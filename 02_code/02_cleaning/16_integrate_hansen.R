# Integra Hansen (deforestación 2001-2023) a paneles nacional y municipal
# =============================================================================
# Input (de 25_process_hansen.R):
#   - hansen_dept_annual_deforestation.rds
#   - hansen_muni_annual_deforestation.rds
#   - hansen_dept_cumulative.rds
#
# Merge con:
#   - spending_panel_v5.rds  (nacional) → spending_panel_v6.rds
#   - municipal_panel_v2_lc.rds          → municipal_panel_v3.rds
#
# Ejecutar:
#   Rscript 02_code/02_cleaning/16_integrate_hansen.R
# =============================================================================

library(data.table)
library(stringr)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")

# ── 1. Panel NACIONAL v6 (agrega deforestación nacional por año) ─────────────
panel_v5 <- readRDS(file.path(proc, "spending_panel_v5.rds"))
setDT(panel_v5)

hansen_d <- readRDS(file.path(proc, "hansen_dept_annual_deforestation.rds"))
setDT(hansen_d)

# Suma nacional
hansen_nat <- hansen_d[, .(
  defor_nacional_ha    = sum(defor_ha, na.rm = TRUE),
  defor_nacional_pct2000 = weighted.mean(defor_pct_2000,
                                         w = forest_area_2000_ha, na.rm = TRUE)
), by = year]

panel_v6 <- merge(panel_v5, hansen_nat, by = "year", all.x = TRUE)

# Forest cover 2000 (constante)
forest_2000_nat <- sum(readRDS(file.path(proc, "hansen_dept_treecover_2000.rds"))$forest_area_2000_ha,
                       na.rm = TRUE)
panel_v6[, forest_2000_ha_nacional := forest_2000_nat]

# Deforestación acumulada desde 2001
setorder(panel_v6, year)
panel_v6[year >= 2001, defor_acum_ha := cumsum(fifelse(is.na(defor_nacional_ha), 0,
                                                       defor_nacional_ha))]
panel_v6[, defor_acum_pct2000 := 100 * defor_acum_ha / forest_2000_ha_nacional]

cat("=== Panel v6 nacional ===\n")
cat("Obs con deforestación:", sum(!is.na(panel_v6$defor_nacional_ha)), "/", nrow(panel_v6), "\n")
cat("Deforestación total 2001-2023:", round(sum(hansen_nat$defor_nacional_ha)/1e6, 2), "M ha\n\n")

saveRDS(panel_v6, file.path(proc, "spending_panel_v6.rds"))
fwrite(panel_v6,  file.path(proc, "spending_panel_v6.csv"))
cat("✓ spending_panel_v6.rds guardado (", nrow(panel_v6), "×", ncol(panel_v6), ")\n\n")

# ── 2. Panel MUNICIPAL v3 (anexa deforestación por muni × año) ───────────────
mun_v2 <- readRDS(file.path(proc, "municipal_panel_v2_lc.rds"))
setDT(mun_v2)

hansen_m <- readRDS(file.path(proc, "hansen_muni_annual_deforestation.rds"))
setDT(hansen_m)

# Normalizador igual al de 14_build_municipal_panel_v2.R
norm_name <- function(x) {
  y <- iconv(x, from = "UTF-8", to = "ASCII//TRANSLIT")
  y <- toupper(y); y <- gsub("[[:punct:]]", " ", y)
  y <- gsub("\\s+", " ", y); str_trim(y)
}
hansen_m[, muni_key := norm_name(municipio)]

# Merge anual (por muni_key × year)
mun_v3 <- merge(mun_v2, hansen_m[, .(muni_key, year,
                                     defor_ha_year      = defor_ha,
                                     defor_pct2000_year = defor_pct_2000,
                                     forest_2000_ha     = forest_area_2000_ha)],
                by = c("muni_key", "year"), all.x = TRUE)

# Acumulado por muni desde 2001 (ordenado muni × year)
setorder(mun_v3, muni_key, year)
mun_v3[year >= 2001 & !is.na(defor_ha_year),
       defor_acum_ha := cumsum(defor_ha_year), by = muni_key]

cat("=== Panel municipal v3 ===\n")
cat("Filas:", nrow(mun_v3), "| Vars:", ncol(mun_v3), "\n")
cat("Obs con deforestación:", sum(!is.na(mun_v3$defor_ha_year)), "/", nrow(mun_v3), "\n")
match_pct <- 100 * length(intersect(unique(mun_v2$muni_key), unique(hansen_m$muni_key))) /
             length(unique(mun_v2$muni_key))
cat(sprintf("Match Jubileo × Hansen: %.0f%% de munis\n\n", match_pct))

saveRDS(mun_v3, file.path(proc, "municipal_panel_v3.rds"))
fwrite(mun_v3,  file.path(proc, "municipal_panel_v3.csv"))
cat("✓ municipal_panel_v3.rds guardado\n")
