# ENA 2015 — Encuesta Nacional Agropecuaria Bolivia
# =============================================================================
# Fuente: INE Bolivia — Encuesta Agropecuaria 2015
# Directorio: 01_data/raw/ine_bolivia/Encuesta_Agropecuaria_2015/BD Spss/
#
# Módulos disponibles:
#   1.-Hogar/Hogar_parte1.sav   — 12,650 UPAs × 19 vars (master, ponderador)
#   1.-Hogar/Hogar_parte2.sav   — 12,650 × 85 vars (hogar/household)
#   1.-Hogar/Hogar_parte3.sav   — 12,650 × 151 vars (mano de obra, tractores)
#   2.-Agricola/agricola verano e invierno.sav — 54,242 × 140 vars (cultivos)
#   3.-Pecuaria/1.-Ganaderia Bovinos.sav — 394,716 × 42 vars
#
# Nota: códigos cultivos 2015 son CIIU (ej. "01412000"=Soya) ≠ ENA 2008 (numérico)
#       Categorías uso de suelo (07xxxxxx) incluidas en módulo agrícola
#
# Outputs:
#   ena_2015_upa_indicadores.rds   — UPA level (12,650 × ~45 vars)
#   ena_2015_cultivos_nacional.rds — resumen nacional por cultivo
#   ena_2015_dept_resumen.rds      — resumen por departamento
#   ena_comparacion_2008_2015.rds  — comparación 2008 vs 2015
# =============================================================================

library(haven)
library(data.table)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
base <- file.path(root, "01_data/raw/ine_bolivia/Encuesta_Agropecuaria_2015/BD Spss")
proc <- file.path(root, "01_data/processed")

# ── 1. Hogar parte1: UPA master ───────────────────────────────────────────────
cat("=== Módulo 1: Hogar parte1 (UPA master) ===\n")
h1 <- as.data.table(zap_labels(read_sav(file.path(base, "1.-Hogar/Hogar_parte1.sav"))))
setnames(h1, tolower(names(h1)))

upa <- h1[, .(
  id_persona,
  id_departamento,
  dept_name    = nombredepartamento,
  id_provincia,
  id_municipio,
  municipio,
  sexo_productor,     # 1=hombre, 2=mujer
  cond_juridica = c1_s2_8,  # 1=persona natural, 2=empresa, etc.
  act_agricola  = c1_s2_10_1,  # 1=sí
  act_ganadera  = c1_s2_10_2,
  act_forestal  = c1_s2_10_3,
  act_pesca     = c1_s2_10_4,
  ponderador
)]
cat(sprintf("UPA master: %d obs × %d vars\n", nrow(upa), ncol(upa)))

# ── 2. Módulo agrícola: cultivos y uso del suelo ──────────────────────────────
cat("\n=== Módulo 2: Agrícola ===\n")
agr_raw <- as.data.table(zap_labels(read_sav(
  file.path(base, "2.-Agricola/agricola verano e invierno.sav"))))
setnames(agr_raw, tolower(names(agr_raw)))
cat(sprintf("Agrícola: %d obs × %d cols\n", nrow(agr_raw), ncol(agr_raw)))
cat(sprintf("UPAs únicas: %d\n", uniqueN(agr_raw$id_persona)))

# Separar uso del suelo no-cultivado (empieza con 07) de cultivos reales
agr_raw[, es_uso_suelo := grepl("^07", as.character(codigo))]

# Superficie total por UPA (incluye bosques, pastos, barbecho, cultivos)
sup_total <- agr_raw[, .(
  sup_total_ha = sum(sup_exp, na.rm = TRUE)
), by = id_persona]

# Solo cultivos (excluye categorías 07...)
agro <- agr_raw[es_uso_suelo == FALSE]
cat(sprintf("  Registros cultivos: %d | UPAs con cultivos: %d\n",
            nrow(agro), uniqueN(agro$id_persona)))

# Cultivos de interés (códigos CIIU 2015)
# Codificación: "01XXXXXX"
SOYA   <- "01412000"
PAPA   <- "01510000"
MAIZ   <- "01122000"  # maíz duro; también 01121000 maíz blando
ARROZ  <- "01132000"
TRIGO  <- "01112000"
SORGO  <- "01142000"
QUINUA <- c("01191001", "01192001")  # quinua real y convencional
CANA   <- "01802000"

# Resumen nacional expandido por cultivo
cultivos_nac <- agro[, .(
  n_obs         = .N,
  n_upas        = uniqueN(id_persona),
  sup_ha_exp    = sum(sup_exp, na.rm = TRUE),
  prod_qq_exp   = sum(prod_exp, na.rm = TRUE),
  pct_riego     = round(mean(riego == 1, na.rm = TRUE) * 100, 1)
), by = .(codigo, cultiv)]
setorder(cultivos_nac, -sup_ha_exp)
cat("\nTop 15 cultivos por superficie expandida:\n")
print(cultivos_nac[1:15, .(codigo, cultiv, sup_ha_exp=round(sup_ha_exp), prod_qq_exp=round(prod_qq_exp), pct_riego)])

saveRDS(cultivos_nac, file.path(proc, "ena_2015_cultivos_nacional.rds"))
fwrite(cultivos_nac,  file.path(proc, "ena_2015_cultivos_nacional.csv"))
cat("✓ ena_2015_cultivos_nacional.rds\n")

# Agregación a nivel UPA
upa_agro <- agro[, .(
  n_cultivos        = .N,
  sup_cultivada_ha  = sum(sup_exp, na.rm = TRUE),
  prod_total_qq     = sum(prod_exp, na.rm = TRUE),
  pct_lotes_riego   = round(mean(riego == 1, na.rm = TRUE) * 100, 1),
  usa_insumos_org   = as.integer(any(usa_ins_org == 1, na.rm = TRUE)),
  usa_plaguicida    = as.integer(any(usa_plag == 1, na.rm = TRUE)),
  usa_quimicos      = as.integer(any(usa_qui == 1, na.rm = TRUE)),
  sup_soya_ha       = sum(sup_exp[codigo == SOYA], na.rm = TRUE),
  sup_papa_ha       = sum(sup_exp[codigo == PAPA], na.rm = TRUE),
  sup_maiz_ha       = sum(sup_exp[codigo %in% c(MAIZ, "01121000")], na.rm = TRUE),
  sup_arroz_ha      = sum(sup_exp[codigo == ARROZ], na.rm = TRUE),
  sup_trigo_ha      = sum(sup_exp[codigo == TRIGO], na.rm = TRUE),
  sup_quinua_ha     = sum(sup_exp[codigo %in% QUINUA], na.rm = TRUE),
  sup_sorgo_ha      = sum(sup_exp[codigo == SORGO], na.rm = TRUE)
), by = id_persona]

# ── 3. Bovinos ────────────────────────────────────────────────────────────────
cat("\n=== Módulo 3: Ganadería Bovina ===\n")
bov_raw <- as.data.table(zap_labels(read_sav(
  file.path(base, "3.-Pecuaria/1.-Ganaderia Bovinos.sav"))))
setnames(bov_raw, tolower(names(bov_raw)))
cat(sprintf("Bovinos raw: %d obs × %d cols\n", nrow(bov_raw), ncol(bov_raw)))

# a072_01_01_fe = expandido cabezas hoy por raza/edad/sexo
upa_bov <- bov_raw[p071 == 1, .(  # solo UPAs con ganado bovino
  cab_bovinos = sum(a072_01_01_fe, na.rm = TRUE)
), by = .(id_persona = persona_id)]
cat(sprintf("UPAs con bovinos: %d | Herd total expandido: %.0f\n",
            nrow(upa_bov), sum(upa_bov$cab_bovinos)))

# ── 4. Tractores y mano de obra (Hogar_parte3) ───────────────────────────────
cat("\n=== Módulo 4: Hogar parte3 (labor + maquinaria) ===\n")
h3 <- as.data.table(zap_labels(read_sav(file.path(base, "1.-Hogar/Hogar_parte3.sav"))))
setnames(h3, tolower(names(h3)))

upa_labor <- h3[, .(
  contrata_trabajadores = as.integer(any(c1_s5_25 == 1, na.rm = TRUE)),
  trabaj_hombres        = sum(c1_s5_26_h6mas + c1_s5_26_h6menos, na.rm = TRUE),
  trabaj_mujeres        = sum(c1_s5_26_m6mas + c1_s5_26_m6menos, na.rm = TRUE),
  usa_tractor           = as.integer(any(c1_s5_28 == 1, na.rm = TRUE)),
  n_tractores           = sum(c1_s5_30_120 + c1_s5_30_80 + c1_s5_30_60 + c1_s5_30_50, na.rm = TRUE)
), by = id_persona]

# ── 5. Join UPA master + módulos ─────────────────────────────────────────────
cat("\n=== Join UPA master + módulos ===\n")
upa_full <- merge(upa, sup_total,  by = "id_persona", all.x = TRUE)
upa_full <- merge(upa_full, upa_agro,  by = "id_persona", all.x = TRUE)
upa_full <- merge(upa_full, upa_bov,   by = "id_persona", all.x = TRUE)
upa_full <- merge(upa_full, upa_labor, by = "id_persona", all.x = TRUE)

# Defaults para UPAs sin módulos
upa_full[is.na(sup_cultivada_ha), sup_cultivada_ha := 0]
upa_full[is.na(cab_bovinos),      cab_bovinos := 0]
upa_full[is.na(usa_tractor),      usa_tractor := 0]
upa_full[is.na(n_tractores),      n_tractores := 0]

cat(sprintf("UPA full: %d × %d vars\n", nrow(upa_full), ncol(upa_full)))
cat(sprintf("  con cultivos: %d/%d (%.0f%%)\n",
            sum(!is.na(upa_full$n_cultivos)), nrow(upa_full),
            mean(!is.na(upa_full$n_cultivos)) * 100))
cat(sprintf("  con bovinos: %d/%d (%.0f%%)\n",
            sum(upa_full$cab_bovinos > 0, na.rm=TRUE), nrow(upa_full),
            mean(upa_full$cab_bovinos > 0, na.rm=TRUE) * 100))

saveRDS(upa_full, file.path(proc, "ena_2015_upa_indicadores.rds"))
fwrite(upa_full,  file.path(proc, "ena_2015_upa_indicadores.csv"))
cat("✓ ena_2015_upa_indicadores.rds\n")

# ── 6. Resumen departamental ──────────────────────────────────────────────────
cat("\n=== Resumen departamental — ENA 2015 ===\n")
dept_res <- upa_full[, .(
  n_upa_exp     = sum(ponderador, na.rm = TRUE),
  sup_total_ha  = sum(sup_total_ha * ponderador / ponderador, na.rm = TRUE),  # sin expansión (ya expandida en módulo agrícola)
  sup_cultiv_ha = sum(sup_cultivada_ha, na.rm = TRUE),
  cab_bovinos   = sum(cab_bovinos, na.rm = TRUE),
  n_tractores   = sum(n_tractores * ponderador, na.rm = TRUE),
  pct_riego     = round(weighted.mean(pct_lotes_riego, ponderador, na.rm = TRUE), 1),
  pct_mujer     = round(mean(sexo_productor == 2, na.rm = TRUE) * 100, 1)
), by = .(id_departamento, dept_name)]
setorder(dept_res, id_departamento)
print(dept_res[, .(dept_name, n_upa_exp=round(n_upa_exp), sup_cultiv_ha=round(sup_cultiv_ha),
                   cab_bovinos=round(cab_bovinos), n_tractores=round(n_tractores),
                   pct_riego, pct_mujer)])

# Totales nacionales
cat("\n=== Totales nacionales expandidos ENA 2015 ===\n")
nac_15 <- upa_full[, .(
  n_upa_exp    = sum(ponderador, na.rm = TRUE),
  sup_cultiv_ha = sum(sup_cultivada_ha, na.rm = TRUE),
  cab_bovinos  = sum(cab_bovinos, na.rm = TRUE),
  n_tractores  = sum(n_tractores * ponderador, na.rm = TRUE),
  pct_mujer    = round(mean(sexo_productor == 2, na.rm = TRUE) * 100, 1)
)]
print(nac_15)

saveRDS(dept_res, file.path(proc, "ena_2015_dept_resumen.rds"))
fwrite(dept_res,  file.path(proc, "ena_2015_dept_resumen.csv"))
cat("✓ ena_2015_dept_resumen.rds\n")

# ── 7. Comparación 2008 vs 2015 ───────────────────────────────────────────────
cat("\n=== Comparación ENA 2008 vs 2015 ===\n")

dept08 <- readRDS(file.path(proc, "ena_2008_dept_resumen.rds"))
setDT(dept08)

dept_labels <- c("1"="Chuquisaca","2"="Cochabamba","3"="La Paz","4"="Oruro",
                 "5"="Potosí","6"="Tarija","7"="Santa Cruz","8"="Beni","9"="Pando")

dept_res[, dept_id := as.character(id_departamento)]

comp_2008 <- dept08[, .(
  dept_id    = as.character(1:.N),
  dept_name  = dept_name,
  upa_2008   = round(n_upa_exp),
  sup_ha_2008 = round(sup_total_ha),
  bov_2008   = round(cab_bovinos),
  tract_2008 = round(n_tractores),
  riego_2008 = pct_riego,
  mujer_2008 = pct_mujer
)]

comp_2015 <- dept_res[, .(
  dept_id    = dept_id,
  upa_2015   = round(n_upa_exp),
  sup_ha_2015 = round(sup_cultiv_ha),
  bov_2015   = round(cab_bovinos),
  tract_2015 = round(n_tractores),
  riego_2015 = pct_riego,
  mujer_2015 = pct_mujer
)]

comp <- merge(comp_2008, comp_2015, by = "dept_id")
comp[, upa_cambio_pct  := round((upa_2015 / upa_2008 - 1) * 100, 1)]
comp[, bov_cambio_pct  := round((bov_2015 / bov_2008 - 1) * 100, 1)]

cat("\n--- UPAs 2008 vs 2015 ---\n")
print(comp[, .(dept_name, upa_2008, upa_2015, upa_cambio_pct)])
cat("\n--- Bovinos 2008 vs 2015 ---\n")
print(comp[, .(dept_name, bov_2008, bov_2015, bov_cambio_pct)])
cat("\n--- % Mujeres productoras ---\n")
print(comp[, .(dept_name, mujer_2008, mujer_2015)])

saveRDS(comp, file.path(proc, "ena_comparacion_2008_2015.rds"))
fwrite(comp,  file.path(proc, "ena_comparacion_2008_2015.csv"))
cat("✓ ena_comparacion_2008_2015.rds\n")

cat("\n✓ ENA 2015 procesado completamente\n")
cat(sprintf("  Nota: módulo agrícola disponible (%d obs, %d UPAs)\n",
            nrow(agro), uniqueN(agro$id_persona)))
