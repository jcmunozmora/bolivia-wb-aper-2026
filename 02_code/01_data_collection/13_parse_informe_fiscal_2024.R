# Parsea el Informe Fiscal 2024 del MEFP
# Extrae series anuales 2000-2024 de entidades públicas (EMAPA, YPFB, etc.)
# y de gasto agropecuario

library(pdftools)
library(data.table)
library(tidyverse)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
pdf      <- file.path(root, "01_data/raw/mefp/Informe_Fiscal_2024.pdf")
proc_dir <- file.path(root, "01_data/processed")

txt <- pdf_text(pdf)
cat("Total pages:", length(txt), "\n")

parse_bob <- function(x) {
  x <- gsub("[()]", "-", x)
  x <- gsub("\\.", "", x)
  x <- gsub(",", ".", x)
  suppressWarnings(as.numeric(x))
}

# Extract an annual time series from any Cuadro page
# Looks for a "YEARS" header line like "2000 2001 ... 2024(p)"
# Then each following line with entity name + numbers
extract_annual_series <- function(page_txt, page_num) {
  lines <- strsplit(page_txt, "\n")[[1]]
  lines <- lines[nchar(trimws(lines)) > 0]

  # Find year header row
  year_row <- NA
  for (i in seq_along(lines)) {
    # Pattern: contains multiple years 2000-2024
    if (grepl("2000\\s+2001.*202[0-4]", lines[i]) ||
        grepl("2010.*202[0-4]", lines[i])) {
      year_row <- i
      break
    }
  }
  if (is.na(year_row)) return(NULL)

  # Parse year labels
  header_clean <- gsub("\\(p\\)|\\(e\\)", "", lines[year_row])
  header_tokens <- strsplit(trimws(gsub("\\s+", " ", header_clean)), " ")[[1]]
  years <- suppressWarnings(as.integer(header_tokens))
  year_vals <- years[!is.na(years)]
  if (length(year_vals) < 5) return(NULL)

  # Title: usually 1-2 lines above year row
  title_start <- max(1, year_row - 4)
  title <- paste(trimws(lines[title_start:(year_row - 1)]), collapse = " | ")
  title <- gsub("\\s+", " ", title)

  # Parse data rows (after year header)
  out <- list()
  for (i in (year_row + 1):length(lines)) {
    line <- gsub("\\s+", " ", trimws(lines[i]))
    # Stop at footnotes
    if (grepl("^(Fuente:|Nota:|Elaboraci|\\(p\\)|1_/|2_/|Cuadro|Gráfica)", line, ignore.case = TRUE)) break
    if (nchar(line) < 5) next

    # Extract numbers
    tokens <- strsplit(line, " ")[[1]]
    tokens <- tokens[nchar(tokens) > 0]
    is_num <- grepl("^[-()\\.,0-9]+$", tokens)
    # Entity name = tokens before first number
    first_num <- which(is_num)[1]
    if (is.na(first_num) || first_num < 2) next

    entity <- paste(tokens[1:(first_num - 1)], collapse = " ")
    values <- parse_bob(tokens[first_num:length(tokens)])
    values <- values[!is.na(values)]

    # Expect matching number of year columns (allow short by a bit)
    if (length(values) >= length(year_vals) - 1) {
      # Take the last N values matching year count
      vals_use <- tail(values, length(year_vals))
      out[[length(out) + 1]] <- list(
        page = page_num, title = title, entity = entity,
        years = year_vals, values = vals_use
      )
    }
  }
  out
}

# Process all pages
all_series <- list()
for (p in seq_along(txt)) {
  res <- extract_annual_series(txt[p], p)
  if (!is.null(res) && length(res) > 0) {
    all_series <- c(all_series, res)
  }
}
cat("Series extracted:", length(all_series), "\n")

# Convert to long data.table
long_dt <- rbindlist(lapply(all_series, function(x) {
  data.table(
    page   = x$page,
    title  = substr(x$title, 1, 150),
    entity = x$entity,
    year   = x$years,
    value  = x$values
  )
}), use.names = TRUE, fill = TRUE)

cat("Total data points:", nrow(long_dt), "\n")
cat("Unique entities:", length(unique(long_dt$entity)), "\n")
cat("Unique tables:", length(unique(long_dt$page)), "\n")

# Filter to agricultural-relevant entities
agro_entities <- c("EMAPA", "MDRyT", "INIAF", "SENASAG", "FDI", "INRA",
                   "Desarrollo Rural", "Ministerio de Desarrollo Rural",
                   "Empresa de Apoyo")
agro_rx <- paste(agro_entities, collapse = "|")
agro_dt <- long_dt[grepl(agro_rx, entity, ignore.case = TRUE)]

cat("\n=== Entidades agropecuarias encontradas ===\n")
print(agro_dt[, .(n_obs = .N, first_year = min(year), last_year = max(year),
                   val_2020 = value[year == 2020][1]),
              by = entity])

# Guardar todo
saveRDS(long_dt, file.path(proc_dir, "informe_fiscal_2024_all_series.rds"))
saveRDS(agro_dt, file.path(proc_dir, "informe_fiscal_2024_agro_series.rds"))
readr::write_csv(agro_dt, file.path(proc_dir, "informe_fiscal_2024_agro_series.csv"))

# EMAPA specifically — wide format
emapa <- long_dt[entity == "EMAPA"]
if (nrow(emapa) > 0) {
  cat("\n=== EMAPA todas las series encontradas ===\n")
  emapa_wide <- dcast(emapa, page + title ~ year, value.var = "value")
  print(emapa_wide)
  readr::write_csv(emapa_wide, file.path(proc_dir, "emapa_series_wide.csv"))
}

cat("\nArchivos guardados en 01_data/processed/\n")
