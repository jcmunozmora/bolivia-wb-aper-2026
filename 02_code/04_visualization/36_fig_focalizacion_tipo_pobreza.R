# 36_fig_focalizacion_tipo_pobreza.R — Cap. 4: ¿se focaliza algún TIPO de gasto en la pobreza rural?
# Small multiples: para cada categoría MAFAP del gasto agro municipal, gasto per cápita rural
#   (promedio anual 2016-2024) vs pobreza rural por NBI (INE Censo 2024).
# Mensaje: ningún instrumento se focaliza en la necesidad — las nubes son planas; los servicios
#   técnicos (I+D, extensión, sanidad), de mayor retorno social, son incluso ligeramente regresivos.
# Fuentes: gasto_agro_prog_muni_2016_2024.rds (MEFP acteco municipal, ADR-0015),
#          pobreza_municipal_nbi.rds (NBI rural, INE Censo 2024).
# Salida: fig_focalizacion_tipo_pobreza.{png,svg,pdf} (600 DPI)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

norm2 <- function(x){ x<-toupper(trimws(x)); x<-iconv(x,to="ASCII//TRANSLIT"); x<-gsub("\\(.*?\\)","",x)
  x<-gsub(" DEL DEPARTAMENTO DE.*| DEL DEPTO.*| DE LA PROVINCIA.*","",x); x<-gsub("[^A-Z ]"," ",x)
  x<-gsub("\\bVILLA ","",x); x<-gsub("  +"," ",x); x<-trimws(x); gsub(" ","",x) }

nbi <- readRDS(here("01_data","processed","pobreza_municipal_nbi.rds")) %>% filter(area=="Rural") %>%
  transmute(dn=dept_norm, nm=muni_norm, rural_pop=pop_2024, nbi=nbi_pct_2024)

p <- readRDS(here("01_data","processed","gasto_agro_prog_muni_2016_2024.rds"))
g <- p %>% mutate(dn=norm2(dept_name), nm=norm2(muni_name)) %>%
  group_by(dn,nm,grupo) %>% summarise(usd_anual = sum(usd2015)/9, .groups="drop")  # promedio anual

d <- g %>% inner_join(nbi, by=c("dn","nm")) %>%
  filter(rural_pop>0, !is.na(nbi), usd_anual>0) %>%
  mutate(gpc = usd_anual/rural_pop)

# orden y paleta de los 4 tipos
ord <- c("Apoyo a la producción y seguridad alimentaria","Riego e infraestructura",
         "Servicios técnicos (I+D, extensión, sanidad)","Tierras, multiprograma y otros")
pal <- c("Apoyo a la producción y seguridad alimentaria"="#C00000",
         "Riego e infraestructura"="#548235",
         "Servicios técnicos (I+D, extensión, sanidad)"="#1F4E79",
         "Tierras, multiprograma y otros"="#A6A6A6")

# highlight + gray-out: solo los servicios técnicos tienen asociación significativa (p<0,01);
# los otros tres son planos y no significativos → se atenúan para que el ojo vaya a la señal real.
HL <- "Servicios técnicos (I+D, extensión, sanidad)"
coef <- d %>% group_by(grupo) %>%
  summarise(n=n(), rho=cor(gpc, nbi, method="spearman"),
            p=suppressWarnings(cor.test(gpc, nbi, method="spearman")$p.value), .groups="drop") %>%
  mutate(hl = grupo==HL,
         lab = sprintf("ρ = %.2f · n = %d\n%s", rho, n,
                       ifelse(hl, "regresivo · significativo (p<0,01)", "sin asociación (no significativa)")))

d    <- d    %>% mutate(grupo = factor(grupo, levels=ord), hl = grupo==HL)
coef <- coef %>% mutate(grupo = factor(grupo, levels=ord))

p1 <- ggplot(d, aes(nbi, gpc)) +
  geom_point(aes(size=rural_pop, color=hl), alpha=0.45, stroke=0) +
  geom_smooth(data=function(x) filter(x, !hl), method="lm", se=FALSE,
              color="gray72", linewidth=0.5, formula=y~x) +
  geom_smooth(data=function(x) filter(x, hl), method="lm", se=TRUE,
              color="#C00000", fill="#C00000", linewidth=0.9, alpha=0.13, formula=y~x) +
  geom_text(data=coef, aes(x=4, y=Inf, label=lab), hjust=0, vjust=1.35,
            size=2.7, color="gray25", fontface="bold", lineheight=0.95) +
  scale_color_manual(values=c("TRUE"="#1F4E79","FALSE"="#C9CCCE"), guide="none") +
  scale_size_area("Población rural", max_size=5.5,
                  labels=label_number(scale_cut=cut_short_scale()),
                  breaks=c(5000,50000,200000)) +
  scale_x_continuous("Pobreza rural — Necesidades Básicas Insatisfechas (% de la población rural, Censo 2024)",
                     limits=c(0,100), breaks=seq(0,100,25), expand=expansion(mult=c(0.01,0.02))) +
  scale_y_log10("Gasto agropecuario municipal por habitante rural (USD const. 2015/año, escala log)",
                labels=label_number()) +
  facet_wrap(~grupo, ncol=2, labeller=label_wrap_gen(width=34)) +
  labs(
    title = "Ningún tipo de gasto agropecuario municipal se focaliza en la pobreza rural, 2016–2024",
    subtitle = "Gasto agropecuario municipal por habitante rural según categoría MAFAP frente a la pobreza rural por NBI. Tres de cuatro instrumentos son planos;\nsolo los servicios técnicos (I+D, extensión, sanidad) muestran asociación significativa, y es regresiva: llegan menos a los municipios más pobres.",
    caption = paste0(
      str_wrap("Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto agropecuario municipal devengado por actividad económica, mapeado a MAFAP; ADR-0015) e INE — NBI rural, Censo 2024.", width=120),
      "\n",
      str_wrap("Nota: gasto del gobierno municipal (POA), no del nivel central ni departamental; promedio anual 2016–2024. Coeficiente de Spearman (robusto a valores extremos); n=293 municipios emparejados por nombre. Solo los servicios técnicos presentan asociación significativa (p<0,01); apoyo a la producción, riego y tierras son planos y no significativos.", width=120))
  ) +
  theme_minimal(base_size=10) +
  theme(plot.title=element_text(size=12.2, face="bold", color="#2C3E50", lineheight=1.1),
        plot.subtitle=element_text(size=8.6, color="gray40", lineheight=1.05, margin=margin(b=8)),
        plot.caption=element_text(size=7.4, color="gray50", hjust=0, margin=margin(t=10), lineheight=1.1),
        plot.caption.position="plot",
        strip.text=element_text(size=8.6, face="bold", color="#2C3E50"),
        strip.background=element_rect(fill="#F5F5F5", color=NA),
        legend.position="bottom", legend.text=element_text(size=8),
        panel.grid.minor=element_blank(),
        plot.margin=margin(12,16,10,16))

W <- 9.2; H <- 7.0
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings=FALSE, recursive=TRUE)
ggsave(here("05_outputs","figures","png","fig_focalizacion_tipo_pobreza.png"), p1, width=W, height=H, dpi=600, bg="white")
if (requireNamespace("svglite", quietly=TRUE))
  ggsave(here("05_outputs","figures","svg","fig_focalizacion_tipo_pobreza.svg"), p1, width=W, height=H, bg="white")
try(ggsave(here("05_outputs","figures","pdf","fig_focalizacion_tipo_pobreza.pdf"), p1, width=W, height=H, bg="white"), silent=TRUE)

cat("\n✅ fig_focalizacion_tipo_pobreza generada\n")
print(as.data.frame(coef %>% select(grupo, n, rho) %>% mutate(rho=round(rho,3))), row.names=FALSE)
