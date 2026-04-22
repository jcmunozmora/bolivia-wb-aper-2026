# DEA + Bootstrap Simar-Wilson — Eficiencia técnica del gasto agropecuario
# DMUs: departamentos bolivianos × años (panel DEA)
# Require: subnacional_panel.rds con datos departamentales
# Output: scores de eficiencia, ranking departamental, índice Malmquist
source(here::here("02_code", "00_setup", "01_constants.R"))
source(here::here("02_code", "00_setup", "02_functions.R"))
library(Benchmarking)
library(rDEA)
library(deaR)
library(tidyverse)
library(fixest)   # para segunda etapa

# ── Cargar panel subnacional ──────────────────────────────────────────────────
subnac_path <- file.path(DIR_DATA_PRO, "subnacional_panel.rds")
if (!file.exists(subnac_path)) {
  stop(
    "subnacional_panel.rds no encontrado.\n",
    "Requiere datos departamentales SIIF/BOOST.\n",
    "Ver 06_manual_sources.md para instrucciones de descarga.\n",
    "Alternativa: ejecutar DEA a nivel nacional con comparadores LAC."
  )
}

panel_dept <- readRDS(subnac_path) |>
  filter(year %in% YEARS, department %in% DEPTS)

# ── Definición de inputs y outputs ───────────────────────────────────────────
# Inputs (lo que el gobierno controla/gasta):
#   X1: Gasto agropecuario real per trabajador agrícola (USD 2015)
#   X2: Crédito BDP desembolsado por departamento (USD 2015)  -- si disponible
#   X3: Área irrigada (ha)                                    -- si disponible

# Outputs (resultados del sector):
#   Y1: PIB agropecuario departamental (USD 2015)  -- si disponible
#   Y2: Rendimiento cereales (kg/ha)
#   Y3: 1 - Tasa de pobreza rural (proxy food security)

# Construir matrices de inputs y outputs
# Ajustar según disponibilidad real de datos departamentales
prepare_dea_matrices <- function(data, year_t) {
  df <- data |> filter(year == year_t) |> arrange(department)

  # NOTA: completar con variables reales cuando disponibles
  # Aquí se usan placeholders basados en la estructura esperada
  X <- df |>
    select(matches("agr_spending|credito|irrigated")) |>
    as.matrix()

  Y <- df |>
    select(matches("agr_gdp|cereal_yield|food_security")) |>
    as.matrix()

  list(X = X, Y = Y, depts = df$department)
}

# ── DEA por año (análisis de eficiencia temporal) ────────────────────────────
years_dea <- sort(unique(panel_dept$year))
dea_results <- list()

for (yr in years_dea) {
  mats <- tryCatch(
    prepare_dea_matrices(panel_dept, yr),
    error = function(e) NULL
  )
  if (is.null(mats) || nrow(mats$X) < 3) next

  # Modelo CRS (retornos constantes a escala) — orientado inputs
  dea_crs <- dea(X = mats$X, Y = mats$Y, RTS = "crs", ORIENTATION = "in")

  # Modelo VRS (retornos variables a escala)
  dea_vrs <- dea(X = mats$X, Y = mats$Y, RTS = "vrs", ORIENTATION = "in")

  # Eficiencia de escala = eff_CRS / eff_VRS
  dea_results[[as.character(yr)]] <- tibble(
    year         = yr,
    department   = mats$depts,
    eff_crs      = dea_crs$eff,
    eff_vrs      = dea_vrs$eff,
    scale_eff    = dea_crs$eff / dea_vrs$eff,
    returns_type = ifelse(scale_eff > 0.99, "CRS",
                          ifelse(dea_vrs$eff > dea_crs$eff, "IRS", "DRS"))
  )
}

eff_scores <- bind_rows(dea_results)

# ── Bootstrap DEA (Simar-Wilson) para intervalos de confianza ─────────────────
cat("Ejecutando bootstrap DEA (Simar-Wilson, B=2000)...\n")
cat("Esto puede tomar varios minutos...\n")

# Usar año más reciente con datos completos para bootstrap
yr_latest <- max(years_dea)
mats_latest <- prepare_dea_matrices(panel_dept, yr_latest)

if (nrow(mats_latest$X) >= 5) {
  bootstrap_dea <- tryCatch({
    dea.robust(
      X     = mats_latest$X,
      Y     = mats_latest$Y,
      W     = NULL,
      model = "input",
      RTS   = "CRS",
      B     = 2000,
      alpha = 0.05
    )
  }, error = function(e) {
    message("Bootstrap DEA falló: ", e$message)
    NULL
  })

  if (!is.null(bootstrap_dea)) {
    eff_bootstrap <- tibble(
      year         = yr_latest,
      department   = mats_latest$depts,
      eff_bias_corrected = bootstrap_dea$eff.bc,
      ci_lower     = bootstrap_dea$conf.int[, 1],
      ci_upper     = bootstrap_dea$conf.int[, 2]
    )
    saveRDS(eff_bootstrap, file.path(DIR_DATA_PRO, "dea_bootstrap_results.rds"))
  }
}

# ── Índice de Productividad Malmquist ─────────────────────────────────────────
cat("Calculando Índice Malmquist...\n")
# Requiere al menos 2 períodos consecutivos
if (length(years_dea) >= 2) {
  malmquist_results <- tryCatch({
    # deaR package para Malmquist
    # Preparar datos en formato largo requerido por deaR
    panel_dea_data <- panel_dept |>
      arrange(department, year) |>
      select(dmu = department, period = year,
             matches("agr_spending"), matches("agr_gdp|cereal_yield"))

    # make_deadata() requiere formato específico — ajustar con datos reales
    # dea_data <- make_deadata(panel_dea_data, ...)
    # malmquist(dea_data, orientation = "io", rts = "crs")
    NULL  # placeholder hasta datos disponibles
  }, error = function(e) {
    message("Malmquist no calculado: ", e$message)
    NULL
  })
}

# ── Segunda etapa: Tobit explicando eficiencia ────────────────────────────────
# Eficiencia DEA ~ factores de contexto (no controlables por el gasto)
# Regresión Tobit porque efficiency ∈ [0,1] → variable censurada

if (nrow(eff_scores) > 0) {
  # Mergear con covariables de contexto
  # (requiere datos de gobernanza, infraestructura, agroecología por dpto)
  eff_tobit_data <- eff_scores |>
    left_join(panel_dept, by = c("year", "department")) |>
    filter(!is.na(eff_vrs))

  tobit_model <- tryCatch({
    censReg::censReg(
      eff_vrs ~ year,  # expandir con covariables reales
      data  = eff_tobit_data,
      left  = 0,
      right = 1
    )
  }, error = function(e) {
    message("Tobit no estimado: ", e$message); NULL
  })

  if (!is.null(tobit_model)) {
    saveRDS(tobit_model, file.path(DIR_DATA_PRO, "dea_tobit_model.rds"))
  }
}

# ── Guardar y reportar ────────────────────────────────────────────────────────
saveRDS(eff_scores, file.path(DIR_DATA_PRO, "dea_efficiency_scores.rds"))

cat("\n=== Scores de Eficiencia DEA ===\n")
eff_scores |>
  group_by(year) |>
  summarise(
    mean_eff_crs = mean(eff_crs, na.rm=TRUE),
    mean_eff_vrs = mean(eff_vrs, na.rm=TRUE),
    n_efficient  = sum(eff_crs >= 0.99, na.rm=TRUE),
    .groups = "drop"
  ) |>
  print()
