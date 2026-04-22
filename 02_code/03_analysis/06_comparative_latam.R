# Análisis comparativo regional LAC — Benchmarking Bolivia
# Capítulo 2: Bolivia vs. pares regionales
source(here::here("02_code", "00_setup", "01_constants.R"))
source(here::here("02_code", "00_setup", "02_functions.R"))
source(here::here("02_code", "04_visualization", "00_wb_theme.R"))
library(tidyverse)
library(ggrepel)
library(patchwork)

wdi_latam <- readRDS(file.path(DIR_DATA_RAW, "wdi", "wdi_latam.rds")) |>
  rename(year = date) |> janitor::clean_names()

# ── 1. Tendencias PIB agropecuario % PIB — LAC ────────────────────────────────
p_agr_gdp_lac <- wdi_latam |>
  select(country, year, agr_value_added_pct_gdp = nv_agr_totl_zs) |>
  filter(!is.na(agr_value_added_pct_gdp), year >= 2000) |>
  mutate(highlight = country == "Bolivia") |>
  ggplot(aes(x = year, y = agr_value_added_pct_gdp,
             group = country, color = highlight, linewidth = highlight)) +
  geom_line(alpha = 0.7) +
  geom_text_repel(
    data = . %>% filter(year == max(year), highlight),
    aes(label = country), size = 3, nudge_x = 0.5
  ) +
  scale_color_manual(values = c("FALSE" = WB_GREY, "TRUE" = WB_BLUE), guide = "none") +
  scale_linewidth_manual(values = c("FALSE" = 0.5, "TRUE" = 1.5), guide = "none") +
  scale_y_continuous(labels = scales::percent_format(scale = 1)) +
  labs(
    title    = "PIB agropecuario como porcentaje del PIB total — LAC",
    subtitle = "2000–2023",
    x = NULL, y = "% del PIB",
    caption  = "Fuente: WDI. Elaboración propia."
  ) +
  theme_wb()

save_figure(p_agr_gdp_lac, "fig_05_agr_gdp_pct_latam.png")

# ── 2. Rendimiento cereales vs. gasto agropecuario (scatter) ─────────────────
# Diagrama de dispersión para el año más reciente
scatter_data <- wdi_latam |>
  select(country, year, cereal_yield = ag_yld_crel_kg,
         agr_value = nv_agr_totl_zs) |>
  filter(year == max(year, na.rm = TRUE)) |>
  filter(!is.na(cereal_yield), !is.na(agr_value)) |>
  mutate(highlight = country == "Bolivia")

p_scatter <- scatter_data |>
  ggplot(aes(x = agr_value, y = cereal_yield,
             color = highlight, label = country)) +
  geom_point(size = 3, alpha = 0.8) +
  geom_text_repel(size = 3, max.overlaps = 15) +
  geom_smooth(aes(group = 1), method = "lm", se = TRUE,
              color = WB_GREY, linetype = "dashed", linewidth = 0.8) +
  scale_color_manual(values = c("FALSE" = WB_GREY, "TRUE" = WB_RED), guide = "none") +
  scale_x_continuous(labels = scales::percent_format(scale = 1)) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title    = "PIB agropecuario y rendimiento de cereales — LAC",
    subtitle = "Último año disponible",
    x        = "PIB agropecuario (% del PIB total)",
    y        = "Rendimiento de cereales (kg/ha)",
    caption  = "Fuente: WDI. Elaboración propia. Bolivia resaltado en rojo."
  ) +
  theme_wb()

save_figure(p_scatter, "fig_06_scatter_yield_agr_gdp.png")

# ── 3. Subalimentación: Bolivia vs. LAC ──────────────────────────────────────
p_undernourish <- wdi_latam |>
  select(country, year, undernourish = sn_itk_defc_zs) |>
  filter(!is.na(undernourish), year >= 2000) |>
  mutate(highlight = country == "Bolivia") |>
  ggplot(aes(x = year, y = undernourish,
             group = country, color = highlight, linewidth = highlight)) +
  geom_line(alpha = 0.7) +
  scale_color_manual(values = c("FALSE" = WB_GREY, "TRUE" = WB_BLUE), guide = "none") +
  scale_linewidth_manual(values = c("FALSE" = 0.5, "TRUE" = 1.5), guide = "none") +
  scale_y_continuous(labels = scales::percent_format(scale = 1)) +
  labs(
    title    = "Prevalencia de subalimentación — LAC",
    subtitle = "% de la población",
    x = NULL, y = "%",
    caption  = "Fuente: WDI. Bolivia resaltado."
  ) +
  theme_wb()

save_figure(p_undernourish, "fig_07_undernourishment_latam.png")

# ── 4. Tabla IFPRI SPEED: benchmarking gasto agropecuario histórico ───────────
speed_path <- file.path(DIR_DATA_RAW, "ifpri_speed", "ifpri_speed_database.xlsx")
if (file.exists(speed_path)) {
  speed <- readxl::read_excel(speed_path) |>
    janitor::clean_names() |>
    filter(country %in% c("Bolivia", "Peru", "Chile", "Colombia",
                           "Ecuador", "Paraguay", "Argentina")) |>
    select(country, year, agr_exp_pct_gdp = starts_with("agr"))

  p_speed <- speed |>
    filter(!is.na(agr_exp_pct_gdp), year >= 1990) |>
    mutate(highlight = country == "Bolivia") |>
    ggplot(aes(x = year, y = agr_exp_pct_gdp,
               group = country, color = highlight)) +
    geom_line() +
    scale_color_manual(values = c("FALSE"=WB_GREY, "TRUE"=WB_BLUE), guide="none") +
    labs(title = "Gasto público en agricultura — IFPRI SPEED",
         y = "% del PIB", x = NULL,
         caption = "Fuente: IFPRI SPEED Database.") +
    theme_wb()

  save_figure(p_speed, "fig_08_ifpri_speed_benchmark.png")
} else {
  cat("IFPRI SPEED no descargado — ver 06_manual_sources.md\n")
}

cat("Análisis comparativo LAC completado.\n")
