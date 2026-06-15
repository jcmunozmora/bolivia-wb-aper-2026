# 22_fig_gasto_sectorial_total.R — Cap. 3: la agricultura en el GASTO PÚBLICO TOTAL por sector
# Enmarque: el gasto público agropecuario es ~2% del total y ocupa el puesto 14 de 24 sectores.
# Fuente: MEFP Presupuesto Abierto (gasto devengado total por sector económico/acteco), 2016-2024.
# Salida: gasto_sectorial_mefp.rds + fig_gasto_sectorial_total.* (600 DPI)

suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(jsonlite); library(ggplot2); library(scales); library(here)

RAW <- here("01_data","raw","external_gasto_2026")
files <- list.files(RAW, pattern="^acteco_\\d+\\.json$", full.names=TRUE)

sec <- map_dfr(files, function(f){
  d <- fromJSON(f)
  if(is.null(d$desc_acteco)) return(NULL)
  d$estados %>% as_tibble() %>% filter(gestion>0) %>%
    transmute(cod=d$acteco, sector=d$desc_acteco, year=gestion,
              monto_bs=total, pct_total=prop)
})
saveRDS(sec, here("01_data","processed","gasto_sectorial_mefp.rds"))

# --- Composición 2016 vs 2024: ranking por 2024, agro resaltado ---
YRS <- c(2016, 2024)
rank24 <- sec %>% filter(year==2024) %>% arrange(desc(pct_total)) %>% mutate(rank=row_number())
n_total <- nrow(rank24)
rank_agro <- rank24$rank[rank24$sector=="Agropecuario"]
keep_sec <- rank24 %>% filter(rank<=rank_agro) %>% arrange(rank) %>% pull(sector)

both  <- sec %>% filter(year %in% YRS, sector %in% keep_sec) %>% select(sector, year, pct_total)
otros <- sec %>% filter(year %in% YRS, !sector %in% keep_sec) %>%
  group_by(year) %>% summarise(sector="Otros sectores", pct_total=sum(pct_total), .groups="drop")
ord <- c(keep_sec, "Otros sectores")
plotdf <- bind_rows(both, otros) %>%
  mutate(sector=factor(sector, levels=rev(ord)), year_f=factor(year, levels=YRS))

agro_df <- plotdf %>% filter(sector=="Agropecuario")

p <- ggplot(plotdf, aes(pct_total, sector, fill=year_f)) +
  geom_col(position=position_dodge(width=0.72), width=0.66) +
  # resaltar el agro con borde rojo en sus dos barras
  geom_col(data=agro_df, aes(pct_total, sector, fill=year_f),
           position=position_dodge(width=0.72), width=0.66, color="#C00000", linewidth=0.9) +
  scale_fill_manual(values=c("2016"="#BBD0E8","2024"="#1F4E79"), name=NULL) +
  geom_text(aes(label=paste0(gsub("\\.",",",round(pct_total,1)),"%")),
            position=position_dodge(width=0.72), hjust=-0.15, size=2.5, color="gray30") +
  annotate("text", x=6.5, y="Agropecuario", label="estable ~2%\n(puesto 14)", hjust=0,
           color="#C00000", size=2.8, fontface="bold", lineheight=0.85) +
  scale_x_continuous(labels=label_number(suffix="%"), expand=expansion(mult=c(0,0.10)), limits=c(0,38)) +
  labs(
    title=paste0("La baja prioridad fiscal del agro no ha cambiado: puesto ", rank_agro, " de ", n_total, " sectores"),
    subtitle=paste0("Participación de cada sector económico en el gasto público total devengado, 2016 vs 2024. ",
                    "El agropecuario (resaltado en rojo)\nse mantuvo en torno al 2% en ambos años, muy por debajo de hidrocarburos (un tercio del gasto), educación y salud."),
    x=NULL, y=NULL,
    caption="Fuente: cálculo propio (Banco Mundial) sobre MEFP Presupuesto Abierto (gasto devengado por sector económico, 'acteco'). Barra clara = 2016; oscura = 2024. Participaciones invariantes a la deflación. Ver ADR-0012."
  ) +
  theme_minimal(base_size=11) +
  theme(
    plot.title=element_text(size=13,face="bold",color="#2C3E50"),
    plot.subtitle=element_text(size=9.5,color="gray40",margin=margin(b=8),lineheight=1.05),
    plot.caption=element_text(size=8,color="gray50",hjust=0,margin=margin(t=10),lineheight=1.1),
    plot.caption.position="plot",
    axis.text.y=element_text(size=9.5,color="gray20"),
    panel.grid.major.y=element_blank(), panel.grid.minor=element_blank(),
    panel.grid.major.x=element_line(color="gray92", linewidth=0.3),
    plot.margin=margin(12,16,10,12)
  )

for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings=FALSE, recursive=TRUE)
ggsave(here("05_outputs","figures","png","fig_gasto_sectorial_total.png"), p, width=10.5, height=6.2, dpi=600, bg="white")
ggsave(here("05_outputs","figures","svg","fig_gasto_sectorial_total.svg"), p, width=10.5, height=6.2, bg="white")
ggsave(here("05_outputs","figures","pdf","fig_gasto_sectorial_total.pdf"), p, width=10.5, height=6.2, bg="white")

cat("\n✅ fig_gasto_sectorial_total generada (", n_total, "sectores; agro puesto", rank_agro, ")\n")
cat("Share agropecuario en gasto total por año:\n")
print(sec %>% filter(sector=="Agropecuario") %>% transmute(year, pct_total=round(pct_total,2)) %>% as.data.frame(), row.names=FALSE)
