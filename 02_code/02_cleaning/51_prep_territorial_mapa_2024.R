# 51_prep_territorial_mapa_2024.R — Geometría municipal (ADM3) + gasto agro TOTAL 2024 (MEFP)
# Reemplaza el insumo del mapa coroplético p10-2020 por agro total MEFP 2024 (USD const. 2015).
# Ver ADR-0015 §5 (revisado): el mapa pasa de gasto productivo Jubileo-2020 a gasto agro total
# MEFP-2024 para alinearse con las figuras de concentración y top-municipios (ya MEFP 2024).
#
# Cobertura: el RDS de geometría (adm3_muni_con_datos_2020.rds) traía 76 polígonos sin muni_name
# ni dept (fallaron el merge con Jubileo). Aquí se recupera (1) el nombre desde shapeName y (2) el
# departamento por vecino más cercano (st_nearest_feature), y se cruza con MEFP 2024 en tres pasadas:
#   P1 exacto por nombre normalizado + dept; P2 tabla de alias explícita (variantes de nombre);
#   P3 pares manuales por ID para los homónimos ambiguos. Objetivo: colocar ~100% del gasto MEFP 2024.
# Los polígonos que queden sin valor son municipios SIN registro de gasto agro MEFP 2024 (gris legítimo,
# no fallo de emparejamiento), idéntico al tratamiento "sin gasto" del mapa 2020.
#
# NOTA sf/stack espacial: vive en el entorno conda 'ds', no en renv (mismo R-4.3). Bootstrap portable.
# Salida: 01_data/processed/adm3_muni_gasto_agro_2024.rds  (sf: 339 polígonos + usd2015 agro total)
suppressWarnings(Sys.setlocale("LC_ALL","en_US.UTF-8"))
if (!requireNamespace("sf", quietly = TRUE)) {
  cand <- c(Sys.getenv("R_GEO_LIBPATH"), file.path(path.expand("~"),"miniforge3/envs/ds/lib/R/library"))
  hit <- cand[nzchar(cand) & dir.exists(file.path(cand,"sf"))]; if (length(hit)) .libPaths(c(.libPaths(), hit[1]))
}
stopifnot(requireNamespace("sf", quietly = TRUE))
suppressMessages({library(dplyr); library(stringr); library(sf)})
if (requireNamespace("here", quietly = TRUE)) library(here) else here <- function(...) file.path(getwd(), ...)
P <- here("01_data","processed")

# --- Normalizador: quita paréntesis y sufijos ANTES de la puntuación; prefijos; colapsa espacios ---
norm2 <- function(x){
  x <- toupper(trimws(x)); x <- iconv(x, to="ASCII//TRANSLIT")
  x <- gsub("\\(.*?\\)", "", x)                                            # secundario entre paréntesis
  x <- gsub(" DEL DEPARTAMENTO DE.*| DEL DEPTO.*| DE LA PROVINCIA.*", "", x)
  x <- gsub("[^A-Z ]", " ", x)                                            # puntuación/comillas -> espacio
  x <- gsub("\\bPUERTO (MAYOR|MENOR) DE ", "", x)
  x <- gsub("\\bNUESTRA SENORA DE ", "", x)
  x <- gsub("\\bSANTIAGO DE ", "", x)
  x <- gsub("\\bVILLA ", "", x)
  x <- gsub("  +", " ", x); x <- trimws(x); gsub(" ", "", x)              # colapsar (Sipe Sipe = Sipesipe)
}

# --- 1. Geometría: recuperar nombre (shapeName) y dept (vecino más cercano) -----------------
a <- readRDS(file.path(P,"adm3_muni_con_datos_2020.rds"))
a$nm_use <- ifelse(is.na(a$muni_name), a$shapeName, a$muni_name)
con <- a[!is.na(a$dept), ]; sinx <- a[is.na(a$dept), ]
if (nrow(sinx) > 0)
  a$dept[is.na(a$dept)] <- con$dept[ st_nearest_feature(st_centroid(st_geometry(sinx)), st_geometry(con)) ]
a$nm <- norm2(a$nm_use)

# --- 2. MEFP 2024: gasto agro total por entidad municipal (USD const. 2015) ------------------
mefp <- readRDS(file.path(P,"territorial_muni_mefp.rds")) %>%
  filter(year == 2024) %>%
  group_by(entidad_id) %>%
  summarise(entidad = first(entidad), dept = first(dept),
            nm = norm2(first(muni_name)), usd2015 = sum(usd2015, na.rm = TRUE), .groups = "drop")

# --- 3. Tabla de alias explícita: nombre normalizado de geometría -> nombre normalizado MEFP --
#     (cada par verificado contra la nomenclatura municipal boliviana; variantes Villa/Puerto/sede)
alias <- c(
  GUAYARAMERIN = "PUERTOGUAYARAMERIN", RURRENABAQUE = "PUERTORURRENABAQUE",   # Beni: prefijo "Puerto"
  ABECIA = "CAMATAQUI", HUACAYA = "DEHUACAYA", HUACARETA = "SANPABLODEHUACARETA",
  SOPACHUI = "SOPACHUY", RICARDOMUGIAICLA = "ICLA",                           # Chuquisaca: sede/ortografía
  AYOPAYA = "INDEPENDENCIA",                                                  # Cochabamba: muni = sede Independencia
  NUESTRASENORADELAPAZ = "LAPAZ", JESUSDEMACHAKA = "JESUSDEMACHACA",
  CHARAZANI = "GENERALJUANJOSEPEREZ", LASANANDRESDEMACH = "SANANDRESDEMACHACA",
  ELALTO = "ELALTODELAPAZ",                                                   # La Paz
  YUNGUYODELLITORAL = "YUNGUYODELITORAL", PARIA = "SORACACHI",                # Oruro: del/de, sede Paria=Soracachi
  HUAYLLAMARCA = "HUAYLLAMARCA",                                             # Oruro (geom quedó en La Paz: ver dept-agnóstico)
  VITICHE = "VITICHI", SANPABLO = "SANPABLODELIPEZ",                          # Potosí: ortografía / Lípez
  GENERALSAAVEDRA = "GENERALAGUSTINSAAVEDRA",                                 # Santa Cruz
  MONTES = "VILLAMONTES"                                                      # Tarija: "Villa Montes" = Villamontes
)

# --- 4. Pasada 1: match exacto por (nm, dept), descartando homónimos dentro de un mismo dept --
dup_geo <- a %>% st_drop_geometry() %>% count(nm, dept) %>% filter(n > 1)
dup_mef <- mefp %>% count(nm, dept) %>% filter(n > 1)
ag <- a %>% st_drop_geometry() %>% select(shapeID, nm, dept) %>%
  anti_join(dup_geo, by = c("nm","dept"))
mf <- mefp %>% anti_join(dup_mef, by = c("nm","dept"))
p1 <- inner_join(ag, mf %>% select(nm, dept, entidad_id, usd2015), by = c("nm","dept"))

# --- 5. Pasada 2: alias (resuelve por nombre MEFP; preferir mismo dept, si no, único global) --
rem_g <- a %>% st_drop_geometry() %>% select(shapeID, nm, dept) %>% filter(!shapeID %in% p1$shapeID)
rem_g$nm_mefp <- ifelse(rem_g$nm %in% names(alias), alias[rem_g$nm], rem_g$nm)
mf2 <- mefp %>% filter(!entidad_id %in% p1$entidad_id)
p2 <- rem_g %>% inner_join(mf2 %>% select(nm_mefp = nm, dept, entidad_id, usd2015),
                           by = c("nm_mefp","dept"))
# alias que cambian de dept (geom mal recuperado): match por nombre MEFP único global
still_g <- rem_g %>% filter(!shapeID %in% p2$shapeID, nm %in% names(alias))
mf3 <- mf2 %>% filter(!entidad_id %in% p2$entidad_id) %>% add_count(nm) %>% filter(n == 1)
p2b <- still_g %>% inner_join(mf3 %>% select(nm_mefp = nm, entidad_id, usd2015), by = "nm_mefp")

# --- 6. Pasada 3: pares manuales por ID. Dos grupos: -----------------------------------------
#   (a) homónimos resueltos por sede/departamento (Totora ×2, San Lorenzo ×2, San Pedro Potosí);
#   (b) variantes de nombre cuyo polígono quedó gris (Colcha K, Macharetí, Moro Moro, Yunchara,
#       Andamarca, Chuquihuta) — cada par verificado contra la nomenclatura municipal boliviana.
# Los homónimos entre departamentos que NO se pueden desambiguar sin código INE (Entre Ríos Cbba/Tarija,
# San Javier Beni/SC, San Ignacio de Velasco/Moxos, Santa Rosa del Sara, San Ramón, El Puente, San Pedro
# de Macha) se dejan SIN colocar: adivinar violaría la trazabilidad. Ver §Reconciliación y ADR-0015.
manual <- tribble(
  ~shapeID,                              ~entidad_id,  # ~municipio
  "33444609B86371599265633",             1515L,        # San Pedro [Potosí] -> San Pedro De Buena Vista
  "33444609B18863033470661",             1331L,        # Totora [Cochabamba] -> Totora (1331, mayor)
  "33444609B99158720513986",             1413L,        # Totora [Oruro] -> Totora (1413)
  "33444609B28508666034993",             1609L,        # San Lorenzo [Tarija] -> San Lorenzo (1609)
  "33444609B99016642424530",             1909L,        # San Lorenzo [Beni->Pando] -> San Lorenzo (1909)
  "33444609B22431638786486",             1521L,        # Colcha "K" [Potosí] -> Colcha "K"
  "33444609B47022297338478",             1128L,        # Macharetí [SC->Chuquisaca] -> Machareti
  "33444609B83192257115411",             1727L,        # Moromoro [Cbba->SC] -> Moro Moro
  "33444609B25815189417469",             1608L,        # Yunchará [Potosí->Tarija] -> Yunchara
  "33444609B27198701178343",             1424L,        # Andamarca [Oruro] -> Andamarca
  "33444609B69303205756490",             1540L         # Chuquihuta Ayllu Jucumani [Potosí] -> Chuquihuta
) %>% inner_join(mefp %>% select(entidad_id, usd2015), by = "entidad_id")

# --- 7. Consolidar crosswalk shapeID -> usd2015 ---------------------------------------------
xwalk <- bind_rows(
  p1  %>% transmute(shapeID, entidad_id, usd2015),
  p2  %>% transmute(shapeID, entidad_id, usd2015),
  p2b %>% transmute(shapeID, entidad_id, usd2015),
  manual %>% transmute(shapeID, entidad_id, usd2015)
) %>% distinct(shapeID, .keep_all = TRUE) %>%
  # 1:1 — un mismo registro MEFP no puede colorear >1 polígono (artefactos de geoBoundaries con
  # nombre duplicado: "Santa Rosa" ×3 y "San Ignacio" ×2 en Beni). Se conserva un polígono por entidad.
  distinct(entidad_id, .keep_all = TRUE)

geo <- a %>% select(shapeID, shapeName, muni_name = nm_use, dept) %>%
  left_join(xwalk, by = "shapeID")
saveRDS(geo, file.path(P, "adm3_muni_gasto_agro_2024.rds"))

# --- 8. Reconciliación + reporte ------------------------------------------------------------
n_match <- sum(!is.na(geo$usd2015)); n_tot <- nrow(geo)
mefp_tot <- sum(mefp$usd2015); placed <- sum(xwalk$usd2015)
cat("\n✅ adm3_muni_gasto_agro_2024.rds\n")
cat(sprintf("Polígonos con gasto 2024: %d / %d (%d%%)\n", n_match, n_tot, round(100*n_match/n_tot)))
cat(sprintf("Gasto MEFP 2024 colocado: %.2f / %.2f M USD (%.1f%%)\n", placed, mefp_tot, 100*placed/mefp_tot))
dbl <- xwalk %>% count(entidad_id) %>% filter(n > 1)
cat("Entidades MEFP asignadas a >1 polígono (debe ser 0):", nrow(dbl), "\n")

unused <- mefp %>% filter(!entidad_id %in% xwalk$entidad_id) %>% arrange(desc(usd2015))
cat("\n=== MEFP 2024 SIN colocar (", nrow(unused), "ent | $", round(sum(unused$usd2015),2), "M ) ===\n")
if (nrow(unused)) unused %>% transmute(entidad_id, entidad = str_trunc(entidad,42), dept = coalesce(dept,"NA"),
                                       usd = round(usd2015,3)) %>% as.data.frame() %>% print(row.names = FALSE)
grey <- geo %>% st_drop_geometry() %>% filter(is.na(usd2015))
cat("\n=== Polígonos sin gasto (gris legítimo:", nrow(grey), ") ===\n")
cat(paste(sprintf("%s [%s]", grey$muni_name, grey$dept), collapse = " | "), "\n")
cat("\nRango gasto agro total 2024 (USD M const 2015):",
    paste(round(range(geo$usd2015, na.rm = TRUE), 3), collapse = " - "),
    "| top:", geo$muni_name[which.max(geo$usd2015)], "\n")
