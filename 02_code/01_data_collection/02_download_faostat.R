# Descarga de datos FAOSTAT via FAOSTAT package
# Output: 01_data/raw/faostat/
source(here::here("02_code", "00_setup", "01_constants.R"))
library(FAOSTAT)
library(tidyverse)

out_dir <- file.path(DIR_DATA_RAW, "faostat")

# ── QCL: Producción cultivos y ganadería ─────────────────────────────────────
cat("Descargando QCL (producción)...\n")
qcl <- get_faostat_bulk(code = "QCL", data_folder = out_dir)
qcl_bol <- qcl |>
  filter(
    Area.Code == COUNTRY_FAO,
    Item.Code %in% COMMODITIES_FAO_CODES,
    Year %in% YEARS
  )
saveRDS(qcl_bol, file.path(out_dir, "qcl_bolivia.rds"))

# ── PP: Precios al productor ──────────────────────────────────────────────────
cat("Descargando PP (precios productor)...\n")
pp <- get_faostat_bulk(code = "PP", data_folder = out_dir)
pp_bol <- pp |>
  filter(
    Area.Code == COUNTRY_FAO,
    Item.Code %in% COMMODITIES_FAO_CODES,
    Year %in% YEARS
  )
saveRDS(pp_bol, file.path(out_dir, "pp_bolivia.rds"))

# ── TM: Comercio de mercancías ────────────────────────────────────────────────
cat("Descargando TM (comercio)...\n")
tm <- get_faostat_bulk(code = "TCL", data_folder = out_dir)
tm_bol <- tm |>
  filter(Reporter.Country.Code == COUNTRY_FAO, Year %in% YEARS)
saveRDS(tm_bol, file.path(out_dir, "trade_bolivia.rds"))

# ── FS: Suite de seguridad alimentaria ───────────────────────────────────────
cat("Descargando FS (seguridad alimentaria)...\n")
fs <- get_faostat_bulk(code = "FS", data_folder = out_dir)
fs_bol <- fs |>
  filter(Area.Code == COUNTRY_FAO, Year %in% YEARS)
saveRDS(fs_bol, file.path(out_dir, "food_security_bolivia.rds"))

# Suite LAC para comparadores
fs_latam_codes <- c(29, 130, 40, 44, 21, 63, 166, 8)  # BOL,PER,CHL,COL,BRA,ECU,PRY,ARG
fs_latam <- fs |>
  filter(Area.Code %in% fs_latam_codes, Year %in% YEARS)
saveRDS(fs_latam, file.path(out_dir, "food_security_latam.rds"))

# ── RFN: Fertilizantes ───────────────────────────────────────────────────────
cat("Descargando RFN (fertilizantes)...\n")
rfn <- get_faostat_bulk(code = "RFN", data_folder = out_dir)
rfn_bol <- rfn |> filter(Area.Code == COUNTRY_FAO, Year %in% YEARS)
saveRDS(rfn_bol, file.path(out_dir, "fertilizers_bolivia.rds"))

# ── FBS: Balances Alimentarios ────────────────────────────────────────────────
cat("Descargando FBS (food balance sheets)...\n")
fbs <- get_faostat_bulk(code = "FBS", data_folder = out_dir)
fbs_bol <- fbs |> filter(Area.Code == COUNTRY_FAO, Year %in% YEARS)
saveRDS(fbs_bol, file.path(out_dir, "food_balance_bolivia.rds"))

# ── LU: Uso de la tierra ──────────────────────────────────────────────────────
cat("Descargando RL (uso de tierra)...\n")
lu <- get_faostat_bulk(code = "RL", data_folder = out_dir)
lu_bol <- lu |>
  filter(Area.Code == COUNTRY_FAO, Year %in% YEARS)
saveRDS(lu_bol, file.path(out_dir, "land_use_bolivia.rds"))

cat(glue::glue("FAOSTAT descargado para Bolivia. Fecha: {Sys.Date()}\n"))
