# =============================================================================
# 00_packages.R — Instalación y carga de paquetes
# Bolivia Agricultural Public Expenditure Review 2026
# =============================================================================

# Paquetes requeridos agrupados por rol
REQUIRED_PACKAGES <- c(
  # Datos y APIs
  wbstats    = "WDI API",
  httr2      = "REST API genérico",
  readxl     = "Excel manual downloads",
  openxlsx   = "Excel escritura",
  pdftools   = "Extracción texto de PDFs",

  # Manipulación de datos
  tidyverse  = "dplyr, tidyr, ggplot2, purrr, readr, stringr",
  data.table = "operaciones eficientes",
  lubridate  = "fechas",
  janitor    = "limpieza nombres",
  here       = "rutas relativas robustas",
  glue       = "interpolación de strings",

  # Econometría
  fixest     = "FE regresiones",
  plm        = "modelos de panel",
  AER        = "IV/2SLS",
  lmtest     = "tests sobre modelos",
  sandwich   = "errores estándar robustos",
  censReg    = "Tobit (segunda etapa DEA)",

  # DEA
  Benchmarking = "DEA principal",
  rDEA       = "Bootstrap Simar-Wilson",
  deaR       = "Índice Malmquist",

  # Análisis multivariado
  FactoMineR = "PCA (food security index)",
  psych      = "análisis factorial",

  # Espacial
  sf         = "datos espaciales",
  spdep      = "Moran's I",
  tmap       = "mapas temáticos",

  # Visualización
  ggplot2    = "gráficos",
  ggrepel    = "labels sin solapamiento",
  patchwork  = "composición de figuras",
  scales     = "formateo ejes",
  RColorBrewer = "paletas",

  # Tablas de publicación
  gt         = "tablas principales",
  gtsummary  = "tablas resumen",
  modelsummary = "tablas de regresión",

  # Reporte
  knitr      = "reporte",
  kableExtra = "tablas LaTeX/HTML"
)

# ── Instalación automática de paquetes faltantes ─────────────────────────────
missing <- setdiff(names(REQUIRED_PACKAGES), rownames(installed.packages()))
if (length(missing) > 0) {
  cat("Instalando paquetes faltantes:\n")
  cat(paste(" -", missing), sep = "\n")
  install.packages(missing, repos = "https://cran.r-project.org")
}

# ── Carga ────────────────────────────────────────────────────────────────────
for (pkg in names(REQUIRED_PACKAGES)) {
  suppressPackageStartupMessages(library(pkg, character.only = TRUE))
}

# ── Resumen ──────────────────────────────────────────────────────────────────
cat("\n")
cat("=========================================================\n")
cat("  Bolivia WB Agricultural PER 2026 — Setup completado\n")
cat("=========================================================\n")
cat(sprintf("  R version:         %s\n", R.version.string))
cat(sprintf("  Paquetes cargados: %d\n", length(REQUIRED_PACKAGES)))
cat(sprintf("  Working dir:       %s\n", getwd()))
cat("=========================================================\n")
