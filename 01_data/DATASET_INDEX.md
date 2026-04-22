# Índice de datasets procesados

Directorio: `01_data/processed/`
Formato: `.rds` (R binary) + `.csv` (interchange) donde aplica
Para cargar en R: `readRDS("01_data/processed/NAME.rds")`

---

## 🎯 PANEL MAESTRO (archivo canónico)

### `spending_panel_v3.rds` — Panel nacional 1990-2024 (72 variables)

**Úsese para**: regresiones panel, análisis descriptivo nacional, figuras principales.

```r
library(data.table)
panel <- readRDS("01_data/processed/spending_panel_v3.rds")
setDT(panel)
# 35 años × 72 variables
```

**Grupos de variables**: deflactores, inversión pública VIPFE, PSE OCDE
(IDB Agrimonitor), EMAPA, USDA TFP, WDI macro, APER legado, GHG, derivados (logs/ratios).

**Fuentes integradas**: WDI + VIPFE + IDB + USDA + APER + EMAPA + GHG.

Ver diccionario completo en [Anexo A — Sección 4](../../04_report/appendix/A_data_sources.qmd).

---

## 📊 Datasets por dominio

### Gasto e inversión pública

| Archivo | Período | Granularidad | Obs |
|---------|---------|--------------|----:|
| `inversion_publica_sectorial_wide.rds` | 1990-2024 | 17 sectores × año | 35 |
| `inversion_publica_sectorial_long.rds` | 1990-2024 | Long format | 595 |
| `aper_full.rds` | 1996-2008 | Todas las entidades públicas | 104,275 |
| `aper_agro.rds` | 1996-2008 | Sector agropecuario filtrado | 27,512 |
| `aper_national_panel.rds` | 1996-2008 | Año × categoría UDAPE-FAM | — |
| `aper_dept_panel.rds` | 1996-2008 | 9 depts × año × categoría | — |
| `aper_total_national.csv` | 1996-2008 | Total nacional anual | 13 |
| `informe_fiscal_2024_all_series.rds` | 2000-2024 | 318 entidades, 882 series | 17,831 |
| `informe_fiscal_2024_agro_series.rds` | 2008-2024 | Solo entidades agrop | — |
| `mefp_deuda_destino_wide.rds` | 2005-2022 | 9 depts × 8 destinos | 47 |
| `mefp_deuda_destino_long.rds` | 2005-2022 | Long format | 846 |
| `mefp_stock_rural_annual.csv` | 2005-2022 | Total rural anual | 18 |
| `emapa_series_wide.csv` | 2000-2024 | EMAPA anual | 1 serie |

### PSE (metodología OCDE) — IDB Agrimonitor

| Archivo | Período | Granularidad | Uso |
|---------|---------|--------------|-----|
| `idb_pse_bolivia_aggregate.rds` | 2006-2023 | Nacional × 22 indicadores | Análisis PSE agregado |
| `idb_psct_by_commodity.rds` | 2006-2023 | 16 commodities × año | Política por cultivo |
| `idb_prices_gap_bolivia.rds` | 2006-2023 | Commodity × año | Brecha de precios |
| `idb_ghg_bolivia.rds` | 2019-2023 | Commodity × año | Emisiones agrícolas |
| `idb_agrimonitor_bolivia_full.rds` | 2006-2023 | 11,284 filas | Acceso completo Bolivia |
| `idb_agrimonitor_lac_full.rds` | 1986-2024 | LAC 27 países | Comparación regional |

### Productividad agrícola (USDA ERS)

| Archivo | Período | Granularidad | Obs |
|---------|---------|--------------|----:|
| `usda_tfp_bolivia.rds` | 1961-2023 | Bolivia × 19 indicadores TFP | 63 |
| `usda_tfp_latam.rds` | 1961-2023 | 9 países LAC | — |
| `usda_tfp_lac_ranking.csv` | 2000 vs 2023 | Ranking crecimiento LAC | 9 |

### Outcomes agrícolas

| Archivo | Período | Granularidad |
|---------|---------|--------------|
| `agricultural_outcomes.rds` | 2000-2023 | Nacional × 7 vars (yield, produc, kcal) |
| `gdp_bolivia.rds` | 2000-2023 | Nacional × PIB corriente + agrop |

### Subnacional (departamental)

| Archivo | Período | Granularidad |
|---------|---------|--------------|
| `pib_departamental_agro.rds` | 2017-2021 | 9 depts × año × PIB agrop |
| `pib_departamental_agro.csv` | 2017-2021 | idem (CSV) |

---

## 📦 Datos externos auxiliares

Directorio: `01_data/external/`

| Archivo | Contenido | Uso |
|---------|-----------|-----|
| `cofog_classification.csv` | Crosswalk Bolivia → COFOG 04.2 | Clasificar APER |
| `bolivia_departments.csv` | 9 depts (código, capital, área, región) | Metadata |
| `inflation_deflators.csv` | CPI 2000-2023 (base 2015) | Deflactar BOB |
| `exchange_rates.csv` | BOB/USD 2000-2023 | Convertir monedas |
| `bolivia_adm1_departments.gpkg` | 9 departamentos (geoBoundaries) | Mapas |
| `bolivia_adm2_municipalities.gpkg` | 110 provincias | Mapas detallados |

---

## 🔄 Pipeline de dependencias

```
Raw data                    Processing                  Output
────────                    ──────────                  ──────
WDI_CSV.zip            →    process_wdi.R          →    wdi_bolivia.rds
WB_Bolivia_APER.xlsx   →    08_process_aper.R      →    aper_*.rds
usda_ers_tfp_*.csv     →    09_process_usda_tfp.R  →    usda_tfp_*.rds
Informe_Fiscal_2024.pdf→    14_parse_inv_sect.R    →    inversion_publica_*.rds
                       ↓
                       ↓    (panel build)
                       ↓
boletin_eef_eta_2022   →    12_parse_mefp_boletin.R→    mefp_deuda_*.rds
Agrimonitor_Dataset.csv→    15_process_idb_agri.R  →    idb_*.rds
OWID CSVs              →    02_download_faostat.R  →    agricultural_outcomes.rds

Panel building (secuencial):
  06_build_panel.R           →  spending_panel.rds     (v1: WDI+APER+defl)
  07_integrate_siif_proxies.R→  spending_panel_v2.rds  (v2: +VIPFE+EMAPA+TFP)
  08_integrate_pse.R         →  spending_panel_v3.rds  (v3: +IDB PSE+GHG) ⭐
```

---

## 🔍 Consultas rápidas frecuentes

**Inversión agropecuaria total nacional:**
```r
panel <- readRDS("01_data/processed/spending_panel_v3.rds")
panel[, .(year, inv_agro_usd_mm, inv_agro_pct_gdp)]
```

**PSE y sus componentes (2006-2023):**
```r
pse <- readRDS("01_data/processed/idb_pse_bolivia_aggregate.rds")
pse[, .(year, PSE_BOB_mm, MPS_BOB_mm, GSSE_BOB_mm, TSE_BOB_mm, PSEP_pct)]
```

**Apoyo por commodity (2023):**
```r
psct <- readRDS("01_data/processed/idb_psct_by_commodity.rds")
psct[year == 2023]
```

**TFP Bolivia vs LAC:**
```r
tfp <- readRDS("01_data/processed/usda_tfp_latam.rds")
tfp[Year == 2023, .(country_label, TFP_Index)][order(-TFP_Index)]
```

**PIB agropecuario por departamento 2021:**
```r
pib <- readRDS("01_data/processed/pib_departamental_agro.rds")
pib[year == 2021][order(-pib_agro_bob_chain2017)]
```

**Shapefile Bolivia (9 deptos):**
```r
library(sf)
adm1 <- st_read("01_data/external/bolivia_adm1_departments.gpkg")
```

---

*Última actualización: 2026-04-21. Ver anexo completo en `04_report/appendix/A_data_sources.qmd`.*
