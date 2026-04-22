# Procesa CHIRPS annual precipitation para Bolivia
# =============================================================================
# Input: CHIRPS v2.0 annual TIFFs (6 años: 2000,2005,2010,2015,2020,2023)
# Output: 01_data/processed/chirps_dept_annual.rds
#   9 depts × año × precipitación promedio (mm/año)
# =============================================================================

library(terra)
library(sf)
library(data.table)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
chirps_dir <- file.path(root, "01_data/raw/chirps")
proc_dir <- file.path(root, "01_data/processed")

# Cargar ADM1 Bolivia
adm1 <- st_read(file.path(root, "01_data/external/bolivia_adm1_departments.gpkg"),
                quiet = TRUE)
adm1_vect <- terra::vect(adm1)

years <- c(2000, 2005, 2010, 2015, 2020, 2023)
out <- list()

for (yr in years) {
  tif <- file.path(chirps_dir, sprintf("chirps_annual_%d.tif", yr))
  if (!file.exists(tif)) next

  cat(sprintf("  Procesando %d...\n", yr))
  r <- terra::rast(tif)

  # Crop to Bolivia bounding box first (speedup)
  r_crop <- terra::crop(r, adm1_vect)

  # Extract mean precipitation per department
  ext <- terra::extract(r_crop, adm1_vect, fun = mean, na.rm = TRUE)
  # Join with adm1 names
  result <- data.table(
    dept_name  = adm1$shapeName,
    year       = yr,
    precip_mm  = ext[[2]]  # second column is the extracted value
  )
  out[[as.character(yr)]] <- result
}

chirps_dept <- rbindlist(out)
cat("\n=== CHIRPS Bolivia precipitación anual por depto ===\n")
cat("Filas:", nrow(chirps_dept), "\n")
print(dcast(chirps_dept, dept_name ~ year, value.var = "precip_mm"))

saveRDS(chirps_dept, file.path(proc_dir, "chirps_dept_annual.rds"))
fwrite(chirps_dept, file.path(proc_dir, "chirps_dept_annual.csv"))
cat("\n✓ Guardado: chirps_dept_annual.rds\n")
