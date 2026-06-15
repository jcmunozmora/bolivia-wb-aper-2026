# 27_fig_top_municipios.R — Cap. 4: top-20 municipios por gasto agropecuario total, 2024
# Serie reciente MEFP (gasto agro TOTAL por municipio, devengado 2024, USD const. 2015).
# Mensaje: el top mezcla capitales departamentales, el Chaco tarijeño y los valles cochabambinos.
# Fuente: territorial_muni_mefp.rds (MEFP Presupuesto Abierto). Ver ADR-0015.
# Salida: fig_top20_municipios_agro.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

YEAR <- 2024
tm <- readRDS(here("01_data","processed","territorial_muni_mefp.rds")) %>% filter(year == YEAR)

capitales <- c("La Paz","Santa Cruz De La Sierra","Cochabamba","Sucre","Oruro",
               "Potosí","Tarija","Trinidad","Cobija")

top <- tm %>% filter(!is.na(usd2015)) %>% arrange(desc(usd2015)) %>% slice_head(n = 20) %>%
  mutate(dept = replace_na(dept, "s/d"),
         capital = muni_name %in% capitales,
         lab = if_else(capital, paste0(muni_name, " *"), muni_name),
         lab = paste0(str_trunc(lab, 30), "  (", str_sub(dept, 1, 3), ")"),
         lab = fct_reorder(lab, usd2015))

pal_dep <- c("Santa Cruz"="#1F4E79","Tarija"="#C00000","La Paz"="#548235","Cochabamba"="#BF8F00",
             "Chuquisaca"="#7030A0","Beni"="#2E8B8B","Oruro"="#8C6D31","Potosí"="#4472C4",
             "Pando"="#A6A6A6","s/d"="#D9D9D9")

p <- ggplot(top, aes(usd2015, lab, fill = dept)) +
  geom_col(width = 0.74) +
  geom_text(aes(label = paste0("$", formatC(usd2015, format="f", digits=2))),
            hjust = -0.15, size = 2.6, color = "gray35") +
  scale_fill_manual(values = pal_dep, name = NULL) +
  scale_x_continuous("Gasto agropecuario total (devengado), millones de USD constantes de 2015",
                     limits = c(0, max(top$usd2015)*1.18), expand = expansion(mult = c(0, 0))) +
  scale_y_discrete(NULL) +
  guides(fill = guide_legend(nrow = 1)) +
  labs(
    title = "El top municipal del gasto agropecuario mezcla capitales, el Chaco tarijeño y los valles cochabambinos, 2024",
    subtitle = "Veinte municipios con mayor gasto agropecuario total (devengado), 2024, en millones de USD constantes de 2015.\nSucre, Santa Cruz de la Sierra, La Paz y Potosí (capitales) conviven con el Chaco tarijeño (Caraparí, Villamontes, Yacuiba) y los valles (Quillacollo, Sacaba).",
    caption = "Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto agro municipal devengado, acteco=2), deflactado a USD const. 2015. Ver ADR-0015.\nNota: (*) capital departamental. Gasto agropecuario total del municipio (no separa instrumentos). 2024 preliminar."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 12.5, face = "bold", color = "#2C3E50", lineheight = 1.1),
    plot.subtitle = element_text(size = 9.2, color = "gray40", margin = margin(b = 8), lineheight = 1.05),
    plot.caption = element_text(size = 7.6, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
    plot.caption.position = "plot",
    legend.position = "top", legend.text = element_text(size = 8.2),
    axis.title.x = element_text(size = 9, color = "gray30"),
    axis.text.y = element_text(size = 8.2, color = "gray20"),
    panel.grid.minor = element_blank(), panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 14, 10, 12)
  )

W <- 11.5; H <- 6.8
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_top20_municipios_agro.png"), p, width = W, height = H, dpi = 600, bg = "white")
if (requireNamespace("svglite", quietly = TRUE))
  ggsave(here("05_outputs","figures","svg","fig_top20_municipios_agro.svg"), p, width = W, height = H, bg = "white")
try(ggsave(here("05_outputs","figures","pdf","fig_top20_municipios_agro.pdf"), p, width = W, height = H, bg = "white"), silent = TRUE)

cat("\n✅ fig_top20_municipios_agro (MEFP", YEAR, ") generada\n")
print(as.data.frame(top %>% transmute(muni_name, dept, usd2015 = round(usd2015,2), capital)), row.names = FALSE)
