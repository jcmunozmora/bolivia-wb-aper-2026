# Regressions extendidas + Eficiencia técnica proxy
# =============================================================================
# EJECUTAR:
#   cd "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
#   RENV_CONFIG_AUTOLOADER_ENABLED=FALSE R_PROFILE_USER=/dev/null \
#   /Users/jcmunoz/miniforge3/envs/ds/bin/Rscript \
#       02_code/03_analysis/08_extended_regressions.R 2>&1 | tee /tmp/reg_log.txt
#
# Secciones:
#   1. NACIONAL — TFP ~ gasto + LC + PSE + deforestación (M1-M6)
#   2. SUBNACIONAL — ln_PIB_agrop ~ gasto + FE (MS1-MS5) + producción INE
#   3. EFICIENCIA PROXY — ratio PIB/gasto normalizado por frontera anual
#
# Output: 05_outputs/tables/ + 01_data/processed/extended_regression_results.rds
# =============================================================================

library(data.table)
library(fixest)

root   <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc   <- file.path(root, "01_data/processed")
tbl    <- file.path(root, "05_outputs/tables")
dir.create(tbl, recursive = TRUE, showWarnings = FALSE)

sep <- function(titulo) {
  cat("\n", strrep("═", 60), "\n", titulo, "\n", strrep("═", 60), "\n\n", sep = "")
}

# ══════════════════════════════════════════════════════════
# 1. PANEL NACIONAL — TFP (1990-2023, hasta 34 obs)
# ══════════════════════════════════════════════════════════
sep("SECCIÓN 1: REGRESIONES NACIONALES — TFP")

nat <- readRDS(file.path(proc, "spending_panel_v5.rds"))
setDT(nat)

# Integrar Hansen nacional si ya existe panel_v6, si no calculamos aquí
if (file.exists(file.path(proc, "spending_panel_v6.rds"))) {
  nat <- readRDS(file.path(proc, "spending_panel_v6.rds"))
  setDT(nat)
  cat("Usando panel_v6 (con Hansen integrado)\n")
} else {
  # Calcular deforestación nacional sumando depts
  hd <- readRDS(file.path(proc, "hansen_dept_annual_deforestation.rds"))
  setDT(hd)
  hnat <- hd[, .(defor_nacional_ha = sum(defor_ha, na.rm = TRUE)), by = year]
  nat <- merge(nat, hnat, by = "year", all.x = TRUE)
  cat("Hansen integrado directamente desde dept_annual\n")
}

# Variables log
nat[, ln_tfp        := log(tfp_index)]
nat[, ln_inv_agro   := log(inv_agro_usd_mm)]
nat[, ln_lc_antrop  := log(lc_antropico / 1e6)]
nat[, time_trend    := year - 1990]
nat[, ln_inv_L1     := shift(ln_inv_agro, 1, type = "lag")]
nat[, ln_inv_L2     := shift(ln_inv_agro, 2, type = "lag")]
nat[defor_nacional_ha > 0,
    ln_defor := log(defor_nacional_ha)]

# Muestra completa
n_full   <- nat[!is.na(ln_tfp) & !is.na(ln_inv_agro) & !is.na(ln_lc_antrop)]
n_pse    <- nat[!is.na(ln_tfp) & !is.na(ln_inv_agro) & !is.na(PSEP_pct)]
n_hansen <- nat[!is.na(ln_tfp) & !is.na(ln_inv_agro) & !is.na(ln_defor)]

cat(sprintf("Obs completas (TFP+inv+LC): %d\n", nrow(n_full)))
cat(sprintf("Obs con PSE: %d\n", nrow(n_pse)))
cat(sprintf("Obs con Hansen: %d\n", nrow(n_hansen)))

# ── Modelos nacionales ──────────────────────────────────────────────────────
cat("\n── M1: TFP ~ Inversión (baseline) ──\n")
m1 <- feols(ln_tfp ~ ln_inv_agro, data = n_full)
print(summary(m1))

cat("\n── M2: TFP ~ Inversión + LC antrópica + tendencia ──\n")
m2 <- feols(ln_tfp ~ ln_inv_agro + ln_lc_antrop + time_trend, data = n_full)
print(summary(m2))

cat("\n── M3: TFP ~ Inversión + LC + tendencia + %PSE ──\n")
m3 <- feols(ln_tfp ~ ln_inv_agro + ln_lc_antrop + time_trend + PSEP_pct,
            data = n_pse)
print(summary(m3))

cat("\n── M4: TFP ~ Inversión rezagada L1 + LC + tendencia ──\n")
m4_data <- n_full[!is.na(ln_inv_L1)]
m4 <- feols(ln_tfp ~ ln_inv_L1 + ln_lc_antrop + time_trend, data = m4_data)
print(summary(m4))

cat("\n── M5: TFP ~ Inversión rezagada L2 + LC + tendencia ──\n")
m5_data <- n_full[!is.na(ln_inv_L2)]
m5 <- feols(ln_tfp ~ ln_inv_L2 + ln_lc_antrop + time_trend, data = m5_data)
print(summary(m5))

if (nrow(n_hansen) >= 10) {
  cat("\n── M6: TFP ~ Inversión + LC + Deforestación + tendencia ──\n")
  m6 <- feols(ln_tfp ~ ln_inv_agro + ln_lc_antrop + ln_defor + time_trend,
              data = n_hansen)
  print(summary(m6))
} else {
  cat("\n[M6 omitido: insuficientes obs con Hansen]\n")
  m6 <- NULL
}

# Tabla nacional
sep("TABLA NACIONAL CONSOLIDADA")
mods_nat <- Filter(Negate(is.null), list(m1, m2, m3, m4, m5, m6))
etable(mods_nat[[1]], mods_nat[[2]], mods_nat[[3]],
       digits = 3, se.below = TRUE,
       fitstat = ~r2 + n,
       title  = "TFP Bolivia — determinantes del crecimiento de productividad")

# ══════════════════════════════════════════════════════════
# 2. PANEL SUBNACIONAL (9 depts)
# ══════════════════════════════════════════════════════════
sep("SECCIÓN 2: REGRESIONES SUBNACIONALES")

sub <- readRDS(file.path(proc, "subnacional_panel_v2.rds"))
setDT(sub)

# Integrar Hansen departamental
hd <- readRDS(file.path(proc, "hansen_dept_annual_deforestation.rds"))
setDT(hd)
hd[, dept_upper := toupper(dept)]
sub <- merge(sub, hd[, .(dept_upper, year,
                          defor_ha_year      = defor_ha,
                          forest_2000_ha     = forest_area_2000_ha,
                          defor_pct_2000     = defor_pct_2000)],
             by = c("dept_upper", "year"), all.x = TRUE)

# Integrar MapBiomas departamental
mb_d <- readRDS(file.path(proc, "mapbiomas_dept_annual.rds"))
setDT(mb_d)
mb_d[, dept_upper := toupper(dept)]
mb_d[dept_upper == "POTOSI", dept_upper := "POTOSÍ"]
sub <- merge(sub, mb_d[, .(dept_upper, year,
                            antrop_ha  = area_ha_antropico,
                            natural_ha = area_ha_natural)],
             by = c("dept_upper", "year"), all.x = TRUE)

# Variables
sub[agro_strict_bob_mm > 0, ln_gasto := log(agro_strict_bob_mm)]
sub[pib_agrop_bob_2017_mm > 0, ln_pib  := log(pib_agrop_bob_2017_mm)]
sub[defor_ha_year > 0, ln_defor := log(defor_ha_year)]
sub[antrop_ha > 0,     ln_antrop := log(antrop_ha)]
sub[, gasto_L1 := shift(ln_gasto, 1, type = "lag"), by = dept_upper]

cat("Obs con PIB agrop:", sum(!is.na(sub$ln_pib)), "(2017-2021)\n")
cat("Obs con gasto:    ", sum(!is.na(sub$ln_gasto)), "(2012-2021)\n")
cat("Obs con Hansen:   ", sum(!is.na(sub$ln_defor)), "\n")
cat("Obs con MapBiomas:", sum(!is.na(sub$ln_antrop)), "\n")

# ── 2a. Outcome: PIB agropecuario departamental (2017-2021) ─────────────────
cat("\n─── 2a. Outcome: ln(PIB agropecuario) ───\n")
sub_pib <- sub[!is.na(ln_pib) & !is.na(ln_gasto)]
cat(sprintf("N = %d (%d depts × ~5 años)\n\n", nrow(sub_pib), length(unique(sub_pib$dept_upper))))

cat("── MS1: PIB ~ Gasto (OLS, sin FE) ──\n")
ms1 <- feols(ln_pib ~ ln_gasto, data = sub_pib)
print(summary(ms1))

cat("\n── MS2: PIB ~ Gasto + FE dept ──\n")
ms2 <- feols(ln_pib ~ ln_gasto | dept_upper, data = sub_pib)
print(summary(ms2))

cat("\n── MS3: PIB ~ Gasto + FE dept + año ──\n")
ms3 <- feols(ln_pib ~ ln_gasto | dept_upper + year, data = sub_pib)
print(summary(ms3))

# MS4: + deforestación (Hansen)
sub_pib_h <- sub_pib[!is.na(ln_defor)]
if (nrow(sub_pib_h) >= 10) {
  cat("\n── MS4: PIB ~ Gasto + Deforestación + FE dept + año ──\n")
  ms4 <- feols(ln_pib ~ ln_gasto + ln_defor | dept_upper + year, data = sub_pib_h)
  print(summary(ms4))
} else {
  ms4 <- NULL; cat("\n[MS4 omitido: pocas obs con Hansen subnacional]\n")
}

# MS5: + LC antrópica (MapBiomas)
sub_pib_lc <- sub_pib[!is.na(ln_antrop)]
if (nrow(sub_pib_lc) >= 10) {
  cat("\n── MS5: PIB ~ Gasto + LC antrópica + FE dept + año ──\n")
  ms5 <- feols(ln_pib ~ ln_gasto + ln_antrop | dept_upper + year, data = sub_pib_lc)
  print(summary(ms5))
} else {
  ms5 <- NULL; cat("\n[MS5 omitido]\n")
}

# Tabla PIB
sep("TABLA SUBNACIONAL — PIB AGROPECUARIO")
mods_pib <- Filter(Negate(is.null), list(ms1, ms2, ms3, ms4, ms5))
do.call(etable, c(mods_pib, list(digits = 3, se.below = TRUE,
                                  fitstat = ~r2 + n,
                                  title = "PIB agropecuario deptl. ~ gasto 2017-2021")))

# ── 2b. Outcome: Producción agrícola INE (2012-2021 — más obs) ──────────────
cat("\n─── 2b. Outcome: ln(producción agrícola INE) — 2012-2021 ───\n")
ine <- readRDS(file.path(proc, "ine_agro_stats_long.rds"))
setDT(ine)
ine[, dept_upper := toupper(dept)]
ine[dept == "La Paz", dept_upper := "LA PAZ"]
ine[dept == "Santa Cruz", dept_upper := "SANTA CRUZ"]
prod <- ine[indicator == "produccion",
            .(prod_ton = sum(value, na.rm = TRUE)),
            by = .(dept_upper, year)]
sub_prod <- merge(sub, prod, by = c("dept_upper", "year"), all.x = TRUE)
sub_prod <- sub_prod[!is.na(ln_gasto) & prod_ton > 0]
sub_prod[, ln_prod := log(prod_ton)]

cat(sprintf("N = %d (%d depts × ~10 años)\n\n", nrow(sub_prod), length(unique(sub_prod$dept_upper))))

cat("── MP1: Producción ~ Gasto (OLS) ──\n")
mp1 <- feols(ln_prod ~ ln_gasto, data = sub_prod)
print(summary(mp1))

cat("\n── MP2: Producción ~ Gasto + FE dept ──\n")
mp2 <- feols(ln_prod ~ ln_gasto | dept_upper, data = sub_prod)
print(summary(mp2))

cat("\n── MP3: Producción ~ Gasto + FE dept + año ──\n")
mp3 <- feols(ln_prod ~ ln_gasto | dept_upper + year, data = sub_prod)
print(summary(mp3))

# Con rezago L1
sub_prod2 <- sub_prod[!is.na(gasto_L1)]
if (nrow(sub_prod2) >= 30) {
  cat("\n── MP4: Producción ~ Gasto(L1) + FE dept + año ──\n")
  mp4 <- feols(ln_prod ~ gasto_L1 | dept_upper + year, data = sub_prod2)
  print(summary(mp4))
} else { mp4 <- NULL }

sep("TABLA SUBNACIONAL — PRODUCCIÓN INE")
mods_prod <- Filter(Negate(is.null), list(mp1, mp2, mp3, mp4))
do.call(etable, c(mods_prod, list(digits = 3, se.below = TRUE,
                                   fitstat = ~r2 + n,
                                   title = "Producción agrícola deptl. ~ gasto 2012-2021")))

# ══════════════════════════════════════════════════════════
# 3. EFICIENCIA TÉCNICA PROXY (sin paquetes DEA)
# ══════════════════════════════════════════════════════════
sep("SECCIÓN 3: EFICIENCIA TÉCNICA — RATIO NORMALIZADO")

cat("Metodología: Ratio PIB_agrop / Gasto_agrop normalizado por máximo anual\n")
cat("(Proxy de eficiencia técnica — DMU más eficiente en cada año = score 1.0)\n\n")

eff <- sub[!is.na(ln_pib) & !is.na(ln_gasto)][
  , .(dept_upper, year,
      pib  = exp(ln_pib),
      gasto = exp(ln_gasto))]
eff[, ratio := pib / gasto]
# Normalizar por máximo anual (frontera annual)
eff[, eff_score := ratio / max(ratio, na.rm = TRUE), by = year]
# Promedio de eficiencia por depto (2017-2021)
eff_avg <- eff[, .(
  eff_mean     = mean(eff_score,   na.rm = TRUE),
  eff_sd       = sd(eff_score,     na.rm = TRUE),
  ratio_mean   = mean(ratio,       na.rm = TRUE),
  pib_mean_mm  = mean(pib,         na.rm = TRUE),
  gasto_mean_mm= mean(gasto,       na.rm = TRUE)
), by = dept_upper][order(-eff_mean)]

cat("── Scores de eficiencia departamental (promedio 2017-2021) ──\n")
cat("   (1.0 = depto más eficiente ese año; interpretación relativa)\n\n")
print(eff_avg[, .(
  dept       = dept_upper,
  eff_score  = round(eff_mean, 3),
  sd         = round(eff_sd, 3),
  PIB_agrop  = round(pib_mean_mm, 0),
  gasto_mm   = round(gasto_mean_mm, 1),
  ratio_PIB_gasto = round(ratio_mean, 0)
)])

# ── Serie temporal eficiencia ────────────────────────────────────────────────
cat("\n── Evolución de eficiencia por año ──\n")
eff_yr <- eff[, .(eff_nacional = mean(eff_score, na.rm = TRUE),
                  best_dept    = dept_upper[which.max(eff_score)],
                  worst_dept   = dept_upper[which.min(eff_score)]),
              by = year][order(year)]
print(eff_yr)

# ── Segunda etapa: ¿qué explica la eficiencia? ───────────────────────────────
cat("\n── Segunda etapa: score ~ deforestación + LC ──\n")
eff2 <- merge(eff, sub[, .(dept_upper, year, ln_defor, ln_antrop, deuda_rural_mm_bob)],
              by = c("dept_upper", "year"), all.x = TRUE)
se1 <- feols(eff_score ~ ln_defor, data = eff2[!is.na(ln_defor)])
se2 <- feols(eff_score ~ ln_antrop, data = eff2[!is.na(ln_antrop)])
se3 <- feols(eff_score ~ ln_defor + ln_antrop, data = eff2[!is.na(ln_defor) & !is.na(ln_antrop)])

cat("\n[score ~ deforestación]:\n"); print(summary(se1))
cat("\n[score ~ LC antrópica]:\n"); print(summary(se2))
if (nrow(eff2[!is.na(ln_defor) & !is.na(ln_antrop)]) >= 5)
  { cat("\n[score ~ defor + LC]:\n"); print(summary(se3)) }

# ══════════════════════════════════════════════════════════
# 4. GUARDAR
# ══════════════════════════════════════════════════════════
sep("GUARDANDO RESULTADOS")

results <- list(
  # Nacional TFP
  m1=m1, m2=m2, m3=m3, m4=m4, m5=m5, m6=m6,
  # Subnacional PIB
  ms1=ms1, ms2=ms2, ms3=ms3, ms4=ms4, ms5=ms5,
  # Subnacional producción INE
  mp1=mp1, mp2=mp2, mp3=mp3, mp4=mp4,
  # Eficiencia
  eff_avg=eff_avg, eff_panel=eff
)
saveRDS(results, file.path(proc, "extended_regression_results.rds"))
cat("✓ extended_regression_results.rds guardado\n")

# Tablas a archivo
sink(file.path(tbl, "extended_regressions.txt"))
cat("Bolivia Agricultural PER — Extended Regressions\n")
cat(format(Sys.time(), "%Y-%m-%d %H:%M"), "\n\n")

cat("═══ NACIONAL: TFP (baseline + controles) ═══\n")
etable(m1, m2, m3, digits = 3, se.below = TRUE, fitstat = ~r2 + n)
if (!is.null(m6)) {
  cat("\n═══ NACIONAL: TFP con rezagos ═══\n")
  etable(m4, m5, m6, digits = 3, se.below = TRUE, fitstat = ~r2 + n)
}
cat("\n═══ SUBNACIONAL: PIB agropecuario ═══\n")
do.call(etable, c(Filter(Negate(is.null), list(ms1, ms2, ms3, ms4, ms5)),
                  list(digits = 3, se.below = TRUE, fitstat = ~r2 + n)))
cat("\n═══ SUBNACIONAL: Producción INE ═══\n")
do.call(etable, c(Filter(Negate(is.null), list(mp1, mp2, mp3, mp4)),
                  list(digits = 3, se.below = TRUE, fitstat = ~r2 + n)))
cat("\n═══ EFICIENCIA TÉCNICA (2017-2021) ═══\n")
print(eff_avg)
sink()

cat("✓ Tabla guardada: 05_outputs/tables/extended_regressions.txt\n")
cat("\n✓ ANÁLISIS COMPLETADO\n")
