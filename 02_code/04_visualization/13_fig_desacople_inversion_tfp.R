# 13_fig_desacople_inversion_tfp.R — El desacople: inversión pública agropecuaria vs TFP
# Diseño: ambas series indexadas a 1990 = 100 en UN SOLO eje (sin doble eje engañoso).
#   La inversión se dispara (~×9) mientras la TFP apenas se mueve (+31%): la brecha
#   entre ambas líneas se sombrea como "wedge" del desacople. Direct labeling, sin leyenda.
# Fuente: inversión VIPFE (inversion_publica_sectorial_long, sector Agropecuario) + USDA-ERS TFP.
# Salida: fig12_inversion_vs_tfp.{png,svg,pdf} (raíz 05_outputs/figures, 600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))

library(tidyverse)
library(ggplot2)
library(scales)
library(here)

# ── Paleta (07_FIGURAS §6) ──
COL_INV <- "#C00000"   # inversión — rojo terracota
COL_TFP <- "#1F4E79"   # productividad — azul WB
COL_GAP <- "#C00000"   # brecha (sombra)

inv <- readRDS(here("01_data", "processed", "inversion_publica_sectorial_long.rds")) %>%
  filter(sector == "Agropecuario") %>% select(year, inv = inv_pub_usd_mm)
tfp <- readRDS(here("01_data", "processed", "usda_tfp_bolivia.rds")) %>%
  select(year = Year, tfp = TFP_Index)

# Ventana común 1990-2023, indexar a 1990 = 100
d <- inner_join(inv, tfp, by = "year") %>%
  filter(year >= 1990, year <= 2023) %>%
  arrange(year) %>%
  mutate(
    inv_idx = 100 * inv / inv[year == 1990],
    tfp_idx = 100 * tfp / tfp[year == 1990]
  )

ult <- max(d$year)
inv_fin <- d$inv_idx[d$year == ult]
tfp_fin <- d$tfp_idx[d$year == ult]
inv_pico <- max(d$inv_idx); anio_pico <- d$year[which.max(d$inv_idx)]

# ── Plot ──
p <- ggplot(d, aes(x = year)) +
  # Brecha del desacople (wedge sombreado entre TFP e inversión)
  geom_ribbon(aes(ymin = tfp_idx, ymax = inv_idx), fill = COL_GAP, alpha = 0.08) +
  # Línea base 1990 = 100
  geom_hline(yintercept = 100, linetype = "dotted", color = "gray70", linewidth = 0.4) +
  # Series
  geom_line(aes(y = inv_idx), color = COL_INV, linewidth = 1.7) +
  geom_line(aes(y = tfp_idx), color = COL_TFP, linewidth = 1.7) +
  geom_point(data = filter(d, year == ult), aes(y = inv_idx), color = COL_INV, size = 2.6) +
  geom_point(data = filter(d, year == ult), aes(y = tfp_idx), color = COL_TFP, size = 2.6) +

  # ── Direct labeling al final ──
  annotate("text", x = ult + 0.6, y = inv_fin, hjust = 0, vjust = 0.4,
           label = "Inversión pública\nagropecuaria", color = COL_INV,
           fontface = "bold", size = 3.8, lineheight = 0.9) +
  annotate("text", x = ult + 0.6, y = tfp_fin, hjust = 0, vjust = 0.5,
           label = "Productividad\ntotal (TFP)", color = COL_TFP,
           fontface = "bold", size = 3.8, lineheight = 0.9) +

  # ── Anotación de la brecha en el pico ──
  annotate("segment", x = anio_pico, xend = anio_pico,
           y = d$tfp_idx[d$year == anio_pico], yend = inv_pico,
           color = "gray45", linewidth = 0.4, linetype = "22") +
  annotate("text", x = anio_pico - 0.5, y = inv_pico * 0.92, hjust = 1,
           label = paste0("En ", anio_pico, " la inversión\nera ~×", round(inv_pico/100),
                          " la de 1990;\nla TFP, apenas +",
                          round(d$tfp_idx[d$year == anio_pico] - 100), "%"),
           color = "gray35", size = 3.1, lineheight = 0.95, fontface = "italic") +

  scale_x_continuous(breaks = seq(1990, 2020, 5),
                     limits = c(1990, ult + 6),
                     expand = expansion(mult = c(0.01, 0))) +
  scale_y_continuous(labels = label_number(accuracy = 1),
                     breaks = seq(0, 1000, 100)) +
  labs(
    title = "La inversión agropecuaria se multiplicó por nueve; la productividad apenas se movió",
    subtitle = "Inversión pública agropecuaria y productividad total de factores (TFP), ambas indexadas a 1990 = 100, Bolivia 1990-2023.\nLa brecha sombreada ilustra el desacople entre el gasto y los resultados de productividad.",
    x = NULL, y = "Índice 1990 = 100",
    caption = "Fuente: VIPFE / inversión pública sectorial (sector Agropecuario, USD millones) y USDA-ERS International Agricultural Productivity (2024). Cálculos propios sobre panel v12."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(size = 14.5, face = "bold", color = "#2C3E50"),
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

ggsave(here("05_outputs", "figures", "fig12_inversion_vs_tfp.png"), p,
       width = 10.5, height = 6.2, dpi = 600, bg = "white")
for (sub in c("svg", "pdf")) dir.create(here("05_outputs", "figures", sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs", "figures", "svg", "fig12_inversion_vs_tfp.svg"), p, width = 10.5, height = 6.2, bg = "white")
ggsave(here("05_outputs", "figures", "pdf", "fig12_inversion_vs_tfp.pdf"), p, width = 10.5, height = 6.2, bg = "white")

cat("\n✅ FIGURA DESACOPLE REGENERADA: 05_outputs/figures/fig12_inversion_vs_tfp.png\n\n")
cat("Índice 1990=100:\n")
cat("  Inversión:", round(d$inv_idx[d$year==1990]), "(1990) →", round(inv_pico), "(pico", anio_pico, ") →", round(inv_fin), "(", ult, ")\n")
cat("  TFP:       ", round(d$tfp_idx[d$year==1990]), "(1990) →", round(tfp_fin), "(", ult, ") = +", round(tfp_fin-100), "%\n")
