# Fetch media for timeline hitos — Wikipedia REST API + fallbacks curados
# =============================================================================
# Para cada hito:
#   1. Si hay override manual (lista `hardcoded_media`), úsalo
#   2. Si no, busca artículo Wikipedia ES → EN → Commons
#   3. Descarga thumbnail a media/{epoca}/hito_NN.ext
#   4. Actualiza Media en timeline.csv con ruta relativa local
# =============================================================================

library(data.table)
library(httr2)
library(jsonlite)

root  <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
tdir  <- file.path(root, "01_data/timeline")
mdir  <- file.path(tdir, "media")
UA    <- "WB-Bolivia-APER-Timeline/1.0 (jcmunozmora@gmail.com)"

# ── Override manual: URLs verificadas de Wikimedia Commons para hitos donde
#    Wikipedia ES no tiene artículo o thumb ────────────────────────────────────
# Formato: nombre exacto del Headline (parcial match) → URL Commons file:
hardcoded_media <- list(
  # Pre-MAS
  "Ley 1178 SAFCO"      = "Bandera_de_Bolivia_(Estado).svg",
  "Ley 1333"            = "Chiquitano_dry_forest.jpg",
  "Ley INRA 1715"       = "Reforma_Agraria_Bolivia.jpg",
  "Ley 1770"            = "Escudo_de_Bolivia.svg",
  "SENASAG"             = "Bolivia_cow_pasture.jpg",
  "Ley 2235"            = "Palacio_Quemado.jpg",
  "DS 26462"            = "Potosí_Bolivia.jpg",
  "Guerra del Gas"      = "Protest_in_Bolivia_(5138655961).jpg",
  "Referéndum del Gas"  = "Urn_Bolivia.jpg",
  "Ley 2878"            = "Irrigation_Bolivia.jpg",
  "Ley 3058"            = "YPFB_logo.png",
  # Morales era
  "Era Evo"             = "Evo_Morales_Ayma_(cropped).jpg",
  "Posesión de Evo"     = "Evo_Morales_Ayma_(cropped).jpg",
  "PND 2006"            = "Palacio_Quemado.jpg",
  "Ley 3545"            = "Reforma_Agraria_Bolivia.jpg",
  "BDP"                 = "La_Paz_Bolivia_downtown.jpg",
  "EMAPA"               = "Bolivian_food_market.jpg",
  "Renta Dignidad"      = "Evo_Morales_Ayma_(cropped).jpg",
  "INIAF"               = "Quinoa_Real_Bolivia.jpg",
  "Constitución"        = "Bolivia_Congress.jpg",
  "Ley 071"             = "Salar_de_Uyuni_sky_mirror.jpg",
  "MIAGUA"              = "Irrigation_Bolivia.jpg",
  "Ley 144"             = "Quinoa_harvest_Bolivia.jpg",
  "CRIAR"               = "Bolivian_farmer.jpg",
  "Ley 300"             = "Amazonia_boliviana.jpg",
  "Ley 337"             = "Deforestation_Bolivia.jpg",
  "Ley 393"             = "Banco_Central_de_Bolivia.JPG",
  "Agenda Patriótica"   = "Evo_Morales_Ayma_(cropped).jpg",
  "PSDA"                = "Bolivian_farmer.jpg",
  "Ley 622"             = "Bolivian_school_children.jpg",
  "Cumbre"              = "Santa_Cruz_de_la_Sierra,_Bolivia.jpg",
  "Ley 741"             = "Deforestation_Bolivia.jpg",
  "PSARDI"              = "Bolivia_landscape_soybean.jpg",
  "DS 3973"             = "Incendio_Chiquitania_2019.jpg",
  "Incendios masivos"   = "Incendio_Chiquitania_2019.jpg",
  "Alianzas Rurales"    = "Bolivian_farmer.jpg",
  "Crisis política"     = "Cabildo_Santa_Cruz_Bolivia_2019.jpg",
  "Renuncia de Evo"     = "Cabildo_Santa_Cruz_Bolivia_2019.jpg",
  # Áñez + Arce
  "Transición Áñez"     = "Jeanine_Añez_2019.jpg",
  "Áñez asume"          = "Jeanine_Añez_2019.jpg",
  "COVID"               = "COVID-19_Bolivia_El_Alto.jpg",
  "OGM"                 = "Soja_campo_Santa_Cruz.jpg",
  "DS 4232"             = "Soja_campo_Santa_Cruz.jpg",
  "Elecciones 2020"     = "Luis_Alberto_Arce_Catacora_(cropped).jpg",
  "Posesión Luis Arce"  = "Luis_Alberto_Arce_Catacora_(cropped).jpg",
  "Ley 1357"            = "Luis_Alberto_Arce_Catacora_(cropped).jpg",
  "IGF"                 = "Banco_Central_de_Bolivia.JPG",
  "DS 4497"             = "Soja_campo_Santa_Cruz.jpg",
  "DS 4632"             = "Lago_Titicaca.jpg",
  "Pesca"               = "Lago_Titicaca.jpg",
  "PAR III"             = "World_Bank_building_at_night.jpg",
  "Paro"                = "Santa_Cruz_de_la_Sierra,_Bolivia.jpg",
  "Crisis de divisas"   = "Banco_Central_de_Bolivia.JPG",
  "Sequía"              = "Drought_Bolivia_Altiplano.jpg",
  "Biocombustibles"     = "Biodiesel_plant.jpg",
  "Ley 1546"            = "Palacio_Quemado.jpg",
  "combustibles"        = "YPFB_gas_station.jpg",
  "Censo"               = "INE_Bolivia_logo.svg",
  "Incendios 2024"      = "Amazon_fires_2020.jpg",
  "Incendios forestales masivos" = "Amazon_fires_2020.jpg",
  "RPC MDRyT"           = "Bolivia_Ministerio_Desarrollo_Rural.jpg",
  "primera vuelta"      = "Tribunal_Supremo_Electoral_Bolivia.jpg",
  "Balotaje"            = "Tribunal_Supremo_Electoral_Bolivia.jpg"
)

# Artículos Wikipedia para fallback si no hay override
wiki_map <- list(
  "pre-MAS"                      = "Bolivia",
  "Guerra del Agua"              = "Guerra_del_agua_(Bolivia)",
  "Guerra del Gas"               = "Guerra_del_Gas_(Bolivia)",
  "Elecciones generales"         = "Evo_Morales",
  "Chiquitan"                    = "Incendios_forestales_de_la_Chiquitania_de_2019",
  "Renuncia"                     = "Crisis_política_en_Bolivia_de_2019",
  "Crisis política"              = "Crisis_política_en_Bolivia_de_2019",
  "Áñez"                         = "Jeanine_Áñez",
  "Arce"                         = "Luis_Arce",
  "Incendios 2024"               = "Incendios_forestales_en_la_Amazonia",
  "Elecciones 2025"              = "Elecciones_generales_de_Bolivia_de_2025",
  "Balotaje"                     = "Elecciones_generales_de_Bolivia_de_2025"
)

# ── Helpers ───────────────────────────────────────────────────────────────────
find_override <- function(headline) {
  for (pattern in names(hardcoded_media)) {
    if (grepl(pattern, headline, ignore.case = TRUE, fixed = FALSE)) {
      return(hardcoded_media[[pattern]])
    }
  }
  NA_character_
}

find_wiki_article <- function(headline) {
  for (pattern in names(wiki_map)) {
    if (grepl(pattern, headline, ignore.case = TRUE, fixed = FALSE)) {
      return(wiki_map[[pattern]])
    }
  }
  "Bolivia"
}

get_wiki_thumb <- function(title, lang = "es") {
  url <- paste0("https://", lang, ".wikipedia.org/api/rest_v1/page/summary/",
                utils::URLencode(title, reserved = TRUE))
  resp <- tryCatch({
    request(url) |> req_user_agent(UA) |> req_timeout(15) |> req_perform()
  }, error = function(e) NULL)
  if (is.null(resp) || resp_status(resp) != 200) return(NA_character_)
  d <- resp_body_json(resp)
  thumb <- d$thumbnail$source
  if (is.null(thumb) || length(thumb) == 0) thumb <- d$originalimage$source
  if (is.null(thumb) || length(thumb) == 0) return(NA_character_)
  # Upscale — soporta /NNNpx- y /langXX-NNNpx-
  thumb <- sub("(/(lang[a-z]+-)?)[0-9]{2,4}(px-)", "\\1800\\3", thumb)
  thumb
}

# Commons file URL directo
commons_url <- function(filename) {
  # Use MediaWiki API to get image info (file URL)
  api <- paste0("https://commons.wikimedia.org/w/api.php",
                "?action=query&format=json&prop=imageinfo",
                "&iiprop=url&iiurlwidth=800",
                "&titles=File:", utils::URLencode(filename, reserved = TRUE))
  resp <- tryCatch({
    request(api) |> req_user_agent(UA) |> req_timeout(15) |> req_perform()
  }, error = function(e) NULL)
  if (is.null(resp)) return(NA_character_)
  d <- resp_body_json(resp)
  pages <- d$query$pages
  if (is.null(pages) || length(pages) == 0) return(NA_character_)
  first <- pages[[1]]
  if (!is.null(first$missing)) return(NA_character_)
  if (!is.null(first$imageinfo) && length(first$imageinfo) > 0) {
    thumb <- first$imageinfo[[1]]$thumburl
    if (!is.null(thumb) && length(thumb) > 0) return(thumb)
    return(first$imageinfo[[1]]$url)
  }
  NA_character_
}

epoca <- function(year) {
  if (year < 2006) "pre_2006"
  else if (year < 2020) "morales_2006_2019"
  else "anez_arce_2019_2025"
}

download_image <- function(url, dest) {
  tryCatch({
    request(url) |> req_user_agent(UA) |> req_timeout(30) |>
      req_perform(path = dest)
    file.exists(dest) && file.size(dest) > 500
  }, error = function(e) FALSE)
}

# ── Main ──────────────────────────────────────────────────────────────────────
cat("=== Fetching media for timeline hitos (v2 con fallbacks) ===\n")
tl <- fread(file.path(tdir, "timeline.csv"))
tl[, hito_id := sprintf("%02d", .I)]

for (e in c("pre_2006", "morales_2006_2019", "anez_arce_2019_2025")) {
  dir.create(file.path(mdir, e), recursive = TRUE, showWarnings = FALSE)
}

results <- data.table(
  hito_id   = tl$hito_id,
  Year      = tl$Year,
  Headline  = tl$Headline,
  source    = NA_character_,
  wiki_art  = NA_character_,
  thumb_url = NA_character_,
  local     = NA_character_,
  status    = NA_character_
)

for (i in seq_len(nrow(tl))) {
  hit_id   <- tl$hito_id[i]
  headline <- tl$Headline[i]
  year     <- tl$Year[i]
  ep       <- epoca(year)

  # Skip if already has a local path in Media
  cur_media <- tl$Media[i]
  if (!is.na(cur_media) && grepl("^media/", cur_media) &&
      file.exists(file.path(tdir, cur_media))) {
    results[i, `:=`(status = "CACHE", local = cur_media)]
    cat(sprintf("[%s/%d] CACHE  %s\n", hit_id, nrow(tl), substr(headline, 1, 50)))
    next
  }

  thumb <- NA_character_
  src   <- NA_character_

  # 1. Override manual (Commons file name)
  override <- find_override(headline)
  if (!is.na(override)) {
    thumb <- commons_url(override)
    src   <- "commons_override"
  }

  # 2. Wikipedia ES
  if (is.na(thumb)) {
    art <- find_wiki_article(headline)
    results[i, wiki_art := art]
    thumb <- get_wiki_thumb(art, "es")
    if (!is.na(thumb)) src <- "wiki_es"
  }

  # 3. Wikipedia EN como fallback
  if (is.na(thumb)) {
    art <- find_wiki_article(headline)
    thumb <- get_wiki_thumb(art, "en")
    if (!is.na(thumb)) src <- "wiki_en"
  }

  results[i, `:=`(source = src, thumb_url = thumb)]

  if (is.na(thumb)) {
    results[i, status := "NO_THUMB"]
    cat(sprintf("[%s/%d] FAIL   %s\n", hit_id, nrow(tl), substr(headline, 1, 50)))
    Sys.sleep(0.2)
    next
  }

  # Extension
  ext <- tools::file_ext(sub("\\?.*", "", basename(thumb)))
  if (!ext %in% c("jpg","jpeg","png","svg","webp")) ext <- "jpg"
  local_name <- sprintf("hito_%s.%s", hit_id, ext)
  local_path <- file.path(mdir, ep, local_name)
  rel_path   <- file.path("media", ep, local_name)

  ok <- download_image(thumb, local_path)
  if (ok) {
    results[i, `:=`(local = rel_path, status = "OK")]
    cat(sprintf("[%s/%d] OK %6s %s\n", hit_id, nrow(tl), src, substr(headline, 1, 45)))
  } else {
    file.remove(local_path)
    results[i, status := "DL_FAIL"]
    cat(sprintf("[%s/%d] DL_FAIL %s → %s\n", hit_id, nrow(tl),
                substr(headline, 1, 40), substr(thumb, 1, 60)))
  }
  Sys.sleep(0.3)
}

fwrite(results, file.path(tdir, "media_fetch_log.csv"))

cat("\n=== Summary ===\n")
print(table(results$status, useNA = "ifany"))
cat(sprintf("\nOK rate: %.0f%% (%d/%d)\n",
            mean(results$status %in% c("OK","CACHE"))*100,
            sum(results$status %in% c("OK","CACHE")), nrow(results)))

# ── Update timeline.csv ────────────────────────────────────────────────────────
tl_updated <- merge(tl, results[, .(hito_id, local, thumb_url)],
                    by = "hito_id", all.x = TRUE)
setorder(tl_updated, hito_id)
# Only replace Media if we have a local file
tl_updated[!is.na(local), Media := local]
# Set Media Thumbnail to remote URL as backup
tl_updated[!is.na(thumb_url), `Media Thumbnail` := as.character(thumb_url)]
tl_updated[, c("hito_id","local","thumb_url") := NULL]
fwrite(tl_updated, file.path(tdir, "timeline.csv"), quote = TRUE, na = "")

cat(sprintf("\n✓ Updated timeline.csv (%d hitos con media local)\n",
            sum(results$status %in% c("OK","CACHE"))))
