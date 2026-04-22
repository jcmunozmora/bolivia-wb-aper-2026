# Descarga de datos OECD para comparadores PSE
# Bolivia NO es miembro OECD — usar LAC members como benchmark
# Output: 01_data/raw/oecd_pse/
source(here::here("02_code", "00_setup", "01_constants.R"))
library(OECD)
library(tidyverse)

out_dir <- file.path(DIR_DATA_RAW, "oecd_pse")

# ── PSE/CSE: Producer & Consumer Support Estimates ───────────────────────────
# Países con datos PSE relevantes para comparación con Bolivia
# Incluye LAC OECD members + emerging economies monitoreadas
cat("Consultando estructura dataset MON...\n")
pse_structure <- get_data_structure("MON2023")

# Códigos de países LAC en OECD PSE database
# Chile (CHL), Colombia (COL), Brasil (BRA), México (MEX), Costa Rica (CRI)
# + promedio OECD (OECD), LAC regional
pse_countries <- c("CHL", "COL", "BRA", "MEX", "CRI", "OECD")

cat("Descargando PSE para comparadores LAC...\n")
pse_data <- get_dataset(
  dataset  = "MON2023",
  filter   = list(COUNTRY = pse_countries),
  start_time = YEAR_START,
  end_time   = YEAR_END
)
saveRDS(pse_data, file.path(out_dir, "pse_latam_oecd.rds"))

# ── Agricultural Outlook ──────────────────────────────────────────────────────
cat("Descargando Agricultural Outlook (proyecciones LAC)...\n")
tryCatch({
  outlook <- get_dataset("HIGH_AGLINK_2023")
  outlook_latam <- outlook |>
    filter(LOCATION %in% c("CHL", "COL", "BRA", "LAC"))
  saveRDS(outlook_latam, file.path(out_dir, "agr_outlook_latam.rds"))
}, error = function(e) {
  message("Agricultural Outlook no disponible: ", e$message)
})

# ── CRSNEW: Flujos de ayuda oficial al desarrollo en agricultura ──────────────
cat("Descargando CRS (ODA agricultura Bolivia)...\n")
tryCatch({
  crs <- get_dataset(
    dataset = "CRS1",
    filter  = list(RECIPIENT = "BOL", SECTOR = "31")  # sector 31 = agricultura
  )
  saveRDS(crs, file.path(out_dir, "oda_agriculture_bolivia.rds"))
}, error = function(e) {
  message("CRS ODA no disponible via API: ", e$message)
  message("Descarga manual desde: https://stats.oecd.org/DownloadFiles.aspx?DatasetCode=CRS1")
})

# ── Metadata PSE ─────────────────────────────────────────────────────────────
saveRDS(pse_structure, file.path(out_dir, "pse_structure_metadata.rds"))

cat(glue::glue("OECD PSE descargado. Países: {paste(pse_countries, collapse=', ')}. Fecha: {Sys.Date()}\n"))
