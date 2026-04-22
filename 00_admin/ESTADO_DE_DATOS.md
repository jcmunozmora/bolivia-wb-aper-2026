# Estado de datos del proyecto — WB Bolivia APER 2026

**Última actualización:** 2026-04-22 (sesión 8)
**Panel nacional v10:** `01_data/processed/spending_panel_v10.rds` (35 años × 143 variables) ⭐⭐ NEW
**Panel subnacional v2:** `01_data/processed/subnacional_panel_v2.rds` (90 × 36 vars)
**Panel municipal v3:** `01_data/processed/municipal_panel_v3.rds` (3,368 × 70 vars) ⭐⭐
**DEA-ready:** `01_data/processed/dea_dataset.rds` (81 DMUs × 32 vars)
**EH panel 2012-2024:** `01_data/processed/eh_panel_2012_2024.rds` (309,185 personas × 28 vars)
**CNA 2013 municipal:** `01_data/processed/cna2013_indicadores.rds` (338 municipios × 49 vars)
**ENA 2008:** `01_data/processed/ena_2008_upa_indicadores.rds` (8,022 UPAs × 33 vars) ⭐
**ENA 2015:** `01_data/processed/ena_2015_upa_indicadores.rds` (12,650 UPAs × 34 vars) ⭐
**NRP extendido:** `01_data/processed/pse_nrp_extended.rds` (NRP 1991-2023 × 7 commodities) ⭐
**FAOSTAT PP Bolivia:** `01_data/processed/faostat_pp_bolivia.rds` (119 commodities × 1991-2025) ⭐
**Regresiones extendidas:** `01_data/processed/extended_regression_results.rds` + `05_outputs/tables/extended_regressions.txt`
**MEFP ejecución anual:** `01_data/processed/mefp_ejecucion_anual.rds` (tasas 2015-2023 MEFP) ⭐ NEW
**Datasets procesados:** 123 archivos `.rds` en `01_data/processed/` (+ `.csv` espejo)
**Scripts de recolección:** 42 en `02_code/01_data_collection/` + 8 en `03_analysis/`

> Este documento consolida el estado real de los datos para no repetir trabajo
> y saber exactamente qué falta. Se actualiza con cada integración.

---

## 1. Panel maestro v10 — completitud por grupo (35 años × 143 vars)

### ✅ Cobertura completa (≥90%)

| Grupo | Vars | Cobertura | Fuente |
|-------|:----:|:---------:|--------|
| Inversión VIPFE sectorial | 11 | 35/35 (1990-2024) | MEFP Informe Fiscal 2024 |
| USDA TFP | 4 | 34/35 (1990-2023) | USDA ERS |
| CHIRPS precipitación (interpolado) | 3 | 34/35 (1990-2023) | CHIRPS TIF + interpolación lineal |
| WDI macro Bolivia | 8 | 34/35 (1990-2023) | WDI API |
| INE cereales yields | 2 | 32/35 (1984-2020) | INE Estadísticas Agrícolas |
| MapBiomas LC nacional | 10 | 40/40 (1985-2024) | MapBiomas Bolivia Col.3 |
| FAOSTAT PP + NRP pre-2006 | 12 | 31/35 (1991-2024) | FAOSTAT PP + WB Pink Sheet ⭐ NEW |

### 🟡 Cobertura media (50-90%)

| Grupo | Vars | Cobertura | Período |
|-------|:----:|:---------:|:-------:|
| PSE/GSSE/TSE IDB AgriMonitor | 29 | 18/35 (2006-2023) | IDB AgriMonitor |
| IFPRI SPEED ag. funcional | 5 | 18/35 (1990-2007) | IFPRI SPEED 2019 |
| WDI outcomes LAC | 5 | 23-24/35 | 2000-2023 |
| BOOST gasto agrop | 11 | 13/35 (1996-2008) | BOOST Bolivia |
| Hansen deforestación (nac.) | 1 | 23/35 (2001-2023) | Hansen GFC v1.11 |
| FAOSTAT QCL Bolivia | 3 | 15-35/35 | 1984-2023 |

### 🔴 Cobertura limitada (<50%)

| Grupo | Vars | Cobertura | Período |
|-------|:----:|:---------:|:-------:|
| WDI financiero Bolivia | 5 | 13-34/35 | 1990-2023 |
| BCB crédito agrop sectorial | 8 | 15/35 (2010-2024) | BCB Boletín Estadístico T.3.02 |
| GHG emisiones (IDB) | 1 | 5/35 | 2019-2023 |

---

## 2. Inventario detallado de fuentes procesadas

### 2.0B BCB Boletín Estadístico — Crédito por Sectores Económicos (sesión 7) ⭐ NEW

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `bcb_credito_sectorial_trimestral.rds` | Crédito sistema bancario × 20 sectores | 63 × 25 | 2010 Q1 – 2025 Q3 |
| `bcb_credito_sectorial_anual.rds` | Valores diciembre × sectores clave | 15 × 9 | 2010-2024 |

**Fuente:** BCB Boletín Estadístico Trimestral, Cuadro 3.02 — Financiamiento concedido por el Sistema Bancario por Sectores Económicos. URL: `webdocs/publicacionesbcb/2025/12/31/03_02.xlsx`. Unidades: miles de Bolivianos corrientes.

**Hallazgos clave crédito agropecuario:**
- **2010:** 1,991 MM Bs / 290 MM USD — 5.1% del crédito total bancario
- **2013:** 3,717 MM Bs / 542 MM USD — 5.4% ← pre-Ley 393
- **2014:** 6,570 MM Bs / 958 MM USD — 7.2% ← Ley 393 julio 2014 (Bancos PYME incluidos Sep-2014)
- **2017:** 14,167 MM Bs / 2,065 MM USD — 10.1% ← supera 10% por primera vez
- **2024:** 23,306 MM Bs / 3,397 MM USD — 11.7% del crédito total
- **Quiebre estructural:** Sep 2014 — creación Bancos PYME por Ley 393. Dummy requerido en regresiones
- **Inversión pública vs crédito:** VIPFE bajó de 0.97% PIB (2015) a 0.38% (2021); crédito agrop subió de 1.4B a 2.8B USD (2015-2021) → sustitución política pública → crédito subsidiado
- **Ley 393/2013:** mandató mínimos de cartera productiva para bancos; agro pasó de 5% a 11% del total en 10 años

**Nota metodológica:** Cuadro 3.02 = solo banca múltiple (excl. cooperativas, EFH, IFD). Cuadros 03_12-03_15 tienen otras entidades (no integrados aún). Tipo de cambio: 6.86 BOB/USD (peg oficial).

---

### 2.0 IFPRI SPEED (nueva sesión 6)

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `speed_agro_bolivia.rds` | Bolivia Agricultura × 9 vars (pctgdp, pctexp, pctaggdp, USD, PPP…) | 38 × 11 | 1980-2007 |
| `speed_bolivia.rds` | Bolivia todos los sectores, long format | 3,648 × 9 | 1980-2017 |
| `speed_lac_agro.rds` | LAC + OCDE sector Agricultura | ~1,200 × 9 | 1980-2017 |
| `speed_ec_bolivia.rds` | Bolivia composición económica (sueldos/subsidios/intereses) | 13 × 15 | 1995-2007 |
| `speed_ec_lac_region.rds` | Regiones mundiales gasto total % PIB | 272 × 3 | 1986-2015 |

**Hallazgos SPEED Bolivia (hallazgos clave para el APER):**
- **Meta Maputo**: Bolivia NUNCA superó el 10% — máximo histórico 3.48% (1990), promedio 2000-2007: 2.2%
- **Ranking LAC 2000-2017**: Bolivia en posición 9/24 (0.43% PIB) — por encima de Argentina (0.08%), Chile (0.31%), Perú (0.21%)
- **VIPFE vs SPEED**: divergencia post-2003 (VIPFE ~0.6% PIB vs SPEED ~0.5%) — diferencia metodológica en cobertura
- **Composición económica 2000-2007**: salarios 44%, bienes/servicios 20%, beneficios sociales 18%, intereses 10%, subsidios 2.5%
- **Bolivia vs LAC gasto total**: Bolivia debajo del promedio LAC hasta 2001, luego supera (boom hidros 2002-2007)
- **Cobertura temporal SPEED**: gap 2008-2017 para Bolivia en ambas versiones (funcional + económica)

---

### 2.A.2 MEFP Ejecución Presupuestaria — Entidad 035 (sesión 8) ⭐ NEW

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `mefp_ejecucion_anual.rds` | Serie anual TOTAL — vigente/ejecutado/% | 9 × 4 | 2015-2023 |
| `mefp_ejecucion_grupo.rds` | Grupo de Gasto × año — inicial/vigente/ejec/% | 58 × 7 | 2015-2023 |

**Fuente:** 9 PDFs `Ejecucion_YYYY.pdf` (DGAA MEFP) — solo Entidad 035 (Ministerio de Economía y Finanzas Públicas). Script: `42_process_mefp_ejecucion.R`.

**Hallazgos clave tasas de ejecución MEFP 2015-2023:**
- **Rango histórico**: 42.3% (2020) – 96.2% (2023)
- **Mínimo 2020**: presupuesto vigente explotó 13× (de 426 MM a 5,540 MM Bs) por transferencias COVID, ejecución cayó al 42% — patrón típico de shock fiscal
- **Recuperación 2022-2023**: tasas 93-96% tras normalización
- **Composición 2023**: 82% del vigente fue "Otros Gastos" (devoluciones al TGN), 8% salarios, 6% activos reales
- **Servicios No Personales** es consistentemente el grupo con menor ejecución (46-79%) — típico indicador de subejecución en compras
- **Uso en APER**: benchmark de referencia para comparar con tasas de ejecución de MDRyT cuando se obtengan vía carta formal DS 28168

**Limitaciones:**
- Solo Entidad 035 (MEFP); no hay MDRyT/INIAF/SENASAG en los PDFs de DGAA
- Estructura Programática (2020+) y Dirección Administrativa no parseables por text-wrapping en pdftools
- Vitrinas Presupuestarias son newsletters temáticos — sin tasas sistemáticas
- Informe Fiscal 2024 tiene ejecución subnacional (p54) 2020-2024: Gobernaciones 66-83%, Muni Grandes 54-64%, Muni Pequeños 49-72%

---

### 2.A Gasto público agropecuario

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `inversion_publica_sectorial_long.rds` | VIPFE inversión agrop × sector | 520 × 5 | 1990-2024 |
| `informe_fiscal_2024_agro_series.rds` | MEFP series fiscales agrop | 882 series | 2000-2024 |
| `boost_agro_panel.rds` | BOOST gasto agrop anual | 13 × 11 | 1996-2008 |
| `boost_agro_nivel.rds` | BOOST por nivel (nac/dept/muni) | 76 × 6 | 1996-2008 |
| `boost_agro_sector.rds` | BOOST por sector (agric/pecuaria/silv…) | 91 × 4 | 1996-2008 |
| `boost_agro_subsector.rds` | BOOST por subsector institucional | 78 × 3 | 1996-2008 |
| `boost_agro_entidades.rds` | BOOST top entidades ejecutoras | 91 × 2 | 1996-2008 |
| `boost_full.rds` | BOOST sector público completo | 104,275 × 38 | 1996-2008 |
| `aper_agro.rds` | APER código UDAPE-FAM agrop | 27,512 × N | 1996-2008 |
| `aper_dept_panel.rds` | APER por departamento | 438 × 8 | 1996-2008 |
| `jubileo_municipal_full_2012_2021.rds` | Jubileo municipal raw | 73,983 × 7 | 2012-2021 |
| `jubileo_departamental_2012_2021.rds` | Jubileo departamental | 2,790 × 6 | 2012-2021 |
| `mefp_deuda_destino_long.rds` | Deuda rural × 9 depts × 8 destinos | 846 × 4 | 2005-2022 |

**Hallazgo clave BOOST 1996-2008:**
- Gasto agrop ejecutado: 278M BOB (1996) → 1,282M BOB (2008); tasa ejecución 74% → 101%
- Composición 2008: Agricultura 63%, Agropecuaria 15%, Ganadería 6%, Silvicultura 6%
- Top ejecutoras: MDRyT, Prefecturas Tarija/Cochabamba/Santa Cruz, EMAPA (BDP precursor)

---

### 2.B Producción agrícola (INE)

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `ine_agro_stats_long.rds` | Producción/rendimiento/superficie anual | 64,688 × 6 | 1984-2024 |
| `ine_campanas_long.rds` | Campañas invierno/verano × cultivo × dept | 29,996 × 7 | 2012-2024 |
| `ine_campanas_wide.rds` | Panel wide cultivos clave (Bolivia) | 13 × 52 | 2012-2024 |
| `cereal_yield_nacional.rds` | Yield cereales ponderado Bolivia | 37 × 4 | 1984-2020 |
| `cereal_yield_dept.rds` | Yield cereales × 9 depts | 178 × 3 | 1984-2020 |
| `cereal_prod_nacional.rds` | Producción cereales total Bolivia | 37 × 2 | 1984-2020 |
| `ena_2008_upa_indicadores.rds` | ENA 2008 UPA-level (cultivos+bovinos+tractores) | 8,022 × 33 | 2008 ⭐ NEW |
| `ena_2008_cultivos_nacional.rds` | Resumen nacional × cultivo (expandido) | 144 cultivos | 2008 ⭐ NEW |
| `ena_2008_dept_resumen.rds` | Resumen departamental × 9 deptos | 9 × 8 | 2008 ⭐ NEW |
| `ena_2015_upa_indicadores.rds` | ENA 2015 UPA-level (cultivos+bovinos+tractores) | 12,650 × 34 | 2015 ⭐ NEW |
| `ena_2015_cultivos_nacional.rds` | Resumen nacional × cultivo (expandido) | 256 cultivos | 2015 ⭐ NEW |
| `ena_2015_dept_resumen.rds` | Resumen departamental × 9 deptos | 9 × 8 | 2015 ⭐ NEW |
| `ena_comparacion_2008_2015.rds` | Comparación 2008 vs 2015 × dept | 9 × 14 | 2008/2015 ⭐ NEW |

**Hallazgos ENA 2008 vs 2015 (comparación departamental):**
- **UPAs:** Declive generalizado (−22% a −38%) excepto Oruro (+63%), Beni (+47%), Santa Cruz (+20%) — consolidación en altiplano, expansión en llanos
- **Bovinos:** Santa Cruz +65.5% (2.2M→3.7M) — boom ganadero oriente; Beni −18% (3.3M→2.7M) — posible impacto climático
- **Soya 2015:** 1.3M ha expandidas (top cultivo, vs ~563K ha en 2008) — crecimiento masivo
- **% mujeres productoras:** Aumentó en todos los deptos: 8.9%→15.9% (Chuquisaca), 9.5%→14.4% (Santa Cruz) — mejora en visibilidad estadística
- **Bovinos nacionales:** 7.79M (2008) → 8.95M (2015) = +14.9% — validado vs CNA 2013: 8.1M

**Tendencia cereales Bolivia:** 1,427 kg/ha (1990) → 2,188 kg/ha (2020) = +53% en 30 años.
**Campañas 2024:** 74 cultivos documentados, producción total cereales verano ~2.0M ton.

---

### 2.B.2 FAOSTAT PP — Precios productor + WB Pink Sheet (sesión 8) ⭐ NEW

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `faostat_pp_bolivia.rds` | PP Bolivia × 119 commodities, long (LCU+USD+índice) | 9,375 obs | 1991-2025 |
| `faostat_pp_lac.rds` | PP LAC × 9 países × commodities clave | ~50K obs | 1991-2025 |
| `wb_pink_sheet_agro.rds` | WB precios mundiales referencia (9 commodities) | 66 × 12 | 1960-2025 |
| `pse_nrp_extended.rds` | NRP Bolivia × 7 commodities (soya/maíz/trigo/arroz/cana/sorgo/cebada) | 34 × 22 | 1991-2024 |

**Fuentes:** FAOSTAT bulk download `Prices_E_Americas.zip` (Bolivia área 19) + WB Commodity Markets Outlook Pink Sheet (CMO-Historical-Data-Annual.xlsx).

**Hallazgos NRP (Nominal Rate of Protection) — Bolivia 1991-2023:**

| Commodity | NRP 1991-2005 | NRP 2006-2023 | Interpretación |
|-----------|:-------------:|:-------------:|----------------|
| **Soya** | −37.3% | −33.5% | Precio doméstico siempre BAJO precio mundial → exportadores soya taxados |
| **Maíz** | +45.8% | +38.5% | Precio doméstico SOBRE precio mundial → maíz subsidiado (seguridad alimentaria) |
| **Trigo** | +28.2% | +21.4% | Precio doméstico SOBRE precio mundial → trigo protegido |
| **Arroz** | −33.4% | −31.7% | Precio doméstico BAJO precio mundial → arroz taxado |
| **Caña** | −50.4% | +55.9% | Cambio drástico: pre-2006 taxación, post-2006 protección |
| **Sorgo** | −53.1% | −46.9% | Consistentemente taxado |
| **Cebada** | +30.6% | +64.5% | Consistentemente protegida |

**Notas metodológicas:**
- NRP = (PP_doméstico_USD/t − PP_referencia_USD/t) / PP_referencia_USD/t × 100
- Referencia: WB Pink Sheet (Soybeans, Maize, Wheat HRW, Rice Thai 5%, Sugar world, Sorghum, Barley)
- NRP ≠ PSE OECD: no incluye transferencias presupuestales (GSSE). Para PSE completo, combinar con IDB AgriMonitor (2006-2023)
- **Anomalía caña 2015**: PP doméstico = 261 USD/mt vs referencia 37 USD/mt → revisar cambio metodológico INE
- Bolivia sin datos PP soya/maíz/trigo 2020-2023 en FAOSTAT (gap reciente)

---

### 2.C PSE / GSSE / TSE (Apoyo al productor)

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `pse_gsse_bolivia.rds` | PSE/GSSE/TSE Bolivia wide | 18 × 17 | 2006-2023 |
| `pse_gsse_lac_panel.rds` | PSE/GSSE/TSE 10 países LAC | 243 × 19 | 2006-2023 |
| `idb_pse_bolivia_aggregate.rds` | PSE agregado Bolivia IDB | N × M | 2006-2023 |
| `idb_agrimonitor_lac_full.rds` | AgriMonitor LAC completo | 134,581 × 27 | 1986-2024 |
| `idb_psct_by_commodity.rds` | PSE por commodity Bolivia | N × M | 2006-2023 |
| `idb_prices_gap_bolivia.rds` | Brecha precios doméstico-frontera | N × M | 2006-2023 |

**Hallazgo PSE 2023:**
- PSE% Bolivia = **5.8%** (5to en LAC tras México 6.6%, Colombia 5.6%, Perú 5.1%, Brasil 4.4%)
- GSSE creció: 251M BOB (2006) → 2,015M BOB (2023) — apoyo en servicios generales domina
- PSE volátil: −27% (2009, control precios implicitamente grava al productor) → +7% (2016)
- Argentina: PSE = −17.9% (taxación implícita al productor vía retenciones)

---

### 2.D TFP y benchmarking internacional

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `usda_tfp_bolivia.rds` | TFP agrícola Bolivia índice | 34 × 5 | 1990-2023 |
| `usda_tfp_latam.rds` | TFP LATAM ranking | 34 × 20 | 1990-2023 |
| `faostat_bolivia_qcl.rds` | FAOSTAT Bolivia producción/yields | 64 × 18 | 1961-2023 |
| `faostat_latam_qcl.rds` | FAOSTAT LAC comparadores | 1,279 × 18 | 1961-2023 |

---

### 2.E Comparadores LAC / WDI

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `wdi_bolivia.rds` | 20 indicadores WDI Bolivia | 34 × 22 | 1990-2023 |
| `wdi_lac_panel.rds` | WDI 20 indicadores × 19 países LAC | 646 × 23 | 1990-2023 |
| `cepal_comparators.rds` | BOL vs LAC mediana/media | 102 × 23 | 1990-2023 |
| `andinos_wdi_panel.rds` | BOL+COL+PER+ECU+PRY+ARG | 204 × 23 | 1990-2023 |
| `wdi_financial_bolivia.rds` | Indicadores financieros WDI | 34 × 6 | 1990-2023 |

**Ranking LAC valor agropecuario % PIB (2020):**
Haití 20.4% → Nicaragua 15.9% → Honduras 12.2% → **Bolivia 9.1% (6to)** → Chile 4.0% → México 3.7%

---

### 2.F Uso de suelo y deforestación

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `mapbiomas_national_annual.rds` | Cobertura nacional Bolivia | 40 × 8 | 1985-2024 |
| `mapbiomas_dept_annual.rds` | LC × 9 depts × macro-clase | 360 × 6 | 1985-2024 |
| `mapbiomas_municipal_annual.rds` | LC × 339 municipios | 13,560 × 7 | 1985-2024 |
| `mapbiomas_cobertura_long.rds` | Todas las clases × territorios | 349,600 × 5 | 1985-2024 |
| `mapbiomas_cambio_dept.rds` | Resumen cambio por depto | 9 × 8 | 1985→2024 |
| `hansen_dept_annual_deforestation.rds` | Deforestación GFC × dept × año | 207 × 4 | 2001-2023 |
| `hansen_dept_cumulative.rds` | Deforestación acumulada × dept | 9 × 4 | 2001-2023 |
| `hansen_muni_annual_deforestation.rds` | Deforestación GFC × muni × año | ~7,800 × 4 | 2001-2023 |
| `hansen_dept_treecover_2000.rds` | Cobertura arbórea base 2000 | 9 × 3 | 2000 |

**Bolivia pérdida forestal:** 9.4M ha en 40 años. Santa Cruz concentra 64% de la expansión agrícola (+6.06M ha).

---

### 2.G Clima y recursos hídricos

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `chirps_dept_annual.rds` | Precipitación TIF (6 snapshots) | 54 × 4 | 2000,2005,2010,2015,2020,2023 |
| `chirps_dept_annual_complete.rds` | Precipitación interpolada lineal | 306 × 4 | 1990-2023 |
| `chirps_nacional_annual.rds` | Promedio nacional anual | 34 × 3 | 1990-2023 |

**Tendencia:** Oruro/Potosí se han secado 25-30% desde 2000. Pando: 1,533 mm/año (máx).

---

### 2.H PIB departamental y macro

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `pib_departamental_agro.rds` | PIB agrop × 9 depts | 50 × 5 | 2017-2021 |
| `pib_departamental_complete.rds` | PIB × 18 actividades × 9 depts | 910 × 6 | 2017-2021 |
| `gdp_bolivia.rds` | PIB Bolivia macro | N × M | 2000-2023 |

---

### 2.I Crédito y sector financiero

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `bcb_credito_sector_snapshot.rds` | Crédito por sector × banco (BCB) | ~35 × 16 | Sept-2025 |
| `bcb_credito_agro_total.rds` | Crédito agrop por grupo bancario | 4 × 9 | Sept-2025 |
| `wdi_financial_bolivia.rds` | Tasas de interés, crédito % PIB | 34 × 6 | 1990-2023 |

**Snapshot BCB Sept 2025:**
- Bancos Múltiples: 16% cartera en agropecuario
- Bancos PYME: 36% en agropecuario
- BDP (banco público de desarrollo): **68% en agropecuario** — refleja mandato de desarrollo productivo
- Sistema total: ~18% del crédito bancario va al sector agropecuario
- Tasa activa Bolivia: ~8% (2019-2022); real 5-8% (tipos relativamente altos vs vecinos)

---

### 2.K Encuesta de Hogares Bolivia 2012-2024

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `eh_panel_2012_2024.rds` | Panel completo persona-nivel | 309,185 × 28 | 2012-2024 |
| `eh_nacional_anual.rds` | Indicadores anuales × área (total/rural/urban) | 24 × 11 | 2012-2024 |
| `eh_dept_anual.rds` | Indicadores × depto × área | 144 × 9 | 2012-2024 |
| `eh_2012.rds` | EH 2012 (sin FIES) | 31,935 × 28 | 2012 |
| `eh_2015.rds` | EH 2015 (sin FIES) | 37,364 × 28 | 2015 |
| `eh_2019.rds` | EH 2019 + FIES (s09a_) | 39,605 × 28 | 2019 |
| `eh_2020.rds` | EH 2020 COVID — sin FIES | 37,092 × 28 | 2020 |
| `eh_2021.rds` | EH 2021 + FIES (s08a_) | 42,090 × 28 | 2021 |
| `eh_2022.rds` | EH 2022 + FIES (s07a_) | 40,955 × 28 | 2022 |
| `eh_2023.rds` | EH 2023 + FIES (s07a_) | 40,647 × 28 | 2023 |
| `eh_2024.rds` | EH 2024 + FIES (s07a_) | 39,497 × 28 | 2024 |

**Variables clave estandarizadas:** `yhogpc` (ingreso pc), `p0`/`pext0` (pobreza/extrema), `caeb_op` (sector ocupación — 0=agropecuario), `fies_score` (0-8), `fies_insecure` (≥1), `fies_severe` (≥6)

**Hallazgos de pobreza rural Bolivia (2012-2024):**
- Pobreza rural: 55.2% (2012) → 40.3% (2021) → 45.1% (2024) — reversión post-2021
- Pobreza extrema rural: 36.2% (2012) → 16.5% (2021) → 21.6% (2024)
- Empleo agropecuario rural (% PEA): 72% (2012) → 67% (2023) — lenta diversificación
- FIES inseguridad alimentaria (mild+): 41.3% (2019) → 65.1% (2024) — **tendencia alarmante**
- Dept. más pobre rural (2024): Chuquisaca 64%, Oruro 54%, Potosí 54%
- Dept. menos pobre rural (2024): Pando 27%, Tarija 33%, Beni 34%

**Notas técnicas:**
- FIES disponible: 2019, 2021, 2022, 2023, 2024 (NO en 2012, 2015, 2020-COVID)
- `folio`: character ("111-XXXXXXXXXX-A-XXXX") en 2015+; numeric en 2012
- Peso de expansión: `factor_2014` (EH2012), `factor` (2015-2024)
- `caeb_op == 0` = Agricultura+Ganadería+Caza+Pesca+Silvicultura (CAEB sección A+B)

---

### 2.J Subnacional — gasto y resultados

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `subnacional_panel_v2.rds` | Panel dept (gasto + PIB + LC) | 90 × 36 | 2012-2021 |
| `dea_dataset.rds` | DEA-ready 81 DMUs | 81 × 32 | 2012-2020 |
| `municipal_panel_v3.rds` | Panel muni v3 (gasto + LC + Hansen + CNA 2013) | 3,368 × 70 | 2012-2021 |
| `municipal_panel_v2_lc.rds` | Panel muni v2 (gasto + MapBiomas) — precursor | 3,368 × 23 | 2012-2021 |
| `adm3_muni_con_datos_2020.rds` | Shape + datos 2020 (339 munis) | 339 × N | 2020 |
| `cna2013_indicadores.rds` | CNA 2013: 49 indicadores × 338 munis | 338 × 49 | 2013 (CS) |
| `cna2013_municipios.rds` | Catálogo dept/prov/municipio Bolivia | 339 × 6 | — |
| `extended_regression_results.rds` | Modelos M1-M6 + MS1-MS5 + MP1-MP4 + eficiencia | lista | 2026-04-22 |

**Hallazgos CNA 2013 (línea base estructural):**
- Superficie promedio por UPA: 6.85 Ha (Sucre) — enorme heterogeneidad entre municipios
- % con riego: Santa Cruz 5.8% vs Sucre 24.4% — acceso a riego muy desigual
- Bovinos: San Ignacio de Velasco (Santa Cruz) 397,713 cabezas — ganadería extensiva del oriente
- Tractores: Warnes (Santa Cruz) 824 — mecanización concentrada en agroindustria del oriente
- Total nacional validado: 871,807 UPAs, 8.1M bovinos, 247K Ha irrigadas, 36.5K tractores

---

## 3. Qué FALTA (por prioridad para el APER)

### 🔴 TIER 1 — Bloquea análisis específicos

**3.1 Presupuesto institucional nacional post-2008 (SIIF / MDRyT)**
- ❌ Sin datos desagregados por institución: MDRyT, INIAF, SENASAG, INRA, BDP, FDI
- ✅ Tenemos: VIPFE agregado sectorial + Jubileo municipal + BOOST 1996-2008
- **Impacto:** No podemos calcular retorno por tipo de gasto (I+D vs riego vs extensión) post-2008
- **Acción:** Carta formal DS 28168 al MEFP + contacto WB Country Office Bolivia

**3.2 Encuesta de Hogares (EH) procesada para análisis de incidencia**
- ✅ **COMPLETADO sesión 5** — 8 años procesados (2012, 2015, 2019, 2020, 2021, 2022, 2023, 2024)
- Script: `33_process_encuestas_hogares.R`
- Outputs: `eh_YYYY.rds` × 8 + `eh_panel_2012_2024.rds` + `eh_nacional_anual.rds` + `eh_dept_anual.rds`
- Variables: pobreza (`p0`, `pext0`), empleo agro (`caeb_op==0`), FIES 8 preguntas (2019-2024), ingreso per cápita

**3.3 IFPRI SPEED database (benchmark global gasto agropecuario)**
- ✅ **COMPLETADO sesión 6** — SPEED 2019 (funcional) + SPEED_EC (económica) procesados
- Scripts: `36_process_ifpri_speed.R` + `37_process_ifpri_speed_ec.R`

---

### 🟡 TIER 2 — Enriquecimiento sustancial

**3.4 Crédito agropecuario BDP/sistema histórico (serie 2000-2024)**
- ✅ **COMPLETADO sesión 7** — BCB Boletín Estadístico T.3.02: 2010-2024 (63 trimestres)
- Script: `38_process_bcb_credito.R`
- Outputs: `bcb_credito_sectorial_trimestral.rds` + `bcb_credito_sectorial_anual.rds`
- **Hallazgo:** Crédito agrop pasó de 5.1% (2010-2013) a 11.7% (2024) por Ley 393/2014 (Bancos PYME)
- **Pendiente:** Pre-2010 no disponible en Boletín Estadístico en línea (solo 2025/12/31 edition activa)

**3.5 Censo Agropecuario 2013 — indicadores municipales**
- ✅ **COMPLETADO sesión 5** — scrapeado SICE INE, 338/339 municipios
- Script: `34_scrape_cna2013_sice.R`
- Outputs: `cna2013_indicadores.rds` (338 × 49 vars) + `cna2013_municipios.rds`
- Variables: UPAs, superficie total/agrícola/con riego, ganadería (16 especies), maquinaria, empleo agro, % riego
- Totales nacionales validados: 871,807 UPAs, 8.1M bovinos, 247K ha irrigadas

**3.6 Microdatos ENA 2008 y ENA 2015**
- ✅ **COMPLETADO sesión 8** — ENA 2008 (8,022 UPAs) + ENA 2015 (12,650 UPAs) procesados
- Scripts: `39_process_ena_2008.R` + `40_process_ena_2015.R`
- Outputs: UPA-level indicators × 2 años + cultivos nacionales + resumen dept + comparación 2008 vs 2015
- **Hallazgo clave:** Soya creció de 563K ha → 1.3M ha (+131%); mujeres productoras subieron en todos los deptos

**3.7 Precios productor por commodity (pre-2006)**
- ✅ **COMPLETADO sesión 8** — FAOSTAT PP 1991-2024 + WB Pink Sheet 1960-2025
- Script: `41_process_faostat_pp.R`
- Outputs: `faostat_pp_bolivia.rds` (119 commodities × 4 elementos) + `wb_pink_sheet_agro.rds` (9 refs) + `pse_nrp_extended.rds` + `faostat_pp_lac.rds` (9 países LAC)
- **Hallazgo:** Bolivia taxa exportables (soya −37%, arroz −33%) y protege seguridad alimentaria (maíz +46%, trigo +28%) — consistente con controles de precios/exportación
- Integrado en `spending_panel_v10.rds` (+12 vars: pp_soya/maiz/trigo/arroz/papa/quinua_usd + nrp_* + avg_nrp)

---

### 🟢 TIER 3 — Complementos marginales

**3.8 Memorias institucionales MDRyT 2015-2024**
- ❌ No descargadas (programas Bolivia Cambia, MIAGUA, Mi Riego, MINKA)
- **Valor:** Narrativa cualitativa para Cap. 3, justificar cambios en composición del gasto

**3.9 Datos SIIF subnacional municipal 2009-2023**
- ❌ Portal Jubileo no filtra por municipio server-side
- **Alternativa A:** Browser automation (Playwright)
- **Alternativa B:** Contacto directo Jubileo Bolivia (René Martínez)
- **Valor:** DEA municipal (en lugar de solo departamental)

**3.10 Tasas de ejecución — Ejecucion MEFP anual**
- ✅ **COMPLETADO sesión 8** — parser de 9 PDFs `Ejecucion_YYYY.pdf` (2015-2023)
- Script: `42_process_mefp_ejecucion.R`
- Outputs: `mefp_ejecucion_anual.rds` (9 años) + `mefp_ejecucion_grupo.rds` (58 obs, 7 grupos × 9 años)
- **Hallazgo:** Rango 42-96% ejecución; mínimo en 2020 (COVID, presupuesto 13× explotado); recuperación 93-96% en 2022-2023
- **Limitación:** solo MEFP (Entidad 035). MDRyT/INIAF/SENASAG NO disponibles en PDFs públicos. Vitrinas Presupuestarias son temáticas (no sistemáticas). Requiere carta MEFP DS 28168 para desagregación institucional.

---

## 4. Viabilidad por capítulo del reporte

| Capítulo | Estado | Pendiente crítico |
|:--------:|:------:|-------------------|
| **2 — Desempeño del sector** | ✅ LISTO | — TFP, yields, MapBiomas, WDI LAC, PSE ranking |
| **3 — Gasto público** | 🟡 PARCIAL | Benchmark SPEED 1990-2007 disponible; falta desagregación institucional post-2008 |
| **4a — PSE/GSSE/TSE** | ✅ LISTO | IDB AgriMonitor 2006-2023 + LAC + SPEED Maputo + NRP FAOSTAT pre-2006 (7 commodities) |
| **4b — DEA eficiencia** | ✅ LISTO | 81 DMUs, 3 inputs, 2 outputs; eficiencia proxy por depto corrida |
| **4c — Regresiones panel** | ✅ LISTO | Panel v10 × panel muni v3; M1-M6 nacionales + MS1-MS5 subnacionales; dummy post_ley393 + precios domésticos/NRP disponibles |
| **4d — Equidad/incidencia** | ✅ LISTO | EH 2012-2024 (309K personas); FIES 2019-2024; 33.6K trabajadores agro; ENA 2008+2015 UPAs (20K) |
| **5 — Recomendaciones** | ⏳ DESPUÉS | Depende de hallazgos 2-4 |

---

## 5. Panel maestro — evolución histórica

| Versión | Variables | Adición |
|---------|:---------:|---------|
| `spending_panel_v1.rds` | 25 | VIPFE + TFP + WDI básico |
| `spending_panel_v2.rds` | 44 | + IDB AgriMonitor PSE |
| `spending_panel_v3.rds` | 58 | + Jubileo + MEFP proxies |
| `spending_panel_v4.rds` | 83 | + MapBiomas + ENA + EMAPA |
| `spending_panel_v5.rds` | 91 | + PIB dept + Hansen |
| `spending_panel_v5_fao.rds` | 98 | + FAOSTAT QCL |
| `spending_panel_v6.rds` | 102 | + CHIRPS completo + yields INE + FAOSTAT |
| `spending_panel_v7.rds` | 118 | + PSE/GSSE/TSE IDB formal + WDI LAC |
| `spending_panel_v8.rds` | 123 | + IFPRI SPEED ag_pctgdp/pctexp/pctaggdp/con_usd/con_ppp |
| `spending_panel_v9.rds` | 131 | + BCB crédito agrop sectorial (2010-2024) × 8 vars |
| **`spending_panel_v10.rds`** ⭐ | **143** | + FAOSTAT PP domésticos + NRP 1991-2023 × 12 vars |

---

## 6. Inventario de scripts

### `02_code/01_data_collection/` (42 scripts)

```
01-06:  APIs WDI/FAOSTAT/OECD/CEPAL/BOOST/manual (setup original)
07:     download_spatial.R           geoBoundaries ADM1+ADM2
08:     process_aper.R               APER 1996-2008 → panels
09:     process_usda_tfp.R           USDA TFP 1961-2023
10:     siif_strategy.md             Estrategia MEFP (4 tiers)
11:     download_alternatives.R      IFPRI, Agrimonitor URLs
12:     parse_mefp_boletin.R         Boletín ETA 2022
13:     parse_informe_fiscal_2024.R  MEFP Informe Fiscal 2024
14:     parse_inversion_publica.R    VIPFE sectorial 1990-2024
15:     process_idb_agrimonitor.R    IDB PSE completo
16:     scrape_jubileo_dept.R        Jubileo departamental
17:     scrape_jubileo_municipal.R   Jubileo municipal 340 munis
18:     process_ine_agro_stats.R     INE producción anual 1984-2024
19:     process_ena_2015.R           ENA 2015 módulos
20:     process_pib_departamental.R  PIB departamental 2017-2021
21:     process_mapbiomas.R          MapBiomas Bolivia Col.3
22:     process_mapbiomas_muni.R     MapBiomas municipal
23:     download_chirps.R            CHIRPS TIF (6 snapshots)
24:     integrate_municipal_lc.R     Panel municipal v2 + LC
25:     process_hansen.R             Hansen GFC deforestación
26:     process_faostat_qcl.R        FAOSTAT QCL via OWID
27:     enrich_climate_yields.R      CHIRPS interpolado + yields INE → panel v6
27b:    download_chirps_nasa_power.R NASA POWER API (alternativa CHIRPS)
28:     download_wdi_lac_comparators.R WDI LAC 20 países → panel comparativo
29:     process_boost.R              BOOST Bolivia 1996-2008
30:     process_ine_campanas.R       INE campañas invierno/verano 2012-2024
31:     process_pse_gsse.R           PSE/GSSE/TSE formal → panel v7
32:     download_bcb_wdi_financial.R BCB snapshot crédito + WDI financiero
33:     process_encuestas_hogares.R  EH 2012-2024 (8 años) → pobreza + FIES + empleo agro
34:     scrape_cna2013_sice.R        CNA 2013 fichas municipales SICE → 338 munis × 49 vars
35:     integrate_municipal_panel_v3.R Hansen + CNA 2013 → municipal_panel_v3 (3,368 × 70 vars)
36:     process_ifpri_speed.R          SPEED 2019 (funcional) → speed_agro_bolivia + speed_lac_agro + panel_v8
37:     process_ifpri_speed_ec.R       SPEED_EC (económica) → composición gasto Bolivia + LAC regional
38:     process_bcb_credito.R          BCB Boletín Estadístico T.3.02 → credito_sectorial + panel_v9
39:     process_ena_2008.R             ENA 2008 (26 módulos SAV) → UPA indicators + cultivos + dept summary
40:     process_ena_2015.R             ENA 2015 (Hogar + Agrícola + Bovinos) → UPA + comparación 2008/2015
41:     process_faostat_pp.R           FAOSTAT PP Americas + WB Pink Sheet → NRP 1991-2023 + panel_v10
42:     process_mefp_ejecucion.R       MEFP Ejecucion_YYYY.pdf 2015-2023 → tasas ejecución MEFP Ent 035 ⭐ NEW
```

### `02_code/03_analysis/` (3 scripts activos)

```
06:     first_regressions.R          Panel nacional M1-M6 (TFP ~ gasto + LC)
07:     mapbiomas_municipal_analysis.R LC analysis municipal
08:     extended_regressions.R       M1-M6 TFP + MS1-MS5 PIB dept + MP1-MP4 produc + eficiencia proxy ✓
```

**Hallazgos regresiones extendidas (sesión 6):**
- **M1 (nacional baseline):** β_gasto = 0.089***, R²=0.63 — relación positiva TFP ~ inversión agrop
- **M3 (con PSE):** PSEP% significativo negativo (−0.004**) — apoyo de precios distorsiona productividad
- **MS5 (dept + LC antrópica):** β_antrop = 0.60* — expansión frontera agrícola eleva PIB dept
- **Eficiencia proxy 2017-2021:** Santa Cruz score=1.0 (frontera); Tarija el menos eficiente (0.05)
- **LC antrópica explica 63% varianza** en scores de eficiencia departamental (R²=0.63)

---

## 7. Decisiones metodológicas adoptadas

1. **Fuente gasto principal:** VIPFE como línea de tiempo larga (1990-2024) + BOOST para detalle histórico (1996-2008) + Jubileo para componente subnacional municipal (2012-2021).

2. **PSE/GSSE:** IDB AgriMonitor como fuente oficial LAC (metodología OCDE aplicada por IDB; validado en publicaciones). No se necesita cálculo desde cero.

2b. **Benchmark histórico gasto agrop:** IFPRI SPEED 2019 como referencia metodológica GFS estándar (164 países, 1980-2017). Bolivia cubre 1980-2007. Para 2008-2024, usar VIPFE + Jubileo como proxies nacionales. SPEED confirma que Bolivia nunca superó la meta Maputo 10% (máx. histórico: 3.5% del gasto total, 1990).

3. **Crédito agropecuario:** BCB Boletín Estadístico T.3.02 (trimestral 2010-2024, `38_process_bcb_credito.R`). Quiebre estructural Sep 2014 por Ley 393 — incluir dummy `post_ley393` en regresiones. Variable integrada en panel v9 como `bcb_cred_agro_mm_bs/usd`. Pre-2010 no disponible en línea (edición única activa es 2025/12/31).

4. **CHIRPS:** 6 snapshots TIF interpolados linealmente a serie 34 años. Flaggear `source = "interpolado"` vs `"CHIRPS_TIF"` en análisis de sensibilidad.

5. **Panel maestro:** `spending_panel_v10.rds` (35 años × 143 vars) es el dataset canónico para análisis nacionales. `subnacional_panel_v2.rds` para análisis departamentales. `municipal_panel_v3.rds` para análisis municipales (con Hansen + CNA 2013).

6. **Deflactor:** CPI base 2015 (INE Bolivia). Variables monetarias en BOB reales 2015 y USD corrientes WDI.

7. **Precios y NRP pre-2006:** FAOSTAT PP (Bolivia área 19) como fuente doméstica; WB Pink Sheet como referencia mundial. NRP = (PP_dom − PP_ref)/PP_ref. NRP ≠ PSE completo (no incluye GSSE). Para PSE pre-2006 completo, combinar NRP con VIPFE/BOOST como proxy de transferencias presupuestales. Anomalía 2015 caña de azúcar (PP=261 USD/t) requiere verificación antes de usar en series largas.

---

## 8. Acciones prioritarias — próximas 2 semanas

| # | Acción | Impacto | Estado |
|:-:|--------|:-------:|:------:|
| 1 | **Poblar capítulos Quarto** — Cap. 2 (desempeño) y Cap. 3 (gasto) primero | 🔴 Alto | Pendiente |
| 2 | **Enviar carta MEFP DS 28168** — desagregación institucional post-2008 | 🟡 Medio | Lista para enviar |
| 3 | **Memorias MDRyT 2015-2024** — narrativa cualitativa para Cap. 3 | 🟢 Bajo | Pendiente |
| ✅ | ~~Tasas de ejecución MEFP~~ — script 42; Ejecucion_YYYY.pdf 2015-2023; 9 años × 7 grupos | — | HECHO sesión 8 |
| ✅ | ~~Precios PP + NRP pre-2006~~ — script 41; FAOSTAT PP + WB Pink Sheet; NRP 1991-2023 × 7 commodities | — | HECHO sesión 8 |
| ✅ | ~~ENA 2008 + 2015~~ — scripts 39 + 40; 8,022+12,650 UPAs; comparación dept 2008 vs 2015 | — | HECHO sesión 8 |
| ✅ | ~~BCB Boletines históricos~~ — `38_process_bcb_credito.R` T.3.02 2010-2024 (63 trimestres) | — | HECHO sesión 7 |
| ✅ | ~~IFPRI SPEED 2019 + SPEED_EC~~ — `36_process_ifpri_speed.R` + `37_process_ifpri_speed_ec.R` | — | HECHO sesión 6 |
| ✅ | ~~Regresiones extendidas~~ — `08_extended_regressions.R`, M1-M6 + MS1-MS5 + eficiencia proxy | — | HECHO sesión 6 |
| ✅ | ~~Panel municipal v3~~ — Hansen + CNA 2013, `35_integrate_municipal_panel_v3.R` | — | HECHO sesión 6 |
| ✅ | ~~EH Bolivia 2012-2024~~ — 8 años, 309K personas, `33_process_encuestas_hogares.R` | — | HECHO sesión 5 |
| ✅ | ~~CNA 2013~~ — 338/339 munis × 49 vars, `34_scrape_cna2013_sice.R` | — | HECHO sesión 5 |

---

**Responsable:** Juan Carlos Muñoz Mora — `jcmunozmora@gmail.com`
