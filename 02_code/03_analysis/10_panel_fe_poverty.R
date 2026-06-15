# =============================================================================
# Panel FE — Gasto agropecuario → POBREZA departamental (§5.4, reemplazo de FIES)
# -----------------------------------------------------------------------------
# Outcome de bienestar con pobreza OFICIAL del INE (incidencia por departamento),
# en vez de FIES (irrealizable: solo 2 años solapaban el gasto).
#
#   Outcome  : incidencia de pobreza moderada / extrema (% poblacional, INE)
#   Insumo   : ln(gasto agro estricto BOB2015)
#   Covar.   : precipitación CHIRPS (no controlable por el gasto)
#   Estimador: FE bidireccional (depto + año) base R lm + sandwich::vcovCL HC1
#
# DOS series por cambio de canasta (NO encadenables; se corren por separado):
#   cba_2016_2024 (vigente, PRINCIPAL) → solapa gasto en 2016-2021 (54 obs)
#   cba_2011_2018 (antigua, robustez)  → solapa gasto en 2012-2018 (63 obs)
#
# Caveat de pocos clusters (9 deptos): inferencia anticonservadora; t(G-1)=t(8).
# Identificación ASOCIATIVA, no causal.
#
# Input : subnacional_productivity_panel.rds (gasto, precip) + ine_pobreza_departamental.rds
# Output: 01_data/processed/panel_fe_poverty_results.rds
#         05_outputs/tables/panel_fe_poverty.txt
# =============================================================================

source(here::here("02_code", "00_setup", "01_constants.R"))
suppressPackageStartupMessages({
  library(data.table)
  library(sandwich)
})

# ── Datos: gasto + precip (panel productividad) y pobreza INE ─────────────────
# Gasto principal: MEFP municipal ejecutado (LATEST, 2016-2024); Jubileo robustez.
prod <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "subnacional_productivity_panel.rds")))
prod <- prod[, .(dept_upper, year, gasto_mefp_usd2015_mm, agro_strict_bob_mm_2015, precip_k)]
prod[, ln_gasto_mefp := log(gasto_mefp_usd2015_mm)]
prod[, ln_gasto_jub  := log(agro_strict_bob_mm_2015)]

pob <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "ine_pobreza_departamental.rds")))
pob_w <- dcast(pob, dept_upper + year + serie ~ indicador, value.var = "value_pct")
setnames(pob_w, c("moderada", "extrema"), c("pobreza_mod", "pobreza_ext"), skip_absent = TRUE)

dat <- merge(pob_w, prod, by = c("dept_upper", "year"))   # inner: solo años con gasto

# ── Estimador FE bidireccional + errores cluster-robustos por departamento ────
run_fe <- function(d, yvar, xvars, label) {
  keep <- Reduce(`&`, lapply(c(yvar, xvars), function(v) is.finite(d[[v]])))
  dd   <- d[keep]
  fml  <- stats::as.formula(sprintf("%s ~ %s + factor(dept_upper) + factor(year)",
                                    yvar, paste(xvars, collapse = " + ")))
  fit  <- stats::lm(fml, data = dd)
  cl   <- dd$dept_upper
  V    <- sandwich::vcovCL(fit, cluster = cl, type = "HC1")
  b    <- stats::coef(fit); sel <- names(b)[!is.na(b) & names(b) %in% xvars]
  bb   <- b[sel]; se <- sqrt(diag(V))[sel]
  G    <- uniqueN(cl); dfres <- G - 1L
  tval <- bb / se; pval <- 2 * stats::pt(abs(tval), dfres, lower.tail = FALSE)
  tcrit <- stats::qt(0.975, dfres)
  data.table(model = label, outcome = yvar, term = sel,
             coef = as.numeric(bb), se = as.numeric(se), p = as.numeric(pval),
             ci_lo = as.numeric(bb - tcrit * se), ci_hi = as.numeric(bb + tcrit * se),
             sig = fcase(pval < 0.01, "***", pval < 0.05, "**", pval < 0.1, "*", default = ""),
             n = as.integer(stats::nobs(fit)), n_clusters = G)
}

vig <- dat[serie == "cba_2016_2024"]   # 2016-2024
ant <- dat[serie == "cba_2011_2018"]   # 2012-2018

models <- rbindlist(list(
  # PRINCIPAL: gasto MEFP (latest) × canasta vigente 2016-2024
  run_fe(vig, "pobreza_mod", "ln_gasto_mefp",                "P1 pobreza mod. ~ gasto MEFP (vigente 16-24)"),
  run_fe(vig, "pobreza_mod", c("ln_gasto_mefp", "precip_k"), "P2 pobreza mod. ~ gasto MEFP + lluvia (PRINCIPAL)"),
  run_fe(vig, "pobreza_ext", c("ln_gasto_mefp", "precip_k"), "P3 pobreza ext. ~ gasto MEFP + lluvia (vigente)"),
  # Robustez fuente de gasto: Jubileo consolidado × canasta vigente (2016-2021)
  run_fe(vig, "pobreza_mod", c("ln_gasto_jub", "precip_k"),  "P4 pobreza mod. ~ gasto Jubileo + lluvia (vigente)"),
  # Robustez metodología pobreza: canasta antigua × gasto Jubileo (2012-2018)
  run_fe(ant, "pobreza_mod", c("ln_gasto_jub", "precip_k"),  "P5 pobreza mod. ~ gasto Jubileo + lluvia (antigua 12-18)"),
  run_fe(ant, "pobreza_ext", c("ln_gasto_jub", "precip_k"),  "P6 pobreza ext. ~ gasto Jubileo + lluvia (antigua)")
))

cat("=== Panel FE: gasto agropecuario → pobreza departamental (INE oficial) ===\n")
cat("Coef = cambio en puntos porcentuales de pobreza por unidad de ln(gasto).\n")
cat("Errores cluster-robustos por depto (9 clusters; significancia con cautela)\n\n")
print(models[, .(model, term, coef = round(coef, 2), se = round(se, 2),
                 p = round(p, 3), sig, n)])

results <- list(
  meta = list(
    fuente     = "INE Encuestas de Hogares — incidencia de pobreza por departamento (oficial)",
    spec       = "FE bidireccional (depto+año), base R lm + sandwich::vcovCL HC1",
    series     = "cba_2016_2024 (principal) / cba_2011_2018 (robustez) — NO encadenadas",
    n_clusters = 9, caveat = "pocos clusters; identificación asociativa",
    built      = as.character(Sys.Date())
  ),
  coef = models,
  panel = dat
)
saveRDS(results, file.path(DIR_DATA_PRO, "panel_fe_poverty_results.rds"))

if (!dir.exists(DIR_TABLES)) dir.create(DIR_TABLES, recursive = TRUE, showWarnings = FALSE)
writeLines(
  c("Bolivia APER 2026 — Panel FE: gasto agropecuario -> pobreza departamental (INE)",
    paste("Generado:", as.character(Sys.Date())), "",
    capture.output(print(models))),
  file.path(DIR_TABLES, "panel_fe_poverty.txt")
)
cat("\n✓ Guardado: panel_fe_poverty_results.rds + panel_fe_poverty.txt\n")
