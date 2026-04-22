# Deflactores, conversión monetaria y agregados macroeconómicos
# Output: 01_data/external/inflation_deflators.csv (verifica y completa)
#         01_data/external/exchange_rates.csv
source(here::here("02_code", "00_setup", "01_constants.R"))
library(wbstats)
library(tidyverse)

# ── 1. Deflactor PIB y CPI desde WDI ─────────────────────────────────────────
deflator_indicators <- c(
  gdp_deflator_idx   = "NY.GDP.DEFL.ZS.AD",  # GDP deflator (base variable)
  cpi_2010base       = "FP.CPI.TOTL",         # CPI index (2010=100)
  cpi_growth_pct     = "FP.CPI.TOTL.ZG"       # CPI inflation %
)

deflators_raw <- wb_data(
  indicator  = deflator_indicators,
  country    = COUNTRY_ISO3,
  start_date = YEAR_START,
  end_date   = YEAR_END
)

# Rebase CPI a 2015 = 100
cpi_raw <- deflators_raw |>
  select(year = date, cpi_2010base) |>
  filter(!is.na(cpi_2010base))

cpi_2015_value <- cpi_raw |> filter(year == DEFLATOR_BASE) |> pull(cpi_2010base)

deflators_clean <- deflators_raw |>
  select(year = date, gdp_deflator_idx, cpi_2010base, cpi_growth_pct) |>
  mutate(
    cpi_index     = cpi_2010base * (100 / cpi_2015_value),  # rebase a 2015=100
    gdp_deflator  = gdp_deflator_idx
  ) |>
  filter(year %in% YEARS) |>
  arrange(year)

# ── 2. Tipo de cambio BOB/USD (WDI + BCB) ────────────────────────────────────
xrate_raw <- wb_data(
  indicator  = c(official_xrate = "PA.NUS.FCRF"),
  country    = COUNTRY_ISO3,
  start_date = YEAR_START,
  end_date   = YEAR_END
)

xrates_clean <- xrate_raw |>
  select(year = date, bob_per_usd = official_xrate) |>
  filter(year %in% YEARS, !is.na(bob_per_usd)) |>
  arrange(year)

# ── 3. PIB total Bolivia (para calcular % PIB del gasto) ─────────────────────
gdp_raw <- wb_data(
  indicator = c(
    gdp_current_bob = "NY.GDP.MKTP.CN",   # PIB en moneda nacional corriente
    gdp_current_usd = "NY.GDP.MKTP.CD",   # PIB en USD corrientes
    gdp_const_usd   = "NY.GDP.MKTP.KD"    # PIB en USD constantes 2015
  ),
  country    = COUNTRY_ISO3,
  start_date = YEAR_START,
  end_date   = YEAR_END
)

gdp_clean <- gdp_raw |>
  select(year = date, gdp_current_bob, gdp_current_usd, gdp_const_usd) |>
  filter(year %in% YEARS) |>
  arrange(year)

# ── 4. PIB agropecuario (FAOSTAT value of production como proxy) ──────────────
# Nota: PIB agropecuario oficial viene de INE Bolivia (cuentas nacionales)
# Proxy FAO disponible inmediatamente para el análisis inicial

# ── 5. Guardar/actualizar archivos externos ───────────────────────────────────
readr::write_csv(deflators_clean, file.path(DIR_DATA_EXT, "inflation_deflators.csv"))
readr::write_csv(xrates_clean,    file.path(DIR_DATA_EXT, "exchange_rates.csv"))
saveRDS(gdp_clean,                file.path(DIR_DATA_PRO, "gdp_bolivia.rds"))

cat("=== Deflactores y tipo de cambio ===\n")
cat("CPI 2015 base year value (2010=100):", round(cpi_2015_value, 2), "\n")
cat("Tipo de cambio 2023:", round(tail(xrates_clean$bob_per_usd, 1), 2), "BOB/USD\n")
cat("Archivos guardados en", DIR_DATA_EXT, "\n")
