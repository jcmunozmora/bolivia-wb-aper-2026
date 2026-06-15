# 49_parse_mefp_muni_programatico.R
# =============================================================================
# Aplana los árboles acteco MUNICIPALES descargados por 49_download_mefp_muni_
# programatico.R en un panel municipio × actividad × año (2016–2024), lo deflacta
# a USD const. 2015 (método idéntico a 48_parse_acteco_programatica.R y a la
# fig 18) y le aplica el mismo crosswalk acteco→MAFAP / grupo de propósito.
#
# Extiende a 2024 la lectura de COMPOSICIÓN del gasto agropecuario municipal que
# Jubileo sólo cubría hasta 2021 — ahora con clasificación oficial MEFP (devengado
# SIGEP), agro-específica (acteco=2) y reconciliada al 100% con el total por entidad.
#
# Decisión: ADR-0015. Provenance: API MEFP → 49_download → este script → RDS.
# Salidas:
#   01_data/processed/gasto_agro_prog_muni_2016_2024.{rds,csv}   (municipio×actividad×año)
#   01_data/processed/gasto_agro_prog_muni_grupo.rds             (municipio×grupo×año)
#   01_data/processed/gasto_agro_prog_muni_mafap.rds             (municipio×MAFAP×año)
# =============================================================================
suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))
library(tidyverse); library(jsonlite)
if (requireNamespace("here", quietly = TRUE)) library(here) else
  here <- function(...) file.path(getwd(), ...)

RAW       <- here("01_data", "raw", "external_gasto_2026")
CACHE_DIR <- file.path(RAW, "muni_treemap")
OUT       <- here("01_data", "processed")
FX2015    <- 6.91

# ─── 1. Catálogo entidad_id → municipio (de los JSON de entidades) ────────────
read_ent <- function(year) {
  f <- file.path(RAW, sprintf("mefp_agro_entidades_%d.json", year))
  if (!file.exists(f)) return(NULL)
  j <- fromJSON(f); df <- if (is.data.frame(j)) j else j$estados
  df <- df[grepl("Municipal", df$entidad_desc, ignore.case = TRUE), ]
  tibble(year = year, entidad_id = as.integer(df$entidad),
         entidad_desc = df$entidad_desc, monto_total_bs = as.numeric(df$monto))
}
ent <- map_dfr(2016:2024, read_ent)

# nombre legible del municipio
ent <- ent %>% mutate(
  muni_name = entidad_desc %>%
    str_replace(regex("Gobierno Aut[oó]nomo Municipal De ", ignore_case = TRUE), "") %>%
    str_squish())

# cruce con catálogo Jubileo para recuperar departamento + código INE
norm <- function(x) x %>% str_to_lower() %>%
  stringi::stri_trans_general("Latin-ASCII") %>%
  str_replace_all("[^a-z ]", " ") %>% str_squish()
cat_jub <- readRDS(file.path(OUT, "jubileo_municipios_catalogo.rds")) %>%
  as_tibble() %>% mutate(key = norm(muni_name)) %>%
  distinct(key, .keep_all = TRUE)
ent <- ent %>% mutate(key = norm(muni_name)) %>%
  left_join(cat_jub %>% select(key, dept_name, muni_code), by = "key")

cat(sprintf("Entidades municipales: %d pares; con depto asignado: %d (%.0f%%)\n",
            nrow(ent), sum(!is.na(ent$dept_name)),
            100*mean(!is.na(ent$dept_name))))

# ─── 2. Leer y aplanar los árboles acteco municipales (solo hojas agro 2.x.y) ─
is_agro_leaf <- function(c) grepl("^2\\.[0-9]+\\.[0-9]+$", c)  # hoja: 2.Y.Z

files <- list.files(CACHE_DIR, pattern = "^tree_\\d+_\\d{4}\\.json$", full.names = TRUE)
stopifnot(length(files) > 0)
cat(sprintf("Parseando %d árboles municipales...\n", length(files)))

read_tree <- function(f) {
  m <- str_match(basename(f), "^tree_(\\d+)_(\\d{4})\\.json$")
  ent_id <- as.integer(m[2]); yr <- as.integer(m[3])
  j <- tryCatch(fromJSON(f), error = function(e) NULL)
  if (is.null(j) || length(j) == 0 || !is.data.frame(j)) return(NULL)
  j %>% as_tibble() %>%
    filter(is_agro_leaf(as.character(acteco))) %>%
    transmute(entidad_id = ent_id, year = yr,
              acteco = as.character(acteco), desc = desc_acteco,
              devengado_bs = as.numeric(devengado)) %>%
    filter(devengado_bs > 0)
}
panel <- map_dfr(files, read_tree)
cat(sprintf("  Filas hoja agro: %s\n", format(nrow(panel), big.mark = ",")))

# ─── 3. Deflactar a USD const. 2015 (idéntico a script 48) ────────────────────
cpi <- readRDS(file.path(OUT, "mafap_bolivia.rds")) %>%
  filter(year >= 2016, year <= 2024) %>%
  transmute(year, cpi = if_else(year == 2024 & is.na(cpi_2015base),
                                117.7729 * 1.051, cpi_2015base)) %>%
  distinct()
panel <- panel %>% left_join(cpi, by = "year") %>%
  mutate(usd2015 = (devengado_bs) / (cpi/100) / FX2015,
         usd2015_mm = usd2015 / 1e6)

# ─── 4. Crosswalk acteco→MAFAP + grupo de propósito (semilla ADR-0014/0015) ───
clasif <- function(desc, acteco) {
  d <- desc; s2 <- str_extract(acteco, "^2\\.\\d+")
  riego  <- s2 == "2.9" | str_detect(d, regex("riego|microriego|drenaje|atajado|reservorio|perforac", ignore_case=TRUE))
  invest <- str_detect(d, regex("investigaci", ignore_case=TRUE))
  ext    <- str_detect(d, regex("extension|extensión|capacitaci", ignore_case=TRUE))
  sanid  <- str_detect(d, regex("sanidad", ignore_case=TRUE))
  tierra <- str_detect(d, regex("saneamiento|titulaci|tierras", ignore_case=TRUE))
  multi  <- str_detect(d, regex("multiprograma", ignore_case=TRUE))
  otros  <- str_detect(d, regex("^otro", ignore_case=TRUE))
  tibble(
    mafap = case_when(invest ~ "D1", ext ~ "D2", sanid ~ "D5", riego ~ "D6",
                      tierra ~ "D10", multi ~ "D9", otros ~ "D10", TRUE ~ "A"),
    grupo = case_when(
      riego ~ "Riego e infraestructura",
      invest | ext | sanid ~ "Servicios técnicos (I+D, extensión, sanidad)",
      tierra | multi | otros ~ "Tierras, multiprograma y otros",
      TRUE ~ "Apoyo a la producción y seguridad alimentaria"))
}
panel <- panel %>%
  bind_cols(pmap_dfr(list(.$desc, .$acteco), clasif)) %>%
  left_join(ent %>% select(entidad_id, year, muni_name, dept_name, muni_code,
                           monto_total_bs), by = c("entidad_id", "year"))

# ─── 5. QA: reconciliación con el total por entidad ──────────────────────────
recon <- panel %>% group_by(entidad_id, year, monto_total_bs) %>%
  summarise(suma_hojas = sum(devengado_bs), .groups = "drop") %>%
  mutate(dif_pct = 100*(suma_hojas - monto_total_bs)/monto_total_bs)
cat(sprintf("QA reconciliación hojas vs total entidad: mediana |dif| = %.3f%%, max = %.2f%%\n",
            median(abs(recon$dif_pct), na.rm=TRUE), max(abs(recon$dif_pct), na.rm=TRUE)))

# ─── 6. Guardar panel detallado + agregados ───────────────────────────────────
panel_out <- panel %>%
  select(year, entidad_id, muni_name, dept_name, muni_code,
         acteco, desc, mafap, grupo, devengado_bs, usd2015, usd2015_mm)
saveRDS(panel_out, file.path(OUT, "gasto_agro_prog_muni_2016_2024.rds"))
write.csv(panel_out, file.path(OUT, "gasto_agro_prog_muni_2016_2024.csv"), row.names = FALSE)

g_grupo <- panel %>% group_by(year, entidad_id, muni_name, dept_name, grupo) %>%
  summarise(usd2015 = sum(usd2015), .groups = "drop")
saveRDS(g_grupo, file.path(OUT, "gasto_agro_prog_muni_grupo.rds"))

g_mafap <- panel %>% group_by(year, entidad_id, muni_name, dept_name, mafap) %>%
  summarise(usd2015 = sum(usd2015), .groups = "drop")
saveRDS(g_mafap, file.path(OUT, "gasto_agro_prog_muni_mafap.rds"))

# ─── 7. Reporte ───────────────────────────────────────────────────────────────
cat("\n=== COBERTURA por año (municipios con gasto agro > 0) ===\n")
print(as.data.frame(panel %>% group_by(year) %>%
  summarise(n_muni = n_distinct(entidad_id),
            n_actividades = n_distinct(acteco),
            usd2015_mm = round(sum(usd2015_mm), 1))), row.names = FALSE)

cat("\n=== COMPOSICIÓN nacional municipal por grupo de propósito (USD 2015 MM/año) ===\n")
print(as.data.frame(panel %>% group_by(year, grupo) %>%
  summarise(mm = sum(usd2015_mm), .groups="drop") %>%
  pivot_wider(names_from = grupo, values_from = mm, values_fill = 0) %>%
  mutate(across(where(is.numeric), ~round(.,1)))), row.names = FALSE)

cat("\n=== TOP 12 municipios por gasto agro 2024 (USD 2015 MM) ===\n")
print(as.data.frame(panel %>% filter(year == 2024) %>%
  group_by(muni_name, dept_name) %>%
  summarise(usd2015_mm = round(sum(usd2015_mm),2), .groups="drop") %>%
  arrange(desc(usd2015_mm)) %>% head(12)), row.names = FALSE)

cat("\n✅ gasto_agro_prog_muni_2016_2024.rds —",
    format(nrow(panel_out), big.mark=","), "filas (municipio×actividad×año)\n")
