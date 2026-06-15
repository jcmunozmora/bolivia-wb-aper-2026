# =============================================================================
# Panel FE — Gasto agropecuario → PRODUCTIVIDAD departamental (§5.4)
# -----------------------------------------------------------------------------
# Reemplaza la especificación irrealizable de §5.4 (outcomes TFP/FIES deptal,
# inexistentes) por la que el dato SÍ soporta a nivel depto × año:
#
#   Outcome principal : ln(producción por hectárea)   [productividad de la tierra]
#   Outcomes robustez : ln(PIB agropecuario)          [valor agregado, 2017-2021]
#                       ln(rendimiento de cereales)   [un solo dominio]
#   Insumo fiscal     : ln(gasto agro estricto BOB2015); robustez con gasto rural amplio
#   Covariable        : precipitación CHIRPS (no controlable por el gasto)
#
# Estimación: FE bidireccional (departamento + año) vía factor() en base R,
# errores estándar cluster-robustos por departamento (CR1/HC1) con sandwich.
# NO usa fixest (no instalado / no en renv.lock) → cero dependencias nuevas.
#
# ADVERTENCIA (pocos clusters): solo 9 departamentos ⇒ la inferencia cluster-
# robusta es anticonservadora. Se usa distribución t con G-1=8 g.l.; la
# significancia debe leerse con cautela (wild cluster bootstrap pendiente).
#
# NOTA de especificación: con FE de año (τ_t) los choques comunes con timing
# fijo (post_ley393, COVID) quedan PERFECTAMENTE absorbidos; por eso solo
# aparecen en la variante con FE de depto únicamente (M7).
#
# Identificación ASOCIATIVA, no causal (coherente con §5.4 del reporte).
#
# Input : 01_data/processed/subnacional_productivity_panel.rds (12_build_*)
# Output: 01_data/processed/panel_fe_productivity_results.rds
#         05_outputs/tables/panel_fe_productivity.txt
# =============================================================================

source(here::here("02_code", "00_setup", "01_constants.R"))
suppressPackageStartupMessages({
  library(data.table)
  library(sandwich)   # vcovCL — errores cluster-robustos
})

panel <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "subnacional_productivity_panel.rds")))

# ── Transformaciones log ─────────────────────────────────────────────────────
# Gasto: MEFP municipal ejecutado (LATEST, 2016-2024) como principal; Jubileo
# consolidado (2012-2021) como ventana larga / robustez.
panel[, `:=`(
  ln_yield     = log(prod_per_ha),
  ln_cereal    = log(cereal_yield_kg_ha),
  ln_pib       = log(pib_agrop_bob_2017_mm),
  ln_gasto_mefp = log(gasto_mefp_usd2015_mm),
  ln_gasto_jub  = log(agro_strict_bob_mm_2015),
  ln_rural      = log(rural_total_bob_mm_2015)
)]
panel[, ln_gasto_jub_l1 := shift(ln_gasto_jub, 1, type = "lag"), by = dept_upper]

# ── Estimador FE + errores cluster-robustos por departamento ─────────────────
run_fe <- function(d, yvar, xvars, label, twoway = TRUE) {
  num    <- c(yvar, xvars)
  keep   <- Reduce(`&`, lapply(num, function(v) is.finite(d[[v]])))
  dd     <- d[keep]
  fe     <- if (twoway) "+ factor(dept_upper) + factor(year)" else "+ factor(dept_upper)"
  fml    <- stats::as.formula(sprintf("%s ~ %s %s", yvar, paste(xvars, collapse = " + "), fe))
  fit    <- stats::lm(fml, data = dd)
  cl     <- dd$dept_upper
  V      <- sandwich::vcovCL(fit, cluster = cl, type = "HC1")
  b      <- stats::coef(fit)
  sel    <- names(b)[!is.na(b) & names(b) %in% xvars]
  bb     <- b[sel]; se <- sqrt(diag(V))[sel]
  G      <- uniqueN(cl); dfres <- G - 1L
  tval   <- bb / se
  pval   <- 2 * stats::pt(abs(tval), dfres, lower.tail = FALSE)
  tcrit  <- stats::qt(0.975, dfres)
  data.table(model = label, outcome = yvar, term = sel,
             coef = as.numeric(bb), se = as.numeric(se), t = as.numeric(tval), p = as.numeric(pval),
             ci_lo = as.numeric(bb - tcrit * se), ci_hi = as.numeric(bb + tcrit * se),
             sig = fcase(pval < 0.01, "***", pval < 0.05, "**", pval < 0.1, "*", default = ""),
             n = as.integer(stats::nobs(fit)), n_clusters = G,
             fe = if (twoway) "dept+año" else "dept")
}

# ── Modelos ──────────────────────────────────────────────────────────────────
models <- rbindlist(list(
  run_fe(panel, "ln_yield",  c("ln_gasto_mefp", "precip_k"),            "M1 rend. ~ gasto MEFP + lluvia (PRINCIPAL, 2016-20)"),
  run_fe(panel, "ln_yield",  c("ln_gasto_jub", "precip_k"),            "M2 rend. ~ gasto Jubileo + lluvia (ventana larga 2012-20)"),
  run_fe(panel, "ln_yield",  c("ln_gasto_jub_l1", "precip_k"),         "M3 rend. ~ gasto Jubileo(L1) + lluvia"),
  run_fe(panel, "ln_yield",  c("ln_rural", "precip_k"),                "M4 rend. ~ gasto rural amplio + lluvia"),
  run_fe(panel, "ln_pib",    c("ln_gasto_jub", "precip_k"),            "M5 PIB agrop. ~ gasto + lluvia (2017-21)"),
  run_fe(panel, "ln_cereal", c("ln_gasto_mefp", "precip_k"),           "M6 rend. cereales ~ gasto MEFP + lluvia"),
  run_fe(panel, "ln_yield",  c("ln_gasto_jub", "precip_k", "post_ley393", "covid"),
         "M7 rend. ~ gasto Jubileo + lluvia + Ley393 + COVID (FE dept)", twoway = FALSE)
))

cat("=== Panel FE: gasto agropecuario → productividad departamental ===\n")
cat("Errores cluster-robustos por departamento (9 clusters; leer significancia con cautela)\n\n")
print(models[, .(model, term, coef = round(coef, 3), se = round(se, 3),
                 p = round(p, 3), sig, n, fe)])

# ── Guardar ───────────────────────────────────────────────────────────────────
results <- list(
  meta = list(
    spec       = "FE bidireccional (depto+año), base R lm + sandwich::vcovCL HC1",
    outcomes   = c("ln_yield (prod/ha)", "ln_pib", "ln_cereal"),
    insumo     = "ln_gasto (agro estricto BOB2015); robustez ln_rural",
    covariable = "precip_k (CHIRPS, miles mm)",
    n_clusters = 9, dof_inference = "t(G-1)=t(8)",
    caveat     = "pocos clusters: inferencia anticonservadora; wild cluster bootstrap pendiente",
    built      = as.character(Sys.Date())
  ),
  coef = models
)
saveRDS(results, file.path(DIR_DATA_PRO, "panel_fe_productivity_results.rds"))

if (!dir.exists(DIR_TABLES)) dir.create(DIR_TABLES, recursive = TRUE, showWarnings = FALSE)
writeLines(
  c("Bolivia APER 2026 — Panel FE: gasto agropecuario -> productividad departamental",
    paste("Generado:", as.character(Sys.Date())), "",
    capture.output(print(models))),
  file.path(DIR_TABLES, "panel_fe_productivity.txt")
)
cat("\n✓ Guardado: panel_fe_productivity_results.rds + panel_fe_productivity.txt\n")
