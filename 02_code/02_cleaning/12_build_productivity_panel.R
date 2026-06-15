# =============================================================================
# Construye el panel departamental de PRODUCTIVIDAD (insumo de §5.4 panel FE)
# -----------------------------------------------------------------------------
# Reemplaza el "TFP departamental" inexistente por medidas de productividad que
# SÍ son construibles a nivel depto × año con fuentes canónicas:
#   - prod_per_ha  : producción agrícola total (ton) / superficie cultivada (ha)
#                    => productividad de la tierra (NO es TFP multifactor:
#                       capital/trabajo solo existen en puntos censales).
#   - cereal_yield_kg_ha : rendimiento de cereales (robustez de un solo dominio)
#   - pib_agrop_bob_2017_mm : valor agregado agropecuario (robustez, 2017-2021)
#
# Insumos fiscales: DOS fuentes de gasto agropecuario subnacional (ADR-0018):
#   - MEFP municipal ejecutado (devengado), USD const. 2015, 2016-2024  ← LATEST
#   - Jubileo consolidado (estricto y rural amplio), BOB const. 2015, 2012-2021
# Covariable no controlable: precipitación CHIRPS departamental.
#
# Cobertura: gasto MEFP 2016-2024 (extiende 3 años más que Jubileo); INE
# producción/superficie 2012-2020; PIB agropecuario 2017-2021; pobreza INE
# hasta 2024 (se une en la regresión). Grid maestro depto×año 2012-2024.
#
# Fuentes (todas canónicas, vía DIR_DATA_PRO):
#   territorial_muni_mefp.rds         gasto agro municipal MEFP (USD2015) 2016-2024
#   subnacional_panel_v2.rds          gasto Jubileo estricto/rural + PIB agropecuario
#   ine_agro_stats_long.rds           producción + superficie por depto×año
#   cereal_yield_dept.rds             rendimiento de cereales por depto×año
#   chirps_dept_annual_complete.rds   precipitación por depto×año
#
# Output: 01_data/processed/subnacional_productivity_panel.rds (+ .csv)
# =============================================================================

source(here::here("02_code", "00_setup", "01_constants.R"))
suppressPackageStartupMessages(library(data.table))

# ── 0. Grid maestro depto × año (2012-2024) ──────────────────────────────────
grid <- CJ(dept_upper = toupper(DEPTS), year = 2012:2024)

# ── 1a. Gasto agro MUNICIPAL MEFP (devengado, USD const. 2015), 2016-2024 ────
# Fuente oficial más reciente que reemplaza/extiende a Jubileo (petición del usuario).
mefp <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "territorial_muni_mefp.rds")))
mefp[, dept_upper := toupper(dept)]
gasto_mefp <- mefp[!is.na(dept_upper),
                   .(gasto_mefp_usd2015_mm = sum(usd2015, na.rm = TRUE)),   # usd2015 ya en mm
                   by = .(dept_upper, year)]

# ── 1b. Gasto + PIB agropecuario (Jubileo consolidado, panel canónico v2) ────
sub <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "subnacional_panel_v2.rds")))
gasto_jub <- sub[, .(dept_upper, year,
                     agro_strict_bob_mm_2015,
                     rural_total_bob_mm_2015,
                     pib_agrop_bob_2017_mm)]
gasto <- merge(merge(grid, gasto_mefp, by = c("dept_upper", "year"), all.x = TRUE),
               gasto_jub, by = c("dept_upper", "year"), all.x = TRUE)

# ── 2. Producción y superficie INE → productividad de la tierra ──────────────
ine <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "ine_agro_stats_long.rds")))
ine[, dept_upper := toupper(dept)]
ine <- ine[dept_upper != "BOLIVIA"]                       # excluir agregado nacional
prod <- ine[indicator == "produccion",
            .(produccion_total_ton = sum(value, na.rm = TRUE)), by = .(dept_upper, year)]
sup  <- ine[indicator == "superficie",
            .(superficie_total_ha = sum(value, na.rm = TRUE)), by = .(dept_upper, year)]

# ── 3. Rendimiento de cereales departamental (robustez de un dominio) ────────
cy <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "cereal_yield_dept.rds")))
cy[, dept_upper := toupper(dept)]
cy <- cy[, .(dept_upper, year, cereal_yield_kg_ha)]

# ── 4. Precipitación CHIRPS departamental (covariable no controlable) ─────────
ch <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "chirps_dept_annual_complete.rds")))
ch[, dept_upper := toupper(dept)]
ch <- ch[, .(dept_upper, year, precip_mm)]

# ── 5. Merge sobre (dept_upper, year) y derivadas ────────────────────────────
panel <- Reduce(function(a, b) merge(a, b, by = c("dept_upper", "year"), all.x = TRUE),
                list(gasto, prod, sup, cy, ch))

panel[, prod_per_ha := produccion_total_ton / superficie_total_ha]   # ton/ha (todos los cultivos)
panel[, precip_k    := precip_mm / 1000]                              # reescala numérica (miles mm)

# Choques comunes con timing fijo (ÚTILES SOLO en specs sin FE de año;
# con FE de año τ_t quedan perfectamente absorbidos — ver 09_panel_fe_productivity.R).
panel[, post_ley393 := as.integer(year >= 2014)]   # Ley 393 Servicios Financieros (promulgada ago-2013)
panel[, covid       := as.integer(year == 2020)]

setorder(panel, dept_upper, year)

# ── 6. Diagnóstico de cobertura ──────────────────────────────────────────────
cat(sprintf("Panel productividad: %d filas, %d deptos, años %d-%d\n",
            nrow(panel), uniqueN(panel$dept_upper), min(panel$year), max(panel$year)))
cov <- panel[, .(
  gasto_mefp  = sum(!is.na(gasto_mefp_usd2015_mm)),
  gasto_jub   = sum(!is.na(agro_strict_bob_mm_2015)),
  prod_per_ha = sum(is.finite(prod_per_ha)),
  cereal      = sum(!is.na(cereal_yield_kg_ha)),
  pib         = sum(!is.na(pib_agrop_bob_2017_mm)),
  precip      = sum(!is.na(precip_mm))
), by = year][order(year)]
cat("\n=== Cobertura no-NA por año ===\n"); print(cov)

# ── 7. Guardar ───────────────────────────────────────────────────────────────
saveRDS(panel, file.path(DIR_DATA_PRO, "subnacional_productivity_panel.rds"))
fwrite(panel,  file.path(DIR_DATA_PRO, "subnacional_productivity_panel.csv"))
cat("\n✓ Guardado: subnacional_productivity_panel.{rds,csv}\n")
