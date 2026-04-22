# Procesa Encuesta Nacional Agropecuaria 2015 — microdatos SPSS
# =============================================================================
# Input: 01_data/raw/ine_bolivia/Encuesta_Agropecuaria_2015/BD Spss/
#   - Hogar: Hogar_parte1.sav, Hogar_parte2.sav, Hogar_parte3.sav
#   - Agricola: agricola verano e invierno.sav
#   - Pecuaria: 8 archivos (bovinos, ovinos, caprinos, porcinos, llamas,
#     alpacas, aves corral, aves granja) + 5 derivados
#
# Output: 01_data/processed/ena_2015_*.rds (una por módulo)
#         + ena_2015_dept_summary.rds — agregado departamental
# =============================================================================

library(haven)
library(data.table)
library(dplyr)

root    <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
ena_dir <- file.path(root, "01_data/raw/ine_bolivia/Encuesta_Agropecuaria_2015/BD Spss")
proc    <- file.path(root, "01_data/processed")

# ─── Helper: leer .sav con haven ──────────────────────────────────────────────
read_sav_safe <- function(path) {
  cat(sprintf("  Leyendo: %s (%.1f MB)\n",
              basename(path), file.info(path)$size / 1e6))
  d <- tryCatch(read_sav(path), error = function(e) {
    cat("    ERROR:", conditionMessage(e), "\n"); NULL
  })
  if (is.null(d)) return(NULL)
  setDT(d)
  cat(sprintf("    → %d filas × %d vars\n", nrow(d), ncol(d)))
  d
}

# ─── 1. Hogar ────────────────────────────────────────────────────────────────
cat("=== Hogar (info base de UPA y encuestados) ===\n")
hogar1 <- read_sav_safe(file.path(ena_dir, "1.-Hogar/Hogar_parte1.sav"))
hogar2 <- read_sav_safe(file.path(ena_dir, "1.-Hogar/Hogar_parte2.sav"))
hogar3 <- read_sav_safe(file.path(ena_dir, "1.-Hogar/Hogar_parte3.sav"))

# Inspeccionar vars clave
if (!is.null(hogar1)) {
  id_vars <- intersect(names(hogar1),
    c("FOLIO", "folio", "cod_upa", "UPA", "upa", "depto", "DEPTO",
      "cod_dep", "cod_mun", "provincia"))
  cat("  Vars identificadoras Hogar1:", paste(id_vars, collapse=", "), "\n")
}

# ─── 2. Agrícola ─────────────────────────────────────────────────────────────
cat("\n=== Agrícola (producción verano + invierno) ===\n")
agric <- read_sav_safe(file.path(ena_dir, "2.-Agricola/agricola verano e invierno.sav"))
if (!is.null(agric)) {
  cat("  Variables:", paste(head(names(agric), 30), collapse=", "), "...\n")
  # Buscar variables de departamento y cultivo
  dep_var <- grep("dep|departamento", names(agric), value = TRUE, ignore.case = TRUE)[1]
  cult_var <- grep("cultivo|producto", names(agric), value = TRUE, ignore.case = TRUE)[1]
  sup_var <- grep("superf|area", names(agric), value = TRUE, ignore.case = TRUE)[1]
  prod_var <- grep("produc|cosech|rend", names(agric), value = TRUE, ignore.case = TRUE)[1:3]
  cat("  depto:", dep_var, "| cultivo:", cult_var, "| superficie:", sup_var, "\n")
  cat("  produccion:", paste(prod_var, collapse = ", "), "\n")
}

# ─── 3. Pecuaria ─────────────────────────────────────────────────────────────
cat("\n=== Pecuaria (8 tipos de ganado) ===\n")
pec_files <- list.files(file.path(ena_dir, "3.-Pecuaria"),
                         pattern = "\\.sav$", full.names = TRUE)
pec_files <- pec_files[!grepl("Derivados", pec_files)]

pecuaria_list <- list()
for (f in pec_files) {
  name <- tools::file_path_sans_ext(basename(f))
  d <- read_sav_safe(f)
  if (!is.null(d)) pecuaria_list[[name]] <- d
}
cat("  Archivos procesados:", length(pecuaria_list), "\n")

# ─── 4. Save consolidado por módulo ──────────────────────────────────────────
cat("\n=== Guardando ===\n")
saveRDS(list(hogar1 = hogar1, hogar2 = hogar2, hogar3 = hogar3),
        file.path(proc, "ena_2015_hogar.rds"))
saveRDS(agric, file.path(proc, "ena_2015_agricola.rds"))
saveRDS(pecuaria_list, file.path(proc, "ena_2015_pecuaria.rds"))
cat("  ✓ ena_2015_hogar.rds\n")
cat("  ✓ ena_2015_agricola.rds\n")
cat("  ✓ ena_2015_pecuaria.rds\n")

# ─── 5. Generar resumen departamental ────────────────────────────────────────
cat("\n=== Resumen por departamento — producción agrícola ===\n")
if (!is.null(agric)) {
  # Identificar cols de interés
  dep_col <- grep("^depto$|^DEPTO$|^cod_dep$|^COD_DEP$", names(agric),
                  value = TRUE, ignore.case = TRUE)[1]
  if (is.na(dep_col)) dep_col <- grep("dep", names(agric),
                                       value = TRUE, ignore.case = TRUE)[1]

  if (!is.na(dep_col)) {
    agric[, dept_id := as.integer(get(dep_col))]
    agric_summary <- agric[, .(n_upas = .N), by = dept_id][order(dept_id)]
    cat("  Número UPA agrícolas por depto (código INE 1-9):\n")
    print(agric_summary)
  } else {
    cat("  No se encontró columna depto clara en agric\n")
  }
}

# Total UPAs por depto en ganadería
cat("\n=== Resumen pecuaria — UPA por tipo ===\n")
for (nm in names(pecuaria_list)) {
  d <- pecuaria_list[[nm]]
  if (is.null(d)) next
  cat(sprintf("  %-30s n_filas: %d\n", nm, nrow(d)))
}

cat("\n✓ ENA 2015 procesada completamente\n")
