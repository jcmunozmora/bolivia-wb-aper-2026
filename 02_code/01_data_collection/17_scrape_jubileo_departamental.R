# Scraping aggresivo Fundación Jubileo — nivel DEPARTAMENTAL
# =============================================================================
# BREAKTHROUGH (2026-04-21 noche):
#   El filtro POST depa[]=N SÍ funciona en el portal Jubileo.
#   Eso nos da acceso a 9 departamentos × 31 programas × 10 años.
#
# Filtros que funcionan:
#   - get_ges[]=N     (año: 25=2012, 19=2013, 20=2014, 21=2015, 22=2016,
#                         23=2017, 24=2018, 26=2019, 27=2020, 30=2021)
#   - depa[]=N        (depto: 1=Beni, 2=Chuquisaca, 3=Cochabamba, 4=Oruro,
#                         5=Pando, 6=Potosí, 7=Santa Cruz, 8=Tarija, 9=La Paz)
#   - get_tip[]=N     (tipo: 1=Corriente, 2=Inversión)
#
# Filtros que NO funcionan server-side:
#   - pro[]  get_pro[]  pro          (programa — es cliente-side en JS)
#   - mun[]  get_mun[]                (municipio — cliente-side)
#
# Output: 01_data/processed/jubileo_departamental_2012_2021.rds
#   9 depts × ~31 programas × 10 años × (corriente/inversión/total/%)
# =============================================================================

library(httr2)
library(data.table)
library(stringr)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
cache_dir <- file.path(root, "01_data/raw/jubileo/scraped_dept")
proc_dir <- file.path(root, "01_data/processed")
dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)

UA <- "Mozilla/5.0 WB-APER-Research/1.0 (jcmunozmora@gmail.com)"
BASE <- "https://pre.jubileobolivia.org.bo/"

# ─── Mapeo de departamentos (confirmado por ajax_municipios.php) ──────────────
DEPT_MAP <- list(
  list(code = 1, name = "Beni",        iso = "BO-B"),
  list(code = 2, name = "Chuquisaca",  iso = "BO-H"),
  list(code = 3, name = "Cochabamba",  iso = "BO-C"),
  list(code = 4, name = "Oruro",       iso = "BO-O"),
  list(code = 5, name = "Pando",       iso = "BO-N"),
  list(code = 6, name = "Potosí",      iso = "BO-P"),
  list(code = 7, name = "Santa Cruz",  iso = "BO-S"),
  list(code = 8, name = "Tarija",      iso = "BO-T"),
  list(code = 9, name = "La Paz",      iso = "BO-L")
)

# Años
YEAR_CODES <- c("25","19","20","21","22","23","24","26","27","30")
YEARS <- 2012:2021

# Tipos de gasto
TIP_MAP <- list(
  total     = NULL,       # sin filtro tip → total
  corriente = "1",
  inversion = "2"
)

# ─── Helper: fetch y cache ────────────────────────────────────────────────────
fetch_and_cache <- function(dept_code, tip_code = NULL, force = FALSE) {
  tip_str <- if (is.null(tip_code)) "total" else paste0("tip", tip_code)
  fname <- sprintf("dept%d_%s.html", dept_code, tip_str)
  fpath <- file.path(cache_dir, fname)

  if (!force && file.exists(fpath) && file.info(fpath)$size > 10000) {
    return(paste(readLines(fpath, warn = FALSE), collapse = "\n"))
  }

  body_parts <- c(paste0("get_ges[]=", YEAR_CODES),
                  sprintf("depa[]=%d", dept_code))
  if (!is.null(tip_code)) {
    body_parts <- c(body_parts, sprintf("get_tip[]=%s", tip_code))
  }
  body <- paste(body_parts, collapse = "&")

  req <- request(BASE) |>
    req_user_agent(UA) |>
    req_timeout(90) |>
    req_options(ssl_verifypeer = 0) |>
    req_retry(max_tries = 3, backoff = ~5) |>
    req_method("POST") |>
    req_body_raw(body, type = "application/x-www-form-urlencoded")

  resp <- req_perform(req)
  html <- resp_body_string(resp)
  writeLines(html, fpath, useBytes = TRUE)
  Sys.sleep(1.2)  # gentileza con el servidor
  html
}

# ─── Parser: extraer programas y sus 60 celdas ────────────────────────────────
parse_bob <- function(x) {
  x <- str_trim(x)
  if (is.na(x) || x == "") return(NA_real_)
  x <- str_replace_all(x, "\\.", "")
  x <- str_replace_all(x, ",", ".")
  x <- str_replace_all(x, "%", "")
  x <- str_replace_all(x, "\\s+", "")
  if (x == "") return(NA_real_)
  suppressWarnings(as.numeric(x))
}

extract_program_names <- function(html) {
  pat <- "<td>\\s*([0-9]+\\s+[A-ZÁÉÍÓÚÑ][^<]*|ADMINISTRACIÓN CENTRAL[^<]*|Otros Programas[^<]*|Total General[^<]*)\\s*</td>"
  m <- regmatches(html, gregexpr(pat, html, perl = TRUE))[[1]]
  sapply(m, function(x) {
    inner <- str_replace(x, "<td>\\s*", "") |>
      str_replace("\\s*</td>", "") |>
      str_trim()
    inner
  }, USE.NAMES = FALSE) |> unname()
}

extract_data_cells <- function(html) {
  pat <- '<td[^>]*align="right"[^>]*>\\s*([^<]*?)\\s*</td>'
  m <- regmatches(html, gregexpr(pat, html, perl = TRUE))[[1]]
  sapply(m, function(x) {
    str_replace(x, '<td[^>]*>\\s*', "") |>
      str_replace("\\s*</td>", "") |>
      str_trim()
  }, USE.NAMES = FALSE) |> unname()
}

parse_html_to_long <- function(html, dept_name, dept_code, tip_label) {
  prog_names <- extract_program_names(html)
  cells      <- extract_data_cells(html)

  prog_labeled <- prog_names[grep("^[0-9]+\\s|Total General", prog_names)]
  prog_labeled <- prog_labeled[!grepl("^Total General", prog_labeled)]

  # Encontrar primera celda numérica > 1M (después de header "Total General:")
  first_data <- NA
  for (i in seq_along(cells)) {
    v <- parse_bob(cells[i])
    if (!is.na(v) && v > 1e5) { first_data <- i; break }
  }
  if (is.na(first_data)) return(NULL)
  data_vals <- cells[first_data:length(cells)]

  # Cada programa tiene 60 celdas (6 × 10 años). Los primeros 60 son "Total General"
  n_programs <- floor(length(data_vals) / 60) - 1  # -1 por el Total General
  if (n_programs < 5) {
    # A veces no hay "Total General" separado, estimación distinta
    n_programs <- floor(length(data_vals) / 60)
  }

  # Saltar primeros 60 (Total General)
  data_vals_programs <- data_vals[61:length(data_vals)]

  out <- list()
  for (p_idx in seq_len(min(length(prog_labeled), n_programs))) {
    prog_name <- prog_labeled[p_idx]
    start_cell <- (p_idx - 1) * 60 + 1
    vals <- data_vals_programs[start_cell:(start_cell + 59)]
    if (length(vals) < 60) next

    for (i in seq_along(YEARS)) {
      s <- (i - 1) * 6 + 1
      out[[length(out) + 1]] <- data.table(
        dept_code     = dept_code,
        dept          = dept_name,
        program       = prog_name,
        tip           = tip_label,
        year          = YEARS[i],
        corriente_bob = parse_bob(vals[s]),
        corriente_pct = parse_bob(vals[s + 1]),
        inversion_bob = parse_bob(vals[s + 2]),
        inversion_pct = parse_bob(vals[s + 3]),
        total_bob     = parse_bob(vals[s + 4]),
        total_pct     = parse_bob(vals[s + 5])
      )
    }
  }
  rbindlist(out, fill = TRUE)
}

# ─── Scraping orchestrator ────────────────────────────────────────────────────
scrape_all_depts <- function() {
  all_data <- list()

  cat("=== Scraping 9 departamentos × agregado ===\n")
  for (d in DEPT_MAP) {
    cat(sprintf("  Dept %d — %s", d$code, d$name))
    html <- fetch_and_cache(d$code, tip_code = NULL)
    dt <- parse_html_to_long(html, d$name, d$code, "total")
    if (!is.null(dt) && nrow(dt) > 0) {
      all_data[[paste0(d$code, "_total")]] <- dt
      cat(sprintf(" → %d filas (%d programas × 10 años)\n",
                  nrow(dt), length(unique(dt$program))))
    } else {
      cat(" → fallo\n")
    }
  }

  cat("\n=== Consolidando dataset ===\n")
  dt_all <- rbindlist(all_data, fill = TRUE)
  dt_all[, program_code := str_extract(program, "^\\d+")]

  cat("Total registros:", nrow(dt_all), "\n")
  cat("Departamentos:", paste(unique(dt_all$dept), collapse = ", "), "\n")
  cat("Años:", paste(range(dt_all$year), collapse = "-"), "\n")
  cat("Programas únicos:", length(unique(dt_all$program_code)), "\n")

  dt_all
}

# ─── MAIN ────────────────────────────────────────────────────────────────────
main <- function() {
  cat("┌──────────────────────────────────────────────────────────────┐\n")
  cat("│ Scraper Jubileo DEPARTAMENTAL 2012-2021                      │\n")
  cat("│ Expectativa: 9 depts × 31 programas × 10 años = 2,790 filas │\n")
  cat("└──────────────────────────────────────────────────────────────┘\n\n")

  dt <- scrape_all_depts()

  # Guardar
  saveRDS(dt, file.path(proc_dir, "jubileo_departamental_2012_2021.rds"))
  fwrite(dt, file.path(proc_dir, "jubileo_departamental_2012_2021.csv"))
  cat("\n✓ Guardado: jubileo_departamental_2012_2021.{rds,csv}\n")

  # Resumen por depto
  cat("\n=== Resumen por departamento (Programa 10 — Agropecuario) ===\n")
  p10 <- dt[program_code == "10",
            .(total_bob_mm = sum(total_bob, na.rm = TRUE) / 1e6),
            by = .(dept, year)]
  p10_wide <- dcast(p10, dept ~ year, value.var = "total_bob_mm")
  print(p10_wide)

  cat("\n=== Top 3 depts 2021 Programa 10 ===\n")
  print(dt[program_code == "10" & year == 2021][order(-total_bob),
          .(dept, total_bob, corriente_bob, inversion_bob)])

  invisible(dt)
}

if (!interactive()) main()
