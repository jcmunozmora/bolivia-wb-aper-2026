# 29_fig_focalizacion_gasto_pobreza.R — Cap. 4: ¿el gasto agro se focaliza en la pobreza rural?
# Scatter municipal: gasto agropecuario per cápita rural (MEFP 2024) vs pobreza rural por NBI (INE Censo 2024).
# Mensaje: la nube es plana — el gasto por habitante rural NO crece con la necesidad (sin focalización).
# Fuentes: territorial_muni_mefp.rds (gasto), pobreza_municipal_nbi.rds (NBI rural),
#          focalizacion_gasto_pobreza.rds (coeficientes para anotar). Ver ADR-0017.
# Salida: fig_focalizacion_gasto_pobreza.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

norm2 <- function(x){ x<-toupper(trimws(x)); x<-iconv(x,to="ASCII//TRANSLIT"); x<-gsub("\\(.*?\\)","",x)
  x<-gsub(" DEL DEPARTAMENTO DE.*| DEL DEPTO.*| DE LA PROVINCIA.*","",x); x<-gsub("[^A-Z ]"," ",x)
  x<-gsub("\\bPUERTO (MAYOR|MENOR) DE ","",x); x<-gsub("\\bNUESTRA SENORA DE ","",x); x<-gsub("\\bSANTIAGO DE ","",x)
  x<-gsub("\\bVILLA ","",x); x<-gsub("  +"," ",x); x<-trimws(x); gsub(" ","",x) }

nbi <- readRDS(here("01_data","processed","pobreza_municipal_nbi.rds")) %>% filter(area=="Rural") %>%
  transmute(dn=dept_norm, nm=muni_norm, rural_pop=pop_2024, nbi=nbi_pct_2024)
gasto <- readRDS(here("01_data","processed","territorial_muni_mefp.rds")) %>% filter(year==2024) %>%
  group_by(entidad) %>% summarise(dept=first(dept), muni=first(muni_name), usd=sum(usd2015,na.rm=TRUE)*1e6, .groups="drop") %>%
  mutate(dn=norm2(dept), nm=norm2(muni))
d <- inner_join(nbi, gasto, by=c("dn","nm")) %>% filter(rural_pop>0, !is.na(usd), !is.na(nbi)) %>%
  mutate(gpc = usd/rural_pop)

r <- readRDS(here("01_data","processed","focalizacion_gasto_pobreza.rds"))
ann <- sprintf("Sin asociación: r de Pearson = %.2f · ρ de Spearman = %.2f (no significativa) · n = %d municipios",
               r$pearson_r, r$spearman_rho, r$n)
med <- median(d$gpc)

p <- ggplot(d, aes(nbi, gpc)) +
  geom_hline(yintercept = med, linetype = "22", color = "gray60", linewidth = 0.4) +
  annotate("text", x = 2, y = med*1.35, label = sprintf("mediana: USD %.0f/hab", med),
           hjust = 0, size = 2.8, color = "gray45") +
  geom_point(aes(size = rural_pop), color = "#1F4E79", alpha = 0.45, stroke = 0) +
  geom_smooth(method = "lm", se = TRUE, color = "#C00000", fill = "#C00000",
              linewidth = 0.7, alpha = 0.12, formula = y ~ x) +
  scale_size_area("Población rural", max_size = 7, labels = label_number(scale_cut = cut_short_scale()),
                  breaks = c(5000, 50000, 200000)) +
  scale_x_continuous("Pobreza rural — Necesidades Básicas Insatisfechas (% de la población rural, Censo 2024)",
                     limits = c(0, 100), breaks = seq(0, 100, 20), expand = expansion(mult = c(0.01, 0.02))) +
  scale_y_log10("Gasto agropecuario municipal por habitante rural (USD const. 2015, escala log)",
                labels = label_number(prefix = "$", accuracy = 1), breaks = c(1,10,100,1000,10000)) +
  annotation_logticks(sides = "l", colour = "gray70", size = 0.25, short = unit(0.04,"cm"),
                      mid = unit(0.07,"cm"), long = unit(0.10,"cm")) +
  labs(
    title = "El gasto agropecuario por habitante rural no se alinea con la pobreza rural municipal, 2024",
    subtitle = str_wrap(paste0("Cada punto es un municipio (área rural). El eje horizontal mide la necesidad (pobreza rural por NBI); ",
                "el vertical, el gasto agropecuario municipal por habitante rural. La recta ajustada es casi plana: ",
                "los municipios con más pobreza rural no reciben más gasto por habitante."), width = 118),
    caption = paste0(
      str_wrap(paste0("Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto agropecuario municipal devengado, acteco=2, 2024, USD const. 2015) y pobreza por Necesidades Básicas Insatisfechas del Censo 2024 (INE). ", ann, "."), width = 130),
      "\n",
      str_wrap("Nota: gasto agropecuario total de los gobiernos municipales dividido por la población rural de referencia (Censo 2024); eje vertical en escala logarítmica. 2024 preliminar. Ver ADR-0017.", width = 130))
  ) +
  theme_minimal(base_size = 11) +
  theme(
    plot.title = element_text(size = 13, face = "bold", color = "#2C3E50", lineheight = 1.1),
    plot.subtitle = element_text(size = 9.2, color = "gray40", margin = margin(b = 8), lineheight = 1.05),
    plot.caption = element_text(size = 7.4, color = "gray50", hjust = 0, margin = margin(t = 10), lineheight = 1.1),
    plot.caption.position = "plot",
    axis.title = element_text(size = 9, color = "gray30"),
    legend.position = c(0.90, 0.83), legend.title = element_text(size = 8), legend.text = element_text(size = 7.3),
    legend.background = element_rect(fill = alpha("white", 0.6), color = NA),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "gray92", linewidth = 0.3),
    plot.margin = margin(12, 14, 10, 12)
  )

W <- 8.8; H <- 7.0
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings = FALSE, recursive = TRUE)
ggsave(here("05_outputs","figures","png","fig_focalizacion_gasto_pobreza.png"), p, width = W, height = H, dpi = 600, bg = "white")
if (requireNamespace("svglite", quietly = TRUE))
  ggsave(here("05_outputs","figures","svg","fig_focalizacion_gasto_pobreza.svg"), p, width = W, height = H, bg = "white")
try(ggsave(here("05_outputs","figures","pdf","fig_focalizacion_gasto_pobreza.pdf"), p, width = W, height = H, bg = "white"), silent = TRUE)

cat("\n✅ fig_focalizacion_gasto_pobreza generada | n =", nrow(d),
    "| Pearson r =", round(r$pearson_r,3), "| Spearman rho =", round(r$spearman_rho,3), "\n")
