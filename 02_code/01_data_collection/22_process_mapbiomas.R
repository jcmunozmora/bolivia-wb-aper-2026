# Procesa MapBiomas Bolivia Collection 3 (1985-2024)
# =============================================================================
# Input: MapBiomas_Bolivia_col3_stats.xlsx (71 MB, 7 hojas)
#   - COBERTURA: 1985-2024 × territorio × clase de cobertura
#   - TRANSICION: matrices de transición entre clases
#   - Legend_code: códigos y descripciones de clases
#
# Output:
#   - mapbiomas_cobertura_long.rds: panel territorio × año × clase
#   - mapbiomas_dept_annual.rds: agregado por depto × año × macro-clase
#   - mapbiomas_transitions.rds: transiciones clave
# =============================================================================

library(readxl)
library(data.table)
library(stringr)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
f        <- file.path(root, "01_data/raw/mapbiomas/MapBiomas_Bolivia_col3_stats.xlsx")
proc_dir <- file.path(root, "01_data/processed")

# ─── 1. Leyenda de clases ─────────────────────────────────────────────────────
cat("=== Procesando leyenda de clases MapBiomas ===\n")
leg_raw <- suppressMessages(read_excel(f, sheet = "Legend_code", skip = 1))
setDT(leg_raw)
setnames(leg_raw,
  old = names(leg_raw)[1:4],
  new = c("class_EN", "class_ES", "level", "hexcode"))

# Filtrar filas válidas
leg <- leg_raw[!is.na(class_ES) & class_ES != "" &
               !grepl("^COLLECTION", class_ES, ignore.case = TRUE)]

cat("Clases identificadas:", nrow(leg), "\n")
cat("Primeras 15:\n")
print(leg[1:min(15, nrow(leg)), .(class_ES, level)])

# ─── 2. Tabla COBERTURA ──────────────────────────────────────────────────────
cat("\n=== Leyendo tabla COBERTURA ===\n")
cov <- suppressMessages(read_excel(f, sheet = "COBERTURA"))
setDT(cov)
cat("Dims:", nrow(cov), "×", ncol(cov), "\n")

# Years columns
year_cols <- names(cov)[grep("^(19|20)\\d{2}$", names(cov))]
cat("Años disponibles:", paste(range(as.integer(year_cols)), collapse="-"),
    "(", length(year_cols), "años)\n")

# Vista de categorías territoriales
cat("\nNiveles territoriales:\n")
print(cov[, .N, by = TERRITORY_LEVEL_1][order(-N)][1:10])
cat("\nCategorías territorio_category:\n")
print(cov[, .N, by = territory_category][order(-N)])

# ─── 3. Filtrar a nivel DEPARTAMENTO ──────────────────────────────────────────
# nivel-politico-1 = País (Bolivia)
# nivel-politico-2 = Departamentos (9)
# nivel-politico-3 = Municipios (339)
depts <- cov[territory_category == "nivel-politico-2"]
cat("\nDepartamentos (nivel-politico-2):", nrow(depts), "\n")
cat("Dept names:\n")
print(unique(depts$NAME))

# ─── 4. Wide → long por año ──────────────────────────────────────────────────
cat("\n=== Transformando a long format ===\n")
cov_long <- melt(cov,
                 id.vars = c("NAME", "TERRITORY_LEVEL_1", "TERRITORY_LEVEL_2",
                              "territory_category", "CATEGORY", "class_id",
                              "level_0", "level_1", "level_2"),
                 measure.vars = year_cols,
                 variable.name = "year",
                 value.name = "area_ha")
cov_long[, year := as.integer(as.character(year))]
cat("Filas long:", nrow(cov_long), "\n")

# ─── 5. Panel departamental × año × clase ────────────────────────────────────
# Nivel 0 son las 6 macro-clases (Forest, Grassland, Farming, Non-veg, Water, NotObserved)
dept_panel <- cov_long[territory_category == "nivel-politico-2",
  .(area_ha = sum(as.numeric(area_ha), na.rm = TRUE)),
  by = .(dept = NAME, year, level_0)]

dept_panel_wide <- dcast(dept_panel, dept + year ~ level_0, value.var = "area_ha")
# Renombrar columnas de clases
cls_cols <- setdiff(names(dept_panel_wide), c("dept", "year"))
if (length(cls_cols) > 0) {
  new_names <- paste0("area_ha_", gsub(" ", "_", tolower(cls_cols)))
  setnames(dept_panel_wide, cls_cols, new_names)
}

cat("\n=== Panel Dept × Año × Macro-clase ===\n")
cat("Filas:", nrow(dept_panel_wide), "\n")
cat("Cols:", paste(names(dept_panel_wide), collapse=", "), "\n\n")
print(head(dept_panel_wide[year == 2024], 10))

# ─── 6. Serie nacional (Bolivia) ──────────────────────────────────────────────
national <- cov_long[territory_category == "nivel-politico-1",
  .(area_ha = sum(as.numeric(area_ha), na.rm = TRUE)),
  by = .(year, level_0)]
cat("\n=== Serie nacional Bolivia 2024 ===\n")
print(national[year == 2024])

# ─── 7. Cambio neto 1985-2024 por clase ───────────────────────────────────────
if (nrow(national) > 0) {
  n_start <- national[year == 1985]
  n_end   <- national[year == 2024]
  change <- merge(n_start[, .(level_0, area_ha_1985 = area_ha)],
                   n_end[, .(level_0, area_ha_2024 = area_ha)],
                   by = "level_0")
  change[, cambio_ha := area_ha_2024 - area_ha_1985]
  change[, cambio_pct := 100 * cambio_ha / area_ha_1985]
  cat("\n=== Cambio Bolivia 1985-2024 por macro-clase ===\n")
  print(change[order(-abs(cambio_ha))])
}

# Save
saveRDS(cov_long, file.path(proc_dir, "mapbiomas_cobertura_long.rds"))
saveRDS(dept_panel_wide, file.path(proc_dir, "mapbiomas_dept_annual.rds"))
saveRDS(national, file.path(proc_dir, "mapbiomas_national_annual.rds"))
saveRDS(leg, file.path(proc_dir, "mapbiomas_legend.rds"))
fwrite(dept_panel_wide, file.path(proc_dir, "mapbiomas_dept_annual.csv"))
fwrite(national, file.path(proc_dir, "mapbiomas_national_annual.csv"))
cat("\n✓ Guardado 4 archivos en processed/\n")
