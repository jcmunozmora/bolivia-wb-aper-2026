library(data.table)
library(tidyverse)

here_root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc_dir  <- file.path(here_root, "01_data/processed")
ext_dir   <- file.path(here_root, "01_data/external")
wdi_dir   <- file.path(here_root, "01_data/raw/wdi")

cat("=== Construyendo Panel Maestro Bolivia 2000-2023 ===\n\n")

# ── 1. Deflactores y tipo de cambio ──────────────────────────────────────────
defl <- fread(file.path(ext_dir, "inflation_deflators.csv"))
xr   <- fread(file.path(ext_dir, "exchange_rates.csv"))
deflators <- merge(defl, xr, by = "year", all = TRUE)

base_2015_cpi <- deflators[year == 2015, cpi_index]
deflators[, cpi_2015base := cpi_index / base_2015_cpi * 100]
cat("Deflactores: años", min(deflators$year), "a", max(deflators$year), "\n")

# ── 2. WDI Bolivia ────────────────────────────────────────────────────────────
wdi_file <- file.path(wdi_dir, "wdi_bolivia.csv")
if (file.exists(wdi_file)) {
  wdi <- fread(wdi_file)
  cat("WDI Bolivia:", nrow(wdi), "obs x", ncol(wdi), "vars\n")
} else {
  cat("wdi_bolivia.csv no encontrado — creando placeholder\n")
  wdi <- data.table(year = 2000:2023)
}

# ── 3. Gasto agropecuario APER (1996-2008) ─────────────────────────────────
aper_total <- fread(file.path(proc_dir, "aper_total_national.csv"))
setnames(aper_total, "agro_spend_bob", "agro_spend_bob_current_aper")

aper_panel <- merge(aper_total, deflators[, .(year, cpi_2015base, bob_per_usd)],
                    by = "year", all.x = TRUE)
aper_panel[, agro_spend_bob_2015 := agro_spend_bob_current_aper / (cpi_2015base / 100)]
aper_panel[, agro_spend_usd      := agro_spend_bob_current_aper / bob_per_usd]
aper_panel[, agro_spend_usd_2015 := agro_spend_bob_2015 / bob_per_usd]

cat("\nAPER spending deflactado (2000-2008):\n")
print(aper_panel[year >= 2000, .(year, agro_spend_bob_current_aper,
                                  agro_spend_bob_2015, agro_spend_usd_2015)])

# ── 4. Gasto APER por categoría (wide) ───────────────────────────────────────
aper_cat <- readRDS(file.path(proc_dir, "aper_national_panel.rds"))
setDT(aper_cat)
aper_wide <- dcast(aper_cat[year >= 2000],
                   year ~ spending_category,
                   value.var = "budget_executed", fun.aggregate = sum, fill = 0L)
setnames(aper_wide, setdiff(names(aper_wide), "year"),
         paste0("spend_", setdiff(names(aper_wide), "year")))

# ── 5. Agricultural outcomes (Our World in Data) ─────────────────────────────
owid_files <- list.files(file.path(here_root, "01_data/raw/faostat"),
                         pattern = "*.csv", full.names = TRUE)
if (length(owid_files) > 0) {
  cat("\nArchivos OWID/FAOSTAT encontrados:", length(owid_files), "\n")
  # Intentar leer el de cereal yield si existe
  cyield_file <- grep("cereal|yield|crop", owid_files, value = TRUE, ignore.case = TRUE)
  if (length(cyield_file) > 0) {
    cyield <- fread(cyield_file[1])
    cat("  Cereal yield file:", basename(cyield_file[1]), "\n")
  }
}

# ── 6. Construir panel base ───────────────────────────────────────────────────
panel_years <- data.table(year = 2000:2023)

panel <- merge(panel_years, deflators, by = "year", all.x = TRUE)
panel <- merge(panel, as.data.table(wdi), by = "year", all.x = TRUE)
panel <- merge(panel,
               aper_panel[, .(year, agro_spend_bob_current_aper,
                               agro_spend_bob_2015, agro_spend_usd, agro_spend_usd_2015)],
               by = "year", all.x = TRUE)
panel <- merge(panel, aper_wide, by = "year", all.x = TRUE)

# ── 7. Variables derivadas ────────────────────────────────────────────────────
# GDP corriente en BOB (si existe en WDI)
if ("gdp_current_usd" %in% names(panel)) {
  panel[, gdp_current_bob  := gdp_current_usd * bob_per_usd]
  panel[, gdp_bob_2015     := gdp_current_bob / (cpi_2015base / 100)]
  panel[, agro_spend_pct_gdp := (agro_spend_usd_2015 / gdp_current_usd) * 100]
}

# GDP agropecuario en USD corrientes (% PIB × PIB total)
if (all(c("agr_value_added_pct_gdp", "gdp_current_usd") %in% names(panel))) {
  panel[, agr_gdp_usd := (agr_value_added_pct_gdp / 100) * gdp_current_usd]
}

# Log-transformaciones
log_vars <- c("agro_spend_bob_2015", "agro_spend_usd_2015", "gdp_current_usd",
              "cereal_yield_kg_ha", "agr_gdp_usd", "agr_food_prod_index")
for (v in log_vars) {
  if (v %in% names(panel)) {
    panel[get(v) > 0, paste0("ln_", v) := log(get(v))]
  }
}

panel <- panel[order(year)]

# ── 8. Resumen ────────────────────────────────────────────────────────────────
cat("\n=== Panel Maestro Bolivia ===\n")
cat("Período: 2000-2023 |", nrow(panel), "años |", ncol(panel), "variables\n\n")

vars_check <- list(
  "Gasto agropecuario (BOB 2015)" = "agro_spend_bob_2015",
  "Gasto agropecuario (USD 2015)" = "agro_spend_usd_2015",
  "Gasto agrop % PIB"             = "agro_spend_pct_gdp",
  "PIB per cápita USD"            = "gdp_per_capita_usd",
  "PIB agrop % PIB"               = "agr_value_added_pct_gdp",
  "Rendimiento cereales (kg/ha)"  = "cereal_yield_kg_ha",
  "Subalimentación (%)"           = "undernourishment_pct",
  "Empleo agrícola (%)"           = "agr_employment_pct",
  "Población rural (%)"           = "rural_pop_pct",
  "Índice prod. alimentos"        = "agr_food_prod_index",
  "CPI base 2015"                 = "cpi_2015base",
  "Tipo cambio BOB/USD"           = "bob_per_usd"
)

for (label in names(vars_check)) {
  v    <- vars_check[[label]]
  ok   <- v %in% names(panel)
  n_ok <- if (ok) sum(!is.na(panel[[v]])) else 0
  years_ok <- if (ok && n_ok > 0) paste(range(panel[!is.na(get(v)), year]), collapse="-") else "—"
  cat(sprintf("  %-38s %s  %2d obs  %s\n",
              label, ifelse(ok, "OK ", "---"), n_ok, years_ok))
}

# ── 9. Guardar ────────────────────────────────────────────────────────────────
saveRDS(panel, file.path(proc_dir, "spending_panel.rds"))
readr::write_csv(panel, file.path(proc_dir, "spending_panel.csv"))
cat("\nspending_panel.rds y .csv guardados en", proc_dir, "\n")
cat("Columnas:", paste(names(panel), collapse=", "), "\n")
