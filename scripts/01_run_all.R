# =============================================================================
# 01_run_all.R — Orquestador del pipeline completo
# Bolivia Agricultural Public Expenditure Review 2026
# =============================================================================
# Re-ejecuta TODO el pipeline en orden canónico:
#   raw → processed → panel maestro → figuras
#
# Pre-requisito: haber corrido `bash scripts/00_download_raw.sh` para tener
# los datos raw en 01_data/raw/
#
# Uso:
#   Rscript scripts/01_run_all.R
# =============================================================================

library(cli)  # cli_alert_*; opcional

root <- normalizePath(file.path(dirname(sys.frame(1)$ofile), ".."), mustWork = FALSE)
if (!dir.exists(root)) root <- getwd()

cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("  Bolivia Agricultural Public Expenditure Review 2026\n")
cat("  Pipeline completo: raw → processed → panel → figuras\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

run_step <- function(name, script, required_file = NULL) {
  cat(sprintf("\n[%s] %s\n", format(Sys.time(), "%H:%M:%S"), name))

  if (!is.null(required_file) && !file.exists(required_file)) {
    cat(sprintf("  ⚠ SKIP: falta archivo requerido %s\n", required_file))
    cat("    Ejecutar primero: bash scripts/00_download_raw.sh\n")
    return(invisible(FALSE))
  }

  t0 <- Sys.time()
  result <- tryCatch({
    source(script, local = new.env())
    TRUE
  }, error = function(e) {
    cat(sprintf("  ✗ ERROR: %s\n", conditionMessage(e)))
    FALSE
  })
  dt <- difftime(Sys.time(), t0, units = "secs")

  if (result) {
    cat(sprintf("  ✓ OK (%.1f seg)\n", as.numeric(dt)))
  }
  invisible(result)
}

# ─────────────────────────────────────────────────────────────────────────────
# ETAPA 1: Setup
# ─────────────────────────────────────────────────────────────────────────────
run_step("1.1 Carga de paquetes",
         "02_code/00_setup/00_packages.R")

# ─────────────────────────────────────────────────────────────────────────────
# ETAPA 2: Descarga/procesamiento por fuente (orden independiente)
# ─────────────────────────────────────────────────────────────────────────────
run_step("2.1 Descargar shapefiles Bolivia (geoBoundaries)",
         "02_code/01_data_collection/07_download_spatial.R")

run_step("2.2 Procesar APER Bolivia 1996-2008",
         "02_code/01_data_collection/08_process_aper.R",
         required_file = "01_data/raw/boost/WB_Bolivia_APER.xlsx")

run_step("2.3 Procesar USDA TFP 1961-2023",
         "02_code/01_data_collection/09_process_usda_tfp.R",
         required_file = "01_data/raw/usda_ers/usda_ers_tfp_international.csv")

run_step("2.4 Parsear MEFP Boletín ETA 2022",
         "02_code/01_data_collection/12_parse_mefp_boletin.R",
         required_file = "01_data/raw/mefp/boletin_eef_eta_2022.pdf")

run_step("2.5 Parsear MEFP Informe Fiscal 2024 (todas las series)",
         "02_code/01_data_collection/13_parse_informe_fiscal_2024.R",
         required_file = "01_data/raw/mefp/Informe_Fiscal_2024.pdf")

run_step("2.6 Parsear Inversión Pública Sectorial (Cuadros 26a/26b)",
         "02_code/01_data_collection/14_parse_inversion_publica_sectorial.R",
         required_file = "01_data/raw/mefp/Informe_Fiscal_2024.pdf")

# IDB Agrimonitor: el archivo tiene nombre con timestamp, verificar heurísticamente
idb_csv <- list.files("01_data/raw/idb_agrimonitor",
                       pattern = "Agrimonitor Dataset\\.csv$",
                       recursive = TRUE, full.names = TRUE)
if (length(idb_csv) > 0) {
  run_step("2.7 Procesar IDB Agrimonitor PSE (metodología OCDE)",
           "02_code/01_data_collection/15_process_idb_agrimonitor.R")
} else {
  cat("\n[SKIP] 2.7 IDB Agrimonitor — archivo no encontrado\n")
  cat("    Descargar manualmente desde:\n")
  cat("    https://data.iadb.org/dataset/idb-agrimonitor-producer-support-estimates-pse-agricultural-policy-monitori\n")
}

# ─────────────────────────────────────────────────────────────────────────────
# ETAPA 3: Integración panel maestro (orden secuencial obligatorio)
# ─────────────────────────────────────────────────────────────────────────────
run_step("3.1 Deflactores y tipo de cambio",
         "02_code/02_cleaning/05_deflate_aggregate.R")

run_step("3.2 Panel v1 (WDI + APER + deflactores)",
         "02_code/02_cleaning/06_build_panel.R")

run_step("3.3 Panel v2 (+ VIPFE inversión sectorial + EMAPA + TFP)",
         "02_code/02_cleaning/07_integrate_siif_proxies.R")

run_step("3.4 Panel v3 (+ IDB PSE + GHG) — CANÓNICO",
         "02_code/02_cleaning/08_integrate_pse.R")

# ─────────────────────────────────────────────────────────────────────────────
# ETAPA 4: Análisis y figuras
# ─────────────────────────────────────────────────────────────────────────────
run_step("4.1 Análisis descriptivo (figuras 1-5)",
         "02_code/03_analysis/01_descriptive_spending.R")

# ─────────────────────────────────────────────────────────────────────────────
# Cierre
# ─────────────────────────────────────────────────────────────────────────────
cat("\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
cat("  Pipeline completado.\n")
cat("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")

# Verificación final
if (file.exists("01_data/processed/spending_panel_v3.rds")) {
  panel <- readRDS("01_data/processed/spending_panel_v3.rds")
  cat(sprintf("\n✓ Panel maestro v3: %d años × %d variables\n",
              nrow(panel), ncol(panel)))
}

n_figs <- length(list.files("05_outputs/figures", pattern = "\\.png$"))
cat(sprintf("✓ Figuras generadas: %d PNG en 05_outputs/figures/\n", n_figs))

cat("\nPróximo paso: renderizar el reporte\n")
cat("  quarto render 04_report/\n\n")
