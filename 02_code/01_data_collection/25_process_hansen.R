# Procesa Hansen Global Forest Change v1.11 para Bolivia
# =============================================================================
# EJECUTAR con el R de miniforge (NO el renv del proyecto, que no tiene
# terra/sf/data.table y tarda 300s escaneando dependencias):
#
#   cd "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
#   RENV_CONFIG_AUTOLOADER_ENABLED=FALSE \
#   R_PROFILE_USER=/dev/null \
#   /Users/jcmunoz/miniforge3/envs/ds/bin/Rscript \
#       02_code/01_data_collection/25_process_hansen.R 2>&1 | tee /tmp/hansen_log.txt
#
# Estrategia memory-safe:
#   - Procesa tile por tile (nunca mosaic completo)
#   - Fuerza escritura a disco de cada raster intermedio (filename = tempfile)
#   - Agrega 30m → 300m (factor 10) antes de cualquier extract
#   - Limpia tempfiles de terra después de cada tile
#   - memfrac = 0.3 → nunca usa más de 30% RAM
#
# Tiempo estimado: ~20-30 min (4 tiles × 23 años).
# Heartbeat: imprime una línea por año con timestamp + uso de RAM.
# =============================================================================

# Bloquea renv (si lo activa el .Rprofile)
Sys.setenv(RENV_CONFIG_AUTOLOADER_ENABLED = "FALSE")

t_global <- Sys.time()
hb <- function(msg) {
  rss_mb <- tryCatch({
    pid <- Sys.getpid()
    as.numeric(system(sprintf("ps -o rss= -p %d", pid), intern = TRUE)) / 1024
  }, error = function(e) NA_real_)
  cat(sprintf("[%s | %.1fm | RAM %.0f MB] %s\n",
              format(Sys.time(), "%H:%M:%S"),
              as.numeric(difftime(Sys.time(), t_global, units = "mins")),
              rss_mb, msg))
  flush.console()
}

hb("iniciando — cargando librerías")
suppressPackageStartupMessages({
  library(terra)
  library(sf)
  library(data.table)
})
hb(sprintf("terra %s · sf %s · data.table %s",
           packageVersion("terra"), packageVersion("sf"), packageVersion("data.table")))

# ── Config terra: OOM-safe ───────────────────────────────────────────────────
terra_tmp <- "/tmp/terra_hansen"
dir.create(terra_tmp, showWarnings = FALSE)
terraOptions(memfrac = 0.3, tempdir = terra_tmp, todisk = TRUE, progress = 0)
hb(sprintf("terra: memfrac=0.3 | todisk=TRUE | tempdir=%s", terra_tmp))

root       <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
hansen_dir <- file.path(root, "01_data/raw/hansen")
proc_dir   <- file.path(root, "01_data/processed")

hb("leyendo shapefiles ADM1 y ADM3")
adm1 <- st_read(file.path(root, "01_data/external/bolivia_adm1_departments.gpkg"),
                quiet = TRUE)
adm3 <- st_read(file.path(root, "01_data/external/bolivia_adm3_municipalities.gpkg"),
                quiet = TRUE)
adm1_vect <- terra::vect(adm1)
adm3_vect <- terra::vect(adm3)
hb(sprintf("ADM1: %d depts · ADM3: %d munis", nrow(adm1), nrow(adm3)))

TILES <- c("10S_060W", "10S_070W", "20S_060W", "20S_070W")
AGG   <- 10       # 30m × 10 = 300m
YEARS <- 1:23     # 2001-2023
bol_ext <- ext(adm1_vect)

dept_rows <- list(); muni_rows <- list()
fa2000_dept_tiles <- list(); fa2000_muni_tiles <- list()
tile_tmp <- function() tempfile(tmpdir = terra_tmp, fileext = ".tif")

# Tamaño total tempdir en MB
tmp_mb <- function() {
  f <- list.files(terra_tmp, full.names = TRUE, recursive = TRUE)
  if (length(f) == 0) return(0)
  round(sum(file.info(f)$size, na.rm = TRUE) / 1024^2, 0)
}

for (tile in TILES) {
  t_tile <- Sys.time()
  hb(sprintf("=== TILE %s INICIO ===", tile))

  tc_f <- file.path(hansen_dir,
                    sprintf("Hansen_GFC-2023-v1.11_treecover2000_%s.tif", tile))
  ly_f <- file.path(hansen_dir,
                    sprintf("Hansen_GFC-2023-v1.11_lossyear_%s.tif", tile))
  if (!file.exists(tc_f) || !file.exists(ly_f)) {
    hb(sprintf("  [%s] ficheros faltantes — SKIP", tile)); next
  }

  hb(sprintf("  abriendo rasters (file sizes: tc=%.0fMB, ly=%.0fMB)",
             file.info(tc_f)$size/1e6, file.info(ly_f)$size/1e6))
  tc <- rast(tc_f); ly <- rast(ly_f)
  inter <- intersect(ext(tc), bol_ext)
  if (is.null(inter)) { hb(sprintf("  [%s] fuera de Bolivia — SKIP", tile)); next }

  hb(sprintf("  crop a Bolivia bbox… (origen %d × %d)", nrow(tc), ncol(tc)))
  tc <- crop(tc, inter, filename = tile_tmp(), overwrite = TRUE)
  ly <- crop(ly, inter, filename = tile_tmp(), overwrite = TRUE)
  hb(sprintf("  crop OK → %d × %d @30m (%.1fM pixeles · temp %d MB)",
             nrow(tc), ncol(tc),
             (as.numeric(nrow(tc)) * ncol(tc)) / 1e6, tmp_mb()))

  hb("  cellSize → ha por pixel")
  area_30 <- cellSize(tc, unit = "ha", filename = tile_tmp(), overwrite = TRUE)

  hb("  forest_2000 = (tc >= 30)")
  forest_2000 <- lapp(tc, fun = function(x) as.integer(x >= 30),
                      filename = tile_tmp(), overwrite = TRUE)

  hb("  forest area 2000 a 300m (aggregate sum)")
  fa_30 <- lapp(sds(forest_2000, area_30), fun = function(f, a) f * a,
                filename = tile_tmp(), overwrite = TRUE)
  fa_300 <- aggregate(fa_30, fact = AGG, fun = "sum", na.rm = TRUE,
                      filename = tile_tmp(), overwrite = TRUE)

  hb("  extract forest 2000 por depto + muni")
  e_d <- terra::extract(fa_300, adm1_vect, fun = sum, na.rm = TRUE)
  e_m <- terra::extract(fa_300, adm3_vect, fun = sum, na.rm = TRUE)
  fa2000_dept_tiles[[tile]] <- data.table(dept = adm1$shapeName, forest_ha = e_d[[2]])
  fa2000_muni_tiles[[tile]] <- data.table(municipio = adm3$shapeName, forest_ha = e_m[[2]])
  hb(sprintf("  ✓ baseline 2000 OK · temp %d MB", tmp_mb()))

  # Deforestación año por año (heartbeat por cada año)
  for (yr_code in YEARS) {
    defor_30 <- lapp(sds(ly, forest_2000, area_30),
                     fun = function(l, f, a) (l == yr_code) * f * a,
                     filename = tile_tmp(), overwrite = TRUE)
    defor_300 <- aggregate(defor_30, fact = AGG, fun = "sum", na.rm = TRUE,
                           filename = tile_tmp(), overwrite = TRUE)
    d_d <- terra::extract(defor_300, adm1_vect, fun = sum, na.rm = TRUE)
    d_m <- terra::extract(defor_300, adm3_vect, fun = sum, na.rm = TRUE)

    dept_rows[[length(dept_rows) + 1L]] <- data.table(
      dept = adm1$shapeName, year = 2000 + yr_code,
      tile = tile, defor_ha = d_d[[2]])
    muni_rows[[length(muni_rows) + 1L]] <- data.table(
      municipio = adm3$shapeName, year = 2000 + yr_code,
      tile = tile, defor_ha = d_m[[2]])

    total_yr <- sum(d_d[[2]], na.rm = TRUE)
    hb(sprintf("  [%s] año %d ok · %.1fk ha deforestadas en este tile · temp %d MB",
               tile, 2000 + yr_code, total_yr/1e3, tmp_mb()))

    rm(defor_30, defor_300); gc(verbose = FALSE)
  }

  rm(tc, ly, area_30, forest_2000, fa_30, fa_300); gc(verbose = FALSE)
  unlink(list.files(terra_tmp, pattern = "\\.tif$", full.names = TRUE))
  dt <- as.numeric(difftime(Sys.time(), t_tile, units = "mins"))
  hb(sprintf("  === TILE %s FIN · %.1f min · temp limpiado ===", tile, dt))
}

hb("=== CONSOLIDANDO RESULTADOS ===")
dept_all <- rbindlist(dept_rows)[, .(defor_ha = sum(defor_ha, na.rm = TRUE)),
                                 by = .(dept, year)]
muni_all <- rbindlist(muni_rows)[, .(defor_ha = sum(defor_ha, na.rm = TRUE)),
                                 by = .(municipio, year)]
fa2000_dept <- rbindlist(fa2000_dept_tiles)[,
  .(forest_area_2000_ha = sum(forest_ha, na.rm = TRUE)), by = dept]
fa2000_muni <- rbindlist(fa2000_muni_tiles)[,
  .(forest_area_2000_ha = sum(forest_ha, na.rm = TRUE)), by = municipio]

dept_all <- merge(dept_all, fa2000_dept, by = "dept", all.x = TRUE)
muni_all <- merge(muni_all, fa2000_muni, by = "municipio", all.x = TRUE)
dept_all[, defor_pct_2000 := 100 * defor_ha / pmax(1, forest_area_2000_ha)]
muni_all[, defor_pct_2000 := 100 * defor_ha / pmax(1, forest_area_2000_ha)]

dept_cum <- dept_all[, .(defor_total_ha = sum(defor_ha, na.rm = TRUE),
                         forest_2000_ha = first(forest_area_2000_ha)),
                     by = dept][,
  defor_pct_forest_2000 := 100 * defor_total_ha / pmax(1, forest_2000_ha)]

cat("\n── Deforestación acumulada 2001-2023 por depto ──\n")
print(dept_cum[order(-defor_total_ha)])

saveRDS(dept_all,    file.path(proc_dir, "hansen_dept_annual_deforestation.rds"))
saveRDS(muni_all,    file.path(proc_dir, "hansen_muni_annual_deforestation.rds"))
saveRDS(fa2000_dept, file.path(proc_dir, "hansen_dept_treecover_2000.rds"))
saveRDS(fa2000_muni, file.path(proc_dir, "hansen_muni_treecover_2000.rds"))
saveRDS(dept_cum,    file.path(proc_dir, "hansen_dept_cumulative.rds"))
fwrite(dept_all,     file.path(proc_dir, "hansen_dept_annual_deforestation.csv"))
fwrite(muni_all,     file.path(proc_dir, "hansen_muni_annual_deforestation.csv"))

hb(sprintf("GUARDADO: dept %d filas · muni %d filas", nrow(dept_all), nrow(muni_all)))
unlink(terra_tmp, recursive = TRUE)
hb("TEMP LIMPIADO · FIN")
