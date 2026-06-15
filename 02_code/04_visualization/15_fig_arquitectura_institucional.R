# 15_fig_arquitectura_institucional.R — Diagrama de relacionamiento institucional del sector
# Diseño: organigrama de relaciones (arriba→abajo) en ggplot2.
#   Cada caja: acrónimo (bold) + nombre completo (pequeño) + función.
#   Rectoría (MDRyT) arriba; adscritas + brazo financiero en el medio; subnacionales abajo.
#   Tuiciones cruzadas (MMAyA, ABT, FDI) al costado = fragmentación institucional (§3.1).
# Fuente conceptual: 04_report/03_budget_institutions.qmd §3.1-3.3.
# Salida: fig_arquitectura_institucional.{png,svg,pdf} (raíz 05_outputs/figures, 600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))

library(tidyverse)
library(ggplot2)
library(here)

# ── Paleta (07_FIGURAS §6) ──
C_FISCAL  <- "#D9E1F2"; C_FISCAL_T <- "#1F4E79"
C_RECTOR  <- "#1F4E79"; C_RECTOR_T <- "white"
C_ADSCR   <- "#4472C4"; C_ADSCR_T  <- "white"
C_FIN     <- "#BF8F00"; C_FIN_T    <- "white"
C_CRUCE   <- "#EADBC2"; C_CRUCE_T  <- "#843C0C"
C_SUBNAC  <- "#548235"; C_SUBNAC_T <- "white"

# ── Cajas: x,y = centro; nombre = nombre completo (pequeño); sub = función ──
boxes <- tribble(
  ~id, ~x, ~y, ~w, ~h, ~fill, ~tcol, ~wrapn, ~titulo, ~nombre, ~sub,
  "mefp",   6.0, 6.05, 5.6, 0.95, C_FISCAL, C_FISCAL_T, 60, "MEFP · VIPFE",
      "Ministerio de Economía y Finanzas Públicas · Viceministerio de Inversión Pública y Financiamiento Externo",
      "Marco presupuestario — IDH, coparticipación",
  "mdryt",  6.0, 4.78, 5.2, 1.12, C_RECTOR, C_RECTOR_T, 48, "MDRyT",
      "Ministerio de Desarrollo Rural y Tierras", "Ente rector del sector agropecuario",
  # adscritas
  "iniaf",  1.45, 2.85, 2.30, 1.62, C_ADSCR, C_ADSCR_T, 22, "INIAF",
      "Instituto Nacional de Innovación Agropecuaria y Forestal", "I+D y semillas",
  "senasag",3.95, 2.85, 2.30, 1.62, C_ADSCR, C_ADSCR_T, 22, "SENASAG",
      "Servicio Nacional de Sanidad Agropecuaria e Inocuidad Alimentaria", "Sanidad e inocuidad",
  "inra",   6.45, 2.85, 2.30, 1.62, C_ADSCR, C_ADSCR_T, 22, "INRA",
      "Instituto Nacional de Reforma Agraria", "Tierras y saneamiento",
  "emapa",  8.95, 2.85, 2.30, 1.62, C_ADSCR, C_ADSCR_T, 22, "EMAPA",
      "Empresa de Apoyo a la Producción de Alimentos", "Compras · precio sostén",
  "bdp",   11.45, 2.85, 2.30, 1.62, C_FIN,   C_FIN_T,   22, "BDP-SAM",
      "Banco de Desarrollo Productivo – S.A.M.", "Crédito dirigido (Ley 393)",
  # tuiciones cruzadas (derecha)
  "mmaya", 14.05, 6.40, 4.5, 0.92, C_CRUCE, C_CRUCE_T, 40, "MMAyA",
      "Ministerio de Medio Ambiente y Agua", "Riego (Mi Agua / MIAGUA)",
  "abt",   14.05, 5.30, 4.5, 0.92, C_CRUCE, C_CRUCE_T, 40, "ABT",
      "Autoridad de Fiscalización y Control Social de Bosques y Tierra", "Control de desmonte",
  "fdi",   14.05, 4.20, 4.5, 0.92, C_CRUCE, C_CRUCE_T, 40, "FDI",
      "Fondo de Desarrollo Indígena", "Transferencias a comunidades",
  # subnacionales
  "gob",    4.15, 0.80, 4.1, 1.06, C_SUBNAC, C_SUBNAC_T, 40, "9 Gobernaciones",
      "Gobiernos Autónomos Departamentales", "IDH y regalías — infraestructura, caminos",
  "mun",    8.85, 0.80, 4.1, 1.06, C_SUBNAC, C_SUBNAC_T, 40, "339 Municipios",
      "Gobiernos Autónomos Municipales", "Coparticipación, IDH — riego, asistencia"
) %>%
  mutate(
    xmin = x - w/2, xmax = x + w/2, ymin = y - h/2, ymax = y + h/2,
    nombre_wrap = map2_chr(nombre, wrapn, ~ str_wrap(.x, width = .y)),
    titsize = if_else(id == "mdryt", 4.4, if_else(id == "mefp", 3.7, 3.4))
  )

bx <- function(id) boxes[boxes$id == id, ]

# ── Aristas sólidas (tuición / dependencia directa) ──
bus_y <- 3.82
seg_solid <- tribble(
  ~x, ~y, ~xend, ~yend,
  6.0, bx("mefp")$ymin, 6.0, bx("mdryt")$ymax,
  6.0, bx("mdryt")$ymin, 6.0, bus_y
)
adscr_x <- c(1.45, 3.95, 6.45, 8.95, 11.45)
adscr_top <- 2.85 + 1.62/2
bus_line <- tibble(x = min(adscr_x), y = bus_y, xend = max(adscr_x), yend = bus_y)
drops <- tibble(x = adscr_x, y = bus_y, xend = adscr_x, yend = adscr_top)

# ── Aristas punteadas (competencia cruzada / autonomía) ──
seg_dash <- tribble(
  ~x, ~y, ~xend, ~yend,
  bx("mdryt")$xmax, 4.90, 11.80, 5.30
)
left_x <- 0.25; sub_bus_y <- 1.85
sub_top <- 0.80 + 1.06/2
sub_bus <- tribble(
  ~x, ~y, ~xend, ~yend,
  bx("mdryt")$xmin, 4.78, left_x, 4.78,
  left_x, 4.78, left_x, sub_bus_y,
  left_x, sub_bus_y, 8.85, sub_bus_y,
  4.15, sub_bus_y, 4.15, sub_top,
  8.85, sub_bus_y, 8.85, sub_top
)

# ── Plot ──
p <- ggplot() +
  geom_segment(data = seg_solid, aes(x, y, xend = xend, yend = yend), color = "#5B6B7A", linewidth = 0.6) +
  geom_segment(data = bus_line, aes(x, y, xend = xend, yend = yend), color = "#5B6B7A", linewidth = 0.6) +
  geom_segment(data = drops, aes(x, y, xend = xend, yend = yend), color = "#5B6B7A", linewidth = 0.6,
               arrow = arrow(length = unit(0.10, "cm"), type = "closed")) +
  geom_segment(data = seg_dash, aes(x, y, xend = xend, yend = yend), color = "#843C0C", linewidth = 0.55, linetype = "21") +
  geom_segment(data = sub_bus, aes(x, y, xend = xend, yend = yend), color = "#3E6B2A", linewidth = 0.55, linetype = "21") +

  geom_rect(data = boxes, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fill),
            color = "white", linewidth = 0.4) +
  scale_fill_identity() +

  # acrónimo (arriba)
  geom_text(data = boxes, aes(x = x, y = ymax - 0.19, label = titulo, color = tcol, size = titsize),
            fontface = "bold", vjust = 1) +
  # nombre completo (pequeño, centro)
  geom_text(data = boxes, aes(x = x, y = (ymax + ymin)/2 - 0.02, label = nombre_wrap, color = tcol),
            size = 1.95, vjust = 0.5, lineheight = 0.88) +
  # función (abajo)
  geom_text(data = boxes, aes(x = x, y = ymin + 0.13, label = sub, color = tcol),
            size = 2.15, vjust = 0, fontface = "italic", alpha = 0.92) +
  scale_color_identity() +
  scale_size_identity() +

  annotate("text", x = 10.1, y = 5.75, label = "competencias\ncruzadas (fragmentación)",
           color = "#843C0C", size = 2.6, fontface = "italic", lineheight = 0.9) +
  annotate("text", x = left_x + 0.12, y = 2.15, label = "Ley 031/2010\nautonomía\nsubnacional",
           color = "#3E6B2A", size = 2.5, fontface = "italic", hjust = 0, vjust = 1, lineheight = 0.9) +

  annotate("segment", x = 0.6, xend = 1.4, y = 0.05, yend = 0.05, color = "#5B6B7A", linewidth = 0.6) +
  annotate("text", x = 1.55, y = 0.05, hjust = 0, size = 2.5, color = "gray30", label = "Tuición / dependencia directa") +
  annotate("segment", x = 6.0, xend = 6.8, y = 0.05, yend = 0.05, color = "#843C0C", linewidth = 0.55, linetype = "21") +
  annotate("text", x = 6.95, y = 0.05, hjust = 0, size = 2.5, color = "gray30", label = "Competencia cruzada / autonomía subnacional") +

  labs(
    title = "Arquitectura institucional del sector agropecuario boliviano",
    subtitle = "El MDRyT es el ente rector; bajo su tuición operan cuatro entidades técnicas y el brazo financiero (BDP-SAM).\nCompetencias clave —riego, bosques, transferencias indígenas— se ejecutan desde otros ministerios:\nuna fragmentación que obliga a reconstruir el gasto sectorial desde clasificadores funcionales.",
    caption = "Fuente: elaboración propia sobre la estructura institucional descrita en el Capítulo 3 (MDRyT y adscritas, Ley 031/2010, Ley 393/2014). Esquema simplificado."
  ) +
  coord_cartesian(xlim = c(-0.2, 16.4), ylim = c(-0.1, 7.0), clip = "off") +
  theme_void(base_size = 12) +
  theme(
    plot.title = element_text(size = 15, face = "bold", color = "#2C3E50", hjust = 0),
    plot.subtitle = element_text(size = 9.8, color = "gray40", hjust = 0, margin = margin(t = 4, b = 8)),
    plot.caption = element_text(size = 8, color = "gray50", hjust = 0, margin = margin(t = 8)),
    plot.margin = margin(14, 12, 10, 12)
  )

ggsave(here("05_outputs", "figures", "fig_arquitectura_institucional.png"), p,
       width = 12.0, height = 8.3, dpi = 600, bg = "white")
for (sub in c("svg", "pdf")) dir.create(here("05_outputs", "figures", sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs", "figures", "svg", "fig_arquitectura_institucional.svg"), p, width = 12.0, height = 8.3, bg = "white")
ggsave(here("05_outputs", "figures", "pdf", "fig_arquitectura_institucional.pdf"), p, width = 12.0, height = 8.3, bg = "white")

cat("\n✅ DIAGRAMA GENERADO (con nombres completos): 05_outputs/figures/fig_arquitectura_institucional.png\n")
