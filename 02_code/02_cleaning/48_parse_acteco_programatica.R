# 48_parse_acteco_programatica.R — Composición programática del gasto agro (MEFP, 2016-2024)
# Lee el árbol de actividad económica (acteco) del sector Agropecuario (código 2.x) descargado
# de MEFP Presupuesto Abierto, lo aplana a tabla larga año × actividad, lo deflacta a USD const.
# 2015 (mismo método que 18_fig_gasto_ejecutores_total.R) y le aplica el crosswalk acteco→MAFAP.
# Corre DESPUÉS de la descarga (mefp_acteco_tree_YYYY.json) y de 17_mafap_classification.R.
# Decisión: ADR-0014. Trazabilidad: API MEFP → este script → gasto_agro_programatico.rds.
# Salidas: 01_data/processed/gasto_agro_programatico.{rds,csv}
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(jsonlite)
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)

RAW <- here("01_data","raw","external_gasto_2026")
OUT <- here("01_data","processed")
FX2015 <- 6.91   # BOB/USD 2015 (peg)

# --- 1. Leer y aplanar los 9 árboles anuales -------------------------------
is_agro <- function(c) { c <- as.character(c); c == "2" | startsWith(c, "2.") }

files <- list.files(RAW, pattern = "^mefp_acteco_tree_\\d{4}\\.json$", full.names = TRUE)
stopifnot(length(files) >= 1)

tree <- map_dfr(files, function(f) {
  yr <- as.integer(str_extract(basename(f), "\\d{4}"))
  fromJSON(f) %>% as_tibble() %>%
    filter(is_agro(acteco)) %>%
    transmute(year = yr, acteco = as.character(acteco), nivel,
              parent = as.character(parent), desc = desc_acteco,
              devengado_bs = as.numeric(devengado))
})

# --- 2. Deflactar a USD const. 2015 (método idéntico a fig 18) --------------
# CPI 2015=100 del panel; 2024 NA → inflación media INE 2024 ≈5,1% [preliminar].
cpi <- readRDS(file.path(OUT,"mafap_bolivia.rds")) %>%
  filter(year >= 2016, year <= 2024) %>%
  transmute(year, cpi = if_else(year == 2024 & is.na(cpi_2015base),
                                117.7729 * 1.051, cpi_2015base)) %>%
  distinct()

tree <- tree %>% left_join(cpi, by = "year") %>%
  mutate(usd2015_mm = (devengado_bs/1e6) / (cpi/100) / FX2015)

# --- 3. Crosswalk acteco→MAFAP (semilla ADR-0014) ---------------------------
# Mapea cada actividad a (a) categoría MAFAP A–E y (b) grupo de despliegue (≤4, paleta §6).
clasif <- function(desc, acteco) {
  d <- desc; s2 <- str_extract(acteco, "^2\\.\\d+")  # subsector
  riego  <- s2 == "2.9" | str_detect(d, regex("riego|microriego|drenaje|atajado|reservorio|perforac", ignore_case=TRUE))
  invest <- str_detect(d, regex("investigaci", ignore_case=TRUE))
  ext    <- str_detect(d, regex("extension|extensión|capacitaci", ignore_case=TRUE))
  sanid  <- str_detect(d, regex("sanidad", ignore_case=TRUE))
  tierra <- str_detect(d, regex("saneamiento|titulaci|tierras", ignore_case=TRUE))
  multi  <- str_detect(d, regex("multiprograma", ignore_case=TRUE))
  otros  <- str_detect(d, regex("^otro", ignore_case=TRUE))
  tibble(
    mafap = case_when(
      invest ~ "D1", ext ~ "D2", sanid ~ "D5", riego ~ "D6",
      tierra ~ "D10", multi ~ "D9", otros ~ "D10", TRUE ~ "A"),
    grupo = case_when(
      riego ~ "Riego e infraestructura",
      invest | ext | sanid ~ "Servicios técnicos (I+D, extensión, sanidad)",
      tierra | multi | otros ~ "Tierras, multiprograma y otros",
      TRUE ~ "Apoyo a la producción y seguridad alimentaria")
  )
}

# subsector lookup (para desambiguar actividades genéricas: "Multiprograma", "Otros")
subsec <- tree %>% filter(nivel == "subsector") %>%
  distinct(acteco, subsector_desc = desc) %>%
  mutate(subsector_desc = str_to_sentence(subsector_desc))

act <- tree %>% filter(nivel == "actividad") %>%
  mutate(subsector_code = str_extract(acteco, "^2\\.\\d+")) %>%
  left_join(subsec, by = c("subsector_code" = "acteco")) %>%
  bind_cols(pmap_dfr(list(.$desc, .$acteco), clasif)) %>%
  # etiqueta legible: las genéricas se prefijan con su subsector
  mutate(label = if_else(str_detect(desc, regex("^(multiprograma|otros)$", ignore_case=TRUE)),
                         paste0(desc, " — ", subsector_desc), desc))

# --- 4. QA: el total de actividades reconcilia con el sector ---------------
chk <- tree %>% group_by(year, nivel) %>%
  summarise(mm_bs = sum(devengado_bs)/1e6, .groups="drop") %>%
  pivot_wider(names_from = nivel, values_from = mm_bs) %>%
  mutate(reconcilia = round(actividad/sector*100, 1))

# --- 5. Guardar ------------------------------------------------------------
saveRDS(act,  file.path(OUT,"gasto_agro_programatico.rds"))
write.csv(act, file.path(OUT,"gasto_agro_programatico.csv"), row.names = FALSE)

# --- 6. Reporte ------------------------------------------------------------
cat("\n=== RECONCILIACIÓN actividad/sector (debe ≈100%) ===\n")
print(as.data.frame(chk %>% mutate(across(where(is.numeric), ~round(.,1)))), row.names = FALSE)

cat("\n=== PARETO: actividades 2016-2024 (promedio anual, MM USD const 2015) ===\n")
par <- act %>% group_by(acteco, desc, grupo, mafap) %>%
  summarise(usd2015_mm = mean(usd2015_mm, na.rm=TRUE), .groups="drop") %>%
  arrange(desc(usd2015_mm)) %>%
  mutate(share = 100*usd2015_mm/sum(usd2015_mm),
         cum_share = cumsum(share), rank = row_number())
print(as.data.frame(par %>% transmute(rank, acteco, desc = str_trunc(desc,38),
      grupo = str_trunc(grupo,18), usd = round(usd2015_mm,1),
      share = round(share,1), cum = round(cum_share,1)) %>% head(18)), row.names = FALSE)
n80 <- sum(par$cum_share <= 80) + 1
cat("\n→", n80, "de", nrow(par), "actividades concentran el 80% del gasto agro (2016-2024).\n")
cat("✅ gasto_agro_programatico.rds guardado (", nrow(act), "filas actividad-año )\n")
