# 50_prep_territorial_mefp.R — Gasto agro municipal TOTAL desde MEFP API, 2016-2024 (USD const. 2015)
# Complementa a 49_prep_territorial.R (Jubileo, 2012-2021, por instrumento). Aquí la serie reciente:
# devengado agro total (acteco=2) por Gobierno Autónomo Municipal, deflactado, con departamento.
# Permite extender a 2024 las figuras de top-municipios y concentración. Ver ADR-0015.
# Salida: 01_data/processed/territorial_muni_mefp.rds  (muni × año, gasto agro total USD 2015)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

P <- here("01_data","processed"); FX2015 <- 6.91

norm <- function(x){
  x <- toupper(trimws(x)); x <- iconv(x, to="ASCII//TRANSLIT"); x <- gsub("[^A-Z ]","",x)
  x <- gsub("\\(.*\\)","",x)
  x <- gsub(" DEL DEPARTAMENTO DE.*| DEL DEPTO.*| DE LA PROVINCIA.*","",x)
  trimws(gsub("  +"," ",x))
}

# --- CPI 2015=100 (mafap_bolivia, 2016-2023; 2024 estimado infl. INE ≈5,1% [preliminar]) ---
cpi <- readRDS(file.path(P,"mafap_bolivia.rds")) %>% filter(year>=2016, year<=2024) %>%
  transmute(year, cpi = if_else(year==2024 & is.na(cpi_2015base), 117.7729*1.051, cpi_2015base)) %>% distinct()

# --- catálogo Jubileo: nombre municipal → departamento (97% de match con MEFP) ---
catalogo <- readRDS(file.path(P,"jubileo_municipios_catalogo.rds")) %>%
  transmute(nm = norm(muni_name), dept = dept_name) %>% distinct(nm, .keep_all = TRUE)

# --- MEFP entidades, tipo Municipios (limpiar prefijos variantes del nombre) ---
tmm <- readRDS(file.path(P,"gasto_agro_externo_mefp_entidades.rds")) %>%
  filter(tipo == "Municipios", year >= 2016, year <= 2024) %>%
  mutate(muni_name = str_remove(entidad, "^Gobierno Aut.{0,3}nomo Municipal( Ecol.{0,3}gico Productivo)?( De)? "),
         nm = norm(muni_name)) %>%
  left_join(catalogo, by = "nm") %>%
  left_join(cpi, by = "year") %>%
  mutate(usd2015 = (monto_bs/1e6) / (cpi/100) / FX2015)

saveRDS(tmm, file.path(P,"territorial_muni_mefp.rds"))

# --- Reporte ---
cov <- tmm %>% filter(year==2024) %>% summarise(n=n_distinct(entidad), con_dept=sum(!is.na(dept)))
cat("\n✅ territorial_muni_mefp.rds:", nrow(tmm), "filas | 2024:", cov$n, "munis,",
    "match depto", cov$con_dept, "(", round(100*cov$con_dept/cov$n), "% )\n")

gini <- function(x){ x<-sort(x[!is.na(x)&x>=0]); n<-length(x); if(n<2||sum(x)==0) return(NA); 2*sum(seq_len(n)*x)/(n*sum(x))-(n+1)/n }
g <- tmm %>% group_by(year) %>% summarise(n=n(), gini=round(gini(usd2015),3),
       top10=round(100*sum(sort(usd2015,decreasing=TRUE)[1:10])/sum(usd2015,na.rm=TRUE)),
       total_mmusd=round(sum(usd2015,na.rm=TRUE)), .groups="drop")
cat("\n=== Gasto agro municipal TOTAL (MEFP, USD const 2015) por año ===\n"); print(as.data.frame(g), row.names=FALSE)

cat("\n=== Top-12 municipios 2024 (gasto agro total, USD const 2015) ===\n")
tmm %>% filter(year==2024) %>% arrange(desc(usd2015)) %>% slice_head(n=12) %>%
  transmute(muni_name=str_trunc(muni_name,32), dept, usd2015=round(usd2015,2)) %>% as.data.frame() %>% print(row.names=FALSE)
