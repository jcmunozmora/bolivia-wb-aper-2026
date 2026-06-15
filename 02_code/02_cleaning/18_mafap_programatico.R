# 18_mafap_programatico.R — Clasificación MAFAP del gasto agro desde el PRESUPUESTO REAL
# Reemplaza el proxy AgriMonitor (17_) con la descomposición programática MEFP (36 actividades).
# Mapeo consenso (3 lentes independientes + verificación adversarial; workflow 2026-06-14).
# Caso base: EMAPA (2.10.x) = A1 puro (upper bound de A); ver sensibilidad en figura.
# Entrada: gasto_agro_programatico_mefp.rds. Salida: gasto_agro_mafap_prog.rds + serie + D-breakdown.
# Decisión: ADR-0009/0010. NO publicar sin firma TTL (gasto sensible) + decisión split EMAPA.
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(here)

P <- here("01_data","processed")
act <- readRDS(file.path(P,"gasto_agro_programatico_mefp.rds"))

# ---- Mapeo consenso: actividad (cod) → subcategoría MAFAP ----
mapeo <- tribble(
  ~cod,~mafap_sub,
  "2.10.2","A1","2.1.4","A1","2.8.5","A1","2.1.2","A2.3","2.10.3","A1","2.8.1","A1",
  "2.2.1","A1","2.8.3","A2.3","2.8.9","A2.3","2.8.8","A2.3","2.8.2","A1","2.2.5","C",
  "2.9.1","D6","2.1.5","D6","2.9.6","D6","2.5.1","D9","2.10.1","D1","2.1.6","D1",
  "2.7.3","D9","2.7.1","D9","2.9.8","D6","2.9.4","D6","2.8.10","D5","2.1.3","D4",
  "2.3.1","D9","2.8.4","D4","2.8.6","D6","2.1.10","D5","2.9.7","D6","2.2.3","D6",
  "2.2.4","D1","2.8.7","D1","2.2.2","D4","2.9.3","D1","2.9.9","D6","2.9.2","D6"
) %>% mutate(mafap_cat = substr(mafap_sub,1,1))

cls <- act %>% left_join(mapeo, by="cod") %>%
  mutate(devengado_mm = devengado_bs/1e6,
         es_emapa = cod %in% c("2.10.2","2.10.3"))

stopifnot(sum(is.na(cls$mafap_cat))==0)  # 100% clasificado
saveRDS(cls, file.path(P,"gasto_agro_mafap_prog.rds"))

# ---- CASO BASE CONSERVADOR: split EMAPA 50/50 entre A1 (productor) y B1 (consumidor) ----
# EMAPA (2.10.2/2.10.3) compra al productor a precio sostén Y vende subsidiado al consumidor.
# Asignarlo todo a A1 borra B (falso). Split 50/50 = supuesto conservador, pendiente de
# estados financieros de EMAPA (decisión a mesa MEFP/EMAPA). SPLIT_B parametrizable.
SPLIT_B <- 0.5
emapa_split <- cls %>% filter(es_emapa) %>%
  (\(d) bind_rows(
     mutate(d, mafap_cat="A", mafap_sub="A1", devengado_mm=devengado_mm*(1-SPLIT_B)),
     mutate(d, mafap_cat="B", mafap_sub="B1", devengado_mm=devengado_mm*SPLIT_B)))()
cls_eff <- bind_rows(cls %>% filter(!es_emapa), emapa_split)

# ---- Serie A–E por año (% del total) — incluye E=0 explícito ----
serie <- cls_eff %>% group_by(year, mafap_cat) %>% summarise(mm=sum(devengado_mm),.groups="drop") %>%
  complete(year, mafap_cat=c("A","B","C","D","E"), fill=list(mm=0)) %>%
  group_by(year) %>% mutate(pct=100*mm/sum(mm)) %>% ungroup()
saveRDS(serie, file.path(P,"gasto_agro_mafap_prog_serie.rds"))

# ---- Desglose de D (acumulado) ----
dbreak <- cls %>% filter(mafap_cat=="D") %>% group_by(mafap_sub) %>%
  summarise(mm=sum(devengado_mm),.groups="drop") %>% mutate(pct_tot=100*mm/sum(cls$devengado_mm))

cat("\n✅ Clasificación MAFAP programática — CASO BASE CONSERVADOR (EMAPA split 50/50)\n\n")
cat("Composición % por año (A,B,C,D,E):\n")
print(serie %>% select(year,mafap_cat,pct) %>% mutate(pct=round(pct,1)) %>%
  pivot_wider(names_from=mafap_cat, values_from=pct) %>% as.data.frame(), row.names=FALSE)
cat("\nAcumulado 2016-2024 (caso base 50/50):\n")
print(cls_eff %>% group_by(mafap_cat) %>% summarise(mm=round(sum(devengado_mm)),.groups="drop") %>%
  mutate(pct=round(100*mm/sum(mm),1)) %>% as.data.frame(), row.names=FALSE)
cat("\nDesglose D (sub, % del total agro):\n")
print(dbreak %>% mutate(pct_tot=round(pct_tot,1)) %>% arrange(desc(pct_tot)) %>% as.data.frame(), row.names=FALSE)
cat("\nEMAPA (2.10.x) total:", round(sum(cls$devengado_mm[cls$es_emapa])), "MM Bs =",
    round(100*sum(cls$devengado_mm[cls$es_emapa])/sum(cls$devengado_mm),1), "% del total\n")
