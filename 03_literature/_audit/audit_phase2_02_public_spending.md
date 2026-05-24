# Auditoría Fase 2 — `02_public_spending/`

**Fecha:** 2026-05-23
**Auditor:** Claude Code (Opus 4.7)
**Método:** Lectura de fichas + extracción de PDFs con `pdftotext` + verificación campo por campo
**Cobertura:** 8 fichas con `pdf_downloaded: true` (de 20 disponibles); muestra estratégica priorizando fichas críticas para el APER (citadas en evidence_map y reporte técnico)

---

## Resumen ejecutivo

- **Fichas auditadas:** 8
- ✅ **Todo confirmado:** 2 (`ASTI_Bolivia2016`, `WB2021_TappingPotential`)
- 🟡 **Parcial / inconsistencias menores:** 2 (`GoyalNash2017`, `WB_BoliviaCPF2023`)
- 🔴 **Alucinaciones críticas / metadatos incorrectos:** 4 (`AllcottLedermanLopez2006`, `Anriquez2016`, `ASTI_Bolivia2023`, `Pernechele2021`)
- **Tasa de alucinación crítica:** 50% de la muestra

**Patrón dominante:** problemas más severos que en `01_systematic_reviews`. Tres fichas describen **un paper distinto al que efectivamente está descargado en el PDF** (la "Anriquez2016" tiene en disco un paper de López 2004; la "Pernechele2021" tiene en disco un paper de Pernechele, Balié & Ghins 2018; la "ASTI_Bolivia2023" tiene autoría incorrecta). Además, la "AllcottLedermanLopez2006" describe el alcance como "Global, 70 países" cuando el paper es estrictamente sobre América Latina. Las "citas verbatim" del §8 son ampliamente paráfrasis con comillas en estas fichas.

---

## Detalle por ficha

### `AllcottLedermanLopez2006` — 🔴 Alcance geográfico inventado + citas inventadas

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Political Institutions, Inequality, and Agricultural Growth: The Public Expenditure Connection" | Idem (WPS3902) | ✅ |
| authors | Allcott, Lederman, López | Confirmados | ✅ |
| year | 2006 | World Bank Policy Research Working Paper 3902, April 2006 | ✅ |
| **geographic_scope: "Global"** + "~70 países en desarrollo y desarrollados" (§5) | — | **PDF abstract dice "panel of Latin American economies"** (NO global, solo LAC) | 🔴 |
| N "~600 observaciones" | §5 | No verificable directamente (consistente con panel LAC×años) | 🟡 |
| Hallazgo "10 puntos Gini = +3pp subsidios privados" (§6) | — | No verificable verbatim | 🟡 |
| Cita §8.1 "Public expenditures that yield returns primarily benefiting agricultural firms..." (Abstract) | — | **NO está en el abstract del PDF** | 🔴 |
| Cita §8.2 "Countries with more egalitarian political institutions..." (Conclusiones) | — | **NO localizada en el PDF** | 🔴 |

**Notas:** el frontmatter y la tesis general (composición del gasto = bienes públicos vs privados; mediada por instituciones e inequidad) están bien. Pero el ALCANCE GEOGRÁFICO está incorrecto — el paper es sobre LAC, no global. Ambas citas verbatim son invenciones del LLM.

---

### `Anriquez2016` — 🔴 PDF DESCARGADO ES OTRO PAPER (López 2004 RUR-04-01)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Public Expenditures and the Performance of LAC Agriculture" (Anríquez et al. 2016) | **"Effect of the Structure of Rural Public Expenditures on Agricultural Growth and Rural Poverty in Latin America"** (López, R., 2004, IDB document RUR-04-01) | 🔴 |
| authors | Anríquez, Foster, Ortega, Falconi, De Salvo | **"Ramón López"** | 🔴 |
| year | 2016 | **December 2004** | 🔴 |
| source | IDB Working Paper IDB-WP-722 | **IDB Rural Development Unit RUR-04-01** | 🔴 |
| doi 10.18235/0000371 | — | No verificable en este PDF | 🔴 |
| §6, §7, §8 (numéricos atribuidos a Anríquez 2016) | — | El PDF disponible no contiene esos hallazgos | 🔴 |
| Nota auto-confesa al inicio de §1 | "Existe también la publicación complementaria..." | — | 🟡 (el ficha-creador detectó la inconsistencia pero no la corrigió) |

**Notas:** **La ficha entera describe un paper distinto al que está en el PDF.** El agente parece haberlo notado en §1 ("Existe también la publicación complementaria... que utiliza datos sobrepuestos") pero procedió a redactar como si el PDF fuese el Anríquez 2016. **Acción urgente.**

---

### `ASTI_Bolivia2016` — ✅ Excelente

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Bolivia: ASTI–INIAF Country Factsheet (2016)" | Confirmado | ✅ |
| authors | Stads, Perez, Marza, Beintema | Confirmado en encabezado | ✅ |
| year, source | 2016 (abril), IFPRI/ASTI/INIAF | Confirmado | ✅ |
| Estancamiento real 2009-2013 (§6) | — | Verbatim: "Bolivia's agricultural research spending levels to remain stagnant in inflation-adjusted terms during 2009-2013" | ✅ |
| 11% PhDs (§6) | — | Verbatim: "At only 11 percent, Bolivia's share of PhD-qualified agricultural researchers" | ✅ |
| Crecimiento INIAF + caída de otros (§6) | — | Verbatim: "Large spending increases at INIAF coupled with considerable decreases at most other agricultural R&D agencies" | ✅ |
| Cita §8.1 "Bolivia's agricultural research spending levels have remained stagnant..." (p. 1) | — | Confirmado verbatim | ✅ |
| Cita §8.2 "Large spending increases at INIAF coupled with considerable decreases..." (p. 2) | — | Confirmado verbatim | ✅ |

**Notas:** ficha ejemplar. Solo nota menor: la cita §8.2 ("p. 2") corresponde realmente a la primera página del factsheet (este documento tiene 4 páginas y el texto está en la portada/p. 1).

---

### `ASTI_Bolivia2023` — 🔴 Autoría incorrecta + período mal indicado

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Agricultural R&D Indicators Factsheet: Bolivia" | Confirmado | ✅ |
| **authors** | "Stads, Gert-Jan & ASTI Team (IFPRI)" | **"Gert-Jan Stads and Luis de los Santos"** | 🔴 |
| year | 2023 (March) | March 2023 | ✅ |
| **period_covered** | 2010-2021 | **PDF muestra principalmente 2015-2020** | 🔴 |
| Intensity ratio §6: "por debajo del 1%" | — | Verbatim: "halved from 1.0 to 0.5 percent during 2015–2020" | ✅ (más preciso en PDF) |
| 11% PhDs en versión 2023 | — | PDF 2023 da otra distribución (~10-15% según gráficos), pero la cifra "11%" es de la versión 2016 (la ficha lo reconoce en §8 "Versión 2016") | 🟡 |
| Cita §8.1 atribuida a "Versión 2016" | — | Esa cita ES del factsheet 2016, no del 2023 | 🟡 (mezcla las dos versiones) |

**Notas:** los autores del PDF 2023 son Stads y de los Santos (no "ASTI Team"); el período de datos en el PDF 2023 es 2015-2020 (no 2010-2021 como dice la ficha). Las dos citas verbatim del §8 son del factsheet **anterior** (2016), no del documento actual auditado. Mezcla anacrónica.

---

### `GoyalNash2017` — 🟡 PDF es solo el "Overview" + año confuso + citas parafraseadas

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Reaping Richer Returns..." | Confirmado | ✅ |
| authors | Goyal, Nash | Confirmados | ✅ |
| year | 2017 | **PDF dice "OCTOBER 2016" en portada** + nota "The full report will be available in January 2017" | 🟡 |
| source, doi | Africa Development Forum, World Bank, 10.1596/978-1-4648-0937-8 | Confirmados | ✅ |
| pages 266 | — | El PDF disponible parece ser **solo el Overview**, no el libro completo de 266 páginas | 🟡 |
| Brecha productividad SSA "50-70% inferior" (§6) | — | No localizada como cifra exacta en el Overview | 🟡 |
| FISP absorbe 30-60% del presupuesto agrícola | §6 | "Resurgence of input subsidy programs in Africa..." (cualitativo, no cifra exacta) | 🟡 |
| I+D agrícola SSA "0.3-0.5% PIB agrícola" vs "1-2% MIC" | §6 | No localizada como cifras exactas en este Overview | 🟡 |
| Cita §8.1 verbatim "While productivity of African agriculture..." (p. xv) | — | **Casi verbatim** en Foreword: "While productivity of African agriculture has grown, it still lags behind Asia and Latin America, and has not delivered the development dividends..." | ✅ |
| Cita §8.2 verbatim "Moving away from a heavy focus on fertilizer subsidies..." (Resumen) | — | **NO localizada literal** (el PDF habla de "Redress the current excessive focus on unproductive fertilizer subsidies", contenido similar pero no verbatim) | 🔴 |

**Notas:** el PDF descargado parece ser el Overview/preview de octubre 2016 (el libro completo se publicó en enero 2017). Las cifras cuantitativas específicas (50-70% brecha productividad, 30-60% FISP, etc.) probablemente están en el libro completo no disponible. La primera cita del §8 está bien; la segunda no es verbatim.

---

### `Pernechele2021` — 🔴 PDF DESCARGADO ES OTRO PAPER (Pernechele Balié Ghins 2018)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Public Expenditure on Food and Agriculture in Sub-Saharan Africa: Trends, Challenges and Priorities" | **"Agricultural policy incentives in sub-Saharan Africa in the last decade (2005–2016) – MAFAP synthesis study"** | 🔴 |
| authors | Pernechele, Fontes, Baborska, Nkuingoua, Pan, Tuyishime (6 autores) | **Pernechele, Balié & Ghins (3 autores)** | 🔴 |
| year | 2021 | **2018** | 🔴 |
| source | FAO | FAO (Technical Study 3) — coincide | ✅ |
| doi 10.4060/cb4492en | — | El PDF tiene ISBN 978-92-5-130465-5, no este DOI | 🔴 |
| pages "viii + 96" | — | "77 pp." (en la citation page) | 🔴 |
| period_covered "2004-2018" | — | PDF cubre **2005-2016** | 🔴 |
| 13 países SSA (§5, §6) | — | Verificación pendiente; el PDF 2018 incluye una lista pero podría diferir | 🟡 |
| Hallazgos sobre Maputo 10% y subsidios fertilizantes (§6, §7, §8) | — | Plausibles pero no verificables como verbatim en el documento real | 🟡 |
| Cita §8.1 "Most countries are still not meeting the Maputo Declaration..." (Executive Summary) | — | No localizable en el PDF 2018 (que es sobre incentivos NRA-PSE, no expenditure) | 🔴 |
| Cita §8.2 sobre input subsidies vs public goods (Cap. 4) | — | Misma situación | 🔴 |

**Notas:** el PDF disponible es el **synthesis study 2018 sobre policy incentives (NRA/PSE)**, distinto del reporte 2021 sobre public expenditure que la ficha pretende describir. Ambos documentos existen, pero el archivo en disco es el 2018. **Acción urgente.**

---

### `WB2021_TappingPotential` — ✅ Quote 1 confirmada; Quote 3 parafraseada

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Tapping the Potential of Bolivia's Agriculture..." | Confirmado | ✅ |
| authors | World Bank (institucional) | Idem | ✅ |
| year | 2021 | **PDF dice "June 2019"** en portada + © 2020. Disconnect con "2021" del frontmatter | 🟡 |
| source | World Bank | Confirmado | ✅ |
| Concentración 72% Santa Cruz, Cochabamba, La Paz (§6) | — | Verbatim: "72 percent of total agricultural value added is concentrated in Santa Cruz, Cochabamba, and La Paz Departments" | ✅ |
| Crecimiento extensivo (área + insumos) (§6) | — | Múltiples confirmaciones en PDF | ✅ |
| 80% unidades <5 ha (§6) | — | Plausible, no verificada puntualmente | 🟡 |
| Cita §8.1 "Agricultural value is concentrated... 72 percent..." (Cap. 2) | — | **Verbatim confirmada** | ✅ |
| Cita §8.2 "Agricultural growth in Bolivia has largely been based on the expansion of agricultural area..." (Cap. 3) | — | PDF tiene texto similar pero el fraseo exacto no se localizó | 🟡 |
| Cita §8.3 "Public expenditure in agriculture... has not been effective..." (Cap. 5) | — | **NO localizada verbatim** en el PDF | 🔴 |

**Notas:** la primera cita es excelente. La tercera ("has not been effective") es paráfrasis del LLM con comillas. Año del documento es 2019/2020, no 2021 (aunque el citekey usa 2021 y eso ya está canonizado en el corpus).

---

### `WB_BoliviaCPF2023` — 🟡 Cifra USD 993M no verificable; resto ok

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Bolivia Country Partnership Framework FY2023-2026" | Confirmado | ✅ |
| authors | World Bank Group | Idem | ✅ |
| year | 2023 (mayo) | **April 14, 2023** (portada) | ✅ |
| source | World Bank | Confirmado | ✅ |
| **3 prioridades textuales** (§2 y §8): "climate and economic resilience; increased income earnings for vulnerable households; expanded access to quality public services" | — | El PDF habla de "climate and economic resilience, connectivity, productivity and skills, and social service delivery" — los 4 ejes son distintos | 🔴 (estructura mal descrita) |
| **Portafolio USD 993 millones en 6 proyectos** (§6) | — | **PDF no menciona USD 993 millones**. Sí dice "indicative IBRD lending program of approximately US$1.6 billion" para los 4 años | 🔴 |
| Préstamo Innovation for Resilient Food Systems USD 300M (agosto 2022) | — | Plausible, no verificado puntualmente en el CPF | 🟡 |
| Cita §8.1 "The CPF supports key sectors..." | — | No localizada verbatim | 🟡 |
| Cita §8.2 "Three development priorities: increased climate and economic resilience..." | — | **NO localizada con ese fraseo**; el PDF usa 4 ejes, no 3 | 🔴 |

**Notas:** la cifra USD 993M en cartera activa no está en el documento; la estructura de "3 prioridades" parece estar mal extraída (el CPF tiene 4 ejes). Probablemente el LLM confundió este CPF con otro documento (o sintetizó incorrectamente).

---

## Acciones correctivas requeridas

| Ficha | Problema | Severidad | Corrección sugerida |
|-------|----------|:---------:|---------------------|
| `AllcottLedermanLopez2006.md` | geographic_scope "Global" cuando el paper es LAC | 🔴 | Cambiar `geographic_scope: "LAC"`; reescribir §5 indicando "panel de economías latinoamericanas" |
| `AllcottLedermanLopez2006.md` | 2 citas verbatim §8 no en PDF | 🔴 | Sustituir por paráfrasis explícita, o citar el verdadero abstract: "the econometric evidence suggests that non-social subsidies reduce agricultural GDP" |
| `Anriquez2016.md` | PDF descargado es López 2004 (RUR-04-01), no Anríquez 2016 | 🔴 **Crítico** | (a) Re-descargar el verdadero Anríquez et al. 2016 (DOI 10.18235/0000371) **o** (b) renombrar la ficha a `LopezGalinato_RUR-04-01.md` y reescribirla; alternativamente, crear dos fichas |
| `ASTI_Bolivia2023.md` | Autoría incorrecta ("ASTI Team" en vez de "Luis de los Santos") | 🔴 | Cambiar `authors: "Stads, Gert-Jan & de los Santos, Luis"` |
| `ASTI_Bolivia2023.md` | period_covered "2010-2021" cuando PDF muestra 2015-2020 | 🟡 | Cambiar a `period_covered: "2015-2020"` |
| `ASTI_Bolivia2023.md` | Citas §8 son de la versión 2016, no de la 2023 | 🟡 | Separar: citar 2016 con `[@ASTI_Bolivia2016]` y la 2023 con sus propias citas verbatim |
| `GoyalNash2017.md` | Año confuso (libro 2017, Overview oct 2016) | 🟡 | Aclarar en §2 que se cita el Overview 2016 mientras el libro es 2017 |
| `GoyalNash2017.md` | Cita §8.2 "Moving away..." no verbatim | 🟡 | Cambiar a paráfrasis o usar la frase exacta del PDF: "Redress the current excessive focus on unproductive fertilizer subsidies" |
| `Pernechele2021.md` | PDF es Pernechele, Balié & Ghins 2018, no Pernechele et al. 2021 | 🔴 **Crítico** | (a) Re-descargar el verdadero reporte 2021 (DOI 10.4060/cb4492en) **o** (b) renombrar a `PerencheleBalie2018.md` y reescribir |
| `WB2021_TappingPotential.md` | Cita §8.3 "Public expenditure... has not been effective" no verbatim | 🟡 | Sustituir por una cita verificable del PDF sobre gasto público |
| `WB_BoliviaCPF2023.md` | USD 993M no localizado en PDF | 🔴 | Verificar fuente: si proviene de otro documento, atribuirlo correctamente. Cifra correcta del CPF: "US$1.6 billion indicative lending program" para 2023-2026 |
| `WB_BoliviaCPF2023.md` | 3 prioridades vs 4 ejes; cita §8.2 con fraseo inventado | 🔴 | Reescribir con los 4 ejes reales: "climate and economic resilience, connectivity, productivity and skills, social service delivery" |

---

## Observaciones transversales

1. **Cuatro de ocho fichas tienen el PDF equivocado o atribución incorrecta de autoría** (`Anriquez2016`, `Pernechele2021`, `ASTI_Bolivia2023` parcialmente, `Searchinger2020` ya en folder 01). Esto es un porcentaje muy alto y sugiere que los agentes que descargaron PDFs no verificaron coincidencia título/autor entre el archivo descargado y el documento citado en el frontmatter. La Fase 1 detectó PDFs falsos (HTMLs disfrazados) pero no detectó **PDFs reales que son del documento incorrecto**.

2. **Citas "verbatim" con comillas en §8 son frecuentemente paráfrasis:** patrón sistemático que requiere una segunda pasada de "verbatim audit" antes de citar en el reporte final.

3. **Cifras agregadas (USD, %, ratios) requieren verificación caso por caso:** ejemplos detectados: USD 600B Gautam (real $638B), USD 993M cartera CPF (no localizable), 30-60% FISP Goyal/Nash (Overview no lo contiene).

4. **Pares de fichas potencialmente redundantes:** `ASTI_Bolivia2016` y `ASTI_Bolivia2023` se solapan en su §8 (la segunda cita verbatim del primero), lo que llevaría a doble conteo si no se diferencia.

5. **Recomendación general:** para Fase 3, focalizar verificación en las **cifras citadas en `evidence_map.md`** que se utilizarán en el reporte técnico Quarto. Las "alucinaciones" más peligrosas son aquellas cuyas cifras alimentan tablas o snippets del informe final.

---

*Fin del reporte 02_public_spending.*
