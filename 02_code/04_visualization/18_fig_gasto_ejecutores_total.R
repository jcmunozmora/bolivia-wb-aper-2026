# 18_fig_gasto_ejecutores_total.R — Cap. 3: ejecutores recientes + gasto total vs inversión
# Fig A: composición de la ejecución del gasto agro por tipo de entidad 2016-2024 (ascenso de EMAPA).
# Fig B: gasto público agropecuario TOTAL (MEFP) vs inversión (VIPFE), 2016-2024 (total ≈2× inversión).
# Fuente: MEFP Presupuesto Abierto (devengado) + VIPFE; ver ADR-0012.
# Salida: fig_ejecutores_agro_2016_2024.* y fig_gasto_total_vs_inversion.* (600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales); library(here)

P <- here("01_data","processed")

# ============================================================================
# FIG A — Composición de la ejecución por tipo de entidad (2016-2024)
# ============================================================================
# Agrupar en 5 bloques limpios (la versión de 8 categorías estaba recargada)
sh <- readRDS(file.path(P,"gasto_agro_externo_share_ejecutor.rds")) %>%
  filter(year <= 2024) %>%
  mutate(bloque = case_when(
    tipo == "EMAPA" ~ "EMAPA (empresa estatal de alimentos)",
    grepl("Gobernaci|Municip", tipo) ~ "Gobiernos subnacionales",
    tipo == "MDRyT (rector)" ~ "MDRyT (ministerio rector)",
    grepl("INIAF|SENASAG|INRA|MMAyA", tipo) ~ "Adscritas técnicas + riego (INIAF, INRA, MMAyA)",
    TRUE ~ "Otras entidades")) %>%
  group_by(year, bloque) %>% summarise(share = sum(share), .groups="drop")

orden <- c("EMAPA (empresa estatal de alimentos)","Gobiernos subnacionales",
           "MDRyT (ministerio rector)","Adscritas técnicas + riego (INIAF, INRA, MMAyA)","Otras entidades")
pal <- c("EMAPA (empresa estatal de alimentos)"="#C00000","Gobiernos subnacionales"="#548235",
         "MDRyT (ministerio rector)"="#1F4E79","Adscritas técnicas + riego (INIAF, INRA, MMAyA)"="#BF8F00",
         "Otras entidades"="#BFBFBF")
sh <- sh %>% mutate(bloque = factor(bloque, levels = rev(orden)))

# valores para anotar (EMAPA ↑, subnacional ↓)
g <- function(b,y) round(sh$share[sh$bloque==b & sh$year==y])

pA <- ggplot(sh, aes(year, share, fill = bloque)) +
  geom_area(alpha = 0.93, color = "white", linewidth = 0.25) +
  scale_fill_manual(values = pal, breaks = orden, name = NULL) +
  # EMAPA (banda inferior): 25% → 42%
  annotate("text", x = 2016.2, y = g("EMAPA (empresa estatal de alimentos)",2016)/2,
           label = paste0("EMAPA\n", g("EMAPA (empresa estatal de alimentos)",2016),"%"),
           color = "white", fontface = "bold", size = 3, hjust = 0, lineheight = 0.85) +
  annotate("text", x = 2024, y = g("EMAPA (empresa estatal de alimentos)",2024)/2,
           label = paste0(g("EMAPA (empresa estatal de alimentos)",2024),"%"),
           color = "white", fontface = "bold", size = 3.4, hjust = 1) +
  # Subnacional (banda media): 38% → 22%
  annotate("text", x = 2016.2, y = g("EMAPA (empresa estatal de alimentos)",2016) + g("Gobiernos subnacionales",2016)/2,
           label = paste0("Subnacional\n", g("Gobiernos subnacionales",2016),"%"),
           color = "white", fontface = "bold", size = 3, hjust = 0, lineheight = 0.85) +
  annotate("text", x = 2024, y = g("EMAPA (empresa estatal de alimentos)",2024) + g("Gobiernos subnacionales",2024)/2,
           label = paste0(g("Gobiernos subnacionales",2024),"%"),
           color = "white", fontface = "bold", size = 3.2, hjust = 1) +
  scale_x_continuous(breaks = seq(2016,2024,2), expand = c(0.01,0)) +
  scale_y_continuous(labels = label_number(suffix="%"), expand = c(0,0)) +
  labs(
    title = "EMAPA desplazó a los gobiernos subnacionales como principal ejecutor del gasto agropecuario",
    subtitle = "Participación en la ejecución del gasto público agropecuario por tipo de entidad, 2016–2024.\nLa empresa estatal de alimentos (EMAPA) pasó de 25% a 42% del gasto, casi exactamente lo que perdió el bloque subnacional (38%→22%); el ministerio rector se mantuvo en ~19%.",
    x = NULL, y = "Participación en la ejecución (%)",
    caption = "Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto devengado SIGEP); más de 340 entidades ejecutan gasto del sector cada año. Ver ADR-0012."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 13, face = "bold", color = "#2C3E50", lineheight = 1.1),
    plot.subtitle = element_text(size = 9.4, color = "gray40", margin = margin(b=8), lineheight = 1.05),
    plot.caption = element_text(size = 8, color = "gray50", hjust = 0, margin = margin(t=10), lineheight=1.1),
    plot.caption.position = "plot",
    legend.position = "right", legend.text = element_text(size = 8.4),
    axis.title.y = element_text(size = 9.5, color = "gray30"),
    panel.grid.minor = element_blank(), panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12,14,10,12)
  )

# ============================================================================
# FIG B — Gasto total (MEFP) vs inversión (VIPFE) 2016-2024
# ============================================================================
FX2015 <- 6.91  # BOB/USD 2015 (peg)
m <- readRDS(file.path(P,"mafap_bolivia.rds")) %>%
  filter(year >= 2016, year <= 2024) %>%
  # CPI 2015=100 (panel); 2024 NA → estimado con inflación media INE 2024 ≈5,1% [preliminar]
  mutate(cpi = if_else(year == 2024 & is.na(cpi_2015base), 117.7729 * 1.051, cpi_2015base),
         # gasto total: BOB corriente → BOB const. 2015 → USD const. 2015
         `Gasto total (corriente + capital)` = (mefp_gasto_agro_total_bs/1e6) / (cpi/100) / FX2015,
         # inversión: ya en BOB const. 2015 → USD const. 2015
         `Inversión (capital, VIPFE)`        = inv_agro_bob_mm_2015 / FX2015) %>%
  select(year, `Gasto total (corriente + capital)`, `Inversión (capital, VIPFE)`) %>%
  pivot_longer(-year, names_to="serie", values_to="mmusd") %>% filter(!is.na(mmusd))

pB <- ggplot(m, aes(year, mmusd, color = serie)) +
  geom_line(linewidth = 1.4) + geom_point(size = 2) +
  scale_color_manual(values = c("Gasto total (corriente + capital)"="#1F4E79",
                                "Inversión (capital, VIPFE)"="#BF8F00"), name = NULL) +
  scale_x_continuous(breaks = seq(2016,2024,2)) +
  scale_y_continuous(labels = label_comma(), limits = c(0, NA)) +
  labs(
    title = "La inversión es solo la mitad del gasto público agropecuario",
    subtitle = "Gasto total devengado (corriente + capital) vs inversión (capital), millones de USD constantes de 2015, 2016–2024.\nEl gasto total es en promedio 2,1× la inversión: la serie de inversión invisibiliza el ~52% corriente (salarios, operación, empresas públicas).",
    x = NULL, y = "Millones de USD constantes de 2015",
    caption = "Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto total devengado, deflactado a USD const. 2015) y VIPFE (inversión, BOB const. 2015 / 6,91). Ver ADR-0012."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 13, face = "bold", color = "#2C3E50"),
    plot.subtitle = element_text(size = 9.6, color = "gray40", margin = margin(b=8), lineheight = 1.05),
    plot.caption = element_text(size = 8, color = "gray50", hjust = 0, margin = margin(t=10), lineheight=1.1),
    plot.caption.position = "plot",
    legend.position = "top", axis.title.y = element_text(size = 9.5, color = "gray30"),
    panel.grid.minor = element_blank(), panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12,14,10,12)
  )

for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_ejecutores_agro_2016_2024.png"), pA, width = 11, height = 5.8, dpi = 600, bg = "white")
ggsave(here("05_outputs","figures","svg","fig_ejecutores_agro_2016_2024.svg"), pA, width = 11, height = 5.8, bg = "white")
ggsave(here("05_outputs","figures","png","fig_gasto_total_vs_inversion.png"), pB, width = 10, height = 5.6, dpi = 600, bg = "white")
ggsave(here("05_outputs","figures","svg","fig_gasto_total_vs_inversion.svg"), pB, width = 10, height = 5.6, bg = "white")
cat("\n✅ Figuras generadas: fig_ejecutores_agro_2016_2024 + fig_gasto_total_vs_inversion\n")
cat("EMAPA share:", paste(round(sh$share[sh$bloque=="EMAPA (empresa estatal de alimentos)"]),"%"), "\n")
