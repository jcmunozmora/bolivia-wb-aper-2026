# MEFP — Tasas de Ejecución Presupuestaria anual 2015-2023
# =============================================================================
# Fuente: Ejecucion_YYYY.pdf (9 PDFs, 2015-2023) — DGAA MEFP
# Estructura consistente: Grupo de Gasto × Dirección Admin × (Inicial/Vigente/
#   Ejecutado/% Ejecución)
# Cobertura: SOLO Ministerio de Economía y Finanzas Públicas (Entidad 035)
#
# Uso: benchmark de tasa de ejecución de un ministerio central.
#   Para MDRyT/INIAF/SENASAG → carta formal MEFP DS 28168 (no disponible en PDFs)
#
# Outputs:
#   mefp_ejecucion_grupo.rds  — Grupo de Gasto × año × (inicial/vigente/ejec/%)
#   mefp_ejecucion_da.rds     — Dirección Admin × año
#   mefp_ejecucion_anual.rds  — Serie anual TOTAL 2015-2023 (9 puntos)
# =============================================================================

library(pdftools)
library(data.table)
library(stringr)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
raw  <- file.path(root, "01_data/raw/mefp")
proc <- file.path(root, "01_data/processed")

# ── Helper: parser de números estilo europeo ("1.234.567,89" → numeric) ──────
parse_eu <- function(x) {
  x <- gsub("\\s", "", x)
  x <- gsub("\\.", "", x)
  x <- gsub(",", ".", x)
  suppressWarnings(as.numeric(x))
}

# Detecta filas de datos con patrón:
#   CODE(opcional) DESCRIPCION  NUM1 NUM2 NUM3 NUM4%
# donde NUMs son estilo europeo y el último tiene sufijo %
extract_table_rows <- function(lines, code_regex = "^\\s*(\\d{1,5})") {
  num_pat <- "-?[0-9.]+,[0-9]+"
  # Buscar líneas con 4 números incluyendo uno con %
  data_rows <- list()
  for (ln in lines) {
    nums <- str_extract_all(ln, num_pat)[[1]]
    pct  <- str_extract(ln, "[\\d.]+,\\d+%")
    if (length(nums) >= 3 && !is.na(pct)) {
      # Tomar los últimos 3 números antes del % como vigente/ejecutado/%
      # Simpler: tomar todos los números, el último es %
      nums_clean <- parse_eu(nums)
      pct_clean  <- parse_eu(sub("%$", "", pct))
      # Necesitamos 3 montos + 1 pct = 4 valores mínimos
      if (length(nums_clean) >= 4) {
        # inicial, vigente, ejecutado, pct
        inicial    <- nums_clean[length(nums_clean) - 3]
        vigente    <- nums_clean[length(nums_clean) - 2]
        ejecutado  <- nums_clean[length(nums_clean) - 1]
        pct_val    <- pct_clean
        # Descripción = línea sin los números
        desc <- ln
        desc <- gsub(num_pat, "", desc)
        desc <- gsub("%", "", desc)
        desc <- gsub("\\s+", " ", trimws(desc))
        # Quitar código inicial si existe
        code <- str_extract(desc, "^\\d+")
        desc <- trimws(sub("^\\d+\\s*", "", desc))
        data_rows[[length(data_rows) + 1]] <- list(
          code = code, desc = desc,
          inicial = inicial, vigente = vigente,
          ejecutado = ejecutado, pct_ejecucion = pct_val
        )
      }
    }
  }
  rbindlist(data_rows, fill = TRUE)
}

# ── Parseo por año ────────────────────────────────────────────────────────────
cat("=== Parseando 9 Ejecucion_YYYY.pdf (2015-2023) ===\n\n")
files <- c(
  "2015" = "Ejecucion_2015.pdf",
  "2016" = "Ejecucion_2016.pdf",
  "2017" = "Ejecucion_2017.pdf",
  "2018" = "Ejecucion_2018.pdf",
  "2019" = "Ejecucion_2019.pdf",
  "2020" = "Ejecucion_2020.pdf",
  "2021" = "Ejecucion_2021.pdf",
  "2022" = "ejecucion_2022.pdf",
  "2023" = "ejecucion_2023.pdf"
)

grupo_all <- list()
da_all    <- list()

# Detector robusto: escanear TODAS las páginas buscando filas con grupo code + 3 montos + %
detect_grupo_page <- function(txt) {
  candidates <- list()
  for (p in seq_along(txt)) {
    lines <- strsplit(txt[p], "\n")[[1]]
    n_complete <- 0
    for (ln in lines) {
      # Line starts with grupo code AND has 3+ decimals AND has percentage
      if (grepl("^\\s*[1-9]0000\\*?\\s", ln) &&
          length(str_extract_all(ln, "[\\d.]+,\\d+")[[1]]) >= 3 &&
          grepl("\\d+,\\d+\\s*%", ln)) {
        n_complete <- n_complete + 1
      }
    }
    if (n_complete >= 4) candidates <- c(candidates, list(list(page = p, n = n_complete)))
  }
  if (length(candidates) == 0) return(NA_integer_)
  # Pick page with most complete rows
  ns <- sapply(candidates, function(x) x$n)
  candidates[[which.max(ns)]]$page
}

for (yr in names(files)) {
  f <- file.path(raw, files[[yr]])
  if (!file.exists(f)) { cat(sprintf("  %s NO ENCONTRADO\n", f)); next }
  txt <- pdf_text(f)
  p_grupo <- detect_grupo_page(txt)
  cat(sprintf("%s: Grupo page=%s (of %d)\n",
              yr, ifelse(is.na(p_grupo), "-", p_grupo), length(txt)))

  if (!is.na(p_grupo)) {
    lines <- strsplit(txt[p_grupo], "\n")[[1]]
    # Solo líneas que inician con código grupo
    grupo_lines <- lines[grepl("^\\s*[1-9]0000\\*?\\s", lines)]
    tbl <- extract_table_rows(grupo_lines)
    if (nrow(tbl) > 0 && "code" %in% names(tbl)) {
      tbl_g <- tbl[!is.na(code) & grepl("^[1-9]0000$", sub("\\*$", "", code))]
      if (nrow(tbl_g) > 0) {
        tbl_g[, year := as.integer(yr)]
        grupo_all[[yr]] <- tbl_g
      }
    }
  }
}

grupo_panel <- rbindlist(grupo_all, fill = TRUE)
da_panel    <- rbindlist(da_all,    fill = TRUE)

cat(sprintf("\n=== Panel Grupo de Gasto: %d obs × %d vars ===\n",
            nrow(grupo_panel), ncol(grupo_panel)))
print(grupo_panel[year == 2023])

# DA parsing skipped (text wrapping en PDFs no permite extracción limpia)
da_panel <- data.table()
cat("\n=== Dirección Admin NO extraída (texto wrappeado en PDFs) ===\n")

# ── Normalizar descripciones de Grupo (consistencia entre años) ───────────────
grupo_panel[, grupo_desc := fcase(
  code == "10000", "Servicios Personales",
  code == "20000", "Servicios No Personales",
  code == "30000", "Materiales y Suministros",
  code == "40000", "Activos Reales",
  code == "50000", "Activos Financieros",
  code == "60000", "Servicio de la Deuda Pública",
  code == "70000", "Transferencias",
  code == "80000", "Impuestos, Regalías y Tasas",
  code == "90000", "Otros Gastos",
  default = desc
)]

# ── Serie anual TOTAL ──────────────────────────────────────────────────────────
cat("\n=== Serie anual TOTAL (Ejecución MEFP) ===\n")
total <- grupo_panel[, .(
  presup_vigente_mm_bs = sum(vigente,  na.rm = TRUE) / 1e6,
  ejecutado_mm_bs      = sum(ejecutado, na.rm = TRUE) / 1e6,
  pct_ejec_ponderado   = sum(ejecutado, na.rm = TRUE) / sum(vigente, na.rm = TRUE) * 100
), by = year]
setorder(total, year)
print(total)

# Composición 2023
cat("\n=== Composición gasto MEFP 2023 por grupo (% vigente) ===\n")
comp <- grupo_panel[year == 2023, .(
  grupo_desc, pct_ejecucion,
  pct_vigente = round(vigente / sum(vigente) * 100, 1),
  ejecutado_mm_bs = round(ejecutado / 1e6, 1)
)]
print(comp)

# ── Guardar ───────────────────────────────────────────────────────────────────
saveRDS(grupo_panel, file.path(proc, "mefp_ejecucion_grupo.rds"))
saveRDS(total,       file.path(proc, "mefp_ejecucion_anual.rds"))
fwrite(grupo_panel,  file.path(proc, "mefp_ejecucion_grupo.csv"))
fwrite(total,        file.path(proc, "mefp_ejecucion_anual.csv"))

cat(sprintf("\n✓ mefp_ejecucion_grupo.rds (%d obs)\n",  nrow(grupo_panel)))
cat(sprintf("✓ mefp_ejecucion_anual.rds (%d años)\n",   nrow(total)))

cat("\n=== LIMITACIONES ===\n")
cat("• Datos cubren SOLO MEFP (Entidad 035); no MDRyT/INIAF/SENASAG.\n")
cat("• Para tasas de ejecución agropecuarias → carta formal DS 28168 al MEFP.\n")
cat("• Benchmark útil: compararcon MDRyT si se obtiene en el futuro.\n")
