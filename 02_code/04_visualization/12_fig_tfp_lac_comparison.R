# 12_fig_tfp_lac_comparison.R — TFP agropecuaria: Bolivia resaltada vs LAC
# Diseño: highlight + gray-out (estándar 07_FIGURAS §237) + direct labeling al final.
#   Bolivia en color fuerte y grueso; resto de países en gris con alpha bajo.
#   Labels de país al final de cada línea (sin leyenda lateral).
# Fuente: USDA-ERS International Agricultural Productivity. Índice rebasado 2000=100.
# Salida: fig07_tfp_latam_comparison.{png,svg,pdf} (raíz de 05_outputs/figures, 600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))

library(tidyverse)
library(ggplot2)
library(ggrepel)
library(scales)
library(here)

tfp <- readRDS(here("01_data", "processed", "usda_tfp_latam.rds"))

# ── Paleta (07_FIGURAS §6) ──────────────────────────────────────────────────
COL_BOLIVIA <- "#C00000"   # rojo terracota — protagonista
COL_OTROS   <- "#A6A6A6"   # gris medio — contexto
COL_ANDINOS <- "#7F7F7F"   # gris un poco más oscuro para pares andinos (Perú/Colombia/Ecuador)

# Pares andinos que la narrativa del capítulo cita explícitamente
andinos <- c("Peru", "Colombia", "Ecuador")

# ── Datos: ventana 2000-2023, rebasado a 2000 = 100 ─────────────────────────
d <- tfp %>%
  filter(Year >= 2000, !is.na(TFP_Index)) %>%
  group_by(country) %>%
  arrange(Year) %>%
  mutate(base = TFP_Index[Year == 2000][1],
         idx  = 100 * TFP_Index / base) %>%
  ungroup() %>%
  mutate(
    es_bolivia = country == "Bolivia",
    grupo = case_when(
      country == "Bolivia" ~ "Bolivia",
      country %in% andinos ~ "Andinos",
      TRUE ~ "Otros LAC"
    ),
    pais_es = recode(country,
      "Brazil" = "Brasil", "Peru" = "Perú", "Mexico" = "México")
  )

# Etiquetas español
d$pais_es <- ifelse(is.na(d$pais_es), d$country, d$pais_es)

# Puntos finales para direct labeling
fin <- d %>% group_by(country) %>% filter(Year == max(Year)) %>% ungroup() %>%
  mutate(
    lab_color = case_when(es_bolivia ~ COL_BOLIVIA, grupo == "Andinos" ~ COL_ANDINOS, TRUE ~ COL_OTROS),
    lab_size  = case_when(es_bolivia ~ 4.4, grupo == "Andinos" ~ 3.3, TRUE ~ 3.0),
    lab_face  = case_when(es_bolivia ~ "bold", grupo == "Andinos" ~ "bold", TRUE ~ "plain")
  )

ultimo_anio <- max(d$Year)

# ── Plot ────────────────────────────────────────────────────────────────────
p <- ggplot(d, aes(x = Year, y = idx, group = country)) +
  # Línea de referencia base
  geom_hline(yintercept = 100, linetype = "dotted", color = "gray70", linewidth = 0.4) +

  # Resto de países (gris, alpha bajo, finos) — se dibujan PRIMERO (debajo)
  geom_line(data = filter(d, grupo == "Otros LAC"),
            color = COL_OTROS, linewidth = 0.55, alpha = 0.40) +
  # Pares andinos: gris un poco más presente
  geom_line(data = filter(d, grupo == "Andinos"),
            color = COL_ANDINOS, linewidth = 0.7, alpha = 0.65) +

  # Bolivia: protagonista, encima de todo
  geom_line(data = filter(d, es_bolivia),
            color = COL_BOLIVIA, linewidth = 1.7) +
  geom_point(data = filter(fin, es_bolivia),
             color = COL_BOLIVIA, size = 2.6) +

  # ── Direct labeling al final: UNA sola capa para que todos los labels se repelan ──
  geom_text_repel(
    data = fin,
    aes(label = pais_es, color = lab_color, size = lab_size, fontface = lab_face),
    hjust = 0, direction = "y", nudge_x = 0.6,
    segment.size = 0.2, segment.alpha = 0.5,
    xlim = c(ultimo_anio + 0.6, NA), max.overlaps = Inf,
    box.padding = 0.22, point.padding = 0.1, min.segment.length = 0
  ) +
  scale_color_identity() +
  scale_size_identity() +

  scale_x_continuous(
    breaks = seq(2000, 2020, 5),
    limits = c(2000, ultimo_anio + 4),
    expand = expansion(mult = c(0.01, 0))
  ) +
  scale_y_continuous(labels = label_number(accuracy = 1)) +
  labs(
    title = "La productividad agropecuaria de Bolivia crece por debajo de la región",
    subtitle = paste0("Índice de productividad total de los factores (TFP), 2000 = 100, ventana 2000-", ultimo_anio,
                      ".\nBolivia (rojo) frente a comparadores de América Latina (gris); pares andinos resaltados en gris oscuro."),
    x = NULL,
    y = "Índice TFP (2000 = 100)",
    caption = "Fuente: USDA-ERS International Agricultural Productivity (2024). Índice rebasado a 2000 = 100. Pares andinos: Perú, Colombia, Ecuador."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(size = 15, face = "bold", color = "#2C3E50"),
    plot.subtitle = element_text(size = 10.5, color = "gray40", margin = margin(b = 10)),
    plot.caption = element_text(size = 8.5, hjust = 0, color = "gray50", margin = margin(t = 12)),
    axis.title.y = element_text(size = 10, color = "gray30"),
    axis.text = element_text(color = "gray30"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 14, 12, 12)
  ) +
  coord_cartesian(clip = "off")

# ── Guardar (raíz para fig() del qmd + subcarpetas vectoriales) ─────────────
ggsave(here("05_outputs", "figures", "fig07_tfp_latam_comparison.png"), p,
       width = 10, height = 6.2, dpi = 600, bg = "white")
for (sub in c("svg", "pdf")) dir.create(here("05_outputs", "figures", sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs", "figures", "svg", "fig07_tfp_latam_comparison.svg"), p, width = 10, height = 6.2, bg = "white")
ggsave(here("05_outputs", "figures", "pdf", "fig07_tfp_latam_comparison.pdf"), p, width = 10, height = 6.2, bg = "white")

# ── Cifras de apoyo ─────────────────────────────────────────────────────────
cat("\n✅ FIGURA TFP REGENERADA: 05_outputs/figures/fig07_tfp_latam_comparison.png\n\n")
cat("Índice TFP (2000=100) en", ultimo_anio, "por país:\n")
print(fin %>% select(pais_es, idx) %>% arrange(desc(idx)) %>% mutate(idx = round(idx, 1)) %>% as.data.frame(), row.names = FALSE)
cat("\nCrecimiento acumulado 2000-", ultimo_anio, " (puntos sobre base 100):\n", sep="")
bol <- fin %>% filter(es_bolivia) %>% pull(idx)
cat("  Bolivia:", round(bol-100,1), "% | mediana resto LAC:",
    round(median((fin %>% filter(!es_bolivia) %>% pull(idx)))-100,1), "%\n")
