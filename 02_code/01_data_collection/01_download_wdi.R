# Descarga de indicadores WDI via wbstats
# Output: 01_data/raw/wdi/wdi_bolivia.rds  y  wdi_latam.rds
source(here::here("02_code", "00_setup", "01_constants.R"))
library(wbstats)
library(tidyverse)

# ── Bolivia ───────────────────────────────────────────────────────────────────
cat("Descargando WDI para Bolivia...\n")

wdi_bol <- wb_data(
  indicator   = WDI_INDICATORS,
  country     = COUNTRY_ISO3,
  start_date  = YEAR_START,
  end_date    = YEAR_END,
  return_wide = TRUE
)

# ── Comparadores LAC ──────────────────────────────────────────────────────────
cat("Descargando WDI para LAC...\n")

wdi_latam <- wb_data(
  indicator   = WDI_INDICATORS,
  country     = LATAM_ISO3,
  start_date  = YEAR_START,
  end_date    = YEAR_END,
  return_wide = TRUE
)

# Indicadores adicionales para contexto macroeconómico
extra_indicators <- c(
  total_govt_exp_pct_gdp   = "GC.XPN.TOTL.GD.ZS",
  agr_govt_exp_pct_gdp     = "ER.H2O.FWTL.ZS",   # placeholder — ver nota
  rural_access_electricity = "EG.ELC.ACCS.RU.ZS",
  roads_paved_pct          = "IS.ROD.PAVE.ZS",
  mobile_subscriptions     = "IT.CEL.SETS.P2"
)
# Nota: WB no publica gasto público en agricultura directamente en WDI;
# usar BOOST/SIIF para esta variable. Los indicadores aquí son de contexto.

wdi_extra <- wb_data(
  indicator   = extra_indicators,
  country     = c(COUNTRY_ISO3, LATAM_ISO3),
  start_date  = YEAR_START,
  end_date    = YEAR_END,
  return_wide = TRUE
)

# ── Guardar ───────────────────────────────────────────────────────────────────
out_dir <- file.path(DIR_DATA_RAW, "wdi")

saveRDS(wdi_bol,   file.path(out_dir, "wdi_bolivia.rds"))
saveRDS(wdi_latam, file.path(out_dir, "wdi_latam.rds"))
saveRDS(wdi_extra, file.path(out_dir, "wdi_extra.rds"))

# ── Metadata ──────────────────────────────────────────────────────────────────
wb_indicators_meta <- wb_indicators(indicator = c(WDI_INDICATORS, extra_indicators))
saveRDS(wb_indicators_meta, file.path(out_dir, "wdi_metadata.rds"))

cat(glue::glue(
  "WDI descargado: {nrow(wdi_bol)} obs Bolivia | ",
  "{nrow(wdi_latam)} obs LAC | Fecha: {Sys.Date()}\n"
))
