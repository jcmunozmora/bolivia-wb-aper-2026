# Scraping masivo Jubileo — NIVEL MUNICIPAL (339 municipios)
# =============================================================================
# TRIPLE BREAKTHROUGH (2026-04-22):
#   Los filtros correctos son:
#     - depa[]=N         (array format, múltiples departamentos)
#     - get_mun=RELID    (single value, rel ID del municipio)
#     - get_pro=N        (single value, código programa)
#     - get_mun=322:324  (colon separator para múltiples)
#     - get_pro=10:12:32 (colon separator)
#     - get_ges[]=YYY    (array format)
#
# Paso 1: Obtener catálogo de 339 municipios desde ajax_municipios.php
# Paso 2: Para cada municipio, hacer 1 request sin filtro de programa
#         → obtiene 34 programas × 10 años para ese municipio
# Paso 3: Parsear y consolidar en panel municipal completo
#
# Output: 01_data/processed/jubileo_municipal_full_2012_2021.rds
#   ~339 municipios × 34 programas × 10 años = ~115,000 observaciones
# =============================================================================

library(httr2)
library(data.table)
library(stringr)

root      <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
cache_dir <- file.path(root, "01_data/raw/jubileo/scraped_muni")
proc_dir  <- file.path(root, "01_data/processed")
dir.create(cache_dir, recursive = TRUE, showWarnings = FALSE)

UA   <- "Mozilla/5.0 WB-APER-Research/1.0 (jcmunozmora@gmail.com)"
BASE <- "https://pre.jubileobolivia.org.bo/"

DEPT_MAP <- list(
  list(code = 1, name = "Beni"),       list(code = 2, name = "Chuquisaca"),
  list(code = 3, name = "Cochabamba"), list(code = 4, name = "Oruro"),
  list(code = 5, name = "Pando"),      list(code = 6, name = "Potosí"),
  list(code = 7, name = "Santa Cruz"), list(code = 8, name = "Tarija"),
  list(code = 9, name = "La Paz")
)

YEAR_CODES <- c("25","19","20","21","22","23","24","26","27","30")
YEARS <- 2012:2021

# ─── 1. Construir catálogo de municipios ──────────────────────────────────────
fetch_municipios_catalog <- function() {
  cat("Construyendo catálogo de municipios...\n")
  out <- list()
  for (d in DEPT_MAP) {
    resp <- request(paste0(BASE, "xtras/ajax_municipios.php")) |>
      req_user_agent(UA) |> req_timeout(30) |>
      req_options(ssl_verifypeer = 0) |> req_method("POST") |>
      req_body_raw(sprintf("dep=%d", d$code),
                   type = "application/x-www-form-urlencoded") |>
      req_perform()
    html <- resp_body_string(resp)

    # Parse: <li><a ... rel="324" ...> 1903 - Bolpebra</a></li>
    pat <- 'rel="(\\d+)"[^>]*>\\s*([0-9]+)\\s*-\\s*([^<]+?)\\s*</a>'
    m <- regmatches(html, gregexpr(pat, html, perl = TRUE))[[1]]
    for (line in m) {
      parts <- regmatches(line, regexec(pat, line, perl = TRUE))[[1]]
      if (length(parts) >= 4) {
        out[[length(out) + 1]] <- data.table(
          dept_code = d$code, dept_name = d$name,
          rel_id    = as.integer(parts[2]),
          muni_code = as.integer(parts[3]),
          muni_name = str_trim(parts[4])
        )
      }
    }
    Sys.sleep(0.5)
  }
  catalog <- rbindlist(out)
  cat("  Municipios encontrados:", nrow(catalog), "\n")
  cat("  Por depto:\n")
  print(catalog[, .N, by = .(dept_code, dept_name)])
  catalog
}

# ─── 2. Scrape municipio individual ───────────────────────────────────────────
scrape_muni <- function(rel_id, dept_code, cache = TRUE) {
  fname <- sprintf("mun_rel%d_dept%d.html", rel_id, dept_code)
  fpath <- file.path(cache_dir, fname)

  if (cache && file.exists(fpath) && file.info(fpath)$size > 10000) {
    return(paste(readLines(fpath, warn = FALSE), collapse = "\n"))
  }

  body_parts <- c(paste0("get_ges[]=", YEAR_CODES),
                  sprintf("depa[]=%d", dept_code),
                  sprintf("get_mun=%d", rel_id))
  body <- paste(body_parts, collapse = "&")

  resp <- tryCatch({
    request(BASE) |>
      req_user_agent(UA) |> req_timeout(90) |>
      req_options(ssl_verifypeer = 0) |>
      req_retry(max_tries = 3, backoff = ~5) |>
      req_method("POST") |>
      req_body_raw(body, type = "application/x-www-form-urlencoded") |>
      req_perform()
  }, error = function(e) NULL)

  if (is.null(resp) || resp_status(resp) != 200) return(NULL)
  html <- resp_body_string(resp)
  writeLines(html, fpath, useBytes = TRUE)
  Sys.sleep(0.8)  # 0.8 seg delay → ~340 segundos = 5.7 min para 339 munis
  html
}

# ─── 3. Parser (reutiliza lógica probada) ────────────────────────────────────
parse_bob <- function(x) {
  x <- str_trim(x)
  if (is.na(x) || x == "") return(NA_real_)
  x <- gsub("\\.", "", x)
  x <- gsub(",", ".", x)
  x <- gsub("%", "", x)
  x <- gsub("\\s+", "", x)
  if (x == "") return(NA_real_)
  suppressWarnings(as.numeric(x))
}

extract_programs <- function(html) {
  pat <- "<td>\\s*([0-9]+\\s+[A-ZÁÉÍÓÚÑ][^<]*|ADMINISTRACIÓN CENTRAL[^<]*|Otros Programas[^<]*|Total General[^<]*)\\s*</td>"
  m <- regmatches(html, gregexpr(pat, html, perl = TRUE))[[1]]
  sapply(m, function(x) {
    str_trim(gsub("<[^>]+>", "", x))
  }, USE.NAMES = FALSE) |> unname()
}

extract_cells <- function(html) {
  pat <- '<td[^>]*align="right"[^>]*>\\s*([^<]*?)\\s*</td>'
  m <- regmatches(html, gregexpr(pat, html, perl = TRUE))[[1]]
  sapply(m, function(x) {
    str_trim(gsub("<[^>]+>", "", x))
  }, USE.NAMES = FALSE) |> unname()
}

parse_muni_html <- function(html, muni_info) {
  prog_names <- extract_programs(html)
  cells <- extract_cells(html)

  # Programas numerados (excluir Total General)
  prog_labeled <- prog_names[grep("^[0-9]+\\s|Total General", prog_names)]
  prog_labeled <- prog_labeled[!grepl("^Total General", prog_labeled)]

  # Primera celda numérica real (después de "Total General:")
  first_data <- NA
  for (i in seq_along(cells)) {
    v <- parse_bob(cells[i])
    if (!is.na(v) && v > 1e3) { first_data <- i; break }
  }
  if (is.na(first_data)) return(NULL)
  data_vals <- cells[first_data:length(cells)]
  # Saltar primeros 60 (Total General por año, 6 celdas × 10 años)
  if (length(data_vals) < 120) return(NULL)
  data_vals <- data_vals[61:length(data_vals)]

  n_programs <- floor(length(data_vals) / 60)
  if (n_programs < 3) return(NULL)

  out <- list()
  for (p_idx in seq_len(min(length(prog_labeled), n_programs))) {
    start <- (p_idx - 1) * 60 + 1
    vals <- data_vals[start:(start + 59)]
    if (length(vals) < 60) next

    for (i in seq_along(YEARS)) {
      s <- (i - 1) * 6 + 1
      total_val <- parse_bob(vals[s + 4])
      # Skip años con 0 o NA en total (optimizar tamaño)
      if (is.na(total_val) || total_val == 0) next
      out[[length(out) + 1]] <- data.table(
        dept_code     = muni_info$dept_code,
        dept          = muni_info$dept_name,
        muni_rel      = muni_info$rel_id,
        muni_code     = muni_info$muni_code,
        muni_name     = muni_info$muni_name,
        program       = prog_labeled[p_idx],
        year          = YEARS[i],
        corriente_bob = parse_bob(vals[s]),
        inversion_bob = parse_bob(vals[s + 2]),
        total_bob     = total_val,
        total_pct     = parse_bob(vals[s + 5])
      )
    }
  }
  rbindlist(out, fill = TRUE)
}

# ─── Main pipeline ────────────────────────────────────────────────────────────
main <- function(limit = NULL) {
  cat("┌─────────────────────────────────────────────────────────────┐\n")
  cat("│ Scraper Jubileo MUNICIPAL 2012-2021 (339 municipios)        │\n")
  cat("│ ~5-8 minutos con 0.8 seg de delay por request                │\n")
  cat("└─────────────────────────────────────────────────────────────┘\n\n")

  catalog_file <- file.path(proc_dir, "jubileo_municipios_catalogo.rds")
  if (file.exists(catalog_file)) {
    catalog <- readRDS(catalog_file)
    cat("Catálogo cacheado:", nrow(catalog), "municipios\n\n")
  } else {
    catalog <- fetch_municipios_catalog()
    saveRDS(catalog, catalog_file)
  }

  if (!is.null(limit)) {
    catalog <- catalog[1:min(limit, nrow(catalog))]
    cat("⚠ Modo prueba: solo", nrow(catalog), "municipios\n")
  }

  all_data <- list()
  t0 <- Sys.time()

  for (i in seq_len(nrow(catalog))) {
    mun <- catalog[i]
    html <- scrape_muni(mun$rel_id, mun$dept_code)
    if (is.null(html)) {
      cat(sprintf("  [%3d/%d] %s (rel=%d) — FALLO\n",
                  i, nrow(catalog), mun$muni_name, mun$rel_id))
      next
    }
    dt <- parse_muni_html(html, mun)
    if (!is.null(dt) && nrow(dt) > 0) {
      all_data[[as.character(mun$rel_id)]] <- dt
      if (i %% 25 == 0 || i == nrow(catalog)) {
        elapsed <- difftime(Sys.time(), t0, units = "mins")
        cat(sprintf("  [%3d/%d] %s — %d filas · total %d · elapsed %.1f min\n",
                    i, nrow(catalog), mun$muni_name, nrow(dt),
                    sum(sapply(all_data, nrow)), as.numeric(elapsed)))
      }
    }
  }

  cat("\n=== Consolidando ===\n")
  dt_all <- rbindlist(all_data, fill = TRUE)
  dt_all[, program_code := str_extract(program, "^\\d+")]

  cat("Total filas:", nrow(dt_all), "\n")
  cat("Municipios:", length(unique(dt_all$muni_rel)), "\n")
  cat("Programas:", length(unique(dt_all$program_code)), "\n\n")

  saveRDS(dt_all, file.path(proc_dir, "jubileo_municipal_full_2012_2021.rds"))
  fwrite(dt_all, file.path(proc_dir, "jubileo_municipal_full_2012_2021.csv"))
  cat("✓ Guardado: jubileo_municipal_full_2012_2021.{rds,csv}\n")

  # Preview Programa 10 Agropecuario
  cat("\n=== Top 10 municipios en P10 Agropecuario 2020 ===\n")
  top10 <- dt_all[program_code == "10" & year == 2020][order(-total_bob)][1:10,
    .(dept, muni_name, total_bob_mm = round(total_bob/1e6, 2))]
  print(top10)

  invisible(dt_all)
}

if (!interactive()) main()
