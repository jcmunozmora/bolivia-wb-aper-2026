# 24_fig_produccion_instrumento.R — Cap. 4: instrumento del gasto rural × zona agroproductiva
# Mensaje: el tipo de instrumento sigue la vocación productiva del territorio: caminos vecinales
#   dominan casi todo, el microriego se concentra en valles, lo productivo (p10) pesa en Chaco/Amazonía.
# Fuente: territorial_muni.rds (panel municipal Jubileo × zona CNA2013). Ver ADR-0015.
# Salida: fig_produccion_instrumento_zona.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

tm <- readRDS(here("01_data","processed","territorial_muni.rds"))

instr_lev <- c("Productivo agropecuario (p10)", "Microriego (p12)",
               "Recursos hídricos (p32)", "Caminos vecinales (p18)")
pal <- c("Productivo agropecuario (p10)" = "#C00000",
         "Microriego (p12)"              = "#1F4E79",
         "Recursos hídricos (p32)"       = "#548235",
         "Caminos vecinales (p18)"       = "#BF8F00")

# promedio anual por zona × instrumento (USD const. 2015), excluyendo zonas híbridas
z <- tm %>% filter(!is.na(zona_agroproductiva), !str_detect(zona_agroproductiva, " - ")) %>%
  group_by(year, zona_agroproductiva) %>%
  summarise(`Productivo agropecuario (p10)` = sum(p10_agropecuario_usd2015, na.rm=TRUE),
            `Microriego (p12)`              = sum(p12_microriegos_usd2015, na.rm=TRUE),
            `Recursos hídricos (p32)`       = sum(p32_recursos_hidricos_usd2015, na.rm=TRUE),
            `Caminos vecinales (p18)`       = sum(p18_caminos_vecinales_usd2015, na.rm=TRUE), .groups="drop") %>%
  group_by(zona_agroproductiva) %>% summarise(across(everything() & !year, mean), .groups="drop") %>%
  mutate(total = `Productivo agropecuario (p10)`+`Microriego (p12)`+`Recursos hídricos (p32)`+`Caminos vecinales (p18)`)

ord <- z %>% arrange(total) %>% pull(zona_agroproductiva)   # menor abajo→mayor arriba
tot_lab <- z %>% transmute(zona_agroproductiva, lab = paste0("$", round(total), " M/año"))

zl <- z %>% select(-total) %>%
  pivot_longer(-zona_agroproductiva, names_to="instrumento", values_to="usd") %>%
  group_by(zona_agroproductiva) %>% mutate(share = 100*usd/sum(usd)) %>% ungroup() %>%
  mutate(zona_agroproductiva = factor(zona_agroproductiva, levels = ord),
         instrumento = factor(instrumento, levels = instr_lev))

p <- ggplot(zl, aes(y = zona_agroproductiva, x = share, fill = instrumento)) +
  geom_col(width = 0.74, color = "white", linewidth = 0.4, position = position_stack(reverse = TRUE)) +
  geom_text(aes(label = ifelse(share >= 9, paste0(round(share),"%"), "")),
            position = position_stack(vjust = 0.5, reverse = TRUE),
            color = "white", fontface = "bold", size = 2.7) +
  # total anual por zona al final de la barra
  geom_text(data = tot_lab, aes(y = zona_agroproductiva, label = lab), x = 101.5,
            hjust = 0, inherit.aes = FALSE, size = 2.8, color = "gray35") +
  scale_fill_manual(values = pal, breaks = instr_lev, name = NULL) +
  scale_x_continuous("Composición del gasto rural municipal (%)",
                     breaks = seq(0,100,25), limits = c(0,118), expand = expansion(mult = c(0,0))) +
  scale_y_discrete(NULL) +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE)) +
  labs(
    title = "El instrumento del gasto rural sigue la vocación del territorio: microriego en los valles, gasto productivo en la frontera oriental",
    subtitle = "Composición del gasto rural municipal por instrumento, según zona agroproductiva (Censo Agropecuario 2013). Promedio anual 2012–2021, USD constantes de 2015.\nLos caminos vecinales (p18) son el principal instrumento en valles, Chiquitania y altiplano; el microriego (p12) se concentra en los valles; el gasto productivo (p10) predomina en el Chaco, la Amazonía y las llanuras.",
    caption = paste0(
      "Fuente: cálculo propio (Banco Mundial) sobre panel municipal (Fundación Jubileo, clasificador programático municipal) y zonas agroproductivas del Censo Nacional Agropecuario 2013 (INE). Ver ADR-0015.\n",
      "Nota: instrumentos = programas municipales p10 (productivo agropecuario), p12 (microriego), p18 (caminos vecinales) y p32 (recursos hídricos). Cruce muni↔CNA por nombre (286/335 municipios, 85%). Zonas híbridas excluidas. Cifra a la derecha: gasto total anual de la zona.")
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 12.5, face = "bold", color = "#2C3E50", lineheight = 1.1),
    plot.subtitle = element_text(size = 9.2, color = "gray40", margin = margin(b = 8), lineheight = 1.05),
    plot.caption = element_text(size = 7.6, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
    plot.caption.position = "plot",
    legend.position = "top", legend.text = element_text(size = 8.4),
    axis.title.x = element_text(size = 9, color = "gray30"),
    axis.text.y = element_text(size = 9, color = "gray20"),
    panel.grid.minor = element_blank(), panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 14, 10, 12)
  )

W <- 11.0; H <- 5.6
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_produccion_instrumento_zona.png"), p, width = W, height = H, dpi = 600, bg = "white")
if (requireNamespace("svglite", quietly = TRUE))
  ggsave(here("05_outputs","figures","svg","fig_produccion_instrumento_zona.svg"), p, width = W, height = H, bg = "white")
try(ggsave(here("05_outputs","figures","pdf","fig_produccion_instrumento_zona.pdf"), p, width = W, height = H, bg = "white"), silent = TRUE)

cat("\n✅ fig_produccion_instrumento_zona generada\n")
print(as.data.frame(z %>% mutate(across(where(is.numeric), ~round(.,1)))), row.names = FALSE)
