# Enriquecimiento interno: precipitación completa + yields cereales
# =============================================================================
# Fuentes internas (ya procesadas, sin APIs externas):
#   A) CHIRPS TIF existentes (6 años) → interpolación lineal dept × año
#   B) INE Agro Stats 1984-2020 → yield cereales nacional y departamental
#
# Output:
#   - chirps_dept_annual_complete.rds  (9 depts × 1990-2023, interpolado)
#   - chirps_nacional_annual.rds
#   - cereal_yield_nacional.rds        (1984-2020)
# =============================================================================

library(data.table)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")

# ══════════════════════════════════════════════════════════
# A. CHIRPS: interpolación lineal entre 6 snapshots
# ══════════════════════════════════════════════════════════
cat("=== A. CHIRPS: interpolación lineal 1990-2023 ===\n")

chirps_snap <- readRDS(file.path(proc, "chirps_dept_annual.rds"))
setDT(chirps_snap)
cat("Snapshots disponibles:", paste(sort(unique(chirps_snap$year)), collapse=", "), "\n")
# Armonizar nombre de columna dept
if ("dept_name" %in% names(chirps_snap) && !"dept" %in% names(chirps_snap))
  setnames(chirps_snap, "dept_name", "dept")

cat("Depts:", paste(sort(unique(chirps_snap$dept)), collapse=", "), "\n\n")

# Interpolación por departamento: approx() con rule=2 (extrapola en extremos)
ALL_YEARS <- 1990:2023

interp_list <- lapply(unique(chirps_snap$dept), function(d) {
  sub <- chirps_snap[dept == d][order(year)]
  app <- approx(x = sub$year, y = sub$precip_mm,
                xout = ALL_YEARS, method = "linear", rule = 2)
  data.table(dept  = d,
             year  = app$x,
             precip_mm = round(app$y, 1),
             source = ifelse(app$x %in% sub$year, "CHIRPS_TIF", "interpolado"))
})
chirps_complete <- rbindlist(interp_list)
setorder(chirps_complete, dept, year)

cat("CHIRPS completo:\n")
cat(sprintf("  Filas: %d | Años: %s-%s | Depts: %d\n",
            nrow(chirps_complete),
            min(chirps_complete$year), max(chirps_complete$year),
            length(unique(chirps_complete$dept))))
cat("  Obs originales (TIF):", sum(chirps_complete$source == "CHIRPS_TIF"), "\n")
cat("  Obs interpoladas:", sum(chirps_complete$source == "interpolado"), "\n\n")

# Preview
cat("Muestra (Beni, 1990-2000):\n")
print(chirps_complete[dept == "Beni" & year %in% 1990:2000,
                      .(dept, year, precip_mm, source)])

# Promedio nacional anual
chirps_nat <- chirps_complete[, .(
  precip_nacional_mm = round(mean(precip_mm, na.rm = TRUE), 1),
  n_depts = .N
), by = year][order(year)]

cat("\nPrecipitación nacional 1990-2023 (mm/año):\n")
print(chirps_nat[year %in% c(1990,1995,2000,2005,2010,2015,2020,2023)])

saveRDS(chirps_complete, file.path(proc, "chirps_dept_annual_complete.rds"))
saveRDS(chirps_nat,      file.path(proc, "chirps_nacional_annual.rds"))
fwrite(chirps_complete,  file.path(proc, "chirps_dept_annual_complete.csv"))
cat("\n✓ chirps_dept_annual_complete.rds\n")
cat("✓ chirps_nacional_annual.rds\n")

# ══════════════════════════════════════════════════════════
# B. Yields de cereales — desde INE Agro Stats 1984-2020
# ══════════════════════════════════════════════════════════
cat("\n=== B. Yields de cereales (INE Agro Stats) ===\n")

ine <- readRDS(file.path(proc, "ine_agro_stats_long.rds"))
setDT(ine)
cat("INE agro stats:", nrow(ine), "filas\n")
cat("Indicadores:", paste(unique(ine$indicator), collapse=", "), "\n")

# Cultivos cereales clave para Bolivia
CEREALS <- c("Maíz en grano", "Trigo", "Arroz en cáscara", "Cebada en grano",
             "Sorgo en grano", "Avena", "Quinua", "Triticale",
             # variantes de nombre
             "Maiz en grano", "Maíz", "Maiz",
             "Arroz", "Cebada", "Sorgo")

# Filtrar rendimiento de cereales (todas las variantes)
cereal_yield <- ine[indicator == "rendimiento" &
                    (cultivo %in% CEREALS | grepl("maíz|maiz|trigo|arroz|cebada|sorgo|quinua|avena",
                                                cultivo, ignore.case = TRUE))]
cat("\nCultivos cereales encontrados:", length(unique(cereal_yield$cultivo)), "\n")
cat(paste(" -", unique(cereal_yield$cultivo)), sep="\n")

# Yield nacional: promedio ponderado por superficie (si disponible)
# Si no, promedio simple
sup <- ine[indicator == "superficie" &
           (cultivo %in% CEREALS | grepl("maíz|maiz|trigo|arroz|cebada|sorgo|quinua|avena",
                                       cultivo, ignore.case = TRUE))]

# Merge sup × yield por dept × year × cultivo
cereal_dept_yr <- merge(
  cereal_yield[dept != "Bolivia", .(dept, year, cultivo, yield_kg_ha = value)],
  sup[dept != "Bolivia", .(dept, year, cultivo, sup_ha = value)],
  by = c("dept", "year", "cultivo"), all.x = TRUE
)

# Yield nacional ponderado por superficie
cereal_nat <- cereal_dept_yr[!is.na(yield_kg_ha) & yield_kg_ha > 0,
  .(cereal_yield_kg_ha = weighted.mean(yield_kg_ha,
                                        w = pmax(1, sup_ha, na.rm=TRUE),
                                        na.rm = TRUE),
    n_cultivos = length(unique(cultivo)),
    sup_total_ha = sum(sup_ha, na.rm = TRUE)),
  by = year][order(year)]

cat("\nYield nacional cereales 1984-2020 (kg/ha, promedio ponderado):\n")
print(cereal_nat[year %in% c(1990,1995,2000,2005,2010,2015,2020)])

# Yield por departamento
cereal_dept <- cereal_dept_yr[!is.na(yield_kg_ha) & yield_kg_ha > 0,
  .(cereal_yield_kg_ha = weighted.mean(yield_kg_ha,
                                        w = pmax(1, sup_ha, na.rm=TRUE),
                                        na.rm = TRUE)),
  by = .(dept, year)][order(dept, year)]

cat("\nCobertura dept × año:", nrow(cereal_dept), "observaciones\n")

# ── Producción total cereales Bolivia (para comparadores LAC) ────────────────
cereal_prod_nat <- ine[indicator == "produccion" &
                       dept == "Bolivia" &
                       (grepl("maíz|maiz|trigo|arroz|cebada|sorgo|quinua|avena",
                               cultivo, ignore.case = TRUE)),
  .(cereal_prod_ton = sum(value, na.rm = TRUE)), by = year][order(year)]

cat("\nProducción cereales Bolivia 1984-2020 (ton/año):\n")
print(cereal_prod_nat[year %in% c(1990, 2000, 2010, 2020)])

# ── Guardar ──────────────────────────────────────────────────────────────────
saveRDS(cereal_nat,      file.path(proc, "cereal_yield_nacional.rds"))
saveRDS(cereal_dept,     file.path(proc, "cereal_yield_dept.rds"))
saveRDS(cereal_prod_nat, file.path(proc, "cereal_prod_nacional.rds"))
fwrite(cereal_nat,       file.path(proc, "cereal_yield_nacional.csv"))

cat("\n✓ cereal_yield_nacional.rds (", nrow(cereal_nat), "años)\n")
cat("✓ cereal_yield_dept.rds (", nrow(cereal_dept), "filas)\n")
cat("✓ cereal_prod_nacional.rds\n")

# ══════════════════════════════════════════════════════════
# C. Merge a panel v5 → panel v6
# ══════════════════════════════════════════════════════════
cat("\n=== C. Construyendo panel_v6 ===\n")

panel <- readRDS(file.path(proc, "spending_panel_v5.rds"))
setDT(panel)

# 1. CHIRPS completo (reemplaza precip_nacional_mm que solo tiene 6 obs)
panel <- merge(panel,
               chirps_nat[, .(year, precip_interp_mm = precip_nacional_mm)],
               by = "year", all.x = TRUE)
panel[is.na(precip_nacional_mm) & !is.na(precip_interp_mm),
      precip_nacional_mm := precip_interp_mm]
panel[, precip_fuente := fifelse(year %in% c(2000,2005,2010,2015,2020,2023),
                                  "CHIRPS_TIF", "interpolado")]

# 2. Yield cereales INE
panel <- merge(panel, cereal_nat[, .(year, cereal_yield_kg_ha)],
               by = "year", all.x = TRUE)

# 3. Producción cereales total
panel <- merge(panel, cereal_prod_nat[, .(year, cereal_prod_ton)],
               by = "year", all.x = TRUE)

# 4. Hansen nacional (si no está ya)
if (!"defor_nacional_ha" %in% names(panel)) {
  hd <- readRDS(file.path(proc, "hansen_dept_annual_deforestation.rds"))
  setDT(hd)
  hnat <- hd[, .(defor_nacional_ha = sum(defor_ha, na.rm = TRUE)), by = year]
  panel <- merge(panel, hnat, by = "year", all.x = TRUE)
}

# 5. FAOSTAT (si existe)
if (file.exists(file.path(proc, "faostat_bolivia_qcl.rds"))) {
  fao <- readRDS(file.path(proc, "faostat_bolivia_qcl.rds"))
  setDT(fao)
  fao[, Code := NULL]
  setnames(fao, "Year", "year", skip_absent = TRUE)
  fao_vars <- setdiff(names(fao), c("year", names(panel)))
  if (length(fao_vars) > 0)
    panel <- merge(panel, fao[, c("year", fao_vars), with = FALSE],
                   by = "year", all.x = TRUE)
}

cat("Panel v6 final:", nrow(panel), "×", ncol(panel), "\n")
cat("\nCompletitud variables clave en panel_v6:\n")
key_v <- c("tfp_index","inv_agro_usd_mm","lc_antropico_share",
           "precip_nacional_mm","PSEP_pct","defor_nacional_ha",
           "cereal_yield_kg_ha","cereal_prod_ton")
for(v in key_v) {
  if (v %in% names(panel))
    cat(sprintf("  %-30s %2d/35\n", v, sum(!is.na(panel[[v]]))))
}

saveRDS(panel, file.path(proc, "spending_panel_v6.rds"))
fwrite(panel,  file.path(proc, "spending_panel_v6.csv"))
cat("\n✓ spending_panel_v6.rds (", nrow(panel), "×", ncol(panel), ")\n")
