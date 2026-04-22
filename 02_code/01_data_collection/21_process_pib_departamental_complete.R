# Parsea los 30 archivos PIB Departamental INE Referencia 2017
# =============================================================================
# Estructura: D<X>_<Y.Z>.xlsx
#   X = 1-10 (CHUQUISACA, LA PAZ, COCHABAMBA, ORURO, POTOSI, TARIJA, SANTA CRUZ,
#              BENI, PANDO, BOLIVIA en orden que hay que verificar)
#   Y.Z = tipo de tabla:
#     1.1 = Total PIB en valores corrientes por actividad
#     2.1 = PIB corrientes por actividad
#     2.2 = PIB constantes 2017 por actividad (medidas de volumen encadenadas)
#
# Output: 01_data/processed/pib_departamental_complete.rds
#   Panel dept × año × actividad económica × (corriente + constante)
# =============================================================================

library(readxl)
library(data.table)
library(stringr)

root      <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
input_dir <- file.path(root, "01_data/raw/ine_bolivia/pib_dept")
proc_dir  <- file.path(root, "01_data/processed")

# Parser una hoja
parse_pib_sheet <- function(file_path, label_tipo) {
  d_raw <- suppressMessages(
    read_excel(file_path, col_names = FALSE)
  )

  # Nombre del departamento (fila 2, columna 1)
  header <- as.character(d_raw[[1]][2])
  dept_name <- gsub(":.*", "", header) |> trimws()

  # Tipo: corriente vs constante — filas 1-3
  title_full <- paste(as.character(d_raw[[1]][1:3]), collapse = " ")

  # Header con años (fila 5)
  header_row <- 5
  header_vals <- unlist(d_raw[header_row, ])
  years_num <- suppressWarnings(as.numeric(header_vals))
  year_col_idx <- which(!is.na(years_num))
  years_vec <- as.integer(years_num[year_col_idx])
  if (length(years_vec) < 2) return(NULL)

  # Datos: desde fila 6 en adelante
  # Columna 1 = clasificación, Col 2 = sección, Col 3 = actividad económica
  out <- list()
  for (i in (header_row + 1):nrow(d_raw)) {
    row <- as.character(unlist(d_raw[i, ]))
    actividad <- str_trim(row[3])
    # Filtrar filas sin actividad o que son notas
    if (is.na(actividad) || actividad == "" || nchar(actividad) < 3) next
    if (grepl("^Fuente|^Nota|^\\(p\\)|^\\(1\\)|^preliminar", actividad,
              ignore.case = TRUE)) next

    vals <- suppressWarnings(as.numeric(row[year_col_idx]))
    if (all(is.na(vals))) next

    out[[length(out) + 1]] <- data.table(
      dept      = dept_name,
      tipo      = label_tipo,
      actividad = actividad,
      year      = years_vec,
      value     = vals
    )
  }

  if (length(out) == 0) return(NULL)
  rbindlist(out)
}

# ─── Procesar todos los archivos ──────────────────────────────────────────────
cat("=== Procesando 30 archivos PIB departamental ===\n")

# D1_2.1, D1_2.2 son los útiles (PIB por actividad)
# D1_1.1 es el total (menos útil para el análisis)
files <- list.files(input_dir, pattern = "^D[0-9]+_2\\.[12]\\.xlsx$",
                    full.names = TRUE)
cat("Archivos a procesar (tipo 2.1 corriente y 2.2 constante):", length(files), "\n\n")

all_data <- list()
for (f in files) {
  fname <- basename(f)
  tipo <- if (grepl("_2\\.1\\.xlsx", fname)) "corriente_bob_mm"
  else if (grepl("_2\\.2\\.xlsx", fname)) "constante_chain2017_mm"
  else next

  dt <- tryCatch(parse_pib_sheet(f, tipo), error = function(e) {
    cat("  ERROR", fname, ":", conditionMessage(e), "\n"); NULL
  })
  if (!is.null(dt) && nrow(dt) > 0) {
    all_data[[fname]] <- dt
    dept <- unique(dt$dept)[1]
    yrs <- paste(range(dt$year), collapse = "-")
    cat(sprintf("  %-15s %-12s %-15s %3d filas | años %s\n",
                fname, dept, tipo, nrow(dt), yrs))
  }
}

long <- rbindlist(all_data, fill = TRUE)
cat("\nTotal filas:", nrow(long), "\n")
cat("Departamentos:", paste(unique(long$dept), collapse = ", "), "\n")
cat("Actividades económicas únicas:", length(unique(long$actividad)), "\n\n")

cat("=== Actividades económicas encontradas ===\n")
print(unique(long$actividad)[1:20])

# ─── Pivotar a wide y filtrar a lo útil ───────────────────────────────────────
wide <- dcast(long, dept + year + actividad ~ tipo, value.var = "value")

cat("\n=== PIB Agropecuario por depto — VALORES CONSTANTES 2017 ===\n")
agro_constante <- wide[grepl("[Aa]gricultura|[Aa]gropecuari|[Gg]anader",
                              actividad)]
print(agro_constante[order(dept, year),
                     .(dept, year, actividad,
                       constante = round(constante_chain2017_mm, 0),
                       corriente = round(corriente_bob_mm, 0))])

# ─── Guardar ─────────────────────────────────────────────────────────────────
saveRDS(long, file.path(proc_dir, "pib_departamental_long.rds"))
saveRDS(wide, file.path(proc_dir, "pib_departamental_complete.rds"))
fwrite(wide, file.path(proc_dir, "pib_departamental_complete.csv"))

cat("\n✓ Guardado: pib_departamental_complete.{rds,csv}\n")
cat("  ", nrow(wide), "filas (dept × año × actividad)\n")
