library(httr2)
library(sf)
library(dplyr)
library(jsonlite)

here_root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
ext_dir   <- file.path(here_root, "01_data/external")

# ── geoBoundaries Bolivia ─────────────────────────────────────────────────────
get_geoboundaries <- function(iso3, adm_level) {
  url <- sprintf("https://www.geoboundaries.org/api/current/gbOpen/%s/%s/", iso3, adm_level)
  cat(sprintf("Fetching metadata: %s\n", url))
  resp <- request(url) |>
    req_timeout(30) |>
    req_perform()
  meta <- resp_body_json(resp)
  dl_url <- meta$gjDownloadURL
  cat(sprintf("Downloading GeoJSON: %s\n", dl_url))
  tmp <- tempfile(fileext = ".geojson")
  download.file(dl_url, tmp, quiet = FALSE, mode = "wb")
  sf::st_read(tmp, quiet = TRUE)
}

# ADM1 — 9 departamentos
cat("\n=== ADM1: Departamentos ===\n")
adm1 <- get_geoboundaries("BOL", "ADM1")
cat("Features:", nrow(adm1), "| CRS:", sf::st_crs(adm1)$input, "\n")
cat("Columns:", paste(names(adm1), collapse = ", "), "\n")

out_adm1_gpkg <- file.path(ext_dir, "bolivia_adm1_departments.gpkg")
out_adm1_shp  <- file.path(ext_dir, "shapefiles/adm1")
dir.create(out_adm1_shp, recursive = TRUE, showWarnings = FALSE)
sf::st_write(adm1, out_adm1_gpkg, delete_dsn = TRUE, quiet = TRUE)
sf::st_write(adm1, file.path(out_adm1_shp, "bolivia_adm1.shp"), delete_dsn = TRUE, quiet = TRUE)
cat("Guardado:", out_adm1_gpkg, "\n")

# ADM2 — 339 municipios
cat("\n=== ADM2: Municipios ===\n")
adm2 <- get_geoboundaries("BOL", "ADM2")
cat("Features:", nrow(adm2), "| CRS:", sf::st_crs(adm2)$input, "\n")

out_adm2_gpkg <- file.path(ext_dir, "bolivia_adm2_municipalities.gpkg")
out_adm2_shp  <- file.path(ext_dir, "shapefiles/adm2")
dir.create(out_adm2_shp, recursive = TRUE, showWarnings = FALSE)
sf::st_write(adm2, out_adm2_gpkg, delete_dsn = TRUE, quiet = TRUE)
sf::st_write(adm2, file.path(out_adm2_shp, "bolivia_adm2.shp"), delete_dsn = TRUE, quiet = TRUE)
cat("Guardado:", out_adm2_gpkg, "\n")

# ── Join con tabla de departamentos del proyecto ──────────────────────────────
dept_table <- readr::read_csv(file.path(ext_dir, "bolivia_departments.csv"), show_col_types = FALSE)
cat("\nDepartamentos en tabla interna:", nrow(dept_table), "\n")
cat("Nombres en shapefile:", paste(sort(adm1$shapeName), collapse = ", "), "\n")

# ── Resumen final ─────────────────────────────────────────────────────────────
cat("\n=== Archivos creados ===\n")
for (f in c(out_adm1_gpkg, out_adm2_gpkg)) {
  sz <- file.info(f)$size / 1024
  cat(sprintf("  %-55s  %.1f KB\n", basename(f), sz))
}
cat("\nListo. Usar sf::st_read() para cargar en análisis y mapas.\n")
