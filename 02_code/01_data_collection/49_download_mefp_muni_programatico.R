# 49_download_mefp_muni_programatico.R
# =============================================================================
# Descarga la DESCOMPOSICIÓN PROGRAMÁTICA (árbol acteco-actividad) del gasto
# agropecuario DEVENGADO a nivel MUNICIPAL, gestión por gestión, 2016–2024.
#
# CIERRA EL GAP que dejaba Jubileo: el portal público de Fundación Jubileo
# (pre.jubileobolivia.org.bo) sólo expone 2012–2021 — sus checkboxes de gestión
# se detienen en 2021. La API de MEFP Presupuesto Abierto, en cambio, devuelve
# el árbol de actividad económica (acteco=2.x.y) filtrable por ENTIDAD ejecutora,
# y las entidades incluyen los ~329 Gobiernos Autónomos Municipales individuales.
# Verificado 2026-06-14: las hojas acteco "2.*" de cada municipio reconcilian al
# 100% con su monto agregado en mefp_agro_entidades_YYYY.json (ej. Sucre 2024 =
# Bs 15 483 436,97 exacto).
#
# Provenance (invariante 3.1):
#   API  : https://abierto.economiayfinanzas.gob.bo/api/acteco-treemap
#   Param: ?gestion=YYYY&entidad=<id_entidad_municipal>
#   Fecha: 2026-06-14   ·   TLS incompleto del servidor → ssl_verifypeer=0
#   Lista de municipios: 01_data/raw/external_gasto_2026/mefp_agro_entidades_YYYY.json
#                        (campo entidad / entidad_desc, filtro "Municipal")
#
# Salida cruda : 01_data/raw/external_gasto_2026/muni_treemap/tree_<ent>_<año>.json
# Parsea       : 02_code/02_cleaning/49_parse_mefp_muni_programatico.R
# Decisión     : ADR-0015 (consolidación territorial del gasto)
# =============================================================================
suppressWarnings(Sys.setlocale("LC_ALL", "en_US.UTF-8"))
library(jsonlite)
if (requireNamespace("stringr", quietly = TRUE)) library(stringr)
HAVE_HTTR2 <- requireNamespace("httr2", quietly = TRUE)   # fallback a curl(1) si falta
if (HAVE_HTTR2) library(httr2)
if (requireNamespace("here", quietly = TRUE)) library(here) else
  here <- function(...) file.path(getwd(), ...)

RAW       <- here("01_data", "raw", "external_gasto_2026")
CACHE_DIR <- file.path(RAW, "muni_treemap")
dir.create(CACHE_DIR, recursive = TRUE, showWarnings = FALSE)

BASE  <- "https://abierto.economiayfinanzas.gob.bo/api/acteco-treemap"
UA    <- "Mozilla/5.0 WB-APER-Research/1.0 (jcmunozmora@gmail.com)"
YEARS <- 2016:2024
DELAY <- 0.30   # seg entre requests (secuencial; servidor responde ~1-2s/req)

# ─── 1. Catálogo de entidades municipales por año (de los JSON ya bajados) ────
# Cada mefp_agro_entidades_YYYY.json trae las entidades del sector agro de ese
# año con su id (entidad) y descripción. Filtramos los Gobiernos Aut. Municipales.
read_muni_catalog <- function(year) {
  f <- file.path(RAW, sprintf("mefp_agro_entidades_%d.json", year))
  if (!file.exists(f)) return(NULL)
  j <- fromJSON(f)
  df <- if (is.data.frame(j)) j else if (!is.null(j$estados)) j$estados else NULL
  if (is.null(df)) return(NULL)
  df <- df[grepl("Municipal", df$entidad_desc, ignore.case = TRUE), ]
  data.frame(
    year        = year,
    entidad_id  = as.integer(df$entidad),
    entidad_desc= df$entidad_desc,
    monto_total = as.numeric(df$monto),
    stringsAsFactors = FALSE
  )
}

catalog <- do.call(rbind, lapply(YEARS, read_muni_catalog))
stopifnot(!is.null(catalog), nrow(catalog) > 0)
cat(sprintf("Catálogo: %d pares (municipio × año), %d municipios únicos, %d años\n",
            nrow(catalog), length(unique(catalog$entidad_id)),
            length(unique(catalog$year))))

# ─── 2. Path de cache de un (municipio, año) ──────────────────────────────────
cache_path <- function(entidad_id, year)
  file.path(CACHE_DIR, sprintf("tree_%d_%d.json", entidad_id, year))
is_cached  <- function(entidad_id, year) {
  p <- cache_path(entidad_id, year); file.exists(p) && file.info(p)$size > 50
}

# ─── 3. Loop principal — descarga PARALELA por lotes ──────────────────────────
# req_perform_parallel hace N requests concurrentes; el servidor MEFP tolera
# ~6-8 simultáneas. El cache en disco hace el proceso reanudable: si se corta,
# re-lanzar saltará lo ya bajado.
# El servidor MEFP rate-limita la concurrencia (~50% de fallos con >2 requests
# simultáneos), pero responde fiable de forma SECUENCIAL (0 fallos). Vamos
# secuencial con delay corto; el cache en disco hace el proceso reanudable.
fetch_tree <- function(entidad_id, year) {
  fpath <- cache_path(entidad_id, year)
  if (is_cached(entidad_id, year)) return("cache")
  if (HAVE_HTTR2) {
    resp <- tryCatch(
      request(BASE) |>
        req_url_query(gestion = year, entidad = entidad_id) |>
        req_user_agent(UA) |> req_timeout(15) |>
        req_options(ssl_verifypeer = 0, ssl_verifyhost = 0) |>
        req_retry(max_tries = 2, backoff = ~ 2) |>
        req_perform(),
      error = function(e) NULL)
    if (is.null(resp) || resp_status(resp) != 200) return(NA_character_)
    writeLines(resp_body_string(resp), fpath, useBytes = TRUE)
  } else {
    # Fallback sin httr2: curl(1) del sistema (TLS incompleto del MEFP → -k).
    url <- sprintf("%s?gestion=%d&entidad=%d", BASE, year, entidad_id)
    suppressWarnings(system2("curl",
      c("-k", "-s", "--max-time", "20", "-A", shQuote(UA), "-o", shQuote(fpath), shQuote(url)),
      stdout = FALSE, stderr = FALSE))
    if (!is_cached(entidad_id, year)) return(NA_character_)
  }
  Sys.sleep(DELAY)
  "ok"
}

main <- function(limit = NULL) {
  cat("┌──────────────────────────────────────────────────────────────┐\n")
  cat("│ MEFP — descomposición programática MUNICIPAL del gasto agro   │\n")
  cat("│ acteco-treemap por entidad · 2016–2024 · secuencial fiable    │\n")
  cat("└──────────────────────────────────────────────────────────────┘\n\n")

  jobs <- catalog
  if (!is.null(limit)) jobs <- jobs[seq_len(min(limit, nrow(jobs))), ]

  t0 <- Sys.time(); ok <- 0L; cached <- 0L; fail <- 0L
  for (i in seq_len(nrow(jobs))) {
    res <- fetch_tree(jobs$entidad_id[i], jobs$year[i])
    if (is.na(res))            fail   <- fail + 1L
    else if (res == "cache")   cached <- cached + 1L
    else                       ok     <- ok + 1L
    if (i %% 100 == 0 || i == nrow(jobs)) {
      el <- difftime(Sys.time(), t0, units = "mins")
      cat(sprintf("  [%4d/%d] ok=%d cache=%d fail=%d · %.1f min\n",
                  i, nrow(jobs), ok, cached, fail, as.numeric(el)))
    }
  }
  done <- sum(mapply(is_cached, jobs$entidad_id, jobs$year))
  cat(sprintf("\n✓ Descarga: %d/%d cacheados (%d sin bajar)\n",
              done, nrow(jobs), nrow(jobs) - done))
  cat(sprintf("  JSON crudos en: %s\n", CACHE_DIR))
  cat("  Siguiente: Rscript 02_code/02_cleaning/51_parse_mefp_muni_programatico.R\n")
  invisible(catalog)
}

if (!interactive()) {
  args  <- commandArgs(trailingOnly = TRUE)
  limit <- if (length(args) >= 1) as.integer(args[1]) else NULL
  main(limit)
}
