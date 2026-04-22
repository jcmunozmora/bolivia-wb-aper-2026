# Panel maestro nacional v5 — + MapBiomas + CHIRPS
# =============================================================================
# Input: spending_panel_v4.rds (35 años x 83 vars, 1990-2024)
# Añade:
#   - MapBiomas nacional: área antrópica, natural (1990-2024 ~35 años)
#   - CHIRPS nacional: precipitación promedio Bolivia (años disponibles)
#   - Variables derivadas: intensificación vs expansión
#
# Output: spending_panel_v5.rds (35 × ~90 vars)
# =============================================================================

library(data.table)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")

panel <- readRDS(file.path(proc, "spending_panel_v4.rds"))
setDT(panel)

# ─── MapBiomas nacional ──────────────────────────────────────────────────────
mb_nat <- readRDS(file.path(proc, "mapbiomas_national_annual.rds"))
setDT(mb_nat)
mb_wide <- dcast(mb_nat, year ~ level_0, value.var = "area_ha")

setnames(mb_wide,
  old = intersect(c("Natural", "Antropico", "No definido"), names(mb_wide)),
  new = paste0("lc_", tolower(gsub(" ", "_",
    intersect(c("Natural", "Antropico", "No definido"), names(mb_wide))))))

mb_wide[, lc_total_ha := rowSums(.SD, na.rm = TRUE),
        .SDcols = grep("^lc_", names(mb_wide), value = TRUE)]

# Shares
mb_wide[, lc_antropico_share := 100 * lc_antropico / lc_total_ha]
mb_wide[, lc_natural_share   := 100 * lc_natural   / lc_total_ha]

# Variaciones interanuales (proxy deforestación)
setorder(mb_wide, year)
mb_wide[, lc_antropico_delta_ha := c(NA, diff(lc_antropico))]
mb_wide[, lc_natural_delta_ha   := c(NA, diff(lc_natural))]

# ─── CHIRPS nacional (promedio de los 9 depts) ───────────────────────────────
chirps <- readRDS(file.path(proc, "chirps_dept_annual.rds"))
setDT(chirps)
chirps_nat <- chirps[, .(precip_nacional_mm = mean(precip_mm, na.rm = TRUE)),
                     by = year]

# ─── Merge ────────────────────────────────────────────────────────────────────
panel_v5 <- merge(panel, mb_wide, by = "year", all.x = TRUE)
panel_v5 <- merge(panel_v5, chirps_nat, by = "year", all.x = TRUE)

# ─── Variables derivadas — relación gasto/inversión con LC ────────────────────
# Gasto agropecuario por hectárea antrópica (intensificación)
if (all(c("inv_agro_usd_mm", "lc_antropico") %in% names(panel_v5))) {
  panel_v5[, gasto_usd_por_ha_antrop := inv_agro_usd_mm * 1e6 / lc_antropico]
}

# Expansion rate: % cambio anual en área antrópica
panel_v5[, lc_antrop_growth_pct := 100 * lc_antropico_delta_ha /
          shift(lc_antropico, 1, type = "lag")]

cat("=== Panel v5 ===\n")
cat("Filas:", nrow(panel_v5), "| Vars:", ncol(panel_v5), "\n\n")

# Completitud de nuevas variables
cat("Nuevas variables LC:\n")
new_vars <- c("lc_natural", "lc_antropico", "lc_antropico_share",
              "lc_antropico_delta_ha", "lc_antrop_growth_pct",
              "precip_nacional_mm", "gasto_usd_por_ha_antrop")
for (v in new_vars) {
  if (v %in% names(panel_v5)) {
    n <- sum(!is.na(panel_v5[[v]]))
    cat(sprintf("  %-30s %2d/35 obs\n", v, n))
  }
}

# Preview key years
cat("\n=== Serie clave 1990/2000/2010/2020/2023 ===\n")
print(panel_v5[year %in% c(1990, 2000, 2010, 2020, 2023),
  .(year,
    inv_agro_USDmm = round(inv_agro_usd_mm, 0),
    tfp            = round(tfp_index, 1),
    lc_antrop_kha  = round(lc_antropico/1e3, 0),
    antrop_pct     = round(lc_antropico_share, 1),
    precip_mm      = round(precip_nacional_mm, 0),
    PSEP_pct       = round(PSEP_pct, 1))])

# Save
saveRDS(panel_v5, file.path(proc, "spending_panel_v5.rds"))
fwrite(panel_v5, file.path(proc, "spending_panel_v5.csv"))
cat("\n✓ spending_panel_v5.rds guardado (", nrow(panel_v5), "×", ncol(panel_v5), ")\n")
