# 21_fig_pareto_programas.R — Cap. 3: Pareto del gasto público agropecuario por actividad/programa
# Mensaje: el gasto agro está muy concentrado: 8 de 36 actividades acumulan el 80%; la mitad
#   va a apoyo a la producción y seguridad alimentaria (EMAPA), solo ~12% a bienes públicos clásicos.
# Fuente: gasto_agro_programatico.rds (MEFP Presupuesto Abierto, acteco 2.x). Ver ADR-0014.
# Salida: fig_pareto_programas_agro.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

a <- readRDS(here("01_data","processed","gasto_agro_programatico.rds"))

# Paleta por grupo de propósito MAFAP (07_FIGURAS §6)
pal <- c(
  "Apoyo a la producción y seguridad alimentaria" = "#C00000",  # rojo — apoyo productor (A)
  "Riego e infraestructura"                        = "#548235",  # verde — infraestructura (D6)
  "Servicios técnicos (I+D, extensión, sanidad)"   = "#1F4E79",  # azul WB — bienes públicos (D1-D5)
  "Tierras, multiprograma y otros"                 = "#A6A6A6")  # gris — otros (D9/D10)
C_CUM <- "#2C3E50"

# Promedio anual por actividad (2016-2024) → ranking + acumulado
TOPN <- 12
par <- a %>%
  group_by(acteco, label, grupo) %>%
  summarise(usd = mean(usd2015_mm, na.rm = TRUE), .groups = "drop") %>%
  arrange(desc(usd)) %>%
  mutate(share = 100*usd/sum(usd), rank = row_number())

n_total <- nrow(par)
n80 <- sum(cumsum(par$share) < 80) + 1            # nº actividades para llegar al 80%
usd80 <- round(sum(par$usd[1:n80]))               # USD acumulado de esas actividades

# top-N individuales + "Otras (resto)" como última barra
top <- par %>% slice_head(n = TOPN)
otras <- par %>% slice_tail(n = n_total - TOPN) %>%
  summarise(acteco = "otras", label = paste0("Otras (", n(), " actividades)"),
            grupo = "Tierras, multiprograma y otros",
            usd = sum(usd), share = sum(share)) %>% mutate(rank = TOPN + 1)

# Pareto VERTICAL con nombres envueltos en dos líneas (legibles, sin cortar)
df <- bind_rows(top, otras) %>%
  mutate(cum = cumsum(share),
         # etiqueta limpia y envuelta a ~2 líneas
         disp = label %>%
           str_replace("\\s*\\(atajados.*", " (atajados/pozos)") %>%
           str_replace("Multiprograma · Fomento a la produccion agricola", "Multiprograma (agrícola)") %>%
           str_replace("Multiprograma · Multiprograma agropecuario", "Multiprograma (agropec.)") %>%
           str_replace("Otros · ", "Otros ") %>%
           str_wrap(width = 20),
         disp = factor(disp, levels = disp))

p <- ggplot(df, aes(x = disp)) +
  geom_hline(yintercept = 80, linetype = "22", color = "gray60", linewidth = 0.4) +
  geom_col(aes(y = share, fill = grupo), width = 0.74) +
  # valor absoluto en USD sobre CADA barra (millones, const. 2015)
  geom_text(aes(y = share, label = paste0("$", round(usd))), vjust = -0.7, size = 2.5, color = "gray30") +
  # curva acumulada
  geom_line(aes(y = cum, group = 1), color = C_CUM, linewidth = 0.9) +
  geom_point(aes(y = cum), color = C_CUM, size = 1.7) +
  # marca del 80%
  annotate("text", x = n80 + 0.4, y = 84, hjust = 0, size = 3, fontface = "bold", color = C_CUM,
           label = paste0(n80, " actividades = 80%")) +
  scale_fill_manual(values = pal, name = NULL) +
  scale_y_continuous("Participación en el gasto agropecuario (%)",
                     breaks = seq(0,100,20), limits = c(0,104), expand = expansion(mult = c(0,0.02)),
                     sec.axis = sec_axis(~., name = "Acumulado (%)", breaks = seq(0,100,20))) +
  scale_x_discrete(NULL) +
  labs(
    title = paste0("Ocho de ", n_total, " actividades concentran el 80% del gasto público agropecuario, 2016–2024"),
    subtitle = paste0("Gasto devengado por actividad, promedio anual 2016–2024. La seguridad alimentaria (EMAPA, ",
                      round(df$share[1]), "%) y la construcción de riego (", round(df$share[2]), "%) encabezan.\nBarras: participación de cada actividad (%); la cifra sobre cada barra es el gasto anual en millones de USD constantes de 2015 ($); línea: acumulado (%)."),
    caption = paste0(
      "Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto devengado SIGEP, clasificación por actividad económica del sector agropecuario), deflactado a USD const. 2015. Ver ADR-0014.\n",
      "Nota: promedio anual 2016–2024 (", n_total, " actividades, código acteco 2.x). El color agrupa las actividades en cuatro categorías temáticas. 'Otras' reúne las ", n_total - TOPN,
      " actividades de menor monto. 2024 preliminar (CPI estimado, inflación INE ≈5,1%).")
  ) +
  guides(fill = guide_legend(nrow = 2, byrow = TRUE)) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 13, face = "bold", color = "#2C3E50", lineheight = 1.1),
    plot.subtitle = element_text(size = 9.4, color = "gray40", margin = margin(b = 8), lineheight = 1.05),
    plot.caption = element_text(size = 7.6, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
    plot.caption.position = "plot",
    legend.position = "top", legend.text = element_text(size = 8.4),
    axis.title.y = element_text(size = 9, color = "gray30"),
    axis.title.y.right = element_text(size = 9, color = C_CUM),
    axis.text.x = element_text(angle = 30, hjust = 1, vjust = 1, size = 6.8, color = "gray25", lineheight = 0.9),
    panel.grid.minor = element_blank(), panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 14, 10, 12)
  )

W <- 12.0; H <- 7.2
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_pareto_programas_agro.png"), p, width = W, height = H, dpi = 600, bg = "white")
if (requireNamespace("svglite", quietly = TRUE))
  ggsave(here("05_outputs","figures","svg","fig_pareto_programas_agro.svg"), p, width = W, height = H, bg = "white")
try(ggsave(here("05_outputs","figures","pdf","fig_pareto_programas_agro.pdf"), p, width = W, height = H, bg = "white"), silent = TRUE)

cat("\n✅ fig_pareto_programas_agro generada |", n80, "actividades =", usd80, "MM USD →80%\n")
print(as.data.frame(df %>% transmute(rank, label = str_trunc(label,40), grupo = str_trunc(grupo,16),
      usd = round(usd,1), share = round(share,1), cum = round(cum,1))), row.names = FALSE)
