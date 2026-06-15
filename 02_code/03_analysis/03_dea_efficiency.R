# =============================================================================
# DEA + Bootstrap Simar-Wilson — Eficiencia técnica del gasto agropecuario
# Especificación fijada en ADR-0016 (.agent/decisions/ADR-0016_dea_simar_wilson_especificacion.md)
# -----------------------------------------------------------------------------
# DMUs : 81 pares departamento-año (9 deptos × 9 años, 2012-2020)
# Dato : 01_data/processed/dea_dataset.rds  (canónico, construido por 11_build_dea_dataset.R)
#
# Frontera principal (ADR-0016 §2,§3,§4):
#   Inputs  (X): agro_strict_bob_mm_2015 (gasto agro estricto, BOB const. 2015)
#                superficie_total_ha     (escala productiva)
#   Outputs (Y): produccion_total_ton    (producción física)
#                rend_cereales_kg_ha      (productividad cereales)
#   RTS = VRS (BCC) ; pooled intertemporal ; AMBAS orientaciones (in y out)
#
# Etapa 1 (SW1998): scores corregidos por sesgo + IC 95% vía bootstrap homogéneo
#                   (Benchmarking::dea.boot, NREP=2000).
# Etapa 2 (SW2007): determinantes de la eficiencia vía regresión truncada
#                   + bootstrap (Algoritmo #1 sobre scores corregidos), NO Tobit.
#
# Robustez: (a) Spearman ranking input vs output; (b) frontera con PIB agrop.
#           (valor agregado) en la submuestra de 36 DMU-años (2017-2020);
#           (c) input rural amplio en vez de estricto.
#
# Output: 01_data/processed/dea_simar_wilson_results.rds
#         01_data/processed/dea_efficiency_scores.rds (compat)
# =============================================================================

source(here::here("02_code", "00_setup", "01_constants.R"))
source(here::here("02_code", "00_setup", "02_functions.R"))
suppressPackageStartupMessages({
  library(data.table)
  library(Benchmarking)   # dea(), dea.boot() — Simar & Wilson (1998)
  library(truncreg)       # regresión truncada — Simar & Wilson (2007)
})

set.seed(20260614)        # reproducibilidad del bootstrap (invariante 7)
NREP   <- 2000            # réplicas bootstrap SW1998 (ADR-0016 §5)
NREP2  <- 2000            # réplicas bootstrap 2ª etapa SW2007 (ADR-0016 §6)
ALPHA  <- 0.05            # IC al 95%

# ── 1. Cargar dataset canónico ───────────────────────────────────────────────
dea_path <- file.path(DIR_DATA_PRO, "dea_dataset.rds")
stopifnot(file.exists(dea_path))
dea <- as.data.table(readRDS(dea_path))
setorder(dea, dept_upper, year)
dea[, dmu := paste(dept_upper, year, sep = "_")]
cat(sprintf("Dataset DEA: %d DMU-años, %d departamentos, años %d-%d\n",
            nrow(dea), uniqueN(dea$dept_upper), min(dea$year), max(dea$year)))

# ── 2. Helpers ───────────────────────────────────────────────────────────────
# Score normalizado a (0,1] (mayor = más eficiente) para cualquier orientación.
# Benchmarking::dea devuelve eff<=1 para "in" y eff>=1 para "out".
to_score01 <- function(eff) ifelse(eff > 1 + 1e-9, 1 / eff, eff)

# N(mu, sigma) truncada a la derecha en `point` (x <= point), vectorizada.
rtnorm_right <- function(n, mu, sigma, point) {
  u_max <- pnorm(point, mean = mu, sd = sigma)
  u     <- runif(n, min = 0, max = u_max)
  qnorm(u, mean = mu, sd = sigma)
}

# Etapa 2 Simar-Wilson (2007), Algoritmo #1 sobre scores corregidos por sesgo.
# eff_bc en (0,1) (corregidos => sin masa en 1) -> truncación derecha en 1.
sw2007_stage2 <- function(eff_bc, Z, L = NREP2, point = 1) {
  ok  <- stats::complete.cases(eff_bc, Z) & eff_bc < point
  dat <- data.frame(eff = eff_bc[ok], Z[ok, , drop = FALSE])
  zn  <- colnames(Z)
  fml <- stats::as.formula(paste("eff ~", paste(zn, collapse = " + ")))
  fit <- truncreg::truncreg(fml, data = dat, point = point, direction = "right")
  cf  <- coef(fit)                       # incluye (Intercept), z..., sigma
  k   <- length(cf) - 1L
  b   <- cf[1:k]; sigma <- cf[k + 1L]
  X   <- model.matrix(fml, dat)
  mu  <- as.vector(X %*% b)
  boot <- matrix(NA_real_, L, k)
  for (l in seq_len(L)) {
    dat$eff_star <- rtnorm_right(nrow(dat), mu, sigma, point)
    f2 <- tryCatch(
      truncreg::truncreg(stats::update(fml, eff_star ~ .), data = dat,
                         point = point, direction = "right"),
      error = function(e) NULL)
    if (!is.null(f2)) boot[l, ] <- coef(f2)[1:k]
  }
  ci <- t(apply(boot, 2L, quantile, probs = c(ALPHA/2, 1 - ALPHA/2), na.rm = TRUE))
  data.table(term = names(b), coef = as.numeric(b),
             ci_lo = ci[, 1], ci_hi = ci[, 2],
             sig95 = (ci[, 1] > 0) | (ci[, 2] < 0),
             n = nrow(dat), L_ok = sum(stats::complete.cases(boot)))
}

# Corre frontera (in + out, VRS) con bootstrap SW1998 y devuelve tabla por DMU.
run_frontier <- function(X, Y, ids, label, nrep = NREP) {
  cat(sprintf("\n── Frontera [%s]: %d DMU, %d inputs, %d outputs ──\n",
              label, nrow(X), ncol(X), ncol(Y)))
  res <- data.table(dmu = ids)
  for (orient in c("in", "out")) {
    pt  <- dea(X, Y, RTS = "vrs", ORIENTATION = orient)
    bt  <- tryCatch(
      dea.boot(X, Y, NREP = nrep, RTS = "vrs", ORIENTATION = orient, alpha = ALPHA),
      error = function(e) { message("  bootstrap [", orient, "] falló: ", e$message); NULL })
    sfx <- if (orient == "in") "in" else "out"
    res[[paste0("eff_", sfx)]]    <- to_score01(eff(pt))
    if (!is.null(bt)) {
      res[[paste0("eff_bc_", sfx)]] <- to_score01(bt$eff.bc)
      ci <- bt$conf.int                      # escala original de la orientación
      lo <- to_score01(ci[, 1]); hi <- to_score01(ci[, 2])
      res[[paste0("ci_lo_", sfx)]] <- pmin(lo, hi)
      res[[paste0("ci_hi_", sfx)]] <- pmax(lo, hi)
    }
  }
  res[]
}

# ── 3. Frontera PRINCIPAL: outputs físicos, 81 DMUs ──────────────────────────
X_main <- as.matrix(dea[, .(agro_strict_bob_mm_2015, superficie_total_ha)])
Y_main <- as.matrix(dea[, .(produccion_total_ton, rend_cereales_kg_ha)])
main   <- run_frontier(X_main, Y_main, dea$dmu, "principal · outputs físicos · 81 DMU")
main[, c("dept_upper", "year") := dea[, .(dept_upper, year)]]

# Robustez (a): correlación de rankings input vs output (ADR-0016 §1)
sp_score <- suppressWarnings(cor(main$eff_in,    main$eff_out,    method = "spearman", use = "complete.obs"))
sp_bc    <- suppressWarnings(cor(main$eff_bc_in, main$eff_bc_out, method = "spearman", use = "complete.obs"))
cat(sprintf("\nSpearman ranking input↔output:  scores=%.3f | corregidos=%.3f\n", sp_score, sp_bc))

# ── 4. Etapa 2 (SW2007): determinantes ambientales de la (in)eficiencia ──────
clim <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "chirps_dept_annual_complete.rds")))
clim[, dept_upper := toupper(dept)]
def  <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "hansen_dept_annual_deforestation.rds")))
def[, dept_upper := toupper(dept)]

z <- merge(main[, .(dept_upper, year, eff_bc_in)],
           clim[, .(dept_upper, year, precip_mm)], by = c("dept_upper", "year"), all.x = TRUE)
z <- merge(z, def[, .(dept_upper, year, defor_ha)], by = c("dept_upper", "year"), all.x = TRUE)
z[, `:=`(precip_k = precip_mm / 1000, defor_k = defor_ha / 1000)]   # reescala numérica

stage2 <- tryCatch(
  sw2007_stage2(z$eff_bc_in, as.matrix(z[, .(precip_k, defor_k)])),
  error = function(e) { message("Etapa 2 SW2007 falló: ", e$message); NULL })
if (!is.null(stage2)) { cat("\n── Etapa 2 Simar-Wilson (2007): eff_bc_in ~ precip + deforestación ──\n"); print(stage2) }

# ── 5. Robustez (b): frontera con PIB agropecuario (valor agregado), N=36 ─────
dea_pib <- dea[!is.na(pib_agrop_bob_2017_mm)]
pib_frontier <- NULL
if (nrow(dea_pib) >= 12) {
  Xp <- as.matrix(dea_pib[, .(agro_strict_bob_mm_2015, superficie_total_ha)])
  Yp <- as.matrix(dea_pib[, .(pib_agrop_bob_2017_mm, produccion_total_ton)])
  pib_frontier <- run_frontier(Xp, Yp, dea_pib$dmu, "robustez · PIB valor agregado · 36 DMU")
  pib_frontier[, c("dept_upper", "year") := dea_pib[, .(dept_upper, year)]]
}

# ── 6. Robustez (c): input rural amplio en vez de estricto ───────────────────
X_rural  <- as.matrix(dea[, .(rural_total_bob_mm_2015, superficie_total_ha)])
rural_frontier <- run_frontier(X_rural, Y_main, dea$dmu, "robustez · gasto rural amplio · 81 DMU")
rural_frontier[, c("dept_upper", "year") := dea[, .(dept_upper, year)]]

# ── 7. Resúmenes departamentales (promedio sobre el panel) ───────────────────
dept_summary <- main[, .(
  eff_in_mean    = mean(eff_in,    na.rm = TRUE),
  eff_in_bc_mean = mean(eff_bc_in, na.rm = TRUE),
  eff_out_mean   = mean(eff_out,   na.rm = TRUE),
  n_frontier_in  = sum(eff_in >= 0.999, na.rm = TRUE)
), by = dept_upper][order(-eff_in_bc_mean)]

cat("\n=== Eficiencia técnica media por departamento (frontera principal, VRS) ===\n")
print(dept_summary)
cat(sprintf("\nResumen scores corregidos (input): media=%.3f  min=%.3f  max=%.3f  | frontera (eff=1): %d/%d DMU\n",
            mean(main$eff_bc_in, na.rm = TRUE), min(main$eff_bc_in, na.rm = TRUE),
            max(main$eff_bc_in, na.rm = TRUE), sum(main$eff_in >= 0.999, na.rm = TRUE), nrow(main)))

# ── 8. Guardar ───────────────────────────────────────────────────────────────
results <- list(
  meta = list(
    adr = "ADR-0016", spec = "VRS pooled intertemporal, ambas orientaciones",
    inputs_main = c("agro_strict_bob_mm_2015", "superficie_total_ha"),
    outputs_main = c("produccion_total_ton", "rend_cereales_kg_ha"),
    n_dmu = nrow(main), nrep = NREP, alpha = ALPHA, seed = 20260614,
    built = as.character(Sys.Date())
  ),
  scores_main    = main,
  dept_summary   = dept_summary,
  spearman       = list(scores = sp_score, bias_corrected = sp_bc),
  stage2_sw2007  = stage2,
  robust_pib     = pib_frontier,
  robust_rural   = rural_frontier
)
saveRDS(results, file.path(DIR_DATA_PRO, "dea_simar_wilson_results.rds"))
saveRDS(main,    file.path(DIR_DATA_PRO, "dea_efficiency_scores.rds"))   # compat
cat("\n✓ Guardado: dea_simar_wilson_results.rds + dea_efficiency_scores.rds\n")
