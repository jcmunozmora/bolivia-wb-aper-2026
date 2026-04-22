# Descarga de fuentes alternativas para estimar gasto agropecuario Bolivia 2009-2023
# Estrategia: triangulación entre fuentes mientras se obtiene SIIF del MEFP

library(httr2)
library(data.table)
library(tidyverse)

here_root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
raw_dir   <- file.path(here_root, "01_data/raw")

# Browser user agent (Bolivia sites often filter curl)
UA <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/605.1.15"

safe_download <- function(url, out_file, max_time = 60) {
  dir.create(dirname(out_file), recursive = TRUE, showWarnings = FALSE)
  resp <- tryCatch({
    req <- request(url) |>
      req_user_agent(UA) |>
      req_timeout(max_time) |>
      req_options(ssl_verifypeer = 0)
    req_perform(req)
  }, error = function(e) { cat("  ERROR:", conditionMessage(e), "\n"); NULL })

  if (!is.null(resp) && resp_status(resp) == 200) {
    writeBin(resp_body_raw(resp), out_file)
    sz <- file.info(out_file)$size / 1024
    cat(sprintf("  OK  %s  (%.1f KB)\n", basename(out_file), sz))
    return(TRUE)
  } else {
    cat(sprintf("  FAIL %s  (HTTP %s)\n", basename(out_file),
                if (is.null(resp)) "ERR" else resp_status(resp)))
    return(FALSE)
  }
}

# ── 1. IFPRI SPEED Database (Harvard Dataverse) ───────────────────────────────
cat("\n=== IFPRI SPEED 2019 (Harvard Dataverse) ===\n")
# Dataverse API para descargar dataset completo como ZIP
speed_url <- "https://dataverse.harvard.edu/api/access/dataset/:persistentId?persistentId=doi:10.7910/DVN/F7IOM7"
safe_download(speed_url, file.path(raw_dir, "ifpri_speed/IFPRI_SPEED_2019_dataset.zip"), max_time = 120)

# ── 2. IDB Agrimonitor Bolivia PSE ─────────────────────────────────────────────
cat("\n=== IDB Agrimonitor ===\n")
# Nota: el portal Agrimonitor usa API; exportación manual recomendada
# Intentar descarga de página con metadatos
safe_download(
  "https://data.iadb.org/dataset/idb-agrimonitor-producer-support-estimates-pse-agricultural-policy-monitori",
  file.path(raw_dir, "idb_agrimonitor/agrimonitor_metadata.html")
)

# ── 3. IMF Government Finance Statistics (Bolivia subset) ──────────────────────
cat("\n=== IMF GFS (se recomienda descarga interactiva) ===\n")
cat("URL: https://data.imf.org/?sk=a0867067-d23c-4ebc-ad23-d3b015045405\n")
cat("Buscar Bolivia > COFOG 04.2 (Agriculture, forestry, fishing)\n")

# ── 4. CEPALSTAT: Gasto público social como % PIB ─────────────────────────────
cat("\n=== CEPALSTAT API ===\n")
# CEPALSTAT tiene API REST: https://statistics.cepal.org/portal/cepalstat/
# Indicador de gasto social en agricultura es difícil de encontrar
# Intentar indicador 341 que apareció en URL
safe_download(
  "https://statistics.cepal.org/portal/cepalstat/dataBank.html?lang=en&indicator_id=341&members=214",
  file.path(raw_dir, "cepal/cepal_agriculture_spending_BOL.html")
)

# ── 5. World Bank BOOST Portal country data ────────────────────────────────────
cat("\n=== WB BOOST Portal ===\n")
safe_download(
  "https://www.worldbank.org/en/programs/boost-portal/country-data",
  file.path(raw_dir, "wb_reports/boost_portal_countries.html")
)

# ── 6. Bolivia PGE (Presupuesto General del Estado) 2009-2023 ──────────────────
cat("\n=== Bolivia PGE 2009-2023 (patrón de URL Gaceta Oficial) ===\n")
# Intentar patrón directo del sitio gacetaoficial
pge_base <- "http://www.gacetaoficialdebolivia.gob.bo"
safe_download(paste0(pge_base, "/normas/buscar_comp/PGE"),
              file.path(raw_dir, "mefp/pge_listado.html"))

# ── 7. Banco Central Bolivia — Boletín Estadístico ─────────────────────────────
cat("\n=== BCB Boletín Estadístico ===\n")
safe_download(
  "https://www.bcb.gob.bo/?q=pub_boletin-estadistico",
  file.path(raw_dir, "bcb/bcb_boletines_index.html")
)

cat("\n=== Resumen ===\n")
cat("Archivos descargados en", raw_dir, "\n")
cat("Subdirectorios:", paste(list.dirs(raw_dir, recursive = FALSE, full.names = FALSE), collapse = ", "), "\n")

# ── 8. Siguiente paso sugerido ─────────────────────────────────────────────────
cat("\n=== Recomendaciones ===\n")
cat("1. SPEED requiere descompresión manual del ZIP\n")
cat("2. Agrimonitor: acceder interactivamente y exportar Bolivia PSE series\n")
cat("3. IMF GFS: registrar cuenta gratuita y exportar Bolivia CSV\n")
cat("4. PGE: parsear listado HTML y descargar los 15 PDFs de leyes anuales\n")
