# Convierte timeline.csv (formato KnightLab) a JSON para embed sin Google Sheets
# IMPORTANTE: forzar locale UTF-8 antes de cualquier I/O de strings
Sys.setlocale("LC_ALL", "en_US.UTF-8")
options(encoding = "UTF-8")

suppressPackageStartupMessages({
  library(data.table)
  library(jsonlite)
})

setwd("/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia")
tl <- fread("01_data/timeline/timeline.csv", encoding = "UTF-8")

# Encode dates a la estructura KnightLab
make_date <- function(y, m, d) {
  if (is.na(y) || y == "") return(NULL)
  out <- list(year = as.integer(y))
  if (!is.na(m) && m != "") out$month <- as.integer(m)
  if (!is.na(d) && d != "") out$day <- as.integer(d)
  out
}

# Helper: limpiar string (NA → NULL)
clean <- function(x) if (is.na(x) || x == "" || x == "NA") NULL else as.character(x)

# Construir events
events <- list()
title <- NULL

for (i in seq_len(nrow(tl))) {
  row <- tl[i]
  is_title <- !is.na(row$Type) && row$Type == "title"

  ev <- list()
  ev$start_date <- make_date(row$Year, row$Month, row$Day)

  # End date solo si existe Year fin
  if (!is.na(row$`End Year`) && row$`End Year` != "") {
    ev$end_date <- make_date(row$`End Year`, row$`End Month`, row$`End Day`)
  }

  # Display date
  if (!is.null(clean(row$`Display Date`))) ev$display_date <- clean(row$`Display Date`)

  # Text (headline + text)
  ev$text <- list()
  if (!is.null(clean(row$Headline))) ev$text$headline <- clean(row$Headline)
  if (!is.null(clean(row$Text))) ev$text$text <- clean(row$Text)

  # Media — preferir path local del sitio (figures/timeline_media/...)
  # sobre URL externa Wikimedia (más robusto, sin dependencias)
  media_local <- clean(row$Media)
  if (!is.null(media_local) && grepl("^media/", media_local)) {
    # Reescribir media/epoca/hito_NN.ext → figures/timeline_media/epoca/hito_NN.ext
    media_local <- sub("^media/", "figures/timeline_media/", media_local)
  }
  media_url <- if (!is.null(media_local)) media_local
               else if (!is.null(clean(row$`Media Thumbnail`))) clean(row$`Media Thumbnail`)
               else NULL

  if (!is.null(media_url)) {
    ev$media <- list(url = media_url)
    if (!is.null(clean(row$`Media Credit`))) ev$media$credit <- clean(row$`Media Credit`)
    if (!is.null(clean(row$`Media Caption`))) ev$media$caption <- clean(row$`Media Caption`)
  }

  # Group
  if (!is.null(clean(row$Group))) ev$group <- clean(row$Group)

  # Background (color o url)
  if (!is.null(clean(row$Background))) {
    bg <- clean(row$Background)
    if (grepl("^#", bg)) ev$background <- list(color = bg)
    else if (grepl("^http", bg)) ev$background <- list(url = bg)
  }

  if (is_title) {
    title <- ev
  } else {
    events[[length(events) + 1]] <- ev
  }
}

# Estructura final
out <- list(events = events)
if (!is.null(title)) out$title <- title

# Serializar — usar write_json para escritura nativa UTF-8 (sin escape)
out_path     <- "docs/timeline.json"
out_path_www <- "www/downloads/timeline.json"

# write_json escribe directo a archivo con UTF-8 nativo, sin pasar por
# writeLines() que puede escapar bytes según la locale del sistema
write_json(out, out_path, auto_unbox = TRUE, pretty = TRUE, na = "null")
write_json(out, out_path_www, auto_unbox = TRUE, pretty = TRUE, na = "null")

cat(sprintf("✓ %s (%d eventos + %s slide inicial)\n",
            out_path, length(events), ifelse(is.null(title), "sin", "con")))
cat(sprintf("  Tamaño: %.0f KB\n", file.size(out_path)/1024))
