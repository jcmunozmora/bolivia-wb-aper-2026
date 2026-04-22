library(data.table)
library(ggplot2)
library(tidyr)
library(dplyr)
library(scales)

here_root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
source(file.path(here_root, "02_code/04_visualization/00_wb_theme.R"))

panel   <- readRDS(file.path(here_root, "01_data/processed/spending_panel.rds"))
fig_dir <- file.path(here_root, "05_outputs/figures")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

setDT(panel)

# ── Fig 1: PIB agropecuario % PIB total (2000-2023) ───────────────────────────
p1 <- ggplot(panel[!is.na(agr_value_added_pct_gdp)],
             aes(x = year, y = agr_value_added_pct_gdp)) +
  geom_line(color = WB_BLUE, linewidth = 1.1) +
  geom_point(color = WB_BLUE, size = 2) +
  geom_hline(yintercept = mean(panel$agr_value_added_pct_gdp, na.rm = TRUE),
             linetype = "dashed", color = WB_GREY, linewidth = 0.6) +
  scale_x_continuous(breaks = seq(2000, 2023, 4)) +
  scale_y_continuous(labels = label_number(suffix = "%")) +
  labs(title   = "Valor Agregado Agropecuario como % del PIB",
       subtitle = "Bolivia, 2000-2023",
       x = NULL, y = "% del PIB",
       caption = "Fuente: Banco Mundial, World Development Indicators.") +
  theme_wb()
ggsave(file.path(fig_dir, "fig01_agr_value_added_pct_gdp.png"),
       p1, width = 8, height = 5, dpi = 150)
cat("Fig 1 guardado\n")

# ── Fig 2: Gasto público agropecuario — APER (2000-2008) ──────────────────────
spend_data <- panel[!is.na(agro_spend_bob_2015),
                    .(year, agro_spend_bob_2015, agro_spend_pct_gdp)]
scale_factor <- 200  # for dual axis

p2 <- ggplot(spend_data, aes(x = year)) +
  geom_col(aes(y = agro_spend_bob_2015 / 1e6), fill = WB_BLUE, alpha = 0.85) +
  geom_line(aes(y = agro_spend_pct_gdp * scale_factor),
            color = WB_RED, linewidth = 1.2) +
  geom_point(aes(y = agro_spend_pct_gdp * scale_factor),
             color = WB_RED, size = 2.5) +
  scale_x_continuous(breaks = 2000:2008) +
  scale_y_continuous(
    name     = "BOB millones (constantes 2015)",
    sec.axis = sec_axis(~ . / scale_factor,
                        name   = "% del PIB",
                        labels = label_number(suffix = "%", accuracy = 0.1))
  ) +
  labs(title   = "Gasto Público Agropecuario",
       subtitle = "Bolivia, 2000-2008 (Fuente: APER, Banco Mundial)",
       x = NULL,
       caption = "Barras: millones BOB constantes 2015.  Línea roja: % del PIB.") +
  theme_wb()
ggsave(file.path(fig_dir, "fig02_agro_spending_aper.png"),
       p2, width = 8, height = 5, dpi = 150)
cat("Fig 2 guardado\n")

# ── Fig 3: Composición del gasto agropecuario por categoría ───────────────────
cat_cols   <- c("spend_riego_agua", "spend_fomento_produccion",
                "spend_investigacion_extension", "spend_sanidad_inocuidad",
                "spend_administracion_general")
cat_labels <- c("Riego y agua", "Fomento producción",
                "I+D y extensión", "Sanidad agrícola", "Administración")

spend_long <- panel[!is.na(spend_riego_agua)] |>
  as_tibble() |>
  select(year, all_of(cat_cols)) |>
  pivot_longer(-year, names_to = "category", values_to = "bob") |>
  mutate(
    category = factor(category, levels = cat_cols, labels = cat_labels),
    bob_m    = bob / 1e6
  )

p3 <- ggplot(spend_long, aes(x = year, y = bob_m, fill = category)) +
  geom_col() +
  scale_x_continuous(breaks = 2000:2008) +
  scale_fill_manual(values = c(WB_BLUE, WB_TEAL, WB_NAVY, WB_ORANGE, WB_GREY)) +
  scale_y_continuous(labels = label_number(suffix = "M")) +
  labs(title   = "Composición del Gasto Público Agropecuario",
       subtitle = "Bolivia, 2000-2008 — BOB corrientes (clasificación UDAPE-FAM)",
       x = NULL, y = "Millones BOB", fill = NULL,
       caption = "Fuente: APER (Banco Mundial).") +
  theme_wb() +
  theme(legend.position = "bottom")
ggsave(file.path(fig_dir, "fig03_spending_composition.png"),
       p3, width = 8, height = 5, dpi = 150)
cat("Fig 3 guardado\n")

# ── Fig 4: Rendimiento de cereales y subalimentación (2000-2023) ───────────────
p4 <- ggplot(panel[!is.na(cereal_yield_kg_ha)], aes(x = year)) +
  geom_ribbon(aes(ymin = 1200, ymax = cereal_yield_kg_ha),
              fill = WB_BLUE, alpha = 0.15) +
  geom_line(aes(y = cereal_yield_kg_ha, color = "Rendimiento cereales\n(kg/ha, eje izq.)"),
            linewidth = 1.1) +
  geom_line(aes(y = undernourishment_pct * 100,
                color = "Subalimentación\n(%, ×100, eje der.)"),
            linewidth = 1.1, linetype = "dashed") +
  scale_color_manual(values = c("Rendimiento cereales\n(kg/ha, eje izq.)" = WB_BLUE,
                                "Subalimentación\n(%, ×100, eje der.)"    = WB_RED)) +
  scale_x_continuous(breaks = seq(2000, 2023, 4)) +
  scale_y_continuous(
    name     = "Rendimiento (kg/ha)",
    sec.axis = sec_axis(~ . / 100, name = "Subalimentación (%)")
  ) +
  labs(title   = "Desempeño del Sector Agropecuario",
       subtitle = "Bolivia, 2000-2023",
       x = NULL, color = NULL,
       caption = "Fuente: WDI (rendimiento), FAOSTAT vía Our World in Data (subalimentación).") +
  theme_wb() +
  theme(legend.position = "bottom")
ggsave(file.path(fig_dir, "fig04_outcomes_trends.png"),
       p4, width = 8, height = 5, dpi = 150)
cat("Fig 4 guardado\n")

# ── Fig 5: Mapa departamental Bolivia ─────────────────────────────────────────
adm1_file <- file.path(here_root, "01_data/external/bolivia_adm1_departments.gpkg")
if (file.exists(adm1_file) && requireNamespace("sf", quietly = TRUE)) {
  library(sf)
  adm1 <- st_read(adm1_file, quiet = TRUE)
  p5 <- ggplot(adm1) +
    geom_sf(fill = "#D4EBF8", color = WB_NAVY, linewidth = 0.6) +
    geom_sf_text(aes(label = shapeName), size = 2.8, color = WB_NAVY,
                 fontface = "bold") +
    labs(title   = "Bolivia — División Departamental",
         subtitle = "9 Departamentos",
         caption  = "Fuente: geoBoundaries (CC BY 4.0).") +
    theme_wb() +
    theme(axis.text  = element_blank(), axis.ticks = element_blank(),
          panel.grid = element_blank(), axis.line  = element_blank())
  ggsave(file.path(fig_dir, "fig05_bolivia_departments_map.png"),
         p5, width = 6, height = 7, dpi = 150)
  cat("Fig 5 (mapa) guardado\n")
}

cat("\n=== Figuras guardadas en", fig_dir, "===\n")
print(list.files(fig_dir, pattern = "\\.png$"))
