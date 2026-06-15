# 25_fig_concentracion_municipal.R — Cap. 4: concentración del gasto agro municipal (Lorenz + Gini)
# Serie reciente MEFP (gasto agro TOTAL por municipio, devengado, 2016-2024). Compara 2016 vs 2024.
# Mensaje: el gasto agropecuario municipal se mantiene moderadamente concentrado y estable (Gini ~0,6).
# Fuente: territorial_muni_mefp.rds (MEFP Presupuesto Abierto, USD const. 2015). Ver ADR-0015.
# Salida: fig_concentracion_gasto_muni.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

tm <- readRDS(here("01_data","processed","territorial_muni_mefp.rds"))

gini <- function(x){ x <- sort(x[!is.na(x) & x >= 0]); n <- length(x)
  if (n < 2 || sum(x) == 0) return(NA_real_); 2*sum(seq_len(n)*x)/(n*sum(x)) - (n+1)/n }
lorenz <- function(df, yr){
  x <- sort(df$usd2015[df$year==yr & !is.na(df$usd2015) & df$usd2015>=0]); n <- length(x)
  tibble(serie = paste0(yr), p = c(0, seq_len(n)/n), L = c(0, cumsum(x)/sum(x)),
         gini = gini(x), n = n,
         top10 = round(100*sum(rev(x)[1:10])/sum(x)))
}
L <- bind_rows(lorenz(tm, 2016), lorenz(tm, 2024))
s16 <- L %>% filter(serie=="2016") %>% slice(1); s24 <- L %>% filter(serie=="2024") %>% slice(1)
f2 <- function(x) formatC(x, format="f", digits=2, decimal.mark=",")

pal <- c("2016" = "#A6A6A6", "2024" = "#1F4E79")

p <- ggplot(L, aes(p*100, L*100, color = serie)) +
  geom_abline(slope = 1, intercept = 0, linetype = "22", color = "gray60", linewidth = 0.4) +
  annotate("text", x = 80, y = 86, label = "igualdad perfecta", angle = 33, size = 2.8, color = "gray55") +
  geom_line(linewidth = 1.1) +
  scale_color_manual(values = pal, guide = "none") +
  annotate("text", x = 50, y = 30, hjust = 0, size = 3.0, color = "#1F4E79", fontface = "bold",
           lineheight = 0.95, label = paste0("2024\nGini ", f2(s24$gini), " · 10 munis = ", s24$top10, "%")) +
  annotate("text", x = 68, y = 11, hjust = 0, size = 3.0, color = "#7F7F7F", fontface = "bold",
           lineheight = 0.95, label = paste0("2016\nGini ", f2(s16$gini), " · 10 munis = ", s16$top10, "%")) +
  scale_x_continuous("Municipios ordenados de menor a mayor gasto (acumulado, %)",
                     breaks = seq(0,100,25), limits = c(0,100), expand = expansion(mult = c(0,0.02))) +
  scale_y_continuous("Gasto agropecuario acumulado (%)",
                     breaks = seq(0,100,25), limits = c(0,100), expand = expansion(mult = c(0,0.02))) +
  labs(
    title = paste0("El gasto agropecuario municipal se mantiene moderadamente concentrado: Gini ≈ 0,6 sin cambio entre 2016 y 2024"),
    subtitle = paste0("Curva de Lorenz del gasto agropecuario total por municipio (devengado), ", s24$n, " municipios en 2024. Cuanto más se aleja de la diagonal, mayor la concentración.\nLos diez municipios mayores ejecutan cerca de una cuarta parte del gasto agropecuario municipal; la distribución es estable en la última década."),
    caption = "Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto agro municipal devengado, acteco=2), deflactado a USD const. 2015. Ver ADR-0015.\nNota: gasto agropecuario total por Gobierno Autónomo Municipal (no separa instrumentos). 2024 preliminar (CPI estimado, inflación INE ≈5,1%)."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 12.5, face = "bold", color = "#2C3E50", lineheight = 1.1),
    plot.subtitle = element_text(size = 9.2, color = "gray40", margin = margin(b = 8), lineheight = 1.05),
    plot.caption = element_text(size = 7.6, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
    plot.caption.position = "plot",
    axis.title = element_text(size = 9, color = "gray30"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 14, 10, 12)
  )

W <- 9.6; H <- 6.6
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_concentracion_gasto_muni.png"), p, width = W, height = H, dpi = 600, bg = "white")
if (requireNamespace("svglite", quietly = TRUE))
  ggsave(here("05_outputs","figures","svg","fig_concentracion_gasto_muni.svg"), p, width = W, height = H, bg = "white")
try(ggsave(here("05_outputs","figures","pdf","fig_concentracion_gasto_muni.pdf"), p, width = W, height = H, bg = "white"), silent = TRUE)

cat("\n✅ fig_concentracion_gasto_muni (MEFP 2016 vs 2024) | Gini 2016:", round(s16$gini,3),
    "(top10", paste0(s16$top10,"%)"), "| 2024:", round(s24$gini,3), "(top10", paste0(s24$top10,"%)"), "\n")
