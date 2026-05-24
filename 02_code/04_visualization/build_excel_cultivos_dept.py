"""Build Excel: yield, production and area sown by crop × year × department.

Combines the two INE panels available in 01_data/processed:
  - ine_agro_stats_long.csv  (1984-2020, año agrícola, no campaign split)
  - ine_campanas_long.csv    (2012-2024, by campaña verano/invierno)

Output: 05_outputs/cultivos_bolivia_dept_panel.xlsx
  Sheet "Datos"   : panel wide (dept × year × campaña × cultivo)
  Sheet "Fuentes" : sources, coverage, definitions
"""

from __future__ import annotations
import os
from datetime import datetime

import pandas as pd

ROOT = "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
PROC = os.path.join(ROOT, "01_data/processed")
OUT  = os.path.join(ROOT, "05_outputs")
os.makedirs(OUT, exist_ok=True)

DEPT_ORDER = ["Bolivia", "Chuquisaca", "La Paz", "Cochabamba", "Oruro",
              "Potosí", "Tarija", "Santa Cruz", "Beni", "Pando"]

INDICATOR_RENAME = {
    "produccion":   "Producción (t)",
    "superficie":   "Superficie (ha)",
    "rendimiento":  "Rendimiento (kg/ha)",
}

# -------------------------------------------------------------------
# 1. Año agrícola anual 1984-2020 (sin campaña)
# -------------------------------------------------------------------
agro = pd.read_csv(os.path.join(PROC, "ine_agro_stats_long.csv"))
agro.columns = [c.strip() for c in agro.columns]
agro["dept"] = agro["dept"].replace({"BOLIVIA": "Bolivia"})
agro["campana"] = "Año agrícola (anual)"
agro_w = (agro
    .pivot_table(index=["dept", "year", "campana", "cultivo"],
                 columns="indicator", values="value",
                 aggfunc="sum")
    .reset_index()
    .rename(columns=INDICATOR_RENAME))
agro_w["Tipo"] = "cultivo"
agro_w["Fuente"] = "INE Bolivia — Año Agrícola por Departamento (1984-2024)"

# -------------------------------------------------------------------
# 2. Campaña verano/invierno 2012-2024
# -------------------------------------------------------------------
camp = pd.read_csv(os.path.join(PROC, "ine_campanas_long.csv"))
camp.columns = [c.strip() for c in camp.columns]
camp = camp.rename(columns={"campaña": "campana", "indicador": "indicator"})
camp["dept"] = camp["dept"].replace({"BOLIVIA": "Bolivia"})
camp["campana"] = "Campaña " + camp["campana"].astype(str)
camp_w = (camp
    .pivot_table(index=["dept", "year", "campana", "cultivo", "tipo"],
                 columns="indicator", values="value",
                 aggfunc="sum")
    .reset_index()
    .rename(columns=INDICATOR_RENAME)
    .rename(columns={"tipo": "Tipo"}))
camp_w["Fuente"] = ("INE Bolivia — Producción/Superficie/Rendimiento "
                    "por Cultivo y Campaña por Departamento (2012-2024)")

# -------------------------------------------------------------------
# 3. Combine
# -------------------------------------------------------------------
keep = ["dept", "year", "campana", "cultivo", "Tipo",
        "Superficie (ha)", "Producción (t)", "Rendimiento (kg/ha)", "Fuente"]
for col in keep:
    if col not in agro_w.columns: agro_w[col] = pd.NA
    if col not in camp_w.columns: camp_w[col] = pd.NA

panel = pd.concat([agro_w[keep], camp_w[keep]], ignore_index=True)

# Drop rows where all three indicators are NA
ind_cols = ["Superficie (ha)", "Producción (t)", "Rendimiento (kg/ha)"]
panel = panel.dropna(subset=ind_cols, how="all")

# Sort
panel["dept"] = pd.Categorical(panel["dept"],
                               categories=DEPT_ORDER, ordered=True)
panel = panel.sort_values(["dept", "year", "campana", "cultivo"]).reset_index(drop=True)
panel["dept"] = panel["dept"].astype(str)

# Round
for c in ind_cols:
    panel[c] = pd.to_numeric(panel[c], errors="coerce").round(1)

panel = panel.rename(columns={
    "dept": "Departamento", "year": "Año",
    "campana": "Campaña", "cultivo": "Cultivo"
})
panel = panel[["Departamento", "Año", "Campaña", "Cultivo", "Tipo",
               "Superficie (ha)", "Producción (t)", "Rendimiento (kg/ha)",
               "Fuente"]]

# -------------------------------------------------------------------
# 4. Sources sheet content
# -------------------------------------------------------------------
fuentes = pd.DataFrame({
    "Fuente": [
        "INE Bolivia — Año Agrícola por Departamento",
        "INE Bolivia — Cultivo por Campaña Verano por Departamento",
        "INE Bolivia — Cultivo por Campaña Invierno por Departamento",
    ],
    "Indicadores": [
        "Producción (t), Superficie (ha), Rendimiento (kg/ha)",
        "Producción (t), Superficie (ha), Rendimiento (kg/ha)",
        "Producción (t), Superficie (ha), Rendimiento (kg/ha)",
    ],
    "Cobertura temporal": [
        "1984-2024 (año agrícola, ej. 1983/1984 → año de cierre 1984)",
        "2013-2024",
        "2012-2024",
    ],
    "Cobertura geográfica": [
        "Nacional + 9 departamentos",
        "Nacional + 9 departamentos",
        "Nacional + 9 departamentos",
    ],
    "URL": [
        "https://www.ine.gob.bo/index.php/estadisticas-economicas/agropecuaria/agricultura-cuadros-estadisticos/",
        "https://www.ine.gob.bo/index.php/estadisticas-economicas/agropecuaria/agricultura-cuadros-estadisticos/",
        "https://www.ine.gob.bo/index.php/estadisticas-economicas/agropecuaria/agricultura-cuadros-estadisticos/",
    ],
    "Notas": [
        "Año agrícola registrado como año de cierre (campaña 1983/1984 → 2024). Se exporta el detalle por cultivo individual.",
        "Reporta cultivos sembrados en campaña verano (siembra oct-dic, cosecha mar-may del año siguiente).",
        "Reporta cultivos sembrados en campaña invierno (siembra abr-jun, cosecha sept-nov).",
    ],
})

por_campana = (panel
    .groupby("Campaña", as_index=False)
    .agg(N_filas=("Cultivo", "size"),
         Año_min=("Año", "min"),
         Año_max=("Año", "max"),
         Superficie_no_NA=("Superficie (ha)", lambda s: s.notna().sum()),
         Producción_no_NA=("Producción (t)", lambda s: s.notna().sum()),
         Rendimiento_no_NA=("Rendimiento (kg/ha)", lambda s: s.notna().sum())))
por_campana["Años"] = (por_campana["Año_min"].astype(str) + "-"
                      + por_campana["Año_max"].astype(str))
por_campana = por_campana[["Campaña", "Años", "N_filas",
                           "Superficie_no_NA", "Producción_no_NA",
                           "Rendimiento_no_NA"]]

por_dept = (panel
    .groupby("Departamento", as_index=False)
    .agg(N_filas=("Cultivo", "size"),
         Cultivos_distintos=("Cultivo", "nunique"),
         Año_min=("Año", "min"),
         Año_max=("Año", "max")))
por_dept["Años"] = (por_dept["Año_min"].astype(str) + "-"
                   + por_dept["Año_max"].astype(str))
por_dept = por_dept[["Departamento", "Años", "Cultivos_distintos", "N_filas"]]

defs = pd.DataFrame({
    "Variable": ["Departamento", "Año", "Campaña", "Cultivo", "Tipo",
                 "Superficie (ha)", "Producción (t)",
                 "Rendimiento (kg/ha)", "Fuente"],
    "Definición": [
        "Departamento de Bolivia o agregado nacional ('Bolivia').",
        "Año calendario de cierre del año agrícola o de la campaña.",
        "Año agrícola anual (sin separar campañas) o campaña específica (verano/invierno).",
        "Cultivo según nomenclatura INE.",
        "Identifica si el registro es un cultivo individual o un grupo agregado (solo en data por campaña).",
        "Superficie cultivada en hectáreas.",
        "Producción en toneladas métricas.",
        "Rendimiento en kilogramos por hectárea (= producción / superficie).",
        "Archivo INE del que proviene la observación.",
    ],
})

# -------------------------------------------------------------------
# 5. Write Excel
# -------------------------------------------------------------------
xlsx_path = os.path.join(OUT, "cultivos_bolivia_dept_panel.xlsx")

with pd.ExcelWriter(xlsx_path, engine="xlsxwriter") as writer:
    panel.to_excel(writer, sheet_name="Datos", index=False)
    wb = writer.book
    ws = writer.sheets["Datos"]

    header_fmt = wb.add_format({
        "bold": True, "bg_color": "#1F4E78", "font_color": "white",
        "align": "center", "valign": "vcenter", "border": 1, "text_wrap": True
    })
    num_fmt = wb.add_format({"num_format": "#,##0.0"})
    int_fmt = wb.add_format({"num_format": "0"})
    text_fmt = wb.add_format({"text_wrap": True, "valign": "top"})

    for col_idx, col_name in enumerate(panel.columns):
        ws.write(0, col_idx, col_name, header_fmt)

    widths = [14, 8, 24, 38, 12, 16, 16, 19, 70]
    for i, w in enumerate(widths):
        if i in (5, 6, 7):
            ws.set_column(i, i, w, num_fmt)
        elif i == 1:
            ws.set_column(i, i, w, int_fmt)
        elif i == 8:
            ws.set_column(i, i, w, text_fmt)
        else:
            ws.set_column(i, i, w)
    ws.freeze_panes(1, 0)
    ws.autofilter(0, 0, len(panel), len(panel.columns) - 1)

    # ---- Fuentes sheet ----
    ws2 = wb.add_worksheet("Fuentes")
    writer.sheets["Fuentes"] = ws2
    title_fmt = wb.add_format({"bold": True, "font_size": 13,
                               "font_color": "#1F4E78"})
    sub_fmt = wb.add_format({"italic": True, "font_color": "#555555"})
    h_fmt = wb.add_format({
        "bold": True, "bg_color": "#1F4E78", "font_color": "white",
        "align": "left", "valign": "vcenter", "border": 1, "text_wrap": True
    })
    cell_fmt = wb.add_format({"text_wrap": True, "valign": "top"})

    row = 0
    ws2.write(row, 0, "Cultivos Bolivia — Panel departamental", title_fmt); row += 1
    ws2.write(row, 0, f"Generado: {datetime.now():%Y-%m-%d %H:%M}", sub_fmt); row += 2

    def write_block(title: str, df: pd.DataFrame, start_row: int) -> int:
        ws2.write(start_row, 0, title, title_fmt)
        start_row += 1
        for c, col in enumerate(df.columns):
            ws2.write(start_row, c, col, h_fmt)
        for r, rec in enumerate(df.itertuples(index=False), start=1):
            for c, val in enumerate(rec):
                if pd.isna(val):
                    ws2.write(start_row + r, c, "", cell_fmt)
                else:
                    ws2.write(start_row + r, c, val, cell_fmt)
        return start_row + 1 + len(df) + 2  # blank row

    row = write_block("Fuentes primarias", fuentes, row)
    row = write_block("Resumen por campaña", por_campana, row)
    row = write_block("Resumen por departamento", por_dept, row)
    row = write_block("Definiciones y unidades", defs, row)

    ws2.set_column(0, 0, 40)
    ws2.set_column(1, 1, 55)
    ws2.set_column(2, 2, 22)
    ws2.set_column(3, 3, 22)
    ws2.set_column(4, 4, 50)
    ws2.set_column(5, 5, 70)

print("=== Resumen ===")
print(f"Filas totales         : {len(panel):,}")
print(f"Departamentos         : {panel['Departamento'].nunique()}")
print(f"Cultivos distintos    : {panel['Cultivo'].nunique()}")
print(f"Rango años            : {panel['Año'].min()}-{panel['Año'].max()}")
print(f"Superficie no-NA      : {panel['Superficie (ha)'].notna().sum():,}")
print(f"Producción no-NA      : {panel['Producción (t)'].notna().sum():,}")
print(f"Rendimiento no-NA     : {panel['Rendimiento (kg/ha)'].notna().sum():,}")
print(f"\nArchivo: {xlsx_path}")
