# Limpieza de datos de producción y desempeño agrícola
# Fuentes: FAOSTAT + WDI + INE Bolivia
# Output: 01_data/processed/agricultural_outcomes.rds
source(here::here("02_code", "00_setup", "01_constants.R"))
library(tidyverse)

fao_dir <- file.path(DIR_DATA_RAW, "faostat")
wdi_dir <- file.path(DIR_DATA_RAW, "wdi")

# ── 1. Producción por commodity (QCL) ────────────────────────────────────────
qcl <- readRDS(file.path(fao_dir, "qcl_bolivia.rds")) |>
  janitor::clean_names() |>
  filter(
    element %in% c("Area harvested", "Production", "Yield"),
    year %in% YEARS
  ) |>
  select(year, item, item_code, element, value, unit) |>
  pivot_wider(names_from = element, values_from = value) |>
  janitor::clean_names() |>
  rename(
    area_harvested_ha = area_harvested,
    production_tonnes = production,
    yield_kg_ha       = yield
  )

# ── 2. Precios al productor (PP) ──────────────────────────────────────────────
pp <- readRDS(file.path(fao_dir, "pp_bolivia.rds")) |>
  janitor::clean_names() |>
  filter(year %in% YEARS) |>
  select(year, item, item_code, value) |>
  rename(producer_price_usd_tonne = value)

prod_with_prices <- left_join(qcl, pp, by = c("year", "item", "item_code")) |>
  mutate(
    production_value_usd = production_tonnes * (producer_price_usd_tonne / 1000)
  )

# ── 3. Seguridad alimentaria (FS) ─────────────────────────────────────────────
fs <- readRDS(file.path(fao_dir, "food_security_bolivia.rds")) |>
  janitor::clean_names() |>
  filter(year %in% YEARS) |>
  select(year, item, value, unit) |>
  pivot_wider(names_from = item, values_from = value) |>
  janitor::clean_names()

# Renombrar indicadores clave de seguridad alimentaria
fs_clean <- fs |>
  rename_with(~case_when(
    str_detect(., "prevalence.*undernourish")   ~ "undernourishment_pct",
    str_detect(., "food_supply.*kcal")          ~ "food_supply_kcal_day",
    str_detect(., "protein_supply")             ~ "protein_supply_g_day",
    str_detect(., "dietary_energy.*adequacy")   ~ "dietary_energy_adequacy",
    str_detect(., "food_insecurity.*severe")    ~ "food_insecurity_severe_pct",
    str_detect(., "food_insecurity.*moderate")  ~ "food_insecurity_moderate_pct",
    TRUE ~ .
  ))

# ── 4. Balances alimentarios (FBS) ───────────────────────────────────────────
fbs <- readRDS(file.path(fao_dir, "food_balance_bolivia.rds")) |>
  janitor::clean_names() |>
  filter(
    year %in% YEARS,
    element %in% c("Food supply (kcal/capita/day)", "Protein supply quantity (g/capita/day)")
  ) |>
  select(year, item, element, value) |>
  pivot_wider(names_from = element, values_from = value)

# ── 5. WDI indicadores agropecuarios ─────────────────────────────────────────
wdi <- readRDS(file.path(wdi_dir, "wdi_bolivia.rds")) |>
  janitor::clean_names() |>
  filter(date %in% YEARS) |>
  rename(year = date) |>
  select(year, any_of(names(WDI_INDICATORS)))

# ── 6. Uso de tierra (FAOSTAT) ───────────────────────────────────────────────
lu <- readRDS(file.path(fao_dir, "land_use_bolivia.rds")) |>
  janitor::clean_names() |>
  filter(
    year %in% YEARS,
    element == "Area"
  ) |>
  select(year, item, value) |>
  pivot_wider(names_from = item, values_from = value) |>
  janitor::clean_names()

# ── 7. Agregar producción total (valor agregado agropecuario) ─────────────────
total_agr_value <- prod_with_prices |>
  group_by(year) |>
  summarise(
    total_production_value_usd = sum(production_value_usd, na.rm = TRUE),
    total_area_harvested_ha    = sum(area_harvested_ha, na.rm = TRUE),
    n_commodities              = n_distinct(item),
    .groups = "drop"
  )

# ── 8. Dataset maestro de outcomes ───────────────────────────────────────────
agr_outcomes <- total_agr_value |>
  left_join(wdi, by = "year") |>
  left_join(fs_clean, by = "year") |>
  arrange(year)

# ── 9. Control de calidad ─────────────────────────────────────────────────────
cat("=== agricultural_outcomes ===\n")
cat("Años:", paste(range(agr_outcomes$year), collapse="-"), "\n")
cat("Vars:", ncol(agr_outcomes), "\n")
cat("Missing por variable:\n")
agr_outcomes |>
  summarise(across(everything(), ~sum(is.na(.)))) |>
  pivot_longer(everything(), names_to = "var", values_to = "n_missing") |>
  filter(n_missing > 0) |>
  arrange(desc(n_missing)) |>
  print()

# ── 10. Guardar ───────────────────────────────────────────────────────────────
saveRDS(prod_with_prices, file.path(DIR_DATA_PRO, "production_by_commodity.rds"))
saveRDS(agr_outcomes,     file.path(DIR_DATA_PRO, "agricultural_outcomes.rds"))
cat("agricultural_outcomes.rds guardado\n")
