# Panel v10 → v11: merge de datasets que estaban en archivos separados
# =============================================================================
# Consolida en panel maestro:
#   - MapBiomas nacional (macro-clases 1985-2024)
#   - Hansen deforestación agregada nacional (2001-2023)
#   - WDI Bolivia extendido (22 vars 1990-2023)
#   - BOOST agregado nacional (1996-2008)
#   - FAOSTAT QCL (cereal yield, prod indices — ya parcial)
#
# Output: spending_panel_v11.rds (target ~170 vars)
# =============================================================================

library(data.table)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")

# ── Base: panel v10 ───────────────────────────────────────────────────────────
cat("=== Cargando panel v10 ===\n")
panel <- readRDS(file.path(proc, "spending_panel_v10.rds"))
setDT(panel)
cat(sprintf("v10: %d años × %d vars\n", nrow(panel), ncol(panel)))

# ── 1. MapBiomas nacional — dcast long → wide ────────────────────────────────
cat("\n=== Integrando MapBiomas nacional ===\n")
mb <- readRDS(file.path(proc, "mapbiomas_national_annual.rds"))
setDT(mb)

# Normalize macro-class names to snake_case
mb[, lc_class := tolower(gsub("[^a-z0-9]+", "_", level_0))]
mb[, lc_class := gsub("^_|_$", "", lc_class)]

mb_wide <- dcast(mb, year ~ lc_class, value.var = "area_ha", fun.aggregate = sum)
# Prefijo mb_ y sufijo _ha
old_cols <- setdiff(names(mb_wide), "year")
new_cols <- paste0("mb_", old_cols, "_ha")
setnames(mb_wide, old_cols, new_cols)
cat(sprintf("MapBiomas: %d vars × %d años\n", ncol(mb_wide)-1, nrow(mb_wide)))

# ── 2. Hansen deforestación — agregado nacional ──────────────────────────────
cat("\n=== Integrando Hansen nacional ===\n")
hansen <- readRDS(file.path(proc, "hansen_dept_annual_deforestation.rds"))
setDT(hansen)
hansen_nac <- hansen[, .(
  hansen_defor_ha = sum(defor_ha, na.rm = TRUE),
  hansen_forest_2000_ha = sum(forest_area_2000_ha, na.rm = TRUE),
  hansen_defor_pct_2000 = sum(defor_ha, na.rm = TRUE) / sum(forest_area_2000_ha, na.rm = TRUE) * 100
), by = year]
cat(sprintf("Hansen: %d años\n", nrow(hansen_nac)))

# ── 3. WDI Bolivia extendido ──────────────────────────────────────────────────
cat("\n=== Integrando WDI Bolivia extendido ===\n")
wdi <- readRDS(file.path(proc, "wdi_bolivia.rds"))
setDT(wdi)
# Drop cols que ya existen en panel
wdi[, c("iso3c", "country") := NULL]
# Rename para evitar colisiones
existing <- intersect(names(wdi), names(panel))
existing <- setdiff(existing, "year")
cat(sprintf("Cols WDI que ya existen en panel (omitir): %s\n", paste(existing, collapse=", ")))
if (length(existing) > 0) wdi[, (existing) := NULL]
# Prefijo wdi_ a las que quedan
new_wdi <- setdiff(names(wdi), "year")
new_wdi_names <- ifelse(grepl("^wdi_", new_wdi), new_wdi, paste0("wdi_", new_wdi))
setnames(wdi, new_wdi, new_wdi_names)
cat(sprintf("WDI: %d vars adicionales\n", ncol(wdi)-1))

# ── 4. BOOST agregado ──────────────────────────────────────────────────────────
cat("\n=== Integrando BOOST agregado nacional ===\n")
boost <- readRDS(file.path(proc, "boost_agro_panel.rds"))
setDT(boost)
setnames(boost, setdiff(names(boost), "year"),
         paste0("boost_", setdiff(names(boost), "year")))
cat(sprintf("BOOST: %d vars × %d años\n", ncol(boost)-1, nrow(boost)))

# ── 5. Merge everything ──────────────────────────────────────────────────────
cat("\n=== Merge final ===\n")
panel_v11 <- panel |>
  merge(mb_wide,     by = "year", all.x = TRUE) |>
  merge(hansen_nac,  by = "year", all.x = TRUE) |>
  merge(wdi,         by = "year", all.x = TRUE) |>
  merge(boost,       by = "year", all.x = TRUE)

setDT(panel_v11)
setorder(panel_v11, year)

cat(sprintf("\n✓ Panel v11: %d años × %d vars (desde %d)\n",
            nrow(panel_v11), ncol(panel_v11), ncol(panel)))
cat(sprintf("  Nuevas vars: %d\n", ncol(panel_v11) - ncol(panel)))

# ── Density check ──────────────────────────────────────────────────────────────
cat("\n=== Densidad por año (n_vars_filled) ===\n")
density_yr <- panel_v11[, .(n_vars = rowSums(!is.na(.SD))), by = year]
setorder(density_yr, year)
print(density_yr)

# ── Save ───────────────────────────────────────────────────────────────────────
saveRDS(panel_v11, file.path(proc, "spending_panel_v11.rds"))
fwrite(panel_v11,  file.path(proc, "spending_panel_v11.csv"))
cat("\n✓ spending_panel_v11.rds\n")
cat("✓ spending_panel_v11.csv\n")
