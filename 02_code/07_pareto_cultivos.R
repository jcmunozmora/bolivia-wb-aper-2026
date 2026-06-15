# 07_pareto_cultivos.R — Pareto del VALOR de producción agropecuaria Bolivia 2006 vs 2023
# Diseño: Pareto clásico por VALOR (USD). Barras descendentes (mayor primero).
#   Se resaltan los rubros que acumulan el 80% del valor ("vital few"); resto en gris.
#   Línea = % acumulado, con referencia 80%.
# Fuente: IDB AgriMonitor — "Value of Production (at farm gate)", USD millones.
#   Ventana 2006-2023 (cobertura de AgriMonitor). Incluye agricultura Y ganadería.
# Salida: fig_pareto_valor_2006v2023.{png,svg,pdf} (600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))

library(tidyverse)
library(ggplot2)
library(patchwork)
library(scales)
library(here)

idb <- readRDS(here("01_data", "processed", "idb_agrimonitor_bolivia_full.rds"))

# Deflactor US GDP (WDI NY.GDP.DEFL.ZS, USA) para pasar USD nominales → USD constantes 2015
defl <- readRDS(here("01_data", "processed", "wdi_us_gdp_deflator.rds"))
defl_2015 <- defl$us_gdp_deflator[defl$year == 2015]
defl <- defl %>% mutate(factor_2015 = defl_2015 / us_gdp_deflator) %>% select(year, factor_2015)

# Nombres en español
nombre_es <- c(
  "Soybeans" = "Soya", "Beef and Veal" = "Carne de res", "Poultry Meat" = "Carne de pollo",
  "Potatoes" = "Papa", "Pigmeat" = "Carne de cerdo", "Sorghum" = "Sorgo",
  "Maize" = "Maíz", "Milk" = "Leche", "Refined Sugar" = "Azúcar",
  "Eggs" = "Huevos", "Bananas" = "Banano", "Rice" = "Arroz",
  "Beans" = "Frijol", "Wheat" = "Trigo", "Plantains" = "Plátano", "Quinoa" = "Quinua"
)

# ============================================================================
# 1. Preparar: valor de producción por rubro, ordenado descendente
# ============================================================================

prep_year <- function(data, year_val) {
  data %>%
    filter(
      description == "Value of Production (at farm gate)",
      !commoditie %in% c("Non MPS Commodities", "Group or Not Commodities"),
      year == year_val,
      !is.na(valueusd), valueusd > 0
    ) %>%
    left_join(defl, by = "year") %>%
    mutate(valueusd_const = valueusd * factor_2015) %>%  # USD constantes 2015
    group_by(commoditie) %>%
    summarise(valor_usd_mn = sum(valueusd_const, na.rm = TRUE), .groups = "drop") %>%
    arrange(desc(valor_usd_mn)) %>%
    mutate(
      etiqueta = recode(commoditie, !!!nombre_es),
      total = sum(valor_usd_mn),
      pct = 100 * valor_usd_mn / total,
      acum_pct = cumsum(pct),
      vital = lag(acum_pct, default = 0) < 80,
      orden = row_number(),
      year = year_val
    )
}

d2006 <- prep_year(idb, 2006)
d2023 <- prep_year(idb, 2023)

# ============================================================================
# 2. Función de panel Pareto
# ============================================================================

plot_pareto <- function(d, year_val) {
  n_vital <- sum(d$vital)
  d <- d %>% mutate(
    etiqueta = factor(etiqueta, levels = etiqueta[order(orden)]),
    fill_col = if_else(vital, "#1F6F8B", "gray80")
  )
  max_val <- max(d$valor_usd_mn)

  ggplot(d, aes(x = etiqueta, y = valor_usd_mn)) +
    geom_col(aes(fill = fill_col), width = 0.74) +
    scale_fill_identity() +
    # Valor sobre las barras vital few (USD mn)
    geom_text(
      data = ~ filter(.x, vital),
      aes(label = paste0("$", label_comma(accuracy = 1)(round(valor_usd_mn)))),
      vjust = -0.6, size = 2.8, color = "gray25"
    ) +
    # Línea acumulada
    geom_line(aes(y = acum_pct / 100 * max_val, group = 1),
              color = "#E07B39", linewidth = 1.0) +
    geom_point(aes(y = acum_pct / 100 * max_val), color = "#E07B39", size = 1.9) +
    geom_text(
      data = ~ filter(.x, vital),
      aes(y = acum_pct / 100 * max_val, label = paste0(round(acum_pct), "%")),
      vjust = -0.9, size = 2.7, color = "#E07B39", fontface = "bold"
    ) +
    geom_hline(yintercept = 0.80 * max_val, linetype = "dashed",
               color = "gray45", linewidth = 0.4) +
    annotate("text", x = Inf, y = 0.80 * max_val,
             label = "80%", hjust = 1.1, vjust = -0.4,
             size = 3, color = "gray45", fontface = "italic") +
    labs(
      title = paste0("Año ", year_val),
      subtitle = paste0(n_vital, " rubros concentran el 80% del valor de producción"),
      x = NULL, y = "Valor de producción (USD const. 2015, millones)"
    ) +
    scale_y_continuous(labels = label_comma(), expand = expansion(mult = c(0, 0.15))) +
    theme_minimal(base_size = 11) +
    theme(
      plot.title = element_text(size = 13, face = "bold", color = "#2C3E50"),
      plot.subtitle = element_text(size = 9.5, color = "#1F6F8B"),
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
    title = "¿Qué rubros concentran el VALOR de la producción agropecuaria boliviana?",
    subtitle = "Rubros ordenados de mayor a menor valor de producción (USD constantes de 2015). En azul, los que acumulan el 80% del valor; en gris, el resto. La línea naranja marca el acumulado. A diferencia del volumen (donde domina la caña), por valor la soya, la carne de res y el pollo lideran.",
    caption = "Fuente: IDB AgriMonitor - Value of Production at farm gate. Deflactado a USD constantes de 2015 con el deflactor del PIB de EE.UU. (WDI NY.GDP.DEFL.ZS). Incluye agricultura y ganadería.",
    theme = theme(
      plot.title = element_text(size = 14.5, face = "bold", color = "#2C3E50"),
      plot.subtitle = element_text(size = 10, color = "gray40"),
      plot.caption = element_text(size = 8.5, hjust = 0, color = "gray50", margin = margin(t = 12))
    )
  )

# ============================================================================
# 3. Guardar
# ============================================================================

for (sub in c("png", "svg", "pdf")) dir.create(here("05_outputs", "figures", sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs", "figures", "png", "fig_pareto_valor_2006v2023.png"), pareto, width = 14, height = 6.4, dpi = 600)
ggsave(here("05_outputs", "figures", "svg", "fig_pareto_valor_2006v2023.svg"), pareto, width = 14, height = 6.4)
ggsave(here("05_outputs", "figures", "pdf", "fig_pareto_valor_2006v2023.pdf"), pareto, width = 14, height = 6.4)

# Limpiar versión obsoleta por volumen
for (sub in c("png","svg","pdf")) {
  old <- here("05_outputs","figures",sub, paste0("fig_pareto_2000v2020.", sub))
  if (file.exists(old)) file.remove(old)
}

# ============================================================================
# 4. Cifras para el párrafo (Word)
# ============================================================================

cat("\n✅ FIGURA GENERADA (por VALOR, 2006 vs 2023)\n")
cat("  • 05_outputs/figures/png/fig_pareto_valor_2006v2023.png\n")
cat("  • 05_outputs/figures/svg/fig_pareto_valor_2006v2023.svg\n")
cat("  • 05_outputs/figures/pdf/fig_pareto_valor_2006v2023.pdf\n\n")

resumen <- function(d, yr) {
  vf <- d %>% filter(vital)
  hhi <- sum(d$pct^2)
  cat(paste0("── AÑO ", yr, " (valor de producción) ──\n"))
  cat(paste0("  Rubros que suman 80%: ", nrow(vf), " (", paste(vf$etiqueta, collapse=", "), ")\n"))
  cat(paste0("  #1: ", vf$etiqueta[1], " = ", round(vf$pct[1],1), "% del valor (USD ", round(vf$valor_usd_mn[1]), " mn)\n"))
  cat(paste0("  Valor total rastreado: USD ", format(round(d$total[1]), big.mark=","), " mn | rubros: ", nrow(d), " | HHI: ", round(hhi), "\n\n"))
}
resumen(d2006, 2006)
resumen(d2023, 2023)
