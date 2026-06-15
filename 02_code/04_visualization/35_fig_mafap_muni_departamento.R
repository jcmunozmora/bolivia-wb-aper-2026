# 35_fig_mafap_muni_departamento.R — Cap. 4: composición MAFAP del gasto agro municipal por departamento
# Mensaje: el instrumento del gasto agropecuario municipal varía radicalmente por departamento.
#   El riego (bien público D6) domina en los Andes y valles (Potosí, Chuquisaca, Cochabamba,
#   Oruro: 57-64%), mientras el apoyo directo a la producción (A) domina en las tierras bajas
#   (Pando 61%, Santa Cruz 47%). Conecta el instrumento con la vocación territorial.
# Fuente: gasto_agro_prog_muni_2016_2024.rds (MEFP acteco por entidad municipal). Ver ADR-0015.
# Salida: fig_mafap_muni_departamento.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

p <- readRDS(here("01_data","processed","gasto_agro_prog_muni_2016_2024.rds"))

pal <- c(
  "Apoyo a la producción y seguridad alimentaria" = "#C00000",
  "Riego e infraestructura"                        = "#548235",
  "Servicios técnicos (I+D, extensión, sanidad)"   = "#1F4E79",
  "Tierras, multiprograma y otros"                 = "#A6A6A6")
etq <- c("Apoyo a la producción y seguridad alimentaria" = "Apoyo a la producción",
         "Riego e infraestructura"                        = "Riego e infraestructura",
         "Servicios técnicos (I+D, extensión, sanidad)"   = "Servicios técnicos (I+D, extensión, sanidad)",
         "Tierras, multiprograma y otros"                 = "Tierras, multiprograma y otros")

# composición acumulada 2016-2024 por departamento; ordenar por % apoyo a la producción
dep <- p %>% filter(!is.na(dept_name)) %>%
  group_by(dept_name, grupo) %>% summarise(usd = sum(usd2015), .groups = "drop") %>%
  group_by(dept_name) %>% mutate(pct = 100*usd/sum(usd), tot_mm = sum(usd)/1e6) %>% ungroup()

ord <- dep %>% filter(grupo == "Apoyo a la producción y seguridad alimentaria") %>%
  arrange(pct) %>% pull(dept_name)
# orden de apilado de izquierda (x=0) a derecha: Tierras · Servicios · Riego · Apoyo
ordstack <- rev(names(pal))
dep <- dep %>% mutate(dept_name = factor(dept_name, levels = ord),
                      grupo = factor(grupo, levels = ordstack))

# posición de etiqueta: acumular sobre los 4 grupos (no sobre el subconjunto filtrado),
# luego quedarse con producción y riego si la banda es legible (pct > 8)
lab <- dep %>% arrange(dept_name, grupo) %>%
  group_by(dept_name) %>% mutate(xpos = cumsum(pct) - pct/2) %>% ungroup() %>%
  filter(grupo %in% c("Apoyo a la producción y seguridad alimentaria",
                      "Riego e infraestructura"), pct > 8)

p2 <- ggplot(dep, aes(pct, dept_name, fill = grupo)) +
  geom_col(width = 0.72, position = position_stack(reverse = TRUE)) +
  geom_text(data = lab, aes(x = xpos, label = paste0(round(pct), "%")),
            color = "white", fontface = "bold", size = 2.9) +
  scale_fill_manual(values = pal, breaks = names(pal), labels = etq, name = NULL) +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE)) +
  scale_x_continuous(labels = label_number(suffix = "%"), expand = c(0, 0)) +
  labs(
    title = "El instrumento del gasto agropecuario municipal sigue la vocación del territorio, 2016–2024",
    subtitle = "Composición del gasto agropecuario municipal por propósito (MAFAP), % acumulado 2016–2024. El riego domina en los Andes y valles;\nel apoyo directo a la producción domina en las tierras bajas (Pando, Santa Cruz).",
    x = "% del gasto agropecuario municipal del departamento", y = NULL,
    caption = paste0(
      str_wrap("Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (devengado SIGEP por entidad municipal, clasificación por actividad económica agropecuaria); crosswalk actividad→MAFAP (ADR-0015).", width = 118),
      "\n",
      str_wrap("Nota: capta el gasto del gobierno municipal (POA), no la ejecución del nivel central ni departamental. Ordenado por participación del apoyo a la producción; acumulado 2016–2024.", width = 118))
  ) +
  theme_minimal(base_size = 10) +
  theme(plot.title = element_text(size = 12.2, face = "bold", color = "#2C3E50", lineheight = 1.1),
        plot.subtitle = element_text(size = 8.6, color = "gray40", lineheight = 1.05, margin = margin(b = 8)),
        plot.caption = element_text(size = 7.4, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
        plot.caption.position = "plot",
        legend.position = "bottom", legend.text = element_text(size = 8.2),
        axis.text.y = element_text(size = 9.4, color = "#2C3E50"),
        panel.grid.major.y = element_blank(), panel.grid.minor = element_blank(),
        plot.margin = margin(12, 16, 10, 16))

W <- 9.0; H <- 5.6
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_mafap_muni_departamento.png"), p2, width = W, height = H, dpi = 600, bg = "white")
if (requireNamespace("svglite", quietly = TRUE))
  ggsave(here("05_outputs","figures","svg","fig_mafap_muni_departamento.svg"), p2, width = W, height = H, bg = "white")
try(ggsave(here("05_outputs","figures","pdf","fig_mafap_muni_departamento.pdf"), p2, width = W, height = H, bg = "white"), silent = TRUE)

cat("\n✅ fig_mafap_muni_departamento generada\n")
print(as.data.frame(dep %>% select(dept_name, grupo, pct) %>%
  pivot_wider(names_from = grupo, values_from = pct, values_fill = 0) %>%
  mutate(across(where(is.numeric), ~round(.,1)))), row.names = FALSE)
