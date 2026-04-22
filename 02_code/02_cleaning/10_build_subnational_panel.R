# Construye panel SUBNACIONAL Bolivia 9 depts × 10 años 2012-2021
# =============================================================================
# Usa el scraping de Jubileo departamental + datos subnacionales ya disponibles:
#   - jubileo_departamental_2012_2021.rds (9 depts × 31 programas × 10 años)
#   - pib_departamental_agro.rds (2017-2021, INE Ref 2017)
#   - mefp_deuda_destino_long.rds (deuda rural por depto 2005-2022)
#   - aper_dept_panel.rds (1996-2008 APER)
#
# Output: 01_data/processed/subnacional_panel.rds
#   Panel dept-año con: gasto por categoría + PIB agrop + outcomes
#   Listo para DEA + regresiones panel FE
# =============================================================================

library(data.table)
library(stringr)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc_dir <- file.path(root, "01_data/processed")

# ─── 1. Jubileo departamental ────────────────────────────────────────────────
jubileo_d <- readRDS(file.path(proc_dir, "jubileo_departamental_2012_2021.rds"))
setDT(jubileo_d)

# Normalizar nombres de depts a MAYÚSCULAS (para join con otras fuentes)
jubileo_d[, dept_upper := toupper(dept)]
jubileo_d[dept == "La Paz",    dept_upper := "LA PAZ"]
jubileo_d[dept == "Santa Cruz", dept_upper := "SANTA CRUZ"]

# Categorías agropecuarias/rurales
AGRO_STRICT   <- c("10", "12", "32")                   # Agrop directo + riego + agua
RURAL_INFRA   <- c("14", "15", "17", "18", "19")       # Aseo, electrif, infra, caminos, catastro
RURAL_TOTAL   <- c(AGRO_STRICT, RURAL_INFRA, "13", "35")  # + medio ambiente + desarrollo económico

# Helper: sumar gasto por categoría
sum_programs <- function(dt, codes, label) {
  dt[program_code %in% codes,
     .(value = sum(total_bob, na.rm = TRUE)),
     by = .(dept_upper, year)][, category := label][]
}

agg_data <- rbind(
  sum_programs(jubileo_d, c("10"),        "p10_agropecuario_bob"),
  sum_programs(jubileo_d, AGRO_STRICT,    "agro_strict_bob"),
  sum_programs(jubileo_d, RURAL_INFRA,    "rural_infra_bob"),
  sum_programs(jubileo_d, RURAL_TOTAL,    "rural_total_bob")
)
jub_dept_wide <- dcast(agg_data, dept_upper + year ~ category, value.var = "value")

# Agregar desglose Corriente/Inversión para Programa 10 específicamente
p10_detail <- jubileo_d[program_code == "10",
  .(p10_corriente_bob = corriente_bob,
    p10_inversion_bob = inversion_bob),
  by = .(dept_upper, year)]
jub_dept_wide <- merge(jub_dept_wide, p10_detail,
                       by = c("dept_upper", "year"), all.x = TRUE)

cat("=== Panel Jubileo departamental ===\n")
cat("Dimensiones:", nrow(jub_dept_wide), "×", ncol(jub_dept_wide), "\n")
cat("Depts:", length(unique(jub_dept_wide$dept_upper)), "\n")
cat("Años:", paste(range(jub_dept_wide$year), collapse = "-"), "\n\n")

# ─── 2. PIB Departamental (INE Ref 2017) ──────────────────────────────────────
pib_d <- readRDS(file.path(proc_dir, "pib_departamental_agro.rds"))
setDT(pib_d)
pib_d <- pib_d[dept != "BOLIVIA"]
setnames(pib_d, c("pib_agro_bob_chain2017", "pib_total_bob_chain2017", "agro_pct_gdp"),
         c("pib_agrop_bob_2017_mm", "pib_total_bob_2017_mm", "pib_agrop_pct_gdp"))
pib_d[, dept_upper := dept]

# ─── 3. APER departamental (1996-2008) — opcional para pre-2012 ─────────────
aper_d <- readRDS(file.path(proc_dir, "aper_dept_panel.rds"))
setDT(aper_d)
# Normalizar nombres
aper_d[, dept_upper := toupper(dept_name_clean)]
aper_d[dept_upper == "LA PAZ",     dept_upper := "LA PAZ"]
aper_d[dept_upper == "SANTA CRUZ", dept_upper := "SANTA CRUZ"]
aper_d[dept_upper == "POTOSÍ",     dept_upper := "POTOSÍ"]

aper_annual <- aper_d[, .(aper_dept_exec_bob = sum(budget_executed, na.rm = TRUE)),
                      by = .(dept_upper, year)]

# ─── 4. MEFP deuda rural por depto 2005-2022 ──────────────────────────────────
deuda <- readRDS(file.path(proc_dir, "mefp_deuda_destino_long.rds"))
setDT(deuda)
deuda[, dept_upper := toupper(dept)]
deuda[dept == "La Paz",    dept_upper := "LA PAZ"]
deuda[dept == "Santa Cruz", dept_upper := "SANTA CRUZ"]
deuda[dept == "Potosí",    dept_upper := "POTOSÍ"]

deuda_agg <- deuda[destino %in% c("AGROPECUARIO", "RIEGO", "CAMINOS"),
                   .(deuda_rural_mm_bob = sum(deuda_mm_bob, na.rm = TRUE)),
                   by = .(dept_upper, year)]

# ─── 5. Merge — panel dept × año completo ────────────────────────────────────
# Base: 9 depts × 10 años = 90 filas
depts <- unique(jub_dept_wide$dept_upper)
years <- 2012:2021
panel <- CJ(dept_upper = depts, year = years)

panel <- merge(panel, jub_dept_wide,  by = c("dept_upper", "year"), all.x = TRUE)
panel <- merge(panel, pib_d[, .(dept_upper, year,
                                 pib_agrop_bob_2017_mm,
                                 pib_total_bob_2017_mm,
                                 pib_agrop_pct_gdp)],
               by = c("dept_upper", "year"), all.x = TRUE)
panel <- merge(panel, deuda_agg, by = c("dept_upper", "year"), all.x = TRUE)

# Convertir Jubileo a millones BOB
for (v in c("p10_agropecuario_bob", "agro_strict_bob",
            "rural_infra_bob", "rural_total_bob",
            "p10_corriente_bob", "p10_inversion_bob")) {
  if (v %in% names(panel)) {
    panel[, (paste0(sub("_bob$", "", v), "_bob_mm")) := get(v) / 1e6]
  }
}

# Deflactores
deflators <- fread(file.path(root, "01_data/external/inflation_deflators.csv"))
xr <- fread(file.path(root, "01_data/external/exchange_rates.csv"))
deflators <- merge(deflators, xr, by = "year", all = TRUE)
base_2015_cpi <- deflators[year == 2015, cpi_index]
deflators[, cpi_2015base := cpi_index / base_2015_cpi * 100]

panel <- merge(panel, deflators[, .(year, cpi_2015base, bob_per_usd)],
               by = "year", all.x = TRUE)

# Valores reales (BOB 2015)
for (v in c("p10_agropecuario_bob_mm", "agro_strict_bob_mm",
            "rural_infra_bob_mm", "rural_total_bob_mm")) {
  if (v %in% names(panel)) {
    panel[, (paste0(sub("_mm$", "", v), "_mm_2015")) :=
            get(v) / (cpi_2015base / 100)]
  }
}

# Variables derivadas
panel[, p10_agropecuario_bob_per_capita_farmers_proxy :=
        p10_agropecuario_bob_mm * 1e6 / pmax(1, pib_agrop_bob_2017_mm)]

# ─── 6. Resumen y guardado ───────────────────────────────────────────────────
cat("=== Panel Subnacional Final ===\n")
cat("Dimensiones:", nrow(panel), "×", ncol(panel), "\n")
cat("Depts:", length(unique(panel$dept_upper)), "\n")
cat("Años:", paste(range(panel$year), collapse = "-"), "\n\n")

cat("=== Completitud por variable clave ===\n")
key_vars <- list(
  "P10 Agropecuario (BOB mm)"     = "p10_agropecuario_bob_mm",
  "Agro estricto (10+12+32)"      = "agro_strict_bob_mm",
  "Rural infra (14-19)"           = "rural_infra_bob_mm",
  "Rural total (10+...+35)"       = "rural_total_bob_mm",
  "PIB agropecuario BOB 2017"     = "pib_agrop_bob_2017_mm",
  "PIB agrop % PIB"               = "pib_agrop_pct_gdp",
  "Deuda rural (stock)"           = "deuda_rural_mm_bob"
)
for (label in names(key_vars)) {
  v <- key_vars[[label]]
  if (v %in% names(panel)) {
    n_ok <- sum(!is.na(panel[[v]]))
    cat(sprintf("  %-30s %d/90 obs\n", label, n_ok))
  }
}

cat("\n=== Top 5 depts 2021 — Agro estricto (10+12+32) ===\n")
print(panel[year == 2021][order(-agro_strict_bob_mm),
  .(dept_upper, agro_strict_bob_mm, rural_total_bob_mm,
    p10_agropecuario_bob_mm)])

# Guardar
saveRDS(panel, file.path(proc_dir, "subnacional_panel.rds"))
fwrite(panel, file.path(proc_dir, "subnacional_panel.csv"))
cat("\n✓ Guardado: subnacional_panel.{rds,csv} —", nrow(panel), "filas ×",
    ncol(panel), "variables\n")
