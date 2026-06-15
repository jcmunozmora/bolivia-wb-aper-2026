# 22_fig_composicion_proposito.R — Cap. 3: composición del gasto agro por propósito (grupo MAFAP)
# Mensaje: la mitad del gasto agro financia apoyo a la producción y seguridad alimentaria;
#   solo ~12% financia bienes públicos clásicos (I+D, extensión, sanidad). Soporta F03.
# Fuente: gasto_agro_programatico.rds (MEFP Presupuesto Abierto, acteco 2.x). Ver ADR-0014.
# Salida: fig_composicion_proposito_agro.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

a <- readRDS(here("01_data","processed","gasto_agro_programatico.rds"))

pal <- c(
  "Apoyo a la producción y seguridad alimentaria" = "#C00000",
  "Riego e infraestructura"                        = "#548235",
  "Servicios técnicos (I+D, extensión, sanidad)"   = "#1F4E79",
  "Tierras, multiprograma y otros"                 = "#A6A6A6")

# promedio anual por grupo (2016-2024); orden de paleta = mayor a la izquierda tras coord_flip
g <- a %>% group_by(year, grupo) %>% summarise(usd = sum(usd2015_mm), .groups = "drop") %>%
  group_by(grupo) %>% summarise(usd = mean(usd), .groups = "drop") %>%
  mutate(share = 100*usd/sum(usd),
         grupo = factor(grupo, levels = names(pal)),
         lab = paste0(round(share), "%  ·  USD ", round(usd), " M"))

p <- ggplot(g, aes(x = 1, y = share, fill = grupo)) +
  geom_col(width = 0.55, color = "white", linewidth = 0.6, position = position_stack(reverse = TRUE)) +
  geom_text(aes(label = lab), color = "white", fontface = "bold", size = 3.2,
            position = position_stack(vjust = 0.5, reverse = TRUE)) +
  scale_fill_manual(values = pal, breaks = names(pal), name = NULL) +
  scale_y_continuous(NULL, expand = c(0,0)) +
  scale_x_continuous(NULL, limits = c(0.5, 1.5)) +
  coord_flip() +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE, reverse = FALSE)) +
  labs(
    title = "La mitad del gasto público agropecuario financia apoyo a la producción; solo el 12% va a bienes públicos, 2016–2024",
    subtitle = "Composición del gasto público agropecuario por propósito (clasificación MAFAP), promedio anual, % del total y millones de USD constantes de 2015.",
    caption = paste0(
      "Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto devengado SIGEP, clasificación por actividad económica del sector agropecuario), deflactado a USD const. 2015. Crosswalk actividad→MAFAP: ADR-0014.\n",
      "Nota: 'Bienes públicos clásicos' = servicios técnicos (investigación, extensión, sanidad). 'Apoyo a la producción' incluye seguridad alimentaria (EMAPA). Promedio anual 2016–2024; 2024 preliminar.")
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 12.5, face = "bold", color = "#2C3E50", lineheight = 1.1),
    plot.subtitle = element_text(size = 9.4, color = "gray40", margin = margin(b = 10), lineheight = 1.05),
    plot.caption = element_text(size = 7.6, color = "gray50", hjust = 0, margin = margin(t = 12), lineheight = 1.1),
    plot.caption.position = "plot",
    legend.position = "top", legend.text = element_text(size = 8.6),
    axis.text = element_blank(), axis.ticks = element_blank(),
    panel.grid = element_blank(),
    plot.margin = margin(12, 16, 10, 16)
  )

W <- 11.0; H <- 4.4
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_composicion_proposito_agro.png"), p, width = W, height = H, dpi = 600, bg = "white")
if (requireNamespace("svglite", quietly = TRUE))
  ggsave(here("05_outputs","figures","svg","fig_composicion_proposito_agro.svg"), p, width = W, height = H, bg = "white")
try(ggsave(here("05_outputs","figures","pdf","fig_composicion_proposito_agro.pdf"), p, width = W, height = H, bg = "white"), silent = TRUE)

cat("\n✅ fig_composicion_proposito_agro generada\n")
print(as.data.frame(g %>% transmute(grupo = str_trunc(as.character(grupo),46), usd = round(usd,1), share = round(share,1))), row.names = FALSE)
