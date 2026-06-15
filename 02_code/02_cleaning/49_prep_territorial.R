# 49_prep_territorial.R — Consolida datos territoriales del gasto agropecuario para el cap. 04
# Une panel municipal (Jubileo) + panel subnacional + producción CNA2013 + deflactor, en USD const. 2015.
# Cruce muni↔CNA por nombre normalizado dentro de departamento (sin código común entre esquemas).
# Salidas: 01_data/processed/territorial_muni.rds  (muni × año + instrumentos + producción CNA)
#          01_data/processed/territorial_dept.rds  (dept × año + gasto + PIB + producción ENA)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

P <- here("01_data","processed")
FX2015 <- 6.91  # BOB/USD 2015 (peg)

muni <- readRDS(file.path(P,"municipal_panel.rds"))
sub  <- readRDS(file.path(P,"subnacional_panel_v2.rds"))
cna  <- readRDS(file.path(P,"cna2013_indicadores.rds"))

# --- Deflactor CPI 2015=100 por año (del panel subnacional) -----------------
cpi <- sub %>% distinct(year, cpi_2015base) %>% filter(!is.na(cpi_2015base))

# --- Normalizador de nombres para el cruce muni↔CNA -------------------------
norm <- function(x){
  x <- toupper(trimws(x))
  x <- iconv(x, to = "ASCII//TRANSLIT"); x <- gsub("[^A-Z ]", "", x)
  x <- gsub("\\(.*\\)", "", x)                                   # quitar paréntesis
  x <- gsub(" DEL DEPARTAMENTO DE.*| DEL DEPTO.*| DE LA PROVINCIA.*", "", x)
  trimws(gsub("  +", " ", x))
}

cna_key <- cna %>%
  transmute(dep = norm(depto), nm = norm(municipio),
            zona_agroproductiva, sup_total_ha, sup_agricola, sup_con_riego,
            cab_bovinos, cab_llamas, cab_ovinos, n_upa, lab_agricola, pct_riego) %>%
  distinct(dep, nm, .keep_all = TRUE)

# --- Panel municipal: deflactar a USD const. 2015 + cruzar producción -------
territorial_muni <- muni %>%
  left_join(cpi, by = "year") %>%
  mutate(dep = norm(dept), nm = norm(muni_name)) %>%
  left_join(cna_key, by = c("dep","nm")) %>%
  mutate(across(c(p10_agropecuario_bob_mm, p12_microriegos_bob_mm,
                  p18_caminos_vecinales_bob_mm, p32_recursos_hidricos_bob_mm,
                  agro_strict_bob_mm, rural_infra_bob_mm, rural_total_bob_mm,
                  total_presupuesto_bob_mm),
                ~ .x / (cpi_2015base/100) / FX2015, .names = "{.col}_usd")) %>%
  rename_with(~ str_replace(.x, "_bob_mm_usd", "_usd2015"), ends_with("_bob_mm_usd"))

saveRDS(territorial_muni, file.path(P,"territorial_muni.rds"))

# --- Panel departamental: gasto USD 2015 + PIB + producción ENA -------------
territorial_dept <- sub %>%
  mutate(agro_strict_usd2015 = agro_strict_bob_mm_2015 / FX2015,
         rural_total_usd2015  = rural_total_bob_mm_2015 / FX2015,
         rural_infra_usd2015  = rural_infra_bob_mm_2015 / FX2015,
         # intensidad fiscal: USD de gasto agro estricto por hectárea cultivada (ENA2015)
         gasto_por_ha_cult    = if_else(!is.na(ena2015_sup_ha) & ena2015_sup_ha > 0,
                                        (agro_strict_bob_mm_2015*1e6/FX2015) / ena2015_sup_ha, NA_real_))

saveRDS(territorial_dept, file.path(P,"territorial_dept.rds"))

# --- Reporte ----------------------------------------------------------------
cov <- territorial_muni %>% filter(year == 2020) %>%
  summarise(n = n_distinct(muni_code),
            con_cna = n_distinct(muni_code[!is.na(zona_agroproductiva)]))
cat("\n✅ territorial_muni.rds:", nrow(territorial_muni), "filas |",
    "match CNA 2020:", cov$con_cna, "/", cov$n,
    "(", round(100*cov$con_cna/cov$n), "% )\n")

cat("\n=== Composición por instrumento × zona agroproductiva (USD 2015, prom. anual) ===\n")
zmix <- territorial_muni %>% filter(!is.na(zona_agroproductiva),
          !str_detect(zona_agroproductiva, " - ")) %>%   # excluir zonas híbridas
  group_by(year, zona_agroproductiva) %>%
  summarise(p10 = sum(p10_agropecuario_usd2015, na.rm=TRUE),
            p12 = sum(p12_microriegos_usd2015, na.rm=TRUE),
            p18 = sum(p18_caminos_vecinales_usd2015, na.rm=TRUE),
            p32 = sum(p32_recursos_hidricos_usd2015, na.rm=TRUE), .groups="drop") %>%
  group_by(zona_agroproductiva) %>%
  summarise(across(p10:p32, mean), .groups="drop") %>%
  mutate(total = p10+p12+p18+p32) %>% arrange(desc(total))
print(as.data.frame(zmix %>% mutate(across(p10:total, ~round(.,1)))), row.names=FALSE)

cat("\n=== Gini del gasto agro municipal (p10/agro estricto, 2020) ===\n")
g <- territorial_muni %>% filter(year==2020, !is.na(agro_strict_usd2015))
gini <- function(x){ x<-sort(x[x>=0]); n<-length(x); if(n<2||sum(x)==0) return(NA); 2*sum(seq_len(n)*x)/(n*sum(x))-(n+1)/n }
cat("Gini agro_strict 2020:", round(gini(g$agro_strict_usd2015),3),
    "| n munis:", nrow(g), "| top-10 acumulan",
    round(100*sum(sort(g$agro_strict_usd2015,decreasing=TRUE)[1:10])/sum(g$agro_strict_usd2015)), "%\n")
