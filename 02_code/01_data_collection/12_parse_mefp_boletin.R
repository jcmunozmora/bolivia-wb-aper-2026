# Parsea el Cuadro N° 34 del Boletín MEFP ETA 2022
# Deuda pública por destino del crédito, 2005-2022, millones de BOB

library(pdftools)
library(data.table)
library(tidyverse)

root    <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
pdf     <- file.path(root, "01_data/raw/mefp/boletin_eef_eta_2022.pdf")
proc_dir <- file.path(root, "01_data/processed")

txt <- pdf_text(pdf)[89]
lines <- strsplit(txt, "\n")[[1]]
lines_clean <- gsub("\\s+", " ", trimws(lines))
lines_clean <- lines_clean[nchar(lines_clean) > 0]

parse_bob <- function(x) {
  x <- gsub("[()]", "-", x)
  x <- gsub("\\.", "", x)
  x <- gsub(",", ".", x)
  suppressWarnings(as.numeric(x))
}

DEPTS  <- c("Beni", "Chuquisaca", "Cochabamba", "La Paz", "Oruro", "Pando",
            "Potosí", "Santa Cruz", "Tarija")
YEARS  <- 2005:2022

# Destinos en orden de aparición en el cuadro
# AGROPECUARIO, CAMINOS, ELECTRIFICACIÓN, FORTALECIMIENTO INSTITUCIONAL,
# RIEGO, SEGURIDAD SOCIAL, TRANSPORTE, OTROS
DESTINOS <- c("AGROPECUARIO", "CAMINOS", "ELECTRIFICACIÓN",
              "FORTALECIMIENTO", "RIEGO", "SEGURIDAD SOCIAL",
              "TRANSPORTE", "OTROS")

# Mark each line: is it a dept row? label row? subtotal row?
row_type <- rep("other", length(lines_clean))
row_dept <- rep(NA, length(lines_clean))
row_subtotal <- grepl("^SUB TOTAL", lines_clean)
row_total    <- grepl("^TOTAL", lines_clean)
for (k in DEPTS) {
  hits <- grepl(paste0("^", k, " "), lines_clean)
  row_type[hits] <- "dept"
  row_dept[hits] <- k
}

# Find destino labels (single word on its own line or label block)
# Labels appear as: "AGROPECUARIO" alone, "CAMINOS" alone, etc
destino_row <- rep(NA, length(lines_clean))
for (d in DESTINOS) {
  pat <- paste0("^", d, "\\b")
  idx <- which(grepl(pat, lines_clean))
  for (i in idx) destino_row[i] <- d
}

# Assign destino to each row based on SUB TOTAL boundaries
# Pattern: each section ends with SUB TOTAL; destino labels are somewhere in the section
# Strategy: walk through sections separated by SUB TOTAL, assign destino from the label in that section
subtotal_idx <- which(row_subtotal | row_total)
section_starts <- c(1, subtotal_idx[-length(subtotal_idx)] + 1)
section_ends   <- subtotal_idx

current_destino <- NA
rows_out <- list()
for (s in seq_along(section_starts)) {
  start <- section_starts[s]
  end   <- section_ends[s]
  # Find destino label in this section
  destinos_in_section <- destino_row[start:end]
  destinos_in_section <- destinos_in_section[!is.na(destinos_in_section)]
  if (length(destinos_in_section) > 0) {
    current_destino <- destinos_in_section[1]
  }
  # Extract dept rows in this section
  for (i in start:end) {
    if (row_type[i] == "dept") {
      dept <- row_dept[i]
      line <- lines_clean[i]
      rest <- sub(paste0("^", dept, " "), "", line)
      rest <- gsub("[0-9]_/", "", rest)
      tokens <- strsplit(trimws(rest), " ")[[1]]
      tokens <- tokens[nchar(tokens) > 0]
      vals <- parse_bob(tokens)
      if (length(vals) >= 18) {
        rows_out[[length(rows_out) + 1]] <- list(
          destino = current_destino,
          dept    = dept,
          vals    = vals[1:18]
        )
      }
    }
  }
}

cat("Total filas extraídas:", length(rows_out), "\n")

wide <- data.table(
  destino = sapply(rows_out, function(x) x$destino),
  dept    = sapply(rows_out, function(x) x$dept),
  do.call(rbind, lapply(rows_out, function(x) x$vals))
)
setnames(wide, paste0("V", 1:18), as.character(YEARS))
print(wide[, .N, by = destino])

long <- melt(wide, id.vars = c("destino", "dept"), variable.name = "year",
             value.name = "deuda_mm_bob")
long[, year := as.integer(as.character(year))]

# Total stock de deuda rural (agropecuario + riego + caminos vecinales) por año
rural_total <- long[destino %in% c("AGROPECUARIO", "RIEGO", "CAMINOS"),
                    .(stock_rural_mm_bob = sum(deuda_mm_bob, na.rm=TRUE)),
                    by = year][order(year)]
cat("\n=== Stock deuda rural (AGRO+RIEGO+CAMINOS) por año, millones BOB ===\n")
print(rural_total)

# Por destino y año
by_destino <- long[destino %in% c("AGROPECUARIO", "RIEGO", "CAMINOS"),
                   .(stock_mm_bob = sum(deuda_mm_bob, na.rm=TRUE)),
                   by = .(year, destino)]
cat("\n=== Por destino y año (wide) ===\n")
print(dcast(by_destino, year ~ destino, value.var = "stock_mm_bob"))

# Por departamento — inversión rural cumulativa 2022
dept_2022 <- long[destino %in% c("AGROPECUARIO", "RIEGO", "CAMINOS") & year == 2022,
                  .(stock_rural_2022 = sum(deuda_mm_bob, na.rm=TRUE)),
                  by = dept][order(-stock_rural_2022)]
cat("\n=== Stock deuda rural por departamento, 2022 ===\n")
print(dept_2022)

# Save
saveRDS(wide, file.path(proc_dir, "mefp_deuda_destino_wide.rds"))
saveRDS(long, file.path(proc_dir, "mefp_deuda_destino_long.rds"))
readr::write_csv(long, file.path(proc_dir, "mefp_deuda_destino_long.csv"))
readr::write_csv(rural_total, file.path(proc_dir, "mefp_stock_rural_annual.csv"))
cat("\nGuardado en 01_data/processed/\n")
