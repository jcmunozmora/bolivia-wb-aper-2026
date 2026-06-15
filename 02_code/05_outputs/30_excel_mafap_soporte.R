# 30_excel_mafap_soporte.R — Excel de soporte metodológico de la clasificación MAFAP
# Genera un libro formateado con la clasificación de las 36 actividades presupuestarias
# del gasto agropecuario a categorías MAFAP, sus montos y la metodología.
# Salida: 05_outputs/tables/MAFAP_clasificacion_programas.xlsx
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(openxlsx); library(here)

P <- here("01_data","processed")
cls <- readRDS(file.path(P,"gasto_agro_mafap_prog.rds"))
tot <- sum(cls$devengado_mm)

# ---- Etiquetas ----
cat_lab <- c(A="A · Apoyo al productor", B="B · Apoyo al consumidor", C="C · Otros agentes",
             D="D · Bienes públicos (servicios generales)", E="E · Soporte rural")
sub_lab <- c(A1="A1 · Subsidio a la producción", A2.3="A2.3 · Capital en finca",
             B1="B1 · Apoyo al consumidor", C="C · Otros agentes",
             D1="D1 · Investigación", D4="D4 · Extensión / asistencia técnica",
             D5="D5 · Inspección y sanidad", D6="D6 · Infraestructura sectorial",
             D9="D9 · Administración y otros")
notas <- c(
  "2.10.2"="EMAPA. Caso base conservador: 50% A1 (productor) + 50% B1 (consumidor).",
  "2.10.3"="EMAPA (pecuaria). Mismo tratamiento split 50/50 A1/B1.",
  "2.9.6" ="Riego comunitario; clasificado D6 por carácter no parcelario (borderline A2.3).",
  "2.5.1" ="Multiprograma sin destino funcional único; asignado por defecto a D9.",
  "2.3.1" ="Multiprograma; asignado por defecto a D9.",
  "2.7.1" ="Residual; asignado por defecto a D9.",
  "2.2.5" ="Única partida de C (apoyo a otros agentes): pesca extractiva.")

# ---- Hoja 1: Clasificación (acumulado por actividad) ----
clasif <- cls %>% group_by(cod, subsector, actividad, mafap_sub, mafap_cat, es_emapa) %>%
  summarise(devengado_mm = sum(devengado_mm), .groups="drop") %>%
  mutate(pct_total = 100*devengado_mm/tot,
         # EMAPA: categoría dividida 50/50 A1/B1 (caso base); el resto, su categoría observada
         categoria    = if_else(es_emapa, "A/B · Productor + consumidor (split 50/50)", cat_lab[mafap_cat]),
         subcategoria = if_else(es_emapa, "A1 50% · B1 50%", coalesce(sub_lab[mafap_sub], mafap_sub)),
         orden        = if_else(es_emapa, "A", mafap_cat),
         nota = coalesce(notas[cod], "")) %>%
  arrange(factor(orden, levels=c("A","B","C","D","E")), desc(devengado_mm)) %>%
  transmute(`Código`=cod, `Subsector`=subsector, `Actividad presupuestaria`=actividad,
            `Categoría MAFAP`=categoria, `Subcategoría`=subcategoria,
            `Devengado acum. 2016–2024 (BOB millones)`=round(devengado_mm,1),
            `% del gasto agropecuario`=round(pct_total,2), `Nota metodológica`=nota,
            .mafap=if_else(es_emapa, "A", mafap_cat))

# ---- Hoja 2: Serie anual (BOB millones) por actividad ----
serie_act <- cls %>% mutate(mm=round(devengado_bs/1e6,1)) %>%
  select(cod, actividad, mafap_cat, year, mm) %>%
  pivot_wider(names_from=year, values_from=mm, values_fill=0) %>%
  arrange(factor(mafap_cat,levels=c("A","B","C","D","E")), cod) %>%
  mutate(`Categoría MAFAP`=cat_lab[mafap_cat]) %>%
  select(`Código`=cod, `Actividad`=actividad, `Categoría MAFAP`,
         matches("^20[0-9]{2}$"))

# ---- Hoja 3: Resumen A–E (caso base conservador, split 50/50) ----
SPLIT_B<-0.5
emapa_split <- cls %>% filter(es_emapa) %>%
  (\(d) bind_rows(mutate(d,mafap_cat="A",devengado_mm=devengado_mm*(1-SPLIT_B)),
                  mutate(d,mafap_cat="B",devengado_mm=devengado_mm*SPLIT_B)))()
cls_eff <- bind_rows(cls %>% filter(!es_emapa), emapa_split)
resumen <- cls_eff %>% group_by(year, mafap_cat) %>% summarise(mm=sum(devengado_mm),.groups="drop") %>%
  complete(year, mafap_cat=c("A","B","C","D","E"), fill=list(mm=0)) %>%
  group_by(year) %>% mutate(pct=100*mm/sum(mm)) %>% ungroup() %>%
  select(year, mafap_cat, pct) %>% pivot_wider(names_from=mafap_cat, values_from=pct) %>%
  mutate(across(-year, ~round(.,1)))
acum <- cls_eff %>% group_by(mafap_cat) %>% summarise(mm=sum(devengado_mm),.groups="drop") %>%
  mutate(pct=round(100*mm/sum(mm),1), categoria=cat_lab[mafap_cat]) %>%
  transmute(`Categoría`=categoria, `Devengado 2016–2024 (BOB millones)`=round(mm), `% del total`=pct)

# ---- Hoja 4: Metodología (texto) ----
metodo <- tibble(Tema=character(), Detalle=character()) %>%
  add_row(Tema="Fuente", Detalle="MEFP — Presupuesto Abierto, descomposición programática (acteco-treemap) del sector agropecuario. Gasto devengado real, 36 actividades, 2016–2024.") %>%
  add_row(Tema="Marco", Detalle="MAFAP/FAO (Pernechele et al. 2018). Categorías A–E por destinatario y naturaleza. narrow = A+B+C+D; full = +E.") %>%
  add_row(Tema="Regla de asignación", Detalle="D solo si el beneficio es no rival (bien público); de lo contrario A/B/C según el agente beneficiario (ADR-0010 §2).") %>%
  add_row(Tema="EMAPA (Seguridad Alimentaria)", Detalle="Caso base conservador: 50% A1 (productor) + 50% B1 (consumidor). Supuesto, no cifra observada; sensibilidad reportada. Pendiente estados financieros de EMAPA.") %>%
  add_row(Tema="Riego (2.9.x)", Detalle="Clasificado D6 (infraestructura sectorial / bien público), no E, por propósito estrictamente productivo.") %>%
  add_row(Tema="C y E ≈ 0", Detalle="C: solo pesca extractiva. E = 0: el riego va a D6 y el gasto rural no agrícola lo ejecutan otros sectores. Para Bolivia, narrow = full.") %>%
  add_row(Tema="Unidades", Detalle="Composición en % (invariante a deflación). Montos en BOB millones corrientes en este libro; conversión a USD const. 2015 = ÷ (CPI/100) ÷ 6,91.") %>%
  add_row(Tema="Cobertura / límite", Detalle="2016–2024 (la fuente programática no cubre pre-2016). MPS y subsidio de crédito Ley 393 son off-budget (Cap. 5 y §3.4).") %>%
  add_row(Tema="Reproducibilidad", Detalle="Datos: gasto_agro_programatico_mefp.rds · Script: 02_code/02_cleaning/18_mafap_programatico.R · ADR-0009/0010/0012.")

# ============================================================================
# Construcción del libro con formato
# ============================================================================
wb <- createWorkbook()
hdr <- createStyle(fgFill="#1F4E79", fontColour="white", textDecoration="bold",
                   halign="center", valign="center", border="TopBottomLeftRight", borderColour="white", wrapText=TRUE)
catfill <- c(A="#F8D7D7", B="#E6D9F2", C="#EFEFEF", D="#D9EAD3", E="#FCE5CD")
num1 <- createStyle(numFmt="#,##0.0"); num0 <- createStyle(numFmt="#,##0"); pctf <- createStyle(numFmt="0.0")
titleS <- createStyle(fontSize=13, textDecoration="bold", fontColour="#1F4E79")
wrapS  <- createStyle(wrapText=TRUE, valign="top")

addTitled <- function(sheet, title, df, startRow=1, catcol=NULL){
  addWorksheet(wb, sheet, gridLines=FALSE)
  writeData(wb, sheet, title, startCol=1, startRow=startRow); addStyle(wb, sheet, titleS, startRow, 1)
  r0 <- startRow+2
  writeData(wb, sheet, df, startRow=r0, headerStyle=hdr, withFilter=TRUE)
  freezePane(wb, sheet, firstActiveRow=r0+1)
  setColWidths(wb, sheet, cols=1:ncol(df), widths="auto")
  if(!is.null(catcol)){
    for(i in seq_len(nrow(df))){
      cc <- catcol[i]; if(!is.na(cc) && cc %in% names(catfill))
        addStyle(wb, sheet, createStyle(fgFill=catfill[cc]), rows=r0+i, cols=1:ncol(df), gridExpand=TRUE, stack=TRUE)
    }
  }
  r0
}

# Hoja 1
df1 <- clasif %>% select(-.mafap)
r0 <- addTitled("Clasificación", "Clasificación MAFAP de las actividades del gasto agropecuario · acumulado 2016–2024", df1, catcol=clasif$.mafap)
addStyle(wb,"Clasificación", num1, rows=(r0+1):(r0+nrow(df1)), cols=6, gridExpand=TRUE, stack=TRUE)
addStyle(wb,"Clasificación", pctf,  rows=(r0+1):(r0+nrow(df1)), cols=7, gridExpand=TRUE, stack=TRUE)
addStyle(wb,"Clasificación", wrapS, rows=(r0+1):(r0+nrow(df1)), cols=8, gridExpand=TRUE, stack=TRUE)
setColWidths(wb,"Clasificación", cols=c(3,8), widths=c(42,55))

# Hoja 2
r0b <- addTitled("Serie anual", "Devengado anual por actividad (BOB millones corrientes), 2016–2024", serie_act)
setColWidths(wb,"Serie anual", cols=2, widths=42)

# Hoja 3
addWorksheet(wb,"Resumen A–E", gridLines=FALSE)
writeData(wb,"Resumen A–E","Composición MAFAP del gasto agropecuario (caso base conservador, EMAPA 50/50)",startRow=1); addStyle(wb,"Resumen A–E",titleS,1,1)
writeData(wb,"Resumen A–E","Acumulado 2016–2024", startRow=3); addStyle(wb,"Resumen A–E",createStyle(textDecoration="bold"),3,1)
writeData(wb,"Resumen A–E", acum, startRow=4, headerStyle=hdr)
addStyle(wb,"Resumen A–E", num0, rows=5:(4+nrow(acum)), cols=2, gridExpand=TRUE, stack=TRUE)
writeData(wb,"Resumen A–E","Participación anual por categoría (%)", startRow=4+nrow(acum)+2); addStyle(wb,"Resumen A–E",createStyle(textDecoration="bold"),4+nrow(acum)+2,1)
writeData(wb,"Resumen A–E", resumen, startRow=4+nrow(acum)+3, headerStyle=hdr)
setColWidths(wb,"Resumen A–E", cols=1:3, widths=c(42,30,14))

# Hoja 4
addWorksheet(wb,"Metodología", gridLines=FALSE)
writeData(wb,"Metodología","Notas metodológicas — clasificación MAFAP del gasto agropecuario (Bolivia)",startRow=1); addStyle(wb,"Metodología",titleS,1,1)
writeData(wb,"Metodología", metodo, startRow=3, headerStyle=hdr)
addStyle(wb,"Metodología", wrapS, rows=4:(3+nrow(metodo)), cols=2, gridExpand=TRUE, stack=TRUE)
setColWidths(wb,"Metodología", cols=1:2, widths=c(26,115))

dir.create(here("05_outputs","tables"), showWarnings=FALSE, recursive=TRUE)
out <- here("05_outputs","tables","MAFAP_clasificacion_programas.xlsx")
saveWorkbook(wb, out, overwrite=TRUE)
cat("\n✅ Excel generado:", out, "\n")
cat("Hojas: Clasificación (",nrow(df1)," actividades) · Serie anual · Resumen A–E · Metodología\n", sep="")
