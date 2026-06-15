# =============================================================================
# Pobreza departamental OFICIAL (INE) — incidencia moderada y extrema
# -----------------------------------------------------------------------------
# Fuente: INE Bolivia, Encuestas de Hogares. Tablas ya calculadas por el INE
# (NO se reprocesan microdatos → sin problemas de confidencialidad ni de método).
# Descargadas de https://nube.ine.gob.bo (ver URLs abajo) a 01_data/raw/ine_pobreza/
#
# Dos series por cambio de Canasta Básica Alimentaria (CBA):
#   - cba_2011_2018 : metodología CBA antigua,  años 2011-2018
#   - cba_2016_2024 : metodología CBA vigente,   años 2016-2024  (PRINCIPAL)
# Solapan 2016-2018 → NO encadenar mecánicamente; usar una serie consistente y
# reportar el quiebre. La serie vigente (2016-2024) solapa el gasto deptal
# (Jubileo 2012-2021) en 2016-2021 = 6 años × 9 deptos = 54 obs.
#
# Layout del Excel: cada departamento es un bloque de 3 filas
#   <DEPTO> / "Población total" / "Población pobre" / "Incidencia de pobreza ..."
# La fila "Incidencia" da el % por año (cols = años en la fila de encabezado).
#
# Output: 01_data/processed/ine_pobreza_departamental.rds (+ .csv) — formato long
# =============================================================================

source(here::here("02_code", "00_setup", "01_constants.R"))
suppressPackageStartupMessages({
  library(data.table)
  library(readxl)
})

raw_dir <- file.path(DIR_DATA_RAW, "ine_pobreza")
DEPTS_UP <- toupper(DEPTS)   # 9 deptos sin "BOLIVIA"

FILES <- list(
  list(f = "pobreza_mod_2011_2018.xlsx", indicador = "moderada", serie = "cba_2011_2018"),
  list(f = "pobreza_ext_2011_2018.xlsx", indicador = "extrema",  serie = "cba_2011_2018"),
  list(f = "pobreza_mod_2016_2024.xlsx", indicador = "moderada", serie = "cba_2016_2024"),
  list(f = "pobreza_ext_2016_2024.xlsx", indicador = "extrema",  serie = "cba_2016_2024")
)

# Parsea UNA hoja de incidencia depto×año → long, o NULL si la hoja no aplica.
parse_sheet <- function(path, sheet) {
  d <- suppressMessages(as.data.frame(read_excel(path, sheet = sheet, col_names = FALSE)))
  if (nrow(d) < 5) return(NULL)
  clean <- function(x) trimws(gsub("\\s+", " ", as.character(x)))

  # 1) Fila de encabezado: ≥3 celdas que son años 2000-2030
  is_year <- function(v) { n <- suppressWarnings(as.numeric(v)); !is.na(n) & n >= 2000 & n <= 2030 }
  hdr <- which(vapply(seq_len(nrow(d)),
                      function(i) sum(is_year(unlist(d[i, ])), na.rm = TRUE) >= 3, logical(1)))[1]
  if (is.na(hdr)) return(NULL)
  yr_vals <- suppressWarnings(as.numeric(unlist(d[hdr, ])))
  ycols   <- which(!is.na(yr_vals) & yr_vals >= 2000 & yr_vals <= 2030)
  years   <- yr_vals[ycols]

  # 2) Recorrer filas: rastrear depto actual; capturar fila "Incidencia"
  out <- list(); cur <- NA_character_
  for (i in (hdr + 1):nrow(d)) {
    lab <- clean(d[i, 1])
    if (toupper(lab) %in% DEPTS_UP) { cur <- toupper(lab); next }
    if (grepl("^Incidencia", lab, ignore.case = TRUE) && !is.na(cur)) {
      vals <- suppressWarnings(as.numeric(unlist(d[i, ycols])))
      out[[length(out) + 1]] <- data.table(dept_upper = cur, year = years, value_pct = vals)
    }
  }
  if (length(out) == 0) return(NULL)
  rbindlist(out)
}

# Recorre las hojas y devuelve la primera con el cuadro de incidencia (≥9 deptos).
parse_ine_pobreza <- function(path) {
  for (sh in excel_sheets(path)) {
    res <- tryCatch(parse_sheet(path, sh), error = function(e) NULL)
    if (!is.null(res) && uniqueN(res$dept_upper) >= 9) return(res)
  }
  stop("No se encontró hoja de incidencia depto×año en ", basename(path))
}

pob <- rbindlist(lapply(FILES, function(x) {
  dt <- parse_ine_pobreza(file.path(raw_dir, x$f))
  dt[, `:=`(indicador = x$indicador, serie = x$serie)]
  dt
}))
pob <- pob[!is.na(value_pct)]
setcolorder(pob, c("dept_upper", "year", "indicador", "serie", "value_pct"))
setorder(pob, serie, indicador, dept_upper, year)

# ── Validación ───────────────────────────────────────────────────────────────
cat(sprintf("Pobreza INE deptal: %d filas | deptos %d | indicadores: %s | series: %s\n",
            nrow(pob), uniqueN(pob$dept_upper),
            paste(unique(pob$indicador), collapse = ", "),
            paste(unique(pob$serie), collapse = ", ")))
stopifnot(uniqueN(pob$dept_upper) == 9, all(pob$value_pct >= 0 & pob$value_pct <= 100))

cat("\n=== Cobertura por serie × año (nº deptos con dato, indicador moderada) ===\n")
print(dcast(pob[indicador == "moderada"], year ~ serie, value.var = "value_pct",
            fun.aggregate = length))

cat("\n=== Consistencia del solape 2016-2018 (moderada, dato nacional implícito por media simple) ===\n")
ov <- pob[indicador == "moderada" & year %in% 2016:2018,
          .(media_deptos = round(mean(value_pct), 1)), by = .(year, serie)]
print(dcast(ov, year ~ serie, value.var = "media_deptos"))

# ── Guardar ───────────────────────────────────────────────────────────────────
saveRDS(pob, file.path(DIR_DATA_PRO, "ine_pobreza_departamental.rds"))
fwrite(pob,  file.path(DIR_DATA_PRO, "ine_pobreza_departamental.csv"))
cat("\n✓ Guardado: ine_pobreza_departamental.{rds,csv}\n")
cat("  Fuente: INE Encuestas de Hogares (tablas oficiales, descarga nube.ine.gob.bo)\n")
