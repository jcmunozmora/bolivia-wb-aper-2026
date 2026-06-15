# 11_focalizacion_gasto_pobreza.R — Cap. 4: ¿el gasto agro municipal se focaliza en la necesidad rural?
# Cruza el gasto agropecuario municipal per cápita rural con la pobreza rural (NBI, INE censo 2024),
# sección cruzada. Cierra el TODO_TRACE de focalización en 04_spending_organization.qmd. Ver ADR-0017.
# Insumos: territorial_muni_mefp.rds (gasto agro total MEFP 2024), pobreza_municipal_nbi.rds (NBI rural).
# Salida: 01_data/processed/focalizacion_gasto_pobreza.rds (coeficientes + n para citar en el reporte).
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
suppressMessages({library(dplyr); library(stringr)})
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)
P <- here("01_data","processed")

norm2 <- function(x){ x<-toupper(trimws(x)); x<-iconv(x,to="ASCII//TRANSLIT"); x<-gsub("\\(.*?\\)","",x)
  x<-gsub(" DEL DEPARTAMENTO DE.*| DEL DEPTO.*| DE LA PROVINCIA.*","",x); x<-gsub("[^A-Z ]"," ",x)
  x<-gsub("\\bPUERTO (MAYOR|MENOR) DE ","",x); x<-gsub("\\bNUESTRA SENORA DE ","",x); x<-gsub("\\bSANTIAGO DE ","",x)
  x<-gsub("\\bVILLA ","",x); x<-gsub("  +"," ",x); x<-trimws(x); gsub(" ","",x) }

# Pobreza rural municipal (NBI 2024) + población rural de referencia
nbi <- readRDS(file.path(P,"pobreza_municipal_nbi.rds")) %>% filter(area == "Rural") %>%
  select(dn = dept_norm, nm = muni_norm, rural_pop_2024 = pop_2024, rural_nbi_2024 = nbi_pct_2024)

# Gasto agro total municipal devengado 2024 (MEFP, USD const. 2015)
gasto <- readRDS(file.path(P,"territorial_muni_mefp.rds")) %>% filter(year == 2024) %>%
  group_by(entidad) %>% summarise(dept = first(dept), muni = first(muni_name),
                                  usd = sum(usd2015, na.rm = TRUE) * 1e6, .groups = "drop") %>%
  mutate(dn = norm2(dept), nm = norm2(muni))

m <- inner_join(nbi, gasto, by = c("dn","nm")) %>%
  filter(rural_pop_2024 > 0, !is.na(usd), !is.na(rural_nbi_2024)) %>%
  mutate(gasto_pc_rural = usd / rural_pop_2024)   # USD agro por habitante rural

cp <- cor.test(m$gasto_pc_rural, m$rural_nbi_2024, method = "pearson")
cs <- suppressWarnings(cor.test(m$gasto_pc_rural, m$rural_nbi_2024, method = "spearman", exact = FALSE))

res <- list(
  spec        = "Gasto agro total municipal (MEFP 2024) / población rural (Censo 2024) vs NBI rural (Censo 2024)",
  n           = nrow(m),
  pearson_r   = unname(cp$estimate),  pearson_p   = cp$p.value,
  spearman_rho= unname(cs$estimate),  spearman_p  = cs$p.value,
  gasto_pc_rural_mediana_usd = median(m$gasto_pc_rural),
  fuente_gasto = "territorial_muni_mefp.rds (MEFP, devengado agro total, acteco=2, 2024)",
  fuente_pobreza = "pobreza_municipal_nbi.rds (INE, NBI rural, Censo 2024)"
)
saveRDS(res, file.path(P, "focalizacion_gasto_pobreza.rds"))

cat("\n✅ focalizacion_gasto_pobreza.rds | n =", res$n, "municipios\n")
cat(sprintf("Pearson  r = %.3f (p = %.3g)\n", res$pearson_r, res$pearson_p))
cat(sprintf("Spearman rho = %.3f (p = %.3g)\n", res$spearman_rho, res$spearman_p))
cat(sprintf("Gasto agro per cápita rural: mediana = USD %.1f / hab\n", res$gasto_pc_rural_mediana_usd))
cat("Lectura:", if (abs(res$pearson_r) < 0.2 && res$spearman_p > 0.05) "correlación DÉBIL / no robusta (sin focalización en necesidad)" else "revisar", "\n")
