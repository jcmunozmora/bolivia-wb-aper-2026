# Análisis PSE (Producer Support Estimates) — Metodología OCDE adaptada
# Bolivia NO es miembro OCDE; PSE calculado desde datos nacionales
# Output: 01_data/processed/pse_estimates.rds
source(here::here("02_code", "00_setup", "01_constants.R"))
source(here::here("02_code", "00_setup", "02_functions.R"))
library(tidyverse)

prod_data    <- readRDS(file.path(DIR_DATA_PRO, "production_by_commodity.rds"))
spending     <- readRDS(file.path(DIR_DATA_PRO, "spending_clean.rds"))
gdp          <- readRDS(file.path(DIR_DATA_PRO, "gdp_bolivia.rds"))
oecd_pse_lac <- readRDS(file.path(DIR_DATA_RAW, "oecd_pse", "pse_latam_oecd.rds"))

# ── COMPONENTE 1: Market Price Support (MPS) ─────────────────────────────────
# MPS = (Precio doméstico - Precio frontera) × Cantidad producida
# Fuentes: Precio doméstico = FAOSTAT PP; Precio frontera = precio CIF/FOB Bolivia

# Nota: El precio frontera de referencia requiere datos de comercio exterior
# Para soya (principal commodity exportable):
#   Precio referencia = precio FOB Puerto Suárez / Rosario (mercados regionales)
# Para trigo/maíz importados:
#   Precio referencia = precio CIF La Paz

mps_by_commodity <- prod_data |>
  filter(item_code %in% COMMODITIES_FAO_CODES) |>
  group_by(year, item, item_code) |>
  summarise(
    production_tonnes       = sum(production_tonnes, na.rm = TRUE),
    producer_price_usd_t    = mean(producer_price_usd_tonne, na.rm = TRUE),
    production_value_usd    = sum(production_value_usd, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(
    # Placeholder: el precio frontera debe completarse con datos de comercio exterior
    # Referencia: precios UNCTAD/COMTRADE para cada commodity
    border_price_usd_t = NA_real_,  # TODO: completar con datos de comercio

    # MPS = (precio doméstico - precio frontera) × producción
    # Cuando precio doméstico > precio frontera → MPS positivo (protección al productor)
    # Cuando precio doméstico < precio frontera → MPS negativo (impuesto implícito)
    mps_per_tonne_usd  = producer_price_usd_t - border_price_usd_t,
    mps_total_usd      = mps_per_tonne_usd * production_tonnes
  )

# ── COMPONENTE 2: Transferencias presupuestales a productores (BT) ────────────
# Clasifica el gasto público según quién recibe el beneficio
bt_producers <- spending |>
  filter(spending_category %in% c(
    "subsidios_precios",      # EMAPA: precios piso → transferencia a productores
    "credito_subsidiado",     # BDP: diferencial de tasa de interés
    "investigacion_extension" # Parcial: beneficio al productor
  )) |>
  group_by(year, spending_category) |>
  summarise(
    bt_usd = sum(executed_usd, na.rm = TRUE),
    .groups = "drop"
  )

bt_total <- bt_producers |>
  group_by(year) |>
  summarise(total_bt_usd = sum(bt_usd, na.rm = TRUE), .groups = "drop")

# ── COMPONENTE 3: General Services Support Estimate (GSSE) ───────────────────
# Gasto que beneficia al sector en general (bienes públicos)
gsse_by_category <- spending |>
  filter(spending_category %in% c(
    "investigacion_extension",  # INIAF: I+D, semillas, extensión
    "sanidad_inocuidad",        # SENASAG: sanidad animal/vegetal
    "riego_agua",               # MMAyA: infraestructura de riego
    "tierra_titulacion",        # INRA: administración de tierras
    "administracion_general"    # MDRyT: planificación y gestión sectorial
  )) |>
  group_by(year, spending_category) |>
  summarise(
    gsse_usd = sum(executed_usd, na.rm = TRUE),
    .groups = "drop"
  )

gsse_total <- gsse_by_category |>
  group_by(year) |>
  summarise(total_gsse_usd = sum(gsse_usd, na.rm = TRUE), .groups = "drop")

# ── ENSAMBLE PSE ─────────────────────────────────────────────────────────────
agr_value <- prod_data |>
  group_by(year) |>
  summarise(
    total_production_value_usd = sum(production_value_usd, na.rm = TRUE),
    .groups = "drop"
  )

pse_estimates <- bt_total |>
  left_join(gsse_total, by = "year") |>
  left_join(agr_value,  by = "year") |>
  left_join(gdp |> select(year, gdp_current_usd), by = "year") |>
  mutate(
    # PSE = MPS + BT (aquí solo BT por falta de datos de precios frontera)
    pse_usd = total_bt_usd,  # completar con MPS cuando disponible

    # Total Support Estimate = PSE + GSSE
    tse_usd = pse_usd + total_gsse_usd,

    # Métricas normalizadas (como % del valor de producción)
    pse_pct   = pse_usd / total_production_value_usd * 100,
    gsse_pct  = total_gsse_usd / total_production_value_usd * 100,
    tse_pct   = tse_usd / total_production_value_usd * 100,

    # Como % del PIB
    tse_pct_gdp = tse_usd / gdp_current_usd * 100,

    # Ratio GSSE/TSE: qué tan orientado está el apoyo a bienes públicos
    # Un ratio alto indica apoyo más eficiente (evidencia OCDE)
    gsse_tse_ratio = total_gsse_usd / tse_usd
  )

# ── Comparación con LAC-OCDE ──────────────────────────────────────────────────
# Extraer %PSE de países OCDE para comparación
# Los datos OECD PSE ya descargados en 03_download_oecd.R
if (file.exists(file.path(DIR_DATA_RAW, "oecd_pse", "pse_latam_oecd.rds"))) {
  pse_oecd <- oecd_pse_lac |>
    filter(
      INDICATOR == "PSE",    # ajustar según estructura del dataset MON2023
      TIME >= YEAR_START,
      TIME <= YEAR_END
    ) |>
    select(country = COUNTRY, year = TIME, pse_pct_oecd = obsValue)

  pse_comparison <- pse_estimates |>
    select(year, pse_pct, gsse_tse_ratio) |>
    mutate(country = "BOL") |>
    bind_rows(
      pse_oecd |>
        filter(country %in% c("CHL", "COL", "BRA")) |>
        mutate(gsse_tse_ratio = NA_real_,
               pse_pct = as.numeric(pse_pct_oecd)) |>
        select(year, pse_pct, gsse_tse_ratio, country)
    )
  saveRDS(pse_comparison, file.path(DIR_DATA_PRO, "pse_comparison_lac.rds"))
}

# ── Guardar ───────────────────────────────────────────────────────────────────
saveRDS(pse_estimates, file.path(DIR_DATA_PRO, "pse_estimates.rds"))

cat("\n=== PSE Bolivia ===\n")
print(pse_estimates |> select(year, pse_usd, gsse_usd=total_gsse_usd,
                               tse_usd, pse_pct, gsse_tse_ratio) |>
        mutate(across(where(is.numeric), ~round(., 3))) |>
        tail(10))

cat("\nNOTA: MPS pendiente de datos de precios frontera (ver 06_manual_sources.md)\n")
