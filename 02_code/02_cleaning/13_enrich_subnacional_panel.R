# Enriquece panel subnacional con ENA 2015 y PIB departamental completo
# =============================================================================
# Input: subnacional_panel.rds (90 filas × 25 vars)
# Agrega:
#   - PIB corriente y constante por actividad (todas actividades, no solo agrop)
#   - ENA 2015 UPAs agrícolas agregadas por depto (número UPA)
#   - Productividad por trabajador (PIB / población rural)
# Output: subnacional_panel_v2.rds (90 × ~50 variables)
# =============================================================================

library(data.table); library(haven)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")

panel <- readRDS(file.path(proc, "subnacional_panel.rds"))
setDT(panel)

# ─── 1. PIB departamental completo ────────────────────────────────────────────
pib <- readRDS(file.path(proc, "pib_departamental_complete.rds"))
setDT(pib)
pib <- pib[dept != "BOLIVIA"]

# Wide: cada actividad como columna (solo agrop por ahora)
pib_agro <- pib[grepl("^Agricultura|^AGRICULTURA", actividad),
  .(dept, year,
    pib_agrop_corriente_mm   = corriente_bob_mm,
    pib_agrop_constante_mm   = constante_chain2017_mm)]

pib_total <- pib[grepl("PRODUCTO INTERNO BRUTO", actividad),
  .(dept, year,
    pib_total_corriente_mm   = corriente_bob_mm,
    pib_total_constante_mm   = constante_chain2017_mm)]

pib_wide <- merge(pib_agro, pib_total, by = c("dept", "year"), all = TRUE)
pib_wide[, pib_agrop_share_pct := pib_agrop_corriente_mm / pib_total_corriente_mm * 100]
setnames(pib_wide, "dept", "dept_upper")
pib_wide[, dept_upper := as.character(dept_upper)]

cat("=== PIB por depto merged ===\n")
print(pib_wide[year == 2020])

# Merge al panel
panel <- merge(panel, pib_wide, by = c("dept_upper", "year"), all.x = TRUE)

# ─── 2. ENA 2015 — UPAs y superficie agregada por depto ──────────────────────
cat("\n=== ENA 2015 agregados ===\n")
agric <- readRDS(file.path(proc, "ena_2015_agricola.rds"))
setDT(agric)

# Variables clave identificadas: id_departamento, nombredepartamento,
# sup (superficie), sup_exp (expandido), prod (producción), prod_exp
# Handle haven labelled columns by using as.numeric / as.character
agric[, riego_num := as.numeric(riego)]
ena_agg <- agric[, .(
  n_parcelas    = .N,
  n_upas_unicas = length(unique(as.character(id_persona))),
  sup_total_ha  = sum(as.numeric(sup), na.rm = TRUE),
  sup_exp_ha    = sum(as.numeric(sup_exp), na.rm = TRUE),
  prod_exp_ton  = sum(as.numeric(prod_exp), na.rm = TRUE),
  riego_pct     = mean(riego_num == 1, na.rm = TRUE) * 100
), by = .(id_departamento = as.integer(id_departamento),
          nombredepartamento = as.character(nombredepartamento))]

# Homogeneizar nombres
ena_agg[, dept_upper := toupper(nombredepartamento)]
ena_agg[, dept_upper := trimws(dept_upper)]
print(ena_agg[, .(dept_upper, n_upas_unicas, sup_total_ha,
                   prod_exp_ton, riego_pct)])

# Merge ENA como snapshot 2015
ena_vars <- c("dept_upper", "n_upas_unicas", "sup_total_ha", "sup_exp_ha",
              "prod_exp_ton", "riego_pct")
ena_merge <- ena_agg[, ..ena_vars]
setnames(ena_merge, c("n_upas_unicas", "sup_total_ha", "sup_exp_ha",
                       "prod_exp_ton", "riego_pct"),
         c("ena2015_upas", "ena2015_sup_ha", "ena2015_sup_exp_ha",
           "ena2015_prod_exp_ton", "ena2015_riego_pct"))

# Panel con datos ENA solo 2015
panel <- merge(panel, ena_merge, by = "dept_upper", all.x = TRUE)

# Mantener ENA solo en año 2015
for (v in c("ena2015_upas", "ena2015_sup_ha", "ena2015_sup_exp_ha",
            "ena2015_prod_exp_ton", "ena2015_riego_pct")) {
  panel[year != 2015, (v) := NA]
}

# ─── 3. Variables derivadas nuevas ────────────────────────────────────────────
# Gasto agrop per hectárea (usando superficie ENA 2015 como proxy fija)
cat("\n=== Indicadores derivados ===\n")

# Ratio gasto/PIB agropecuario (eficiencia presupuesta/valor producción)
panel[!is.na(pib_agrop_corriente_mm) & pib_agrop_corriente_mm > 0,
      gasto_por_pib_agrop_ratio := agro_strict_bob_mm / pib_agrop_corriente_mm]

cat("=== Panel subnacional v2 — resumen completitud ===\n")
check_vars <- list(
  "Gasto P10 Agropecuario (Jubileo)"       = "p10_agropecuario_bob_mm",
  "Gasto agro estricto 10+12+32"            = "agro_strict_bob_mm",
  "Gasto rural total"                       = "rural_total_bob_mm",
  "PIB agrop corriente (INE)"               = "pib_agrop_corriente_mm",
  "PIB agrop constante (INE)"               = "pib_agrop_constante_mm",
  "PIB total corriente"                     = "pib_total_corriente_mm",
  "PIB agrop % PIB"                         = "pib_agrop_share_pct",
  "ENA 2015 UPAs"                            = "ena2015_upas",
  "ENA 2015 superficie expandida"           = "ena2015_sup_exp_ha",
  "ENA 2015 producción expandida"          = "ena2015_prod_exp_ton",
  "Ratio gasto/PIB agrop"                   = "gasto_por_pib_agrop_ratio"
)
for (lbl in names(check_vars)) {
  v <- check_vars[[lbl]]
  if (v %in% names(panel)) {
    n <- sum(!is.na(panel[[v]]))
    cat(sprintf("  %-40s %2d/90 obs\n", lbl, n))
  }
}

cat("\n=== Panel v2 dimensiones:", nrow(panel), "×", ncol(panel), "===\n")

# Guardar
saveRDS(panel, file.path(proc, "subnacional_panel_v2.rds"))
fwrite(panel, file.path(proc, "subnacional_panel_v2.csv"))
cat("✓ subnacional_panel_v2.{rds,csv} guardado\n")
