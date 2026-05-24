# FUENTES.md — Inventario de fuentes crudas del APER Bolivia 2026

**Versión:** v0.2.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/03_FUENTES.md`
**Inventario maestro:** [`00_admin/Inventario_Datos_APER_Bolivia_2026.xlsx`](../00_admin/Inventario_Datos_APER_Bolivia_2026.xlsx) (5 hojas, 63 datasets).
**Estado de acceso:** [`00_admin/ESTADO_DE_DATOS.md`](../00_admin/ESTADO_DE_DATOS.md) (gaps, bloqueos, acciones pendientes).
**Diccionario del panel:** [`INDICADORES.md`](02_INDICADORES.md) (variables × grupos).
**Estado:** 🟢 **Estructurado** — fuentes primarias documentadas con licencia, fecha, path, ingesta y variables del panel que producen. Pendiente para v1.0: completar las 35+ fuentes secundarias del inventario y agregar checksums.

---

## Principios

1. **Fuentes son inmutables.** Una vez descargadas a `01_data/raw/<fuente>/`, no se editan. Cambios upstream disparan una **nueva descarga** versionada por fecha, no una sobre-escritura.
2. **Cada fuente declara licencia.** Sin licencia clara, la fuente no entra al panel.
3. **Cada fuente declara fecha de descarga.** Reproducibilidad requiere conocer la versión temporal de la fuente.
4. **Cada fuente apunta a su script de ingesta.** El script convierte la fuente cruda en RDS procesado.
5. **Cada fuente declara qué variables del panel produce.** Cross-reference con [INDICADORES.md](02_INDICADORES.md).
6. **Gaps documentados.** Fuentes faltantes o bloqueadas se registran en [ESTADO_DE_DATOS.md](../00_admin/ESTADO_DE_DATOS.md), no se ocultan.

---

## 1. Fuentes nacionales (Bolivia)

### 1.1. BOOST Bolivia — Banco Mundial

```text
proveedor          : Banco Mundial (BOOST initiative)
cobertura          : ejecución presupuestaria 1996–2024 (sector agropecuario:
                     n=13 años en panel v12, ventana 2009–2024 con datos sparse
                     hasta 2014)
licencia           : pública (BOOST Initiative)
fecha de descarga  : 2026-Q1 (release BOOST 2024)
path crudo         : 01_data/raw/boost/
formato            : Excel / CSV (clasificación funcional + económica + fuente
                     de financiamiento + entidad ejecutora)
script de ingesta  : 02_code/01_ingest/boost_*.R
RDS producidos     : 01_data/processed/boost_agro_*.rds
variables panel    : G04 — `boost_presup_*`, `boost_fuente_*`, `boost_gasto_*`,
                     `boost_tasa_ejecucion`, `boost_n_entidades`
caveats            : cobertura institucional incompleta (subnacionales parciales,
                     empresas estatales solo cuando reportan a SIGEP)
```

### 1.2. VIPFE — MEFP (Viceministerio de Inversión Pública y Financiamiento Externo)

```text
proveedor          : MEFP / VIPFE
cobertura          : inversión pública 1990–2024 (35 años, cobertura completa
                     en panel)
licencia           : pública (gobierno boliviano)
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/vipfe/
formato            : Excel + reportes anuales
script de ingesta  : 02_code/01_ingest/vipfe_*.R
RDS producidos     : 01_data/processed/inversion_publica_*.rds
variables panel    : G01 — `inv_*_usd_mm` (todos los sectores);
                     G02 — `inv_agro_*` (agropecuario completo)
caveats            : VIPFE registra inversión, no gasto corriente; agregado
                     completo del GAP requiere combinar VIPFE + BOOST + EMAPA +
                     municipal (ver METODOLOGIA §4.1)
```

### 1.3. INE — Instituto Nacional de Estadística

```text
proveedor          : INE Bolivia
cobertura          : variada — cuentas nacionales, IPC, empleo, EH, censo
                     agropecuario 2013
licencia           : pública
fecha de descarga  : various (cuentas nacionales 2026-Q1; encuestas hogares
                     según release INE; censo 2013 archivado)
path crudo         : 01_data/raw/ine_bolivia/
formato            : Excel / CSV / PDF
script de ingesta  : 02_code/01_ingest/ine_*.R
RDS producidos     : 01_data/processed/ine_*.rds + agricultural_outcomes.rds
variables panel    : G15 — `ine_cereal_prod_ton`, `ine_cereal_yield_kg_ha`;
                     G17 — componentes de `rural_pop_pct`, `agr_employment_pct`
                     (cuando INE complementa WDI/ILO);
                     contexto macro (G01) cuando complementa WDI
caveats            : EH es muestral, no censo; cobertura departamental requiere
                     factor de expansión documentado
```

### 1.4. MDRyT — Memorias y reportes de gestión

```text
proveedor          : Ministerio de Desarrollo Rural y Tierras
cobertura          : 2014, 2019, 2021, 2024 (con huecos 2015–2018, 2020,
                     2022–2023 — ver §5 fuentes bloqueadas)
licencia           : pública (vía Wayback Machine HTTP — sitio MDRyT bloquea
                     con Cloudflare; descargar vía http://web.archive.org/web/*)
fecha de descarga  : 2026-04
path crudo         : 01_data/raw/mdryt/
formato            : PDF
script de ingesta  : 02_code/02_clean/mdryt_extract_*.R (extracción tabular)
RDS producidos     : 01_data/processed/mdryt_*.rds (parcial)
variables panel    : insumo cualitativo + contexto institucional para F07;
                     no produce variables cuantitativas canónicas del panel
caveats            : cobertura discontinua; las memorias son producto político,
                     leer con criterio de fuente secundaria
```

### 1.5. INIAF — Memoria Institucional 2019

```text
proveedor          : Instituto Nacional de Innovación Agropecuaria y Forestal
cobertura          : ejecución 2019 (única memoria pública disponible)
licencia           : pública (vía Wayback)
fecha de descarga  : 2026-04
path crudo         : 01_data/raw/mdryt/INIAF_Memoria_2019.pdf
formato            : PDF
script de ingesta  : extracción manual hasta ahora; objetivo
                     02_code/02_clean/iniaf_*.R
RDS producidos     : pendiente (insumo cualitativo)
variables panel    : F07 contexto institucional; pendiente cuantificación
                     I+D / extensión cuando datos secundarios disponibles
caveats            : una sola memoria pública; el gap de cobertura INIAF
                     2009–2018 + 2020–2024 está en carta MEFP pendiente
```

### 1.6. Fundación Jubileo — Reportes de gasto subnacional

```text
proveedor          : Fundación Jubileo (Bolivia)
cobertura          : varios reportes con compilaciones de gasto departamental
                     y municipal (paralelo a SIIF)
licencia           : pública
fecha de descarga  : various
path crudo         : 01_data/raw/jubileo/
formato            : PDF + Excel
script de ingesta  : 02_code/02_clean/jubileo_*.R
RDS producidos     : 01_data/processed/jubileo_*.rds (parcial)
variables panel    : G05 — complemento de `mun_*` cuando SIIF tiene huecos
caveats            : contacto institucional: René Martínez (Jubileo);
                     compilaciones agregadas, no nivel transaccional
```

### 1.7. BCB — Banco Central de Bolivia

```text
proveedor          : BCB
cobertura          : cartera de crédito por sector económico 2010–2024;
                     comercio exterior 1990–2024
licencia           : pública
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/bcb/, 01_data/raw/bcb_boletin_estadistico/
formato            : Excel / CSV (boletines estadísticos)
script de ingesta  : 02_code/01_ingest/bcb_*.R
RDS producidos     : 01_data/processed/bcb_credito_*.rds (anual, trimestral)
variables panel    : G10 completo — `bcb_cred_*`
caveats            : cartera por sector tiene cambios metodológicos en 2014
                     (Ley 393); el panel documenta el cambio sin imputar
```

### 1.8. CIPCA — Evaluaciones de riego y microriego

```text
proveedor          : Centro de Investigación y Promoción del Campesinado (CIPCA)
cobertura          : evaluación riego/microriego 2012 (snapshot histórico)
licencia           : pública (CIPCA)
fecha de descarga  : 2026-04
path crudo         : 01_data/raw/secundarias/cipca/
formato            : PDF
script de ingesta  : insumo cualitativo, no scripteado
RDS producidos     : ninguno (referencia narrativa)
variables panel    : ninguna directa; contexto para F02 (brechas) y F04
                     (distribución territorial) en riego
caveats            : snapshot 2012; no se extrapola sin nueva fuente
```

### 1.9. PEFA Bolivia (Public Expenditure and Financial Accountability)

```text
proveedor          : PEFA Secretariat / Banco Mundial (evaluaciones país)
cobertura          : evaluaciones de marco fiscal 2009 + posibles posteriores
licencia           : pública
path crudo         : 01_data/raw/pefa/
RDS producidos     : ninguno (referencia narrativa)
variables panel    : ninguna; contexto institucional para F07
```

### 1.10. SIIF — Sistema Integrado de Información Financiera

```text
proveedor          : MEFP (SIIF subnacional)
cobertura          : ejecución municipal y departamental
licencia           : pública parcial; acceso transaccional restringido
path crudo         : 01_data/raw/siif/
estado             : parcial — completar requiere apoyo de Jubileo (§1.6)
                     o solicitud explícita a MEFP
variables panel    : G05 — `mun_*` (compilación cuando disponible)
caveats            : ver §5 fuentes con acceso bloqueado
```

---

## 2. Fuentes regionales LAC

### 2.1. IDB AgriMonitor — PSE/GSSE/TSE LAC

```text
proveedor          : Banco Interamericano de Desarrollo (BID)
cobertura          : PSE / GSSE / TSE / MPS / BT por país LAC, 1986–2024;
                     10 países cubiertos incluyendo Bolivia
licencia           : pública (BID)
fecha de descarga  : 2026-Q1; edición de febrero 2026 pendiente
path crudo         : 01_data/raw/idb_agrimonitor/
formato            : Excel / dashboard descargable
script de ingesta  : 02_code/01_ingest/idb_agrimonitor_*.R
RDS producidos     : 01_data/processed/pse_panel_*.rds + andinos_wdi_panel.rds
                     (cross-country)
variables panel    : G08 completo — todas las variables PSE/CSE/GSSE/TSE/MPS/BT;
                     cross-references a metodología OECD-PSE
caveats            : metodología OECD-PSE adaptada a LATAM por el BID;
                     supuestos clave (precios de referencia, tipo de cambio,
                     commodities cubiertos) ver METODOLOGIA §4.4
status crítico     : edición feb-2026 del módulo Bolivia pendiente; si trae
                     revisiones de serie histórica, dispara ROJO + ADR
```

### 2.2. FAOSTAT — FAO Statistics Division

```text
proveedor          : FAO
cobertura          : 1961–2025 (variable por dataset)
módulos usados     : PP (precios al productor), QCL (cultivos y livestock),
                     FBS (food balance sheets), TCL (trade), Emisiones
licencia           : CC-BY (FAOSTAT)
fecha de descarga  : various
path crudo         : 01_data/raw/faostat/, 01_data/raw/faostat_qcl/
formato            : CSV (bulk download)
script de ingesta  : 02_code/01_ingest/faostat_*.R
RDS producidos     : 01_data/processed/faostat_*.rds
variables panel    : G09 (precios productor `pp_*`); G15 (`fao_cereal_*`);
                     G17 (`agr_food_prod_index`, `all_meat_prod_ton`,
                     `undernourishment_pct`, `use_of_pesticides_*`)
caveats            : revisiones retroactivas de FAOSTAT son frecuentes;
                     el panel fija una fecha de descarga y no actualiza
                     sin ADR
```

### 2.3. WB Pink Sheet — Commodity Prices

```text
proveedor          : Banco Mundial (Pink Sheet)
cobertura          : precios mensuales y anuales 1960–2025 de commodities
                     internacionales
licencia           : pública
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/worldbank/
formato            : Excel mensual
script de ingesta  : 02_code/01_ingest/wb_pinksheet_*.R
RDS producidos     : 01_data/processed/precios_referencia_*.rds
variables panel    : insumo del MPS (G08) — precios de referencia
                     internacional para soya, maíz, trigo, arroz
caveats            : precios FOB en mercados de referencia (Chicago,
                     Rotterdam); ajuste de flete a frontera boliviana
                     documentado en METODOLOGIA §4.4
```

### 2.4. WDI — World Development Indicators

```text
proveedor          : Banco Mundial
cobertura          : indicadores macroeconómicos y de desarrollo 1960–2024
licencia           : pública
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/wdi/
formato            : CSV (bulk API o descarga)
script de ingesta  : 02_code/01_ingest/wdi_*.R
RDS producidos     : 01_data/processed/wdi_*.rds, andinos_wdi_panel.rds
variables panel    : G01 (macro); G16 completo (`wdi_*`); G17 (varias)
caveats            : revisiones anuales de WDI; el panel fija año de descarga
```

### 2.5. CEPALSTAT — CEPAL

```text
proveedor          : CEPAL
cobertura          : pobreza, empleo rural, indicadores sociales LAC
licencia           : pública
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/cepal/
formato            : CSV / dashboard
script de ingesta  : 02_code/01_ingest/cepal_*.R
variables panel    : complemento de G17 para benchmarks regionales (pobreza
                     rural, empleo rural)
caveats            : metodologías de pobreza CEPAL vs INE difieren; reporte
                     usa ambas con flag
```

### 2.6. IFPRI SPEED — Statistics on Public Expenditure for Economic Development

```text
proveedor          : IFPRI
cobertura          : gasto público en agricultura cross-country, ventana
                     amplia con cobertura n=18 para Bolivia
licencia           : pública (IFPRI)
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/ifpri_speed/
formato            : CSV
script de ingesta  : 02_code/01_ingest/speed_*.R
RDS producidos     : 01_data/processed/speed_*.rds
variables panel    : G07 completo — `speed_ag_*`
caveats            : SPEED puede no coincidir con VIPFE/BOOST locales por
                     diferencias metodológicas; el book reporta rango cuando
                     hay divergencia
```

### 2.7. USDA-ERS International Agricultural Productivity

```text
proveedor          : USDA Economic Research Service
cobertura          : TFP agropecuaria cross-country, 1961–2023
licencia           : pública (USDA)
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/usda_ers/
formato            : Excel / CSV
script de ingesta  : 02_code/01_ingest/usda_tfp_*.R
RDS producidos     : 01_data/processed/usda_tfp_*.rds
variables panel    : G14 completo — `tfp_*`
caveats            : TFP estimada con metodología Diewert-Morrison; comparable
                     internacionalmente pero no calibrada con datos primarios
                     bolivianos
```

### 2.8. OECD PSE Database — benchmarking

```text
proveedor          : OECD
cobertura          : PSE/CSE/TSE países OECD + emergentes seleccionados,
                     1986–2024
licencia           : pública (OECD)
fecha de descarga  : 2026-Q1 (snapshot reciente para benchmarks)
path crudo         : 01_data/raw/oecd_pse/
formato            : Excel
script de ingesta  : 02_code/01_ingest/oecd_pse_*.R
RDS producidos     : 01_data/processed/oecd_pse_benchmark_*.rds
variables panel    : ninguna directa (Bolivia no está en OECD-PSE);
                     usado para benchmarks comparativos en F03 y F06
```

### 2.9. IMF — Datos fiscales y macro

```text
proveedor          : IMF (WEO, GFS, IFS)
cobertura          : macro y fiscal cross-country
licencia           : pública
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/imf/
formato            : Excel / API
script de ingesta  : 02_code/01_ingest/imf_*.R
variables panel    : cross-check con WDI (G01, G16)
```

---

## 3. Fuentes geoespaciales

### 3.1. MapBiomas Bolivia — Colección 3

```text
proveedor          : MapBiomas Bolivia (red colaborativa)
cobertura          : cobertura del suelo 1985–2024 (anual), resolución 30m
licencia           : CC-BY
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/mapbiomas/
formato            : rasters GeoTIFF + estadísticas tabulares
script de ingesta  : 02_code/01_ingest/mapbiomas_*.R
RDS producidos     : 01_data/processed/mapbiomas_*.rds
variables panel    : G11 completo — `lc_*`, `mb_*`, `defor_nacional_ha`,
                     `gasto_usd_por_ha_antrop`
caveats            : Colección 3; la C4 puede aparecer durante el ciclo del
                     APER y dispararía ROJO + ADR
```

### 3.2. Hansen Global Forest Change v1.11

```text
proveedor          : Hansen et al., University of Maryland (vía Google Earth Engine)
cobertura          : pérdida forestal anual 2001–2023, resolución 30m
licencia           : pública (uso académico/no comercial)
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/hansen/
formato            : rasters GeoTIFF + estadísticas tabulares
script de ingesta  : 02_code/01_ingest/hansen_*.R
RDS producidos     : 01_data/processed/hansen_*.rds
variables panel    : G12 — `hansen_forest_2000_ha`, `hansen_defor_*`
caveats            : definición de "bosque" Hansen != MapBiomas; el book
                     reporta rango cuando hay divergencia con G11
```

### 3.3. CHIRPS — Precipitación

```text
proveedor          : Climate Hazards Group, UCSB
cobertura          : precipitación diaria global 1981–2024, resolución 5km
licencia           : pública
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/chirps/
formato            : netCDF
script de ingesta  : 02_code/01_ingest/chirps_*.R (agregación a anual nacional)
RDS producidos     : 01_data/processed/chirps_*.rds
variables panel    : G13 — `precip_nacional_mm`, `precip_interp_mm`,
                     `precip_fuente`
caveats            : versiones CHIRPS (v2 → futuras) pueden disparar bump
                     del panel
```

### 3.4. ESA WorldCover

```text
proveedor          : European Space Agency
cobertura          : cobertura global 10m, snapshots 2020 y 2021
licencia           : CC-BY 4.0
fecha de descarga  : 2026-Q1
path crudo         : 01_data/raw/esa_worldcover/
formato            : rasters GeoTIFF
script de ingesta  : 02_code/01_ingest/esa_worldcover_*.R
RDS producidos     : auxiliar (cross-check de cobertura MapBiomas)
variables panel    : ninguna directa; insumo de verificación
```

---

## 4. Literatura y manuales metodológicos

### 4.1. APER Bolivia 2011 (WB N° 59696-BO)

```text
documento          : Bolivia: Agricultural Public Expenditure Review (WB, 2011)
autoría            : World Bank
path               : 03_literature/APER_2011/
uso                : empalme histórico de la serie de gasto agropecuario
                     (variables G03 `aper_*`); referencia metodológica para
                     clasificación funcional histórica
```

### 4.2. Manual MAFAP Volumen II

```text
documento          : Methodology for monitoring food and agricultural policies
autoría            : Ghins, Ilicic-Komorowska, Mas Aparisi (FAO, 2013)
path               : 03_literature/Informacion_PER/manual MAFAP.pdf
uso                : guía metodológica para construcción del PSE adaptado;
                     complemento del OECD PSE Manual
```

### 4.3. PER Sub-Saharan Africa con MAFAP

```text
documento          : Public Expenditure Reviews in Sub-Saharan Africa applying MAFAP
autoría            : Pernechele et al. (FAO MAFAP, 2021)
path               : 03_literature/Informacion_PER/PER subsaharan using MAFAP.pdf
uso                : referencia operativa para integrar PSE en PER
```

### 4.4. PER Filipinas (WB AgPER)

```text
documento          : Philippines Agricultural Public Expenditure Review
autoría            : Weiss, Kar, Nash, Oliveros, Briones (WB, 2023)
path               : 03_literature/Informacion_PER/PER filipinas.pdf
uso                : modelo de PER reciente del WB; estructura del reporte;
                     ejemplos de tratamiento del repurposing
```

### 4.5. OECD PSE Manual

```text
documento          : OECD Producer Support Estimate Manual (última edición
                     consolidada)
estado             : descarga oficial pendiente — TODO §6
uso                : fuente canónica para definiciones PSE/CSE/GSSE/TSE;
                     METODOLOGIA §4.4–§4.5 cita esta fuente
```

### 4.6. Repurposing FAO + WB 2022

```text
documento          : Repurposing agricultural policies and support
autoría            : FAO + WB (2022)
estado             : localización pendiente — TODO §6
uso                : marco conceptual del repurposing; supuestos de retornos
                     comparativos de bienes públicos vs. transferencias
```

### 4.7. Simar-Wilson (1998, 2007)

```text
documento          : Sensitivity analysis of efficiency scores; statistical
                     inference in nonparametric frontier models
autoría            : Simar & Wilson
estado             : pendiente descarga de papers originales
uso                : metodología DEA con bootstrap; sustento técnico de
                     escenarios de eficiencia (cuando se incorpore)
```

### 4.8. Fichas de lectura del equipo

```text
path               : 03_literature/*/FICHA_LECTURA.md
autoría            : equipo APER (Juan Carlos Muñoz y otros)
uso                : sintesis y extracción de papers relevantes; vivas,
                     se actualizan con cada lectura
```

---

## 5. Fuentes con acceso bloqueado o parcial (gaps documentados)

| Fuente | Estado | Acción pendiente | Responsable |
|---|---|---|---|
| **MDRyT / INIAF / SENASAG** ejecución 2009–2024 | 🔴 Bloqueada | Carta MEFP en `00_admin/carta_solicitud_MEFP.md` (lista para enviar) | TTL + co-TTL |
| **Memorias MDRyT** 2015–2018, 2020, 2022–2023 | 🔴 Faltan 5 años | Wayback no las tiene; solicitud explícita al MDRyT vía carta MEFP | TTL |
| **BDP** cartera detallada por programa | 🟡 Solo snapshot Sept-2025 | Solicitud directa a BDP (contacto via MEFP) | co-TTL |
| **SIIF subnacional municipal** 2009–2023 | 🟡 Parcial | Contacto Jubileo (René Martínez); apoyo de Jubileo para compilación | co-TTL |
| **INIAF / SENASAG operativos** por departamento | 🔴 Sin acceso | Carta MEFP | TTL |
| **Sitio oficial MDRyT** | 🔴 Cloudflare bloquea | Usar Wayback Machine HTTP (no HTTPS) — workaround documentado en `00_admin/data_access_log.md` | n/a |
| **OECD PSE Manual** oficial | 🟡 Descarga pendiente | Descargar y archivar en `03_literature/OECD_PSE_Manual/` | equipo |
| **Repurposing FAO+WB 2022** | 🟡 Localización pendiente | Buscar versión definitiva y archivar | equipo |

**Política operativa.** Cifras que dependen de fuentes bloqueadas se marcan `[TODO_TRACE: ...]` en capítulos y `uncertainty: alta` en HALLAZGOS. Mientras los gaps persistan, los hallazgos correspondientes no pueden pasar a `MEFP_validated`; pueden quedar en `reviewed` con la incertidumbre declarada.

---

## 6. Refresh cadence (cuándo se actualiza cada fuente)

| Cadencia | Fuentes |
|---|---|
| Una vez por reporte (snapshot fijado por release) | BOOST, VIPFE, IDB AgriMonitor, MapBiomas, Hansen, USDA-ERS, OECD-PSE, WDI, FAOSTAT |
| Por descarga puntual con fecha registrada | INE EH, MDRyT memorias, BCB boletines, CIPCA, Jubileo |
| Continua durante el ciclo del reporte | CHIRPS (si se decide rebuild estacional), WB Pink Sheet (precios) |
| No refresca durante el ciclo | APER 2011, Manual MAFAP, OECD PSE Manual, papers metodológicos |

**Regla.** Cualquier refresh fuera de cadencia que cambie cifras publicadas dispara **ROJO + ADR** (CONTROL §4.3).

---

## 7. Vinculación fuente → variables del panel

Cross-reference rápida (detalle por variable en [INDICADORES.md](02_INDICADORES.md)):

| Fuente | Grupos del panel que produce |
|---|---|
| BOOST | G04 (12 vars) |
| VIPFE | G01 (6 vars de inv_*), G02 (5 vars) |
| INE | G01 (cuentas nacionales cuando complementa WDI), G15 (2 vars), G17 (parcial) |
| MDRyT / INIAF / SENASAG | F07 cualitativo; pendiente cuantificación |
| Fundación Jubileo / SIIF | G05 (11 vars municipal) |
| EMAPA informes | G06 (2 vars) |
| BCB | G10 (8 vars de cartera) |
| IFPRI SPEED | G07 (5 vars) |
| IDB AgriMonitor | G08 (43 vars de PSE/CSE/GSSE/TSE/MPS/BT + NAC/NPC + GHG) |
| FAOSTAT | G09 (precios productor + NRP — junto con cálculo propio), G15 (2 vars), G17 (4 vars) |
| WB Pink Sheet | precios de referencia para MPS (G08) |
| WDI | G01 (10 macro), G16 (15 vars) |
| USDA-ERS | G14 (4 vars TFP) |
| MapBiomas | G11 (14 vars uso del suelo) |
| Hansen GFC | G12 (3 vars deforestación) |
| CHIRPS | G13 (3 vars precipitación) |
| CEPALSTAT | benchmarks regionales (G17 ampliado) |
| OECD PSE | benchmark internacional (G08 referencias comparativas) |
| IMF | cross-check macro (G01, G16) |

---

## 8. Checksums y verificación de integridad

**Estado.** Pendiente para v1.0.

Para cada fuente inmutable archivada en `01_data/raw/`, se generará:

```text
01_data/raw/<fuente>/CHECKSUMS.md
  SHA-256 de cada archivo + fecha de descarga + URL de origen.
```

Esto permite verificar que el panel se reconstruye desde fuentes idénticas a las usadas en el release publicado. Script de generación: `scripts/audit_sources.sh` (a implementar).

---

## 9. Licencias y atribución

| Tipo de licencia | Fuentes |
|---|---|
| Pública sin restricciones | BOOST, VIPFE, INE, BCB, IDB AgriMonitor, WB Pink Sheet, WDI, IMF, CEPALSTAT, OECD-PSE |
| CC-BY (atribución requerida) | FAOSTAT, MapBiomas, ESA WorldCover |
| Pública con uso académico/no comercial | Hansen GFC, CHIRPS, USDA-ERS, IFPRI SPEED |
| Pública vía archivo (Wayback) | MDRyT, INIAF Memoria 2019 |
| Pública institucional | CIPCA, Fundación Jubileo, PEFA |
| Académica / editorial | Papers metodológicos (Simar-Wilson, etc.) |

**Atribución obligatoria.** En cada figura derivada de una fuente CC-BY, el caption incluye la cita estándar (e.g. "Fuente: MapBiomas Bolivia Col. 3 (CC-BY)").

**Restricciones.** Ninguna fuente del panel impide publicación del reporte como reporte WB; las restricciones son de **atribución**, no de **acceso a publicar derivados**.

---

## 10. TODOs para alcanzar v1.0

- [ ] Completar el inventario de 63 datasets del [Excel raíz](../00_admin/Inventario_Datos_APER_Bolivia_2026.xlsx) (faltan ~30 fuentes secundarias menores).
- [ ] Para cada fuente: URL canónica + checksums SHA-256 + script de ingesta verificado.
- [ ] Generar `01_data/raw/<fuente>/CHECKSUMS.md` para todas las fuentes inmutables.
- [ ] Descargar oficialmente el OECD PSE Manual y archivar en `03_literature/OECD_PSE_Manual/`.
- [ ] Localizar versión definitiva del documento FAO+WB Repurposing 2022 y archivar.
- [ ] Descargar papers Simar-Wilson originales.
- [ ] Activar refresh de IDB AgriMonitor cuando salga edición feb-2026.
- [ ] Convertir el inventario Excel a versión Markdown sincronizada con este archivo (script de export).
- [ ] Tabla inversa: para cada RDS en `01_data/processed/`, qué fuentes lo alimentan.

---

## 11. Cómo modificar este archivo

`FUENTES.md` es zona crítica ([CONTROL §3](08_CONTROL.md)).

| Tipo de cambio | Color | Requisitos |
|---|---|---|
| Agregar fuente nueva no usada todavía en el panel | AMARILLO | entrada documentada + nota |
| Incorporar fuente nueva al panel (genera variables) | ROJO | ADR + bump del panel + actualización de INDICADORES.md |
| Cambiar fecha de descarga de una fuente ya usada | ROJO | ADR si cambian cifras; AMARILLO si solo se actualiza la nota |
| Cambiar licencia / atribución declarada | ROJO | ADR si afecta publicación |
| Marcar fuente como bloqueada o disponible | AMARILLO | nota + actualizar ESTADO_DE_DATOS.md |
| Corrección de path o tipografía | VERDE | commit directo |

---

## 12. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Stub inicial: ~15 fuentes en 5 secciones |
| v0.2.0 | 2026-05-23 | Expansión a 30+ fuentes con ficha estructurada por fuente (proveedor, cobertura, licencia, fecha, path, ingesta, RDS, variables panel, caveats); vinculación fuente → grupos de variables del panel; cadencia de refresh; checksums previstos para v1.0 |
