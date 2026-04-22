library(readxl)
library(data.table)
library(tidyverse)

here_root  <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
boost_dir  <- file.path(here_root, "01_data/raw/boost")
proc_dir   <- file.path(here_root, "01_data/processed")
dir.create(proc_dir, recursive = TRUE, showWarnings = FALSE)

# ── 1. Leer APER ──────────────────────────────────────────────────────────────
cat("Leyendo APER (puede tardar ~30 seg)...\n")
aper_raw <- suppressMessages(
  read_excel(file.path(boost_dir, "WB_Bolivia_APER.xlsx"),
             sheet = "base de datos", skip = 4, col_names = TRUE)
)
# Limpiar nombres de columnas
setDT(aper_raw)
setnames(aper_raw, make.names(names(aper_raw), unique = TRUE))

# Quitar filas de notas al pie (Gestión no numérico)
aper_raw <- aper_raw[!is.na(Gestión) & is.numeric(Gestión)]
cat("Filas válidas:", nrow(aper_raw), "\n")

# ── 2. Renombrar a nombres legibles ───────────────────────────────────────────
setnames(aper_raw,
  old = c("Gestión", "Subsector", "Nivel", "Codigo.cobertura", "Nombre.Cobertura",
          "Código..Entidad", "Nombre.de.la..Entidad",
          "Pro...grama", "Sub...pro...grama", "Pro...yecto", "Acti...vidad",
          "Nombre.de.la.Apertura.Programática",
          "Codigo.funcional..UDAPE", "Nombre.de.la.función",
          "Tipo.de.gasto.público", "Nombre.del.tipo.de.gasto.público",
          "Codigo.UDAPE.FAM", "Nombre.codigo.UDAPE.FAM",
          "Sector", "Nombre.del.sector", "Area", "Nombre.del.área",
          "Presupuesto..aprobado", "Presupuesto..vigente",
          "Presupuesto..según.la..entidad", "Presupuesto..ejecutado",
          "Total.fuente..TGN", "Fuente.TGN..coparticipación..tributaria",
          "Fuente.TGN..IDH", "Fuente.TGN..otro",
          "Fuente..recursos..específicos", "Fuente..crédito..externo",
          "Fuente..donación..externa", "Fuente..crédito..interno", "Fuente..Otros",
          "Gasto..corriente", "Gasto.de..capital"),
  new = c("year", "subsector", "nivel", "dept_code", "dept_name",
          "entity_code", "entity_name",
          "program", "subprogram", "project", "activity",
          "program_name",
          "udape_func_code", "udape_func_name",
          "expenditure_type_code", "expenditure_type_name",
          "udape_fam_code", "udape_fam_name",
          "sector_code", "sector_name", "area_code", "area_name",
          "budget_approved", "budget_current",
          "budget_entity", "budget_executed",
          "src_tgn_total", "src_tgn_copart",
          "src_tgn_idh", "src_tgn_other",
          "src_specific", "src_ext_credit",
          "src_donation", "src_int_credit", "src_other",
          "expenditure_current", "expenditure_capital")
)

# ── 3. Mapa de departamentos ──────────────────────────────────────────────────
dept_map <- c(
  "1" = "Chuquisaca", "2" = "La Paz",   "3" = "Cochabamba",
  "4" = "Oruro",      "5" = "Potosí",   "6" = "Tarija",
  "7" = "Santa Cruz", "8" = "Beni",     "9" = "Pando",
  "N" = "Nacional",   "D" = "Rest_Dept", "M" = "Rest_Muni"
)
aper_raw[, dept_name_clean := dept_map[dept_code]]

# ── 4. Filtrar gasto agropecuario ─────────────────────────────────────────────
# Sector agropecuario en UDAPE: sector_code == 1 o udape_func_code relacionado
cat("\nDistribución sector_code:\n")
print(aper_raw[, .N, by = sector_code][order(-N)][1:10])

cat("\nCódigos UDAPE-FAM (agro, primeros):\n")
print(aper_raw[, .N, by = .(udape_fam_code, udape_fam_name)][order(-N)][1:15])

# Filtro: sector agropecuario (sector 1 = Agropecuario en clasificación UDAPE)
aper_agro <- aper_raw[sector_code == 1]
cat("\nFilas agropecuarias:", nrow(aper_agro), "\n")

# ── 5. Clasificar categorías de gasto ─────────────────────────────────────────
aper_agro[, spending_category := fcase(
  udape_fam_code %in% c("101", "102"),       "investigacion_extension",
  udape_fam_code %in% c("108"),              "sanidad_inocuidad",
  udape_fam_code %in% c("103", "107"),       "riego_agua",
  udape_fam_code %in% c("104", "105", "106"), "fomento_produccion",
  default = "administracion_general"
)]

# ── 6. Panel nacional anual ────────────────────────────────────────────────────
aper_national <- aper_agro[nivel == "Nacional" | dept_code == "N",
  .(budget_executed = sum(budget_executed, na.rm = TRUE),
    budget_approved = sum(budget_approved, na.rm = TRUE),
    expenditure_current = sum(expenditure_current, na.rm = TRUE),
    expenditure_capital  = sum(expenditure_capital,  na.rm = TRUE),
    src_tgn_total = sum(src_tgn_total, na.rm = TRUE),
    src_tgn_idh   = sum(src_tgn_idh,   na.rm = TRUE),
    src_ext_credit = sum(src_ext_credit, na.rm = TRUE),
    n_lines = .N),
  by = .(year, spending_category)
]

# ── 7. Panel subnacional anual ─────────────────────────────────────────────────
aper_dept <- aper_agro[dept_code %in% as.character(1:9),
  .(budget_executed = sum(budget_executed, na.rm = TRUE),
    budget_approved = sum(budget_approved, na.rm = TRUE),
    expenditure_current = sum(expenditure_current, na.rm = TRUE),
    expenditure_capital  = sum(expenditure_capital,  na.rm = TRUE)),
  by = .(year, dept_code, dept_name_clean, spending_category)
]

# ── 8. Total agropecuario anual (nacional) ────────────────────────────────────
aper_total_nat <- aper_agro[nivel == "Nacional" | dept_code == "N",
  .(agro_spend_bob = sum(budget_executed, na.rm = TRUE)),
  by = year
][order(year)]

cat("\n=== Gasto Agropecuario Ejecutado Nacional (1996-2008) ===\n")
print(aper_total_nat)

# ── 9. Guardar ────────────────────────────────────────────────────────────────
saveRDS(aper_raw,      file.path(proc_dir, "aper_full.rds"))
saveRDS(aper_agro,     file.path(proc_dir, "aper_agro.rds"))
saveRDS(aper_national, file.path(proc_dir, "aper_national_panel.rds"))
saveRDS(aper_dept,     file.path(proc_dir, "aper_dept_panel.rds"))
readr::write_csv(aper_total_nat, file.path(proc_dir, "aper_total_national.csv"))

cat("\n=== Archivos guardados en", proc_dir, "===\n")
cat("  aper_full.rds          —", nrow(aper_raw), "filas (todas)\n")
cat("  aper_agro.rds          —", nrow(aper_agro), "filas (agropecuario)\n")
cat("  aper_national_panel.rds — panel nacional por categoría\n")
cat("  aper_dept_panel.rds     — panel departamental por categoría\n")
cat("  aper_total_national.csv — total ejecutado agro por año\n")
