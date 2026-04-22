# Funciones utilitarias compartidas — Bolivia WB Project
source(here::here("02_code", "00_setup", "01_constants.R"))

# ── Deflactores y conversión monetaria ───────────────────────────────────────

#' Deflactar serie nominal a valores reales en año base
#' @param nominal Vector de valores nominales
#' @param cpi     Vector de índice CPI (mismo año base que DEFLATOR_BASE)
#' @param base_year Año base target (default: DEFLATOR_BASE = 2015)
deflate_to_real <- function(nominal, cpi, base_year = DEFLATOR_BASE) {
  cpi_base <- cpi[names(cpi) == as.character(base_year)]
  if (length(cpi_base) == 0) stop("CPI base year not found in vector")
  nominal * (cpi_base / cpi)
}

#' Convertir BOB a USD usando tipo de cambio promedio anual
#' @param bob    Vector de valores en BOB
#' @param xrate  Vector named con tipo de cambio BOB/USD por año
bob_to_usd <- function(bob, xrate) {
  bob / xrate
}

# ── Winsorización ─────────────────────────────────────────────────────────────

#' Winsorizar valores extremos al percentil p_low y p_high
winsorize <- function(x, p_low = 0.01, p_high = 0.99) {
  q <- quantile(x, probs = c(p_low, p_high), na.rm = TRUE)
  pmax(pmin(x, q[2]), q[1])
}

# ── Clasificación COFOG ───────────────────────────────────────────────────────

#' Clasificar línea presupuestal en categoría COFOG agrícola
#' Usa tabla de correspondencia cofog_classification.csv
#' @param program_code Código del programa presupuestal boliviano
#' @param description  Descripción textual del programa (fuzzy match fallback)
#' @param cofog_table  data.frame con columnas: program_code, cofog_code, category
classify_cofog <- function(program_code, description = NULL, cofog_table) {
  match_exact <- cofog_table[cofog_table$program_code == program_code, ]
  if (nrow(match_exact) > 0) return(match_exact$cofog_code[1])

  if (!is.null(description)) {
    agr_keywords <- c("agrop", "agric", "ganad", "pesc", "forestal", "riego",
                      "semil", "fertil", "extensi", "sanidad vegetal", "senasag",
                      "iniaf", "emapa", "inra", "fondo tierra")
    if (any(sapply(agr_keywords, function(k) grepl(k, tolower(description))))) {
      return(COFOG_AGR)
    }
  }
  return(NA_character_)
}

# ── Estadísticos descriptivos ─────────────────────────────────────────────────

#' Coeficiente de variación
cv <- function(x, na.rm = TRUE) sd(x, na.rm = na.rm) / mean(x, na.rm = na.rm)

#' Índice Gini (para distribución subnacional del gasto)
gini <- function(x, na.rm = TRUE) {
  if (na.rm) x <- x[!is.na(x)]
  x <- sort(x)
  n <- length(x)
  2 * sum((1:n) * x) / (n * sum(x)) - (n + 1) / n
}

#' Crear tabla resumen estándar del proyecto
summary_table <- function(data, vars, by = NULL, digits = 2) {
  data |>
    dplyr::select(dplyr::all_of(c(by, vars))) |>
    (\(d) if (!is.null(by)) dplyr::group_by(d, dplyr::across(dplyr::all_of(by))) else d)() |>
    dplyr::summarise(
      dplyr::across(dplyr::all_of(vars), list(
        n     = ~sum(!is.na(.)),
        mean  = ~mean(., na.rm = TRUE),
        sd    = ~sd(., na.rm = TRUE),
        min   = ~min(., na.rm = TRUE),
        p25   = ~quantile(., 0.25, na.rm = TRUE),
        med   = ~median(., na.rm = TRUE),
        p75   = ~quantile(., 0.75, na.rm = TRUE),
        max   = ~max(., na.rm = TRUE)
      ), .names = "{.col}__{.fn}"
    ), .groups = "drop"
  ) |>
    dplyr::mutate(dplyr::across(dplyr::where(is.numeric), ~round(., digits)))
}

# ── Guardar outputs ───────────────────────────────────────────────────────────

#' Guardar figura con dimensiones estándar para reporte WB
save_figure <- function(plot, filename, width = 7, height = 4.5, dpi = 300,
                        dir = DIR_FIGS) {
  path <- file.path(dir, filename)
  ggplot2::ggsave(path, plot = plot, width = width, height = height,
                  dpi = dpi, bg = "white")
  invisible(path)
}

#' Guardar tabla gt como PNG y LaTeX
save_table <- function(gt_obj, filename, dir = DIR_TABLES) {
  gt::gtsave(gt_obj, file.path(dir, paste0(filename, ".png")))
  gt::gtsave(gt_obj, file.path(dir, paste0(filename, ".tex")))
  invisible(file.path(dir, filename))
}

# ── Logging de descarga de datos ──────────────────────────────────────────────

#' Registrar descarga en data_access_log.md
log_download <- function(source, file_path, url = NA, notes = "") {
  entry <- glue::glue(
    "| {Sys.Date()} | {source} | {basename(file_path)} | {url} | {notes} |\n"
  )
  log_path <- here::here("00_admin", "data_access_log.md")
  if (!file.exists(log_path)) {
    writeLines("| Date | Source | File | URL | Notes |\n|------|--------|------|-----|-------|", log_path)
  }
  cat(entry, file = log_path, append = TRUE)
  invisible(entry)
}
