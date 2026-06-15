# 20_fig_credito_profundizacion.R — Cap. 3 §3.4 (F05): cartera agropecuaria (crédito dirigido)
# Figura simple de un panel: cartera bancaria al sector agropecuario en USD CONSTANTES de 2015
#   + su participación (%) en la cartera total. Headline del hallazgo F05.
# Fuente: BCB Boletín Estadístico Cuadro 3.02 (solo banca múltiple). Deflactor CPI Bolivia 2015=100.
# Salida: fig_cartera_agro_2010_2024.* (600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales); library(here)

FX2015 <- 6.91  # BOB/USD 2015 (peg)
m <- readRDS(here("01_data","processed","mafap_bolivia.rds")) %>% filter(year>=2010, year<=2024)

a <- m %>% transmute(
  year,
  cpi = if_else(year==2024 & is.na(cpi_2015base), 117.7729*1.051, cpi_2015base),  # 2024 estimado INE ~5,1%
  # cartera: BOB corriente → BOB const. 2015 → USD const. 2015
  cartera_usd2015 = (bcb_cred_agro_mm_bs / (cpi/100)) / FX2015,
  share = bcb_cred_agro_pct_total
)

factor_real <- round(a$cartera_usd2015[a$year==2024] / a$cartera_usd2015[a$year==2010], 1)
escala <- max(a$cartera_usd2015)/max(a$share)

# etiquetas de % sobre la curva de participación (rojo oscuro, legibles)
lab_curve <- a %>% filter(year %in% c(2010, 2014, 2018, 2024))

p <- ggplot(a, aes(year)) +
  geom_col(aes(y=cartera_usd2015), fill="#1F4E79", width=0.72, alpha=0.92) +
  geom_line(aes(y=share*escala), color="#C00000", linewidth=1.2) +
  geom_point(aes(y=share*escala), color="#C00000", size=1.8) +
  # % de participación sobre la curva, en rojo oscuro y por encima de la línea
  geom_text(data=lab_curve, aes(y=share*escala, label=paste0(gsub("\\.",",",round(share,1)),"%")),
            color="#900000", fontface="bold", size=3.1, vjust=-1.0) +
  # valor de la cartera: solo USD, en azul (sin blanco)
  annotate("text", x=2010, y=a$cartera_usd2015[a$year==2010],
           label="USD 385 M", vjust=-0.8, size=2.9, color="#1F4E79", fontface="bold") +
  annotate("text", x=2024, y=a$cartera_usd2015[a$year==2024],
           label="USD\n2.725 M", vjust=1.3, size=2.2, color="white", fontface="bold", lineheight=0.85) +
  scale_y_continuous(name="Cartera agropecuaria (USD const. 2015, millones)", labels=label_comma(),
                     expand=expansion(mult=c(0,0.13)),
                     sec.axis=sec_axis(~./escala, name="% de la cartera total",
                                       labels=label_number(suffix="%"))) +
  scale_x_continuous(breaks=seq(2010,2024,2)) +
  labs(
    title="El crédito dirigido al agro se multiplicó y duplicó su peso en la cartera bancaria",
    subtitle=paste0("Cartera bancaria al sector agropecuario (USD constantes de 2015) y su participación en la cartera total, 2010–2024.\nEn términos reales la cartera se multiplicó por ", factor_real, " y su participación pasó de 5,1% a 11,7% (hallazgo F05)."),
    x=NULL,
    caption="Fuente: cálculo propio (Banco Mundial) sobre BCB Boletín Estadístico Cuadro 3.02 (solo banca múltiple; subestima el crédito total del sistema). Deflactado a USD constantes de 2015 con el CPI de Bolivia (INE, 2015=100; 2024 preliminar). Régimen de cuotas y tasas reguladas: Ley 393/2014."
  ) +
  theme_minimal(base_size=11) +
  theme(
    plot.title=element_text(size=13.5,face="bold",color="#2C3E50"),
    plot.subtitle=element_text(size=9.6,color="gray40",margin=margin(b=8),lineheight=1.05),
    plot.caption=element_text(size=8,color="gray50",hjust=0,margin=margin(t=10),lineheight=1.1),
    plot.caption.position="plot",
    axis.title.y.left=element_text(size=9.5,color="#1F4E79"),
    axis.title.y.right=element_text(size=9.5,color="#C00000"), axis.text.y.right=element_text(color="#C00000"),
    panel.grid.minor=element_blank(), panel.grid.major.x=element_blank(),
    panel.grid.major.y=element_line(color="gray92", linewidth=0.3),
    plot.margin=margin(12,14,10,12)
  )

for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings=FALSE, recursive=TRUE)
ggsave(here("05_outputs","figures","png","fig_cartera_agro_2010_2024.png"), p, width=10.5, height=5.8, dpi=600, bg="white")
ggsave(here("05_outputs","figures","svg","fig_cartera_agro_2010_2024.svg"), p, width=10.5, height=5.8, bg="white")
ggsave(here("05_outputs","figures","pdf","fig_cartera_agro_2010_2024.pdf"), p, width=10.5, height=5.8, bg="white")
# limpiar la versión anterior de 2 paneles
for (s in c("png","svg","pdf")) { f<-here("05_outputs","figures",s,paste0("fig_credito_instrumentos.",s)); if(file.exists(f)) file.remove(f) }

cat("\n✅ fig_cartera_agro_2010_2024 generada (USD const. 2015)\n")
cat("Cartera USD const 2015:", round(a$cartera_usd2015[a$year==2010]), "(2010) →", round(a$cartera_usd2015[a$year==2024]), "(2024) = ×", factor_real, "real\n")
cat("(vs ×11,7 en USD corrientes — la diferencia es inflación)\n")
