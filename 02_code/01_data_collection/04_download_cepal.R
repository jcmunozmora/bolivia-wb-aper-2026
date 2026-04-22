# Descarga de datos CEPALSTAT via API SDMX
# Output: 01_data/raw/cepal/
source(here::here("02_code", "00_setup", "01_constants.R"))
library(httr2)
library(tidyverse)
library(jsonlite)

out_dir <- file.path(DIR_DATA_RAW, "cepal")

# CEPALSTAT API base (SDMX 2.1)
CEPAL_BASE <- "https://api-cepalstat.cepal.org/cepalstat/api/v1"

# Helper para consultar CEPALSTAT
cepal_get <- function(indicator_id, countries = "BOL,PER,CHL,COL,BRA,ECU,PRY,ARG") {
  url <- glue::glue("{CEPAL_BASE}/indicator/{indicator_id}/data",
                    "?lang=es&members={countries}&format=json")
  resp <- request(url) |>
    req_timeout(60) |>
    req_retry(max_tries = 3) |>
    req_perform()

  if (resp_status(resp) == 200) {
    resp_body_json(resp, simplifyVector = TRUE)
  } else {
    warning(glue::glue("CEPALSTAT indicador {indicator_id}: status {resp_status(resp)}"))
    NULL
  }
}

# ── Indicadores CEPALSTAT clave ───────────────────────────────────────────────
# IDs obtenidos de: https://statistics.cepal.org/portal/cepalstat/
cepal_indicators <- list(
  pib_agropecuario        = "2017",   # PIB sector agropecuario (% del PIB)
  gasto_publico_agr       = "2094",   # Gasto público en agricultura (% PIB) — si disponible
  pobreza_rural           = "3678",   # Tasa de pobreza rural
  indigencia_rural        = "3679",   # Tasa de indigencia rural
  empleo_agricola         = "3693",   # Empleo agrícola (% empleo total)
  exportaciones_agr       = "2082",   # Exportaciones agropecuarias (USD)
  productividad_laboral   = "3714"    # Productividad laboral agricultura
)

cat("Descargando indicadores CEPALSTAT...\n")
cepal_data <- map(cepal_indicators, function(id) {
  cat(glue::glue("  → Indicador {id}...\n"))
  Sys.sleep(0.5)  # respetar rate limit
  cepal_get(id)
})

saveRDS(cepal_data, file.path(out_dir, "cepalstat_indicators.rds"))

# Descarga directa CSV como backup (más estable que API)
# Instrucciones: https://statistics.cepal.org/portal/cepalstat/
cepal_csv_url <- "https://api-cepalstat.cepal.org/cepalstat/api/v1/indicator/2017/data?lang=es&format=csv"
tryCatch({
  pib_agr_csv <- readr::read_csv(cepal_csv_url, show_col_types = FALSE)
  readr::write_csv(pib_agr_csv, file.path(out_dir, "pib_agropecuario_latam.csv"))
}, error = function(e) {
  message("CSV directo no disponible: ", e$message)
})

cat(glue::glue("CEPALSTAT descargado. Fecha: {Sys.Date()}\n"))
