# ============================================================================
# Script:        17_mafap_classification.R
# Propósito:     Re-clasificar el gasto público agropecuario boliviano bajo
#                la taxonomía MAFAP/FAO (categorías A-E) usando el crosswalk
#                canónico. Produce dos cifras paralelas del GAP: narrow y full.
# Ejecuta:       ADR-0009 (adopción MAFAP narrow+full) y ADR-0010 (crosswalk)
# Inputs:        - 01_data/processed/spending_panel_v12.rds   (panel maestro)
#                - 01_data/processed/crosswalk_mafap_oecd_cofog.csv
#                - 01_data/processed/mafap_categories.csv
#                - 01_data/raw/boost/*                        (BOOST 2024)
#                - 01_data/raw/vipfe/*                        (VIPFE inversión)
# Outputs:       - 01_data/processed/mafap_bolivia.rds        (panel clasificado)
#                - 01_data/processed/mafap_bolivia.csv        (gemelo CSV)
#                - 02_code/02_cleaning/logs/17_mafap_coverage.log
# Autor:         Juan Carlos Muñoz Mora (EAFIT)
# Fecha:         2026-05-23
# Dependencias:  tidyverse, here, readr, janitor, glue, logger
# ============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(here)
  library(readr)
  library(janitor)
  library(glue)
})

# ---- 0. Configuración ------------------------------------------------------

ROOT       <- here()
PATH_PANEL <- here("01_data/processed/spending_panel_v12.rds")
PATH_CW    <- here("01_data/processed/crosswalk_mafap_oecd_cofog.csv")
PATH_CAT   <- here("01_data/processed/mafap_categories.csv")
PATH_OUT_RDS <- here("01_data/processed/mafap_bolivia.rds")
PATH_OUT_CSV <- here("01_data/processed/mafap_bolivia.csv")
PATH_LOG     <- here("02_code/02_cleaning/logs/17_mafap_coverage.log")

dir.create(dirname(PATH_LOG), recursive = TRUE, showWarnings = FALSE)

log_line <- function(msg) {
  line <- glue("[{format(Sys.time(), '%Y-%m-%d %H:%M:%S')}] {msg}")
  message(line)
  cat(line, "\n", file = PATH_LOG, append = TRUE)
}

# ---- 1. Cargar inputs ------------------------------------------------------

log_line("MAFAP classification — start")
log_line(glue("Project root: {ROOT}"))

panel <- readRDS(PATH_PANEL)
log_line(glue("Panel v12 cargado: {nrow(panel)} filas × {ncol(panel)} cols"))

crosswalk <- read_csv(PATH_CW, show_col_types = FALSE) %>%
  clean_names()
log_line(glue("Crosswalk cargado: {nrow(crosswalk)} entradas"))

categories <- read_csv(PATH_CAT, show_col_types = FALSE) %>%
  filter(!is.na(code))  # remover filas-encabezado del CSV
log_line(glue("Categorías MAFAP: {nrow(categories)} códigos"))

# ---- 2. Verificación de consistencia crosswalk ↔ categorías ----------------

cat_codes <- categories$code
cw_codes  <- crosswalk$mafap_code

missing_in_cw  <- setdiff(cat_codes, cw_codes)
missing_in_cat <- setdiff(cw_codes, cat_codes)

if (length(missing_in_cw) > 0) {
  log_line(glue("⚠ Códigos en mafap_categories sin entrada en crosswalk: {paste(missing_in_cw, collapse = ', ')}"))
}
if (length(missing_in_cat) > 0) {
  log_line(glue("⚠ Códigos en crosswalk sin entrada en mafap_categories: {paste(missing_in_cat, collapse = ', ')}"))
}

# ---- 3. Función de clasificación de partidas BOOST/VIPFE -------------------
#
# IMPORTANTE — Esta función opera sobre el panel v12 agregado. Si en el futuro
# se reconstruye con datos transaccionales BOOST, esta lógica debe migrar a
# trabajar sobre la base granular (entidad × programa × año) antes del agregado.
#
# Estrategia híbrida (panel v12 agregado):
#   Como el panel v12 NO tiene una columna `mafap_code` por construcción
#   transaccional, se aplica un mapeo basado en columnas existentes
#   (boost_*, inv_agro_*, emapa_*, pse_*, bcb_*, mun_*). El crosswalk se usa
#   como tabla de referencia para los nombres canónicos.
# ----------------------------------------------------------------------------

classify_panel <- function(df) {

  df <- df %>%
    mutate(
      # ---- Categoría A: Apoyo al productor ----
      # A1 MPS — proxy con componente IDB AgriMonitor (MPS_BOB_2015)
      mafap_A1_bob_2015 = coalesce(MPS_BOB_2015, 0),

      # A2 Input subsidies — incluye crédito BDP subsidiado (revenue foregone)
      # Hasta tener `revenue_foregone_bdp`, usar BT_agg como proxy
      mafap_A2_bob_2015 = coalesce(BT_agg_BOB_2015, 0),

      # A — total productor (suma OECD-PSE: MPS + BT)
      mafap_A_bob_2015 = mafap_A1_bob_2015 + mafap_A2_bob_2015,

      # ---- Categoría B: Apoyo al consumidor (CSE) ----
      mafap_B_bob_2015 = coalesce(CSE_BOB_2015, 0),

      # ---- Categoría C: Apoyo a otros agentes ----
      # Sin proxy directo en panel v12; placeholder = 0 hasta clasificación granular
      mafap_C_bob_2015 = 0,

      # ---- Categoría D: Apoyo general al sector (GSSE) ----
      mafap_D_bob_2015 = coalesce(GSSE_BOB_2015, 0),

      # ---- Categoría E: Gasto agropecuario-soporte (rural) ----
      # Proxy con infraestructura rural municipal cuando disponible
      mafap_E_bob_2015 = coalesce(mun_rural_infra_bob_mm_2015, 0) * 1000,
      # × 1000 porque mun_*_mm está en millones; ajustar a BOB

      # ---- Agregados narrow y full ----
      mafap_narrow_bob_2015 = mafap_A_bob_2015 + mafap_B_bob_2015 +
                              mafap_C_bob_2015 + mafap_D_bob_2015,
      mafap_full_bob_2015   = mafap_narrow_bob_2015 + mafap_E_bob_2015,

      # ---- Shares (relativos al narrow) ----
      mafap_share_A = if_else(mafap_narrow_bob_2015 > 0,
                              mafap_A_bob_2015 / mafap_narrow_bob_2015, NA_real_),
      mafap_share_B = if_else(mafap_narrow_bob_2015 > 0,
                              mafap_B_bob_2015 / mafap_narrow_bob_2015, NA_real_),
      mafap_share_C = if_else(mafap_narrow_bob_2015 > 0,
                              mafap_C_bob_2015 / mafap_narrow_bob_2015, NA_real_),
      mafap_share_D = if_else(mafap_narrow_bob_2015 > 0,
                              mafap_D_bob_2015 / mafap_narrow_bob_2015, NA_real_),

      # ---- Cifra paralela 4-way (para apéndice D) ----
      gap_mafap_narrow = mafap_narrow_bob_2015,
      gap_mafap_full   = mafap_full_bob_2015,
      gap_oecd_pse     = coalesce(PSE_BOB_2015, 0) + coalesce(GSSE_BOB_2015, 0),
      gap_cofog_042    = coalesce(inv_agro_bob_mm_2015, 0) * 1000,  # proxy COFOG 04.2

      # ---- Flag de cobertura ----
      mafap_coverage_flag = case_when(
        is.na(MPS_BOB_2015) & is.na(GSSE_BOB_2015) ~ "no_pse_data",
        is.na(mun_rural_infra_bob_mm_2015)         ~ "no_rural_data",
        TRUE                                       ~ "ok"
      ),

      # ---- Versionamiento ----
      methodology_version = "m0.1.0",
      panel_version       = "v12",
      mafap_script        = "17_mafap_classification.R",
      mafap_adr           = "ADR-0009, ADR-0010"
    )

  df
}

# ---- 4. Aplicar clasificación ---------------------------------------------

log_line("Aplicando clasificación MAFAP al panel v12...")
mafap_bolivia <- classify_panel(panel)

# ---- 5. Tests de integridad ------------------------------------------------

run_tests <- function(df) {

  log_line("Tests de integridad MAFAP:")

  # Test 1: narrow = A + B + C + D
  t1 <- with(df, all.equal(
    mafap_narrow_bob_2015,
    mafap_A_bob_2015 + mafap_B_bob_2015 + mafap_C_bob_2015 + mafap_D_bob_2015
  ))
  log_line(glue("  [T1] narrow = A+B+C+D : {if (isTRUE(t1)) '✓' else paste('✗', t1)}"))

  # Test 2: full = narrow + E
  t2 <- with(df, all.equal(
    mafap_full_bob_2015,
    mafap_narrow_bob_2015 + mafap_E_bob_2015
  ))
  log_line(glue("  [T2] full = narrow + E : {if (isTRUE(t2)) '✓' else paste('✗', t2)}"))

  # Test 3: cobertura años con datos
  yrs_with_data <- df %>% filter(mafap_narrow_bob_2015 > 0) %>% pull(year)
  log_line(glue("  [T3] Años con MAFAP narrow > 0: {length(yrs_with_data)} ({min(yrs_with_data, na.rm = TRUE)}-{max(yrs_with_data, na.rm = TRUE)})"))

  # Test 4: relación MAFAP D ≈ OECD GSSE (debe ser idéntico por construcción del proxy)
  diff_d_gsse <- df %>%
    mutate(diff = mafap_D_bob_2015 - coalesce(GSSE_BOB_2015, 0)) %>%
    summarise(max_diff = max(abs(diff), na.rm = TRUE)) %>%
    pull(max_diff)
  log_line(glue("  [T4] |MAFAP D - OECD GSSE| max: {round(diff_d_gsse, 2)} (debe ser 0 por construcción)"))

  # Test 5: ratio E/narrow razonable cuando hay datos rurales
  e_ratio <- df %>%
    filter(mafap_coverage_flag == "ok", mafap_narrow_bob_2015 > 0) %>%
    summarise(median_ratio = median(mafap_E_bob_2015 / mafap_narrow_bob_2015,
                                     na.rm = TRUE)) %>%
    pull(median_ratio)
  log_line(glue("  [T5] Mediana E/narrow: {round(e_ratio, 3)} (esperado ~0.2-0.5 en países de ingreso medio)"))

  invisible(df)
}

run_tests(mafap_bolivia)

# ---- 6. Reporte de cobertura -----------------------------------------------

cov_summary <- mafap_bolivia %>%
  count(mafap_coverage_flag, name = "n_years") %>%
  arrange(desc(n_years))

log_line("Cobertura por flag:")
for (i in seq_len(nrow(cov_summary))) {
  log_line(glue("  {cov_summary$mafap_coverage_flag[i]}: {cov_summary$n_years[i]} años"))
}

# ---- 7. Guardar outputs ----------------------------------------------------

saveRDS(mafap_bolivia, PATH_OUT_RDS)
write_csv(mafap_bolivia, PATH_OUT_CSV)

log_line(glue("Output RDS: {PATH_OUT_RDS}"))
log_line(glue("Output CSV: {PATH_OUT_CSV}"))
log_line(glue("Total columnas mafap_*: {sum(grepl('^mafap_|^gap_', colnames(mafap_bolivia)))}"))

# ---- 8. Reporte para apéndice B y D ---------------------------------------

# Tabla resumen anual: las 4 cifras paralelas del GAP
gap_paralelo <- mafap_bolivia %>%
  filter(year >= 2006, year <= 2024) %>%
  select(year, gap_mafap_narrow, gap_mafap_full, gap_oecd_pse, gap_cofog_042) %>%
  mutate(across(starts_with("gap_"), ~ round(.x / 1e6, 2)))  # convertir a millones

log_line("Resumen GAP en 4 cifras paralelas (mm BOB 2015), últimos 5 años:")
gap_recent <- tail(gap_paralelo, 5)
for (i in seq_len(nrow(gap_recent))) {
  log_line(glue("  {gap_recent$year[i]}: narrow={gap_recent$gap_mafap_narrow[i]} | full={gap_recent$gap_mafap_full[i]} | oecd-pse={gap_recent$gap_oecd_pse[i]} | cofog={gap_recent$gap_cofog_042[i]}"))
}

log_line("MAFAP classification — done")

# ---- 9. Caveats operativos -------------------------------------------------
# Notas para futuras iteraciones:
#
# 1. CATEGORÍA C (otros agentes): actualmente = 0 porque el panel v12 agregado
#    no permite identificarla. Cuando se reconstruya con datos transaccionales,
#    revisar partidas a intermediarios, transportistas y procesadores.
#
# 2. CATEGORÍA E (rural-soporte): el proxy actual usa solo
#    mun_rural_infra_bob_mm_2015 con cobertura 2012-2023. Para extender a
#    1990-2011 se requiere fuente alternativa (Jubileo histórico, BOOST con
#    clasificación funcional rural).
#
# 3. SUB-CATEGORÍAS A1-A4 y D1-D10: este script solo produce los agregados
#    A, B, C, D, E. Para desagregar a sub-categorías (necesario para las
#    figuras fig18a-d), aplicar lógica adicional sobre BOOST transaccional
#    siguiendo el crosswalk MEFP funcional → MAFAP sub-código.
#
# 4. REVENUE FORGONE BDP: actualmente capturado parcialmente en BT_agg_BOB_2015
#    pero no separado de transferencias presupuestarias directas. Cuando se
#    calcule por separado (script futuro 18_revenue_foregone.R), restar de
#    A2 y agregar como sub-categoría A2.2 explícita.
#
# 5. SENSIBILIDAD: el script debe correrse con dos versiones:
#    (a) panel v12 actual (cobertura PSE 2006-2023);
#    (b) panel v12 + extensiones AgriMonitor feb-2026 cuando estén disponibles.
#    Si la edición feb-2026 cambia retroactivamente la serie, BUMP del panel
#    a v13 y nueva ejecución de este script (ver ADR-0009 §"Consecuencias").
# ============================================================================
