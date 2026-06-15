# 26_fig_mapa_muni_gasto.R — Cap. 4: mapa coroplético del gasto agropecuario municipal TOTAL, 2024
# Mensaje: distribución territorial del gasto agropecuario total municipal (MEFP) por municipio.
# Reemplaza la versión p10-2020 (Jubileo): el dato 2024 solo existe como gasto agro total (MEFP,
# acteco=2), alineando el mapa con las figuras de concentración y top-municipios (ya MEFP 2024).
# NOTA sf: el stack espacial vive en el entorno conda 'ds', no en renv. Se añade su librería
#   al .libPaths (mismo R-4.3, seguro). Fix permanente: renv::install("sf").
# Fuente: adm3_muni_gasto_agro_2024.rds (51_prep_territorial_mapa_2024.R). Ver ADR-0015 §5.
# Salida: fig_mapa_muni_gasto_agro_2024.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
# --- bootstrap sf desde conda ds si renv no lo trae ---
if (!requireNamespace("sf", quietly = TRUE)) {
  cand <- c(Sys.getenv("R_GEO_LIBPATH"),
            file.path(path.expand("~"), "miniforge3/envs/ds/lib/R/library"))
  hit <- cand[nzchar(cand) & dir.exists(file.path(cand, "sf"))]
  if (length(hit)) .libPaths(c(.libPaths(), hit[1]))
}
stopifnot(requireNamespace("sf", quietly = TRUE))
library(tidyverse); library(ggplot2); library(scales); library(sf)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

# Gasto agro total municipal 2024 en USD const. 2015 (ya deflactado en 50/51_prep). Sin re-deflactar.
a <- readRDS(here("01_data","processed","adm3_muni_gasto_agro_2024.rds")) %>%
  rename(usd2015_agro = usd2015)

# clasificación en quintiles del gasto positivo (mapa legible pese a la asimetría)
pos  <- a$usd2015_agro[!is.na(a$usd2015_agro) & a$usd2015_agro > 0]
brks <- quantile(pos, probs = seq(0, 1, 0.2)); brks[1] <- 0
lab5 <- paste0(formatC(brks[-6], format="f", digits=2), "–", formatC(brks[-1], format="f", digits=2))
a <- a %>% mutate(
  cl = cut(usd2015_agro, breaks = brks, include.lowest = TRUE, labels = lab5),
  cl = fct_na_value_to_level(cl, "Sin gasto"),
  cl = fct_relevel(cl, "Sin gasto"))
pal5 <- c("Sin gasto" = "grey90",
          setNames(c("#DCE6F1","#A9C2E0","#6E97C7","#3E6BA6","#1F4E79"), lab5))

# bordes departamentales (disolver municipios por departamento; dept recuperado al 100% en 51_prep)
dep <- a %>% group_by(dept) %>% summarise(.groups = "drop")
maxmuni <- a$muni_name[which.max(a$usd2015_agro)]; maxval <- max(a$usd2015_agro, na.rm=TRUE)

p <- ggplot() +
  geom_sf(data = a, aes(fill = cl), color = "white", linewidth = 0.08) +
  geom_sf(data = dep, fill = NA, color = "gray40", linewidth = 0.3) +
  scale_fill_manual(values = pal5, name = "Gasto agropecuario municipal total (millones de USD constantes de 2015)") +
  guides(fill = guide_legend(nrow = 1, title.position = "top", title.hjust = 0,
                             keywidth = unit(0.55, "cm"), keyheight = unit(0.30, "cm"))) +
  labs(
    title = "El gasto agropecuario municipal es bajo y disperso en todo el territorio, 2024",
    subtitle = str_wrap(paste0("Gasto agropecuario total devengado por el gobierno municipal (MEFP), millones de USD constantes de 2015, en quintiles. ",
                      "El mayor es Sucre (USD 1,8 millones); 339 municipios."), width = 96),
    caption = paste0(
      str_wrap("Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto agropecuario total devengado, acteco=2) y límites municipales geoBoundaries ADM3. Deflactado a USD const. 2015. Ver ADR-0015.", width = 128),
      "\n",
      str_wrap("Nota: el gris indica municipios sin registro de gasto agropecuario en MEFP 2024 o sin emparejamiento de nombre (homónimos sin código INE); el mapa representa el 98% del gasto agropecuario municipal 2024.", width = 128))
  ) +
  theme_void(base_size = 11) +
  theme(
    plot.title = element_text(size = 12.5, face = "bold", color = "#2C3E50", lineheight = 1.1, hjust = 0),
    plot.subtitle = element_text(size = 9.4, color = "gray40", margin = margin(t = 2, b = 6), lineheight = 1.05, hjust = 0),
    plot.caption = element_text(size = 7.6, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
    legend.position = "bottom", legend.direction = "horizontal", legend.justification = "center",
    legend.title = element_text(size = 8.2), legend.text = element_text(size = 7.3),
    legend.margin = margin(t = 4, b = 0), legend.box.spacing = unit(2, "pt"),
    plot.margin = margin(12, 14, 10, 12)
  )

W <- 8.6; H <- 8.4
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_mapa_muni_gasto_agro_2024.png"), p, width = W, height = H, dpi = 600, bg = "white")
if (requireNamespace("svglite", quietly = TRUE))
  ggsave(here("05_outputs","figures","svg","fig_mapa_muni_gasto_agro_2024.svg"), p, width = W, height = H, bg = "white")
try(ggsave(here("05_outputs","figures","pdf","fig_mapa_muni_gasto_agro_2024.pdf"), p, width = W, height = H, bg = "white"), silent = TRUE)

cat("\n✅ fig_mapa_muni_gasto_agro_2024 generada | agro total USD2015 rango:",
    paste(round(range(a$usd2015_agro, na.rm=TRUE),2), collapse=" - "),
    "| top:", maxmuni, round(maxval,2), "\n")
