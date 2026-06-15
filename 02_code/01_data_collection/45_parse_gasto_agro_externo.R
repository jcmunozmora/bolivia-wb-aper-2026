# 45_parse_gasto_agro_externo.R — Consolida fuentes externas de gasto público agropecuario
# Bolivia (descargadas 2026-06-14 de MEFP Presupuesto Abierto, UDAPE, IMF GFSCOFOG).
# Cierra el gap 2009–2024 que BOOST (1996–2008) y VIPFE-inversión no cubrían.
# Salidas: 01_data/processed/gasto_agro_externo_*.rds + .csv
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(jsonlite); library(readxl); library(here)

RAW <- here("01_data","raw","external_gasto_2026")
OUT <- here("01_data","processed")

# ============================================================================
# 1) MEFP — sector AGROPECUARIO (acteco=2): total devengado + top3 entidades
# ============================================================================
sec <- fromJSON(file.path(RAW,"mefp_agro_sector.json"))$estados %>% as_tibble() %>%
  transmute(year=gestion, gasto_agro_bs=total, gasto_total_bs=total_gestion,
            pct_del_total=prop, per_capita_bs=per_capita, n_entidades,
            top1=top1_entidad_desc, top1_pct, top2=top2_entidad_desc, top2_pct,
            top3=top3_entidad_desc, top3_pct)
saveRDS(sec, file.path(OUT,"gasto_agro_externo_mefp_sector.rds"))

# ============================================================================
# 2) MEFP — funcional COFOG Agricultura (finfun 4.2): devengado por año
# ============================================================================
fun <- fromJSON(file.path(RAW,"mefp_finfun_agricultura.json"))$estados %>% as_tibble() %>%
  filter(gestion>0) %>% transmute(year=gestion, gasto_func_agri_bs=total, pct_del_total=prop)
saveRDS(fun, file.path(OUT,"gasto_agro_externo_mefp_funcional.rds"))

# ============================================================================
# 3) MEFP — TODAS las entidades del sector agro por año (2016-2024)
# ============================================================================
ent_files <- list.files(RAW, pattern="mefp_agro_entidades_\\d{4}\\.json$", full.names=TRUE)
ent <- map_dfr(ent_files, function(f){
  fromJSON(f) %>% as_tibble() %>%
    transmute(year=gestion, entidad_id=entidad, entidad=entidad_desc,
              monto_bs=monto, pct_sector=prop, ranking)
})
# clasificación por tipo de ejecutor (para actualizar el hallazgo de fragmentación)
ent <- ent %>% mutate(tipo = case_when(
  grepl("Departamental|Prefectura|Gobernaci", entidad, ignore.case=TRUE) ~ "Gobernaciones",
  grepl("Municipal|Municipio|G\\.A\\.M|GAM ", entidad, ignore.case=TRUE) ~ "Municipios",
  grepl("Desarrollo Rural y Tierras", entidad, ignore.case=TRUE) ~ "MDRyT (rector)",
  grepl("Apoyo A La Producci|EMAPA", entidad, ignore.case=TRUE) ~ "EMAPA",
  grepl("INIAF|Innovaci.n Agropecuaria", entidad, ignore.case=TRUE) ~ "INIAF",
  grepl("Sanidad Agropecuaria|SENASAG", entidad, ignore.case=TRUE) ~ "SENASAG",
  grepl("Medio Ambiente y Agua|EMAGUA|Riego|SENARI|Cuenca", entidad, ignore.case=TRUE) ~ "MMAyA/Agua-Riego",
  grepl("Reforma Agraria|INRA", entidad, ignore.case=TRUE) ~ "INRA",
  TRUE ~ "Otras"))
saveRDS(ent, file.path(OUT,"gasto_agro_externo_mefp_entidades.rds"))

# share por tipo de ejecutor, por año
share_tipo <- ent %>% group_by(year, tipo) %>% summarise(monto=sum(monto_bs,na.rm=TRUE),.groups="drop") %>%
  group_by(year) %>% mutate(share=100*monto/sum(monto)) %>% ungroup()
saveRDS(share_tipo, file.path(OUT,"gasto_agro_externo_share_ejecutor.rds"))

# resolver INIAF / SENASAG (TODO_TRACE del capítulo)
inst <- ent %>% filter(tipo %in% c("INIAF","SENASAG","MDRyT (rector)","EMAPA")) %>%
  group_by(year, tipo) %>% summarise(monto_mm_bs=round(sum(monto_bs)/1e6,1),.groups="drop") %>%
  pivot_wider(names_from=tipo, values_from=monto_mm_bs)

# ============================================================================
# 4) UDAPE — inversión pública por sector (1990-2022): fila Agropecuario
# ============================================================================
udape_raw <- tryCatch(read_excel(file.path(RAW,"udape_inv_sector.xls"), col_names=FALSE), error=function(e) NULL)
udape_note <- if(is.null(udape_raw)) "ERROR leyendo .xls" else paste0(nrow(udape_raw),"x",ncol(udape_raw))

# ============================================================================
# 5) IMF GFSCOFOG GF0402 — gasto funcional agricultura, gobierno general (1972-2014)
# ============================================================================
imf <- fromJSON(file.path(RAW,"imf_gfscofog_agro.json"), simplifyVector=FALSE)
imf_docs <- imf$series$docs
# tomar la serie del gobierno general en moneda local (S13, XDC, sin ratio)
gg <- NULL
for(s in imf_docs){ if(grepl("^A\\.BO\\.S13\\.XDC\\.GF0402$", s$series_code)) gg <- s }
imf_gg <- if(!is.null(gg)) tibble(year=as.integer(unlist(gg$period)), gasto_agri_cofog_lcu=unlist(gg$value)) else tibble()
if(nrow(imf_gg)>0) saveRDS(imf_gg, file.path(OUT,"gasto_agro_externo_imf_cofog.rds"))

# ============================================================================
# REPORTE
# ============================================================================
cat("\n================ GASTO PÚBLICO AGROPECUARIO — FUENTES EXTERNAS ================\n\n")
cat(">>> 1) MEFP sector Agropecuario (devengado TOTAL corriente+capital, MM Bs):\n")
print(sec %>% transmute(year, gasto_agro_MMbs=round(gasto_agro_bs/1e6), pct_del_total, top1, top1_pct) %>% as.data.frame(), row.names=FALSE)

cat("\n>>> 2) ¿Quién ejecuta? Share por tipo de ejecutor (%), reciente vs años:\n")
print(share_tipo %>% filter(year %in% c(2016,2020,2024)) %>%
  select(year,tipo,share) %>% mutate(share=round(share,1)) %>%
  pivot_wider(names_from=year,values_from=share) %>% arrange(desc(`2024`)) %>% as.data.frame(), row.names=FALSE)

cat("\n>>> 3) INIAF / SENASAG / MDRyT / EMAPA (devengado, MM Bs) — resuelve TODO_TRACE:\n")
print(inst %>% as.data.frame(), row.names=FALSE)

cat("\n>>> 4) UDAPE inversión .xls leído:", udape_note, "\n")
cat(">>> 5) IMF GFSCOFOG GF0402 (gob. general):", if(nrow(imf_gg)>0) paste0(nrow(imf_gg)," años ",min(imf_gg$year),"-",max(imf_gg$year)) else "no parseado","\n")

cat("\nRDS guardados en 01_data/processed/gasto_agro_externo_*.rds\n")
