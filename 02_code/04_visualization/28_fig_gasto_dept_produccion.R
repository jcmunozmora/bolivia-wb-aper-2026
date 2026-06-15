# 28_fig_gasto_dept_produccion.R — Cap. 4: gasto agro municipal vs producción por departamento
# Serie reciente MEFP: gasto agropecuario municipal total (devengado 2024, USD const. 2015) agregado por
# departamento, vs superficie cultivada (ENA 2015). Mensaje: la cuota departamental del gasto NO sigue la
# base productiva: Santa Cruz concentra la superficie pero recibe una cuota menor; los andinos, lo contrario.
# Fuente: territorial_muni_mefp.rds (MEFP) + territorial_dept.rds (ENA2015). Ver ADR-0015.
# Salida: fig_gasto_dept_produccion.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
# ggrepel vive en conda ds; bootstrap si falta
if (!requireNamespace("ggrepel", quietly = TRUE)) {
  cand <- c(Sys.getenv("R_GEO_LIBPATH"), file.path(path.expand("~"), "miniforge3/envs/ds/lib/R/library"))
  hit <- cand[nzchar(cand) & dir.exists(file.path(cand, "ggrepel"))]
  if (length(hit)) .libPaths(c(.libPaths(), hit[1]))
}
library(tidyverse); library(ggplot2); library(scales); library(ggrepel)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

YEAR <- 2024
norm <- function(x){ x<-toupper(trimws(x)); x<-iconv(x,to="ASCII//TRANSLIT"); gsub("[^A-Z ]","",x) }

# gasto agro municipal MEFP por departamento, 2024
g <- readRDS(here("01_data","processed","territorial_muni_mefp.rds")) %>%
  filter(year == YEAR, !is.na(dept)) %>%
  group_by(dept) %>% summarise(gasto = sum(usd2015, na.rm = TRUE), .groups = "drop") %>%
  mutate(dep = norm(dept))

# superficie cultivada ENA 2015 por departamento
sup <- readRDS(here("01_data","processed","territorial_dept.rds")) %>%
  group_by(dept_upper) %>% summarise(sup = mean(ena2015_sup_ha, na.rm = TRUE), .groups = "drop") %>%
  mutate(dep = norm(dept_upper))

d <- sup %>% left_join(g, by = "dep") %>% filter(!is.na(sup), sup > 0, !is.na(gasto)) %>%
  mutate(sup_pct = 100*sup/sum(sup), gasto_pct = 100*gasto/sum(gasto),
         dept = str_to_title(dept_upper), brecha = gasto_pct - sup_pct)

lim <- max(d$sup_pct, d$gasto_pct)*1.08

p <- ggplot(d, aes(sup_pct, gasto_pct)) +
  geom_abline(slope = 1, intercept = 0, linetype = "22", color = "gray55", linewidth = 0.4) +
  annotate("text", x = lim*0.80, y = lim*0.92, label = "gasto = producción", angle = 34, size = 2.9, color = "gray55") +
  annotate("text", x = lim*0.62, y = lim*0.10, label = "menos gasto que producción →", size = 2.8, color = "#C00000", hjust = 0) +
  annotate("text", x = lim*0.02, y = lim*0.92, label = "← más gasto que producción", size = 2.8, color = "#1F4E79", hjust = 0) +
  geom_point(aes(color = brecha < 0), size = 3.2) +
  ggrepel::geom_text_repel(aes(label = dept), size = 3.1, color = "gray20", seed = 1, max.overlaps = 20) +
  scale_color_manual(values = c("TRUE"="#C00000","FALSE"="#1F4E79"), guide = "none") +
  scale_x_continuous("Participación en la superficie cultivada nacional (%)", limits = c(0, lim),
                     expand = expansion(mult = c(0, 0.02))) +
  scale_y_continuous("Participación en el gasto agropecuario municipal (%)", limits = c(0, lim),
                     expand = expansion(mult = c(0, 0.02))) +
  labs(
    title = "La cuota departamental del gasto agropecuario no sigue la base productiva del territorio, 2024",
    subtitle = "Participación de cada departamento en la superficie cultivada nacional (ENA 2015) vs su participación en el gasto agropecuario municipal (MEFP, devengado 2024).\nPor encima de la diagonal: el departamento recibe más gasto que su peso productivo; por debajo: menos.",
    caption = "Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto agro municipal devengado, acteco=2, agregado por departamento, USD const. 2015) y superficie cultivada de la Encuesta Agropecuaria 2015 (INE). Ver ADR-0015.\nNota: gasto agropecuario total de los gobiernos municipales del departamento. 2024 preliminar."
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 13, face = "bold", color = "#2C3E50", lineheight = 1.1),
    plot.subtitle = element_text(size = 9.2, color = "gray40", margin = margin(b = 8), lineheight = 1.05),
    plot.caption = element_text(size = 7.6, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
    plot.caption.position = "plot",
    axis.title = element_text(size = 9, color = "gray30"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 14, 10, 12)
  )

W <- 8.8; H <- 7.0
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_gasto_dept_produccion.png"), p, width = W, height = H, dpi = 600, bg = "white")
if (requireNamespace("svglite", quietly = TRUE))
  ggsave(here("05_outputs","figures","svg","fig_gasto_dept_produccion.svg"), p, width = W, height = H, bg = "white")
try(ggsave(here("05_outputs","figures","pdf","fig_gasto_dept_produccion.pdf"), p, width = W, height = H, bg = "white"), silent = TRUE)

cat("\n✅ fig_gasto_dept_produccion (MEFP", YEAR, ") generada\n")
print(as.data.frame(d %>% transmute(dept, sup_pct=round(sup_pct,1), gasto_pct=round(gasto_pct,1), brecha=round(brecha,1)) %>% arrange(brecha)), row.names=FALSE)
