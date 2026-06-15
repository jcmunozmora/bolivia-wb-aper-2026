# 23_fig_mafap_programatico.R — Cap. 3: MAFAP reconstruido desde el presupuesto real (3 figuras)
# FIG 1: recomposición A vs D 2016-2024 (A cruza a D en 2022).
# FIG 2: sensibilidad EMAPA — el pivote A vs B (A1-puro vs split).
# FIG 3: desglose de D — los bienes públicos son sobre todo riego.
# Fuente: MEFP descomposición programática (36 actividades), mapeo consenso (workflow 2026-06-14).
# Composición en %, invariante a la deflación. Ver ADR-0009/0010.

suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(ggplot2); library(scales); library(patchwork); library(here)

P <- here("01_data","processed")
cls   <- readRDS(file.path(P,"gasto_agro_mafap_prog.rds"))
serie <- readRDS(file.path(P,"gasto_agro_mafap_prog_serie.rds"))

CA<-"#C00000"; CB<-"#7030A0"; CC<-"#A6A6A6"; CD<-"#548235"

# ============================================================================
# FIG 1 — Recomposición A vs D (100% apilado)
# ============================================================================
catlab <- c(A="A — Apoyo al productor", B="B — Apoyo al consumidor", C="C — Otros agentes",
            D="D — Bienes públicos (servicios generales)", E="E — Soporte rural")
niv <- rev(c("A — Apoyo al productor","B — Apoyo al consumidor","C — Otros agentes","E — Soporte rural",
             "D — Bienes públicos (servicios generales)"))  # D base abajo, A/B arriba
s1 <- serie %>% mutate(cat=factor(recode(mafap_cat, !!!catlab), levels=niv))
# etiquetas D (banda inferior), B (media), A (superior) en 2016 y 2024
lab1 <- s1 %>% group_by(year) %>% arrange(match(mafap_cat,c("A","B","C","E","D"))) %>%
  mutate(ypos=cumsum(pct)-pct/2) %>% ungroup() %>%
  filter(year %in% c(2016,2024), mafap_cat %in% c("A","B","D"))
p1 <- ggplot(s1, aes(year, pct, fill=cat)) +
  geom_area(alpha=0.92, color="white", linewidth=0.2) +
  scale_fill_manual(values=c("A — Apoyo al productor"=CA,"B — Apoyo al consumidor"=CB,
                             "C — Otros agentes"=CC,"D — Bienes públicos (servicios generales)"=CD,
                             "E — Soporte rural"="#BF8F00"),
                    breaks=c("A — Apoyo al productor","B — Apoyo al consumidor","C — Otros agentes",
                             "D — Bienes públicos (servicios generales)","E — Soporte rural"),
                    labels=c("A · Productor","B · Consumidor","C · Otros agentes",
                             "D · Bienes públicos","E · Soporte rural"), name=NULL) +
  guides(fill=guide_legend(nrow=1)) +
  geom_text(data=filter(lab1,year==2016), aes(y=ypos,label=paste0(round(pct),"%")),
            x=2016.15, hjust=0, color="white", fontface="bold", size=2.9) +
  geom_text(data=filter(lab1,year==2024), aes(y=ypos,label=paste0(round(pct),"%")),
            x=2023.85, hjust=1, color="white", fontface="bold", size=2.9) +
  scale_x_continuous(breaks=seq(2016,2024,2), expand=c(0.01,0)) +
  scale_y_continuous(labels=label_number(suffix="%"), expand=c(0,0)) +
  labs(title="El apoyo al productor y al consumidor desplaza a los bienes públicos",
       subtitle="Composición MAFAP A–E del gasto agropecuario, caso base conservador (EMAPA split 50/50 A/B), 2016–2024.\nC (otros agentes) ≈ 0,1% y E (soporte rural) = 0: el riego se clasifica como bien público sectorial (D6), no como E.",
       x=NULL, y="% del gasto agropecuario") +
  theme_minimal(base_size=10) +
  theme(plot.title=element_text(size=11.5,face="bold",color="#2C3E50"),
        plot.subtitle=element_text(size=8.2,color="gray40",lineheight=1.05), legend.position="bottom",
        legend.text=element_text(size=7), panel.grid.major.x=element_blank(), panel.grid.minor=element_blank())

# ============================================================================
# FIG 2 — Sensibilidad EMAPA (A vs B)
# ============================================================================
emapa_pct <- 100*sum(cls$devengado_mm[cls$es_emapa])/sum(cls$devengado_mm)  # 32.6
A0 <- cls %>% filter(mafap_cat=="A") %>% summarise(p=100*sum(devengado_mm)/sum(cls$devengado_mm)) %>% pull(p)
Dc <- cls %>% filter(mafap_cat=="D") %>% summarise(p=100*sum(devengado_mm)/sum(cls$devengado_mm)) %>% pull(p)
Cc <- 100-A0-Dc
scn <- tribble(~escenario,~A,~B,
  "A1 puro\n(cota superior de A)", A0, 0,
  "Split 60/40", A0-0.40*emapa_pct, 0.40*emapa_pct,
  "Split 50/50\n(caso base)", A0-0.50*emapa_pct, 0.50*emapa_pct) %>%
  mutate(C=Cc, D=Dc) %>%
  pivot_longer(c(A,B,C,D), names_to="cat", values_to="pct") %>%
  mutate(escenario=factor(escenario, levels=rev(c("A1 puro\n(cota superior de A)","Split 60/40","Split 50/50\n(caso base)"))),
         cat=factor(cat, levels=c("A","B","C","D")))
# posiciones manuales de etiqueta (orden visual A,B,C,D de izq. a der.)
labp <- scn %>% arrange(escenario, cat) %>% group_by(escenario) %>%
  mutate(xpos=cumsum(pct)-pct/2) %>% ungroup() %>% filter(cat %in% c("A","B"), pct>3)
p2 <- ggplot(scn, aes(pct, escenario, fill=cat)) +
  geom_col(width=0.65, position=position_stack(reverse=TRUE)) +
  scale_fill_manual(values=c("A"=CA,"B"=CB,"C"=CC,"D"=CD),
                    labels=c("A productor","B consumidor","C otros","D bienes públicos"), name=NULL) +
  geom_text(data=labp, aes(x=xpos, label=paste0(round(pct),"%")),
            color="white", fontface="bold", size=2.8) +
  scale_x_continuous(labels=label_number(suffix="%"), expand=c(0,0)) +
  labs(title="B · El diagnóstico depende de cómo se clasifique EMAPA",
       subtitle=paste0("EMAPA = ", round(emapa_pct), "% del gasto. Bajo A1-puro, B=0 (falso); con split emerge apoyo al consumidor de 13–16%"),
       x=NULL, y=NULL) +
  theme_minimal(base_size=10) +
  theme(plot.title=element_text(size=12,face="bold",color="#2C3E50"),
        plot.subtitle=element_text(size=8.6,color="gray40"), legend.position="bottom",
        legend.text=element_text(size=7.6), panel.grid.major.y=element_blank(), panel.grid.minor=element_blank())

# ============================================================================
# FIG 3 — Desglose de D (bienes públicos)
# ============================================================================
total_mm <- sum(cls$devengado_mm)
db <- cls %>% filter(mafap_cat=="D") %>%
  mutate(grupo=case_when(
    grepl("^2\\.9", cod) & mafap_sub=="D6" ~ "Riego e hidroagrícola (D6)",
    mafap_sub=="D6" ~ "Otra infraestructura sectorial (D6)",
    mafap_sub=="D1" ~ "Investigación (D1)",
    mafap_sub=="D5" ~ "Sanidad/inspección (D5)",
    mafap_sub=="D4" ~ "Extensión y asistencia técnica (D4)",
    mafap_sub=="D9" ~ "Administración y otros (D9)", TRUE~"Otro D")) %>%
  group_by(grupo) %>% summarise(mm=sum(devengado_mm),.groups="drop") %>%
  mutate(pct=100*mm/total_mm, grupo=fct_reorder(grupo, pct),
         fill_col=if_else(grepl("Riego",grupo), CD, "#9DC183"))
p3 <- ggplot(db, aes(pct, grupo)) +
  geom_col(aes(fill=fill_col), width=0.72) + scale_fill_identity() +
  geom_text(aes(label=paste0(gsub("\\.",",",round(pct,1)),"%")), hjust=-0.12, size=3, color="gray25") +
  scale_x_continuous(labels=label_number(suffix="%"), expand=expansion(mult=c(0,0.12)), limits=c(0,32)) +
  labs(title="C · Los bienes públicos del sector son, sobre todo, riego",
       subtitle="Desglose de la categoría D (acumulado 2016–2024, % del gasto agropecuario total).\nInvestigación y extensión juntas no llegan al 10%.",
       x=NULL, y=NULL) +
  theme_minimal(base_size=10) +
  theme(plot.title=element_text(size=12,face="bold",color="#2C3E50"),
        plot.subtitle=element_text(size=8.8,color="gray40",lineheight=1.05),
        axis.text.y=element_text(size=9), panel.grid.major.y=element_blank(), panel.grid.minor=element_blank())

# ---- Guardar (3 figuras individuales + combinada) ----
for (sub in c("png","svg","pdf")) dir.create(here("05_outputs","figures",sub), showWarnings=FALSE, recursive=TRUE)
sav <- function(p,n,w,h){ ggsave(here("05_outputs","figures","png",paste0(n,".png")),p,width=w,height=h,dpi=600,bg="white")
                          ggsave(here("05_outputs","figures","svg",paste0(n,".svg")),p,width=w,height=h,bg="white") }
sav(p1,"fig_mafap_prog_recomposicion",8.5,5.2)
sav(p2,"fig_mafap_prog_sensibilidad_emapa",7,4.2)
sav(p3,"fig_mafap_prog_desglose_d",8,4.5)

cat("\n✅ 3 figuras MAFAP programáticas generadas:\n")
cat("  fig_mafap_prog_recomposicion · fig_mafap_prog_sensibilidad_emapa · fig_mafap_prog_desglose_d\n")
cat("\nEscenarios EMAPA (A/B %):\n"); print(scn %>% filter(cat %in% c("A","B")) %>%
  pivot_wider(names_from=cat,values_from=pct) %>% mutate(across(c(A,B),~round(.,1))) %>% as.data.frame(), row.names=FALSE)
