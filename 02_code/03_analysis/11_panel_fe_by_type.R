# =============================================================================
# Panel FE — Gasto agropecuario POR TIPO → productividad y pobreza (§5.4)
# -----------------------------------------------------------------------------
# Prueba directa de la tesis "la composición importa más que el nivel":
# descompone el gasto agro municipal MEFP en 4 tipos (clasificación MAFAP/grupo)
# y estima si el TIPO de gasto —no solo el nivel— se asocia con los resultados.
#
#   Tipos: tecnicos (I+D, extensión, sanidad = bienes públicos), apoyo (directo
#          a la producción), riego (e infraestructura), tierras (multiprograma/otros).
#   Outcomes: ln(producción/ha) 2016-2020; pobreza moderada/extrema 2016-2024 (INE vigente).
#   Estimador: FE bidireccional (depto+año) base R lm + sandwich::vcovCL HC1, cluster depto.
#
# CAVEATS (fuertes): 9 clusters (inferencia anticonservadora); 4 tipos co-mueven
# (multicolinealidad) → los coeficientes por tipo son frágiles; identificación
# asociativa, no causal; ventana corta (productividad 2016-2020 = 45 obs).
#
# Input : gasto_agro_prog_muni_grupo.rds (51) + subnacional_productivity_panel.rds
#         + ine_pobreza_departamental.rds
# Output: 01_data/processed/panel_fe_by_type_results.rds
#         05_outputs/tables/panel_fe_by_type.txt
# =============================================================================

source(here::here("02_code", "00_setup", "01_constants.R"))
suppressPackageStartupMessages({ library(data.table); library(sandwich) })

# ── 1. Gasto por tipo: muni → dept × año × grupo (USD2015 mm) ─────────────────
g <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "gasto_agro_prog_muni_grupo.rds")))
g[, dept_upper := toupper(dept_name)]
g <- g[!is.na(dept_upper) & dept_upper %in% toupper(DEPTS)]
gd <- g[, .(usd2015_mm = sum(usd2015, na.rm = TRUE) / 1e6), by = .(dept_upper, year, grupo)]

key <- c("Apoyo a la producción y seguridad alimentaria" = "apoyo",
         "Riego e infraestructura"                       = "riego",
         "Servicios técnicos (I+D, extensión, sanidad)"  = "tecnicos",
         "Tierras, multiprograma y otros"                = "tierras")
gd[, tipo := key[grupo]]
w <- dcast(gd, dept_upper + year ~ tipo, value.var = "usd2015_mm", fill = 0)
w[, gasto_total := apoyo + riego + tecnicos + tierras]
for (k in c("apoyo", "riego", "tecnicos", "tierras"))
  w[, paste0("sh_", k) := get(k) / gasto_total]

# ── 2. Outcomes: productividad (+precip) y pobreza INE vigente ────────────────
prod <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "subnacional_productivity_panel.rds")))
prod <- prod[, .(dept_upper, year, prod_per_ha, precip_k)]
pob  <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "ine_pobreza_departamental.rds")))
pobv <- dcast(pob[serie == "cba_2016_2024"], dept_upper + year ~ indicador, value.var = "value_pct")
setnames(pobv, c("moderada", "extrema"), c("pobreza_mod", "pobreza_ext"), skip_absent = TRUE)

d <- Reduce(function(a, b) merge(a, b, by = c("dept_upper", "year"), all.x = TRUE),
            list(w, prod, pobv))
d[, `:=`(ln_yield = log(prod_per_ha), ln_total = log(gasto_total),
         ln_tecnicos = log(tecnicos), ln_apoyo = log(apoyo), ln_riego = log(riego))]

# ── 3. Estimador FE bidireccional + cluster-robusto por depto ────────────────
run_fe <- function(dat, yvar, xvars, label) {
  keep <- Reduce(`&`, lapply(c(yvar, xvars), function(v) is.finite(dat[[v]])))
  dd <- dat[keep]
  fit <- stats::lm(stats::as.formula(sprintf("%s ~ %s + factor(dept_upper) + factor(year)",
                                             yvar, paste(xvars, collapse = " + "))), data = dd)
  cl <- dd$dept_upper; V <- sandwich::vcovCL(fit, cluster = cl, type = "HC1")
  b <- stats::coef(fit); sel <- names(b)[!is.na(b) & names(b) %in% xvars]
  bb <- b[sel]; se <- sqrt(diag(V))[sel]; G <- uniqueN(cl); dfres <- G - 1L
  tv <- bb/se; pv <- 2*stats::pt(abs(tv), dfres, lower.tail = FALSE)
  data.table(model = label, term = sel, coef = as.numeric(bb), se = as.numeric(se), p = as.numeric(pv),
             sig = fcase(pv<0.01,"***", pv<0.05,"**", pv<0.1,"*", default=""),
             n = as.integer(stats::nobs(fit)), n_clusters = G)
}

models <- rbindlist(list(
  # Composición: ¿importa la PARTICIPACIÓN de bienes públicos (I+D), dado el total?
  run_fe(d, "ln_yield",    c("sh_tecnicos", "ln_total", "precip_k"), "BT1 prod/ha ~ %I+D + total + lluvia"),
  run_fe(d, "pobreza_mod", c("sh_tecnicos", "ln_total", "precip_k"), "BT2 pobreza mod ~ %I+D + total + lluvia"),
  run_fe(d, "pobreza_ext", c("sh_tecnicos", "ln_total", "precip_k"), "BT3 pobreza ext ~ %I+D + total + lluvia"),
  # Niveles por tipo (cada tipo por separado)
  run_fe(d, "pobreza_mod", c("ln_tecnicos", "precip_k"),             "BT4 pobreza mod ~ gasto I+D"),
  run_fe(d, "pobreza_mod", c("ln_apoyo", "precip_k"),                "BT5 pobreza mod ~ gasto apoyo directo"),
  run_fe(d, "pobreza_mod", c("ln_riego", "precip_k"),                "BT6 pobreza mod ~ gasto riego/infra"),
  run_fe(d, "ln_yield",    c("ln_tecnicos", "precip_k"),             "BT7 prod/ha ~ gasto I+D"),
  run_fe(d, "ln_yield",    c("ln_apoyo", "precip_k"),                "BT8 prod/ha ~ gasto apoyo directo")
))

cat("=== Panel FE por TIPO de gasto: composición → productividad y pobreza ===\n")
cat("sh_* = participación del tipo (0-1); ln_* = nivel (log USD2015). 9 clusters → cautela.\n\n")
print(models[, .(model, term, coef = round(coef, 3), p = round(p, 3), sig, n)])

results <- list(
  meta = list(fuente = "MEFP muni programático por grupo MAFAP (2016-2024)",
              spec = "FE depto+año, base R lm + sandwich HC1, cluster depto",
              caveat = "9 clusters; 4 tipos co-mueven (multicolinealidad); asociativo; ventana corta",
              built = as.character(Sys.Date())),
  coef = models, panel = d)
saveRDS(results, file.path(DIR_DATA_PRO, "panel_fe_by_type_results.rds"))
if (!dir.exists(DIR_TABLES)) dir.create(DIR_TABLES, recursive = TRUE, showWarnings = FALSE)
writeLines(c("APER 2026 — Panel FE por tipo de gasto", as.character(Sys.Date()), "",
             capture.output(print(models))), file.path(DIR_TABLES, "panel_fe_by_type.txt"))
cat("\n✓ Guardado: panel_fe_by_type_results.rds + panel_fe_by_type.txt\n")
