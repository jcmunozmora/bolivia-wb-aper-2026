# Procesa IDB Agrimonitor — PSE Bolivia 2006-2023 (metodología OCDE)
# CIERRA la tarea crítica "calcular PSE desde cero"

library(data.table)
library(tidyverse)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
raw_file <- file.path(root, "01_data/raw/idb_agrimonitor/idb-agrimonitor-producer-support-estimates-pse-agricultural-policy-monitori-2026-04-17-05-34/Agrimonitor Dataset/Agrimonitor Dataset.csv")
proc_dir <- file.path(root, "01_data/processed")

cat("Leyendo IDB Agrimonitor...\n")
d <- fread(raw_file)
setnames(d, names(d)[1], "id")

lac <- c("BO", "AR", "BR", "CL", "CO", "EC", "MX", "PE", "PY", "UY")
d_lac <- d[country_id %in% lac]
bol   <- d[country_id == "BO"]

# ── 1. Extraer series nacionales agregadas (commoditie = Group or Not Commodities) ─
extract_series <- function(bol_dt, desc, unit_filter = "BOBmn") {
  bol_dt[description == desc &
         unit == unit_filter &
         commoditie == "Group or Not Commodities",
         .(year, value)][order(year)]
}

# Core PSE indicators
indicators <- list(
  PSE_BOB_mm       = "Producer Support Estimate (PSE)",
  MPS_BOB_mm       = "Market Price Support (MPS)",
  GSSE_BOB_mm      = "General Services Support Estimate (GSSE)",
  CSE_BOB_mm       = "Consumer Support Estimate (CSE)",
  TSE_BOB_mm       = "Total Support Estimate (TSE)",
  GDP_BOB_mm       = "Gross Domestic Product (GDP), Current Prices"
)

series_list <- lapply(indicators, function(d) extract_series(bol, d, "BOBmn"))
pse_wide <- Reduce(function(a, b) merge(a, b, by = "year", all = TRUE),
                    Map(function(x, n) setnames(copy(x), "value", n),
                        series_list, names(indicators)))

# Percentages and ratios
for (pair in list(
  c("PSEP_pct",   "Percentage Producer Support Estimate (PSEP)",   "%"),
  c("GSSEP_pct",  "Percentage General Services Support Estimate (GSSEP)", "%"),
  c("TSEP_pct",   "Percentage Total Support Estimate (TSEP)",       "%"),
  c("CSEP_pct",   "Percentage Consumer Support Estimate (CSEP)",    "%"),
  c("NPC_producer", "Producer Nominal Protection Coefficient (producer NPC)", "ratio"),
  c("NAC_producer", "Producer Nominal Assistance Coefficient (producer NAC)", "ratio")
)) {
  tmp <- extract_series(bol, pair[2], pair[3])
  if (nrow(tmp) > 0) {
    setnames(tmp, "value", pair[1])
    pse_wide <- merge(pse_wide, tmp, by = "year", all = TRUE)
  }
}

# Value of production — needs special filter (parent1name Value of Prod)
vop <- bol[parent1name == "Value of Production (at farm gate)" &
           description == "Total Value of Production (at Farm Gate)" &
           unit == "BOBmn",
           .(year, VoP_total_BOB_mm = value)][order(year)]
if (nrow(vop) > 0) pse_wide <- merge(pse_wide, vop, by = "year", all = TRUE)

# ── 2. Convertir a USD con tipo de cambio del propio dataset ──────────────────
xr <- bol[description == "USD Exchange Rate" & unit == "BOB/USD",
          .(year, bob_per_usd = value)][order(year)]
pse_wide <- merge(pse_wide, xr, by = "year", all.x = TRUE)

for (v in c("PSE_BOB_mm", "MPS_BOB_mm", "GSSE_BOB_mm", "CSE_BOB_mm",
            "TSE_BOB_mm", "GDP_BOB_mm", "VoP_total_BOB_mm")) {
  if (v %in% names(pse_wide)) {
    v_usd <- sub("_BOB_mm", "_USD_mm", v)
    pse_wide[, (v_usd) := get(v) / bob_per_usd]
  }
}

# ── 3. Pivot PSCT por commodity ───────────────────────────────────────────────
psct <- bol[parent1name == "Producer Single Commodity Transfers (PSCT)" &
            description == "Producer Single Commodity Transfers (PSCT)" &
            unit == "BOBmn",
            .(year, commoditie, PSCT_BOB_mm = value)]
psct_wide <- dcast(psct, year ~ commoditie, value.var = "PSCT_BOB_mm")

# ── 4. Precios productor vs referencia por commodity ──────────────────────────
prices <- bol[description %in% c("Producer Price (at farm gate)",
                                  "Reference Price (at farm gate)") &
              unit == "BOB/t",
              .(year, commoditie, description, value)]
prices_wide <- dcast(prices, year + commoditie ~ description,
                     value.var = "value", fun.aggregate = mean)
if ("Producer Price (at farm gate)" %in% names(prices_wide)) {
  setnames(prices_wide,
           c("Producer Price (at farm gate)", "Reference Price (at farm gate)"),
           c("producer_price_BOB_t", "reference_price_BOB_t"))
  prices_wide[, price_gap_pct := (producer_price_BOB_t / reference_price_BOB_t - 1) * 100]
}

# ── 5. Budgetary Transfers — agregar por año (multicommodity) ─────────────────
bt <- bol[description == "Budgetary Transfers" & unit == "BOBmn",
          .(BT_BOB_mm_agg = sum(value, na.rm = TRUE)), by = year][order(year)]
pse_wide <- merge(pse_wide, bt, by = "year", all.x = TRUE)

# ── 6. Emisiones GHG agrícolas ────────────────────────────────────────────────
ghg <- bol[description == "Greenhouse Gas Emissions (GHG) by Agricultural Sector" &
           unit == "Gg CO2 e",
           .(year, commoditie, GHG_GgCO2e = value)]
ghg_total <- bol[description == "Greenhouse Gas Emissions (GHG) by Agricultural Sector" &
                 unit == "Gg CO2 e" & commoditie == "Group or Not Commodities",
                 .(year, GHG_total_GgCO2e = value)][order(year)]
pse_wide <- merge(pse_wide, ghg_total, by = "year", all.x = TRUE)

# ── 7. Resumen ─────────────────────────────────────────────────────────────────
cat("\n=== PSE Bolivia — series principales (BOB mm) ===\n")
print(pse_wide[, .(year, PSE_BOB_mm, MPS_BOB_mm, BT_BOB_mm_agg,
                    GSSE_BOB_mm, TSE_BOB_mm, CSE_BOB_mm,
                    PSEP_pct, NPC_producer)])

cat("\n=== PSCT por commodity 2020-2023 (BOB mm) ===\n")
print(psct_wide[year >= 2020])

cat("\n=== Brecha de precios — 2023 (%) ===\n")
print(prices_wide[year == 2023][order(-abs(price_gap_pct)),
  .(commoditie, producer_price_BOB_t, reference_price_BOB_t, price_gap_pct)])

cat("\n=== GHG emisiones agrícolas (Gg CO2 eq) ===\n")
print(ghg_total)

# ── 8. Guardar ─────────────────────────────────────────────────────────────────
saveRDS(pse_wide, file.path(proc_dir, "idb_pse_bolivia_aggregate.rds"))
saveRDS(psct_wide, file.path(proc_dir, "idb_psct_by_commodity.rds"))
saveRDS(prices_wide, file.path(proc_dir, "idb_prices_gap_bolivia.rds"))
saveRDS(ghg,      file.path(proc_dir, "idb_ghg_bolivia.rds"))
saveRDS(bol,      file.path(proc_dir, "idb_agrimonitor_bolivia_full.rds"))
saveRDS(d_lac,    file.path(proc_dir, "idb_agrimonitor_lac_full.rds"))

readr::write_csv(pse_wide, file.path(proc_dir, "idb_pse_bolivia_aggregate.csv"))
readr::write_csv(psct_wide, file.path(proc_dir, "idb_psct_by_commodity.csv"))
readr::write_csv(prices_wide, file.path(proc_dir, "idb_prices_gap_bolivia.csv"))

cat("\n=== Archivos guardados ===\n")
cat("  idb_pse_bolivia_aggregate.rds/csv\n")
cat("  idb_psct_by_commodity.rds/csv\n")
cat("  idb_prices_gap_bolivia.rds/csv\n")
cat("  idb_ghg_bolivia.rds\n")
cat("  idb_agrimonitor_bolivia_full.rds\n")
cat("  idb_agrimonitor_lac_full.rds\n")
