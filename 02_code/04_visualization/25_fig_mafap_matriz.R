# 25_fig_mafap_matriz.R — Cap. 3: matriz 2×2 de las categorías MAFAP (todo como % del gasto)
# Ejes: a quién (oferta/productor ↔ demanda/consumidor) × tipo (específico-privado ↔ bien público-general).
# Cada celda = categorías MAFAP + su % del gasto agropecuario (caso base conservador, EMAPA 50/50).
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(here)

serie <- readRDS(here("01_data","processed","gasto_agro_mafap_prog_serie.rds"))
p <- serie %>% group_by(mafap_cat) %>% summarise(mm=sum(mm),.groups="drop") %>%
  mutate(pct=100*mm/sum(mm)) %>% { setNames(.$pct, .$mafap_cat) }
f <- function(v) gsub("\\.",",",format(round(v,1),nsmall=1))

# 4 celdas: x (1=específico/privado, 2=general/bien público) · y (2=oferta, 1=demanda)
cells <- tribble(
  ~x,~y,~total,~titulo,~detalle,
  1,2, p["A"]+p["C"], "Apoyo privado al productor",
       paste0("A · Apoyo al productor  ", f(p["A"]),"%\nC · Otros agentes  ", f(p["C"]),"%"),
  2,2, p["D"]+p["E"], "Bienes públicos sectoriales",
       paste0("D · Servicios generales  ", f(p["D"]),"%\nE · Soporte rural  ", f(p["E"]),"%"),
  1,1, p["B"], "Apoyo privado al consumidor",
       paste0("B · Apoyo al consumidor  ", f(p["B"]),"%"),
  2,1, 0, "Bien público al consumidor",
       "(sin gasto registrado)\n0,0%"
) %>% mutate(
  pct_lab = paste0(f(total),"%"),
  fill = scales::col_numeric(c("#EAF0F8","#1F4E79"), domain=c(0,57))(total),
  tcol = if_else(total>28, "white", "#2C3E50"))

p_fig <- ggplot(cells, aes(x,y)) +
  geom_tile(aes(fill=fill), color="white", linewidth=3, width=0.96, height=0.96) +
  scale_fill_identity() +
  # % grande de la celda
  geom_text(aes(label=pct_lab, color=tcol), y=cells$y+0.30, size=8, fontface="bold") +
  # título de la celda
  geom_text(aes(label=titulo, color=tcol), y=cells$y+0.06, size=3.2, fontface="bold") +
  # detalle por categoría
  geom_text(aes(label=detalle, color=tcol), y=cells$y-0.22, size=2.9, lineheight=0.95) +
  scale_color_identity() +
  scale_x_continuous(breaks=c(1,2), position="top",
                     labels=c("Apoyo a agentes específicos\n(privado / apropiable)","Apoyo general al sector\n(bien público)")) +
  scale_y_continuous(breaks=c(2,1),
                     labels=c("Lado de la oferta\n(productor / sector)","Lado de la demanda\n(consumidor)")) +
  coord_equal(clip="off") +
  labs(
    title="El gasto agropecuario por categoría MAFAP, acumulado 2016–2024",
    subtitle=str_wrap(paste0("Composición del gasto agropecuario total como % del acumulado 2016–2024 ",
             "(caso base conservador, EMAPA split 50/50 A/B). Más de la mitad son bienes públicos ",
             "sectoriales (D, sobre todo riego); el resto, apoyo privado al productor (A) y al consumidor (B)."), 115),
    x=NULL, y=NULL,
    caption=str_wrap(paste0("Fuente: cálculo propio (Banco Mundial) sobre la descomposición programática del gasto agro ",
            "del MEFP (36 actividades, devengado acumulado 2016–2024). C ≈ 0 (solo pesca en cauces); ",
            "E = 0 (el riego se clasifica como bien público sectorial D6). Ver auditoría 2026-06-14."), 135)
  ) +
  theme_minimal(base_size=11) +
  theme(
    plot.title=element_text(size=13.5,face="bold",color="#2C3E50"),
    plot.subtitle=element_text(size=9.4,color="gray40",margin=margin(b=10),lineheight=1.05),
    plot.caption=element_text(size=8,color="gray50",hjust=0,margin=margin(t=12),lineheight=1.1),
    plot.caption.position="plot",
    axis.text.x=element_text(size=9.5,face="bold",color="#1F4E79"),
    axis.text.y=element_text(size=9.5,face="bold",color="#1F4E79"),
    panel.grid=element_blank(),
    plot.margin=margin(12,16,10,12)
  )

for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings=FALSE, recursive=TRUE)
ggsave(here("05_outputs","figures","png","fig_mafap_matriz_2x2.png"), p_fig, width=10.5, height=7.4, dpi=600, bg="white")
ggsave(here("05_outputs","figures","svg","fig_mafap_matriz_2x2.svg"), p_fig, width=10.5, height=7.4, bg="white")
cat("\n✅ fig_mafap_matriz_2x2 (limpia, % del gasto) generada\n")
print(cells %>% select(titulo,total) %>% mutate(total=round(total,1)) %>% as.data.frame(), row.names=FALSE)
