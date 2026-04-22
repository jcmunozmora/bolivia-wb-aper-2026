# Parsea el Cuadro N° 26a/26b del Informe Fiscal 2024
# Serie 1990-2024 de Inversión Pública Ejecutada por Sector Económico
# Millones de USD — Fuente: VIPFE/MPD
#
# ESTE ES EL DATO CENTRAL DEL PROYECTO WB BOLIVIA PER
# Cubre la brecha del APER (que terminaba en 2008)

library(pdftools)
library(data.table)
library(tidyverse)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
pdf      <- file.path(root, "01_data/raw/mefp/Informe_Fiscal_2024.pdf")
proc_dir <- file.path(root, "01_data/processed")

# Page 109 has both Cuadros 26a (1990-2007) and 26b (2008-2024)
txt <- pdf_text(pdf)[109]
lines <- strsplit(txt, "\n")[[1]]
lines <- gsub("\\s+", " ", trimws(lines))
lines <- lines[nchar(lines) > 0]

parse_usd <- function(x) {
  x <- gsub("[()]", "-", x)
  x <- gsub("\\.", "", x)   # separador de miles (punto)
  x <- gsub(",", ".", x)    # separador decimal (coma)
  suppressWarnings(as.numeric(x))
}

# Find year header lines
yr_line_a <- grep("^1990 1991", lines)[1]       # Cuadro 26a header
yr_line_b <- grep("^2008 2009", lines)[1]       # Cuadro 26b header

years_a <- 1990:2007
years_b <- 2008:2024

sector_labels <- c("TOTAL", "PRODUCTIVOS", "Agropecuario", "Hidrocarburos",
                   "Energía", "Industria y Turismo", "Minero",
                   "INFRAESTRUCTURA", "Comunicaciones", "Recursos Hídricos",
                   "Transportes",
                   "SOCIALES", "Educación y Cultura",
                   "Salud, Seguridad Social y Deportes", "Saneamiento Básico",
                   "Urbanismo y Vivienda",
                   "MULTISECTORIALES")

extract_section <- function(lines, start_idx, years) {
  out <- list()
  for (sl in sector_labels) {
    pat <- paste0("^", sl, " ")
    row <- grep(pat, lines[start_idx:length(lines)], fixed = FALSE)
    if (length(row) == 0) next
    row <- start_idx + row[1] - 1
    line <- lines[row]
    # Remove sector name to get only values
    vals_str <- sub(pat, "", line)
    # Remove footnote indicators like "2_/" or "3_/"
    vals_str <- gsub("[0-9]_/", "", vals_str)
    tokens <- strsplit(trimws(vals_str), " ")[[1]]
    tokens <- tokens[nchar(tokens) > 0]
    vals <- parse_usd(tokens)
    vals <- vals[!is.na(vals)]
    if (length(vals) >= length(years)) {
      out[[sl]] <- vals[1:length(years)]
    }
  }
  df <- data.table(
    sector = rep(names(out), each = length(years)),
    year   = rep(years, times = length(out)),
    inv_pub_usd_mm = unlist(out)
  )
  df
}

df_a <- extract_section(lines, yr_line_a, years_a)
df_b <- extract_section(lines, yr_line_b, years_b)

inv_publica <- rbind(df_a, df_b)
cat("Registros extraídos:", nrow(inv_publica), "\n")
cat("Sectores:", length(unique(inv_publica$sector)), "\n")
cat("Años:", paste(range(inv_publica$year), collapse="-"), "\n\n")

# Agropecuario time series — THE key variable for the project
agro <- inv_publica[sector == "Agropecuario"][order(year)]
cat("=== INVERSIÓN PÚBLICA EJECUTADA SECTOR AGROPECUARIO, 1990-2024 (USD mm) ===\n")
print(agro)

# Pivot wide
inv_wide <- dcast(inv_publica, year ~ sector, value.var = "inv_pub_usd_mm")
setcolorder(inv_wide, c("year", "TOTAL", "PRODUCTIVOS", "Agropecuario",
                         "Hidrocarburos", "Energía", "Industria y Turismo",
                         "Minero", "INFRAESTRUCTURA", "Transportes",
                         "Recursos Hídricos", "Comunicaciones",
                         "SOCIALES", "Educación y Cultura",
                         "Salud, Seguridad Social y Deportes",
                         "Saneamiento Básico", "Urbanismo y Vivienda",
                         "MULTISECTORIALES"))

# Calculate agricultural share of total investment
inv_wide[, agro_share_pct := Agropecuario / TOTAL * 100]

cat("\n=== Serie agropecuaria y participación % en inversión pública total ===\n")
print(inv_wide[, .(year, TOTAL, Agropecuario, agro_share_pct)])

# Save
saveRDS(inv_publica, file.path(proc_dir, "inversion_publica_sectorial_long.rds"))
saveRDS(inv_wide,    file.path(proc_dir, "inversion_publica_sectorial_wide.rds"))
readr::write_csv(inv_publica, file.path(proc_dir, "inversion_publica_sectorial.csv"))
readr::write_csv(inv_wide, file.path(proc_dir, "inversion_publica_sectorial_wide.csv"))

cat("\n=== Archivos guardados ===\n")
cat("01_data/processed/inversion_publica_sectorial.csv (long)\n")
cat("01_data/processed/inversion_publica_sectorial_wide.csv (wide)\n")
cat("\n🎯 DATO CLAVE: Esto cubre la brecha SIIF 2009-2024 a nivel sectorial.\n")
cat("Para desagregación por institución (MDRyT, INIAF, etc.) aún se requiere\n")
cat("solicitud formal al MEFP o acceso al SIGEP.\n")
