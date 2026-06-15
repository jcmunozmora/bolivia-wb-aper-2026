# 08_pareto_exportaciones.R — Pareto del VALOR de exportaciones agropecuarias Bolivia 2006 vs 2023
# Diseño: Pareto clásico por VALOR de exportación (USD constantes 2015). Barras descendentes.
#   Rubros que acumulan 80% en azul; "Otros" (residual vs total agropecuario) en gris.
#   Línea = % acumulado; referencia 80%.
# Fuente: FAOSTAT Trade (Crops & livestock), Element 5922 Export value.
#   Se curan ítems-hoja (sin agregados) y se agrupan en cadenas (soya, girasol, carne bovina).
#   "Otros" = total agropecuario (Crops and livestock products) - suma de rubros curados.
#   Deflactado a USD const. 2015 (US GDP deflator, WDI NY.GDP.DEFL.ZS).
# Salida: fig_pareto_export_2006v2023.{png,svg,pdf} (600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))

library(tidyverse)
library(ggplot2)
library(patchwork)
library(scales)
library(here)

exp_raw <- readRDS(here("01_data", "processed", "faostat_bolivia_exports.rds"))

# Deflactor a USD const. 2015
defl <- readRDS(here("01_data", "processed", "wdi_us_gdp_deflator.rds"))
defl_2015 <- defl$us_gdp_deflator[defl$year == 2015]
defl <- defl %>% mutate(factor_2015 = defl_2015 / us_gdp_deflator) %>% select(year, factor_2015)

# Ítem code del total agropecuario (denominador)
COD_TOTAL_AGRO <- 1882  # "Crops and livestock products"

# Rubros curados (ítem-hoja → grupo en español). Evita agregados para no doble-contar.
grupos <- tribble(
  ~item_code, ~grupo,
  238, "Soya y derivados",      # Cake of soya beans
  237, "Soya y derivados",      # Soya bean oil
  236, "Soya y derivados",      # Soya beans
  870, "Carne bovina",          # Meat of cattle boneless, fresh or chilled
  868, "Carne bovina",          # Edible offal of cattle
  229, "Castaña (nuez de Brasil)", # Brazil nuts, shelled
  268, "Girasol y derivados",   # Sunflower-seed oil, crude
  269, "Girasol y derivados",   # Cake of sunflower seed
   92, "Quinua",                # Quinoa
  164, "Azúcar",                # Refined sugar
  486, "Banano",                # Bananas
  897, "Lácteos"                # Whole milk powder
)

# ============================================================================
# Preparar datos por año
# ============================================================================

prep_year <- function(data, year_val) {
  f <- defl$factor_2015[defl$year == year_val]

  total_agro <- data %>%
    filter(item_code == COD_TOTAL_AGRO, year == year_val) %>%
    summarise(v = sum(export_value_1000usd, na.rm = TRUE)) %>% pull(v)

  curados <- data %>%
    filter(item_code %in% grupos$item_code, year == year_val) %>%
    left_join(grupos, by = "item_code") %>%
    group_by(grupo) %>%
    summarise(valor = sum(export_value_1000usd, na.rm = TRUE), .groups = "drop")

  suma_curada <- sum(curados$valor)
  otros <- max(total_agro - suma_curada, 0)

  bind_rows(
    curados,
    tibble(grupo = "Otros agropecuarios", valor = otros)
  ) %>%
    # USD const 2015, en millones
    mutate(valor_mn = valor * f / 1000) %>%
    arrange(desc(grupo == "Otros agropecuarios"), desc(valor_mn)) %>%  # Otros al final
    arrange(if_else(grupo == "Otros agropecuarios", Inf, -valor_mn)) %>%
    mutate(
      total = sum(valor_mn),
      pct = 100 * valor_mn / total,
      acum_pct = cumsum(pct),
      vital = lag(acum_pct, default = 0) < 80 & grupo != "Otros agropecuarios",
      orden = row_number(),
      year = year_val
    )
}

d2006 <- prep_year(exp_raw, 2006)
d2023 <- prep_year(exp_raw, 2023)

# ============================================================================
# Panel Pareto
# ============================================================================

plot_pareto <- function(d, year_val) {
  n_vital <- sum(d$vital)
  d <- d %>% mutate(
    grupo = factor(grupo, levels = grupo[order(orden)]),
    fill_col = if_else(vital, "#2E7D5B", if_else(grupo == "Otros agropecuarios", "gray80", "#9FC8B5"))
  )
  max_val <- max(d$valor_mn)

  ggplot(d, aes(x = grupo, y = valor_mn)) +
    geom_col(aes(fill = fill_col), width = 0.74) +
    scale_fill_identity() +
    geom_text(aes(label = paste0("$", label_comma(accuracy = 1)(round(valor_mn)))),
              vjust = -0.6, size = 2.7, color = "gray25") +
    geom_line(aes(y = acum_pct / 100 * max_val, group = 1),
              color = "#E07B39", linewidth = 1.0) +
    geom_point(aes(y = acum_pct / 100 * max_val), color = "#E07B39", size = 1.9) +
    geom_text(aes(y = acum_pct / 100 * max_val, label = paste0(round(acum_pct), "%")),
              vjust = -0.9, size = 2.6, color = "#E07B39", fontface = "bold") +
    geom_hline(yintercept = 0.80 * max_val, linetype = "dashed",
               color = "gray45", linewidth = 0.4) +
    annotate("text", x = Inf, y = 0.80 * max_val, label = "80%",
             hjust = 1.1, vjust = -0.4, size = 3, color = "gray45", fontface = "italic") +
    labs(
      title = paste0("Año ", year_val),
      subtitle = paste0(n_vital, " rubros concentran el 80% de las exportaciones"),
      x = NULL, y = "Exportaciones (USD const. 2015, millones)"
    ) +
    scale_y_continuous(labels = label_comma(), expand = expansion(mult = c(0, 0.16))) +
    theme_minimal(base_size = 11) +
    theme(
      plot.title = element_text(size = 13, face = "bold", color = "#2C3E50"),
      plot.subtitle = element_text(size = 9.5, color = "#2E7D5B"),
      axis.text.x = element_text(angle = 40, hjust = 1, size = 9),
      axis.title.y = element_text(size = 9.5, color = "gray30"),
      panel.grid.major.x = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major.y = element_line(color = "gray92", linewidth = 0.3)
    )
}

p2006 <- plot_pareto(d2006, 2006)
p2023 <- plot_pareto(d2023, 2023)

pareto <- p2006 + p2023 +
  plot_layout(axes = "collect") +
  plot_annotation(
    title = "¿Qué rubros concentran las exportaciones agropecuarias bolivianas?",
    subtitle = "Rubros ordenados de mayor a menor valor exportado (USD constantes de 2015). En verde, los que acumulan el 80% de las exportaciones agropecuarias; en gris, el resto. El complejo soya domina las ventas externas, una concentración mucho mayor que la de la producción.",
    caption = "Fuente: FAOSTAT Trade (Crops & livestock products), valor de exportación. Deflactado a USD const. 2015 (WDI NY.GDP.DEFL.ZS). Rubros agrupados por cadena; 'Otros' = total agropecuario menos rubros mostrados.",
    theme = theme(
      plot.title = element_text(size = 14.5, face = "bold", color = "#2C3E50"),
      plot.subtitle = element_text(size = 10, color = "gray40"),
      plot.caption = element_text(size = 8.5, hjust = 0, color = "gray50", margin = margin(t = 12))
    )
  )

# ============================================================================
# Guardar
# ============================================================================

for (sub in c("png", "svg", "pdf")) dir.create(here("05_outputs", "figures", sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs", "figures", "png", "fig_pareto_export_2006v2023.png"), pareto, width = 14, height = 6.4, dpi = 600)
ggsave(here("05_outputs", "figures", "svg", "fig_pareto_export_2006v2023.svg"), pareto, width = 14, height = 6.4)
ggsave(here("05_outputs", "figures", "pdf", "fig_pareto_export_2006v2023.pdf"), pareto, width = 14, height = 6.4)

# ============================================================================
# Cifras para el párrafo (Word)
# ============================================================================

cat("\n✅ FIGURA GENERADA (exportaciones por VALOR, 2006 vs 2023)\n")
cat("  • 05_outputs/figures/png/fig_pareto_export_2006v2023.png\n")
cat("  • 05_outputs/figures/svg/fig_pareto_export_2006v2023.svg\n")
cat("  • 05_outputs/figures/pdf/fig_pareto_export_2006v2023.pdf\n\n")

resumen <- function(d, yr) {
  vf <- d %>% filter(vital)
  hhi <- sum(d$pct^2)
  soya <- d %>% filter(grupo == "Soya y derivados")
  cat(paste0("── AÑO ", yr, " (exportaciones) ──\n"))
  cat(paste0("  Rubros que suman 80%: ", nrow(vf), " (", paste(as.character(vf$grupo), collapse=", "), ")\n"))
  cat(paste0("  Soya y derivados: ", round(soya$pct,1), "% (USD ", round(soya$valor_mn), " mn const. 2015)\n"))
  cat(paste0("  Total agropecuario exportado: USD ", format(round(d$total[1]), big.mark=","), " mn | HHI: ", round(hhi), "\n\n"))
}
resumen(d2006, 2006)
resumen(d2023, 2023)
