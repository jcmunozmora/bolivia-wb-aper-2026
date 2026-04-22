# Procesa FAOSTAT QCL (vía OWID CSVs) — producción, rendimiento, insumos
# =============================================================================
# Input: 01_data/raw/faostat_qcl/owid_*.csv (ya descargados)
# Output:
#   - faostat_bolivia.rds  — Bolivia: serie completa 1961-2023
#   - faostat_latam.rds    — LAC: comparadores regionales
# Merge a panel_v5 → panel_v6 en script separado
# =============================================================================

library(data.table)

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
fao_dir  <- file.path(root, "01_data/raw/faostat_qcl")
proc     <- file.path(root, "01_data/processed")

# Países LAC para comparadores
LAC_CODES <- c("BOL","ARG","BRA","CHL","COL","ECU","MEX","PER","PRY","URY",
                "VEN","GTM","HND","NIC","PAN","SLV","DOM","CRI","JAM","HTI")

# ── Leer y combinar todos los CSVs ──────────────────────────────────────────
files <- list.files(fao_dir, pattern = "^owid_.*\\.csv$", full.names = TRUE)
cat("Archivos OWID encontrados:", length(files), "\n")

datasets <- lapply(files, function(f) {
  varname <- tools::file_path_sans_ext(basename(f))
  varname <- sub("^owid_", "", varname)
  dt <- tryCatch(fread(f, showProgress = FALSE), error = function(e) NULL)
  if (is.null(dt)) { cat(sprintf("  %-35s ERROR lectura\n", basename(f))); return(NULL) }
  # Detectar archivos que son errores JSON (columna 1 == "status" o similar)
  if (!"Entity" %in% names(dt) || !"Year" %in% names(dt)) {
    cat(sprintf("  %-35s SKIP (no es CSV OWID válido)\n", basename(f))); return(NULL)
  }
  val_cols <- setdiff(names(dt), c("Entity", "Code", "Year"))
  if (length(val_cols) == 0) { cat(sprintf("  %-35s SKIP (sin vars)\n", basename(f))); return(NULL) }
  cat(sprintf("  %-35s %d filas | %d vars\n", basename(f), nrow(dt), length(val_cols)))
  dt[, source := varname]
  dt
})
datasets <- Filter(Negate(is.null), datasets)

# ── Bolivia — melt a long (maneja multi-columna) ─────────────────────────────
bol_list <- lapply(seq_along(datasets), function(i) {
  dt <- datasets[[i]][Code == "BOL"]
  if (nrow(dt) == 0) return(NULL)
  val_cols <- setdiff(names(dt), c("Entity", "Code", "Year", "source"))
  # melt todas las columnas de valor
  melt(dt[, c("Code", "Year", val_cols), with = FALSE],
       id.vars = c("Code", "Year"),
       variable.name = "variable", value.name = "value")
})
bol_long <- rbindlist(Filter(Negate(is.null), bol_list))

# Limpiar nombres de variable (quitar sufijos FAOSTAT verbosos)
clean_varname <- function(x) {
  x <- gsub(" - Production \\(tonnes\\)", "_prod_ton", x)
  x <- gsub(" - Yield \\(kg per hectare\\)", "_yield_kg_ha", x)
  x <- gsub(" - Livestock, number of animals", "_livestock_head", x)
  x <- gsub(" - Meat, total production \\(tonnes\\)", "_meat_ton", x)
  x <- gsub(" - Use per area of cropland \\(kilograms per hectare\\)", "_kg_ha", x)
  x <- tolower(gsub("[^a-zA-Z0-9_]", "_", x))
  x
}
bol_long[, variable := clean_varname(variable)]

# Reshape a wide
bol_wide <- dcast(bol_long, Code + Year ~ variable, value.var = "value",
                  fun.aggregate = mean)
setnames(bol_wide, "Year", "year")

cat("\n=== Bolivia FAOSTAT ===\n")
cat("Filas:", nrow(bol_wide), "| Vars:", ncol(bol_wide), "\n")
cat("Años:", paste(range(bol_wide$year), collapse = "-"), "\n")

# Completitud de vars clave
key_vars <- names(bol_wide)[!names(bol_wide) %in% c("Code", "year")]
for (v in key_vars) {
  n <- sum(!is.na(bol_wide[[v]]))
  cat(sprintf("  %-45s %3d obs\n", v, n))
}

# ── LAC comparadores ─────────────────────────────────────────────────────────
lac_list <- lapply(seq_along(datasets), function(i) {
  dt <- datasets[[i]][Code %in% LAC_CODES]
  if (nrow(dt) == 0) return(NULL)
  val_cols <- setdiff(names(dt), c("Entity", "Code", "Year", "source"))
  melt(dt[, c("Entity", "Code", "Year", val_cols), with = FALSE],
       id.vars = c("Entity", "Code", "Year"),
       variable.name = "variable", value.name = "value")
})
lac_long <- rbindlist(Filter(Negate(is.null), lac_list))
lac_long[, variable := clean_varname(variable)]
lac_wide <- dcast(lac_long, Entity + Code + Year ~ variable,
                  value.var = "value", fun.aggregate = mean)
setnames(lac_wide, "Year", "year")

cat("\n=== LAC FAOSTAT ===\n")
cat("Países:", length(unique(lac_wide$Code)),
    "| Filas:", nrow(lac_wide), "\n")

# ── Merge a panel v5 ─────────────────────────────────────────────────────────
panel <- readRDS(file.path(proc, "spending_panel_v5.rds"))
setDT(panel)
panel[, Code := "BOL"]

# Seleccionar vars más útiles del FAOSTAT para el panel
fao_merge_vars <- intersect(
  c("year", "Code",
    grep("cereal.*yield|yield.*cereal|crop.*prod|prod.*crop|fertilizer|pesticide",
         names(bol_wide), value = TRUE, ignore.case = TRUE),
    names(bol_wide)[grepl("yield|prod|livestock|meat", names(bol_wide))]
  ),
  names(bol_wide)
)
fao_merge_vars <- unique(fao_merge_vars)

panel_fao <- merge(panel, bol_wide[, ..fao_merge_vars],
                   by = c("year", "Code"), all.x = TRUE)
cat("\nPanel + FAOSTAT QCL:", nrow(panel_fao), "×", ncol(panel_fao), "\n")

# ── Guardar ──────────────────────────────────────────────────────────────────
saveRDS(bol_wide,   file.path(proc, "faostat_bolivia_qcl.rds"))
saveRDS(lac_wide,   file.path(proc, "faostat_latam_qcl.rds"))
fwrite(bol_wide,    file.path(proc, "faostat_bolivia_qcl.csv"))
saveRDS(panel_fao,  file.path(proc, "spending_panel_v5_fao.rds"))

cat("\n✓ faostat_bolivia_qcl.rds\n")
cat("✓ faostat_latam_qcl.rds\n")
cat("✓ spending_panel_v5_fao.rds (panel v5 + FAOSTAT)\n")
