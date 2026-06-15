# 34_fig_mafap_muni_evolucion.R — Cap. 4: composición MAFAP del gasto agro MUNICIPAL, 2016-2024
# Mensaje: el gasto que ejecutan los gobiernos municipales viró del riego (bien público D6)
#   hacia el apoyo directo a la producción (A), que pasó de 33% a 53% entre 2016 y 2024,
#   cruzando a los bienes públicos en el último año. Extiende a 2024 la lectura de composición
#   municipal que Jubileo cerraba en 2021.
# Fuente: gasto_agro_prog_muni_2016_2024.rds (MEFP acteco por entidad municipal). Ver ADR-0015.
# Composición en %, invariante a la deflación.
# Salida: fig_mafap_muni_evolucion.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

p <- readRDS(here("01_data","processed","gasto_agro_prog_muni_2016_2024.rds"))

# paleta por propósito (consistente con fig_composicion_proposito_agro nacional, script 22)
pal <- c(
  "Apoyo a la producción y seguridad alimentaria" = "#C00000",
  "Riego e infraestructura"                        = "#548235",
  "Servicios técnicos (I+D, extensión, sanidad)"   = "#1F4E79",
  "Tierras, multiprograma y otros"                 = "#A6A6A6")
etq <- c("Apoyo a la producción y seguridad alimentaria" = "Apoyo a la producción",
         "Riego e infraestructura"                        = "Riego e infraestructura",
         "Servicios técnicos (I+D, extensión, sanidad)"   = "Servicios técnicos (I+D, extensión, sanidad)",
         "Tierras, multiprograma y otros"                 = "Tierras, multiprograma y otros")

# composición % por año; D base abajo (riego/servicios/tierras), A (producción) arriba
ordstack <- rev(c("Apoyo a la producción y seguridad alimentaria",
                   "Riego e infraestructura",
                   "Servicios técnicos (I+D, extensión, sanidad)",
                   "Tierras, multiprograma y otros"))
comp <- p %>% group_by(year, grupo) %>% summarise(usd = sum(usd2015), .groups = "drop") %>%
  group_by(year) %>% mutate(pct = 100*usd/sum(usd)) %>% ungroup() %>%
  mutate(grupo = factor(grupo, levels = ordstack))

# etiquetas de % en 2016 y 2024 para producción (banda base) y riego (banda media).
# geom_area apila el ÚLTIMO nivel del factor en la base (y=0): acumular en desc(grupo)
# para que ypos coincida con la banda dibujada.
lab <- comp %>% group_by(year) %>% arrange(desc(grupo)) %>% mutate(ypos = cumsum(pct) - pct/2) %>%
  ungroup() %>% filter(year %in% c(2016, 2024),
                       grupo %in% c("Apoyo a la producción y seguridad alimentaria",
                                    "Riego e infraestructura"))

p1 <- ggplot(comp, aes(year, pct, fill = grupo)) +
  geom_area(alpha = 0.93, color = "white", linewidth = 0.2) +
  scale_fill_manual(values = pal, breaks = names(pal), labels = etq, name = NULL) +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE)) +
  geom_text(data = filter(lab, year == 2016), aes(y = ypos, label = paste0(round(pct), "%")),
            x = 2016.12, hjust = 0, color = "white", fontface = "bold", size = 3.0) +
  geom_text(data = filter(lab, year == 2024), aes(y = ypos, label = paste0(round(pct), "%")),
            x = 2023.88, hjust = 1, color = "white", fontface = "bold", size = 3.0) +
  scale_x_continuous(breaks = seq(2016, 2024, 2), expand = c(0.01, 0)) +
  scale_y_continuous(labels = label_number(suffix = "%"), expand = c(0, 0)) +
  labs(
    title = "El gasto agropecuario municipal viró del riego hacia el apoyo directo a la producción, 2016–2024",
    subtitle = "Composición del gasto agropecuario de los gobiernos autónomos municipales por propósito (clasificación MAFAP), % del total.\nEl apoyo a la producción (categoría A) pasó de 33% a 53% y cruzó a los bienes públicos (D) en 2024.",
    x = NULL, y = "% del gasto agropecuario municipal",
    caption = paste0(
      str_wrap("Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (devengado SIGEP por entidad municipal, clasificación por actividad económica agropecuaria); crosswalk actividad→MAFAP (ADR-0015).", width = 120),
      "\n",
      str_wrap("Nota: capta el gasto del gobierno municipal (POA), no la ejecución del nivel central ni departamental. ~329 municipios/año; cobertura 99,7% del total agropecuario municipal MEFP. 2024 preliminar.", width = 120))
  ) +
  theme_minimal(base_size = 10) +
  theme(plot.title = element_text(size = 12.2, face = "bold", color = "#2C3E50", lineheight = 1.1),
        plot.subtitle = element_text(size = 8.6, color = "gray40", lineheight = 1.05, margin = margin(b = 8)),
        plot.caption = element_text(size = 7.4, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
        plot.caption.position = "plot",
        legend.position = "bottom", legend.text = element_text(size = 8.2),
        panel.grid.major.x = element_blank(), panel.grid.minor = element_blank(),
        plot.margin = margin(12, 16, 10, 16))

W <- 9.0; H <- 5.4
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_mafap_muni_evolucion.png"), p1, width = W, height = H, dpi = 600, bg = "white")
if (requireNamespace("svglite", quietly = TRUE))
  ggsave(here("05_outputs","figures","svg","fig_mafap_muni_evolucion.svg"), p1, width = W, height = H, bg = "white")
try(ggsave(here("05_outputs","figures","pdf","fig_mafap_muni_evolucion.pdf"), p1, width = W, height = H, bg = "white"), silent = TRUE)

cat("\n✅ fig_mafap_muni_evolucion generada\n")
print(as.data.frame(comp %>% select(year, grupo, pct) %>%
  pivot_wider(names_from = grupo, values_from = pct) %>%
  mutate(across(where(is.numeric), ~round(.,1)))), row.names = FALSE)
