# Panel municipal v3 — Hansen deforestación + CNA 2013
# =============================================================================
# Integra:
#   1. hansen_muni_annual_deforestation.rds → defor_ha por año (2001-2023)
#   2. cna2013_indicadores.rds             → 49 vars estructurales CNA 2013
# sobre municipal_panel_v2_lc.rds para crear municipal_panel_v3.rds
#
# Output: municipal_panel_v3.rds (340 munis × 10 años × ~75 vars)
# =============================================================================

library(data.table)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")

# ── Carga ─────────────────────────────────────────────────────────────────────
mp  <- readRDS(file.path(proc, "municipal_panel_v2_lc.rds"));  setDT(mp)
hm  <- readRDS(file.path(proc, "hansen_muni_annual_deforestation.rds")); setDT(hm)
cna <- readRDS(file.path(proc, "cna2013_indicadores.rds")); setDT(cna)

cat(sprintf("Panel v2: %d obs × %d vars (%d munis)\n",
            nrow(mp), ncol(mp), length(unique(mp$muni_key))))
cat(sprintf("Hansen muni: %d obs × %d vars (%d munis, %d-%d)\n",
            nrow(hm), ncol(hm), length(unique(hm$municipio)),
            min(hm$year), max(hm$year)))
cat(sprintf("CNA 2013: %d munis × %d vars\n", nrow(cna), ncol(cna)))

# ── Normalización de nombres ──────────────────────────────────────────────────
norm <- function(x) gsub("[^A-Z0-9 ]", "", toupper(iconv(trimws(x), from = "UTF-8", to = "ASCII//TRANSLIT")))

mp[,  muni_norm := norm(muni_name)]
hm[,  muni_norm := norm(municipio)]
cna[, muni_norm := norm(municipio)]

# Tabla de correcciones: nombre Hansen → nombre normalizado en panel
corrections_hansen <- c(
  "ALCALA"                       = "VILLA ALCALA",
  "PORONGO"                      = "PORONGO AYACUCHO",
  "POOPO"                        = "POOP  VILLA POOP",   # fallback; handled below
  "CHARAGUA"                     = "3701 GAIOC DE CHARAGUA IYAMBAE",
  "CHIPAYA"                      = "3401 GAIOC DE LA NACION ORIGINARIA URU CHIPAYA",
  "INGAVI"                       = "INGAVI HUMAITA",
  "SICASICA"                     = "SAN PEDRO DE CURAHUARA",
  "VILLA MONTES"                 = "VILLAMONTES",
  "ANDAMARCA"                    = "ANDAMARCA SANTIAGO DE ANDAMAR",
  "EL PUENTE"                    = "EL PUENTE PADILLA",
  "GUAYARAMERIN"                 = "GUAYARAMERIN",
  "HUACARETA"                    = "HUACARETA",
  "IRUPANA"                      = "IRUPANA",
  "MOJOCOYA"                     = "MOJOCOYA",
  "PUNA"                         = "PUNA",
  "SACACA"                       = "SACACA",
  "SIPESIPE"                     = "SIPE SIPE",
  "TARVITA"                      = "TARVITA LAS CARRERAS",
  "TOTORA"                       = "TOTORA",
  "URIONDO"                      = "URIONDO CONCEPCION",
  "VILLA NUEVA"                  = "VILLA NUEVA LORETO",
  "ZUDANEZ"                      = "ZUDANEZ",
  "VITICHE"                      = "TOMAVE",
  "SOPACHUI"                     = "SOPACHUY",
  "MOROMORO"                     = "SAN PABLO DE LIPES",
  "CHUQUIHUTA AYLLU JUCUMANI"   = "CHUQUIHUTA",
  "COLCHA K"                     = "COLCHA K",
  "ENTRE RIOS"                   = "ENTRE RIOS",
  "GENERAL SAAVEDRA"             = "GENERAL SAAVEDRA",
  "HUACAYA"                      = "HUACAYA",
  "HUAYLLAMARCA"                 = "HUAYLLAMARCA",
  "JESUS DE MACHAKA"             = "JESUS DE MACHAKA",
  "PAPEL PAMPA"                  = "PAPEL PAMPA",
  "PARIA"                        = "PARIA",
  "POSTRERVALLE"                 = "POSTRER VALLE",
  "PUERTO ACOSTA"                = "PUERTO ACOSTA",
  "PUERTO MAYOR DE CARABUCO"     = "CARABUCO",
  "PUERTO MAYOR DE GUAQUI"       = "GUAQUI",
  "PUERTO MENOR DE RURRENABAQUE" = "RURRENABAQUE",
  "PUERTO PEREZ"                 = "PUERTO PEREZ",
  "SALINAS DE GARCI MENDOZA"     = "SALINAS DE GARCI MENDOZA",
  "SAN BENITO"                   = "SAN BENITO",
  "SAN JAVIER"                   = "SAN JAVIER",
  "SAN LORENZO"                  = "SAN LORENZO",
  "SAN MIGUEL"                   = "SAN MIGUEL DE VELASCO",
  "SAN PABLO"                    = "SAN PABLO DE LIPES",
  "SAN PEDRO"                    = "SAN PEDRO DE CURAHUARA",
  "SAN RAMON"                    = "SAN RAMON",
  "VILLA ABECIA"                 = "CAMATAQUI VILLA ABECIA",
  "VILLA ANCORAIMES"             = "ANCORAIMES",
  "VILLA RICARDO MUGIA  ICLA"    = "ICLA",
  "WALDO BALLIVIAN"              = "WALDO BALLIVIAN",
  "YUNGUYO DEL LITORAL"          = "YUNGUYO DE LITORAL",
  "AYOPAYA"                      = "INDEPENDENCIA",
  "AZURDUY"                      = "AZURDUY",
  "CHARAZANI"                    = "CHARAZANI CURVA",
  "CHULUMANI"                    = "CHULUMANI",
  "NUESTRA SENORA DE LA PAZ"     = "NUESTRA SENORA DE LA PAZ",
  "LA MARKA SAN ANDRES DE MACH"  = "JESUS DE MACHAKA"
)

# Aplicar correcciones a Hansen
for (wrong in names(corrections_hansen)) {
  right <- corrections_hansen[[wrong]]
  hm[muni_norm == wrong, muni_norm := right]
}

# ── Join Hansen → Panel ───────────────────────────────────────────────────────
# Limitar Hansen al rango de años del panel (2012-2021)
hm_panel <- hm[year %in% unique(mp$year)]
panel_keys <- unique(mp[, .(muni_norm, muni_key)])

hm_join <- merge(hm_panel, panel_keys, by = "muni_norm", all.x = TRUE)
cat(sprintf("\nHansen: %d/%d obs con muni_key asignado\n",
            sum(!is.na(hm_join$muni_key)), nrow(hm_join)))

hm_clean <- hm_join[!is.na(muni_key),
                     .(muni_key, year,
                       defor_ha_year   = defor_ha,
                       forest_2000_ha  = forest_area_2000_ha,
                       defor_pct_2000)]
cat(sprintf("Hansen para panel: %d obs × %d munis × %d años\n",
            nrow(hm_clean), length(unique(hm_clean$muni_key)),
            length(unique(hm_clean$year))))

mp3 <- merge(mp, hm_clean, by = c("muni_key", "year"), all.x = TRUE)

# ── Join CNA 2013 → Panel ─────────────────────────────────────────────────────
# CNA es cross-section 2013 → aplicar a todos los años del panel
cna_vars <- setdiff(names(cna), c("cod_depto","depto","cod_prov","provincia",
                                    "cod_muni","municipio","muni_norm"))
# Join on muni_norm + dept to avoid collisions (e.g., "Santa Rosa" in multiple depts)
cna[, depto_norm := norm(depto)]
mp_keys_dept <- unique(mp[, .(muni_norm, muni_key, dept_norm = norm(dept))])

cna_join <- merge(cna, mp_keys_dept, by.x = c("muni_norm","depto_norm"),
                  by.y = c("muni_norm","dept_norm"), all.x = TRUE)
# Fallback: match on muni_norm solo para los que no tienen dept match
no_dept <- cna_join[is.na(muni_key), .(muni_norm, depto_norm)]
if (nrow(no_dept) > 0) {
  panel_keys_fallback <- unique(mp[, .(muni_norm, muni_key)])
  fallback <- merge(no_dept, panel_keys_fallback, by = "muni_norm", all.x = TRUE)
  # Actualizar solo los primeros matches (para munis duplicados tomar 1)
  fallback <- unique(fallback, by = "muni_norm")
  cna_join <- merge(cna_join, fallback[, .(muni_norm, muni_key_fb = muni_key)],
                    by = "muni_norm", all.x = TRUE)
  cna_join[is.na(muni_key), muni_key := muni_key_fb]
  cna_join[, muni_key_fb := NULL]
}

cat(sprintf("\nCNA: %d/%d munis con muni_key asignado\n",
            sum(!is.na(cna_join$muni_key)), nrow(cna_join)))

cna_clean <- unique(cna_join[!is.na(muni_key), c("muni_key", cna_vars), with = FALSE],
                    by = "muni_key")
mp3 <- merge(mp3, cna_clean, by = "muni_key", all.x = TRUE)

# ── Deduplicar (NA muni_key + nombres duplicados en CNA) ─────────────────────
mp3 <- mp3[!is.na(muni_key)]
mp3 <- unique(mp3, by = c("muni_key", "year"))

# ── Estadísticas de cobertura ─────────────────────────────────────────────────
cat(sprintf("\nPanel v3 final: %d obs × %d vars\n", nrow(mp3), ncol(mp3)))
cat(sprintf("Cobertura Hansen (defor_ha_year): %d/%d obs (%.0f%%)\n",
            sum(!is.na(mp3$defor_ha_year)), nrow(mp3),
            100 * mean(!is.na(mp3$defor_ha_year))))
cat(sprintf("Cobertura CNA (n_upa): %d/%d obs (%.0f%%)\n",
            sum(!is.na(mp3$n_upa)), nrow(mp3),
            100 * mean(!is.na(mp3$n_upa))))

# Muestra
cat("\n=== Muestra panel v3 (Santa Cruz 2019) ===\n")
sc_sample <- mp3[dept == "Santa Cruz" & year == 2019,
                  .(muni_name, agro_strict_bob_mm, defor_ha_year,
                    n_upa, sup_total_ha, pct_riego, cab_bovinos, maq_tractores)]
print(head(sc_sample[!is.na(n_upa)], 8))

# ── Guardar ───────────────────────────────────────────────────────────────────
setorder(mp3, dept, muni_key, year)
saveRDS(mp3, file.path(proc, "municipal_panel_v3.rds"))
fwrite(mp3,  file.path(proc, "municipal_panel_v3.csv"))
cat(sprintf("\n✓ municipal_panel_v3.rds (%d obs × %d vars)\n", nrow(mp3), ncol(mp3)))
cat("  Nuevas vars: defor_ha_year, forest_2000_ha, defor_pct_2000 (Hansen)\n")
cat("  + 43 vars CNA 2013 (n_upa, sup_total_ha, cab_bovinos, etc.)\n")
