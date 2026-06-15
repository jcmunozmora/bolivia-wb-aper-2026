# =============================================================================
# Figura — Heatmap de eficiencia técnica DEA Simar-Wilson (depto × año)
# Reemplaza fig24_eficiencia_simple_2019 (figura preparatoria).
# Fuente: 01_data/processed/dea_simar_wilson_results.rds (ADR-0016)
# Estándar: .agent/07_FIGURAS.md + 02_code/04_visualization/00_wb_theme.R
# =============================================================================
source(here::here("02_code", "00_setup", "01_constants.R"))
source(here::here("02_code", "00_setup", "02_functions.R"))
source(here::here("02_code", "04_visualization", "00_wb_theme.R"))
suppressPackageStartupMessages({
  library(data.table)
  library(ggplot2)
})

res <- readRDS(file.path(DIR_DATA_PRO, "dea_simar_wilson_results.rds"))
m   <- as.data.table(res$scores_main)

# Orden departamental por eficiencia media corregida (más eficiente arriba)
ord <- m[, .(mean_eff = mean(eff_bc_in, na.rm = TRUE)), by = dept_upper][order(mean_eff)]
m[, dept_f := factor(dept_upper, levels = ord$dept_upper)]
m[, lab := formatC(eff_bc_in, format = "f", digits = 2)]
m[, txt_col := ifelse(eff_bc_in > 0.60, "white", WB_NAVY)]

p <- ggplot(m, aes(x = factor(year), y = dept_f, fill = eff_bc_in)) +
  geom_tile(color = "white", linewidth = 0.6) +
  geom_text(aes(label = lab, color = txt_col), size = 2.7, show.legend = FALSE) +
  scale_color_identity() +
  scale_fill_gradient(
    low = "#FBE5D6", high = WB_NAVY, limits = c(0, 1),
    name = "Score\n(corregido)", breaks = c(0.2, 0.5, 0.8)
  ) +
  labs(
    x = NULL, y = NULL,
    title = "Eficiencia técnica del gasto agropecuario por departamento",
    subtitle = "Scores DEA corregidos por sesgo (Simar-Wilson, orientación input, VRS), 2012–2020",
    caption = "Fuente: cálculos propios del Banco Mundial. Nota: mayor score = mayor eficiencia técnica."
  ) +
  theme_wb(base_size = 10) +
  theme(panel.grid = element_blank(),
        axis.line.x = element_blank(),
        legend.position = "right")

path <- save_figure(p, "fig24_dea_heatmap_simar_wilson.png",
                    width = 8, height = 4.6, dpi = 300)
cat("✓ Figura guardada:", path, "\n")
