# Panel regression: gasto agropecuario → outcomes agrícolas
# Estimador principal: fixest (FE bidireccional + SE robustos cluster)
# Output: tablas de regresión en 05_outputs/tables/
source(here::here("02_code", "00_setup", "01_constants.R"))
source(here::here("02_code", "00_setup", "02_functions.R"))
library(fixest)
library(modelsummary)
library(tidyverse)
library(AER)   # IV/2SLS

# ── Datos ─────────────────────────────────────────────────────────────────────
panel <- readRDS(file.path(DIR_DATA_PRO, "spending_panel.rds")) |>
  mutate(
    # Non-linearity: spending² (curva de Laffer del gasto público)
    ln_agr_spending_sq = ln_agr_spending^2,

    # Categorías de gasto desagregado (si disponibles)
    ln_spend_rd    = log(investigacion_extension_executed_usd + 1),
    ln_spend_irrig = log(riego_agua_executed_usd + 1),
    ln_spend_sanid = log(sanidad_inocuidad_executed_usd + 1),

    # Rezagos del gasto (retornos a la inversión con lag)
    ln_agr_spending_l1 = lag(ln_agr_spending, 1),
    ln_agr_spending_l2 = lag(ln_agr_spending, 2),
    ln_agr_spending_l3 = lag(ln_agr_spending, 3)
  )

# ── MODELO 1: PIB agropecuario (% PIB total) ──────────────────────────────────
# Regresión nacional de serie de tiempo con tendencia temporal
m1_base <- feols(
  agr_value_added_pct_gdp ~ ln_agr_spending + ln_agr_spending_sq,
  data = panel
)

m1_lag1 <- feols(
  agr_value_added_pct_gdp ~ ln_agr_spending_l1 + ln_agr_spending_sq,
  data = panel
)

m1_lag2 <- feols(
  agr_value_added_pct_gdp ~ ln_agr_spending_l2 + ln_agr_spending_sq,
  data = panel
)

# ── MODELO 2: Rendimiento de cereales (kg/ha) ─────────────────────────────────
m2_base <- feols(
  ln_cereal_yield ~ ln_agr_spending + ln_agr_spending_sq,
  data = panel
)

m2_decomp <- feols(
  ln_cereal_yield ~ ln_spend_rd + ln_spend_irrig + ln_spend_sanid,
  data = panel
)

# ── MODELO 3: Subalimentación (si disponible como panel subnacional) ──────────
m3_undernourish <- feols(
  undernourishment_pct ~ ln_agr_spending,
  data = panel |> filter(!is.na(undernourishment_pct))
)

# ── PANEL SUBNACIONAL (si disponible) ────────────────────────────────────────
subnac_path <- file.path(DIR_DATA_PRO, "subnacional_panel.rds")
if (file.exists(subnac_path)) {
  panel_dept <- readRDS(subnac_path) |>
    mutate(
      ln_agr_spending = log(agr_spending_real_bob + 1),
      ln_agr_spending_l1 = lag(ln_agr_spending, 1),
      .by = department
    )

  # FE bidireccional: departamento + año
  m_panel_fe <- feols(
    ln_agr_gdp_dept ~ ln_agr_spending + ln_agr_spending_l1 |
      department + year,
    data    = panel_dept,
    cluster = ~department   # SE clustered por departamento
  )

  # FE con interacción zona agroecológica (si disponible)
  # m_panel_zone <- feols(..., fsplit = ~agroecological_zone, ...)

  # Prueba de autocorrelación espacial (Moran's I)
  # Requiere shapefile de Bolivia por departamento
  shp_path <- here::here("01_data", "external", "bolivia_departments.gpkg")
  if (file.exists(shp_path)) {
    library(sf)
    library(spdep)
    shp <- sf::st_read(shp_path, quiet = TRUE)
    nb  <- spdep::poly2nb(shp)
    lw  <- spdep::nb2listw(nb, style = "W")

    # Residuales del modelo FE para test Moran's I
    resid_dept <- residuals(m_panel_fe)
    moran_test <- spdep::moran.test(resid_dept, lw)
    cat("Moran's I test (autocorrelación espacial residuales):\n")
    print(moran_test)
  }

  # GMM Arellano-Bond para dinámica (si N × T suficientemente grande)
  if (n_distinct(panel_dept$department) >= 5 &&
      n_distinct(panel_dept$year) >= 10) {
    tryCatch({
      m_gmm <- plm::pgmm(
        ln_agr_gdp_dept ~ lag(ln_agr_gdp_dept, 1) + ln_agr_spending |
          lag(ln_agr_spending, 2:4),
        data   = plm::pdata.frame(panel_dept, index = c("department", "year")),
        effect = "twoways",
        model  = "twosteps"
      )
      saveRDS(m_gmm, file.path(DIR_DATA_PRO, "gmm_model.rds"))
      cat("\nGMM Arellano-Bond:\n")
      summary(m_gmm, robust = TRUE) |> print()
    }, error = function(e) message("GMM no estimado: ", e$message))
  }
}

# ── Tabla de resultados ────────────────────────────────────────────────────────
models_list <- list(
  "(1) PIB agr."     = m1_base,
  "(2) PIB L1"       = m1_lag1,
  "(3) PIB L2"       = m1_lag2,
  "(4) Rendimiento"  = m2_base,
  "(5) Descomposición" = m2_decomp,
  "(6) Subalimentación" = m3_undernourish
)

tbl_regression <- modelsummary(
  models_list,
  stars     = c("*" = 0.1, "**" = 0.05, "***" = 0.01),
  gof_map   = c("nobs", "r.squared", "adj.r.squared"),
  fmt       = 3,
  output    = "gt",
  title     = "Gasto público agropecuario y outcomes del sector — Bolivia",
  notes     = list(
    "Errores estándar robustos en paréntesis.",
    "Fuente: BOOST/SIIF, WDI, FAOSTAT. Elaboración propia."
  )
)

save_table(tbl_regression, "tbl_03_regression_outcomes")

# Guardar modelos
saveRDS(models_list, file.path(DIR_DATA_PRO, "regression_models.rds"))
cat("Regresiones completadas. Tabla guardada en 05_outputs/tables/\n")
