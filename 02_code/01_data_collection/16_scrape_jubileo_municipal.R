# Plan B: scrape la base municipal de Jubileo (pre.jubileobolivia.org.bo)
# extrayendo los datos embebidos en bloques Highcharts del HTML resultante.
#
# USO PRIMARIO: contactar a Jubileo primero (ver 00_admin/carta_solicitud_Jubileo.md)
# Este script se activa si no hay respuesta en 10 días.
#
# Output: 01_data/raw/jubileo/municipal_panel_2012_2021.rds
#   9 departamentos × ~300 municipios × 10 años × 60+ programas

library(httr2)
library(data.table)
library(stringr)

root    <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
out_dir <- file.path(root, "01_data/raw/jubileo/scraped")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

BASE_URL <- "https://pre.jubileobolivia.org.bo/"

# ─── Mapeo año ↔ código Jubileo ──────────────────────────────────────────────
YEAR_CODES <- c("2012" = "25", "2013" = "19", "2014" = "20", "2015" = "21",
                "2016" = "22", "2017" = "23", "2018" = "24", "2019" = "26",
                "2020" = "27", "2021" = "30")

# ─── Departamentos ────────────────────────────────────────────────────────────
DEPARTMENTS <- c("Chuquisaca" = 1, "La Paz" = 2, "Cochabamba" = 3,
                 "Oruro" = 4, "Potosí" = 5, "Tarija" = 6,
                 "Santa Cruz" = 7, "Beni" = 8, "Pando" = 9)

# ─── Programas agropecuarios y rurales relevantes ────────────────────────────
AGRO_PROGRAMS <- c(
  "10" = "Promocion y Fomento Produccion Agropecuaria",
  "12" = "Construccion y Mantenimiento de Microriegos",
  "13" = "Desarrollo y Preservacion del Medio Ambiente",
  "14" = "Limpieza Urbana y Rural",
  "15" = "Electrificacion Urbana y Rural",
  "17" = "Infraestructura Urbano y Rural",
  "18" = "Construccion y Mantenimiento de Caminos Vecinales",
  "19" = "Servicio de Catastro Urbano y Rural",
  "32" = "Recursos Hidricos",
  "35" = "Fomento al Desarrollo Economico Local"
)

# ─── Helper: extraer series Highcharts del HTML resultante ───────────────────
extract_highcharts_series <- function(html_text) {
  # Match patterns like:
  # name: 'GASTO CORRIENTE ...', y: 1234567,
  pattern_name_value <- "name:\\s*'([^']+)'[^,}]*,\\s*y:\\s*([-0-9.eE]+)"
  m <- regmatches(html_text, gregexpr(pattern_name_value, html_text, perl = TRUE))[[1]]
  if (length(m) == 0) return(data.table())

  results <- lapply(m, function(x) {
    parts <- regmatches(x, regexec(pattern_name_value, x, perl = TRUE))[[1]]
    if (length(parts) >= 3) {
      data.table(category = parts[2], value = as.numeric(parts[3]))
    } else NULL
  })
  rbindlist(results[!sapply(results, is.null)])
}

# ─── Helper: extraer data: [array] blocks ───────────────────────────────────
extract_annual_arrays <- function(html_text) {
  # Match: data: [15108857278, 18201155584, ...]
  pattern <- "data:\\s*\\[([-0-9.,eE\\s]+)\\]"
  m <- regmatches(html_text, gregexpr(pattern, html_text, perl = TRUE))[[1]]
  if (length(m) == 0) return(list())

  lapply(m, function(x) {
    inner <- regmatches(x, regexec(pattern, x, perl = TRUE))[[1]][2]
    nums <- as.numeric(trimws(strsplit(inner, ",")[[1]]))
    nums[!is.na(nums)]
  })
}

# ─── Request wrapper con retry ────────────────────────────────────────────────
scrape_portal <- function(dept_code, program_code, year_codes, cache = TRUE) {
  fname <- sprintf("dept%d_pro%s.html", dept_code, program_code)
  fpath <- file.path(out_dir, fname)

  if (cache && file.exists(fpath) && file.info(fpath)$size > 1000) {
    return(readLines(fpath, warn = FALSE, encoding = "UTF-8"))
  }

  req <- request(BASE_URL) |>
    req_user_agent("Mozilla/5.0 WB-APER-Research/1.0 (jcmunozmora@gmail.com)") |>
    req_timeout(60) |>
    req_retry(max_tries = 3, backoff = ~ 5) |>
    req_options(ssl_verifypeer = 0) |>
    req_method("POST")

  # Build body — multiple get_ges[] and get_dep[] and get_pro[]
  body_parts <- c(
    sprintf("get_ges[]=%s", year_codes),
    sprintf("get_dep[]=%d", dept_code),
    sprintf("get_pro[]=%s", program_code)
  )
  body <- paste(body_parts, collapse = "&")

  req <- req_body_raw(req, body,
                      type = "application/x-www-form-urlencoded")
  resp <- tryCatch(req_perform(req), error = function(e) NULL)

  if (is.null(resp) || resp_status(resp) != 200) return(NULL)

  html <- resp_body_string(resp)
  writeLines(html, fpath, useBytes = TRUE)
  html
}

# ─── Pipeline principal ────────────────────────────────────────────────────────
main <- function(sample_only = FALSE) {
  cat("Scraping Jubileo municipal portal...\n")
  cat("Total departamentos:", length(DEPARTMENTS), "\n")
  cat("Total programas agro:", length(AGRO_PROGRAMS), "\n")
  cat("Total combinaciones:", length(DEPARTMENTS) * length(AGRO_PROGRAMS), "\n\n")

  year_codes_all <- unname(YEAR_CODES)
  all_data <- list()
  idx <- 0

  depts_to_scrape   <- if (sample_only) DEPARTMENTS[1:2] else DEPARTMENTS
  programs_to_scrape <- if (sample_only) AGRO_PROGRAMS[1:3] else AGRO_PROGRAMS

  for (dept_name in names(depts_to_scrape)) {
    for (prog_code in names(programs_to_scrape)) {
      idx <- idx + 1
      dept_code <- depts_to_scrape[[dept_name]]
      cat(sprintf("  [%d] Dept %s (%d) × Prog %s (%s)\n",
                  idx, dept_name, dept_code, prog_code,
                  substr(programs_to_scrape[[prog_code]], 1, 40)))

      html <- scrape_portal(dept_code, prog_code, year_codes_all, cache = TRUE)
      if (is.null(html)) {
        cat("     ⚠ fallo\n")
        next
      }
      text <- paste(html, collapse = "\n")

      # Parsear años categoricos
      years <- regmatches(text, regexpr("categories:\\s*\\[[^\\]]+\\]", text, perl = TRUE))
      # Parsear series principales
      arrays <- extract_annual_arrays(text)
      series <- extract_highcharts_series(text)

      all_data[[paste0(dept_name, "_", prog_code)]] <- list(
        dept       = dept_name,
        dept_code  = dept_code,
        program    = prog_code,
        program_name = programs_to_scrape[[prog_code]],
        annual_arrays = arrays,
        series      = series
      )

      Sys.sleep(1.5)  # ser gentiles con el servidor
    }
  }

  # Serializar resultado bruto
  saveRDS(all_data,
          file.path(root, "01_data/raw/jubileo/scraped_raw.rds"))
  cat("\n✓ Scraping completado:", length(all_data), "combinaciones\n")
  cat("  Output: 01_data/raw/jubileo/scraped_raw.rds\n")
}

# ─── Ejecución ────────────────────────────────────────────────────────────────
# Para prueba limitada:
#   main(sample_only = TRUE)
#
# Para scraping completo (9 depts × 10 programas = 90 requests, ~5 min):
#   main(sample_only = FALSE)

if (!interactive()) {
  main(sample_only = FALSE)
}
