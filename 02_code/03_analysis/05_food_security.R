# Análisis de seguridad alimentaria Bolivia
# Marco FAO: 4 dimensiones (disponibilidad, acceso, utilización, estabilidad)
# Construye índice compuesto via PCA
source(here::here("02_code", "00_setup", "01_constants.R"))
source(here::here("02_code", "00_setup", "02_functions.R"))
library(tidyverse)
library(FactoMineR)
library(psych)

fs_bol   <- readRDS(file.path(DIR_DATA_RAW, "faostat", "food_security_bolivia.rds")) |>
  janitor::clean_names() |> filter(year %in% YEARS)
outcomes <- readRDS(file.path(DIR_DATA_PRO, "agricultural_outcomes.rds"))

# ── 1. Normalizar indicadores a escala 0-100 ──────────────────────────────────
# Dirección: 100 = mejor situación de seguridad alimentaria
normalize_indicator <- function(x, direction = "higher_better") {
  x_min <- min(x, na.rm = TRUE); x_max <- max(x, na.rm = TRUE)
  norm <- (x - x_min) / (x_max - x_min) * 100
  if (direction == "lower_better") norm <- 100 - norm
  norm
}

fs_wide <- outcomes |>
  select(year, starts_with("food_"), starts_with("undernourish"),
         cereal_yield_kg_ha, agr_food_prod_index) |>
  filter(year %in% YEARS) |>
  mutate(
    # DIMENSIÓN 1: Disponibilidad
    idx_food_prod   = normalize_indicator(agr_food_prod_index, "higher_better"),
    idx_cereal_yield = normalize_indicator(cereal_yield_kg_ha, "higher_better"),

    # DIMENSIÓN 2: Acceso (subalimentación → invertir)
    idx_undernourish = normalize_indicator(undernourishment_pct, "lower_better"),

    # DIMENSIÓN 3: Utilización (food supply kcal)
    idx_kcal_supply  = normalize_indicator(food_supply_kcal_day, "higher_better"),

    # DIMENSIÓN 4: Estabilidad (CV de rendimiento cereal)
    cv_yield = slider::slide_dbl(cereal_yield_kg_ha, cv, .before = 4, .complete = FALSE)
  )

# ── 2. PCA para pesos del índice compuesto ────────────────────────────────────
pca_vars <- c("idx_food_prod", "idx_cereal_yield", "idx_undernourish", "idx_kcal_supply")

pca_data <- fs_wide |>
  select(all_of(pca_vars)) |>
  filter(complete.cases(.))

if (nrow(pca_data) >= 5) {
  pca_result <- PCA(pca_data, scale.unit = TRUE, graph = FALSE)

  # Pesos del PC1 (primer componente principal)
  pca_weights <- abs(pca_result$var$cor[, 1])
  pca_weights <- pca_weights / sum(pca_weights)

  cat("\nPesos PCA para índice compuesto:\n")
  print(round(pca_weights, 3))

  # Calcular índice compuesto ponderado
  fs_wide <- fs_wide |>
    left_join(
      pca_data |>
        mutate(
          food_security_index = rowSums(
            sweep(as.matrix(select(pca_data, all_of(pca_vars))),
                  2, pca_weights, "*")
          )
        ) |>
        mutate(row_id = row_number()),
      by = character()
    )
} else {
  # Índice simple (promedio igual ponderado) si no hay suficientes obs para PCA
  fs_wide <- fs_wide |>
    rowwise() |>
    mutate(
      food_security_index = mean(c(idx_food_prod, idx_cereal_yield,
                                    idx_undernourish, idx_kcal_supply),
                                  na.rm = TRUE)
    ) |>
    ungroup()
}

# ── 3. Comparación regional con LAC ──────────────────────────────────────────
fs_latam <- readRDS(file.path(DIR_DATA_RAW, "faostat", "food_security_latam.rds")) |>
  janitor::clean_names() |>
  filter(
    year %in% YEARS,
    item == "Prevalence of undernourishment (percent) (3-year average)"
  ) |>
  select(year, country = area, undernourishment_pct = value)

# ── 4. Vincular con gasto público ────────────────────────────────────────────
panel <- readRDS(file.path(DIR_DATA_PRO, "spending_panel.rds"))

fs_spending <- fs_wide |>
  select(year, food_security_index, idx_undernourish) |>
  left_join(
    panel |> select(year, agr_spending_total_usd, investigacion_extension_executed_usd),
    by = "year"
  )

# Correlación gasto-seguridad alimentaria
corr_matrix <- cor(
  fs_spending |> select(-year) |> filter(complete.cases(.)),
  use = "pairwise.complete.obs"
)
cat("\nCorrelación gasto vs. seguridad alimentaria:\n")
print(round(corr_matrix["food_security_index", ], 3))

# ── 5. Guardar ────────────────────────────────────────────────────────────────
saveRDS(fs_wide,     file.path(DIR_DATA_PRO, "food_security_index.rds"))
saveRDS(fs_latam,    file.path(DIR_DATA_PRO, "food_security_latam.rds"))

cat("Índice de seguridad alimentaria calculado para", nrow(fs_wide), "años\n")
