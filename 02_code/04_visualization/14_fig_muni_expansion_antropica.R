# 14_fig_muni_expansion_antropica.R — Top 15 municipios por expansión de área antrópica 1985-2024
# Diseño: barras horizontales ordenadas; color por departamento (Santa Cruz resaltado).
#   Muestra la concentración territorial de la frontera agropecuaria (F08).
# Fuente: MapBiomas Bolivia (mapbiomas_municipal_cambio).
# Salida: fig_muni_top15_expansion.{png,svg,pdf} (raíz 05_outputs/figures, 600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))

library(tidyverse)
library(ggplot2)
library(scales)
library(here)

# ── Paleta ──
COL_SC   <- "#843C0C"   # ocre/marrón — frontera (Santa Cruz)
COL_OTRO <- "#A6A6A6"   # gris — otros departamentos

m <- readRDS(here("01_data", "processed", "mapbiomas_municipal_cambio.rds"))

# Total nacional de expansión antrópica (cambios positivos) para contexto
total_nac <- sum(m$cambio_antrop_ha[m$cambio_antrop_ha > 0], na.rm = TRUE)

top <- m %>%
  arrange(desc(cambio_antrop_ha)) %>%
  slice_head(n = 15) %>%
  mutate(
    expansion_kha = cambio_antrop_ha / 1000,                 # miles de ha
    es_sc = dept == "Santa Cruz",
    fill_col = if_else(es_sc, COL_SC, COL_OTRO),
    etiqueta = paste0(municipio, if_else(es_sc, "", paste0(" (", dept, ")"))),
    etiqueta = fct_reorder(etiqueta, cambio_antrop_ha)
  )

share_top15 <- 100 * sum(top$cambio_antrop_ha) / total_nac
n_sc <- sum(top$es_sc)

p <- ggplot(top, aes(x = expansion_kha, y = etiqueta)) +
  geom_col(aes(fill = fill_col), width = 0.72) +
  scale_fill_identity() +
  # Valor al final de cada barra (miles de ha)
  geom_text(aes(label = label_comma(accuracy = 1)(expansion_kha)),
            hjust = -0.15, size = 3.2, color = "gray25") +
  # % antrópico 2024 como contexto, dentro de la barra
  geom_text(aes(label = paste0(round(antropico_share_2024), "% hoy")),
            hjust = 1.1, size = 2.7, color = "white", fontface = "bold") +
  scale_x_continuous(
    labels = label_comma(),
    expand = expansion(mult = c(0, 0.12)),
    name = "Expansión de área antrópica 1985–2024 (miles de hectáreas)"
  ) +
  labs(
    title = "La expansión de la frontera agropecuaria se concentra en Santa Cruz",
    subtitle = paste0("Los 15 municipios con mayor expansión absoluta de área antrópica, 1985–2024.\n",
                      n_sc, " de los 15 están en Santa Cruz (en ocre); juntos concentran el ",
                      round(share_top15), "% de toda la expansión antrópica nacional."),
    y = NULL,
    caption = paste0("Fuente: MapBiomas Bolivia (Colección 3). 'Expansión antrópica' = aumento del área bajo uso humano. ",
                     "La cifra dentro de la barra indica el % del territorio municipal bajo uso antrópico en 2024.")
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(size = 14.5, face = "bold", color = "#2C3E50"),
    plot.subtitle = element_text(size = 10.5, color = "gray40", margin = margin(b = 10)),
    plot.caption = element_text(size = 8, hjust = 0, color = "gray50", margin = margin(t = 12)),
    axis.title.x = element_text(size = 10, color = "gray30", margin = margin(t = 6)),
    axis.text.y = element_text(size = 10, color = "gray20"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 16, 12, 12)
  )

ggsave(here("05_outputs", "figures", "fig_muni_top15_expansion.png"), p,
       width = 10.5, height = 6.6, dpi = 600, bg = "white")
for (sub in c("svg", "pdf")) dir.create(here("05_outputs", "figures", sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs", "figures", "svg", "fig_muni_top15_expansion.svg"), p, width = 10.5, height = 6.6, bg = "white")
ggsave(here("05_outputs", "figures", "pdf", "fig_muni_top15_expansion.pdf"), p, width = 10.5, height = 6.6, bg = "white")

cat("\n✅ FIGURA GENERADA: 05_outputs/figures/fig_muni_top15_expansion.png\n\n")
cat("Top 15 municipios por expansión antrópica 1985-2024:\n")
print(top %>% select(municipio, dept, expansion_miles_ha = expansion_kha, pct_antropico_2024 = antropico_share_2024) %>%
        mutate(expansion_miles_ha = round(expansion_miles_ha), pct_antropico_2024 = round(pct_antropico_2024,1)) %>% as.data.frame(), row.names = FALSE)
cat("\nSanta Cruz en top15:", n_sc, "de 15 | Top15 = ", round(share_top15), "% de la expansión nacional\n")
