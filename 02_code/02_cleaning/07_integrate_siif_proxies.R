# Integra al panel maestro las series SIIF-proxy recién extraídas:
# 1. Inversión pública ejecutada sector agropecuario (VIPFE) 1990-2024 en USD
# 2. EMAPA gasto en bienes y servicios 2008-2024 en BOB
# 3. Deuda pública por destino del crédito agropecuario/riego 2005-2022 en BOB
# 4. USDA TFP Bolivia 1961-2023
# 5. Datos WDI, APER originales

library(data.table)
library(tidyverse)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc_dir <- file.path(root, "01_data/processed")
ext_dir  <- file.path(root, "01_data/external")

# ── 1. Load all building blocks ───────────────────────────────────────────────
panel_prev <- readRDS(file.path(proc_dir, "spending_panel.rds"))
setDT(panel_prev)
cat("Panel previo:", nrow(panel_prev), "x", ncol(panel_prev), "\n")

inv_sect <- readRDS(file.path(proc_dir, "inversion_publica_sectorial_wide.rds"))
setDT(inv_sect)
cat("Inversión pública sectorial:", nrow(inv_sect), "obs\n")

deflators <- merge(
  fread(file.path(ext_dir, "inflation_deflators.csv")),
  fread(file.path(ext_dir, "exchange_rates.csv")), by = "year", all = TRUE
)
base_2015_cpi <- deflators[year == 2015, cpi_index]
deflators[, cpi_2015base := cpi_index / base_2015_cpi * 100]

# EMAPA
emapa_full <- readRDS(file.path(proc_dir, "informe_fiscal_2024_all_series.rds"))
setDT(emapa_full)
emapa <- emapa_full[entity == "EMAPA" & grepl("BIENES", title, ignore.case = TRUE),
                    .(year, emapa_bob_mm = value)]

# TFP
tfp_bol <- readRDS(file.path(proc_dir, "usda_tfp_bolivia.rds"))
setDT(tfp_bol)
setnames(tfp_bol, "Year", "year")
tfp_bol_cols <- tfp_bol[, .(year, tfp_index = TFP_Index,
                             tfp_output = Outall_Index,
                             tfp_input  = Input_Index)]

# ── 2. Build master panel 1990-2024 ───────────────────────────────────────────
years <- data.table(year = 1990:2024)

# Start with deflators
master <- merge(years, deflators, by = "year", all.x = TRUE)

# Add sectoral investment (USD mm → BOB mm using BOB/USD)
inv_cols <- c("year", "TOTAL", "Agropecuario", "PRODUCTIVOS",
              "Hidrocarburos", "INFRAESTRUCTURA", "SOCIALES",
              "MULTISECTORIALES", "agro_share_pct")
inv_sub <- inv_sect[, ..inv_cols]
setnames(inv_sub,
         c("TOTAL", "Agropecuario", "PRODUCTIVOS", "Hidrocarburos",
           "INFRAESTRUCTURA", "SOCIALES", "MULTISECTORIALES",
           "agro_share_pct"),
         c("inv_pub_total_usd_mm", "inv_agro_usd_mm",
           "inv_productivos_usd_mm", "inv_hidrocarb_usd_mm",
           "inv_infraestr_usd_mm", "inv_sociales_usd_mm",
           "inv_multisec_usd_mm", "inv_agro_pct_total"))
master <- merge(master, inv_sub, by = "year", all.x = TRUE)

# Convertir a BOB constantes 2015
master[, inv_agro_bob_mm_current := inv_agro_usd_mm * bob_per_usd]
master[, inv_agro_bob_mm_2015    := inv_agro_bob_mm_current / (cpi_2015base / 100)]

# Add EMAPA
master <- merge(master, emapa, by = "year", all.x = TRUE)
master[, emapa_bob_mm_2015 := emapa_bob_mm / (cpi_2015base / 100)]

# Add TFP
master <- merge(master, tfp_bol_cols, by = "year", all.x = TRUE)

# WDI indicators from previous panel
wdi_keep <- c("year", "agr_value_added_pct_gdp", "cereal_yield_kg_ha",
              "agr_food_prod_index", "undernourishment_pct",
              "agr_employment_pct", "rural_pop_pct", "gdp_current_usd",
              "gdp_per_capita_usd", "gdp_per_capita_const2015",
              "agr_gdp_usd")
wdi_keep <- intersect(wdi_keep, names(panel_prev))
master <- merge(master, panel_prev[, ..wdi_keep], by = "year", all.x = TRUE)

# APER spending 1996-2008 desde panel_prev
aper_cols <- grep("^agro_spend|^spend_", names(panel_prev), value = TRUE)
aper_sub <- panel_prev[, c("year", aper_cols), with = FALSE]
setnames(aper_sub, aper_cols, paste0("aper_", aper_cols))
master <- merge(master, aper_sub, by = "year", all.x = TRUE)

# ── 3. Derived series ────────────────────────────────────────────────────────
# Inversión pública agropecuaria como % del PIB
master[, inv_agro_pct_gdp := (inv_agro_usd_mm * 1e6) / gdp_current_usd * 100]

# Agricultural productivity-to-spending ratio
master[!is.na(tfp_index) & !is.na(inv_agro_bob_mm_2015),
       tfp_per_mbob := tfp_index / inv_agro_bob_mm_2015]

# Sort columns
setcolorder(master,
  c("year", "cpi_2015base", "bob_per_usd",
    "inv_agro_usd_mm", "inv_agro_bob_mm_current", "inv_agro_bob_mm_2015",
    "inv_agro_pct_gdp", "inv_agro_pct_total", "inv_pub_total_usd_mm",
    "emapa_bob_mm", "emapa_bob_mm_2015",
    "tfp_index", "tfp_output", "tfp_input",
    "agr_value_added_pct_gdp", "cereal_yield_kg_ha",
    "undernourishment_pct", "agr_employment_pct",
    "gdp_current_usd", "gdp_per_capita_usd"))

# ── 4. Summary ───────────────────────────────────────────────────────────────
cat("\n=== Panel Maestro v2 (1990-2024) ===\n")
cat("Filas:", nrow(master), "| Columnas:", ncol(master), "\n\n")

key <- list(
  "Inversión agropecuaria (USD mm)"    = "inv_agro_usd_mm",
  "Inversión agropecuaria (BOB 2015)"  = "inv_agro_bob_mm_2015",
  "Inversión agrop. % PIB"             = "inv_agro_pct_gdp",
  "Participación agrop. en inv. total" = "inv_agro_pct_total",
  "EMAPA gasto bienes y servicios"     = "emapa_bob_mm",
  "TFP Index (2015=100)"               = "tfp_index",
  "PIB agropecuario % PIB"             = "agr_value_added_pct_gdp",
  "Rendimiento cereales kg/ha"         = "cereal_yield_kg_ha",
  "Subalimentación %"                  = "undernourishment_pct",
  "PIB per cápita USD"                 = "gdp_per_capita_usd",
  "Gasto APER ejecutado (BOB 2015)"    = "aper_agro_spend_bob_2015"
)

for (label in names(key)) {
  v <- key[[label]]
  if (v %in% names(master)) {
    n_ok <- sum(!is.na(master[[v]]))
    yrs  <- if (n_ok > 0) paste(range(master[!is.na(get(v)), year]), collapse="-") else "—"
    cat(sprintf("  ✓ %-40s %2d obs  %s\n", label, n_ok, yrs))
  } else {
    cat(sprintf("  ✗ %-40s AUSENTE\n", label))
  }
}

# Save
saveRDS(master, file.path(proc_dir, "spending_panel_v2.rds"))
readr::write_csv(master, file.path(proc_dir, "spending_panel_v2.csv"))
cat("\nspending_panel_v2.rds guardado (1990-2024, 35 años).\n")

# Vista de la serie clave
cat("\n=== SERIE CLAVE: Inversión pública agropecuaria ejecutada ===\n")
print(master[, .(year, inv_agro_usd_mm, inv_agro_bob_mm_2015,
                 inv_agro_pct_gdp, aper_agro_spend_bob_2015)][order(year)])
