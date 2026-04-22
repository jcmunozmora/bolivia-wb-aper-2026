# Procesa Hansen Global Forest Change v1.11 para Bolivia
# =============================================================================
# Input: 4 tiles GFC (10S/20S × 60W/70W) × 2 layers (treecover2000, lossyear)
# Total: 2.3 GB raw rasters
#
# Output:
#   - hansen_dept_annual_deforestation.rds: 9 depts × 24 años (2001-2024)
#   - hansen_muni_annual_deforestation.rds: 339 munis × 24 años
#   - hansen_dept_treecover_2000.rds: baseline forest cover 2000
# =============================================================================

library(terra)
library(sf)
library(data.table)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
hansen_dir <- file.path(root, "01_data/raw/hansen")
proc_dir <- file.path(root, "01_data/processed")

# Cargar shapefiles
adm1 <- st_read(file.path(root, "01_data/external/bolivia_adm1_departments.gpkg"),
                quiet = TRUE)
adm3 <- st_read(file.path(root, "01_data/external/bolivia_adm3_municipalities.gpkg"),
                quiet = TRUE)
adm1_vect <- terra::vect(adm1)
adm3_vect <- terra::vect(adm3)

cat("ADM1 (depts):", nrow(adm1), "| ADM3 (munis):", nrow(adm3), "\n\n")

# ─── 1. Mosaic tiles ──────────────────────────────────────────────────────────
cat("=== Mosaicando tiles Hansen (treecover2000 + lossyear) ===\n")

# Function to mosaic 4 tiles
mosaic_tiles <- function(layer) {
  tiles <- c("10S_060W", "10S_070W", "20S_060W", "20S_070W")
  rasters <- lapply(tiles, function(t) {
    f <- file.path(hansen_dir, sprintf("Hansen_GFC-2023-v1.11_%s_%s.tif", layer, t))
    if (!file.exists(f)) return(NULL)
    terra::rast(f)
  })
  rasters <- rasters[!sapply(rasters, is.null)]
  if (length(rasters) == 0) return(NULL)
  if (length(rasters) == 1) return(rasters[[1]])
  do.call(terra::mosaic, c(rasters, fun = "min"))
}

cat("  Mosaicando treecover2000...\n")
tc <- mosaic_tiles("treecover2000")
cat("  Dim:", dim(tc), "| res:", terra::res(tc), "\n")
cat("  Mosaicando lossyear...\n")
ly <- mosaic_tiles("lossyear")
cat("  Dim:", dim(ly), "| res:", terra::res(ly), "\n\n")

# ─── 2. Crop to Bolivia bounding box (speedup) ───────────────────────────────
cat("=== Cropping a Bolivia ===\n")
bolivia_bbox <- terra::ext(adm1_vect)
tc_bol <- terra::crop(tc, bolivia_bbox)
ly_bol <- terra::crop(ly, bolivia_bbox)
cat("  TC Bolivia:", dim(tc_bol), "\n")
cat("  LY Bolivia:", dim(ly_bol), "\n\n")

# ─── 3. Calcular área por pixel ──────────────────────────────────────────────
# A 30m resolution, cada pixel ≈ 0.09 ha (30×30/10000)
# Pero en coordenadas geográficas (WGS84), el área varía con la latitud
# Para simplicidad usamos cellSize() de terra
cat("=== Calculando área por píxel (ha) ===\n")
area_ras <- terra::cellSize(tc_bol, unit = "ha")
cat("  Area raster OK\n\n")

# ─── 4. Baseline treecover 2000 por depto/muni ───────────────────────────────
# Un pixel se considera "forest" si tree cover ≥ 30% (umbral Hansen estándar)
cat("=== Forest cover 2000 (threshold ≥30%) ===\n")
forest_2000 <- tc_bol >= 30
forest_area_2000 <- forest_2000 * area_ras

cat("  Extrayendo area forestal 2000 por depto...\n")
fa2000_dept <- terra::extract(forest_area_2000, adm1_vect, fun = sum, na.rm = TRUE)
fa2000_dept_dt <- data.table(
  dept = adm1$shapeName,
  forest_area_2000_ha = fa2000_dept[[2]]
)
print(fa2000_dept_dt[order(-forest_area_2000_ha)])

cat("\n  Extrayendo area forestal 2000 por muni...\n")
fa2000_muni <- terra::extract(forest_area_2000, adm3_vect, fun = sum, na.rm = TRUE)
fa2000_muni_dt <- data.table(
  municipio = adm3$shapeName,
  forest_area_2000_ha = fa2000_muni[[2]]
)

# ─── 5. Deforestation por año (lossyear) ──────────────────────────────────────
# lossyear value 1-24 representa 2001-2024
# Pérdida ocurre solo en pixels que eran forest en 2000
cat("\n=== Procesando deforestación anual 2001-2024 ===\n")

dept_defor_list <- list()
muni_defor_list <- list()

for (yr_code in 1:23) {  # 1-23 = 2001-2023 (v1.11 llega a 2023)
  cat(sprintf("  Año %d (código %d)...", 2000 + yr_code, yr_code))
  # Deforestación ese año: lossyear == yr_code AND forest_2000
  defor_mask <- (ly_bol == yr_code) & forest_2000
  defor_area <- defor_mask * area_ras

  # Agregado departamental
  d_ext <- terra::extract(defor_area, adm1_vect, fun = sum, na.rm = TRUE)
  dept_defor_list[[as.character(2000 + yr_code)]] <- data.table(
    dept = adm1$shapeName, year = 2000 + yr_code,
    defor_ha = d_ext[[2]]
  )

  # Agregado municipal (más lento)
  m_ext <- terra::extract(defor_area, adm3_vect, fun = sum, na.rm = TRUE)
  muni_defor_list[[as.character(2000 + yr_code)]] <- data.table(
    municipio = adm3$shapeName, year = 2000 + yr_code,
    defor_ha = m_ext[[2]]
  )
  cat(" ok\n")
}

dept_defor <- rbindlist(dept_defor_list)
muni_defor <- rbindlist(muni_defor_list)

# Merge baseline
dept_defor <- merge(dept_defor, fa2000_dept_dt, by = "dept", all.x = TRUE)
muni_defor <- merge(muni_defor, fa2000_muni_dt, by = "municipio", all.x = TRUE)

# Calcular % anual sobre bosque 2000
dept_defor[, defor_pct_2000 := 100 * defor_ha / pmax(1, forest_area_2000_ha)]
muni_defor[, defor_pct_2000 := 100 * defor_ha / pmax(1, forest_area_2000_ha)]

cat("\n=== Resumen deforestación acumulada 2001-2023 por depto ===\n")
dept_cum <- dept_defor[, .(
  defor_total_ha = sum(defor_ha, na.rm = TRUE),
  forest_2000_ha = first(forest_area_2000_ha)
), by = dept][, defor_pct_forest_2000 := 100 * defor_total_ha / pmax(1, forest_2000_ha)]
print(dept_cum[order(-defor_total_ha)])

# Save
saveRDS(dept_defor, file.path(proc_dir, "hansen_dept_annual_deforestation.rds"))
saveRDS(muni_defor, file.path(proc_dir, "hansen_muni_annual_deforestation.rds"))
saveRDS(fa2000_dept_dt, file.path(proc_dir, "hansen_dept_treecover_2000.rds"))
saveRDS(fa2000_muni_dt, file.path(proc_dir, "hansen_muni_treecover_2000.rds"))
saveRDS(dept_cum, file.path(proc_dir, "hansen_dept_cumulative.rds"))
fwrite(dept_defor, file.path(proc_dir, "hansen_dept_annual_deforestation.csv"))
fwrite(muni_defor, file.path(proc_dir, "hansen_muni_annual_deforestation.csv"))

cat("\n✓ Archivos guardados en processed/\n")
cat("  hansen_dept_annual_deforestation.rds (9 × 23 años = 207 filas)\n")
cat("  hansen_muni_annual_deforestation.rds (339 × 23 años = 7,797 filas)\n")
cat("  hansen_dept_cumulative.rds (9 depts resumen)\n")
