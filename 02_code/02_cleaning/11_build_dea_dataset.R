# Construye dataset DEA-ready para análisis de eficiencia subnacional
# =============================================================================
# DEA (Data Envelopment Analysis) + Bootstrap Simar-Wilson requiere:
#   INPUTS (X):
#     - Gasto agropecuario real (BOB 2015)    [Jubileo]
#     - Superficie cultivada total (ha)         [INE]
#     - Deuda rural stock (proxy capital)       [MEFP]
#   OUTPUTS (Y):
#     - Producción agrícola total (toneladas)   [INE]
#     - Rendimiento promedio cereales (kg/ha)   [INE]
#     - PIB agropecuario real (BOB 2017)        [INE Ref 2017, solo 2017+]
#
# Período común: 2012-2020 (intersección de Jubileo 2012-2021 e INE hasta 2020)
# DMUs: 9 departamentos × 9 años = 81 observaciones
# =============================================================================

library(data.table)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc_dir <- file.path(root, "01_data/processed")

# ─── Cargar datasets ──────────────────────────────────────────────────────────
panel_sub <- readRDS(file.path(proc_dir, "subnacional_panel.rds"))
setDT(panel_sub)

ine <- readRDS(file.path(proc_dir, "ine_agro_stats_long.rds"))
setDT(ine)
ine[, dept_upper := toupper(dept)]
ine[dept == "La Paz",     dept_upper := "LA PAZ"]
ine[dept == "Santa Cruz", dept_upper := "SANTA CRUZ"]

# ─── Agregar INE por depto × año ──────────────────────────────────────────────
# Superficie total cultivada (suma de todos los cultivos)
superficie <- ine[indicator == "superficie",
                  .(superficie_total_ha = sum(value, na.rm = TRUE)),
                  by = .(dept_upper, year)]

# Producción total (suma toneladas)
produccion <- ine[indicator == "produccion",
                  .(produccion_total_ton = sum(value, na.rm = TRUE)),
                  by = .(dept_upper, year)]

# Rendimiento promedio ponderado de cereales
cereales_vals <- c("Arroz con cáscara", "Arroz en grano", "Maíz en grano",
                   "Maíz en grano (1)", "Sorgo en grano", "Sorgo en grano (1)",
                   "Trigo", "Cebada en grano", "Quinua", "Avena")
rend_cereales <- ine[cultivo %in% cereales_vals & indicator == "rendimiento",
                     .(rend_cereales_kg_ha = mean(value, na.rm = TRUE)),
                     by = .(dept_upper, year)]

# Producción específica por commodity importante
prod_commodities <- ine[cultivo %in% c("Soya", "Papa", "Maíz en grano (1)",
                                        "Arroz con cáscara", "Quinua", "Trigo") &
                        indicator == "produccion",
  .(dept_upper, year, cultivo, produccion_ton = value)]
prod_wide <- dcast(prod_commodities, dept_upper + year ~ cultivo,
                   value.var = "produccion_ton", fun.aggregate = sum)
setnames(prod_wide,
         old = intersect(c("Soya","Papa","Maíz en grano (1)","Arroz con cáscara",
                            "Quinua","Trigo"), names(prod_wide)),
         new = c("prod_soya_ton","prod_papa_ton","prod_maiz_ton",
                 "prod_arroz_ton","prod_quinua_ton","prod_trigo_ton")[
                 match(intersect(c("Soya","Papa","Maíz en grano (1)","Arroz con cáscara",
                                   "Quinua","Trigo"), names(prod_wide)),
                 c("Soya","Papa","Maíz en grano (1)","Arroz con cáscara",
                   "Quinua","Trigo"))])

# ─── Merge con panel subnacional ─────────────────────────────────────────────
dea_panel <- merge(panel_sub, superficie,     by = c("dept_upper", "year"), all.x = TRUE)
dea_panel <- merge(dea_panel, produccion,      by = c("dept_upper", "year"), all.x = TRUE)
dea_panel <- merge(dea_panel, rend_cereales,   by = c("dept_upper", "year"), all.x = TRUE)
dea_panel <- merge(dea_panel, prod_wide,        by = c("dept_upper", "year"), all.x = TRUE)

# ─── Filtrar al período común (2012-2020) ────────────────────────────────────
# 2021 INE no está disponible (último año: 2020)
dea_panel <- dea_panel[year <= 2020]

cat("=== Panel DEA-ready ===\n")
cat("DMUs:", nrow(dea_panel), "(9 depts × 9 años)\n")
cat("Variables:", ncol(dea_panel), "\n\n")

cat("=== Inputs & Outputs para DEA — completitud ===\n")
dea_vars <- list(
  "INPUT: Gasto agropecuario estricto BOB 2015" = "agro_strict_bob_mm_2015",
  "INPUT: Gasto rural total BOB 2015"           = "rural_total_bob_mm_2015",
  "INPUT: Superficie total ha"                  = "superficie_total_ha",
  "INPUT: Deuda rural stock (proxy capital)"    = "deuda_rural_mm_bob",
  "OUTPUT: Producción total (ton)"              = "produccion_total_ton",
  "OUTPUT: Rendimiento cereales (kg/ha)"        = "rend_cereales_kg_ha",
  "OUTPUT: Producción soya (ton)"               = "prod_soya_ton",
  "OUTPUT: PIB agropecuario BOB 2017"           = "pib_agrop_bob_2017_mm"
)
for (lbl in names(dea_vars)) {
  v <- dea_vars[[lbl]]
  if (v %in% names(dea_panel)) {
    n <- sum(!is.na(dea_panel[[v]]))
    cat(sprintf("  %-50s %2d/%d obs\n", lbl, n, nrow(dea_panel)))
  }
}

cat("\n=== Top departamentos 2019 — Inputs vs Outputs ===\n")
print(dea_panel[year == 2019][order(-agro_strict_bob_mm_2015),
  .(dept_upper,
    input_gasto_bob = agro_strict_bob_mm_2015,
    input_superf_ha = superficie_total_ha,
    output_prod_ton = produccion_total_ton,
    output_rend_kgha = rend_cereales_kg_ha)])

# Guardar dataset DEA
saveRDS(dea_panel, file.path(proc_dir, "dea_dataset.rds"))
fwrite(dea_panel, file.path(proc_dir, "dea_dataset.csv"))
cat("\n✓ Guardado: dea_dataset.{rds,csv} — panel DEA-ready\n")
cat("  Listo para: rDEA::dea.robust(), Benchmarking::dea()\n")
cat("  Panel: 9 depts × 9 años = 81 DMUs × observaciones temporales\n")
