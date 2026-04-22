# Limpieza y clasificación de datos de gasto público agropecuario
# Fuentes: BOOST + SIIF manual
# Output: 01_data/processed/spending_clean.rds
source(here::here("02_code", "00_setup", "01_constants.R"))
source(here::here("02_code", "00_setup", "02_functions.R"))
library(tidyverse)
library(readxl)

cofog_table <- readr::read_csv(file.path(DIR_DATA_EXT, "cofog_classification.csv"),
                                show_col_types = FALSE)
deflators   <- readr::read_csv(file.path(DIR_DATA_EXT, "inflation_deflators.csv"),
                                show_col_types = FALSE)
xrates      <- readr::read_csv(file.path(DIR_DATA_EXT, "exchange_rates.csv"),
                                show_col_types = FALSE)

# ── 1. Cargar BOOST procesado ─────────────────────────────────────────────────
boost_path <- file.path(DIR_DATA_RAW, "boost", "spending_national.rds")
if (file.exists(boost_path)) {
  spending_boost <- readRDS(boost_path)
  cat("BOOST cargado:", nrow(spending_boost), "obs\n")
} else {
  warning("BOOST no encontrado — ejecutar primero 05_process_boost.R")
  spending_boost <- tibble()
}

# ── 2. Cargar SIIF manual ─────────────────────────────────────────────────────
siif_files <- list.files(file.path(DIR_DATA_RAW, "siif"), pattern = "\\.xlsx$", full.names = TRUE)

read_siif_year <- function(path) {
  year <- as.integer(stringr::str_extract(basename(path), "\\d{4}"))
  sheets <- readxl::excel_sheets(path)
  map(sheets, ~readxl::read_excel(path, sheet = .x, skip = 2)) |>
    bind_rows() |>
    mutate(year = year, source = "SIIF") |>
    janitor::clean_names()
}

if (length(siif_files) > 0) {
  spending_siif <- map(siif_files, read_siif_year) |>
    bind_rows() |>
    filter(year %in% YEARS) |>
    rename_with(~case_when(
      str_detect(., "ejecut")  ~ "executed",
      str_detect(., "aprob")   ~ "approved",
      str_detect(., "entidad") ~ "institution",
      str_detect(., "program") ~ "program",
      TRUE ~ .
    ))
  cat("SIIF cargado:", nrow(spending_siif), "obs\n")
} else {
  warning("Archivos SIIF no encontrados en 01_data/raw/siif/ — ver 06_manual_sources.md")
  spending_siif <- tibble()
}

# ── 3. Combinar fuentes y resolver conflictos ─────────────────────────────────
# BOOST tiene prioridad cuando disponible (más granular y ya clasificado)
spending_combined <- bind_rows(spending_boost, spending_siif) |>
  filter(!is.na(executed), executed >= 0) |>
  distinct(year, institution, program, spending_category, .keep_all = TRUE)

# ── 4. Deflactar a valores reales BOB 2015 ───────────────────────────────────
cpi_named <- setNames(deflators$cpi_index, deflators$year)
xrate_named <- setNames(xrates$bob_per_usd, xrates$year)

spending_real <- spending_combined |>
  left_join(deflators |> select(year, cpi_index), by = "year") |>
  left_join(xrates   |> select(year, bob_per_usd), by = "year") |>
  mutate(
    cpi_base     = cpi_named[as.character(DEFLATOR_BASE)],
    executed_real_bob = executed * (cpi_base / cpi_index),
    executed_usd      = executed_real_bob / bob_per_usd,
    exec_rate         = if_else(!is.na(approved) & approved > 0,
                                executed / approved, NA_real_)
  ) |>
  select(-cpi_base)

# ── 5. Clasificar categorías de gasto funcional ───────────────────────────────
spending_classified <- spending_real |>
  mutate(
    spending_category = case_when(
      str_detect(institution, "INIAF")           ~ "investigacion_extension",
      str_detect(institution, "SENASAG")         ~ "sanidad_inocuidad",
      str_detect(institution, "EMAPA")           ~ "subsidios_precios",
      str_detect(institution, "BDP|credito")     ~ "credito_subsidiado",
      str_detect(institution, "INRA|Fondo Tier") ~ "tierra_titulacion",
      str_detect(institution, "MMAyA|riego")     ~ "riego_agua",
      str_detect(institution, "MDRyT") &
        str_detect(program, "extensi|asist")     ~ "extension_servicios",
      str_detect(institution, "MDRyT")           ~ "administracion_general",
      !is.na(spending_category)                  ~ spending_category,
      TRUE                                        ~ "otros"
    )
  )

# ── 6. Control de calidad ─────────────────────────────────────────────────────
cat("\n=== Control de calidad ===\n")
cat("Años con datos:", paste(sort(unique(spending_classified$year)), collapse=", "), "\n")
cat("Instituciones:", n_distinct(spending_classified$institution), "\n")
cat("Categorías de gasto:\n")
print(count(spending_classified, spending_category, sort = TRUE))
cat("Tasa de ejecución promedio:", round(mean(spending_classified$exec_rate, na.rm=TRUE)*100, 1), "%\n")

# ── 7. Guardar ────────────────────────────────────────────────────────────────
saveRDS(spending_classified, file.path(DIR_DATA_PRO, "spending_clean.rds"))
cat(glue::glue("\nspending_clean.rds guardado: {nrow(spending_classified)} obs\n"))
