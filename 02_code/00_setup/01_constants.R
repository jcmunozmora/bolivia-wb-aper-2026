# Constantes globales del proyecto Bolivia WB
# Fuente de verdad para todos los scripts

# ── Períodos ──────────────────────────────────────────────────────────────────
YEAR_START      <- 2000
YEAR_END        <- 2023
YEAR_BASE       <- 2015       # año base para valores reales
YEARS           <- YEAR_START:YEAR_END

# ── Identificadores de país ───────────────────────────────────────────────────
COUNTRY_ISO3    <- "BOL"
COUNTRY_ISO2    <- "BO"
COUNTRY_FAO     <- 29         # área code FAOSTAT para Bolivia
COUNTRY_WB      <- "BO"       # código wbstats

# Comparadores LAC (para benchmarking PSE y gasto)
LATAM_ISO3      <- c("BOL", "PER", "CHL", "COL", "BRA", "ECU", "PRY", "ARG")
LATAM_OECD      <- c("CHL", "COL", "MEX", "CRI", "BRA")  # miembros/candidatos OCDE con PSE

# ── Moneda y deflactores ──────────────────────────────────────────────────────
CURRENCY        <- "BOB"      # Boliviano
CURRENCY_USD    <- "USD"
DEFLATOR_BASE   <- 2015       # CPI base = 2015

# ── Departamentos Bolivia ─────────────────────────────────────────────────────
DEPTS <- c(
  "Beni", "Chuquisaca", "Cochabamba", "La Paz",
  "Oruro", "Pando", "Potosí", "Santa Cruz", "Tarija"
)
N_DEPTS <- length(DEPTS)

# ── Clasificación COFOG para agricultura ─────────────────────────────────────
# Código COFOG 04.2: Agricultura, silvicultura, pesca y caza
COFOG_AGR       <- "04.2"
COFOG_AGR_CODES <- c("042", "0421", "0422", "0423", "0424", "0425", "04251", "04252")

# ── Commodities principales Bolivia ──────────────────────────────────────────
COMMODITIES_KEY <- c(
  "Soybeans", "Quinoa", "Potatoes", "Maize", "Wheat",
  "Rice", "Sugar cane", "Cattle", "Chickens"
)
COMMODITIES_FAO_CODES <- c(
  236,      # Soybeans
  92,       # Quinoa
  116,      # Potatoes
  56,       # Maize
  15,       # Wheat
  27,       # Rice, paddy
  156,      # Sugar cane
  866,      # Cattle
  1058      # Chickens
)

# ── Indicadores WDI ──────────────────────────────────────────────────────────
WDI_INDICATORS <- c(
  agr_value_added_pct_gdp  = "NV.AGR.TOTL.ZS",
  agr_food_prod_index      = "AG.PRD.FOOD.XD",
  agr_employment_pct       = "SL.AGR.EMPL.ZS",
  undernourishment_pct     = "SN.ITK.DEFC.ZS",
  cereal_yield_kg_ha       = "AG.YLD.CREL.KG",
  agr_land_pct             = "AG.LND.AGRI.ZS",
  rural_pop_pct            = "SP.RUR.TOTL.ZS",
  gdp_per_capita_usd       = "NY.GDP.PCAP.CD",
  gdp_per_capita_const2015 = "NY.GDP.PCAP.KD",
  gdp_deflator             = "NY.GDP.DEFL.ZS",
  inflation_cpi            = "FP.CPI.TOTL.ZG",
  rural_poverty_gap        = "SI.POV.RUGP"
)

# ── Rutas de archivos ─────────────────────────────────────────────────────────
DIR_ROOT     <- here::here()
DIR_DATA_RAW <- file.path(DIR_ROOT, "01_data", "raw")
DIR_DATA_PRO <- file.path(DIR_ROOT, "01_data", "processed")
DIR_DATA_EXT <- file.path(DIR_ROOT, "01_data", "external")
DIR_CODE     <- file.path(DIR_ROOT, "02_code")
DIR_LIT      <- file.path(DIR_ROOT, "03_literature")
DIR_FIGS     <- file.path(DIR_ROOT, "05_outputs", "figures")
DIR_TABLES   <- file.path(DIR_ROOT, "05_outputs", "tables")
