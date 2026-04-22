# ENA 2008 — Encuesta Nacional Agropecuaria Bolivia
# =============================================================================
# Fuente: INE Bolivia — Encuesta Nacional Agropecuaria 2008
#   Módulos: UPA, Agrícola, Ganadería (bovinos), Infraestructura/Maquinaria
#   Cobertura: 8,022 UPAs, 9 departamentos, 15 zonas agroproductivas
#
# Departamentos: 1=Chuquisaca, 2=Cochabamba, 3=La Paz, 4=Oruro, 5=Potosí,
#                6=Tarija, 7=Santa Cruz, 8=Beni, 9=Pando
#
# Módulos disponibles:
#   01: UBIGEO + Condición jurídica + Superficie UPA (8,022 UPAs × 27 vars)
#   02: Cultivos + Producción + Insumos (26,536 registros × 45 vars)
#   03: Distribución producción (ventas, consumo, stock)
#   04: Derivados agrícolas
#   05-10: Balance ganadero (bovinos, ovinos, caprinos, porcinos, llamas, alpacas)
#   11-16: Características ganaderas × especie
#   17-20: Producción ganadera × especie
#   21: Otras especies | 22: Avicultura
#   23: Miembros del hogar | 24: Mano de obra
#   25: Infraestructura y maquinaria (tractores, silos, corrales...)
#
# Outputs:
#   ena_2008_upa_indicadores.rds   — UPA-level: geo + superficie + cultivos + ganado + maquinaria
#   ena_2008_cultivos_nacional.rds — Estadísticas por cultivo expandidas nacionalmente
#   ena_2008_dept_resumen.rds      — Resumen departamental comparable con ENA 2015 y CNA 2013
# =============================================================================

library(data.table)
library(haven)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
raw08 <- file.path(root, "01_data/raw/ine_bolivia/Encuesta_Nacional_Agropecuaria_2008")
proc  <- file.path(root, "01_data/processed")

dept_labels <- c("1"="Chuquisaca","2"="Cochabamba","3"="La Paz","4"="Oruro",
                 "5"="Potosí","6"="Tarija","7"="Santa Cruz","8"="Beni","9"="Pando")

# ── 1. UPA master (módulo 1) ──────────────────────────────────────────────────
cat("=== Módulo 1: UPA master ===\n")
upa_raw <- as.data.table(read_sav(file.path(raw08,
  "1-UBIGEO PRODUCTOR/1.-ENA08_BOLIVIA_UBIGEO_CONDICION_JURIDICA_SUPERFICIE_UPA(preg_1-17).sav")))

upa <- upa_raw[, .(
  folio         = as.character(FOLIO),
  depto         = as.integer(DEPTO),
  dpto_nombre   = dept_labels[as.character(as.integer(DEPTO))],
  zona          = as.character(IZON),
  factor        = as.numeric(Factor),
  # Superficie
  sup_total_ha  = as.numeric(s3_151_ha),   # Dentro y fuera del segmento
  sup_seg_ha    = as.numeric(s3_152_ha),   # Solo dentro del segmento
  n_parcelas    = as.integer(S3_16),
  n_lotes       = as.integer(S3_17),
  # Condición jurídica y operador
  cond_juridica = as.integer(S2_10),       # 1=Natural, 2=Empresa, etc.
  sexo_productor= as.integer(S2_11),       # 1=Hombre, 2=Mujer
  ocup_principal= as.integer(S2_12)        # 1=Agropecuaria como principal
)]

cat(sprintf("UPA master: %d obs × %d vars\n", nrow(upa), ncol(upa)))
cat(sprintf("  Superficie total expandida: %.0f Ha\n",
            sum(upa$sup_total_ha * upa$factor, na.rm = TRUE)))

# ── 2. Módulo agrícola (módulo 2 — cultivos) ──────────────────────────────────
cat("\n=== Módulo 2: Agrícola — cultivos ===\n")
agro_raw <- as.data.table(read_sav(file.path(raw08,
  "2-AGRICOLA/Cultivos (Preg-19)/2.-ENA08_BOLIVIA_CULTIVOS_PRODUCCION_INSUMOS(preg_19).sav")))

agro <- agro_raw[, .(
  folio        = as.character(FOLIO),
  factor       = as.numeric(Factor),
  depto        = as.integer(DPTO),
  zona         = as.character(IZON),
  cultivo_cod  = as.integer(S4_P19_3),
  cultivo_nom  = trimws(as.character(zap_labels(S4_P19_2))),
  tipo_cultivo = as.integer(S4_P19_4),   # 1=Anual, 2=Perenne, 3=Permanente
  sup_cult_ha  = as.numeric(s4_19_5_ha),
  prod_qq      = as.numeric(s4_19_9_qq),
  semilla_qq   = as.numeric(s4_19_7_qq),
  semilla_bs   = as.numeric(s4_19_16_bs),
  abono_qq     = as.numeric(s4_19_17_qq),
  abono_bs     = as.numeric(s4_19_19_bs),
  fertiliz_qq  = as.numeric(s4_19_20_qq),
  fertiliz_bs  = as.numeric(s4_19_22_bs),
  pestic_qq    = as.numeric(s4_19_23_qq),
  pestic_bs    = as.numeric(s4_19_25_bs),
  usa_riego    = as.integer(S4_P19_13),  # 1=Sí, 2=No
  mes_siembra  = as.integer(S4_P19_11),
  mes_cosecha  = as.integer(S4_P19_12)
)]

cat(sprintf("Agrícola: %d cultivos-UPA | %d UPAs únicas\n",
            nrow(agro), uniqueN(agro$folio)))

# 2a. Estadísticas por cultivo expandidas (nacional)
cat("\n=== Cultivos — estadísticas nacionales expandidas ===\n")
cultivos_nac <- agro[!is.na(sup_cult_ha), .(
  n_upa_muestra  = uniqueN(folio),
  sup_ha_exp     = sum(sup_cult_ha * factor, na.rm = TRUE),
  prod_qq_exp    = sum(prod_qq    * factor, na.rm = TRUE),
  pct_riego      = weighted.mean(usa_riego == 1, factor, na.rm = TRUE) * 100,
  costo_insumos_bs = sum((semilla_bs + abono_bs + fertiliz_bs + pestic_bs) * factor, na.rm = TRUE)
), by = .(cultivo_cod, cultivo_nom)][order(-sup_ha_exp)]

cat("Top 15 cultivos por superficie expandida:\n")
print(cultivos_nac[1:15, .(cultivo_nom, sup_ha_exp = round(sup_ha_exp), prod_qq_exp = round(prod_qq_exp),
                            pct_riego = round(pct_riego, 1))])

# 2b. Agregado a nivel UPA
upa_agro <- agro[, .(
  n_cultivos      = .N,
  sup_cultivada_ha= sum(sup_cult_ha, na.rm = TRUE),
  prod_total_qq   = sum(prod_qq, na.rm = TRUE),
  costo_insumos   = sum(semilla_bs + abono_bs + fertiliz_bs + pestic_bs, na.rm = TRUE),
  pct_lotes_riego = mean(usa_riego == 1, na.rm = TRUE) * 100,
  tiene_abono     = any(abono_qq > 0, na.rm = TRUE),
  tiene_fertiliz  = any(fertiliz_qq > 0, na.rm = TRUE),
  tiene_pestic    = any(pestic_qq > 0, na.rm = TRUE),
  # Cultivos específicos
  sup_soya_ha     = sum(sup_cult_ha[cultivo_cod == 26], na.rm = TRUE),
  sup_papa_ha     = sum(sup_cult_ha[cultivo_cod == 43], na.rm = TRUE),
  sup_maiz_ha     = sum(sup_cult_ha[cultivo_cod %in% c(7, 8)], na.rm = TRUE),
  sup_arroz_ha    = sum(sup_cult_ha[cultivo_cod == 2], na.rm = TRUE),
  sup_quinua_ha   = sum(sup_cult_ha[cultivo_cod == 10], na.rm = TRUE)
), by = folio]

# ── 3. Módulo ganadería — bovinos (módulo 5) ──────────────────────────────────
cat("\n=== Módulo 3: Balance Ganadero — Bovinos ===\n")
bov_raw <- as.data.table(read_sav(file.path(raw08,
  "3-GANADERIA/Balance Ganadero/5.-ENA08_BOLIVIA_BALANCE_GANADERO_BOVINOS(preg_23).sav")))

bov <- bov_raw[, .(
  folio    = as.character(FOLIO),
  factor   = as.numeric(Factor),
  depto    = as.integer(DEPTO),
  categoria= trimws(as.character(BOVINOS)),
  cabezas_ini = as.numeric(S5_P23A),   # Cabezas al inicio (Jul-2007)
  nacidos     = as.numeric(S5_P23B),
  comprados   = as.numeric(S5_P23C),
  muertos     = as.numeric(S5_P23D),
  consumo_hogar = as.numeric(S5_P23E),
  vendidos_pie  = as.numeric(S5_P23F),
  vendidos_faen = as.numeric(S5_P23H),
  cabezas_fin   = as.numeric(S5_P23J)  # Cabezas a la entrevista
)]

# Aggregate to UPA: total hembras + machos = total bovinos
bov_upa <- bov[categoria %in% c("TOTAL HEMBRAS", "TOTAL MACHOS"), .(
  cab_bovinos_total = sum(cabezas_fin, na.rm = TRUE),
  cab_hembras       = sum(cabezas_fin[categoria == "TOTAL HEMBRAS"], na.rm = TRUE),
  cab_machos        = sum(cabezas_fin[categoria == "TOTAL MACHOS"],  na.rm = TRUE)
), by = folio]

cat(sprintf("Bovinos: %d UPAs con dato\n", nrow(bov_upa)))
cat(sprintf("  Herd total expandido: %.0f cabezas\n",
            sum(bov_upa$cab_bovinos_total * upa[folio %in% bov_upa$folio, .(folio, factor)]$factor, na.rm=TRUE)))

# ── 4. Infraestructura y maquinaria — tractores ──────────────────────────────
cat("\n=== Módulo 4: Infraestructura y Maquinaria ===\n")
infra_raw <- as.data.table(read_sav(file.path(raw08,
  "7-INFRAESTRUCTURA Y MAQUINARIA/25.-ENA08_BOLIVIA_INFRAESTRUCTURA-MAQUINARIA(preg_103).sav")))

infra <- infra_raw[, .(
  folio   = as.character(FOLIO),
  factor  = as.numeric(Factor),
  codigo  = as.integer(S14_103A),
  num     = as.numeric(S14_103C)
)]

# Tractores: códigos 9 (<50HP), 10 (50-100HP), 11 (>100HP)
tractores_upa <- infra[codigo %in% c(9, 10, 11), .(
  n_tractores = sum(num, na.rm = TRUE)
), by = folio]

# Silos (códigos 1-2)
silos_upa <- infra[codigo %in% c(1, 2), .(
  tiene_silo = TRUE
), by = folio]

cat(sprintf("UPAs con tractores: %d\n", nrow(tractores_upa)))
cat(sprintf("Tractores expandidos: %.0f\n",
            sum(tractores_upa$n_tractores * upa[folio %in% tractores_upa$folio, .(folio, factor)]$factor, na.rm=TRUE)))

# ── 5. Mano de obra (módulo 23 — miembros del hogar) ─────────────────────────
cat("\n=== Módulo 5: Mano de obra del hogar ===\n")
mo_raw <- as.data.table(read_sav(file.path(raw08,
  "6-MANO DE OBRA/23.-ENA08_BOLIVIA_MIEMBROS_DEL_HOGAR(preg_97).sav")))

mo_vars <- names(mo_raw)
cat("Variables mano de obra:", paste(mo_vars[1:min(15, length(mo_vars))], collapse=", "), "\n")

mo_upa <- mo_raw[, .(
  folio = as.character(FOLIO),
  n_miembros = .N
), by = FOLIO][, folio := as.character(FOLIO)]

# ── 6. Join todo a UPA master ─────────────────────────────────────────────────
cat("\n=== Join UPA master + módulos ===\n")

upa_full <- merge(upa, upa_agro,     by = "folio", all.x = TRUE)
upa_full <- merge(upa_full, bov_upa, by = "folio", all.x = TRUE)
upa_full <- merge(upa_full, tractores_upa, by = "folio", all.x = TRUE)
upa_full <- merge(upa_full, silos_upa,     by = "folio", all.x = TRUE)

# Flags
upa_full[, tiene_cultivos  := !is.na(n_cultivos)]
upa_full[, tiene_bovinos   := !is.na(cab_bovinos_total) & cab_bovinos_total > 0]
upa_full[, tiene_tractores := !is.na(n_tractores) & n_tractores > 0]
upa_full[is.na(n_tractores), n_tractores := 0]
upa_full[is.na(cab_bovinos_total), cab_bovinos_total := 0]
upa_full[is.na(tiene_silo), tiene_silo := FALSE]

cat(sprintf("UPA con cultivos: %d/%d (%.0f%%)\n",
            sum(upa_full$tiene_cultivos), nrow(upa_full),
            100*mean(upa_full$tiene_cultivos)))
cat(sprintf("UPA con bovinos: %d/%d (%.0f%%)\n",
            sum(upa_full$tiene_bovinos), nrow(upa_full),
            100*mean(upa_full$tiene_bovinos)))
cat(sprintf("UPA con tractores: %d/%d (%.0f%%)\n",
            sum(upa_full$tiene_tractores), nrow(upa_full),
            100*mean(upa_full$tiene_tractores)))

# ── 7. Resumen departamental expandido ───────────────────────────────────────
cat("\n=== Resumen departamental — ENA 2008 ===\n")
dept_resumen <- upa_full[, .(
  n_upa_muestra   = .N,
  n_upa_exp       = sum(factor, na.rm = TRUE),
  sup_total_ha    = sum(sup_total_ha * factor, na.rm = TRUE),
  sup_cultiv_ha   = sum(sup_cultivada_ha * factor, na.rm = TRUE),
  cab_bovinos     = sum(cab_bovinos_total * factor, na.rm = TRUE),
  n_tractores     = sum(n_tractores * factor, na.rm = TRUE),
  pct_riego       = weighted.mean(pct_lotes_riego, factor, na.rm = TRUE),
  pct_con_abono   = weighted.mean(tiene_abono, factor, na.rm = TRUE) * 100,
  pct_con_fertiliz= weighted.mean(tiene_fertiliz, factor, na.rm = TRUE) * 100,
  pct_mujer       = weighted.mean(sexo_productor == 2, factor, na.rm = TRUE) * 100,
  sup_media_ha    = weighted.mean(sup_total_ha, factor, na.rm = TRUE)
), by = .(depto, dept_name = dpto_nombre)][order(depto)]

dept_resumen[, survey_year := 2008L]
cat("Resumen por departamento:\n")
print(dept_resumen[, .(dept_name, n_upa_exp = round(n_upa_exp),
                        sup_total_ha = round(sup_total_ha),
                        cab_bovinos = round(cab_bovinos),
                        n_tractores = round(n_tractores),
                        pct_riego = round(pct_riego, 1))])

# ── 8. Nacional total ─────────────────────────────────────────────────────────
cat("\n=== Totales nacionales expandidos ENA 2008 ===\n")
nac <- upa_full[, .(
  n_upa_exp     = sum(factor, na.rm = TRUE),
  sup_total_ha  = sum(sup_total_ha * factor, na.rm = TRUE),
  cab_bovinos   = sum(cab_bovinos_total * factor, na.rm = TRUE),
  n_tractores   = sum(n_tractores * factor, na.rm = TRUE),
  pct_riego     = weighted.mean(pct_lotes_riego, factor, na.rm = TRUE),
  pct_mujer     = weighted.mean(sexo_productor == 2, factor, na.rm = TRUE) * 100
)]
print(nac)

# Comparación con CNA 2013
cat("\n--- Referencia CNA 2013 (para contraste) ---\n")
cat("CNA 2013: 871,807 UPAs | 247K Ha irrigadas | 8.1M bovinos | 36.5K tractores\n")
cat(sprintf("ENA 2008: %.0f UPAs | bovinos=%.0f | tractores=%.0f\n",
            nac$n_upa_exp, nac$cab_bovinos, nac$n_tractores))

# ── 9. Guardar ────────────────────────────────────────────────────────────────
saveRDS(upa_full,      file.path(proc, "ena_2008_upa_indicadores.rds"))
fwrite(upa_full,       file.path(proc, "ena_2008_upa_indicadores.csv"))
saveRDS(cultivos_nac,  file.path(proc, "ena_2008_cultivos_nacional.rds"))
fwrite(cultivos_nac,   file.path(proc, "ena_2008_cultivos_nacional.csv"))
saveRDS(dept_resumen,  file.path(proc, "ena_2008_dept_resumen.rds"))
fwrite(dept_resumen,   file.path(proc, "ena_2008_dept_resumen.csv"))

cat(sprintf("\n✓ ena_2008_upa_indicadores.rds (%d UPAs × %d vars)\n", nrow(upa_full), ncol(upa_full)))
cat(sprintf("✓ ena_2008_cultivos_nacional.rds (%d cultivos)\n", nrow(cultivos_nac)))
cat(sprintf("✓ ena_2008_dept_resumen.rds (%d departamentos)\n", nrow(dept_resumen)))
cat("\n✓ ENA 2008 procesado completamente\n")
