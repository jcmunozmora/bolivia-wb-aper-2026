# BCB snapshot crédito + WDI indicadores financieros para Bolivia
# =============================================================================
# A) BCB Cuadro 3.03 (snapshot más reciente): crédito por sector económico
#    → agropecuario como % del total del sistema bancario
# B) WDI: indicadores financieros Bolivia 1990-2023 (crédito, tasas, acceso)
#
# Output:
#   - bcb_credito_sector_snapshot.rds  (cross-section por banco y sector)
#   - bcb_credito_agro_total.rds       (agregado agropecuario por tipo banco)
#   - wdi_financial_bolivia.rds        (serie histórica WDI sector financiero)
# =============================================================================

library(httr2)
library(readxl)
library(data.table)
library(jsonlite)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")
raw  <- file.path(root, "01_data/raw/bcb")

# ══════════════════════════════════════════════════════════
# A. BCB Cuadro 3.03 — Crédito por sector económico
#    (snapshot más reciente disponible: sept 2025)
# ══════════════════════════════════════════════════════════
cat("=== A. BCB Crédito por sector económico ===\n")

bcb_url <- "https://www.bcb.gob.bo/webdocs/publicacionesbcb/2025/12/31/03_03.xlsx"
bcb_file <- file.path(raw, "bcb_credito_sector_2025.xlsx")

if (!file.exists(bcb_file)) {
  r <- tryCatch(
    request(bcb_url) |> req_timeout(30) |> req_perform(),
    error = function(e) NULL
  )
  if (!is.null(r) && r$status_code == 200) {
    writeBin(r$body, bcb_file)
    cat("Descargado:", basename(bcb_file), "\n")
  } else {
    cat("No se pudo descargar el archivo BCB\n")
  }
}

if (file.exists(bcb_file)) {
  raw_bcb <- as.data.table(read_excel(bcb_file, col_names = FALSE))

  # Estructura: col1=banco, col2=industria, col3=agropec, col4=minería, col5=construcción...
  # Fila 7: headers de sectores
  header_row <- as.character(unlist(raw_bcb[7, ]))
  cat("Sectores:", paste(na.omit(header_row), collapse=" | "), "\n")

  # Filas de datos (bancos): buscar filas con "TOTAL" para cada grupo
  # Identificar filas TOTAL de cada grupo de bancos
  totals <- raw_bcb[grepl("^TOTAL$", trimws(as.character(raw_bcb[[1]])), ignore.case=TRUE)]
  cat("Filas TOTAL encontradas:", nrow(totals), "\n")

  # Leer estructura limpia: fila 9+ = datos
  snap <- raw_bcb[9:.N]
  setnames(snap, c("banco", "industria", "agropecuario", "mineria",
                    "construccion", "comercio", "servicios", "consumo",
                    "microempresa", "vivienda", "otros", "total",
                    "extra1", "extra2")[1:ncol(snap)])

  # Convertir a numeric
  num_cols <- setdiff(names(snap), "banco")
  snap[, (num_cols) := lapply(.SD, function(x) suppressWarnings(as.numeric(x))),
       .SDcols = num_cols]

  # Filtrar solo filas TOTAL de cada grupo
  totals_snap <- snap[grepl("^TOTAL$", trimws(banco), ignore.case=TRUE) & !is.na(agropecuario)]

  # Calcular agropecuario como % del total
  totals_snap[, agro_pct := round(agropecuario / total * 100, 2)]
  totals_snap[, snapshot_date := "Sept-2025"]

  cat("\nCrédito agropecuario por grupo bancario (snapshot Sept 2025, miles BOB):\n")
  print(totals_snap[, .(banco, agropecuario = round(agropecuario/1e3,0),
                         total = round(total/1e3,0), agro_pct)])

  # Agregado total sistema
  tot_sistema <- snap[grepl("SISTEMA", toupper(banco)) & !is.na(agropecuario)]
  if (nrow(tot_sistema) == 0) {
    # Si no hay fila sistema, sumar todos los TOTAL
    tot_agro <- sum(totals_snap$agropecuario, na.rm=TRUE)
    tot_total <- sum(totals_snap$total, na.rm=TRUE)
    cat(sprintf("\nSistema total: Agropecuario = %.0f miles BOB | %.1f%% del total\n",
                tot_agro/1e3, tot_agro/tot_total*100))
  }

  saveRDS(snap,         file.path(proc, "bcb_credito_sector_snapshot.rds"))
  saveRDS(totals_snap,  file.path(proc, "bcb_credito_agro_total.rds"))
  fwrite(totals_snap,   file.path(proc, "bcb_credito_agro_total.csv"))
  cat("✓ bcb_credito_sector_snapshot.rds\n")
  cat("✓ bcb_credito_agro_total.rds\n")
} else {
  cat("AVISO: archivo BCB no disponible — saltando sección A\n")
}

# ══════════════════════════════════════════════════════════
# B. WDI — indicadores financieros Bolivia 1990-2023
# ══════════════════════════════════════════════════════════
cat("\n=== B. WDI indicadores financieros Bolivia ===\n")

get_wdi_single <- function(indicator_code, country = "BOL", year_from = 1990, year_to = 2023) {
  url <- sprintf(
    "https://api.worldbank.org/v2/country/%s/indicator/%s?format=json&date=%d:%d&per_page=5000",
    country, indicator_code, year_from, year_to
  )
  resp <- tryCatch(
    request(url) |> req_timeout(20) |> req_retry(max_tries=3, backoff=~2) |> req_perform(),
    error = function(e) NULL
  )
  if (is.null(resp) || resp$status_code != 200) return(NULL)
  parsed <- tryCatch(fromJSON(rawToChar(resp$body)), error = function(e) NULL)
  if (is.null(parsed) || length(parsed) < 2 || is.null(parsed[[2]])) return(NULL)
  raw_dt <- parsed[[2]]
  if (is.null(raw_dt) || length(raw_dt) == 0) return(NULL)
  data.table(
    year  = as.integer(raw_dt$date),
    value = as.numeric(raw_dt$value)
  )
}

# Indicadores financieros clave para contexto del APER
fin_indicators <- data.table(
  code = c(
    "FS.AST.PRVT.GD.ZS",  # Crédito sector privado % PIB
    "FS.AST.DOMS.GD.ZS",  # Crédito doméstico % PIB
    "FD.AST.PRVT.GD.ZS",  # Crédito bancos al sector privado % PIB
    "FR.INR.LEND",         # Tasa de interés activa %
    "FR.INR.DPST",         # Tasa de interés pasiva %
    "FR.INR.RINR",         # Tasa de interés real %
    "FB.BNK.CAPA.ZS",     # Capital bancario/activos %
    "FB.AST.NPER.ZS"      # Préstamos no productivos %
  ),
  label = c(
    "credito_privado_pct_gdp", "credito_domestico_pct_gdp",
    "credito_bancos_privado_pct", "tasa_activa_pct",
    "tasa_pasiva_pct", "tasa_real_pct",
    "capital_activos_pct", "npl_pct"
  )
)

fin_list <- list()
for (i in seq_len(nrow(fin_indicators))) {
  code  <- fin_indicators$code[i]
  label <- fin_indicators$label[i]
  cat(sprintf("  %-35s ... ", label))
  dt <- get_wdi_single(code)
  if (!is.null(dt) && nrow(dt) > 0) {
    dt[, indicator := label]
    fin_list[[label]] <- dt
    cat(sprintf("OK (%d obs)\n", sum(!is.na(dt$value))))
  } else {
    cat("sin datos\n")
  }
  Sys.sleep(0.3)
}

if (length(fin_list) > 0) {
  fin_long <- rbindlist(fin_list)
  fin_wide <- dcast(fin_long, year ~ indicator, value.var = "value", fun.aggregate = mean)
  setorder(fin_wide, year)

  cat("\nIndicadores financieros Bolivia (selección 2010-2022):\n")
  show_cols <- intersect(c("year","credito_privado_pct_gdp","tasa_activa_pct","tasa_real_pct"), names(fin_wide))
  print(fin_wide[year %in% 2010:2022, ..show_cols])

  saveRDS(fin_wide, file.path(proc, "wdi_financial_bolivia.rds"))
  fwrite(fin_wide,  file.path(proc, "wdi_financial_bolivia.csv"))
  cat("\n✓ wdi_financial_bolivia.rds (", nrow(fin_wide), "años x", ncol(fin_wide), "vars)\n")
} else {
  cat("No se pudieron descargar indicadores financieros WDI\n")
}
