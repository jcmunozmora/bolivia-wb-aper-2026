# Procesamiento datos WB BOOST Bolivia
# Fuente: https://boost.worldbank.org/country/bolivia
# Los datos BOOST se descargan manualmente como Excel/CSV desde el portal
# Este script procesa los archivos ya descargados en 01_data/raw/boost/
source(here::here("02_code", "00_setup", "01_constants.R"))
source(here::here("02_code", "00_setup", "02_functions.R"))
library(readxl)
library(tidyverse)

boost_dir <- file.path(DIR_DATA_RAW, "boost")
files <- list.files(boost_dir, pattern = "\\.(xlsx|xls|csv)$", full.names = TRUE)

if (length(files) == 0) {
  stop(
    "No se encontraron archivos BOOST en ", boost_dir, "\n",
    "Descarga manual requerida:\n",
    "  1. Ir a https://boost.worldbank.org/country/bolivia\n",
    "  2. Descargar dataset completo (Open Budgets)\n",
    "  3. Guardar en 01_data/raw/boost/"
  )
}

cat(glue::glue("Procesando {length(files)} archivo(s) BOOST...\n"))

# ── Leer y estandarizar ───────────────────────────────────────────────────────
read_boost_file <- function(path) {
  ext <- tools::file_ext(path)
  if (ext %in% c("xlsx", "xls")) {
    readxl::read_excel(path, guess_max = 10000)
  } else {
    readr::read_csv(path, show_col_types = FALSE, locale = readr::locale(encoding = "UTF-8"))
  }
}

boost_raw <- map(files, read_boost_file) |> bind_rows()

# ── Estandarizar nombres de columnas ─────────────────────────────────────────
boost_clean <- boost_raw |>
  janitor::clean_names() |>
  rename_with(~case_when(
    . == "year"         ~ "year",
    . == "adm1"         ~ "department",
    . == "func"         ~ "cofog_code",
    . == "econ"         ~ "economic_classifier",
    . == "org"          ~ "institution",
    . == "prog"         ~ "program",
    . == "executed"     ~ "executed",
    . == "approved"     ~ "approved",
    TRUE                ~ .
  )) |>
  filter(year %in% YEARS) |>
  mutate(
    year      = as.integer(year),
    executed  = as.numeric(executed),
    approved  = as.numeric(approved)
  )

# ── Filtrar agricultura (COFOG 04.2.x) ───────────────────────────────────────
boost_agr <- boost_clean |>
  filter(str_starts(cofog_code, "04.2") | str_starts(cofog_code, "042"))

# ── Clasificar por categoría de gasto ────────────────────────────────────────
cofog_table <- readr::read_csv(file.path(DIR_DATA_EXT, "cofog_classification.csv"),
                                show_col_types = FALSE)

boost_agr <- boost_agr |>
  left_join(cofog_table |> select(cofog_code, spending_category, spending_subcategory),
            by = "cofog_code")

# ── Agregar por año e institución ─────────────────────────────────────────────
spending_by_institution <- boost_agr |>
  group_by(year, institution, spending_category) |>
  summarise(
    executed_bob  = sum(executed, na.rm = TRUE),
    approved_bob  = sum(approved, na.rm = TRUE),
    exec_rate     = executed_bob / approved_bob,
    .groups = "drop"
  )

spending_by_dept <- boost_agr |>
  group_by(year, department, spending_category) |>
  summarise(
    executed_bob = sum(executed, na.rm = TRUE),
    .groups = "drop"
  )

spending_national <- boost_agr |>
  group_by(year, spending_category, economic_classifier) |>
  summarise(
    executed_bob = sum(executed, na.rm = TRUE),
    approved_bob = sum(approved, na.rm = TRUE),
    .groups = "drop"
  )

# ── Guardar ───────────────────────────────────────────────────────────────────
pro_dir <- file.path(DIR_DATA_RAW, "boost")
saveRDS(boost_agr,             file.path(pro_dir, "boost_agriculture_raw.rds"))
saveRDS(spending_by_institution, file.path(pro_dir, "spending_by_institution.rds"))
saveRDS(spending_by_dept,      file.path(pro_dir, "spending_by_department.rds"))
saveRDS(spending_national,     file.path(pro_dir, "spending_national.rds"))

cat(glue::glue(
  "BOOST procesado: {nrow(boost_agr)} líneas agropecuarias | ",
  "{n_distinct(boost_agr$year)} años | Fecha: {Sys.Date()}\n"
))
