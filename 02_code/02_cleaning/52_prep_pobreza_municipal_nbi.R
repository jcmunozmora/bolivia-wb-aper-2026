# 52_prep_pobreza_municipal_nbi.R — Pobreza municipal por NBI (INE, censos 2012 y 2024)
# Fuente: INE, "Población por condición de NBI según depto/prov/municipio/TIOC y área, censos 2012 y 2024"
#   Cuadro 3.06.04.03 → 01_data/raw/ine_pobreza/ine_nbi_municipio_2012_2024_3060403.xlsx
#   (descarga y URLs en 01_data/raw/ine_pobreza/FUENTE_nbi_municipal.txt). Ver ADR-0017.
# Cierra la brecha de "pobreza municipal" del cap. 4: el INE solo daba pobreza departamental; el NBI
# censal es el único indicador de pobreza con desagregación municipal (incl. área Rural) en Bolivia.
# Salida: 01_data/processed/pobreza_municipal_nbi.rds (long: municipio × área {Total,Urbana,Rural})
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
# readxl vive en conda 'ds' si renv no lo trae
if (!requireNamespace("readxl", quietly = TRUE)) {
  cand <- c(Sys.getenv("R_GEO_LIBPATH"), file.path(path.expand("~"),"miniforge3/envs/ds/lib/R/library"))
  hit <- cand[nzchar(cand) & dir.exists(file.path(cand,"readxl"))]; if (length(hit)) .libPaths(c(.libPaths(), hit[1]))
}
stopifnot(requireNamespace("readxl", quietly = TRUE))
suppressMessages({library(dplyr); library(stringr); library(readxl)})
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)
P <- here("01_data","processed")

norm2 <- function(x){ x<-toupper(trimws(x)); x<-iconv(x,to="ASCII//TRANSLIT"); x<-gsub("\\(.*?\\)","",x)
  x<-gsub(" DEL DEPARTAMENTO DE.*| DEL DEPTO.*| DE LA PROVINCIA.*","",x); x<-gsub("[^A-Z ]"," ",x)
  x<-gsub("\\bPUERTO (MAYOR|MENOR) DE ","",x); x<-gsub("\\bNUESTRA SENORA DE ","",x); x<-gsub("\\bSANTIAGO DE ","",x)
  x<-gsub("\\bVILLA ","",x); x<-gsub("  +"," ",x); x<-trimws(x); gsub(" ","",x) }

f <- here("01_data","raw","ine_pobreza","ine_nbi_municipio_2012_2024_3060403.xlsx")
d <- as.data.frame(suppressMessages(read_excel(f, sheet = 1, col_names = FALSE)))

# Estructura del cuadro: cada unidad ocupa 3 filas (Total/Urbana/Rural); en la fila Total el campo
# "área" (col 6) repite el nombre de la unidad. Columnas de interés:
#   3=DEPARTAMENTO, 5=MUNICIPIO/TIOC, 6=ÁREA, 7=pob.ref 2012, 11=% pobre 2012, 15=pob 2024, 19=% pobre 2024.
nbi <- d[!is.na(d[[2]]) & d[[2]] == "Municipio", ] %>%
  transmute(
    dept       = .data[["...3"]],
    municipio  = .data[["...5"]],
    area_raw   = .data[["...6"]],
    pop_2012   = suppressWarnings(as.numeric(.data[["...7"]])),
    nbi_pct_2012 = suppressWarnings(as.numeric(.data[["...11"]])),
    pop_2024   = suppressWarnings(as.numeric(.data[["...15"]])),
    nbi_pct_2024 = suppressWarnings(as.numeric(.data[["...19"]]))
  ) %>%
  mutate(area = case_when(area_raw == "Urbana" ~ "Urbana",
                          area_raw == "Rural"  ~ "Rural",
                          TRUE                 ~ "Total"),
         dept_norm = norm2(dept), muni_norm = norm2(municipio)) %>%
  select(dept, dept_norm, municipio, muni_norm, area, pop_2012, nbi_pct_2012, pop_2024, nbi_pct_2024)

saveRDS(nbi, file.path(P, "pobreza_municipal_nbi.rds"))

# --- Reporte ---
n_muni <- n_distinct(nbi$muni_norm)
cat("\n✅ pobreza_municipal_nbi.rds:", nrow(nbi), "filas |", n_muni, "municipios × {Total,Urbana,Rural}\n")
chk <- nbi %>% filter(area == "Rural")
cat("Cobertura NBI rural 2024:", sum(!is.na(chk$nbi_pct_2024)), "munis | con pob rural>0:", sum(chk$pop_2024>0, na.rm=TRUE), "\n")
cat("NBI rural 2024 — mediana:", round(median(chk$nbi_pct_2024, na.rm=TRUE),1),
    "% | rango:", paste(round(range(chk$nbi_pct_2024, na.rm=TRUE),1), collapse="–"), "%\n")
cat("Validación nacional (debe ≈ 61,8% rural 2024 / 79,8% rural 2012):\n")
val <- d[d[[2]]=="Pais" & d[[6]]=="Rural", ]
cat("  rural 2012:", round(as.numeric(val[[11]]),1), "% | rural 2024:", round(as.numeric(val[[19]]),1), "%\n")
