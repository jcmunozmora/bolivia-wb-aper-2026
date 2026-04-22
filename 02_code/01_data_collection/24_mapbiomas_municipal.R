# MapBiomas Bolivia — NIVEL MUNICIPAL (339 munis × 40 años × clases)
# =============================================================================
# Los datos ya están en el XLSX descargado. Solo filtrar nivel-politico-3
# (municipios) y extraer la serie temporal por clase.
#
# Output: 01_data/processed/mapbiomas_municipal_annual.rds
#         339 munis × 40 años × 3 macro-clases (Natural/Antrópico/No definido)
# =============================================================================

library(readxl)
library(data.table)
library(stringr)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
f        <- file.path(root, "01_data/raw/mapbiomas/MapBiomas_Bolivia_col3_stats.xlsx")
proc_dir <- file.path(root, "01_data/processed")

cat("=== Leyendo MapBiomas COBERTURA ===\n")
cov <- suppressMessages(read_excel(f, sheet = "COBERTURA"))
setDT(cov)
cat("Total filas:", nrow(cov), "\n\n")

# Filtrar municipios (nivel-politico-3)
mun <- cov[territory_category == "nivel-politico-3"]
cat("Nivel municipal: ", nrow(mun), "filas\n")
cat("Municipios únicos:", length(unique(mun$NAME)), "\n")
cat("TERRITORY_LEVEL_2 (depts):", paste(unique(mun$TERRITORY_LEVEL_2), collapse = ", "), "\n\n")

# Year cols
year_cols <- names(mun)[grep("^(19|20)\\d{2}$", names(mun))]
cat("Años cubiertos:", length(year_cols), "(", range(as.integer(year_cols))[1],
    "-", range(as.integer(year_cols))[2], ")\n\n")

# Wide → long
cov_long <- melt(mun,
  id.vars = c("NAME", "TERRITORY_LEVEL_1", "TERRITORY_LEVEL_2",
              "class_id", "level_0", "level_1", "level_2"),
  measure.vars = year_cols,
  variable.name = "year",
  value.name = "area_ha")
cov_long[, year := as.integer(as.character(year))]
cov_long[, area_ha := as.numeric(area_ha)]

# Panel municipal × año × macro-clase (level_0)
mun_panel <- cov_long[, .(area_ha = sum(area_ha, na.rm = TRUE)),
  by = .(municipio = NAME, dept = TERRITORY_LEVEL_2, year, level_0)]

# Pivot wide
mun_wide <- dcast(mun_panel, municipio + dept + year ~ level_0,
                  value.var = "area_ha")

# Rename
setnames(mun_wide, old = intersect(c("Natural", "Antropico", "No definido"), names(mun_wide)),
         new  = paste0("area_", tolower(intersect(c("Natural", "Antropico", "No definido"), names(mun_wide)))))
setnames(mun_wide, "area_no definido", "area_no_def", skip_absent = TRUE)

# Calcular área total y shares
mun_wide[, area_total_ha := rowSums(.SD, na.rm = TRUE),
         .SDcols = grep("^area_", names(mun_wide), value = TRUE)]

if ("area_antropico" %in% names(mun_wide)) {
  mun_wide[, antropico_share := 100 * area_antropico / area_total_ha]
}
if ("area_natural" %in% names(mun_wide)) {
  mun_wide[, natural_share   := 100 * area_natural / area_total_ha]
}

cat("=== Panel municipal MapBiomas ===\n")
cat("Dimensiones:", nrow(mun_wide), "×", ncol(mun_wide), "\n\n")

# Verificar
cat("Municipios × años = 339 × 40 =", 339*40, "esperado | real:", nrow(mun_wide), "\n\n")

# Cambio 1985→2024 por municipio
mun_change <- dcast(mun_wide[year %in% c(1985, 2024)],
                    municipio + dept ~ year,
                    value.var = c("area_antropico", "area_natural", "antropico_share"))
mun_change[, cambio_antrop_ha := area_antropico_2024 - area_antropico_1985]
mun_change[, cambio_antrop_pct := 100 * cambio_antrop_ha / pmax(1, area_antropico_1985)]
mun_change[, cambio_natural_ha := area_natural_2024 - area_natural_1985]
mun_change[, cambio_antrop_share_pp := antropico_share_2024 - antropico_share_1985]

cat("=== Top 10 municipios con mayor expansión antrópica 1985-2024 (absoluta) ===\n")
print(mun_change[order(-cambio_antrop_ha)][1:10,
  .(municipio, dept,
    antrop_1985_kha = round(area_antropico_1985/1e3, 1),
    antrop_2024_kha = round(area_antropico_2024/1e3, 1),
    cambio_kha = round(cambio_antrop_ha/1e3, 1),
    share_2024 = round(antropico_share_2024, 1))])

cat("\n=== Top 10 municipios con mayor expansión antrópica 1985-2024 (relativa) ===\n")
print(mun_change[area_antropico_1985 > 1000][order(-cambio_antrop_share_pp)][1:10,
  .(municipio, dept,
    share_1985 = round(antropico_share_1985, 1),
    share_2024 = round(antropico_share_2024, 1),
    delta_pp = round(cambio_antrop_share_pp, 1))])

# Save
saveRDS(mun_wide, file.path(proc_dir, "mapbiomas_municipal_annual.rds"))
saveRDS(mun_change, file.path(proc_dir, "mapbiomas_municipal_cambio.rds"))
fwrite(mun_wide, file.path(proc_dir, "mapbiomas_municipal_annual.csv"))
fwrite(mun_change, file.path(proc_dir, "mapbiomas_municipal_cambio.csv"))

cat("\n✓ Guardado: mapbiomas_municipal_annual.rds (", nrow(mun_wide), "filas)\n")
cat("✓ Guardado: mapbiomas_municipal_cambio.rds (", nrow(mun_change), "filas)\n")
