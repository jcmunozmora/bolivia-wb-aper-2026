# Panel MUNICIPAL consolidado v2 — con land cover MapBiomas
# =============================================================================
# Integra los 340 municipios con:
#   - Gasto municipal Jubileo 2012-2021 (31 programas)
#   - Cobertura MapBiomas 1985-2024 (natural / antrópico / share)
#   - Cambio cobertura 1985-2024 (absoluto y porcentual)
#
# Output: municipal_panel_v2_lc.rds
# =============================================================================

library(data.table)
library(stringr)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc     <- file.path(root, "01_data/processed")

# ─── Cargar ──────────────────────────────────────────────────────────────────
mun_gasto <- readRDS(file.path(proc, "municipal_panel.rds"))         # Jubileo
mun_lc    <- readRDS(file.path(proc, "mapbiomas_municipal_annual.rds"))
mun_chg   <- readRDS(file.path(proc, "mapbiomas_municipal_cambio.rds"))
setDT(mun_gasto); setDT(mun_lc); setDT(mun_chg)

cat("=== Input datasets ===\n")
cat("Jubileo gasto:     ", nrow(mun_gasto), "filas (", length(unique(mun_gasto$muni_name)), "munis )\n")
cat("MapBiomas LC:      ", nrow(mun_lc), "filas (", length(unique(mun_lc$municipio)), "munis )\n")
cat("MapBiomas cambio:  ", nrow(mun_chg), "filas\n\n")

# ─── Normalizar nombres para match ────────────────────────────────────────────
norm_name <- function(x) {
  y <- iconv(x, from = "UTF-8", to = "ASCII//TRANSLIT")
  y <- toupper(y)
  y <- gsub("[[:punct:]]", " ", y)
  y <- gsub("\\s+", " ", y)
  str_trim(y)
}

mun_gasto[, muni_key := norm_name(muni_name)]
mun_lc[,    muni_key := norm_name(municipio)]
mun_chg[,   muni_key := norm_name(municipio)]

# ─── Merge LC temporal (Jubileo 2012-2021 × MapBiomas por año) ────────────────
panel <- merge(
  mun_gasto[, .(dept, muni_rel, muni_code, muni_name, muni_key, year,
                agro_strict_bob_mm, p10_agropecuario_bob_mm,
                rural_total_bob_mm, total_presupuesto_bob_mm,
                agro_share_pct, p10_share_pct)],
  mun_lc[, .(muni_key, year,
             area_antropico_ha = area_antropico,
             area_natural_ha = area_natural,
             area_total_ha,
             antropico_share_pct = antropico_share,
             natural_share_pct = natural_share)],
  by = c("muni_key", "year"),
  all.x = TRUE
)

# ─── Agregar cambio total 1985-2024 por municipio (invariante) ────────────────
panel <- merge(panel,
  mun_chg[, .(muni_key,
              lc_antrop_1985_kha  = area_antropico_1985 / 1e3,
              lc_antrop_2024_kha  = area_antropico_2024 / 1e3,
              lc_change_antrop_ha = cambio_antrop_ha,
              lc_change_antrop_pp = cambio_antrop_share_pp)],
  by = "muni_key", all.x = TRUE
)

cat("=== Panel municipal v2 ===\n")
cat("Filas:", nrow(panel), "\n")
cat("Variables:", ncol(panel), "\n")
cat("Match con MapBiomas:\n")
cat("  - con LC:", sum(!is.na(panel$area_antropico_ha)), "/", nrow(panel), "\n")
cat("  - con cambio:", sum(!is.na(panel$lc_change_antrop_ha)), "/", nrow(panel), "\n\n")

# ─── Variables derivadas ──────────────────────────────────────────────────────
# Intensidad: gasto / área antrópica (BOB per ha agrícola)
panel[area_antropico_ha > 0,
      gasto_agrop_por_ha_antrop := agro_strict_bob_mm * 1e6 / area_antropico_ha]

# Eficiencia ejecución: % presupuesto agropecuario sobre área natural remanente
panel[area_natural_ha > 0,
      gasto_por_ha_natural := agro_strict_bob_mm * 1e6 / area_natural_ha]

# ─── Resumen ──────────────────────────────────────────────────────────────────
cat("=== Top 10 municipios por gasto × expansión antrópica 2020 ===\n")
top <- panel[year == 2020 & !is.na(agro_strict_bob_mm) & !is.na(lc_change_antrop_ha)][
  order(-agro_strict_bob_mm)][1:10,
  .(dept, muni_name,
    gasto_agrop_mm   = round(agro_strict_bob_mm, 1),
    expansion_kha    = round(lc_change_antrop_ha/1e3, 1),
    antrop_share_24  = round(antropico_share_pct, 1))]
print(top)

cat("\n=== Correlación gasto agrop × expansión antrópica acumulada (2020) ===\n")
cor_panel <- panel[year == 2020 & !is.na(agro_strict_bob_mm) &
                    !is.na(lc_change_antrop_ha) &
                    total_presupuesto_bob_mm > 1]
r1 <- cor(cor_panel$agro_strict_bob_mm, cor_panel$lc_change_antrop_ha,
          use = "complete.obs")
cat(sprintf("  r (gasto agrop × cambio antrópico absoluto): %.3f\n", r1))
r2 <- cor(cor_panel$p10_agropecuario_bob_mm, cor_panel$antropico_share_pct,
          use = "complete.obs")
cat(sprintf("  r (P10 agropecuario × %% antrópico 2024): %.3f\n", r2))

# ─── Save ─────────────────────────────────────────────────────────────────────
saveRDS(panel, file.path(proc, "municipal_panel_v2_lc.rds"))
fwrite(panel, file.path(proc, "municipal_panel_v2_lc.csv"))
cat("\n✓ Guardado: municipal_panel_v2_lc.rds (", nrow(panel), "filas ×", ncol(panel), "vars)\n")
