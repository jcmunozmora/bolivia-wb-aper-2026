# 46_integrate_gasto_externo.R — Integra fuentes externas de gasto agro al panel v12
# Corre DESPUÉS de 17_mafap_classification.R y de 45_parse_gasto_agro_externo.R.
# Añade columnas mefp_* / imf_* a mafap_bolivia.rds, por año (1990-2024). Idempotente.
# Decisión: ADR-0012. Trazabilidad: raw URL → 45_ → 46_ → panel.
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
library(tidyverse); library(here)

P  <- here("01_data","processed")
panel <- readRDS(file.path(P,"mafap_bolivia.rds"))

# Limpiar columnas previas (idempotencia)
panel <- panel %>% select(-matches("^(mefp_|imf_gasto_agri)"))

# --- MEFP sector (devengado total agropecuario) ---
sector <- readRDS(file.path(P,"gasto_agro_externo_mefp_sector.rds")) %>% filter(year > 0) %>%
  transmute(year,
            mefp_gasto_agro_total_bs   = gasto_agro_bs,
            mefp_gasto_publico_total_bs= gasto_total_bs,
            mefp_gasto_agro_pct_total  = pct_del_total,   # numerador Maputo sobre GASTO TOTAL
            mefp_n_entidades_agro      = n_entidades)

# --- MEFP funcional COFOG 4.2 ---
fun <- readRDS(file.path(P,"gasto_agro_externo_mefp_funcional.rds")) %>%
  transmute(year, mefp_gasto_func_agri_bs = gasto_func_agri_bs)

# --- MEFP shares por tipo de ejecutor (pivot) ---
sh <- readRDS(file.path(P,"gasto_agro_externo_share_ejecutor.rds")) %>%
  mutate(tipo2 = case_when(
    tipo == "EMAPA" ~ "emapa",
    tipo == "MDRyT (rector)" ~ "mdryt",
    tipo %in% c("Gobernaciones","Municipios") ~ "subnacional",
    tipo == "MMAyA/Agua-Riego" ~ "mmaya",
    tipo == "INIAF" ~ "iniaf",
    tipo == "INRA" ~ "inra",
    TRUE ~ "otras")) %>%
  group_by(year, tipo2) %>% summarise(share = sum(share), .groups="drop") %>%
  pivot_wider(names_from = tipo2, values_from = share, names_prefix = "mefp_share_")

# --- INIAF devengado (resuelve TODO_TRACE L128) ---
iniaf <- readRDS(file.path(P,"gasto_agro_externo_mefp_entidades.rds")) %>%
  filter(tipo == "INIAF") %>% group_by(year) %>%
  summarise(mefp_iniaf_devengado_bs = sum(monto_bs, na.rm=TRUE), .groups="drop")

# --- IMF COFOG GF0402 (forzar numérico; solo 2002-2007 útil) ---
imf <- readRDS(file.path(P,"gasto_agro_externo_imf_cofog.rds")) %>%
  transmute(year = as.integer(year),
            imf_gasto_agri_cofog_lcu = suppressWarnings(as.numeric(gasto_agri_cofog_lcu))) %>%
  filter(!is.na(imf_gasto_agri_cofog_lcu))

# --- Join por año ---
panel2 <- panel %>%
  left_join(sector, by="year") %>%
  left_join(fun,    by="year") %>%
  left_join(sh,     by="year") %>%
  left_join(iniaf,  by="year") %>%
  left_join(imf,    by="year") %>%
  mutate(
    # ratio gasto total / inversión VIPFE (cuando ambos existen)
    mefp_ratio_total_inversion = if_else(!is.na(mefp_gasto_agro_total_bs) & !is.na(inv_agro_bob_mm_current) & inv_agro_bob_mm_current>0,
                                         (mefp_gasto_agro_total_bs/1e6) / inv_agro_bob_mm_current, NA_real_),
    mefp_source   = if_else(!is.na(mefp_gasto_agro_total_bs), "MEFP Presupuesto Abierto (devengado, SIGEP)", NA_character_),
    mefp_retrieved= if_else(!is.na(mefp_gasto_agro_total_bs), "2026-06-14", NA_character_)
  )

saveRDS(panel2, file.path(P,"mafap_bolivia.rds"))
write.csv(panel2, file.path(P,"mafap_bolivia.csv"), row.names=FALSE)

# --- Verificación ---
cat("\n✅ Panel integrado:", ncol(panel2), "columnas (", ncol(panel2)-ncol(panel),"nuevas )\n\n")
chk <- panel2 %>% filter(year %in% c(2016,2020,2023,2024)) %>%
  transmute(year,
            gasto_total_MMbs = round(mefp_gasto_agro_total_bs/1e6),
            pct_total = mefp_gasto_agro_pct_total,
            ratio_tot_inv = round(mefp_ratio_total_inversion,2),
            emapa = round(mefp_share_emapa,1),
            mdryt = round(mefp_share_mdryt,1),
            subnac = round(mefp_share_subnacional,1),
            iniaf_MMbs = round(mefp_iniaf_devengado_bs/1e6,1))
print(as.data.frame(chk), row.names=FALSE)
cat("\nColumnas nuevas:", paste(grep("^(mefp_|imf_gasto)", names(panel2), value=TRUE), collapse=", "), "\n")
