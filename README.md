# Bolivia Agricultural Public Expenditure Review 2026

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![R version](https://img.shields.io/badge/R-%E2%89%A5%204.3-blue.svg)](https://www.r-project.org/)
[![Data](https://img.shields.io/badge/panel-1990--2024-green.svg)](./01_data/processed/spending_panel_v3.rds)
[![Reproducible](https://img.shields.io/badge/reproducible-yes-brightgreen.svg)](./CONTRIBUTING.md)
[![Anexo datos](https://img.shields.io/badge/docs-Anexo%20A-blue.svg)](./04_report/appendix/A_data_sources.qmd)

**Cliente:** World Bank – Bolivia Country Office
**Periodo de análisis:** 1961-2024 (nacional) / 1984-2024 (subnacional)
**Estado:** Pipeline de datos completo ✅ · Análisis en curso

## Quickstart

```bash
# 1. Clonar el repo
git clone https://github.com/jcmunozmora/bolivia-wb-aper-2026.git
cd bolivia-wb-aper-2026

# 2. Descargar datos raw (~400 MB, no incluidos en el repo)
bash scripts/00_download_raw.sh

# 3. Instalar paquetes R + re-ejecutar pipeline completo
Rscript scripts/01_run_all.R

# 4. (Opcional) Renderizar reporte
quarto render 04_report/
```

Tiempo total desde repo limpio: **~15 minutos** (10 min descarga + 5 min pipeline).

---

## Descripción

Análisis de gasto público agropecuario para Bolivia, siguiendo metodología
OCDE (PSE, PER) y mejores prácticas del Banco Mundial. Actualiza el
*Agricultural Public Expenditure Review* (WB, 2011) con datos 2009-2024.

**Preguntas centrales:**
1. ¿Cuánto gasta el Estado en agricultura y cómo se distribuye?
2. ¿Qué productos/regiones reciben apoyo efectivo vs. tasación implícita?
3. ¿Es eficiente el gasto (DEA departamental)?
4. ¿Impacta en productividad (TFP) y seguridad alimentaria?

---

## Documentación principal

📄 **[Anexo A — Inventario de Fuentes de Datos](04_report/appendix/A_data_sources.qmd)**

Documentación exhaustiva de todas las fuentes, archivos, scripts y figuras.
Incluye catálogo de datasets procesados, cobertura temporal, licencias,
y reproducibilidad.

📄 **[Estrategia SIIF](02_code/01_data_collection/10_siif_strategy.md)**

Plan de 4 tiers con 25+ rutas para obtener datos SIIF del MEFP.

📄 **[Carta formal MEFP (DS 28168)](00_admin/carta_solicitud_MEFP.md)**

Solicitud de acceso a información pública lista para enviar.

---

## Estructura del proyecto

```
00_admin/             Documentos administrativos (ToR, cartas, bitácora)
01_data/
├── raw/              Originales inmutables (~1.3 GB, 13 fuentes)
├── processed/        42 datasets limpios (.rds/.csv)
└── external/         Shapefiles, clasificadores, deflactores
02_code/              29 scripts R del pipeline
├── 00_setup/         Configuración y funciones base
├── 01_data_collection/   Descarga y parseo raw
├── 02_cleaning/      Integración y panel maestro
├── 03_analysis/      PSE, DEA, regresiones, food security
└── 04_visualization/ Tema WB ggplot2
03_literature/        Revisión PRISMA
04_report/            Quarto Book (6 capítulos + 2 anexos)
05_outputs/
├── figures/          17 figuras WB-theme (PNG 150 dpi)
└── tables/           Tablas resultados
```

---

## Panel maestro (archivo canónico)

**`01_data/processed/spending_panel_v3.rds`** — 35 años × 72 variables

| Grupo | Cobertura | Fuente |
|-------|-----------|--------|
| Inversión pública agropecuaria | 1990-2024 | MEFP Informe Fiscal 2024 (VIPFE) |
| PSE / MPS / GSSE / TSE (OCDE) | 2006-2023 | IDB Agrimonitor |
| EMAPA gasto individual | 2008-2024 | MEFP Cuadro 22 |
| APER detallado por categoría | 1996-2008 | WB APER 2011 |
| TFP + outputs + inputs | 1961-2023 | USDA ERS |
| Outcomes WDI | 2000-2023 | World Bank WDI |
| GHG agrícolas | 2019-2023 | IDB Agrimonitor |
| Deflactores CPI 2015 | 2000-2023 | Derivado de WDI |

---

## Fuentes de datos (resumen)

### ✅ Descargado y procesado

| Fuente | Cobertura | Tipo | Script |
|--------|-----------|------|--------|
| **IDB Agrimonitor** ⭐ | 2006-2023 PSE 16 commodities | CSV 91 MB | `15_process_idb_agrimonitor.R` |
| **USDA ERS TFP** | 1961-2023 Bolivia + LAC | CSV 17 MB | `09_process_usda_tfp.R` |
| **WB APER 2011** | 1996-2008 granular | Excel 26 MB | `08_process_aper.R` |
| **MEFP Informe Fiscal 2024** | 1990-2024 inversión sectorial | PDF 2.6 MB | `14_parse_inversion_publica_sectorial.R` |
| **MEFP Boletín ETA 2022** | 2005-2022 deuda rural | PDF 4.4 MB | `12_parse_mefp_boletin.R` |
| **Jubileo Municipal** ⭐ | 2012-2021 gasto municipal 31 programas | HTML | `16_scrape_jubileo_municipal.R` |
| **WDI Bulk** | 2000-2023 22 indicadores | CSV 280 MB | `process_wdi.R` |
| **Our World in Data (FAOSTAT)** | 1961-2023 outcomes | CSV | `02_download_faostat.R` |
| **geoBoundaries** | ADM1 + ADM2 | GeoPackage | `07_download_spatial.R` |

### 🟡 Descargado pero sin procesar

| Dato | Archivo raw | Acción pendiente |
|------|-------------|------------------|
| INE ENA 2015 microdatos | `Encuesta_Agropecuaria_2015.zip` (19.5 MB) | Extraer SPSS .sav, estructurar |
| INE ENA 2008 microdatos | `Encuesta_Nacional_Agropecuaria_2008.zip` (5.2 MB) | Extraer SPSS .sav |
| INE Estadísticas Agrícolas | 3 Excel (producción, rendimiento, superficie × 9 depts, 1984-2024) | Parsear a panel largo |
| INE PIB Departamental | 30 Excel files 2017-2021 | Completar extracción |

### ⏳ Pendiente de obtener

| Dato | Fuente | Acción | Carta/script listo |
|------|--------|--------|:------------------:|
| Gasto detallado por entidad 2009-2023 | MEFP SIGEP | Solicitud formal DS 28168 | ✅ |
| Jubileo datos por depto/municipio | Fundación Jubileo | Email colaboración | ✅ |
| Precios productor pre-2006 | FAOSTAT PP | Crear cuenta + download | — |
| PIB dept 1988-2016 | INE Ref 2001 | Localizar archivo | — |
| OECD PSE comparadores oficial | API OECD | Reintentar | — |

> Ver [ESTADO_DE_DATOS.md](00_admin/ESTADO_DE_DATOS.md) para el snapshot completo
> con variables por grupo, cobertura real, y plan semanal de acciones.

---

## Hallazgos centrales (por si ya se revisan)

1. **Inversión 10× vs TFP estancada** — la inversión pública agropecuaria pasó de USD 84 M (2010) a USD 320 M (2015), pero la TFP se mantuvo en ~95-100 → problema de eficiencia del gasto.

2. **Bolivia es el país más volátil de LAC en política de apoyo** — %PSE osciló entre -27% (2009) y +7% (2016), comparado con México (estable +10-20%) o Chile (estable +3-10%).

3. **Patrón dual de protección (2023)**:
   - Protegidos: papa (+83%), azúcar (+23%), leche (+22%), cerdo (+17%)
   - Tasados: huevos (-53%), arroz (-34%), pollo (-34%), maíz (-33%), sorgo (-25%)
   - Consistente con "soberanía alimentaria" (proteger autoconsumo, tasar exportables)

4. **GSSE creció 8×** — gasto en servicios generales (R&D, infraestructura, sanidad) pasó de 251 mm BOB (2006) a 2,015 mm BOB (2023) → expansión sostenida de bienes públicos agrícolas.

5. **Colapso productividad 2020** — inversión cayó 46% (USD 247→134 mm) por COVID-19; recuperación gradual.

---

## Reproducibilidad rápida

```bash
# Setup
Rscript 02_code/00_setup/00_packages.R

# Descargar + procesar (datos manuales requeridos — ver Anexo A)
Rscript 02_code/01_data_collection/07_download_spatial.R
Rscript 02_code/01_data_collection/08_process_aper.R
Rscript 02_code/01_data_collection/09_process_usda_tfp.R
Rscript 02_code/01_data_collection/12_parse_mefp_boletin.R
Rscript 02_code/01_data_collection/14_parse_inversion_publica_sectorial.R
Rscript 02_code/01_data_collection/15_process_idb_agrimonitor.R

# Integrar panel maestro
Rscript 02_code/02_cleaning/08_integrate_pse.R

# Analizar y visualizar
Rscript 02_code/03_analysis/01_descriptive_spending.R

# Renderizar reporte
quarto render 04_report/
```

**Ver documentación completa del pipeline en [Anexo A](04_report/appendix/A_data_sources.qmd)**.

---

## Metodología

| Método | Capítulo | Implementación |
|--------|----------|----------------|
| **PSE** (Producer Support Estimate) | Cap. 4 | IDB Agrimonitor pre-calculado (OECD 2020) |
| **PER** (Public Expenditure Review) | Cap. 3-4 | Análisis de nivel, composición, eficiencia |
| **DEA** + Bootstrap Simar-Wilson | Cap. 4 | 9 depts × 2006-2023 (B=2000) |
| **Panel FE** (fixest) | Cap. 5 | TFP como outcome + PSE/GSSE/inversión |
| **Food Security Index** | Cap. 2 | PCA 4 dimensiones FAO |
| **Benchmark LAC** | Cap. 2 | USDA TFP + IDB PSE, 8 países |

---

## Convenciones del proyecto

- **Año base deflactores:** 2015 (BOB constantes 2015)
- **Moneda:** BOB (bolivianos) y USD paralelos
- **Tema visual:** World Bank (`#009FDA` azul, `#002244` navy)
- **Idioma reporte:** Español
- **Sistema código:** R + Quarto Book (no Python)

---

## Contactos

| Rol | Persona |
|-----|---------|
| Investigador principal | Juan Carlos Muñoz Mora (jcmunozmora@gmail.com) |
| Institución | Universidad EAFIT, Medellín |
| Cliente | WB Bolivia Country Office |

---

*Última actualización: 2026-04-21*
