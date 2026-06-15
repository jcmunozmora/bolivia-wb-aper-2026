# 21_fig_composicion_sectorial.R — Cap. 3: la agricultura en el portafolio de inversión pública
# Composición de la inversión pública por sector económico, Bolivia 1990–2024 (% del total).
# Enmarque: la agricultura es una tajada pequeña y no prioritaria, que se contrae en los auges.
# Fuente: panel v12 (VIPFE/MEFP, inv_*_usd_mm). Shares = invariantes a la deflación.
# Salida: fig_composicion_sectorial_inversion.* (600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales); library(here)

m <- readRDS(here("01_data","processed","mafap_bolivia.rds")) %>% filter(year>=1990, year<=2024)

d <- m %>% transmute(
  year, total=inv_pub_total_usd_mm,
  Agropecuario      = inv_agro_usd_mm,
  Hidrocarburos     = inv_hidrocarb_usd_mm,
  `Otros productivos` = pmax(inv_productivos_usd_mm - coalesce(inv_agro_usd_mm,0) - coalesce(inv_hidrocarb_usd_mm,0), 0),
  Infraestructura   = inv_infraestr_usd_mm,
  Social            = inv_sociales_usd_mm,
  Multisectorial    = inv_multisec_usd_mm
) %>%
  pivot_longer(-c(year,total), names_to="sector", values_to="usd") %>%
  filter(!is.na(usd)) %>%
  mutate(share = 100*usd/total)

orden <- c("Agropecuario","Otros productivos","Hidrocarburos","Infraestructura","Social","Multisectorial")
pal <- c("Agropecuario"="#C00000","Otros productivos"="#E8A0A0","Hidrocarburos"="#7F7F7F",
         "Infraestructura"="#1F4E79","Social"="#548235","Multisectorial"="#BFBFBF")
d <- d %>% mutate(sector=factor(sector, levels=rev(orden)))

agro <- d %>% filter(sector=="Agropecuario")

p <- ggplot(d, aes(year, share, fill=sector)) +
  geom_area(alpha=0.92, color="white", linewidth=0.15) +
  scale_fill_manual(values=pal, breaks=orden, name=NULL) +
  # etiquetas de la franja agro (abajo) en años clave
  geom_text(data=agro %>% filter(year %in% c(1990,2008,2024)),
            aes(y=share/2, label=paste0(gsub("\\.",",",round(share,1)),"%")),
            color="white", fontface="bold", size=2.9) +
  scale_x_continuous(breaks=seq(1990,2024,6), expand=c(0.01,0)) +
  scale_y_continuous(labels=label_number(suffix="%"), expand=c(0,0)) +
  labs(
    title="La agricultura es una tajada pequeña del portafolio de inversión pública boliviana",
    subtitle="Composición de la inversión pública por sector económico, 1990–2024 (% del total). El sector agropecuario (en rojo) recibe\nentre 6% y 11% de la inversión, muy por debajo de infraestructura y social, y su participación se contrae en los auges.",
    x=NULL, y="Participación en la inversión pública (%)",
    caption="Fuente: cálculo propio (Banco Mundial) sobre panel v12 (VIPFE/MEFP, inversión pública por sector). Las participaciones son invariantes a la deflación. 'Otros productivos' = minería, industria, turismo y energía."
  ) +
  theme_minimal(base_size=11) +
  theme(
    plot.title=element_text(size=13,face="bold",color="#2C3E50"),
    plot.subtitle=element_text(size=9.6,color="gray40",margin=margin(b=8),lineheight=1.05),
    plot.caption=element_text(size=8,color="gray50",hjust=0,margin=margin(t=10),lineheight=1.1),
    plot.caption.position="plot",
    legend.position="right", legend.text=element_text(size=8.8),
    axis.title.y=element_text(size=9.5,color="gray30"),
    panel.grid.minor=element_blank(), panel.grid.major.x=element_blank(),
    panel.grid.major.y=element_line(color="gray92", linewidth=0.3),
    plot.margin=margin(12,14,10,12)
  )

for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings=FALSE, recursive=TRUE)
ggsave(here("05_outputs","figures","png","fig_composicion_sectorial_inversion.png"), p, width=11, height=6, dpi=600, bg="white")
ggsave(here("05_outputs","figures","svg","fig_composicion_sectorial_inversion.svg"), p, width=11, height=6, bg="white")
ggsave(here("05_outputs","figures","pdf","fig_composicion_sectorial_inversion.pdf"), p, width=11, height=6, bg="white")

cat("\n✅ fig_composicion_sectorial_inversion generada\n")
cat("Share agro (% inversión total):\n")
print(agro %>% filter(year %in% c(1990,2000,2008,2015,2020,2024)) %>% transmute(year, agro_pct=round(share,1)) %>% as.data.frame(), row.names=FALSE)
EOF
