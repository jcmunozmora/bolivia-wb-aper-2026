# Integra PSE (IDB Agrimonitor) al panel maestro — Panel v3 final
# Agrega las series OCDE completas 2006-2023 al panel v2

library(data.table)
library(tidyverse)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc_dir <- file.path(root, "01_data/processed")

panel_v2 <- readRDS(file.path(proc_dir, "spending_panel_v2.rds"))
setDT(panel_v2)

pse <- readRDS(file.path(proc_dir, "idb_pse_bolivia_aggregate.rds"))
setDT(pse)

# Rename IDB bob_per_usd to avoid conflict with WDI exchange rate
if ("bob_per_usd" %in% names(pse)) {
  setnames(pse, "bob_per_usd", "bob_per_usd_idb")
}

cat("Panel v2:", nrow(panel_v2), "x", ncol(panel_v2), "\n")
cat("PSE Agrimonitor:", nrow(pse), "obs x", ncol(pse), "vars\n")

# Merge
panel_v3 <- merge(panel_v2, pse, by = "year", all.x = TRUE)
cat("Panel v3:", nrow(panel_v3), "x", ncol(panel_v3), "\n\n")

# ── Variables derivadas ───────────────────────────────────────────────────────
# PSE como % del valor producción
if ("VoP_total_BOB_mm" %in% names(panel_v3)) {
  panel_v3[, PSE_pct_VoP := PSE_BOB_mm / VoP_total_BOB_mm * 100]
}

# GSSE como % PSE + GSSE (public goods share)
if (all(c("GSSE_BOB_mm", "PSE_BOB_mm") %in% names(panel_v3))) {
  panel_v3[, GSSE_pct_total_support := GSSE_BOB_mm / (PSE_BOB_mm + GSSE_BOB_mm) * 100]
}

# Deflactar PSE/GSSE/TSE a BOB 2015
if (all(c("PSE_BOB_mm", "cpi_2015base") %in% names(panel_v3))) {
  for (v in c("PSE_BOB_mm", "MPS_BOB_mm", "BT_BOB_mm_agg", "GSSE_BOB_mm",
              "TSE_BOB_mm", "CSE_BOB_mm", "VoP_total_BOB_mm")) {
    if (v %in% names(panel_v3)) {
      new_v <- paste0(sub("_BOB_mm", "", v), "_BOB_2015")
      panel_v3[, (new_v) := get(v) / (cpi_2015base / 100)]
    }
  }
}

# ── Resumen ───────────────────────────────────────────────────────────────────
cat("=== Panel Maestro v3 (1990-2024) ===\n")
cat("Variables:", ncol(panel_v3), "\n")
cat("Años:", paste(range(panel_v3$year), collapse="-"), "\n\n")

key <- list(
  "PSE nacional (BOB mm)"          = "PSE_BOB_mm",
  "PSE nacional (USD mm)"          = "PSE_USD_mm",
  "PSE % Valor de Producción"      = "PSEP_pct",
  "MPS (BOB mm)"                   = "MPS_BOB_mm",
  "GSSE (BOB mm)"                  = "GSSE_BOB_mm",
  "GSSE % apoyo total"             = "GSSE_pct_total_support",
  "TSE (BOB mm)"                   = "TSE_BOB_mm",
  "NPC productor"                  = "NPC_producer",
  "Inversión pública agro (USD)"   = "inv_agro_usd_mm",
  "EMAPA gasto b/s (BOB mm)"       = "emapa_bob_mm",
  "TFP Index"                      = "tfp_index",
  "PIB agropecuario % PIB"         = "agr_value_added_pct_gdp",
  "Rendimiento cereales"           = "cereal_yield_kg_ha",
  "GHG total agrícolas (Gg CO2e)"  = "GHG_total_GgCO2e"
)

for (lbl in names(key)) {
  v <- key[[lbl]]
  if (v %in% names(panel_v3)) {
    n <- sum(!is.na(panel_v3[[v]]))
    yrs <- if (n > 0) paste(range(panel_v3[!is.na(get(v)), year]), collapse="-") else "—"
    cat(sprintf("  %-38s %2d obs  %s\n", lbl, n, yrs))
  } else {
    cat(sprintf("  %-38s AUSENTE\n", lbl))
  }
}

# Save
saveRDS(panel_v3, file.path(proc_dir, "spending_panel_v3.rds"))
readr::write_csv(panel_v3, file.path(proc_dir, "spending_panel_v3.csv"))

cat("\n=== Panel v3 guardado: spending_panel_v3.rds (", ncol(panel_v3), "cols,", nrow(panel_v3), "años) ===\n")

# Vista clave de la serie PSE
cat("\n=== Serie PSE/GSSE/TSE Bolivia 2006-2023 (millones BOB 2015) ===\n")
print(panel_v3[year >= 2006 & !is.na(PSE_BOB_mm),
               .(year, PSE_BOB_2015, MPS_BOB_2015, GSSE_BOB_2015, TSE_BOB_2015,
                 PSEP_pct, NPC_producer)])
