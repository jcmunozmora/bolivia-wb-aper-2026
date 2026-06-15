# 32_fig_panel_fe_resultados.R — Panel FE: gasto agropecuario → productividad y pobreza
# -----------------------------------------------------------------------------
# Coefficient plot (forest) de DOS paneles que cuenta una sola historia:
#   (a) el coeficiente de ln(gasto) sobre la productividad de la tierra cruza 0
#       en todas las especificaciones → sin asociación;
#   (b) el coeficiente de ln(gasto) sobre la pobreza departamental (INE) es
#       negativo → más gasto se asocia con menos pobreza.
# Escalas distintas (elasticidad vs puntos porcentuales) → facet con scales="free_x".
# Estándar: .agent/07_FIGURAS.md (finding-first title, paleta WB, highlight/gray-out).
#
# Fuente: panel_fe_productivity_results.rds + panel_fe_poverty_results.rds (ADR-0018).
# Salida: 05_outputs/figures/fig41_panel_fe_gasto_resultados.{png,svg,pdf} (600 DPI)
# =============================================================================

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))
suppressPackageStartupMessages({
  library(data.table)
  library(ggplot2)
  library(here)
})
source(here("02_code", "04_visualization", "00_wb_theme.R"))

PA <- "(a) Productividad de la tierra — elasticidad"
PB <- "(b) Pobreza departamental — puntos porcentuales"

# ── Datos de coeficientes (de los RDS del panel FE, ADR-0018) ────────────────
pr <- as.data.table(readRDS(here("01_data/processed/panel_fe_productivity_results.rds"))$coef)
po <- as.data.table(readRDS(here("01_data/processed/panel_fe_poverty_results.rds"))$coef)

# Solo el gasto MEFP (dato oficial más reciente, 2016-2024) — el nulo principal.
prod <- pr[term == "ln_gasto_mefp" & model %like% "M1|M6"]
prod[, lab := fcase(
  model %like% "M1", "Producción por hectárea",
  model %like% "M6", "Rendimiento de cereales")]
prod[, panel := PA]

pov <- po[term == "ln_gasto_mefp" & model %like% "P2|P3"]
pov[, lab := fcase(
  model %like% "P2", "Pobreza moderada",
  model %like% "P3", "Pobreza extrema")]
pov[, panel := PB]

d <- rbind(prod[, .(panel, lab, coef, ci_lo, ci_hi, p)],
           pov[,  .(panel, lab, coef, ci_lo, ci_hi, p)])
d[, panel := factor(panel, levels = c(PA, PB))]
setorder(d, panel, coef)
d[, lab := factor(lab, levels = unique(lab))]   # ordenar por coef dentro de panel

# ── Plot ──────────────────────────────────────────────────────────────────────
p <- ggplot(d, aes(x = coef, y = lab)) +
  geom_vline(xintercept = 0, color = WB_RED, linewidth = 0.6, linetype = "22") +
  geom_segment(aes(x = ci_lo, xend = ci_hi, y = lab, yend = lab),
               color = WB_NAVY, linewidth = 0.9) +
  geom_point(color = WB_NAVY, size = 2.8) +
  facet_wrap(~panel, scales = "free", ncol = 2) +
  labs(
    title    = "El gasto agropecuario\nno se asocia con la productividad ni con la pobreza departamental",
    subtitle = "Coeficiente de ln(gasto agropecuario municipal ejecutado) en panel con efectos fijos departamento–año, Bolivia",
    x = "Coeficiente (barra = intervalo de confianza al 95%; la línea roja marca el cero)", y = NULL,
    caption = paste(
      "Fuente: MEFP (gasto agropecuario municipal ejecutado), INE (producción, superficie, pobreza por departamento), CHIRPS (lluvia); cálculo propio (ADR-0018).",
      "Nota: productividad de la tierra en elasticidad (escala log); pobreza en puntos porcentuales por unidad de ln(gasto). Todas las bandas cruzan el cero:",
      "ninguna asociación es estadísticamente distinta de cero. Identificación asociativa, no causal; errores cluster-robustos por departamento (9 clusters).",
      "El detalle por especificación y la serie Jubileo (donde el signo no es robusto) se reportan en el Apéndice E.", sep = "\n")
  ) +
  theme_wb() +
  theme(plot.title = element_text(size = 12.5),
        panel.spacing = unit(1.1, "lines"))

# ── Guardar (600 DPI; png + svg + pdf) ───────────────────────────────────────
fig_dir <- here("05_outputs", "figures")
base    <- file.path(fig_dir, "fig41_panel_fe_gasto_resultados")
ggsave(paste0(base, ".png"), p, width = 11, height = 5.2, dpi = 600, bg = "white")
# Vector (SVG/PDF) opcional: solo si los backends están instalados.
ok <- c(svg = requireNamespace("svglite", quietly = TRUE), pdf = TRUE)
if (ok["svg"]) ggsave(paste0(base, ".svg"), p, width = 11, height = 5.2, bg = "white")
try(ggsave(paste0(base, ".pdf"), p, width = 11, height = 5.2, bg = "white"), silent = TRUE)
cat(sprintf("✓ Guardado: fig41_panel_fe_gasto_resultados.png%s + .pdf\n",
            if (ok["svg"]) " + .svg" else " (svg omitido: falta svglite)"))
