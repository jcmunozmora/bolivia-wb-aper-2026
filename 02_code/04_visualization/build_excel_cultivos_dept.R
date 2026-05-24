# Construye Excel con producción / superficie / rendimiento por
# cultivo × año × departamento, combinando las dos fuentes INE
# disponibles en 01_data/processed:
#   - ine_agro_stats_long.rds  (1984-2020, año agrícola, sin campaña)
#   - ine_campanas_long.rds    (2012-2024, con campaña verano/invierno)
#
# Output:
#   05_outputs/cultivos_bolivia_dept_panel.xlsx
#     Hoja "Datos"   : panel wide (dept × año × cultivo × campaña)
#     Hoja "Fuentes" : documentación de cobertura, unidades y enlaces

suppressPackageStartupMessages({
  library(data.table)
  library(openxlsx)
})

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc <- file.path(root, "01_data/processed")
out  <- file.path(root, "05_outputs")
dir.create(out, showWarnings = FALSE, recursive = TRUE)

# -------------------------------------------------------------------
# 1. Año agrícola anual 1984-2020 (sin campaña)
# -------------------------------------------------------------------
agro <- as.data.table(readRDS(file.path(proc, "ine_agro_stats_long.rds")))
setnames(agro, c("dept","cultivo","year","indicator","value"))
agro[, dept := ifelse(toupper(dept) == "BOLIVIA", "Bolivia", dept)]
agro[, campana := "Año agrícola (anual)"]
agro_w <- dcast(
  agro,
  dept + year + campana + cultivo ~ indicator,
  value.var = "value",
  fun.aggregate = function(x) if (all(is.na(x))) NA_real_ else sum(x, na.rm = TRUE)
)
setnames(agro_w,
  old = c("produccion","superficie","rendimiento"),
  new = c("produccion_t","superficie_ha","rendimiento_kg_ha"),
  skip_absent = TRUE
)
agro_w[, fuente := "INE Bolivia — Año Agrícola por Departamento (1984-2024)"]
agro_w[, tipo := "cultivo"]

# -------------------------------------------------------------------
# 2. Campaña verano/invierno 2012-2024
# -------------------------------------------------------------------
camp <- as.data.table(readRDS(file.path(proc, "ine_campanas_long.rds")))
# columnas esperadas: dept, campaña, indicador, cultivo, tipo, year, value
setnames(camp, "campaña", "campana")
setnames(camp, "indicador", "indicator")
camp[, dept := ifelse(toupper(dept) == "BOLIVIA", "Bolivia", dept)]
camp[, campana := paste0("Campaña ", campana)]
camp_w <- dcast(
  camp,
  dept + year + campana + cultivo + tipo ~ indicator,
  value.var = "value",
  fun.aggregate = function(x) if (all(is.na(x))) NA_real_ else sum(x, na.rm = TRUE)
)
setnames(camp_w,
  old = c("produccion","superficie","rendimiento"),
  new = c("produccion_t","superficie_ha","rendimiento_kg_ha"),
  skip_absent = TRUE
)
camp_w[, fuente := "INE Bolivia — Producción/Superficie/Rendimiento por Cultivo y Campaña por Departamento (2012-2024)"]

# -------------------------------------------------------------------
# 3. Combinar
# -------------------------------------------------------------------
all_cols <- c("dept","year","campana","cultivo","tipo",
              "superficie_ha","produccion_t","rendimiento_kg_ha","fuente")
for (cc in setdiff(all_cols, names(agro_w))) agro_w[, (cc) := NA]
for (cc in setdiff(all_cols, names(camp_w))) camp_w[, (cc) := NA]
panel <- rbindlist(list(agro_w[, ..all_cols], camp_w[, ..all_cols]),
                   use.names = TRUE)

# Limpieza: solo registros con al menos un indicador no nulo
panel <- panel[
  !(is.na(superficie_ha) & is.na(produccion_t) & is.na(rendimiento_kg_ha))
]

# Orden departamentos
dept_order <- c("Bolivia","Chuquisaca","La Paz","Cochabamba","Oruro","Potosí",
                "Tarija","Santa Cruz","Beni","Pando")
panel[, dept := factor(dept, levels = dept_order)]
setorder(panel, dept, year, campana, cultivo)
panel[, dept := as.character(dept)]

# Renombrar columnas a español, finales para Excel
setnames(panel,
  old = c("dept","year","campana","cultivo","tipo",
          "superficie_ha","produccion_t","rendimiento_kg_ha","fuente"),
  new = c("Departamento","Año","Campaña","Cultivo","Tipo",
          "Superficie (ha)","Producción (t)","Rendimiento (kg/ha)","Fuente")
)

# Redondeo
panel[, `Superficie (ha)`     := round(`Superficie (ha)`, 1)]
panel[, `Producción (t)`      := round(`Producción (t)`, 1)]
panel[, `Rendimiento (kg/ha)` := round(`Rendimiento (kg/ha)`, 1)]

# -------------------------------------------------------------------
# 4. Hoja Fuentes
# -------------------------------------------------------------------
fuentes <- data.table(
  Fuente = c(
    "INE Bolivia — Año Agrícola por Departamento",
    "INE Bolivia — Cultivo por Campaña Verano por Departamento",
    "INE Bolivia — Cultivo por Campaña Invierno por Departamento"
  ),
  Indicadores = c(
    "Producción (t), Superficie (ha), Rendimiento (kg/ha)",
    "Producción (t), Superficie (ha), Rendimiento (kg/ha)",
    "Producción (t), Superficie (ha), Rendimiento (kg/ha)"
  ),
  Cobertura_temporal = c(
    "1984-2024 (año agrícola, ej. 1983/1984)",
    "2013-2024",
    "2012-2024"
  ),
  Cobertura_geografica = c(
    "Nacional + 9 departamentos",
    "Nacional + 9 departamentos",
    "Nacional + 9 departamentos"
  ),
  URL = c(
    "https://www.ine.gob.bo/index.php/estadisticas-economicas/agropecuaria/agricultura-cuadros-estadisticos/",
    "https://www.ine.gob.bo/index.php/estadisticas-economicas/agropecuaria/agricultura-cuadros-estadisticos/",
    "https://www.ine.gob.bo/index.php/estadisticas-economicas/agropecuaria/agricultura-cuadros-estadisticos/"
  ),
  Notas = c(
    "Año agrícola registrado como año de cierre (campaña 1983/1984 → 2024). Incluye cultivos individuales y agregados por grupo (cereales, oleaginosas, etc.) — aquí se exporta el detalle.",
    "Reporta los cultivos sembrados en campaña verano (siembra oct-dic, cosecha mar-may del año siguiente).",
    "Reporta los cultivos sembrados en campaña invierno (siembra abr-jun, cosecha sept-nov)."
  )
)

cobertura <- panel[, .(
  Anios   = paste(min(Año, na.rm = TRUE), max(Año, na.rm = TRUE), sep = "-"),
  Cultivos_distintos = uniqueN(Cultivo),
  Departamentos_distintos = uniqueN(Departamento),
  Filas = .N
), by = .(Fuente)]

ind_resumen <- panel[, .(
  N_filas = .N,
  Anios = paste(min(Año, na.rm = TRUE), max(Año, na.rm = TRUE), sep = "-"),
  Superficie_no_NA  = sum(!is.na(`Superficie (ha)`)),
  Produccion_no_NA  = sum(!is.na(`Producción (t)`)),
  Rendimiento_no_NA = sum(!is.na(`Rendimiento (kg/ha)`))
), by = .(Campaña)]

# -------------------------------------------------------------------
# 5. Escribir Excel
# -------------------------------------------------------------------
wb <- createWorkbook()

addWorksheet(wb, "Datos")
writeData(wb, "Datos", panel, headerStyle = createStyle(
  textDecoration = "bold", fgFill = "#1F4E78", fontColour = "white",
  halign = "center", border = "TopBottomLeftRight"
))
freezePane(wb, "Datos", firstRow = TRUE)
setColWidths(wb, "Datos", cols = 1:9, widths = c(14, 8, 22, 35, 12, 16, 16, 18, 60))

addWorksheet(wb, "Fuentes")
header_style <- createStyle(textDecoration = "bold", fgFill = "#1F4E78",
                            fontColour = "white", halign = "left",
                            border = "TopBottomLeftRight", wrapText = TRUE)
title_style <- createStyle(textDecoration = "bold", fontSize = 13)

writeData(wb, "Fuentes", "Cultivos Bolivia — Panel departamental",
          startCol = 1, startRow = 1)
addStyle(wb, "Fuentes", style = title_style, rows = 1, cols = 1)
writeData(wb, "Fuentes",
          paste0("Generado: ", format(Sys.time(), "%Y-%m-%d %H:%M %Z")),
          startCol = 1, startRow = 2)

writeData(wb, "Fuentes", "Fuentes primarias",
          startCol = 1, startRow = 4)
addStyle(wb, "Fuentes", style = title_style, rows = 4, cols = 1)
writeData(wb, "Fuentes", fuentes,
          startCol = 1, startRow = 5, headerStyle = header_style)

start_row_b <- 5 + nrow(fuentes) + 3
writeData(wb, "Fuentes", "Resumen por campaña",
          startCol = 1, startRow = start_row_b - 1)
addStyle(wb, "Fuentes", style = title_style,
         rows = start_row_b - 1, cols = 1)
writeData(wb, "Fuentes", ind_resumen,
          startCol = 1, startRow = start_row_b, headerStyle = header_style)

start_row_c <- start_row_b + nrow(ind_resumen) + 3
writeData(wb, "Fuentes", "Resumen por fuente",
          startCol = 1, startRow = start_row_c - 1)
addStyle(wb, "Fuentes", style = title_style,
         rows = start_row_c - 1, cols = 1)
writeData(wb, "Fuentes", cobertura,
          startCol = 1, startRow = start_row_c, headerStyle = header_style)

start_row_d <- start_row_c + nrow(cobertura) + 3
writeData(wb, "Fuentes", "Definiciones e unidades",
          startCol = 1, startRow = start_row_d - 1)
addStyle(wb, "Fuentes", style = title_style,
         rows = start_row_d - 1, cols = 1)
defs <- data.table(
  Variable = c("Departamento","Año","Campaña","Cultivo","Tipo",
               "Superficie (ha)","Producción (t)","Rendimiento (kg/ha)","Fuente"),
  Definicion = c(
    "Departamento de Bolivia o agregado nacional ('Bolivia').",
    "Año calendario de cierre del año agrícola o de la campaña.",
    "Año agrícola anual (sin separar campañas) o campaña específica (verano/invierno).",
    "Cultivo según nomenclatura INE.",
    "Identifica si el registro es un cultivo individual o un grupo agregado (solo en data por campaña).",
    "Superficie cultivada en hectáreas.",
    "Producción en toneladas métricas.",
    "Rendimiento en kilogramos por hectárea (= producción/superficie).",
    "Archivo fuente INE del que proviene la observación."
  )
)
writeData(wb, "Fuentes", defs,
          startCol = 1, startRow = start_row_d, headerStyle = header_style)

setColWidths(wb, "Fuentes", cols = 1:6,
             widths = c(58, 60, 28, 28, 50, 70))

xlsx_path <- file.path(out, "cultivos_bolivia_dept_panel.xlsx")
saveWorkbook(wb, xlsx_path, overwrite = TRUE)

cat("\n=== Resumen ===\n")
cat("Filas totales         :", nrow(panel), "\n")
cat("Departamentos          :", uniqueN(panel$Departamento), "\n")
cat("Cultivos distintos     :", uniqueN(panel$Cultivo), "\n")
cat("Rango de años          :", min(panel$Año, na.rm=TRUE), "-",
    max(panel$Año, na.rm=TRUE), "\n")
cat("Superficie  no-NA      :", sum(!is.na(panel$`Superficie (ha)`)), "\n")
cat("Producción  no-NA      :", sum(!is.na(panel$`Producción (t)`)), "\n")
cat("Rendimiento no-NA      :", sum(!is.na(panel$`Rendimiento (kg/ha)`)), "\n")
cat("\nArchivo:", xlsx_path, "\n")
