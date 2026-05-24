# Auditoria Fase 2 — 04_climate_food_security

**Fecha:** 2026-05-23
**Auditor:** Claude (verificacion PDF vs ficha)
**Carpeta:** `03_literature/04_climate_food_security/`
**PDFs disponibles:** 9 en `pdfs/04_climate_food_security/`
**Fichas con `pdf_downloaded: true`:** 9

## Resumen

- Fichas auditadas: 9
- Confirmadas (verde): 3 (FAO2013_CSA_Sourcebook, IPCC2022_Ch12, WorldBank2021_TappingBolivia)
- Inconsistencias menores (amarillo): 2 (IPCC2022_Ch5 cifra 50-80% no verificada; OXFAM2009 cifras parciales sin confirmar)
- Alucinaciones criticas (rojo): 4 (Andersen2010_ClimateGDP PDF erroneo, Canedo2021 autores y cifra 25%, Frontiers_QuinoaResilience autores totalmente distintos, Springmann2022 cifra 143k EU, WB2022_Innovation PDF erroneo)

## Detalle por ficha

### `Andersen2010_ClimateGDP` — ROJO (el PDF descargado NO es el documento citado)

| Campo | En ficha | En PDF descargado | Status |
|-------|----------|-------------------|:------:|
| title | The Economic Impacts of Climate Change in Bolivia | Programa Gestion Resiliente del Agua — Marco de Gestion Ambiental y Social (MGAS) | ROJO |
| authors | Andersen & Jemio | Ministerio de Desarrollo Productivo, Rural y Agua (Bolivia) | ROJO |
| year | 2016 | Enero 2026 | ROJO |
| source | INESAD / CEPAL | Gobierno de Bolivia / Banco Mundial (proyecto P178861) | ROJO |
| Seccion 6 (1.32-4.75% PIB; 30% mas horas trabajo mujeres) | "verificadas" pero NO en PDF | n/a (no es el documento) | ROJO |

**Problema critico:** La ficha reconoce en una nota que el PDF es "complemento institucional" — pero marca `pdf_downloaded: true` lo cual es enganoso. Todas las cifras cuantitativas (% PIB, % trabajo domestico mujeres) son citas de Andersen & Jemio que NO se pueden verificar porque el documento NO esta en disco.

### `Canedo2021` — ROJO (autores incorrectos + cifra 25% inventada)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Drought impact in the Bolivian Altiplano agriculture... | identico | OK |
| authors | Canedo-Rosso, Uvo (Cintia B.), Berndtsson | Canedo-Rosso, Hochrainer-Stigler, Pflug, Condori, Berndtsson | ROJO |
| year / journal / doi / vol / issue / pages | 2021 / NHESS / 10.5194/nhess-21-995-2021 / 21(3) / 995-1010 | identicos | OK |
| Seccion 6: "ENSO explica ~25% de variabilidad de precipitacion" | claim explicito | NO aparece en el PDF (busqueda exhaustiva); paper habla cualitativamente del rol del ENSO | ROJO |
| Cita verbatim p.995 "Drought is a major natural hazard..." | atribuida | confirmada en abstract | OK |
| Cita "ENSO plays an especially important role..." | atribuida | confirmada en introduccion | OK |

**Problema:** Autor "Uvo, Cintia B." NO es autor del paper. Se omiten 2 autores reales (Hochrainer-Stigler, Pflug y Condori). La cifra "25% de variabilidad explicada por ENSO" es invencion.

### `FAO2013_CSA_Sourcebook` — VERDE

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Climate-Smart Agriculture Sourcebook | identico | OK |
| author | FAO | FAO 2013 | OK |
| year | 2013 | 2013 | OK |
| ISBN | n/a en ficha | 978-92-5-107720-7 (print) | OK |
| Seccion 6 (10-50% yield gains, 19-29% emisiones, $80-150bn) | sin verificar a pagina | razonable y consistente con literatura CSA estandar | AMARILLO sobre cifras especificas |

### `Frontiers_QuinoaResilience` — ROJO (autores totalmente distintos + cifras inventadas)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Indigenous Food Systems and Climate Change: Impacts of Climatic Shifts on the Production and Processing of Native and Traditional Crops in the Bolivian Andes | identico | OK |
| authors | Meldrum, Mijatovic, Rojas, Flores, Pinto, Mamani, Condori, Hilaquita, Gruberg, Padulosi (10) | Alder Keleman Saxena, Ximena Cadima Fuentes, Rhimer Gonzales Herbas, Debbie L. Humphries (4) | ROJO |
| year / journal / doi / pages | 2016 / Frontiers Public Health / 10.3389/fpubh.2016.00020 / 4:20 | identicos | OK |
| geographic_scope (Altiplano) | claim ficha | PDF: municipio de Colomi, Cochabamba (valles, no altiplano) | ROJO |
| Cifras Seccion 6: 60+ variedades papa, 30-60% perdidas, >80% productores reportan heladas | citas explicitas | NO aparecen en el resumen ni metodologia del PDF real (foco en papa/oca/tarwi/papalisa/charke en Colomi) | ROJO |

**Problema critico:** La ficha describe un paper COMPLETAMENTE DISTINTO al PDF en disco. El titulo y DOI son los mismos, pero los autores, el contexto geografico (Colomi/Cochabamba vs Altiplano) y los hallazgos son ficcion. Todo el snippet ES/EN del seccion 12 esta basado en informacion no presente en el paper.

### `IPCC2022_Ch12` — VERDE

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Central and South America (Ch.12) | identico | OK |
| authors | Castellanos, Lemos, Astigarraga, Chacon, Cuvi, Huggel, Miranda, Moncassim Vale, Ometto, Peri, Postigo, Ramajo, Roco, Rusticucci | identicos (CLA+LA) | OK |
| year / source / pages / doi | 2022 / IPCC AR6 WGII / 1689-1816 / 10.1017/9781009325844.014 | identicos | OK |
| Cifras Seccion 6: 4.5-5°C, 30-50% perdida glaciar, 10-30% perdida cultivos RCP8.5 | claims explicitos | consistentes con AR6 WGII pero requieren citas de pagina exacta | AMARILLO |

### `IPCC2022_Ch5` — AMARILLO (cifra 50-80% reduccion de perdidas no verificada)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Food, Fibre and Other Ecosystem Products | identico | OK |
| authors | Bezner Kerr, Hasegawa, Lasco + LA (13) | identicos | OK |
| year / source / pages / doi | 2022 / IPCC AR6 WGII / 713-906 / 10.1017/9781009325844.007 | identicos | OK |
| "CSA puede reducir perdidas 50-80%" | claim explicito | rango especifico no comun en IPCC AR6 WGII Cap 5 | AMARILLO |

### `OXFAM2009_BoliviaClimate` — AMARILLO (cifras parciales no verificadas a pagina)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Bolivia: Climate Change, Poverty and Adaptation | identico (es Executive Summary) | OK |
| author | Oxfam International | Oxfam International | OK |
| year | 2009 | October 2009 | OK |
| pages | sin especificar | Executive summary corto | OK menor |
| Cifras: Chacaltaya extinto 2009; ~50% glaciar Andes Bolivia desde 1980; 36% pobreza extrema rural | citas explicitas | Chacaltaya 2009 cierto en literatura; ~50% y 36% NO verificadas a pagina | AMARILLO |
| Cita verbatim "Bolivia is one of the most vulnerable countries..." | atribuida | parafrasea correctamente el contenido del documento (Bolivia "particularly vulnerable") | OK |

### `Springmann2022` — ROJO (cifra "143,000 vidas UE" no esta en el paper)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Options for Reforming Agricultural Subsidies from Health, Climate, and Economic Perspectives | identico | OK |
| authors | Springmann, M. & Freund, F. | identicos | OK |
| year / journal / vol / pages / doi | 2022 / Nature Communications / 13:82 / 10.1038/s41467-021-27645-2 | identicos | OK |
| "143,000 vidas salvadas/ano en la UE en 2030" | citado | NO en el paper. Paper reporta 444,000 menos muertes globales en 2030 (95% CI 429k-460k); 370,000-379,000 evitadas en otro escenario. No hay cifra de "143,000 EU". | ROJO |
| "Reduccion 2-9% GHG global" | citado | rango razonable pero no verificado a pagina | AMARILLO |

### `WB2022_Innovation` — ROJO (PDF descargado no corresponde + pdf_path apunta a archivo erroneo)

| Campo | En ficha | En PDF descargado (que es Andersen2010_ClimateGDP.pdf) | Status |
|-------|----------|-------------------------------------------------------|:------:|
| title | Bolivia — Innovation for Resilient Food Systems Project (PAD) | Programa Gestion Resiliente del Agua — MGAS (Bolivia gobierno) | ROJO |
| authors | World Bank | Ministerio de Desarrollo Productivo, Rural y Agua | ROJO |
| year | 2022 | Enero 2026 | ROJO |
| pdf_path | `04_climate_food_security/Andersen2010_ClimateGDP.pdf` | n/a | ROJO (duplicado y enganoso) |
| Cifras: USD 300M, 130k familias | citadas como "verificadas" | NO se pueden verificar — PDF en disco es otro documento | ROJO |

**Problema:** Dos fichas (Andersen2010_ClimateGDP y WB2022_Innovation) apuntan al MISMO archivo PDF descargado que ademas NO es ninguno de los dos documentos citados. Se debe re-descargar el PAD oficial P178861 y el Andersen & Jemio (2016).

### `WorldBank2021_TappingBolivia` — VERDE

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Tapping the Potential of Bolivia's Agriculture and Food Systems... | identico | OK |
| author | World Bank | World Bank Group | OK |
| year | 2021 | June 2019 portada (mismo issue que en folder 03) | AMARILLO menor |
| source | World Bank | World Bank | OK |
| Cifras Seccion 6: mujeres rurales ~48% sistemas productivos, productividad rezagada | claims sin verificar a pagina | requieren citas exactas | AMARILLO |

## Acciones correctivas

| Ficha | Problema | Severidad | Correccion sugerida |
|-------|----------|:---------:|---------------------|
| Andersen2010_ClimateGDP | El PDF descargado es un documento gubernamental boliviano (MGAS riego), no el paper Andersen & Jemio | ROJO | (a) Re-descargar el paper Andersen-Jemio (2016) de CEPAL/INESAD; o (b) cambiar `pdf_downloaded: false`; (c) reescribir la nota explicando que las cifras NO estan verificadas |
| WB2022_Innovation | Mismo PDF erroneo que Andersen2010_ClimateGDP; metadatos del PAD no verificables | ROJO | Re-descargar el Project Appraisal Document P178861 desde el WB y corregir pdf_path |
| Canedo2021 | Autoria incompleta y erronea; cifra "25%" inventada | ROJO | Corregir authors a "Canedo-Rosso, C., Hochrainer-Stigler, S., Pflug, G., Condori, B., Berndtsson, R."; eliminar el numero 25%; reemplazar con afirmacion cualitativa apoyada en el paper |
| Frontiers_QuinoaResilience | Autores y contenido COMPLETAMENTE distintos al PDF real | ROJO | (a) Reescribir ficha para el paper real (Keleman Saxena, Cadima Fuentes, Gonzales Herbas, Humphries 2016 — Colomi, Cochabamba); o (b) Re-descargar el paper Meldrum et al. si existe con ese DOI (verificar — el DOI en ficha apunta al paper Keleman Saxena en realidad) |
| Springmann2022 | Cifra "143,000 vidas UE 2030" no esta en el paper | ROJO | Reemplazar por las cifras reales: "444,000 menos muertes globales en 2030" o "370,000-379,000 evitadas en otro escenario"; eliminar la referencia a "143k EU" |
| IPCC2022_Ch5 | Cifra "50-80% reduccion perdidas via CSA" no es tipica de IPCC; requiere validacion | AMARILLO | Verificar a pagina o sustituir por afirmacion del rango incluido en el resumen IPCC con confidence level adecuado |
| OXFAM2009_BoliviaClimate | Cifras 50% glaciar / 36% pobreza no validadas a pagina | AMARILLO | Anadir referencia de pagina o sustituir por cita textual del Executive Summary |
| WorldBank2021_TappingBolivia | Ano 2021 vs portada 2019 | AMARILLO | Mismo issue que en folder 03 — homologar la decision sobre ano oficial |
| FAO2013_CSA_Sourcebook, IPCC2022_Ch12 | Cifras razonables pero sin pagina exacta | AMARILLO | Anadir paginas precisas en lectura posterior |
