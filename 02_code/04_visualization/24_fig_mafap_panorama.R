# 24_fig_mafap_panorama.R — Cap. 3: panorama A–E (small multiples, una panel por categoría)
# Trayectoria de cada categoría MAFAP como % del gasto agropecuario, 2016–2024 (caso base 50/50).
# Acompaña el análisis individual por componente.
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales); library(here)

serie <- readRDS(here("01_data","processed","gasto_agro_mafap_prog_serie.rds"))
lab <- c(A="A · Apoyo al productor", B="B · Apoyo al consumidor", C="C · Otros agentes",
         D="D · Bienes públicos (servicios generales)", E="E · Soporte rural")
col <- c(A="#C00000", B="#7030A0", C="#A6A6A6", D="#548235", E="#BF8F00")
s <- serie %>% mutate(facet=factor(lab[mafap_cat], levels=lab), col=col[mafap_cat])

p <- ggplot(s, aes(year, pct)) +
  geom_area(aes(fill=col), alpha=0.18) +
  geom_line(aes(color=col), linewidth=1.2) +
  geom_point(aes(color=col), size=1.3) +
  # etiqueta del valor en 2016 y 2024
  geom_text(data=s %>% filter(year %in% c(2016,2024)),
            aes(label=paste0(round(pct),"%"), color=col,
                hjust=if_else(year==2016,0,1)),
            vjust=-0.7, size=2.9, fontface="bold", show.legend=FALSE) +
  scale_color_identity() + scale_fill_identity() +
  facet_wrap(~facet, nrow=1) +
  scale_x_continuous(breaks=c(2016,2020,2024), expand=expansion(mult=c(0.08,0.08))) +
  scale_y_continuous(labels=label_number(suffix="%"), limits=c(0, NA), expand=expansion(mult=c(0,0.18))) +
  labs(
    title="Panorama del gasto agropecuario boliviano por categoría MAFAP, 2016–2024",
    subtitle="Cada panel: participación de la categoría en el gasto agropecuario total (caso base conservador, EMAPA split 50/50). El apoyo privado (A productor, B consumidor) crece; los bienes públicos (D) ceden; C y E son nulos.",
    x=NULL, y="% del gasto agropecuario",
    caption="Fuente: cálculo propio (Banco Mundial) sobre la descomposición programática del gasto agro del MEFP (36 actividades) clasificada a MAFAP. Ver ADR-0009/0010 y auditoría 2026-06-14. E=0 porque el riego se clasifica como D6 (bien público sectorial)."
  ) +
  theme_minimal(base_size=10) +
  theme(
    plot.title=element_text(size=13,face="bold",color="#2C3E50"),
    plot.subtitle=element_text(size=9,color="gray40",margin=margin(b=6),lineheight=1.05),
    plot.caption=element_text(size=7.6,color="gray50",hjust=0,margin=margin(t=10),lineheight=1.1),
    plot.caption.position="plot",
    strip.text=element_text(face="bold",size=8.6,color="#2C3E50"),
    panel.grid.minor=element_blank(), panel.grid.major.x=element_blank(),
    panel.grid.major.y=element_line(color="gray92",linewidth=0.3),
    plot.margin=margin(12,12,8,12)
  )

for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings=FALSE, recursive=TRUE)
ggsave(here("05_outputs","figures","png","fig_mafap_panorama_ABCDE.png"), p, width=13, height=4.2, dpi=600, bg="white")
ggsave(here("05_outputs","figures","svg","fig_mafap_panorama_ABCDE.svg"), p, width=13, height=4.2, bg="white")
cat("\n✅ fig_mafap_panorama_ABCDE generada\n")
