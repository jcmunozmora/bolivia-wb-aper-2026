# =============================================================================
# Figura — Intuición: eficiencia técnica frente al NIVEL y la COMPOSICIÓN del gasto
# Responde "¿qué significan los scores DEA?" cruzándolos con cuánto y en qué se gasta.
# Tres lentes: nivel de gasto | % en inversión (capital) | % en infraestructura.
# Fuente scores: dea_simar_wilson_results.rds (ADR-0016) | gasto: dea_dataset.rds
# Estándar: .agent/07_FIGURAS.md + 00_wb_theme.R
# =============================================================================
source(here::here("02_code", "00_setup", "01_constants.R"))
source(here::here("02_code", "00_setup", "02_functions.R"))
source(here::here("02_code", "04_visualization", "00_wb_theme.R"))
suppressPackageStartupMessages({
  library(data.table); library(ggplot2); library(ggrepel)
})

res <- readRDS(file.path(DIR_DATA_PRO, "dea_simar_wilson_results.rds"))
m   <- as.data.table(res$scores_main)[, .(dept_upper, year, eff = eff_bc_in)]
d   <- as.data.table(readRDS(file.path(DIR_DATA_PRO, "dea_dataset.rds")))
x   <- merge(m, d, by = c("dept_upper", "year"))

# Métricas (los ratios son indiferentes a nominal/real porque el deflactor se cancela)
x[, gasto_usd   := agro_strict_bob_mm_2015 / bob_per_usd]                          # US$ mm const. 2015
x[, pct_invers  := 100 * p10_inversion_bob / (p10_corriente_bob + p10_inversion_bob)]
x[, pct_infra   := 100 * rural_infra_bob_mm_2015 / rural_total_bob_mm_2015]

ag <- x[, .(eff = mean(eff), gasto_usd = mean(gasto_usd),
            pct_invers = mean(pct_invers, na.rm = TRUE),
            pct_infra  = mean(pct_infra,  na.rm = TRUE)), by = dept_upper]

# Región geográfica (clasificación estándar Bolivia)
reg_map <- c(
  "SANTA CRUZ"="Tierras bajas", "BENI"="Tierras bajas", "PANDO"="Tierras bajas",
  "COCHABAMBA"="Valles", "TARIJA"="Valles", "CHUQUISACA"="Valles",
  "LA PAZ"="Altiplano", "ORURO"="Altiplano", "POTOSÍ"="Altiplano")
ag[, region := factor(reg_map[dept_upper], levels = c("Tierras bajas","Valles","Altiplano"))]
ag[, dept_lab := tools::toTitleCase(tolower(dept_upper))]
ag[dept_upper == "LA PAZ", dept_lab := "La Paz"]; ag[dept_upper == "SANTA CRUZ", dept_lab := "Santa Cruz"]

p_lvl <- "¿Cuánto?\nGasto agropecuario (US$ mm const. 2015)"
p_inv <- "¿En qué? — capital\n% del gasto en inversión"
p_inf <- "¿En qué? — bienes públicos\n% del gasto rural en infraestructura"
long <- rbind(
  ag[, .(dept_lab, region, eff, xval = gasto_usd,  panel = p_lvl)],
  ag[, .(dept_lab, region, eff, xval = pct_invers, panel = p_inv)],
  ag[, .(dept_lab, region, eff, xval = pct_infra,  panel = p_inf)]
)
long[, panel := factor(panel, levels = c(p_lvl, p_inv, p_inf))]

reg_cols <- c("Tierras bajas" = WB_BLUE, "Valles" = WB_GREEN, "Altiplano" = WB_ORANGE)

p <- ggplot(long, aes(x = xval, y = eff)) +
  geom_smooth(method = "lm", se = FALSE, color = WB_GREY, linewidth = 0.5, linetype = "dashed") +
  geom_point(aes(color = region), size = 2.6) +
  geom_text_repel(aes(label = dept_lab), size = 2.3, color = "#444444",
                  segment.color = "#CCCCCC", min.segment.length = 0,
                  max.overlaps = 20, box.padding = 0.4, seed = 1) +
  facet_wrap(~ panel, scales = "free_x") +
  scale_color_manual(values = reg_cols, name = "Región") +
  scale_x_continuous(expand = expansion(mult = 0.18)) +
  scale_y_continuous(limits = c(0.2, 0.95), expand = expansion(mult = 0.08)) +
  labs(
    x = NULL, y = "Eficiencia técnica DEA (0–1)",
    title = "Más gasto no compra más eficiencia técnica; la composición sí se asocia con ella",
    subtitle = "Promedios departamentales 2012–2020. Cada punto es un departamento; la línea punteada es solo guía visual.",
    caption = "Fuente: cálculos propios del Banco Mundial. Eficiencia: frontera DEA Simar-Wilson (orientación input, VRS)."
  ) +
  theme_wb(base_size = 10) +
  theme(
    legend.position = "top",
    panel.grid.minor = element_blank(),
    panel.spacing = unit(14, "pt"),
    strip.text = element_text(size = 8.2, lineheight = 0.95),
    plot.title = element_text(size = 12),
    plot.subtitle = element_text(size = 9),
    plot.margin = margin(12, 16, 12, 12)
  )

path <- save_figure(p, "fig25_dea_gasto_intuicion.png", width = 10.5, height = 4.9, dpi = 300)
cat("✓ Figura guardada:", path, "\n")
