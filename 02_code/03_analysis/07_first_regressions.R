# Primeras regresiones — Panel v5 nacional + Panel subnacional
# =============================================================================
# Output: tablas de regresión y estadísticos descriptivos
# =============================================================================

library(data.table)
library(fixest)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")

# ═══════════════════════════════════════════════════════════════════════════
# 1. Panel NACIONAL v5 — time-series regressions
# ═══════════════════════════════════════════════════════════════════════════
nat <- readRDS(file.path(proc, "spending_panel_v5.rds"))
setDT(nat)

cat("══════════════════════════════════════════════════════════\n")
cat("  REGRESIONES NACIONALES (time series 1990-2024)\n")
cat("══════════════════════════════════════════════════════════\n\n")

# Limpiar: eliminar años con datos faltantes críticos
nat_clean <- nat[!is.na(tfp_index) & !is.na(inv_agro_usd_mm) &
                  !is.na(lc_antropico_share)]
cat("Años usables (TFP + inversión + LC):", nrow(nat_clean), "\n")
cat("Rango:", paste(range(nat_clean$year), collapse = "-"), "\n\n")

# Variables en logs
nat_clean[, ln_tfp        := log(tfp_index)]
nat_clean[, ln_inv_agro   := log(inv_agro_usd_mm)]
nat_clean[, ln_lc_antrop  := log(lc_antropico/1e6)]  # en millones ha
nat_clean[, ln_lc_natural := log(lc_natural/1e6)]
nat_clean[, time_trend    := year - 1990]

# Modelos
cat("── Modelo 1: TFP ~ Inversión agropecuaria ──\n")
m1 <- feols(ln_tfp ~ ln_inv_agro, data = nat_clean)
print(summary(m1))

cat("\n── Modelo 2: TFP ~ Inversión + Área antrópica ──\n")
m2 <- feols(ln_tfp ~ ln_inv_agro + ln_lc_antrop, data = nat_clean)
print(summary(m2))

cat("\n── Modelo 3: TFP ~ Inversión + LC + tendencia temporal ──\n")
m3 <- feols(ln_tfp ~ ln_inv_agro + ln_lc_antrop + time_trend, data = nat_clean)
print(summary(m3))

# Modelo con PSE (IDB Agrimonitor, 2006-2023)
nat_pse <- nat[!is.na(PSEP_pct) & !is.na(tfp_index) & !is.na(inv_agro_usd_mm)]
if (nrow(nat_pse) >= 10) {
  cat("\n── Modelo 4: TFP ~ Inversión + %PSE + LC (2006-2023) ──\n")
  nat_pse[, ln_tfp      := log(tfp_index)]
  nat_pse[, ln_inv_agro := log(inv_agro_usd_mm)]
  nat_pse[, ln_lc_antrop:= log(lc_antropico/1e6)]
  m4 <- feols(ln_tfp ~ ln_inv_agro + PSEP_pct + ln_lc_antrop, data = nat_pse)
  print(summary(m4))
}

# Tabla etable
cat("\n═════════════════ TABLA CONSOLIDADA ═════════════════\n")
etable(m1, m2, m3, digits = 3, se.below = TRUE,
       title = "Determinantes de TFP Bolivia 1990-2023",
       fitstat = ~r2 + n)

# ═══════════════════════════════════════════════════════════════════════════
# 2. Panel SUBNACIONAL (9 depts × 10 años 2012-2021)
# ═══════════════════════════════════════════════════════════════════════════
cat("\n\n══════════════════════════════════════════════════════════\n")
cat("  REGRESIONES SUBNACIONALES (9 depts × 10 años 2012-2021)\n")
cat("══════════════════════════════════════════════════════════\n\n")

sub <- readRDS(file.path(proc, "subnacional_panel_v2.rds"))
setDT(sub)

# Preparar
sub[, ln_gasto_agrop := log(pmax(1, agro_strict_bob_mm))]
sub[, ln_pib_agrop   := log(pmax(1, pib_agrop_corriente_mm))]

# PIB agrop solo está 2017-2021, así que usamos productividad INE stats como proxy
# Cargar INE agro stats
ine <- readRDS(file.path(proc, "ine_agro_stats_long.rds"))
setDT(ine)
ine[, dept_upper := toupper(dept)]
ine[dept == "La Paz",    dept_upper := "LA PAZ"]
ine[dept == "Santa Cruz", dept_upper := "SANTA CRUZ"]

# Producción total por depto × año
prod_dept <- ine[indicator == "produccion",
                 .(prod_total_ton = sum(value, na.rm = TRUE)),
                 by = .(dept_upper, year)]

sub <- merge(sub, prod_dept, by = c("dept_upper", "year"), all.x = TRUE)
sub[, ln_prod := log(pmax(1, prod_total_ton))]

cat("Obs con producción:", sum(!is.na(sub$prod_total_ton)), "/", nrow(sub), "\n\n")

# Modelo panel: Producción ~ gasto con FE dept y año
sub_reg <- sub[!is.na(ln_gasto_agrop) & !is.na(ln_prod) &
                is.finite(ln_gasto_agrop) & is.finite(ln_prod)]
cat("Filas reg:", nrow(sub_reg), "\n\n")

cat("── Subnacional 1: Producción ~ Gasto (sin FE) ──\n")
ms1 <- feols(ln_prod ~ ln_gasto_agrop, data = sub_reg)
print(summary(ms1))

cat("\n── Subnacional 2: Producción ~ Gasto + FE dept ──\n")
ms2 <- feols(ln_prod ~ ln_gasto_agrop | dept_upper, data = sub_reg)
print(summary(ms2))

cat("\n── Subnacional 3: Producción ~ Gasto + FE dept + año ──\n")
ms3 <- feols(ln_prod ~ ln_gasto_agrop | dept_upper + year, data = sub_reg)
print(summary(ms3))

cat("\n═════════════════ TABLA SUBNACIONAL ═════════════════\n")
etable(ms1, ms2, ms3, digits = 3, se.below = TRUE,
       title = "Producción agrícola departamental ~ gasto (2012-2021)",
       fitstat = ~r2 + n)

# ═══════════════════════════════════════════════════════════════════════════
# 3. Guardar resultados
# ═══════════════════════════════════════════════════════════════════════════
saveRDS(list(m1=m1, m2=m2, m3=m3, ms1=ms1, ms2=ms2, ms3=ms3),
        file.path(proc, "first_regression_results.rds"))
cat("\n✓ Resultados guardados: first_regression_results.rds\n")

# Tabla en archivo
sink(file.path(root, "05_outputs/tables/first_regressions.txt"))
cat("Bolivia Agricultural PER — First Regressions\n")
cat(format(Sys.time(), "%Y-%m-%d %H:%M"), "\n\n")
cat("════════════ NATIONAL (1990-2023) ════════════\n")
etable(m1, m2, m3)
cat("\n\n════════════ SUBNATIONAL (9×10) ════════════\n")
etable(ms1, ms2, ms3)
sink()
cat("✓ Tabla guardada en 05_outputs/tables/first_regressions.txt\n")
