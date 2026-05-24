# Scraper CNA 2013 — Fichas municipales SICE INE Bolivia
# =============================================================================
# Fuente: http://sice.ine.gob.bo/censofichacna/
# Método: POST a c_listadof/listar_comunidades por dept/prov/muni
#
# PASO 1: Construye catálogo completo dept × prov × municipio via AJAX
# PASO 2: Descarga ficha HTML para cada municipio
# PASO 3: Parsea indicadores estructurales (superficie, ganadería, maquinaria,
#         actividad, cultivos totales, indicadores de riego)
#
# Output:
#   - cna2013_municipios.rds    (catálogo completo dept/prov/muni)
#   - cna2013_indicadores.rds   (indicadores por municipio ~340 obs × ~55 vars)
# =============================================================================

library(httr2)
library(rvest)
library(data.table)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")

SICE_BASE  <- "http://sice.ine.gob.bo/censofichacna"
FICHA_URL  <- paste0(SICE_BASE, "/c_listadof/listar_comunidades")
PROV_URL   <- paste0(SICE_BASE, "/c_listadof/llenar_provincias")
MUNI_URL   <- paste0(SICE_BASE, "/c_listadof/llenar_municipios")

DEPTOS <- sprintf("%02d", 1:9)
DEPTO_NAMES <- c("Chuquisaca","La Paz","Cochabamba","Oruro","Potosi",
                  "Tarija","Santa Cruz","Beni","Pando")

# ── PASO 1: Catálogo dept × prov × municipio ─────────────────────────────────
cat("=== PASO 1: Construyendo catálogo de municipios ===\n")

get_options <- function(url, body_list) {
  resp <- tryCatch(
    request(url) |> req_timeout(15) |> req_body_form(!!!body_list) |> req_perform(),
    error = function(e) NULL
  )
  if (is.null(resp) || resp_status(resp) != 200) return(data.table())
  html <- resp |> resp_body_string()
  opts <- regmatches(html, gregexpr('<option value="\\d+">[^<]+', html))[[1]]
  opts <- opts[!grepl('^<option value="-1">', opts)]
  if (length(opts) == 0) return(data.table())
  codes <- regmatches(opts, regexpr('(?<=value=")\\d+', opts, perl=TRUE))
  names_ <- trimws(gsub("^<option value=\"\\d+\">", "", opts))
  # Strip leading "NN " prefix from names
  names_ <- gsub("^\\d+\\s+", "", names_)
  data.table(code = codes, name = names_)
}

catalog_list <- list()
for (dep in DEPTOS) {
  dep_name <- DEPTO_NAMES[as.integer(dep)]
  cat(sprintf("  Dept %s %s...\n", dep, dep_name))
  provs <- get_options(PROV_URL, list(accion="cargar_provincias", id_depto=dep))
  if (nrow(provs) == 0) next
  for (i in seq_len(nrow(provs))) {
    prov <- provs$code[i]
    prov_name <- provs$name[i]
    munis <- get_options(MUNI_URL, list(accion="cargar_municipios",
                                         id_depto=dep, id_provincia=prov))
    if (nrow(munis) == 0) next
    for (j in seq_len(nrow(munis))) {
      catalog_list[[length(catalog_list)+1]] <- data.table(
        cod_depto=dep, depto=dep_name,
        cod_prov=prov, provincia=prov_name,
        cod_muni=munis$code[j], municipio=munis$name[j]
      )
    }
    Sys.sleep(0.2)
  }
}

catalog <- rbindlist(catalog_list)
cat(sprintf("Municipios encontrados: %d\n", nrow(catalog)))
print(catalog[, .N, by=depto])
saveRDS(catalog, file.path(proc, "cna2013_municipios.rds"))
fwrite(catalog,  file.path(proc, "cna2013_municipios.csv"))

# ── PASO 2+3: Descarga y parseo de fichas ────────────────────────────────────
cat("\n=== PASO 2-3: Descargando y parseando fichas municipales ===\n")

# Extrae pares th→td parseando FILA POR FILA (evita desalineamiento
# causado por filas de encabezado intermedias que tienen th sin td)
parse_th_td <- function(tbl_node) {
  rows <- tbl_node |> html_elements("tr")
  pairs <- list()
  for (row in rows) {
    th <- row |> html_elements("th") |> html_text(trim=TRUE)
    td <- row |> html_elements("td") |> html_text(trim=TRUE)
    # Solo registrar si la fila tiene exactamente 1 th y 1 td
    if (length(th) == 1 && length(td) == 1) {
      key <- th[1]
      if (nchar(key) > 0) pairs[[key]] <- td[1]
    }
  }
  if (length(pairs) == 0) return(NULL)
  unlist(pairs)
}

# Limpia número manejando tres formatos del SICE Bolivia:
#   "174.067,53" → 174067.53  (tiene coma → europeo)
#   "7.618"      → 7618       (punto + 3 dígitos al final → miles)
#   "24.38"      → 24.38      (punto + 2 dígitos → decimal)
clean_num <- function(x) {
  x <- trimws(x)
  if (grepl(",", x)) {
    # Formato europeo: punto=miles, coma=decimal
    x <- gsub("\\.", "", x)
    x <- gsub(",", ".", x)
  } else if (grepl("(\\.[0-9]{3})+$", x)) {
    # Solo puntos + grupos de 3 dígitos → separador de miles
    x <- gsub("\\.", "", x)
  }
  x <- gsub("[^0-9.-]", "", x)
  suppressWarnings(as.numeric(x))
}

# Parsea el HTML completo de una ficha y devuelve un named list de valores
parse_ficha <- function(html_str) {
  pg <- read_html(html_str)
  tbls <- pg |> html_elements("table")
  if (length(tbls) == 0) return(NULL)

  # Extraer todos los pares de todas las tablas
  all_pairs <- list()
  for (t in tbls) {
    p <- parse_th_td(t)
    if (!is.null(p)) all_pairs <- c(all_pairs, as.list(p))
  }
  if (length(all_pairs) == 0) return(NULL)

  get_val <- function(keys) {
    for (k in keys) {
      matches <- grep(k, names(all_pairs), ignore.case=TRUE, value=TRUE)
      if (length(matches) > 0) {
        v <- clean_num(all_pairs[[matches[1]]])
        if (!is.na(v)) return(v)
      }
    }
    NA_real_
  }

  get_txt <- function(keys) {
    for (k in keys) {
      matches <- grep(k, names(all_pairs), ignore.case=TRUE, value=TRUE)
      if (length(matches) > 0) return(trimws(all_pairs[[matches[1]]]))
    }
    NA_character_
  }

  list(
    # Datos generales
    zona_agroproductiva = get_txt(c("Zona Agro")),
    n_comunidades       = get_val(c("Numero de Comunidades","Comunidades")),
    sup_total_ha        = get_val(c("Superficie Total en Hect")),
    n_upa               = get_val(c("Unidades de Produccion Agropecuaria","UPA\\)")),

    # Uso de la tierra (Ha)
    sup_agricola        = get_val(c("AGRICOLA$","^AGRICOLA")),
    sup_cult_verano     = get_val(c("Superficie Cultivada de verano","Cultivada de verano")),
    sup_sin_riego       = get_val(c("sin riego")),
    sup_con_riego       = get_val(c("con riego")),
    sup_barbecho        = get_val(c("barbecho")),
    sup_descanso        = get_val(c("descanso")),
    sup_ganaderia       = get_val(c("GANADERÍA$","^GANADERÍA")),
    sup_pastos_cult     = get_val(c("Pastos cultivados")),
    sup_pastos_nat      = get_val(c("Pastos Naturales")),
    sup_forestal        = get_val(c("FORESTAL$","^FORESTAL")),
    sup_plantac         = get_val(c("Plantaciones Forestales")),
    sup_bosques         = get_val(c("Bosques o montes")),
    sup_no_agricola     = get_val(c("NO AGRICOLA")),

    # Ganadería (cabezas)
    cab_bovinos         = get_val(c("Bovinos")),
    cab_bueyes          = get_val(c("Bueyes")),
    cab_bufalos         = get_val(c("ú?falos","Bufalos")),
    cab_ovinos          = get_val(c("Ovinos")),
    cab_porcinos_granja = get_val(c("Porcinos de Granja")),
    cab_porcinos_corral = get_val(c("Porcinos de corral","Porcino de [Cc]orral")),
    cab_caprinos        = get_val(c("Caprinos")),
    cab_llamas          = get_val(c("Llamas")),
    cab_alpacas         = get_val(c("Alpacas")),
    cab_caballos        = get_val(c("Caballos")),
    cab_mulas           = get_val(c("Mulas")),
    cab_asnos           = get_val(c("Asnos")),
    cab_aves_granja     = get_val(c("Aves de granja")),
    cab_aves_corral     = get_val(c("Aves de corral")),

    # Maquinaria (cantidad)
    maq_tractores       = get_val(c("Tractores")),
    maq_trilladoras_mot = get_val(c("Trilladoras con motor")),
    maq_cosechad_mot    = get_val(c("Cosechadoras con motor")),
    maq_motocultores    = get_val(c("Motocultores")),
    maq_fumigacion      = get_val(c("fumigacion","fumigación")),
    maq_arado_mec       = get_val(c("Arados de todo tipo de tracción mecánica")),

    # Actividad principal (personas)
    lab_agricola        = get_val(c("Agricola$","^Agricola")),
    lab_ganadero        = get_val(c("Ganadero$","^Ganadero")),
    lab_total           = get_val(c("^Total$","Total$")),
    lab_no_participa    = get_val(c("No participa")),

    # Indicadores
    sup_prom_upa_ha     = get_val(c("Superficie Promedio por UPA")),
    pct_riego           = get_val(c("Porcentaje de superficie cultivada con Riego"))
  )
}

# Descarga la ficha de un municipio
fetch_ficha <- function(dep, prov, muni, retries=2) {
  for (i in seq_len(retries + 1)) {
    resp <- tryCatch(
      request(FICHA_URL) |>
        req_timeout(20) |>
        req_body_form(departamento=dep, provincias=prov,
                      municipios=muni, comunidades="-1") |>
        req_perform(),
      error = function(e) NULL
    )
    if (!is.null(resp) && resp_status(resp) == 200) {
      html <- resp |> resp_body_string()
      if (nchar(html) > 500) return(html)
    }
    Sys.sleep(1)
  }
  NULL
}

# ── Loop principal ────────────────────────────────────────────────────────────
results_list <- list()
n_total <- nrow(catalog)
n_ok <- 0; n_fail <- 0

cat(sprintf("Procesando %d municipios...\n", n_total))

for (i in seq_len(n_total)) {
  row  <- catalog[i]
  dep  <- row$cod_depto
  prov <- row$cod_prov
  muni <- row$cod_muni
  tag  <- sprintf("%s/%s/%s (%s)", dep, prov, muni, row$municipio)

  html <- fetch_ficha(dep, prov, muni)
  if (is.null(html)) {
    cat(sprintf("  [%3d/%d] FAIL: %s\n", i, n_total, tag))
    n_fail <- n_fail + 1
    next
  }

  vals <- tryCatch(parse_ficha(html), error=function(e) NULL)
  if (is.null(vals)) {
    cat(sprintf("  [%3d/%d] PARSE ERROR: %s\n", i, n_total, tag))
    n_fail <- n_fail + 1
    next
  }

  row_out <- data.table(
    cod_depto  = dep,   depto     = row$depto,
    cod_prov   = prov,  provincia = row$provincia,
    cod_muni   = muni,  municipio = row$municipio,
    as.data.table(vals)
  )
  results_list[[length(results_list)+1]] <- row_out
  n_ok <- n_ok + 1

  if (i %% 20 == 0 || i == n_total)
    cat(sprintf("  [%3d/%d] OK: %s\n", i, n_total, tag))

  Sys.sleep(0.3)   # cortés con el servidor
}

cat(sprintf("\nCompletado: %d OK, %d fallidos de %d total\n", n_ok, n_fail, n_total))

# ── Combinar y guardar ────────────────────────────────────────────────────────
if (length(results_list) > 0) {
  cna_muni <- rbindlist(results_list, use.names=TRUE, fill=TRUE)
  setorder(cna_muni, cod_depto, cod_prov, cod_muni)

  cat("\n=== Indicadores CNA 2013 — muestra Santa Cruz ===\n")
  sc <- cna_muni[cod_depto == "07",
                  .(municipio, n_upa, sup_total_ha, pct_riego,
                    cab_bovinos, maq_tractores, lab_agricola)]
  print(head(sc, 10))

  cat("\n=== Resumen nacional ===\n")
  cat(sprintf("UPAs totales:           %s\n", format(sum(cna_muni$n_upa, na.rm=TRUE), big.mark=",")))
  cat(sprintf("Superficie total (Ha):  %s\n", format(round(sum(cna_muni$sup_total_ha, na.rm=TRUE),0), big.mark=",")))
  cat(sprintf("Bovinos totales:        %s\n", format(sum(cna_muni$cab_bovinos, na.rm=TRUE), big.mark=",")))
  cat(sprintf("Tractores totales:      %s\n", format(sum(cna_muni$maq_tractores, na.rm=TRUE), big.mark=",")))
  cat(sprintf("Sup. con riego (Ha):    %s\n", format(round(sum(cna_muni$sup_con_riego, na.rm=TRUE),0), big.mark=",")))

  saveRDS(cna_muni, file.path(proc, "cna2013_indicadores.rds"))
  fwrite(cna_muni,  file.path(proc, "cna2013_indicadores.csv"))
  cat(sprintf("\n✓ cna2013_indicadores.rds (%d municipios × %d vars)\n",
              nrow(cna_muni), ncol(cna_muni)))
  cat("✓ cna2013_municipios.rds\n")
} else {
  cat("ERROR: No se pudo descargar ninguna ficha\n")
}
