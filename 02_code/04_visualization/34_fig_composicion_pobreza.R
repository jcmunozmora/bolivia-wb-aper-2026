# 34_fig_composicion_pobreza.R — La composición importa: %bienes públicos ↔ pobreza
# -----------------------------------------------------------------------------
# Added-variable plot (relación parcial) del estimador within-FE: residualiza
# la pobreza departamental y la PARTICIPACIÓN de bienes públicos (servicios
# técnicos: I+D, extensión, sanidad) contra los FE depto+año, el gasto total y
# la lluvia; la pendiente del scatter = el coeficiente del panel FE (BT2).
# Muestra visualmente que, a igual gasto total, más participación de bienes
# públicos se asocia con MENOR pobreza.
# Estándar: .agent/07_FIGURAS.md (finding-first, paleta WB).
#
# Fuente: panel_fe_by_type_results.rds (panel; MEFP por grupo MAFAP + pobreza INE).
# Salida: 05_outputs/figures/fig43_composicion_pobreza.{png,pdf} (600 DPI)
# =============================================================================

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))
suppressPackageStartupMessages({ library(data.table); library(ggplot2); library(here) })
source(here("02_code", "04_visualization", "00_wb_theme.R"))

d <- as.data.table(readRDS(here("01_data/processed/panel_fe_by_type_results.rds"))$panel)
yv <- "pobreza_mod"  # pobreza moderada (canasta vigente); extrema da relación similar y más fuerte
d <- d[is.finite(get(yv)) & is.finite(sh_tecnicos) & is.finite(ln_total) & is.finite(precip_k)]

# Residualización (FWL): ambos contra FE depto+año + gasto total + lluvia
ry <- residuals(lm(reformulate(c("ln_total","precip_k","factor(dept_upper)","factor(year)"), yv), data = d))
rx <- residuals(lm(sh_tecnicos ~ ln_total + precip_k + factor(dept_upper) + factor(year), data = d))
pd <- data.table(rx_pp = rx * 100, ry = ry)   # x en puntos porcentuales de participación

sl <- coef(lm(ry ~ rx_pp, data = pd))[2]       # pendiente (pp pobreza por +1 pp de participación I+D)

p <- ggplot(pd, aes(x = rx_pp, y = ry)) +
  geom_hline(yintercept = 0, color = WB_GREY, linewidth = 0.3) +
  geom_vline(xintercept = 0, color = WB_GREY, linewidth = 0.3) +
  geom_point(color = WB_GREY, size = 2, alpha = 0.8) +
  geom_smooth(method = "lm", se = TRUE, color = WB_BLUE, fill = WB_BLUE,
              linewidth = 1, alpha = 0.15, formula = y ~ x) +
  annotate("text", x = max(pd$rx_pp) * 0.55, y = max(pd$ry) * 0.9,
           label = sprintf("Pendiente ≈ %.1f pp de pobreza\npor cada +10 pp de bienes públicos", sl * 10),
           color = WB_BLUE, size = 3.4, hjust = 0, fontface = "bold") +
  labs(
    title    = "A igual gasto total, los departamentos que asignan más a bienes públicos\nregistran menor pobreza, 2016–2024",
    subtitle = "Relación parcial (efectos fijos departamento+año): participación de servicios técnicos (I+D, extensión, sanidad) y pobreza moderada",
    x = "Participación de bienes públicos en el gasto agropecuario\n(desviación respecto al promedio del departamento y del año, puntos porcentuales)",
    y = "Incidencia de pobreza moderada\n(desviación, puntos porcentuales)",
    caption = paste(
      "Fuente: MEFP (gasto agropecuario municipal por grupo MAFAP), INE (pobreza por departamento); cálculo propio (ADR-0018).",
      "Nota: cada punto es un departamento-año residualizado contra efectos fijos de departamento y año, el gasto total y la precipitación;",
      "la pendiente equivale al coeficiente del panel FE (−19 pp por unidad de participación, p=0,085; la pobreza extrema da una relación similar más fuerte).",
      "Identificación asociativa, no causal; 9 clusters.", sep = "\n")
  ) +
  theme_wb() + theme(plot.title = element_text(size = 12.5))

base <- here("05_outputs", "figures", "fig43_composicion_pobreza")
ggsave(paste0(base, ".png"), p, width = 8.5, height = 5.6, dpi = 600, bg = "white")
try(ggsave(paste0(base, ".pdf"), p, width = 8.5, height = 5.6, bg = "white"), silent = TRUE)
cat(sprintf("✓ Guardado: fig43_composicion_pobreza.png + .pdf (pendiente=%.3f pp/pp)\n", sl))
