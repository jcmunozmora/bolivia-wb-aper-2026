# 16_fig_mafap_publicexp.R — Composición del gasto público agropecuario MAFAP (marco Vol II, m0.2.0)
# Historia honesta: el gasto público medible se concentra en D (servicios generales/
#   bienes públicos) y E (soporte rural); el apoyo presupuestario NETO al productor (A=BT)
#   es marginal o negativo. El MPS (sostén de precios) NO es gasto público → Cap. 5 (PSE).
# Fuente: mafap_bolivia.rds (m0.2.0). Reemplaza fig18_summary con la lectura corregida.
# Salida: fig18_summary_mafap_ABCDE.{png,svg,pdf} (subcarpetas, 600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales); library(here)

m <- readRDS(here("01_data", "processed", "mafap_bolivia.rds")) %>%
  filter(year >= 2006, year <= 2023)

FX2015 <- 6.91  # BOB/USD 2015 (peg). USD const. 2015 = BOB const. 2015 / FX2015.

# Colores (07_FIGURAS §6)
C_D <- "#548235"   # verde — D servicios generales (bienes públicos)
C_E <- "#BF8F00"   # dorado — E soporte rural
C_A <- "#1F4E79"   # azul WB — A transferencias presupuestarias netas al productor

# Stack positivo: D + E (gasto público medible)
df_de <- m %>%
  select(year, D = mafap_D_bob_2015, E = mafap_E_bob_2015) %>%
  mutate(D = D/FX2015, E = E/FX2015) %>%                 # → USD const. 2015
  pivot_longer(-year, names_to = "cat", values_to = "mm") %>%
  filter(!is.na(mm)) %>%
  mutate(cat = factor(cat, levels = c("E", "D")))  # D arriba

df_a <- m %>% select(year, A = mafap_A_bob_2015) %>% mutate(A = A/FX2015) %>% filter(!is.na(A))

ymax <- max((m$mafap_D_bob_2015 + coalesce(m$mafap_E_bob_2015, 0))/FX2015, na.rm = TRUE)
ymin <- min(0, min(df_a$A, na.rm = TRUE)) * 1.1

p <- ggplot() +
  geom_hline(yintercept = 0, color = "gray55", linewidth = 0.4) +
  # D + E apilados (gasto público medible)
  geom_col(data = df_de, aes(x = year, y = mm, fill = cat), width = 0.74) +
  scale_fill_manual(
    values = c("D" = C_D, "E" = C_E),
    breaks = c("D", "E"),
    labels = c("D — Servicios generales / bienes públicos (≈GSSE: I+D, sanidad, infraestructura)",
               "E — Soporte rural (infraestructura municipal; solo cobertura 2012–2021)")
  ) +
  # A = transferencias presupuestarias netas (línea, puede ser negativa)
  geom_line(data = df_a, aes(x = year, y = A), color = C_A, linewidth = 1.2) +
  geom_point(data = df_a, aes(x = year, y = A), color = C_A, size = 2) +
  annotate("text", x = 2006.2, y = df_a$A[df_a$year == 2006], hjust = 0, vjust = 1.6,
           label = "A — Transferencias presupuestarias\nnetas al productor (BT)",
           color = C_A, size = 2.9, fontface = "bold", lineheight = 0.9) +
  scale_x_continuous(breaks = seq(2006, 2022, 4)) +
  scale_y_continuous(labels = label_comma(), limits = c(ymin, ymax * 1.05)) +
  labs(
    title = "El gasto público agropecuario boliviano se concentra en servicios generales,\nno en transferencias al productor",
    subtitle = "Clasificación MAFAP (marco de gasto público, Vol II), millones de USD constantes de 2015, 2006–2023.\nEl apoyo presupuestario neto al productor (A) es marginal o negativo: el presupuesto net-grava al productor vía restricciones de exportación.",
    x = NULL, y = "Millones de USD constantes de 2015",
    fill = NULL,
    caption = paste0(
      "Fuente: cálculo propio (Banco Mundial) sobre panel v12 — IDB AgriMonitor (GSSE→D; BT→A) + SIIF/Jubileo municipal (E). Metodología m0.2.0.\n",
      "Nota: el sostén de precios de mercado (MPS) y el apoyo vía precios al consumidor (CSE) NO son gasto público y se reportan como OECD-PSE en el Capítulo 5.\n",
      "El apoyo presupuestario a productores (A2) y consumidores (B) en detalle, y la categoría C, requieren clasificación funcional BOOST granular (disponible 2000–2008); ver auditoría 2026-06-14."
    )
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 13.5, face = "bold", color = "#2C3E50", lineheight = 1.1),
    plot.subtitle = element_text(size = 9.6, color = "gray40", margin = margin(b = 8), lineheight = 1.05),
    plot.caption = element_text(size = 7.6, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
    plot.caption.position = "plot",
    legend.position = "top", legend.direction = "vertical", legend.text = element_text(size = 8.4),
    axis.title.y = element_text(size = 9.5, color = "gray30"),
    panel.grid.minor = element_blank(), panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 14, 10, 12)
  )

for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig18_summary_mafap_ABCDE.png"), p, width = 10.5, height = 6.6, dpi = 600, bg = "white")
ggsave(here("05_outputs","figures","svg","fig18_summary_mafap_ABCDE.svg"), p, width = 10.5, height = 6.6, bg = "white")
ggsave(here("05_outputs","figures","pdf","fig18_summary_mafap_ABCDE.pdf"), p, width = 10.5, height = 6.6, bg = "white")
cat("\n✅ fig18_summary_mafap_ABCDE regenerada (m0.2.0, marco Vol II)\n")
