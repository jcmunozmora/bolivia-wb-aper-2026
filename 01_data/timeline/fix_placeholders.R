# Fix placeholder images in timeline
# =============================================================================
# 31 hitos recibieron el thumbnail SVG del mapa de Bolivia (1066 bytes).
# Este script identifica esos hitos, busca imágenes temáticas más relevantes
# en Wikimedia Commons, y las reemplaza.
# =============================================================================

library(data.table)
library(httr2)
library(jsonlite)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
tdir <- file.path(root, "01_data/timeline")
UA   <- "WB-Bolivia-APER-Timeline/1.0 (jcmunozmora@gmail.com)"

# ── Mapeo curado: hito # → search query en Commons + file preferido (opcional)
# Estos reemplazos fueron investigados manualmente para maximizar relevancia
replacements <- list(
  # Pre-MAS
  "03" = list(topic = "Ley 1333 Medio Ambiente 1992",
              files = c("Madidi_National_Park_Bolivia.jpg",
                        "Bolivian_Amazon_rainforest.jpg",
                        "Amazonia_Bolivia.jpg")),
  "05" = list(topic = "Ley INRA 1715 Reforma Agraria 1996",
              files = c("Farmland_in_Bolivia.jpg",
                        "Tierras_comunitarias_Bolivia.jpg",
                        "Quinoa_harvest_in_Bolivia.jpg")),
  "07" = list(topic = "SENASAG 2000 sanidad agropecuaria",
              files = c("Cattle_in_Bolivia.jpg",
                        "Ganado_vacuno_Bolivia.jpg")),
  "09" = list(topic = "HIPC II Diálogo Nacional Bolivia",
              files = c("Palacio_Quemado_Bolivia.jpg",
                        "Plaza_Murillo.jpg")),
  "10" = list(topic = "Pobreza rural Bolivia",
              files = c("El_Alto_Bolivia_2011.jpg",
                        "Rural_poverty_Bolivia.jpg")),
  "12" = list(topic = "Referéndum 2004 Bolivia",
              files = c("Urn_election_Bolivia.jpg",
                        "Bolivian_election.jpg")),
  "13" = list(topic = "Riego agrícola Bolivia",
              files = c("Irrigation_canal.jpg",
                        "Drip_irrigation.jpg",
                        "Farm_irrigation.jpg")),
  "14" = list(topic = "YPFB Hidrocarburos Bolivia",
              files = c("YPFB_building.jpg",
                        "Natural_gas_field.jpg")),
  # Morales
  "18" = list(topic = "Plan Nacional Desarrollo 2006 Bolivia",
              files = c("Plaza_Murillo_Bolivia.jpg",
                        "Palacio_Quemado_La_Paz.jpg")),
  "19" = list(topic = "Reforma agraria comunitaria Bolivia",
              files = c("Land_reform_Bolivia.jpg",
                        "Indigenous_farmer_Bolivia.jpg",
                        "Quinoa_Real_Bolivia.jpg")),
  "20" = list(topic = "Banco Desarrollo Productivo Bolivia",
              files = c("Banco_Central_de_Bolivia.JPG",
                        "La_Paz_downtown.jpg")),
  "21" = list(topic = "EMAPA alimentos Bolivia",
              files = c("Bolivian_market.jpg",
                        "Food_market_Bolivia.jpg",
                        "Soybean_harvest.jpg")),
  "23" = list(topic = "INIAF investigación agrícola Bolivia",
              files = c("Quinoa_harvest_in_Bolivia.jpg",
                        "Agricultural_research.jpg")),
  "24" = list(topic = "Constitución 2009 Bolivia",
              files = c("Constitution_Bolivia.jpg",
                        "Asamblea_Constituyente_Bolivia.jpg",
                        "Plaza_Murillo_Bolivia.jpg")),
  "25" = list(topic = "Pachamama Madre Tierra",
              files = c("Salar_de_Uyuni_reflection.jpg",
                        "Pachamama_ceremony.jpg",
                        "Andean_landscape.jpg")),
  "26" = list(topic = "MIAGUA riego Bolivia",
              files = c("Drip_irrigation.jpg",
                        "Irrigation_system.jpg",
                        "Water_reservoir_Bolivia.jpg")),
  "27" = list(topic = "Revolución productiva agropecuaria Bolivia",
              files = c("Quinoa_harvest_in_Bolivia.jpg",
                        "Farming_Bolivia.jpg")),
  "28" = list(topic = "CRIAR agricultura familiar Bolivia",
              files = c("Indigenous_farmer_Bolivia.jpg",
                        "Bolivian_farmer.jpg",
                        "Farming_Bolivia.jpg")),
  "29" = list(topic = "Ley 300 Madre Tierra Bolivia",
              files = c("Salar_de_Uyuni_sky.jpg",
                        "Bolivian_Amazon.jpg")),
  "31" = list(topic = "Servicios financieros banca Bolivia",
              files = c("Banco_Central_de_Bolivia.JPG",
                        "La_Paz_financial_district.jpg")),
  "33" = list(topic = "PSDA agropecuario Bolivia 2014",
              files = c("Santa_Cruz_agriculture.jpg",
                        "Soybean_field_Bolivia.jpg")),
  "34" = list(topic = "Alimentación escolar Bolivia",
              files = c("School_lunch.jpg",
                        "Children_Bolivia.jpg")),
  "37" = list(topic = "PSARDI Plan Sectorial 2016 Bolivia",
              files = c("Santa_Cruz_agriculture.jpg",
                        "Bolivian_agriculture.jpg")),
  "38" = list(topic = "DS 3973 chaqueo desmonte 2019",
              files = c("Deforestation_Bolivia.jpg",
                        "Amazon_deforestation.jpg",
                        "Slash_and_burn.jpg")),
  # Áñez+Arce
  "50" = list(topic = "Banco Mundial Washington oficina",
              files = c("World_Bank_Group_building.jpg",
                        "World_Bank_headquarters.jpg",
                        "International_Monetary_Fund_building.jpg")),
  "51" = list(topic = "Paro Santa Cruz Censo 2022",
              files = c("Santa_Cruz_de_la_Sierra.jpg",
                        "Protest_Santa_Cruz.jpg",
                        "Catedral_Santa_Cruz.jpg")),
  "52" = list(topic = "Crisis divisas dólar paralelo Bolivia",
              files = c("Bolivia_boliviano_banknotes.jpg",
                        "Banco_Central_de_Bolivia.JPG",
                        "US_dollar_banknotes.jpg")),
  "55" = list(topic = "Presupuesto general Bolivia 2024",
              files = c("Palacio_Quemado_Bolivia.jpg",
                        "Ministerio_Economia_Bolivia.jpg",
                        "Plaza_Murillo_Bolivia.jpg")),
  "57" = list(topic = "Censo Nacional 2024 Bolivia",
              files = c("INE_Bolivia.jpg",
                        "Population_census.jpg",
                        "La_Paz_Bolivia_aerial.jpg")),
  "58" = list(topic = "Incendios 2024 Amazonia Bolivia",
              files = c("Amazon_fires_2020.jpg",
                        "Bolivia_wildfires.jpg",
                        "Incendio_forestal_Bolivia.jpg",
                        "Big_wildfire_in_San_Jose_de_Chiquitos,_Bolivia.jpg")),
  "59" = list(topic = "MDRyT Ministerio Desarrollo Rural",
              files = c("Farming_Bolivia.jpg",
                        "Santa_Cruz_agriculture.jpg",
                        "Bolivian_farmer.jpg"))
)

# ── Helper: Commons search for fallback ───────────────────────────────────────
commons_search <- function(query, n = 5) {
  api <- paste0("https://commons.wikimedia.org/w/api.php",
                "?action=query&format=json&generator=search",
                "&gsrsearch=", utils::URLencode(query, reserved = TRUE),
                "&gsrnamespace=6&gsrlimit=", n,
                "&prop=imageinfo&iiprop=url&iiurlwidth=800")
  resp <- tryCatch({
    request(api) |> req_user_agent(UA) |> req_timeout(15) |> req_perform()
  }, error = function(e) NULL)
  if (is.null(resp)) return(character(0))
  d <- resp_body_json(resp)
  if (is.null(d$query$pages) || length(d$query$pages) == 0) return(character(0))
  urls <- c()
  for (p in d$query$pages) {
    if (!is.null(p$imageinfo) && length(p$imageinfo) > 0) {
      u <- p$imageinfo[[1]]$thumburl
      if (is.null(u) || length(u) == 0) u <- p$imageinfo[[1]]$url
      if (!is.null(u) && length(u) > 0) urls <- c(urls, as.character(u))
    }
  }
  urls
}

commons_file_url <- function(filename) {
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
  if (length(pages) == 0) return(NA_character_)
  p <- pages[[1]]
  if (!is.null(p$missing)) return(NA_character_)
  if (!is.null(p$imageinfo) && length(p$imageinfo) > 0) {
    u <- p$imageinfo[[1]]$thumburl
    if (is.null(u) || length(u) == 0) u <- p$imageinfo[[1]]$url
    if (!is.null(u)) return(as.character(u))
  }
  NA_character_
}

download_image <- function(url, dest) {
  tryCatch({
    request(url) |> req_user_agent(UA) |> req_timeout(30) |>
      req_perform(path = dest)
    file.exists(dest) && file.size(dest) > 5000  # >5KB para evitar placeholders
  }, error = function(e) FALSE)
}

epoca <- function(year) {
  if (year < 2006) "pre_2006"
  else if (year < 2020) "morales_2006_2019"
  else "anez_arce_2019_2025"
}

# ── Identify placeholder hitos (1066 bytes) ──────────────────────────────────
tl <- fread(file.path(tdir, "timeline.csv"))
tl[, hito_id := sprintf("%02d", .I)]

placeholders <- c()
for (i in seq_len(nrow(tl))) {
  m <- tl$Media[i]
  if (grepl("^media/", m)) {
    p <- file.path(tdir, m)
    if (file.exists(p) && file.size(p) == 1066) {
      placeholders <- c(placeholders, tl$hito_id[i])
    }
  }
}
cat(sprintf("Detectados %d hitos con placeholder 1066B\n", length(placeholders)))
cat("Hitos:", paste(placeholders, collapse = ", "), "\n\n")

# ── Fix each one ──────────────────────────────────────────────────────────────
fixed <- 0
failed <- c()

for (hid in placeholders) {
  i <- as.integer(hid)
  headline <- tl$Headline[i]
  year     <- tl$Year[i]
  ep       <- epoca(year)
  local_path <- file.path(tdir, "media", ep, sprintf("hito_%s.png", hid))

  cat(sprintf("[%s] %s\n", hid, substr(headline, 1, 60)))

  # Determinar ubicación de archivo destino (puede ser jpg)
  rep <- replacements[[hid]]

  urls_to_try <- c()
  if (!is.null(rep)) {
    # Probar archivos curados primero
    for (fn in rep$files) {
      u <- commons_file_url(fn)
      if (!is.na(u)) urls_to_try <- c(urls_to_try, u)
    }
    # Luego búsqueda por tema
    urls_to_try <- c(urls_to_try, commons_search(rep$topic, n = 5))
  } else {
    # Fallback genérico: buscar por headline
    urls_to_try <- commons_search(headline, n = 5)
  }

  urls_to_try <- unique(urls_to_try)
  if (length(urls_to_try) == 0) {
    cat("  NO candidates\n"); failed <- c(failed, hid); next
  }

  # Intentar descargar hasta que funcione
  success <- FALSE
  for (u in urls_to_try) {
    ext <- tools::file_ext(sub("\\?.*", "", basename(u)))
    if (!ext %in% c("jpg","jpeg","png","svg","webp")) ext <- "jpg"
    new_path <- file.path(tdir, "media", ep, sprintf("hito_%s.%s", hid, ext))

    # Remove old placeholder first
    if (file.exists(local_path) && file.size(local_path) == 1066) {
      file.remove(local_path)
    }

    if (download_image(u, new_path)) {
      cat(sprintf("  OK → %s (%d bytes)\n", basename(new_path), file.size(new_path)))
      # Update CSV with new path
      rel <- file.path("media", ep, basename(new_path))
      tl[i, Media := rel]
      tl[i, `Media Thumbnail` := u]
      fixed <- fixed + 1
      success <- TRUE
      break
    } else {
      if (file.exists(new_path)) file.remove(new_path)
    }
  }

  if (!success) {
    cat("  FAIL all candidates\n")
    failed <- c(failed, hid)
  }
  Sys.sleep(0.3)
}

tl[, hito_id := NULL]
fwrite(tl, file.path(tdir, "timeline.csv"), quote = TRUE, na = "")

cat(sprintf("\n=== Resumen ===\n"))
cat(sprintf("Placeholders detectados: %d\n", length(placeholders)))
cat(sprintf("Reemplazados exitosamente: %d\n", fixed))
cat(sprintf("Fallidos (quedan con placeholder): %d\n", length(failed)))
if (length(failed) > 0) {
  cat("Hitos fallidos:", paste(failed, collapse = ", "), "\n")
}
