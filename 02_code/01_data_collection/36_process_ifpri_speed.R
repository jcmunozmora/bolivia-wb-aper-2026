# IFPRI SPEED 2019 — Gasto público agropecuario
# =============================================================================
# Fuente: SPEED2019.xls (Harvard Dataverse doi:10.7910/DVN/MKX1TU)
# Cobertura: 164 países, 1980-2017, 12 sectores × 8 variables
#
# Outputs:
#   speed_bolivia.rds       — Bolivia completo (todos sectores, long format)
#   speed_agro_bolivia.rds  — Bolivia Agricultura wide (9 vars × 38 años)
#   speed_lac_agro.rds      — LAC + comparadores OCDE, sector Agricultura
#   spending_panel_v8.rds   — Panel v7 + SPEED ag_pctgdp + ag_pctexp + ag_con_usd
# =============================================================================

library(data.table)
library(readxl)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
raw  <- file.path(root, "01_data/raw/ifpri_speed")
proc <- file.path(root, "01_data/processed")

# ── Leer SPEED ────────────────────────────────────────────────────────────────
cat("Leyendo SPEED2019.xls...\n")
speed <- as.data.table(read_xls(file.path(raw, "SPEED2019.xls")))
cat(sprintf("  %d filas × %d cols | %d países | sectores: %s\n",
            nrow(speed), ncol(speed), length(unique(speed$isocode)),
            paste(sort(unique(speed$sector)), collapse=", ")))

# ── Pasar a formato largo (wide → long) ───────────────────────────────────────
id_vars  <- c("country","isocode","wb_region","region","sector","varname","unit")
yr_cols  <- names(speed)[grepl("^y[0-9]{4}$", names(speed))]

speed_long <- melt(speed, id.vars = id_vars, measure.vars = yr_cols,
                   variable.name = "yr_lbl", value.name = "value")
speed_long[, year := as.integer(sub("^y", "", yr_lbl))]
speed_long[, yr_lbl := NULL]
setorder(speed_long, isocode, sector, varname, year)

# ── 1. Bolivia completo ───────────────────────────────────────────────────────
bol_full <- speed_long[isocode == "BOL"]
cat(sprintf("\nBolivia: %d series × %d años | obs con dato: %d\n",
            uniqueN(bol_full[, paste(sector, varname)]),
            uniqueN(bol_full$year),
            sum(!is.na(bol_full$value))))
saveRDS(bol_full, file.path(proc, "speed_bolivia.rds"))
fwrite(bol_full,  file.path(proc, "speed_bolivia.csv"))
cat("✓ speed_bolivia.rds\n")

# ── 2. Bolivia Agricultura — wide para análisis ───────────────────────────────
bol_ag <- speed_long[isocode == "BOL" & sector == "Agriculture"]
bol_ag_wide <- dcast(bol_ag, year ~ varname, value.var = "value")
bol_ag_wide[, isocode := "BOL"]
bol_ag_wide[, country := "Bolivia (Plurinational State of)"]

cat("\n=== Bolivia — Gasto Agricultura (% del PIB) ===\n")
print(bol_ag_wide[year >= 1990, .(year, ag_pctgdp, ag_pctexp, ag_pctaggdp,
                                   ag_con_usd, ag_cur_usd)])

saveRDS(bol_ag_wide, file.path(proc, "speed_agro_bolivia.rds"))
fwrite(bol_ag_wide,  file.path(proc, "speed_agro_bolivia.csv"))
cat("✓ speed_agro_bolivia.rds\n")

# ── 3. LAC + OCDE comparadores — Sector Agricultura ─────────────────────────
# LAC completo + comparadores OCDE relevantes para benchmarking APER
comparadores_ocde <- c("CHL","COL","PER","MEX","BRA","ARG",
                        "USA","CAN","FRA","DEU","OECD_mean")
lac_isos <- unique(speed[wb_region == "Latin America & Caribbean"]$isocode)
keep_isos <- union(lac_isos, comparadores_ocde)

lac_ag <- speed_long[isocode %in% keep_isos & sector == "Agriculture"]

# Estadísticas de cobertura por país
cov <- lac_ag[varname == "ag_pctgdp", .(
  n_years     = sum(!is.na(value)),
  year_min    = as.integer(ifelse(any(!is.na(value)), min(year[!is.na(value)]), NA_integer_)),
  year_max    = as.integer(ifelse(any(!is.na(value)), max(year[!is.na(value)]), NA_integer_)),
  mean_pctgdp = round(mean(value, na.rm = TRUE), 2)
), by = .(country, isocode)][order(-n_years)]

cat("\n=== Cobertura LAC — ag_pctgdp ===\n")
print(cov)

saveRDS(lac_ag, file.path(proc, "speed_lac_agro.rds"))
fwrite(lac_ag,  file.path(proc, "speed_lac_agro.csv"))
cat("✓ speed_lac_agro.rds\n")

# ── 4. Integrar al panel maestro v7 → v8 ─────────────────────────────────────
cat("\nIntegrando SPEED al panel v7...\n")
panel <- readRDS(file.path(proc, "spending_panel_v7.rds"))
setDT(panel)

# Variables clave SPEED para Bolivia
bol_speed_vars <- bol_ag_wide[, .(
  year,
  speed_ag_pctgdp    = ag_pctgdp,    # % PIB total
  speed_ag_pctexp    = ag_pctexp,     # % gasto total gobierno
  speed_ag_pctaggdp  = ag_pctaggdp,  # % PIB agropecuario
  speed_ag_con_usd   = ag_con_usd,   # MM USD constantes 2010
  speed_ag_con_ppp   = ag_con_ppp    # MM PPP constantes 2010
)]

panel_v8 <- merge(panel, bol_speed_vars, by = "year", all.x = TRUE)
setorder(panel_v8, year)

# Cobertura
cat(sprintf("  SPEED ag_pctgdp: %d/%d años con dato\n",
            sum(!is.na(panel_v8$speed_ag_pctgdp)), nrow(panel_v8)))
cat(sprintf("  SPEED ag_pctexp: %d/%d años con dato\n",
            sum(!is.na(panel_v8$speed_ag_pctexp)), nrow(panel_v8)))

# Comparación VIPFE vs SPEED
cat("\n=== VIPFE vs SPEED — Gasto Agrop % PIB (solapamiento) ===\n")
comp <- panel_v8[!is.na(speed_ag_pctgdp) & !is.na(inv_agro_pct_gdp),
                  .(year, vipfe_pct_pib = round(inv_agro_pct_gdp, 3),
                    speed_pct_pib = round(speed_ag_pctgdp, 3))]
print(comp)

# Estadísticas Maputo (meta 10% gasto total)
cat("\n=== Cumplimiento meta Maputo (10% gasto público) ===\n")
maputo <- panel_v8[!is.na(speed_ag_pctexp),
                    .(year, ag_pctexp = round(speed_ag_pctexp, 2),
                      maputo_10 = speed_ag_pctexp >= 10)]
cat(sprintf("Años que cumplen Maputo (≥10%%): %d/%d\n",
            sum(maputo$maputo_10, na.rm = TRUE), sum(!is.na(maputo$maputo_10))))
print(maputo)

saveRDS(panel_v8, file.path(proc, "spending_panel_v8.rds"))
fwrite(panel_v8,  file.path(proc, "spending_panel_v8.csv"))
cat(sprintf("\n✓ spending_panel_v8.rds (%d años × %d vars)\n",
            nrow(panel_v8), ncol(panel_v8)))

# ── Resumen LAC benchmarking ───────────────────────────────────────────────────
cat("\n=== Benchmark LAC — Gasto Agrop promedio 2000-2017 (% PIB) ===\n")
lac_bench <- lac_ag[varname == "ag_pctgdp" & year >= 2000,
                     .(mean_pctgdp = round(mean(value, na.rm=TRUE), 2),
                       n_obs = sum(!is.na(value))),
                     by = .(country, isocode)][order(-mean_pctgdp)]
print(lac_bench)

cat("\n✓ SPEED procesado completamente\n")
