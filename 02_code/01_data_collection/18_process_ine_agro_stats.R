# Procesa Estadísticas Agrícolas INE 1984-2024
# =============================================================================
# Tres archivos Excel con hojas por departamento:
#   - agro_produccion_depto.xlsx: Producción en toneladas métricas
#   - agro_rendimiento_depto.xlsx: Rendimiento kg/ha
#   - agro_superficie_depto.xlsx: Superficie cultivada en hectáreas
#
# Cada hoja: año agrícola (ej. 1983-1984) × cultivo × depto
#
# Output: 01_data/processed/ine_agro_stats_dept_long.rds
#   Panel largo: depto × cultivo × año × {producción, rendimiento, superficie}
# =============================================================================

library(readxl)
library(data.table)
library(stringr)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
raw_dir  <- file.path(root, "01_data/raw/ine_bolivia/agro_stats")
proc_dir <- file.path(root, "01_data/processed")

# Departamentos — nombres de hojas en el Excel
DEPT_SHEETS <- c("Bolivia", "Chuquisaca", "La Paz", "Cochabamba", "Oruro",
                 "Potosí", "Tarija", "Santa Cruz", "Beni", "Pando")

# Archivos por indicador
FILES <- list(
  produccion   = "agro_produccion_depto.xlsx",
  rendimiento  = "agro_rendimiento_depto.xlsx",
  superficie   = "agro_superficie_depto.xlsx"
)

parse_sheet <- function(file, sheet, indicator) {
  d <- suppressMessages(
    read_excel(file.path(raw_dir, file), sheet = sheet, col_names = FALSE)
  )

  # Fila 3 tiene el header con años (ej. "1983-1984", "1984-1985", ...)
  header_row <- as.character(unlist(d[3, ]))
  # Identificar columnas de año (patrón "YYYY-YYYY" o "YYYY")
  year_col_idx <- grep("^(19|20)\\d{2}[-_]?(19|20)?\\d{0,2}$", header_row)
  if (length(year_col_idx) == 0) {
    year_col_idx <- grep("^(19|20)\\d{2}", header_row)
  }

  # Años — tomar el SEGUNDO año del par "1983-1984" → 1984
  years_str <- header_row[year_col_idx]
  years_extracted <- str_extract(years_str, "(19|20)\\d{2}$")
  years_numeric <- suppressWarnings(as.integer(years_extracted))

  # Desde fila 4 en adelante son datos
  data_rows <- d[4:nrow(d), ]

  # Primera columna es nombre del cultivo
  cultivos <- as.character(unlist(data_rows[, 1]))

  # Filtrar: eliminar filas vacías o de categorías agregadas (MAYÚSCULAS)
  is_data <- !is.na(cultivos) & cultivos != "" &
             !(cultivos %in% c("CEREALES", "ESTIMULANTES", "FRUTALES",
                                "HORTALIZAS", "INDUSTRIALES", "OLEAGINOSAS",
                                "TUBERCULOS", "TUBÉRCULOS", "FORRAJES"))

  # Build long
  out <- list()
  for (r in which(is_data)) {
    cultivo <- str_trim(cultivos[r])
    vals <- suppressWarnings(as.numeric(unlist(data_rows[r, year_col_idx])))
    for (j in seq_along(vals)) {
      if (!is.na(years_numeric[j]) && !is.na(vals[j])) {
        out[[length(out) + 1]] <- data.table(
          dept      = sheet,
          cultivo   = cultivo,
          year      = years_numeric[j],
          indicator = indicator,
          value     = vals[j]
        )
      }
    }
  }
  rbindlist(out)
}

cat("=== Procesando Estadísticas Agrícolas INE 1984-2024 ===\n\n")

all_data <- list()
for (indicator in names(FILES)) {
  file <- FILES[[indicator]]
  cat(sprintf("Archivo: %s (%s)\n", file, indicator))
  for (sh in DEPT_SHEETS) {
    dt <- tryCatch(parse_sheet(file, sh, indicator),
                   error = function(e) NULL)
    if (!is.null(dt) && nrow(dt) > 0) {
      cat(sprintf("  %-15s %5d filas\n", sh, nrow(dt)))
      all_data[[paste(indicator, sh, sep = "_")]] <- dt
    }
  }
}

long <- rbindlist(all_data, fill = TRUE)
cat("\nTotal filas long:", nrow(long), "\n")
cat("Indicadores:", paste(unique(long$indicator), collapse = ", "), "\n")
cat("Depts:", paste(unique(long$dept), collapse = ", "), "\n")
cat("Años:", paste(range(long$year, na.rm = TRUE), collapse = "-"), "\n")
cat("Cultivos únicos:", length(unique(long$cultivo)), "\n\n")

# Pivot wide por indicador
wide <- dcast(long, dept + cultivo + year ~ indicator, value.var = "value")

cat("=== Producción total cereales 2020 por depto ===\n")
cereales <- c("Arroz con cáscara", "Maíz en grano (1)", "Maíz en grano",
              "Sorgo en grano (1)", "Sorgo en grano", "Trigo", "Cebada en grano",
              "Quinua")
cereales_2020 <- long[cultivo %in% cereales & indicator == "produccion" & year == 2020,
                      .(prod_ton = sum(value, na.rm = TRUE)),
                      by = dept][order(-prod_ton)]
print(cereales_2020)

# Guardar
saveRDS(long, file.path(proc_dir, "ine_agro_stats_long.rds"))
saveRDS(wide, file.path(proc_dir, "ine_agro_stats_wide.rds"))
fwrite(long, file.path(proc_dir, "ine_agro_stats_long.csv"))
cat("\n✓ Guardado: ine_agro_stats_{long,wide}.{rds,csv}\n")
