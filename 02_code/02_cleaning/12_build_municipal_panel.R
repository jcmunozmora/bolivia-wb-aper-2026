# Construye panel municipal consolidado y verifica consistencia
# =============================================================================
# Input: jubileo_municipal_full_2012_2021.rds (73,983 filas)
#   340 municipios × ~31 programas × 10 años
#
# Construye:
#  1) panel municipal con categorías agregadas (agro, rural, total)
#  2) agregación municipal → departamental para validar consistencia
#  3) comparación con jubileo_departamental_2012_2021.rds (scraping previo)
# =============================================================================

library(data.table)
library(stringr)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc_dir <- file.path(root, "01_data/processed")

# ─── 1. Cargar scraping municipal ────────────────────────────────────────────
mun <- readRDS(file.path(proc_dir, "jubileo_municipal_full_2012_2021.rds"))
setDT(mun)

cat("=== Jubileo Municipal — vista general ===\n")
cat("Filas:", nrow(mun), "\n")
cat("Municipios únicos:", length(unique(mun$muni_rel)), "\n")
cat("Departamentos:", length(unique(mun$dept)), "\n")
cat("Programas:", length(unique(mun$program_code)), "\n")
cat("Años:", paste(range(mun$year), collapse = "-"), "\n\n")

# ─── 2. Panel municipal con categorías agregadas ─────────────────────────────
AGRO_STRICT   <- c("10", "12", "32")
RURAL_INFRA   <- c("14", "15", "17", "18", "19")
RURAL_AMPLIO  <- c(AGRO_STRICT, RURAL_INFRA, "13", "35")

sum_cat <- function(dt, codes, label) {
  dt[program_code %in% codes,
     .(value = sum(total_bob, na.rm = TRUE)),
     by = .(dept, muni_rel, muni_code, muni_name, year)][, category := label][]
}

cats <- rbind(
  sum_cat(mun, "10",         "p10_agropecuario_bob"),
  sum_cat(mun, "12",         "p12_microriegos_bob"),
  sum_cat(mun, "18",         "p18_caminos_vecinales_bob"),
  sum_cat(mun, "32",         "p32_recursos_hidricos_bob"),
  sum_cat(mun, AGRO_STRICT,  "agro_strict_bob"),
  sum_cat(mun, RURAL_INFRA,  "rural_infra_bob"),
  sum_cat(mun, RURAL_AMPLIO, "rural_total_bob")
)

# Total municipal (todos los programas)
total_mun <- mun[, .(total_presupuesto_bob = sum(total_bob, na.rm = TRUE)),
                 by = .(dept, muni_rel, muni_code, muni_name, year)]

panel_mun <- dcast(cats,
                   dept + muni_rel + muni_code + muni_name + year ~ category,
                   value.var = "value")
panel_mun <- merge(panel_mun, total_mun,
                   by = c("dept", "muni_rel", "muni_code", "muni_name", "year"))

# Convertir a MM BOB
for (v in grep("_bob$", names(panel_mun), value = TRUE)) {
  panel_mun[, (paste0(sub("_bob$", "", v), "_bob_mm")) := get(v) / 1e6]
}

# Share agropecuario del presupuesto municipal
panel_mun[, agro_share_pct := (agro_strict_bob / total_presupuesto_bob) * 100]
panel_mun[, p10_share_pct  := (p10_agropecuario_bob / total_presupuesto_bob) * 100]

cat("=== Panel Municipal consolidado ===\n")
cat("Filas (muni × año):", nrow(panel_mun), "\n")
cat("Variables:", ncol(panel_mun), "\n\n")

# ─── 3. Agregación muni → dept para validar ──────────────────────────────────
agg_dept <- panel_mun[, .(
  agro_strict_sum_bob_mm = sum(agro_strict_bob_mm, na.rm = TRUE),
  p10_sum_bob_mm         = sum(p10_agropecuario_bob_mm, na.rm = TRUE),
  total_sum_bob_mm       = sum(total_presupuesto_bob_mm, na.rm = TRUE)
), by = .(dept, year)]

# Comparar con el scraping departamental anterior
dept_prev <- readRDS(file.path(proc_dir, "jubileo_departamental_2012_2021.rds"))
setDT(dept_prev)
dept_prev[, program_code := str_extract(program, "^\\d+")]
dept_p10 <- dept_prev[program_code == "10",
                      .(dept, year, p10_dept_direct_bob_mm = total_bob / 1e6)]

comparison <- merge(agg_dept, dept_p10, by = c("dept", "year"), all = TRUE)
comparison[, p10_diff_pct := 100 * (p10_sum_bob_mm / p10_dept_direct_bob_mm - 1)]

cat("=== Validación consistencia muni-agg vs dept-direct (P10 Agropecuario) ===\n")
cat("Si están bien alineados, diff debería ser < 5% en magnitud:\n")
print(comparison[year %in% c(2015, 2020),
  .(dept, year,
    P10_suma_munis = round(p10_sum_bob_mm, 2),
    P10_scrap_dept = round(p10_dept_direct_bob_mm, 2),
    diff_pct       = round(p10_diff_pct, 1))])

# ─── 4. Top municipios — análisis sustantivo ──────────────────────────────────
cat("\n=== Top 15 municipios por gasto agropecuario estricto 2020 ===\n")
top15 <- panel_mun[year == 2020][order(-agro_strict_bob_mm)][1:15,
  .(dept, muni_name,
    agro_strict_mm  = round(agro_strict_bob_mm, 2),
    p10_mm          = round(p10_agropecuario_bob_mm, 2),
    p12_microriegos = round(p12_microriegos_bob_mm, 2),
    agro_share_pct  = round(agro_share_pct, 2))]
print(top15)

cat("\n=== Top 10 municipios por % agropecuario (no por monto) 2020 ===\n")
top_share <- panel_mun[year == 2020 & total_presupuesto_bob_mm > 10][
  order(-agro_share_pct)][1:10,
  .(dept, muni_name,
    agro_strict_mm  = round(agro_strict_bob_mm, 2),
    presup_total_mm = round(total_presupuesto_bob_mm, 1),
    agro_share_pct  = round(agro_share_pct, 1))]
print(top_share)

# ─── 5. Guardar ──────────────────────────────────────────────────────────────
saveRDS(panel_mun,  file.path(proc_dir, "municipal_panel.rds"))
fwrite(panel_mun,   file.path(proc_dir, "municipal_panel.csv"))
saveRDS(comparison, file.path(proc_dir, "muni_dept_validation.rds"))
cat("\n✓ Guardado: municipal_panel.{rds,csv} — ", nrow(panel_mun), "filas ×",
    ncol(panel_mun), "variables\n")
cat("✓ Guardado: muni_dept_validation.rds (chequeo consistencia)\n")
