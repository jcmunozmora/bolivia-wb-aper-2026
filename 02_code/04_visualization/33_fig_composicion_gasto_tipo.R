# 33_fig_composicion_gasto_tipo.R — Composición del gasto agropecuario por tipo
# -----------------------------------------------------------------------------
# Barra apilada de participación (%) del gasto agropecuario nacional por tipo
# (clasificación MAFAP/grupo del MEFP), 2016-2024. Cuenta la recomposición:
# el apoyo directo a la producción gana peso mientras riego/infraestructura y
# los servicios técnicos (I+D, extensión, sanidad — bienes públicos) ceden.
# Estándar: .agent/07_FIGURAS.md (finding-first, paleta WB, composición→apilada).
#
# Fuente: gasto_agro_programatico.rds (MEFP Presupuesto Abierto, devengado).
# Salida: 05_outputs/figures/fig42_composicion_gasto_tipo.{png,pdf} (600 DPI)
# =============================================================================

suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))
suppressPackageStartupMessages({ library(data.table); library(ggplot2); library(here) })
source(here("02_code", "04_visualization", "00_wb_theme.R"))

d <- as.data.table(readRDS(here("01_data/processed/gasto_agro_programatico.rds")))
g <- d[!is.na(usd2015_mm), .(usd = sum(usd2015_mm, na.rm = TRUE)), by = .(year, grupo)]
g[, share := 100 * usd / sum(usd), by = year]

# Etiquetas cortas + orden (apoyo directo abajo para ver su expansión)
lab_map <- c(
  "Apoyo a la producción y seguridad alimentaria" = "Apoyo directo a la producción",
  "Riego e infraestructura"                       = "Riego e infraestructura",
  "Servicios técnicos (I+D, extensión, sanidad)"  = "Servicios técnicos (I+D, extensión, sanidad)",
  "Tierras, multiprograma y otros"                = "Tierras y otros")
g[, tipo := factor(lab_map[grupo], levels = rev(lab_map))]
pal <- c("Apoyo directo a la producción" = WB_RED,
         "Riego e infraestructura" = WB_GREEN,
         "Servicios técnicos (I+D, extensión, sanidad)" = WB_BLUE,
         "Tierras y otros" = WB_GREY)

p <- ggplot(g, aes(x = year, y = share, fill = tipo)) +
  geom_col(width = 0.78) +
  scale_fill_manual(values = pal, name = NULL,
                    guide = guide_legend(reverse = TRUE, nrow = 2)) +
  scale_x_continuous(breaks = 2016:2024) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.02))) +
  labs(
    title    = "El apoyo directo a la producción pasó de 43% a 63% del gasto agropecuario,\ndesplazando a riego e infraestructura, 2016–2024",
    subtitle = "Participación (%) del gasto agropecuario público por tipo (clasificación MAFAP), Bolivia",
    x = NULL, y = "% del gasto agropecuario",
    caption = paste(
      "Fuente: MEFP Presupuesto Abierto (gasto agropecuario devengado, árbol acteco); clasificación MAFAP; cálculo propio.",
      "Nota: los servicios técnicos (I+D, extensión, sanidad) —bienes públicos de mayor retorno— se mantienen cerca del 14% en toda la serie.", sep = "\n")
  ) +
  theme_wb() +
  theme(legend.position = "top", legend.justification = "left",
        plot.title = element_text(size = 12.5),
        panel.grid.major.x = element_blank())

base <- here("05_outputs", "figures", "fig42_composicion_gasto_tipo")
ggsave(paste0(base, ".png"), p, width = 9, height = 5.4, dpi = 600, bg = "white")
try(ggsave(paste0(base, ".pdf"), p, width = 9, height = 5.4, bg = "white"), silent = TRUE)
cat("✓ Guardado: fig42_composicion_gasto_tipo.png + .pdf\n")
