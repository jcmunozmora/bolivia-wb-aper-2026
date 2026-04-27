# Panel v11 → v12: arreglo de bugs detectados en revisión
# =============================================================================
# Bugs identificados:
#   1. MapBiomas: nombres truncados ("mb_atural" debió ser "mb_natural", etc.)
#      Causa: regex gsub("[^a-z0-9]+", "_", x) aplicado ANTES de tolower()
#      consume mayúsculas iniciales como no-letras.
#
#   2. Duplicados WDI vs OWID idénticos (correlación 1.0):
#      - agr_food_prod_index ≡ wdi_food_prod_index
#      - agr_employment_pct  ≡ wdi_agr_empl_pct
#      - agr_value_added_pct_gdp ≡ wdi_agr_va_pct_gdp
#      - rural_pop_pct ≡ wdi_rural_pop_pct (verificar)
#      - undernourishment_pct ≡ wdi_undernourishment_pct (verificar)
#      - agr_land_pct ≡ wdi_agr_land_pct (verificar)
#
#   3. Cereal yield triplicado con diferencias entre fuentes:
#      - cereal_yield_kg_ha.x (FAOSTAT QCL via OWID)
#      - cereal_yield_kg_ha.y (INE Bolivia)
#      - wdi_cereal_yield_kg_ha (WDI)
#      Solución: renombrar para identificar fuente; conservar las 3
#
# Output: spending_panel_v12.rds (35 años × ~165 vars limpias)
# =============================================================================

suppressPackageStartupMessages({
  library(data.table)
})

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")

# ── Cargar panel v11 ──────────────────────────────────────────────────────────
cat("=== Cargando panel v11 ===\n")
p <- readRDS(file.path(proc, "spending_panel_v11.rds"))
setDT(p)
n_v11 <- ncol(p)
cat(sprintf("v11: %d años × %d vars\n\n", nrow(p), n_v11))

# ── FIX 1: MapBiomas — renombrar correctamente ───────────────────────────────
cat("=== FIX 1: MapBiomas ===\n")
fix_mb <- c(
  "mb_atural_ha"      = "mb_natural_ha",
  "mb_ntropico_ha"    = "mb_antropico_ha",
  "mb_o_definido_ha"  = "mb_no_definido_ha"
)
for (old in names(fix_mb)) {
  new <- fix_mb[[old]]
  if (old %in% names(p)) {
    setnames(p, old, new)
    cat(sprintf("  ✓ %s → %s\n", old, new))
  }
}

# ── FIX 2: Eliminar duplicados idénticos (correlación 1.0) ────────────────────
cat("\n=== FIX 2: Duplicados idénticos ===\n")
identical_pairs <- list(
  list("agr_food_prod_index",     "wdi_food_prod_index"),
  list("agr_employment_pct",       "wdi_agr_empl_pct"),
  list("agr_value_added_pct_gdp",  "wdi_agr_va_pct_gdp"),
  list("rural_pop_pct",            "wdi_rural_pop_pct"),
  list("undernourishment_pct",     "wdi_undernourishment_pct"),
  list("agr_land_pct",             "wdi_agr_land_pct")
)

vars_to_drop <- character(0)
for (pair in identical_pairs) {
  v1 <- pair[[1]]; v2 <- pair[[2]]
  if (!(v1 %in% names(p)) || !(v2 %in% names(p))) next
  both <- !is.na(p[[v1]]) & !is.na(p[[v2]])
  if (!any(both)) next
  diff <- max(abs(p[[v1]][both] - p[[v2]][both]), na.rm = TRUE)
  if (diff < 1e-6) {
    # Idénticos: eliminar wdi_ y mantener el sin prefijo (más legible)
    vars_to_drop <- c(vars_to_drop, v2)
    cat(sprintf("  ✓ %s ≡ %s — drop %s\n", v1, v2, v2))
  } else {
    cat(sprintf("  ✗ %s ≠ %s (diff=%.4f) — mantener ambos\n", v1, v2, diff))
  }
}
if (length(vars_to_drop) > 0) {
  p[, (vars_to_drop) := NULL]
}

# ── FIX 3: Cereal yield — renombrar por fuente ────────────────────────────────
cat("\n=== FIX 3: Cereal yield — identificar fuentes ===\n")
if ("cereal_yield_kg_ha.x" %in% names(p)) {
  setnames(p, "cereal_yield_kg_ha.x", "fao_cereal_yield_kg_ha")
  cat("  ✓ cereal_yield_kg_ha.x → fao_cereal_yield_kg_ha (FAOSTAT/OWID)\n")
}
if ("cereal_yield_kg_ha.y" %in% names(p)) {
  setnames(p, "cereal_yield_kg_ha.y", "ine_cereal_yield_kg_ha")
  cat("  ✓ cereal_yield_kg_ha.y → ine_cereal_yield_kg_ha (INE Bolivia)\n")
}
# wdi_cereal_yield_kg_ha permanece sin cambios (WDI)

# Cereal_prod
if ("cereal_prod_ton" %in% names(p) && "cereals_prod_ton" %in% names(p)) {
  setnames(p, "cereal_prod_ton",  "fao_cereal_prod_ton")
  setnames(p, "cereals_prod_ton", "ine_cereal_prod_ton")
  cat("  ✓ cereal_prod_ton → fao_cereal_prod_ton (FAOSTAT)\n")
  cat("  ✓ cereals_prod_ton → ine_cereal_prod_ton (INE)\n")
}

# ── FIX 4: Verificar y reordenar columnas por grupo ──────────────────────────
cat("\n=== FIX 4: Reordenar columnas por grupo ===\n")
# Definir orden lógico: identificadores → indicadores macro → gasto público →
#   PSE/NRP → producción → uso suelo → clima → BCB
group_order <- c(
  "year",
  grep("^cpi|^bob_per|^inflation|^gdp_|^inv_pub|^inv_productivos|^inv_hidro|^inv_infra|^inv_sociales|^inv_multisec",
       names(p), value=TRUE),  # macro/deflactor
  grep("^inv_agro|^vipfe|^informe_fiscal", names(p), value=TRUE),  # gasto VIPFE
  grep("^aper_", names(p), value=TRUE),
  grep("^boost_", names(p), value=TRUE),
  grep("^mun_", names(p), value=TRUE),
  grep("^emapa", names(p), value=TRUE),
  grep("^speed_", names(p), value=TRUE),
  grep("^pse_|^PSE_|^psep|^PSEP|^gsse|^GSSE|^cse|^CSE|^tse|^TSE|^npc|^NPC|^nac|^NAC|^psct|^MPS_|^BT_|^GDP_|^GHG_",
       names(p), value=TRUE),
  grep("^pp_|^nrp_|^avg_nrp|^n_commod", names(p), value=TRUE),
  grep("^bcb_", names(p), value=TRUE),
  grep("^mb_|^lc_|^defor|gasto_usd_por_ha", names(p), value=TRUE),
  grep("^hansen_", names(p), value=TRUE),
  grep("^chirps|^precip", names(p), value=TRUE, ignore.case=TRUE),
  grep("^tfp", names(p), value=TRUE, ignore.case=TRUE),
  grep("^fao_|^ine_", names(p), value=TRUE),
  grep("^wdi_", names(p), value=TRUE),
  grep("^agr_|food_|cereal|rural_pop|undernour|all_meat|use_of_pesticides",
       names(p), value=TRUE)
)
group_order <- unique(group_order)
remaining <- setdiff(names(p), group_order)
if (length(remaining) > 0) {
  cat(sprintf("  Variables sin asignar grupo (al final): %s\n",
              paste(remaining, collapse=", ")))
  group_order <- c(group_order, remaining)
}
setcolorder(p, group_order)

# ── Validación final ──────────────────────────────────────────────────────────
cat(sprintf("\n=== Resumen ===\n"))
cat(sprintf("v11 vars: %d\n", n_v11))
cat(sprintf("v12 vars: %d (delta: %+d)\n", ncol(p), ncol(p) - n_v11))
cat(sprintf("Vars eliminadas (duplicados): %d\n", length(vars_to_drop)))
cat(sprintf("Vars renombradas: %d (MapBiomas) + cereal yield/prod\n", length(fix_mb)))

# Verificación: no quedan vars con .x/.y
sufijos <- grep("\\.x$|\\.y$", names(p), value=TRUE)
cat(sprintf("Vars con sufijo .x/.y restantes: %d ", length(sufijos)))
if (length(sufijos) == 0) cat("✓\n") else { cat("✗\n"); print(sufijos) }

# Verificación: nombres MapBiomas
mb_vars <- grep("^mb_", names(p), value=TRUE)
cat(sprintf("Vars MapBiomas: %s\n", paste(mb_vars, collapse=", ")))

# Densidad por año (igual que v11 pero con vars consolidadas)
density <- p[, .(n_vars = rowSums(!is.na(.SD))), by=year]
cat(sprintf("Densidad: min=%d, max=%d, media=%.0f\n",
            min(density$n_vars), max(density$n_vars), mean(density$n_vars)))

# ── Guardar ───────────────────────────────────────────────────────────────────
saveRDS(p, file.path(proc, "spending_panel_v12.rds"))
fwrite(p,  file.path(proc, "spending_panel_v12.csv"))
cat("\n✓ spending_panel_v12.rds\n")
cat("✓ spending_panel_v12.csv\n")

# Guardar también un diccionario de variables
dict <- data.table(
  variable = names(p),
  type = sapply(p, function(x) class(x)[1]),
  n_obs = sapply(p, function(x) sum(!is.na(x))),
  pct_filled = sapply(p, function(x) round(sum(!is.na(x))/length(x)*100, 1)),
  group = fcase(
    grepl("^year$", names(p)),                                   "00_id",
    grepl("^cpi|^bob_per|^inflation|^gdp_|^inv_pub|^inv_productivos|^inv_hidro|^inv_infra|^inv_sociales|^inv_multisec", names(p)), "01_macro",
    grepl("^inv_agro|^vipfe|^informe", names(p)),                "02_gasto_vipfe",
    grepl("^aper_", names(p)),                                    "03_aper_2011",
    grepl("^boost_", names(p)),                                   "04_gasto_boost",
    grepl("^mun_", names(p)),                                     "05_gasto_municipal",
    grepl("^emapa", names(p), ignore.case=TRUE),                  "06_emapa",
    grepl("^speed_", names(p)),                                   "07_speed_ifpri",
    grepl("^pse_|^PSE_|^psep|^PSEP|^gsse|^GSSE|^cse|^CSE|^tse|^TSE|^npc|^NPC|^nac|^NAC|^psct|^MPS_|^BT_|^GDP_|^GHG_", names(p)), "08_pse_idb",
    grepl("^pp_|^nrp_|^avg_nrp|^n_commod", names(p)),             "09_precios_nrp",
    grepl("^bcb_", names(p)),                                     "10_credito_bcb",
    grepl("^mb_|^lc_|^defor|gasto_usd_por_ha", names(p)),         "11_uso_suelo",
    grepl("^hansen_", names(p)),                                  "12_hansen",
    grepl("^chirps|^precip", names(p), ignore.case=TRUE),         "13_clima",
    grepl("^tfp", names(p), ignore.case=TRUE),                    "14_tfp_usda",
    grepl("^fao_|^ine_", names(p)),                               "15_fao_ine",
    grepl("^wdi_", names(p)),                                     "16_wdi",
    grepl("^agr_|food_|cereal|rural_pop|undernour|all_meat|use_of_pesticides", names(p)), "17_otros_outcomes",
    default = "99_sin_clasificar"
  )
)
setorder(dict, group, variable)
fwrite(dict, file.path(proc, "spending_panel_v12_dictionary.csv"))
cat(sprintf("✓ spending_panel_v12_dictionary.csv (%d vars × 5 cols)\n", nrow(dict)))

cat("\n--- Distribución por grupo ---\n")
print(dict[, .N, by=group][order(group)])
