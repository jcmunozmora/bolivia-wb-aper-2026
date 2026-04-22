# FAOSTAT PP — Precios productor Bolivia + WB Pink Sheet (referencia mundial)
# =============================================================================
# Fuente 1: FAOSTAT Producer Prices (PP) — bulk download Americas
#   URL: bulks-faostat.fao.org/production/Prices_E_Americas.zip
#   Bolivia área código 19 | 1991-2024 | ~80 commodities
#   Elementos: LCU/tonne, USD/tonne, SLC/tonne, Índice (2014-2016=100)
#
# Fuente 2: World Bank Commodity Markets Outlook (Pink Sheet)
#   URL: thedocs.worldbank.org …/CMO-Historical-Data-Annual.xlsx
#   Cobertura: 1960-2025, precios mundiales (USD) para commodities clave
#
# Propósito: Extender cálculo de Nominal Rate of Protection (NRP) pre-2006
#   NRP = (Precio doméstico USD/t - Precio referencia USD/t) / Precio ref.
#   IDB AgriMonitor cubre PSE 2006-2023; este script añade 1991-2005
#
# Key commodities PSE Bolivia: soya, maíz, trigo, arroz, papa, quinua,
#   girasol, caña azúcar, ganado bovino (carne)
#
# Outputs:
#   faostat_pp_bolivia.rds       — Bolivia PP × 80 commodities × 1991-2024
#   faostat_pp_lac.rds           — LAC comparadores PP × commodities clave
#   wb_pink_sheet_agro.rds       — WB precios mundiales referencia × 1960-2025
#   pse_nrp_extended.rds         — NRP Bolivia 1991-2023 × 8 commodities
#   spending_panel_v10.rds       — panel v9 + avg_nrp_1991 (NRP promedio anual)
# =============================================================================

library(data.table)
library(readxl)

root    <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
raw_fao <- file.path(root, "01_data/raw/faostat")
raw_wb  <- file.path(root, "01_data/raw/worldbank")
proc    <- file.path(root, "01_data/processed")

for (d in c(raw_fao, raw_wb)) if (!dir.exists(d)) dir.create(d, recursive = TRUE)

# ── 1. Descargar FAOSTAT PP Americas ─────────────────────────────────────────
cat("=== 1. FAOSTAT Producer Prices — Americas ===\n")
pp_zip  <- file.path(raw_fao, "faostat_pp_americas.zip")
pp_url  <- "https://bulks-faostat.fao.org/production/Prices_E_Americas.zip"

if (!file.exists(pp_zip)) {
  cat("Descargando Prices_E_Americas.zip...\n")
  download.file(pp_url, pp_zip, mode = "wb", quiet = FALSE)
  cat(sprintf("  Descargado: %.0f KB\n", file.size(pp_zip)/1024))
} else {
  cat(sprintf("Usando caché: %s\n", basename(pp_zip)))
}

pp_dir <- file.path(raw_fao, "pp_americas_unzipped")
if (!dir.exists(pp_dir)) {
  dir.create(pp_dir)
  unzip(pp_zip, exdir = pp_dir)
}
pp_raw <- fread(file.path(pp_dir, "Prices_E_Americas_NOFLAG.csv"))
cat(sprintf("PP Americas raw: %d obs × %d cols\n", nrow(pp_raw), ncol(pp_raw)))

# ── 2. Filtrar Bolivia: annual value + key elements ───────────────────────────
# Bolivia = area code 19 en FAOSTAT
bol_pp <- pp_raw[`Area Code` == 19 & Months == "Annual value"]
cat(sprintf("Bolivia PP (anual): %d obs\n", nrow(bol_pp)))

yr_cols <- grep("^Y[0-9]{4}$", names(bol_pp), value = TRUE)
years   <- as.integer(sub("^Y", "", yr_cols))

# Reshape a long
pp_long <- melt(bol_pp,
                id.vars      = c("Area Code", "Area", "Item Code", "Item",
                                 "Element Code", "Element", "Unit"),
                measure.vars = yr_cols,
                variable.name = "yr_lbl",
                value.name   = "price")
pp_long[, year := as.integer(sub("^Y", "", yr_lbl))]
pp_long[, yr_lbl := NULL]
pp_long[, price := suppressWarnings(as.numeric(price))]
pp_long <- pp_long[!is.na(price)]
setnames(pp_long,
         c("Area Code","Item Code","Item","Element","Unit"),
         c("area_code","item_code","item","element","unit"))

# Simplificar nombre de elemento
pp_long[, element_short := fcase(
  grepl("LCU",   element), "pp_lcu",
  grepl("USD",   element), "pp_usd",
  grepl("SLC",   element), "pp_slc",
  grepl("Index", element), "pp_idx",
  default = "other"
)]
pp_long <- pp_long[element_short != "other"]

cat(sprintf("Bolivia PP long: %d obs | %d commodities | %d-%d\n",
            nrow(pp_long), uniqueN(pp_long$item),
            min(pp_long$year), max(pp_long$year)))

# Guardar long format completo
saveRDS(pp_long, file.path(proc, "faostat_pp_bolivia.rds"))
fwrite(pp_long,  file.path(proc, "faostat_pp_bolivia.csv"))
cat("✓ faostat_pp_bolivia.rds\n")

# ── 3. Wide format — PSE commodities clave ────────────────────────────────────
cat("\n=== 3. PP Bolivia — commodities clave para PSE ===\n")

# Mapeo: nombre FAOSTAT → código corto
commodities <- list(
  soya     = "Soya beans",
  maiz     = "Maize (corn)",
  trigo    = "Wheat",
  arroz    = "Rice",
  papa     = "Potatoes",
  quinua   = "Quinoa",
  girasol  = "Sunflower seed",
  cana     = "Sugar cane",
  sorgo    = "Sorghum",
  cebada   = "Barley",
  cafe     = "Coffee, green",
  carne_bov = "Meat of cattle with the bone, fresh or chilled (biological)",
  leche    = "Raw milk of cattle",
  huevos   = "Hen eggs in shell, fresh"
)

pp_key <- pp_long[item %in% unlist(commodities) & element_short == "pp_usd"]
pp_key[, commodity := names(commodities)[match(item, unlist(commodities))]]
pp_key <- pp_key[!is.na(commodity)]

# Wide: year × commodity
pp_wide_usd <- dcast(pp_key[, .(year, commodity, price)],
                     year ~ commodity,
                     value.var = "price")

cat("\n=== Bolivia — Precios productor USD/ton (muestra) ===\n")
print(pp_wide_usd[year %in% c(1991, 1995, 2000, 2005, 2010, 2015, 2020, 2024),
                  .(year, soya, maiz, trigo, arroz, papa, quinua, girasol, cana)])

# También índice 2014-2016=100 para series largas
pp_key_idx <- pp_long[item %in% unlist(commodities) & element_short == "pp_idx"]
pp_key_idx[, commodity := names(commodities)[match(item, unlist(commodities))]]
pp_key_idx <- pp_key_idx[!is.na(commodity)]
pp_wide_idx <- dcast(pp_key_idx[, .(year, commodity, price)],
                     year ~ commodity,
                     value.var = "price")
setnames(pp_wide_idx, setdiff(names(pp_wide_idx), "year"),
         paste0(setdiff(names(pp_wide_idx), "year"), "_idx"))

# ── 4. LAC comparadores ───────────────────────────────────────────────────────
cat("\n=== 4. LAC — Precios productor USD/ton (soya, maíz, trigo) ===\n")
LAC_CODES <- c(19, 9, 21, 40, 44, 58, 138, 169, 170)  # BOL, ARG, BRA, CHL, COL, ECU, MEX, PRY, PER

lac_pp <- pp_raw[`Area Code` %in% LAC_CODES & Months == "Annual value"]
lac_long <- melt(lac_pp,
                 id.vars = c("Area Code","Area","Item","Element"),
                 measure.vars = yr_cols,
                 variable.name = "yr_lbl", value.name = "price")
lac_long[, year  := as.integer(sub("^Y", "", yr_lbl))]
lac_long[, price := suppressWarnings(as.numeric(price))]
lac_long <- lac_long[!is.na(price) & Element == "Producer Price (USD/tonne)"]
lac_long <- lac_long[Item %in% c("Soya beans","Maize (corn)","Wheat","Potatoes","Quinoa")]

cat("LAC comparadores — precio soya (mediana) vs Bolivia:\n")
comp_lac <- lac_long[Item == "Soya beans" & year >= 2000,
                     .(avg_price = round(mean(price, na.rm=TRUE), 0)),
                     by = .(Area, year)]
comp_wide <- dcast(comp_lac[Area %in% c("Bolivia (Plurinational State of)","Argentina","Brazil","Paraguay")],
                   year ~ Area, value.var = "avg_price")
print(comp_wide[year %in% c(2000,2005,2010,2015,2020,2024)])

saveRDS(lac_long, file.path(proc, "faostat_pp_lac.rds"))
fwrite(lac_long,  file.path(proc, "faostat_pp_lac.csv"))
cat("✓ faostat_pp_lac.rds\n")

# ── 5. WB Pink Sheet — Precios mundiales de referencia ───────────────────────
cat("\n=== 5. WB Pink Sheet — precios mundiales referencia ===\n")
pink_xlsx <- file.path(raw_wb, "wb_pink_sheet_annual.xlsx")
pink_url  <- paste0("https://thedocs.worldbank.org/en/doc/",
                    "18675f1d1639c7a34d463f59263ba0a2-0050012025/related/",
                    "CMO-Historical-Data-Annual.xlsx")

if (!file.exists(pink_xlsx)) {
  cat("Descargando WB Pink Sheet...\n")
  download.file(pink_url, pink_xlsx, mode = "wb", quiet = FALSE)
  cat(sprintf("  Descargado: %.0f KB\n", file.size(pink_xlsx)/1024))
} else {
  cat(sprintf("Usando caché: %s\n", basename(pink_xlsx)))
}

pink_raw <- as.data.table(
  read_excel(pink_xlsx, sheet = "Annual Prices (Nominal)", skip = 4))

# Row 1 = unidades; col 1 = year (numeric or blank)
setnames(pink_raw, 1, "year")
units_row <- pink_raw[1]  # save units
pink <- pink_raw[!is.na(suppressWarnings(as.numeric(year)))]
pink[, year := as.integer(year)]
cat(sprintf("Pink Sheet: %d años (%d-%d) × %d commodities\n",
            nrow(pink), min(pink$year), max(pink$year), ncol(pink)-1))

# Convertir a numérico
num_cols <- setdiff(names(pink), "year")
pink[, (num_cols) := lapply(.SD, function(x) suppressWarnings(as.numeric(x))),
     .SDcols = num_cols]

# Mapeo Pink Sheet → nombre corto
# All prices en USD/mt excepto energía
pink_map <- list(
  ref_soya   = "Soybeans",          # USD/mt
  ref_maiz   = "Maize",             # USD/mt
  ref_sorgo  = "Sorghum",           # USD/mt
  ref_arroz  = "Rice, Thai 5%",     # USD/mt (Free on Board Bangkok)
  ref_trigo  = "Wheat, US HRW",     # USD/mt (Hard Red Winter)
  ref_cebada = "Barley",            # USD/mt
  ref_cana   = "Sugar, world",      # USD/mt (ISA contract #11)
  ref_cafe   = "Coffee, Arabica",   # USD/kg → convertir a ×1000 = USD/mt
  ref_carne  = "Beef",              # USD/kg carcass weight → ×1000 = USD/mt
  ref_aceite_palm = "Palm oil",     # USD/mt (proxy aceite girasol)
  ref_girasol = "Soybeans"          # proxy: sin precio ref girasol en Pink Sheet
)

pink_sel <- pink[, c("year", intersect(unlist(pink_map), names(pink))), with = FALSE]
# Rename
for (nm in names(pink_map)) {
  col <- pink_map[[nm]]
  if (col %in% names(pink_sel) && col != nm) {
    # Avoid duplicate if multiple names map to same col
    if (!nm %in% names(pink_sel)) setnames(pink_sel, col, nm)
    else pink_sel[, (nm) := pink_sel[[col]]]
  }
}
# Handle remaining: rename the actual columns that exist
pink_final <- pink[, .(
  year,
  ref_soya    = Soybeans,
  ref_maiz    = Maize,
  ref_sorgo   = Sorghum,
  ref_arroz   = `Rice, Thai 5%`,
  ref_trigo   = `Wheat, US HRW`,
  ref_cebada  = Barley,
  ref_cana_sugar_world = `Sugar, world`,   # USD/kg raw sugar → needs ×1000/8
  ref_cafe_arabica_kg  = `Coffee, Arabica`, # USD/kg → needs ×1000
  ref_beef_kg          = Beef               # USD/kg → needs ×1000
)]
# All per-kg prices: multiply ×1000 to get USD/mt
pink_final[, ref_cafe_usd_mt := ref_cafe_arabica_kg * 1000]
pink_final[, ref_beef_usd_mt := ref_beef_kg         * 1000]
# Sugar cane: sugar world = USD/kg raw sugar; 1 mt raw sugar ≈ 8 mt cane
pink_final[, ref_cana_usd_mt := ref_cana_sugar_world * 1000 / 8]

cat("\n=== WB Pink Sheet — precios referencia clave (USD/mt) ===\n")
print(pink_final[year %in% c(1991, 1995, 2000, 2005, 2010, 2015, 2020, 2024),
                 .(year, ref_soya, ref_maiz, ref_trigo, ref_arroz, ref_cana_usd_mt)])

saveRDS(pink_final, file.path(proc, "wb_pink_sheet_agro.rds"))
fwrite(pink_final,  file.path(proc, "wb_pink_sheet_agro.csv"))
cat("✓ wb_pink_sheet_agro.rds\n")

# ── 6. NRP — Nominal Rate of Protection (1991-2023) ──────────────────────────
cat("\n=== 6. NRP por commodity — Bolivia 1991-2023 ===\n")

# Bolivia domestic prices (USD/tonne)
dom <- pp_wide_usd[year >= 1991 & year <= 2025]

# Merge domestic + reference prices
nrp_data <- merge(dom, pink_final[, .(year, ref_soya, ref_maiz, ref_trigo,
                                       ref_arroz, ref_cana_usd_mt, ref_sorgo,
                                       ref_cebada)],
                  by = "year", all.x = TRUE)

# NRP = (PP_dom - PP_ref) / PP_ref × 100 (%)
nrp_data[, nrp_soya   := (soya   - ref_soya)   / ref_soya   * 100]
nrp_data[, nrp_maiz   := (maiz   - ref_maiz)   / ref_maiz   * 100]
nrp_data[, nrp_trigo  := (trigo  - ref_trigo)  / ref_trigo  * 100]
nrp_data[, nrp_arroz  := (arroz  - ref_arroz)  / ref_arroz  * 100]
nrp_data[, nrp_sorgo  := (sorgo  - ref_sorgo)  / ref_sorgo  * 100]
nrp_data[, nrp_cana   := (cana   - ref_cana_usd_mt) / ref_cana_usd_mt * 100]
nrp_data[, nrp_cebada := (cebada - ref_cebada) / ref_cebada * 100]

# Promedio NRP: solo cultivos con precios de referencia directos (excl. sorgo/cebada por baja cobertura)
nrp_cols     <- grep("^nrp_", names(nrp_data), value = TRUE)
nrp_cols_key <- c("nrp_soya", "nrp_maiz", "nrp_trigo", "nrp_arroz", "nrp_cana")
nrp_data[, avg_nrp            := rowMeans(.SD, na.rm = TRUE), .SDcols = nrp_cols_key]
nrp_data[, n_commodities_nrp  := rowSums(!is.na(.SD)),        .SDcols = nrp_cols_key]

cat("=== NRP Bolivia (%) — muestra decadal ===\n")
print(nrp_data[year %in% c(1991,1995,2000,2005,2010,2015,2020,2023) & !is.na(avg_nrp),
               .(year, nrp_soya=round(nrp_soya,1), nrp_maiz=round(nrp_maiz,1),
                 nrp_trigo=round(nrp_trigo,1), nrp_arroz=round(nrp_arroz,1),
                 avg_nrp=round(avg_nrp,1), n_commodities_nrp)])

cat("\n--- Promedios por período ---\n")
cat("1991-2005 (pre-IDB AgriMonitor):\n")
pre <- nrp_data[year <= 2005, lapply(.SD, mean, na.rm=TRUE), .SDcols=nrp_cols]
print(round(pre, 1))
cat("2006-2023 (solapamiento con IDB AgriMonitor):\n")
post <- nrp_data[year >= 2006 & year <= 2023, lapply(.SD, mean, na.rm=TRUE), .SDcols=nrp_cols]
print(round(post, 1))

saveRDS(nrp_data, file.path(proc, "pse_nrp_extended.rds"))
fwrite(nrp_data,  file.path(proc, "pse_nrp_extended.csv"))
cat("✓ pse_nrp_extended.rds\n")

# ── 7. Integrar al panel v9 → v10 ────────────────────────────────────────────
cat("\nIntegrando precios al panel v9...\n")
panel <- readRDS(file.path(proc, "spending_panel_v9.rds"))
setDT(panel)

# Variables a integrar: PP domésticos + NRP promedio anual
price_vars <- nrp_data[, .(
  year,
  pp_soya_usd    = soya,
  pp_maiz_usd    = maiz,
  pp_trigo_usd   = trigo,
  pp_arroz_usd   = arroz,
  pp_papa_usd    = papa,
  pp_quinua_usd  = quinua,
  nrp_soya, nrp_maiz, nrp_trigo, nrp_arroz,
  avg_nrp,
  n_commodities_nrp
)]

panel_v10 <- merge(panel, price_vars, by = "year", all.x = TRUE)
setorder(panel_v10, year)

cat(sprintf("  pp_soya_usd: %d/%d años con dato\n",
            sum(!is.na(panel_v10$pp_soya_usd)), nrow(panel_v10)))
cat(sprintf("  nrp_soya: %d/%d años con dato\n",
            sum(!is.na(panel_v10$nrp_soya)), nrow(panel_v10)))
cat(sprintf("  avg_nrp: %d/%d años con dato\n",
            sum(!is.na(panel_v10$avg_nrp)), nrow(panel_v10)))

cat("\n=== NRP completo vs IDB AgriMonitor — solapamiento ===\n")
if ("pse_pct" %in% names(panel_v10)) {
  comp <- panel_v10[!is.na(avg_nrp) & !is.na(pse_pct),
                    .(year, avg_nrp = round(avg_nrp, 1),
                      idb_pse_pct = round(pse_pct, 1))]
  print(comp)
}

saveRDS(panel_v10, file.path(proc, "spending_panel_v10.rds"))
fwrite(panel_v10,  file.path(proc, "spending_panel_v10.csv"))
cat(sprintf("\n✓ spending_panel_v10.rds (%d años × %d vars)\n",
            nrow(panel_v10), ncol(panel_v10)))

cat("\n✓ FAOSTAT PP + WB Pink Sheet procesados completamente\n")
cat("  NRP pre-2006: cobertura 1991-2005 para soya/maiz/trigo/arroz\n")
cat("  Nota: NRP ≠ PSE OCDE (no incluye transferencias presupuestales)\n")
cat("  Para PSE completo pre-2006: integrar BOOST + VIPFE como GSSE proxy\n")
