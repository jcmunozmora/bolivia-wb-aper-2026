# ============================================================================
# Script:        20_fig_ejecucion_entidad.R
# Propósito:     Figura Cap 4 — tasa de ejecución por entidad agropecuaria.
#                Lollipop horizontal de ejecución financiera + marcador de
#                ejecución física donde existe. Soporta la subsección
#                "Tasa de ejecución por entidad" y el hallazgo F07.
# Datos:         Valores por entidad = MDRyT RPC Final 2024 (MDRyT_RPC2024,
#                p.6 y p.11) + INIAF Memoria 2019 (INIAF_Memoria2019).
#                Referencia nacional fase BOOST = panel v12 (boost_tasa_ejecucion),
#                calculada en vivo.
# Outputs:       fig19_ejecucion_entidad  (SVG + PNG 600 DPI)
# Estándar:      07_FIGURAS §4 (ranking → barra horizontal), §6 (paleta APER),
#                §6.2 (sin semáforo para "buen/mal gasto" → highlight neutral),
#                §9 (caption finding-first), §12 (eje desde 0).
# Autor:         Juan Carlos Muñoz Mora (EAFIT) — sesión 21
# Fecha:         2026-06-14
# Ejecutar desde la raíz del repo: Rscript 02_code/04_visualization/20_fig_ejecucion_entidad.R
# ============================================================================

suppressPackageStartupMessages({ library(ggplot2); library(scales) })

OUT_DIR_SVG <- "05_outputs/figures/svg"
OUT_DIR_PNG <- "05_outputs/figures/png"
for (d in c(OUT_DIR_SVG, OUT_DIR_PNG)) dir.create(d, recursive = TRUE, showWarnings = FALSE)

# ---- Paleta APER 2026 (07_FIGURAS §6.1) ------------------------------------
AZUL_WB  <- "#1F4E79"   # primario_1 — ejecución financiera
DORADO   <- "#BF8F00"   # primario_4 — ejecución física (categórico, no semáforo)
GRIS_MED <- "#A6A6A6"   # secundario_2 — referencia / contexto
base_family <- if ("Inter" %in% systemfonts::system_fonts()$family) "Inter" else "sans"

# ---- Referencia nacional fase BOOST (panel v12, reproducible) ---------------
panel <- readRDS("01_data/processed/spending_panel_v12.rds")
boost_avg <- mean(panel$boost_tasa_ejecucion[
  panel$year >= 1996 & panel$year <= 2008], na.rm = TRUE)   # ~ 88.9

# ---- Datos por entidad (fuentes primarias RPC/Memoria, ver header) ----------
dat <- data.frame(
  entidad = c("SENASAG", "Administración Central", "INIAF", "INRA (saneamiento)",
              "MDRyT consolidado", "IPD-PACU", "PAR III (EMPODERAR)"),
  fin  = c(87, 87, 83.7, 77, 74, 58, 16),
  fis  = c(NA, NA, 82.7, 81, 54, NA, 60),
  anio = c(2024, 2024, 2019, 2024, 2024, 2024, 2024),
  stringsAsFactors = FALSE
)
dat$etiqueta <- paste0(dat$entidad, "  (", dat$anio, ")")
dat$etiqueta <- factor(dat$etiqueta, levels = dat$etiqueta[order(dat$fin)])
dat$fin_lab  <- sub("\\.", ",", dat$fin)
dat$lab_x    <- pmax(dat$fin, dat$fis, na.rm = TRUE)   # etiqueta a la derecha del marcador más externo

cap <- paste0(
  "Fuente: MDRyT, Rendición Pública de Cuentas Final 2024 (Tabla A p. 6; avance físico-financiero p. 11); INIAF, Memoria 2019;\n",
  "promedio nacional fase BOOST calculado sobre panel v12 (boost_tasa_ejecucion, 1996–2008).\n",
  "Nota: las cifras por entidad son auto-reportes institucionales de años distintos (INIAF 2019; resto 2024), no un extracto\n",
  "SIGEP harmonizado. EMAPA y BDP-SAM se excluyen (la métrica estándar no aplica). PAR III es el de menor ejecución (F07)."
)

# ---- Figura -----------------------------------------------------------------
p <- ggplot(dat, aes(y = etiqueta)) +
  geom_vline(xintercept = boost_avg, linetype = "22", color = GRIS_MED, linewidth = 0.5) +
  geom_segment(aes(x = 0, xend = fin, yend = etiqueta), color = AZUL_WB, linewidth = 0.7) +
  geom_segment(aes(x = fin, xend = fis, yend = etiqueta),
               color = GRIS_MED, linewidth = 0.4, na.rm = TRUE) +
  geom_point(aes(x = fis, shape = "Ejecución física"), color = DORADO, fill = "white",
             size = 2.6, stroke = 1.1, na.rm = TRUE) +
  geom_point(aes(x = fin, shape = "Ejecución financiera"), color = AZUL_WB, fill = AZUL_WB, size = 3.2) +
  geom_text(aes(x = lab_x, label = fin_lab), hjust = -0.5,
            size = 3, color = AZUL_WB, fontface = "bold", family = base_family) +
  scale_shape_manual(values = c("Ejecución financiera" = 19, "Ejecución física" = 23), name = NULL) +
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 25),
                     expand = expansion(mult = c(0, 0.08))) +
  labs(
    title    = "La ejecución del gasto agropecuario varía de 16% a 87%\nentre entidades del MDRyT, 2024",
    subtitle = paste0("Ejecución financiera (devengado / presupuesto vigente) y física, en %.\n",
                      "Línea discontinua: promedio nacional fase BOOST 1996–2008 (~", round(boost_avg), "%)"),
    x = "Ejecución (% del presupuesto vigente)", y = NULL, caption = cap
  ) +
  theme_minimal(base_family = base_family, base_size = 11) +
  theme(
    plot.title       = element_text(face = "bold", size = 12.5, lineheight = 1.12,
                                     color = "#002244", margin = margin(b = 3)),
    plot.subtitle    = element_text(size = 10, color = "#444444", margin = margin(b = 10)),
    plot.caption     = element_text(size = 7.2, color = "#666666", hjust = 0, lineheight = 1.25),
    plot.caption.position = "plot",
    plot.title.position   = "plot",
    axis.title.x     = element_text(size = 9, color = "#002244", margin = margin(t = 6)),
    axis.text.y      = element_text(size = 9.5, color = "#333333"),
    axis.text.x      = element_text(size = 8.5),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "#E5E5E5", linewidth = 0.3),
    legend.position  = "top",
    legend.justification = "right",
    legend.text      = element_text(size = 9),
    plot.margin      = margin(10, 14, 8, 10)
  )

png_dev <- if (requireNamespace("ragg", quietly = TRUE)) ragg::agg_png else "png"
ggsave(file.path(OUT_DIR_PNG, "fig19_ejecucion_entidad.png"), p,
       width = 7.6, height = 4.7, units = "in", dpi = 600, device = png_dev)
if (requireNamespace("svglite", quietly = TRUE)) {
  ggsave(file.path(OUT_DIR_SVG, "fig19_ejecucion_entidad.svg"), p,
         width = 7.6, height = 4.7, units = "in", device = "svg")
} else message("[warn] svglite ausente — SVG omitido; PNG 600 DPI generado.")
message(sprintf("OK fig19_ejecucion_entidad — boost_avg = %.1f%%", boost_avg))
