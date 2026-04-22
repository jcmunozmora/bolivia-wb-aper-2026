# Scraping Fundación Jubileo — Portal pre.jubileobolivia.org.bo
# =============================================================================
# HALLAZGO (2026-04-21): El portal IGNORA todos los filtros POST. El filtrado
# se hace client-side en JavaScript. Este script extrae el AGREGADO NACIONAL
# MUNICIPAL BOLIVIA 2012-2021 por programa (único dato accesible sin browser).
#
# Estructura HTML del portal: 2 tablas paralelas renderizadas lado a lado
#  - Tabla A: nombres de programas (una columna, ~64 filas)
#  - Tabla B: datos numéricos (60 TDs por fila = 6 cells × 10 años)
#  - Orden: Corriente BOB, Corriente %, Inversión BOB, Inversión %,
#           Total BOB, Total %
#
# Output: 01_data/processed/jubileo_municipal_nacional_2012_2021.{rds,csv}
#
# Datos desagregados por depto/municipio:
#   → Esperar respuesta a 00_admin/carta_solicitud_Jubileo.md
#   → O implementar browser automation (Selenium/Playwright)
# =============================================================================

library(httr2)
library(data.table)
library(stringr)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
raw_dir  <- file.path(root, "01_data/raw/jubileo")
proc_dir <- file.path(root, "01_data/processed")

# ─── 1. Descarga ─────────────────────────────────────────────────────────────
fetch_portal <- function() {
  year_codes <- c("25","19","20","21","22","23","24","26","27","30")
  body <- paste(paste0("get_ges[]=", year_codes), collapse = "&")

  req <- request("https://pre.jubileobolivia.org.bo/") |>
    req_user_agent("Mozilla/5.0 WB-APER-Research/1.0 (jcmunozmora@gmail.com)") |>
    req_timeout(60) |>
    req_options(ssl_verifypeer = 0) |>
    req_method("POST") |>
    req_body_raw(body, type = "application/x-www-form-urlencoded")

  resp <- req_perform(req)
  html <- resp_body_string(resp)
  writeLines(html, file.path(raw_dir, "portal_nacional_2012_2021.html"),
             useBytes = TRUE)
  html
}

# ─── 2. Parser: nombres de programas ──────────────────────────────────────────
extract_program_names <- function(html) {
  # Nombres están en filas simples: <tr><td>10 PROMOCIÓN Y FOMENTO...</td></tr>
  # Patron: <td>DIGITO NOMBRE</td> o "ADMINISTRACIÓN CENTRAL (Programas..." etc.
  pat <- "<td>\\s*([0-9]+\\s+[A-ZÁÉÍÓÚÑ][^<]*|ADMINISTRACIÓN CENTRAL[^<]*|Otros Programas[^<]*|Total General[^<]*)\\s*</td>"
  m <- regmatches(html, gregexpr(pat, html, perl = TRUE))[[1]]

  names_clean <- sapply(m, function(x) {
    inner <- str_replace(x, "<td>\\s*", "")
    inner <- str_replace(inner, "\\s*</td>", "")
    str_trim(inner)
  }, USE.NAMES = FALSE)
  unname(names_clean)
}

# ─── 3. Parser: celdas numéricas (solo TDs del bloque de datos) ──────────────
parse_bob <- function(x) {
  x <- str_trim(x)
  x <- str_replace_all(x, "\\.", "")            # separador miles
  x <- str_replace_all(x, ",", ".")              # decimal
  x <- str_replace_all(x, "%", "")
  x <- str_replace_all(x, "\\s+", "")
  if (x == "") return(NA_real_)
  suppressWarnings(as.numeric(x))
}

extract_data_cells <- function(html) {
  # Pattern más específico: td align="right" seguido de contenido y </td>
  pat <- '<td[^>]*align="right"[^>]*>\\s*([^<]*?)\\s*</td>'
  m <- regmatches(html, gregexpr(pat, html, perl = TRUE))[[1]]

  values <- sapply(m, function(x) {
    inner <- str_replace(x, '<td[^>]*>\\s*', "")
    inner <- str_replace(inner, "\\s*</td>", "")
    str_trim(inner)
  }, USE.NAMES = FALSE)
  unname(values)
}

# ─── 4. Pipeline principal ────────────────────────────────────────────────────
main <- function() {
  html_file <- file.path(raw_dir, "portal_nacional_2012_2021.html")
  if (!file.exists(html_file) || file.info(html_file)$size < 10000) {
    cat("Descargando HTML del portal Jubileo...\n")
    html <- fetch_portal()
  } else {
    cat("Usando HTML cacheado...\n")
    html <- paste(readLines(html_file, warn = FALSE), collapse = "\n")
  }

  cat("\nExtrayendo nombres de programas...\n")
  prog_names <- extract_program_names(html)
  cat("  Encontrados:", length(prog_names), "\n")
  cat("  Primeros 5:", paste(head(prog_names, 5), collapse = " | "), "\n")

  cat("\nExtrayendo celdas de datos...\n")
  cells <- extract_data_cells(html)
  cat("  Celdas extraídas:", length(cells), "\n")

  # Cells structure: primera fila "Total General" con 60 celdas + 1 header
  # Luego cada programa tiene 60 celdas
  # Total esperado: N_programs × 60 + algunos extras

  # Descartar el primer match (suele ser el label "Total General:")
  # y tomar bloques de 60
  first_data_idx <- NA
  for (i in seq_along(cells)) {
    v <- parse_bob(cells[i])
    if (!is.na(v) && v > 1e6) { first_data_idx <- i; break }
  }
  cat("  Primera celda numérica > 1M en posición:", first_data_idx, "\n")

  if (is.na(first_data_idx)) {
    stop("No se encontraron celdas numéricas válidas")
  }

  # Los primeros 60 valores después del header son la fila "Total General"
  # Luego vienen los programas (en el orden de prog_names filtrado)
  data_vals <- cells[first_data_idx:length(cells)]
  cat("  Total celdas de datos:", length(data_vals), "\n")

  # Construir tabla de programas (saltar "Total General" del inicio)
  # Asumir 60 celdas por programa
  n_programs <- floor(length(data_vals) / 60)
  cat("  Programas esperados (n_cells/60):", n_programs, "\n\n")

  # Los nombres de programas están a la izquierda — filtrar solo los numerados
  # (los que tienen un número al inicio + texto)
  prog_labeled <- prog_names[grep("^[0-9]+\\s|Total General", prog_names)]
  cat("  Nombres útiles:", length(prog_labeled), "\n")

  # Reshape a long
  years <- 2012:2021
  out <- list()
  for (p_idx in seq_len(min(length(prog_labeled), n_programs))) {
    prog_name <- prog_labeled[p_idx]
    vals <- data_vals[((p_idx - 1) * 60 + 1):(p_idx * 60)]

    for (i in seq_along(years)) {
      start <- (i - 1) * 6 + 1
      out[[length(out) + 1]] <- data.table(
        program       = prog_name,
        year          = years[i],
        corriente_bob = parse_bob(vals[start]),
        corriente_pct = parse_bob(vals[start + 1]),
        inversion_bob = parse_bob(vals[start + 2]),
        inversion_pct = parse_bob(vals[start + 3]),
        total_bob     = parse_bob(vals[start + 4]),
        total_pct     = parse_bob(vals[start + 5])
      )
    }
  }
  dt <- rbindlist(out)
  dt[, program_code := str_extract(program, "^\\d+")]

  cat("=== Panel resultante ===\n")
  cat("  Filas:", nrow(dt), "\n")
  cat("  Programas:", length(unique(dt$program)), "\n")
  cat("  Años:", paste(range(dt$year), collapse = "-"), "\n\n")

  # Programa 10 (Agropecuario)
  cat("=== Programa 10 — Promoción y Fomento Producción Agropecuaria ===\n")
  p10 <- dt[program_code == "10"]
  if (nrow(p10) > 0) {
    print(p10[order(year), .(year, total_bob, total_pct,
                             corriente_bob, inversion_bob)])
    cat("\n  Total 2012-2021 (BOB):",
        formatC(sum(p10$total_bob, na.rm = TRUE), format = "d", big.mark = ","),
        "\n")
  }

  # Programas agro/rurales totales
  cat("\n=== Programas agro/rurales seleccionados — totales por año ===\n")
  agro_codes <- c("10", "12", "13", "14", "15", "17", "18", "19", "32", "35")
  agro_summary <- dt[program_code %in% agro_codes,
                     .(total_bob = sum(total_bob, na.rm = TRUE)),
                     by = .(year, program)]
  print(dcast(agro_summary, program ~ year, value.var = "total_bob"))

  # Guardar
  saveRDS(dt, file.path(proc_dir, "jubileo_municipal_nacional_2012_2021.rds"))
  fwrite(dt, file.path(proc_dir, "jubileo_municipal_nacional_2012_2021.csv"))
  cat("\n✓ Guardado: jubileo_municipal_nacional_2012_2021.{rds,csv}\n")
  invisible(dt)
}

if (!interactive()) main()
