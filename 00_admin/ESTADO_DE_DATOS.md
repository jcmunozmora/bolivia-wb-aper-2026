# Estado de datos del proyecto — snapshot trabajo futuro

**Última actualización:** 2026-04-22
**Panel nacional:** `01_data/processed/spending_panel_v4.rds` (35 años × 83 variables)
**Panel subnacional v2:** `01_data/processed/subnacional_panel_v2.rds` (90 × 36 vars)
**Panel municipal:** `01_data/processed/municipal_panel.rds` (3,368 × 23 vars) ⭐
**DEA-ready:** `01_data/processed/dea_dataset.rds` (81 DMUs × 32 vars)
**Repo:** https://github.com/jcmunozmora/bolivia-wb-aper-2026

> **🚀 TRIPLE BREAKTHROUGH 2026-04-21/22**:
> 1. `depa[]=N` → filtro departamental (9 depts × 31 programas × 10 años)
> 2. `get_mun=RELID` single value → filtro municipal (340 munis × 31 × 10 = 73,983 obs)
> 3. `get_pro=N` single value → filtro programa
> Combinados descubiertos leyendo función JS `array_var()` del portal.

> Este documento consolida el estado real de los datos para no repetir trabajo
> y saber exactamente qué falta. Se actualiza con cada integración.

---

## 1. Panel maestro v4 — completitud por grupo

### ✅ Cobertura completa (≥90%)

| Grupo | Variables | Cobertura | Fuente |
|-------|:---------:|:---------:|--------|
| Inversión VIPFE sectorial | 11 | 35/35 años (1990-2024) | MEFP Informe Fiscal 2024 |
| USDA TFP | 4 | 34/35 años (1990-2023) | USDA ERS |

### 🟡 Cobertura media (50-90%)

| Grupo | Variables | Cobertura | Período |
|-------|:---------:|:---------:|:-------:|
| WDI outcomes | 6 | 23-24/35 años | 2000-2023 |
| Macro/Deflactores | 6 | 24/35 años | 2000-2023 |
| EMAPA individual | 2 | 24-25/35 años | 2000-2024 |
| PSE OCDE (IDB Agrimonitor) | 24 | 18/35 años | 2006-2023 |

### 🔴 Cobertura limitada (<50%)

| Grupo | Variables | Cobertura | Período |
|-------|:---------:|:---------:|:-------:|
| APER legado | 10 | 9/35 años | 2000-2008 |
| **Jubileo Municipal nacional** | 11 | 10/35 años | 2012-2021 |
| GHG emisiones | 1 | 5/35 años | 2019-2023 |

---

## 1.B Panel SUBNACIONAL (nuevo 2026-04-21) ⭐

**Archivo:** `01_data/processed/subnacional_panel.rds` — 90 filas × 25 variables

| Variable | Cobertura | Fuente |
|----------|:---------:|--------|
| P10 Agropecuario por depto | 90/90 (9 depts × 10 años) | Jubileo scraping dept |
| Agro estricto (10+12+32) | 90/90 | Jubileo scraping dept |
| Rural infra (14-19) | 90/90 | Jubileo scraping dept |
| Rural total (10 programas) | 90/90 | Jubileo scraping dept |
| PIB agropecuario BOB 2017 | 45/90 | INE Ref 2017 (2017-2021) |
| Deuda rural stock | 90/90 | MEFP ETA 2022 |

**Archivo DEA-ready:** `01_data/processed/dea_dataset.rds` — 81 DMUs × 32 vars

- 9 departamentos × 9 años (2012-2020)
- **INPUTS**: gasto agrop real, superficie total, deuda rural stock (3 inputs completos 81/81)
- **OUTPUTS**: producción total ton, rendimiento cereales, PIB agrop (2 outputs completos + 1 parcial)
- Listo para `rDEA::dea.robust()` + Simar-Wilson bootstrap

---

## 1.C INE Estadísticas Agrícolas 1984-2020 (nuevo 2026-04-21) ⭐

**Archivo:** `01_data/processed/ine_agro_stats_long.rds` — 64,688 filas

| Dimensión | Cobertura |
|-----------|-----------|
| Departamentos | 10 (9 + Bolivia total) |
| Cultivos únicos | 80 |
| Años | 1984-2020 (41 años) |
| Indicadores | Producción (ton), Rendimiento (kg/ha), Superficie (ha) |

**Cultivos clave disponibles:** Soya, Papa, Maíz, Arroz, Quinua, Trigo, Caña de azúcar, Frijol, Cebada, Avena, Sorgo y 69 más.

---

## 1.D Panel MUNICIPAL 340 × 10 años (nuevo 2026-04-22) ⭐⭐⭐

**Archivo:** `01_data/processed/municipal_panel.rds` — 3,368 filas × 23 vars

| Dimensión | Cobertura |
|-----------|-----------|
| Municipios | 340 (incluye GAIOC + GAR) |
| Años | 2012-2021 (10 años) |
| Programas | 31 (agro + rural + resto) |
| Observaciones raw | 73,983 en `jubileo_municipal_full_2012_2021.rds` |

**Variables principales (BOB corrientes y 2015):**
- `p10_agropecuario`, `p12_microriegos`, `p18_caminos_vecinales`, `p32_recursos_hidricos`
- `agro_strict` (10+12+32), `rural_infra` (14-19), `rural_total` (10 progs rurales)
- `total_presupuesto`, `agro_share_pct`, `p10_share_pct`

**Top 2020:** La Paz ciudad (82.4 MM), Yacuiba/Tarija (18.7), Caraparí (10.6), Villamontes (9.7)

---

## 1.E ENA 2015 microdatos (nuevo 2026-04-22) ⭐

**Archivos:** `01_data/processed/ena_2015_{hogar,agricola,pecuaria}.rds`

| Módulo | Filas | Uso |
|--------|------:|-----|
| Hogar (3 partes) | 77,709 | UPAs base (12,650 unique), demografía rural |
| Agrícola | 54,242 | Producción por cultivo × UPA × semestre (140 vars) |
| Pecuaria (8 tipos) | 1,268,730 | Ganado bovino, ovino, caprino, porcino, llamas, alpacas, aves |

**Agregados por depto 2015 disponibles**: UPAs, superficie, producción expandida, % riego.

---

## 1.F PIB Departamental completo (nuevo 2026-04-22) ⭐

**Archivo:** `01_data/processed/pib_departamental_complete.rds` — 910 filas

| Dimensión | Cobertura |
|-----------|-----------|
| Departamentos | 9 (+ Bolivia total) |
| Años | 2017-2021 (5 años) |
| Actividades económicas | 18 (Agricultura, Hidrocarburos, Manufactura, etc.) |
| Series | Corrientes BOB mm + Constantes base 2017 encadenadas |

**PIB Agropecuario corriente 2020 (MM BOB):**
- Santa Cruz: 11,472 (dominante)
- Cochabamba: 5,477 · La Paz: 3,941
- Beni: 1,499 · Chuquisaca: 1,248 · Tarija: 1,161
- Potosí: 979 · Pando: 807 · Oruro: 492

---

## 1.G Shapefile ADM3 (nuevo 2026-04-22) ⭐

**Archivo:** `01_data/external/bolivia_adm3_municipalities.gpkg`

- 339 municipios (nivel correcto para análisis municipal)
- Fuente: geoBoundaries CC BY 4.0
- Match con Jubileo por nombre: 255/339 (75.2%)
- Los no-matched son por variaciones de nomenclatura ("San Javier" vs "San Javier del Beni")

---

## 2. Datasets subnacionales disponibles

### ✅ Procesados y listos

| Archivo | Contenido | Dimensiones | Período |
|---------|-----------|:-----------:|:-------:|
| `aper_dept_panel.rds` | APER por depto | 438 × 8 | 1996-2008 |
| `aper_agro.rds` | APER detallado (27,512 obs) | 27,512 × N | 1996-2008 |
| `pib_departamental_agro.rds` | PIB agrop × 9 depts | 50 × 5 | 2017-2021 |
| `mefp_deuda_destino_long.rds` | Deuda rural × 9 depts × 8 destinos | 846 × 4 | 2005-2022 |
| `jubileo_municipal_nacional_2012_2021.rds` | Gasto municipal nacional × 31 programas | 310 × 9 | 2012-2021 |

### ⚠️ Descargados SIN procesar (pendiente)

| Archivo raw | Contenido potencial | Tamaño |
|-------------|--------------------|:------:|
| `Encuesta_Agropecuaria_2015.zip` | Microdatos ENA 2015 (SPSS .sav, 9 files) | 19.5 MB |
| `Encuesta_Nacional_Agropecuaria_2008.zip` | Microdatos ENA 2008 | 5.2 MB |
| `agro_stats/agro_produccion_depto.xlsx` | Producción por cultivo × depto 1984-2024 | 395 KB |
| `agro_stats/agro_rendimiento_depto.xlsx` | Rendimiento kg/ha × depto 1984-2024 | 306 KB |
| `agro_stats/agro_superficie_depto.xlsx` | Superficie cultivada × depto 1984-2024 | 853 KB |
| `pib_dept/` | 30 Excel files PIB por depto 2017-2021 | ~3 MB |

---

## 3. Datos que NOS FALTAN (por prioridad)

### ✅ RESUELTO 2026-04-21 (ya no falta)

**✓ Panel subnacional de gasto agropecuario 2012-2021 (ERA TIER 1)**
- Resuelto vía scraping Jubileo con filtro correcto `depa[]=N`
- 9 depts × 31 programas × 10 años = 2,780 observaciones en
  `subnacional_panel.rds` + `dea_dataset.rds`
- ✅ DEA + Simar-Wilson ya es posible

**✓ Outputs agrícolas subnacionales 1984-2020 (nuevo)**
- INE Estadísticas Agrícolas procesadas (64,688 filas)
- Producción, rendimiento, superficie × 10 depts × 80 cultivos × 37 años

### 🔴 TIER 1 — Sigue bloqueando

**1.1 Gasto agropecuario detallado por institución 2009-2023**
- ❌ MDRyT, INIAF, SENASAG, INRA, FDI, BDP individuales
- ✅ Solo tenemos: EMAPA individual + VIPFE agregado sectorial + Jubileo por programa municipal
- **Impacto**: No podemos descomponer el gasto post-2008 por institución nacional
- **Vía de obtención**:
  - Carta formal DS 28168 al MEFP ([`00_admin/carta_solicitud_MEFP.md`](00_admin/carta_solicitud_MEFP.md))
  - WB Bolivia Country Office (Svetlana Edmeades / Camille Nuamah)

**1.2 Datos MUNICIPIO × programa (no solo depto)**
- ❌ Filtro `mun[]` NO funciona server-side en portal Jubileo
- ✅ Tenemos catálogo completo de 339 municipios (via `ajax_municipios.php`)
- **Vía**: Browser automation con Playwright/Selenium (2-3 días de trabajo)
- **Impacto**: DEA municipal en lugar de solo departamental

### 🟡 TIER 2 — Enriquecimiento sustancial

**2.1 Datos Jubileo subnacional 2012-2021** (la clave más inmediata)
- ❌ Portal pre.jubileobolivia.org.bo ignora filtros POST server-side
- ✅ Tenemos el agregado nacional; falta desglose por dept/muni
- **Vías**:
  a) **Enviar carta a Jubileo** ([`00_admin/carta_solicitud_Jubileo.md`](00_admin/carta_solicitud_Jubileo.md)) — pedir dataset subyacente
  b) **Browser automation** (Selenium/Playwright) para simular clicks en filtros
  c) **Contacto directo con René Martínez** (experto Open Budget Survey)

**2.2 Microdatos ENA 2008 y 2015**
- ❌ ZIPs descargados pero no procesados (25 MB total)
- ✅ Listos para extracción (formato SPSS .sav)
- **Script pendiente**: `02_code/01_data_collection/17_process_ena_microdata.R`

**2.3 Estadísticas agrícolas INE 1984-2024**
- ❌ Excel descargados pero no estructurados en panel
- ✅ Cubren 41 años × 9 depts × cultivos (producción, rendimiento, superficie)
- **Script pendiente**: `02_code/01_data_collection/18_process_ine_agro_stats.R`

**2.4 PIB departamental 2017-2021 completo**
- 🟡 Parcialmente procesado (tenemos 50 × 5 rows); 30 Excel files sin todos extraídos
- **Acción**: Extender parser para usar los 30 archivos D.X.Y.Z

**2.5 Precios productor commodity pre-2006**
- ❌ IDB Agrimonitor arranca 2006
- **Vía**: FAOSTAT PP dataset (cuenta gratuita en data.apps.fao.org)

**2.6 OECD PSE oficial comparadores LAC**
- ❌ API OECD cayó en intento inicial
- ✅ Tenemos proxy via IDB Agrimonitor para LAC (que basa su metodología en OCDE)
- **Prioridad baja** — el IDB ya nos da comparadores válidos

### 🟢 TIER 3 — Complementos marginales

**3.1 Memorias institucionales MDRyT 2015-2024**
- ❌ No descargadas
- **Valor**: narrativa cualitativa sobre programas específicos (Bolivia Cambia, MIAGUA, Mi Riego, MINKA)
- **Descarga**: `ruralytierras.gob.bo`

**3.2 Datos climáticos y agroecológicos por depto**
- ❌ Ninguno procesado
- **Fuentes**: SENAMHI Bolivia, CHIRPS, FAO AQUASTAT
- **Uso**: variables de control en regresiones panel (shocks climáticos)

**3.3 Censo Agropecuario 2013 — microdatos completos**
- ✅ Tenemos PDF del informe en `01_data/raw/mefp/`
- ❌ Sin microdatos procesados
- **Descarga**: `anda.ine.gob.bo` (requiere registro gratuito)

---

## 4. Comparación por capítulo del reporte (actualizado post-breakthrough)

| Capítulo | Datos suficientes | Análisis viable hoy |
|:--------:|:-----------------:|---------------------|
| **2** — Desempeño del sector | ✅ Completo | Todo: TFP, outcomes, PIB agrop, benchmark LAC |
| **3** — Gasto público | 🟡 Parcial | Nacional 1990-2024 ✓ · Subnacional 2012-2021 ✓ · Desagregación institucional post-2008 ❌ |
| **4** — Análisis PSE | ✅ Completo | Todo: PSE/MPS/GSSE/TSE 2006-2023 + LAC |
| **4b** — DEA eficiencia | ✅ **DESBLOQUEADO** | 81 DMUs (9 depts × 9 años) con 3 inputs + 2 outputs completos |
| **4c** — Regresiones panel | ✅ **DESBLOQUEADO** | TFP/PIB agrop ~ gasto × depto × año, FE posible |
| **4d** — Equidad/incidencia | 🔴 Bloqueado | Falta Encuesta Hogares procesada |
| **5** — Recomendaciones | ✅ Completo | Se arma al final con hallazgos |

---

## 5. Acciones priorizadas — próxima semana

| # | Acción | Tiempo | Impacto | Estado |
|:-:|--------|:------:|:-------:|:------:|
| 1 | **Enviar carta a MEFP (DS 28168)** | 1 día | 🔴 Alto | Lista |
| 2 | **Enviar carta a Jubileo** | 1 día | 🔴 Alto | Lista |
| 3 | Procesar ENA 2015 microdatos (SPSS) | 2-3 días | 🟡 Medio | Pendiente |
| 4 | Estructurar INE Estadísticas Agrícolas 1984-2024 | 1 día | 🟡 Medio | Pendiente |
| 5 | Completar extracción PIB departamental (30 files) | 1 día | 🟡 Medio | Pendiente |
| 6 | Implementar scraper Selenium (backup Jubileo) | 2-3 días | 🟢 Bajo si 1-2 responden | Pendiente |
| 7 | FAOSTAT cuenta + precios pre-2006 | 0.5 día | 🟢 Bajo | Pendiente |

---

## 6. Scripts y datasets resultantes

### Código disponible (30 scripts R)

```
02_code/00_setup/              (3 scripts)
  00_packages.R  01_constants.R  02_functions.R

02_code/01_data_collection/    (16 scripts + 2 md)
  01-06: APIs originales (WDI, FAOSTAT, OECD, CEPAL, BOOST)
  07_download_spatial.R        geoBoundaries ADM1+ADM2
  08_process_aper.R            APER 1996-2008 → panels
  09_process_usda_tfp.R        USDA TFP 1961-2023
  10_siif_strategy.md          Estrategia MEFP (4 tiers)
  10_siif_request_letter.md    Plantilla DS 28168
  11_download_alternatives.R   IFPRI, Agrimonitor URLs
  12_parse_mefp_boletin.R      Boletín ETA 2022
  13_parse_informe_fiscal_2024.R  882 series MEFP
  14_parse_inversion_publica_sectorial.R  VIPFE 26a+26b
  15_process_idb_agrimonitor.R    IDB PSE completo
  16_scrape_jubileo_municipal.R   Jubileo portal (Plan B)

02_code/02_cleaning/           (7 scripts)
  05_deflate_aggregate.R       CPI base 2015
  06_build_panel.R             Panel v1
  07_integrate_siif_proxies.R  Panel v2
  08_integrate_pse.R           Panel v3
  09_integrate_jubileo.R       Panel v4 (CANÓNICO)

02_code/03_analysis/           (6 scripts — templates)
02_code/04_visualization/      (1 script — WB theme)
```

### Datasets procesados (44 archivos en 01_data/processed/)

- **`spending_panel_v4.rds`** — PANEL MAESTRO (35 × 83)
- **Por fuente**: 7 datasets IDB Agrimonitor, 4 USDA TFP, 4 APER, 2 PIB dept, Jubileo, MEFP boletines
- **Histórico integración**: spending_panel_v{1,2,3,4}.rds (auditoría)

### Figuras generadas (20 PNG en 05_outputs/figures/)

- Cap. 2: fig01-09, 12 (desempeño + TFP)
- Cap. 3: fig02, 03, 10, 11 (gasto)
- Cap. 4: fig13-17 (PSE/política)
- Comparaciones: fig18-20 (Jubileo vs VIPFE)

---

## 7. Preguntas abiertas metodológicas

1. **¿Cómo tratar la diferencia APER vs VIPFE vs Jubileo?**
   - APER: gasto estricto UDAPE-FAM 101-110 (1996-2008)
   - VIPFE: inversión funcional sectorial agropecuaria (1990-2024)
   - Jubileo: gasto municipal por programa (2012-2021)
   - Propuesta: usar VIPFE como línea principal, APER para detalle histórico, Jubileo para componente municipal

2. **¿IDB Agrimonitor PSE es equivalente a cálculo OCDE desde cero?**
   - Metodología oficial OCDE aplicada por IDB con supervisión técnica
   - Validado en publicaciones peer-reviewed
   - Propuesta: aceptar PSE IDB como output oficial, documentar como tal

3. **¿Cómo manejar el cambio de base de PIB INE 2001 → 2017?**
   - Ref 2001: 1988-2016 (pendiente localizar)
   - Ref 2017: 2017-2021 (tenemos)
   - Propuesta: usar serie USD WDI para continuidad; INE Ref 2017 solo para el corte reciente

---

## 8. Compromiso de próxima actualización

Actualizar este documento cada vez que:
- Se integre una nueva fuente al panel maestro
- Se reciba respuesta del MEFP o Jubileo
- Se procese un dataset raw pendiente
- Se genere una nueva versión del panel (v5, v6, ...)

**Responsable de mantenimiento:** Juan Carlos Muñoz Mora (`jcmunozmora@gmail.com`)
