# Auditoría Fase 2 — 03_productivity_efficiency

**Fecha:** 2026-05-23
**Auditor:** Claude (verificación PDF vs ficha)
**Carpeta:** `03_literature/03_productivity_efficiency/`
**PDFs disponibles:** 17 en `pdfs/03_productivity_efficiency/`
**Fichas con `pdf_downloaded: true`:** 13

## Resumen

- Fichas auditadas: 9
- Confirmadas (verde): 4 (AndersonFeder2007 metadata correcta pero PDF distinto, BazileJacobsenVerniau2016, Fuglie2024, Greene2008SFA, Ludena2010, WorldBank2021Bolivia)
- Inconsistencias menores (amarillo): 3 (Bazile2016Quinoa lista incorrecta de paises, WorldBank2021Bolivia anyo cubierta vs ficha, varios snippets con [TBV] pendientes)
- Alucinaciones criticas (rojo): 4 (AndersenSDSN2023 autores, AndersonFeder2007 PDF distinto, Anriquez2017IDB autores y numero de WP, AvilaEvenson2010 PDF distinto, Gasques2010ERS autores)

## Detalle por ficha

### `AndersenSDSN2023` — ROJO (autores incorrectos)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Map of Agricultural Potential in Bolivia | Map of Agricultural Potential in Bolivia | OK |
| authors | Andersen, Doyle & Branisa (3) | Andersen, Argandona, Choque Sunagua, Calderon Acebey, Inkinen, Malky (6) | ROJO |
| year | 2023 | 2023 (Oct) | OK |
| source | SDSN Bolivia / INESAD WP 5/2023 | SDSN Bolivia / INESAD WP 5/2023 | OK |
| Seccion 6 | TBV (no cifras concretas) | n/a | OK (marca TBV) |

**Problema:** Los autores "Doyle" y "Branisa" NO aparecen en el PDF. Los autores reales son seis personas distintas. Es una alucinacion completa de la autoria.

### `AndersonFeder2007` — ROJO (el PDF en disco no corresponde a la cita)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Agricultural Extension (Handbook ch.) | Agricultural Advisory Services (WDR 2008 background paper) | ROJO |
| authors | Anderson, Jock R. & Feder, Gershon | Jock R. Anderson (solo) | ROJO |
| year | 2007 (Handbook v.3) | July 2, 2007 (background paper) | OK ano |
| source | Handbook of Ag Economics V.3 | World Bank — WDR 2008 background | ROJO |
| pages | 2343-2378 | n/a (paper standalone) | ROJO |
| doi | 10.1016/S1574-0072(06)03044-1 | n/a | ROJO (no DOI en background paper) |

**Problema:** La ficha describe el capitulo del Handbook que NO esta en el PDF descargado. El PDF es un background paper de WDR 2008 escrito solo por Anderson. Hay que reescribir la ficha para el documento descargado, o re-descargar el capitulo del Handbook.

### `Anriquez2017IDB` — ROJO (autores y numero de WP incorrectos)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Public Expenditures, Impact Evaluations, and Agricultural Productivity... | Public Expenditures, Impact Evaluations, and Agricultural Productivity... | OK |
| authors | Anriquez, Foster, Ortega, Falconi, De Salvo | Cesar Augusto Lopez, Lina Salazar, Carmine Paolo De Salvo | ROJO |
| year | 2017 | January 2017 | OK |
| source | IDB Working Paper IDB-WP-768 | IDB Technical Note IDB-TN-1242 | ROJO |
| issue | IDB-WP-768 | IDB-TN-1242 | ROJO |

**Problema:** El tipo de documento (Technical Note, no Working Paper), el numero (TN-1242 no WP-768), y los autores son distintos. Solo De Salvo aparece en ambos. Los hallazgos cuantitativos (45% bienes publicos, 30-40% IRR I+D) deben revalidarse.

### `Arias2017Brazil` — VERDE

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Agriculture Productivity Growth in Brazil... | Agriculture Productivity Growth in Brazil | OK |
| authors | Arias, Vieira, Contini, Farinelli, Morris | Arias, Vieira, Contini, Farinelli, Morris | OK |
| year | 2017 | September 24, 2017 | OK |
| source | WB Brazil Productivity Growth Flagship | WB Brazil Productivity Growth Flagship | OK |
| url | wb 268351520343354377 | id no verificado pero coincide con flagship | OK |
| Seccion 6 (3-4%/ano TFP) | TBV verbatim | consistente con literatura Brasil | AMARILLO (cifras no verificadas a pagina) |

### `AvilaEvenson2010` — ROJO (PDF en disco es de un capitulo distinto)

| Campo | En ficha | En PDF (Embrapa mirror) | Status |
|-------|----------|-------------------------|:------:|
| title | TFP Growth in Agriculture: The Role of Technological Capital | Agricultural Productivity in Latin America and the Caribbean and Sources of Growth | ROJO |
| authors | Avila, Antonio Flavio Dias & Evenson, Robert E. | Antonio Flavio Dias Avila, Luis Romano, Fernando Garagorry | ROJO |
| pages | 3769-3822 | 3713-3768 (capitulo 71) | ROJO |
| doi | 10.1016/S1574-0072(09)04072-9 | n/a en este capitulo | ROJO |

**Problema:** El PDF descargado es el Capitulo 71 (Avila, Romano, Garagorry) NO el capitulo del libro citado en la ficha. Las cifras de la ficha (Brasil TFP 4.5%/ano, Colombia 1.5%/ano, elasticidad 0.20-0.30) pueden o no estar en el capitulo descargado pero NO se atribuyen a "Avila & Evenson" como afirma la ficha.

### `Bazile2016Quinoa` — AMARILLO (paises listados parcialmente incorrectos)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Worldwide Evaluations of Quinoa: Preliminary Results... | Worldwide Evaluations of Quinoa: Preliminary Results... | OK |
| authors | Bazile, Pulvento, Verniau & et al | Bazile, Pulvento, Verniau + 11 mas (correctamente "et al") | OK |
| year/journal/doi/pages | 2016 / Frontiers Plant Sci / 10.3389/fpls.2016.00850 / 7:850 | identicos | OK |
| paises listados en ficha | Algeria, Iran, Libano, Mali, Mauritania, Pakistan, Sudan, Tayikistan, Turquia | Kyrgyzstan, Tajikistan, Algeria, Egypt, Iraq, Iran, Lebanon, Mauritania, Yemen | AMARILLO |
| Q21/Q26 >1 t/ha | citado | confirmado en abstract | OK |

**Problema:** 4 paises mal listados (Mali/Pakistan/Sudan/Turquia incorrectos; Kyrgyzstan/Egypt/Iraq/Yemen omitidos). Cifra del rendimiento confirmada.

### `BazileJacobsenVerniau2016` — VERDE

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title / authors / year / doi / pages | The Global Expansion... / Bazile, Jacobsen, Verniau / 2016 / 10.3389/fpls.2016.00622 / 7:622 | identicos | OK |
| Cifras 8 paises (1980) -> 40 (2010) -> 75 (2014) +20 nuevos 2015 | confirmadas en abstract | OK |
| Bolivia+Peru 80% produccion | claim de ficha; no verificada en primeras paginas pero coherente | AMARILLO menor |

### `Fuglie2024` — VERDE

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | World Agricultural Production, Resource Use, and Productivity, 1961-2020 | identico | OK |
| authors | Fuglie, Morgan, Jelliffe | identicos | OK |
| year | 2024 | Feb 2024 | OK |
| source / issue | USDA ERS EIB-268 | EIB-268, Feb 2024 | OK |
| Cifras (TFP global ~1.7%, LAC ~1.9%, Bolivia ~0.6%) | marcadas [TBV] dentro de ficha | razonables, pero requieren validacion a pagina | AMARILLO (la ficha lo reconoce) |

### `Gasques2010ERS` — ROJO (autoria del reporte distinta)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | TFP in Brazilian Agriculture (ch.4 of ERR-137) | Policy, Technology, and Efficiency of Brazilian Agriculture (ERR-137) | OK overall report; pero la ficha cita un capitulo |
| authors | Gasques, Bastos, Bacchi, Valdes | Nicholas Rada and Constanza Valdes (autores del reporte ERR-137) | ROJO |
| year | 2012 | July 2012 | OK |
| source | USDA ERS ERR-137 | USDA ERS ERR-137 | OK |
| citacion oficial | "Gasques et al" | "Rada, Nicholas, and Constanza Valdes. Policy, Technology, and Efficiency of Brazilian Agriculture, ERR-137, July 2012" | ROJO |

**Problema:** El reporte ERR-137 es de Rada & Valdes. Gasques aparece solo en agradecimientos. La cifra "Brasil TFP 3.5%/ano 1975-2010" debe re-atribuirse a Rada-Valdes o a una pieza separada de Gasques que NO esta en este PDF.

### `Greene2008SFA` — VERDE

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title / authors / source / pages | The Econometric Approach to Efficiency Analysis / Greene / Fried-Lovell-Schmidt OUP / 92-250 | confirmados | OK |
| Contenido seccional | Cap 2 SFA en Measurement of Productive Efficiency | confirmado | OK |

### `Ludena2010` — VERDE

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title / author / year / source | Agricultural Productivity Growth... LAC / Ludena / 2010 / IDB-WP-186 | confirmados | OK |
| Cifras LAC ~1.9%/ano, Bolivia ~0.6% | claim explicito | no verificado a pagina pero consistente con literatura previa | AMARILLO |

### `WorldBank2021Bolivia` — AMARILLO (ano portada vs ano ficha)

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | Tapping the Potential of Bolivia's Agriculture... | identico | OK |
| author | World Bank | World Bank Group | OK |
| year | 2021 | June 2019 portada / 2020 copyright | AMARILLO |
| source | World Bank Group | World Bank Group | OK |
| Cifras: 3% crecimiento, 72% concentracion 3 deptos, 60% fincas <1 ha | claims explicitos | no verificadas a pagina; consistentes con narrativa pero requieren citas exactas | AMARILLO |

## Acciones correctivas

| Ficha | Problema | Severidad | Correccion sugerida |
|-------|----------|:---------:|---------------------|
| AndersenSDSN2023 | Autores Doyle/Branisa inventados | ROJO | Reemplazar por la lista correcta: Andersen, Argandona, Choque Sunagua, Calderon Acebey, Inkinen, Malky |
| AndersonFeder2007 | PDF descargado no corresponde a la cita | ROJO | (a) Re-descargar capitulo del Handbook (cap. con DOI 10.1016/S1574-0072(06)03044-1), o (b) reescribir ficha para "Anderson (2007) Agricultural Advisory Services, WDR 2008 background paper" |
| Anriquez2017IDB | Autores incorrectos; tipo y numero de paper incorrectos | ROJO | Corregir authors a "Lopez, Salazar, De Salvo"; cambiar issue de IDB-WP-768 a IDB-TN-1242; cambiar type a "Technical Note"; re-validar cifras del seccion 6 |
| AvilaEvenson2010 | El PDF en disco es el capitulo Avila-Romano-Garagorry, no el de Avila-Evenson | ROJO | Re-descargar el capitulo correcto (3769-3822) o reescribir ficha como "Avila, Romano, Garagorry (2010) Agricultural Productivity in LAC and Sources of Growth, Handbook Ag Economics Ch.71, pp. 3713-3768" |
| Gasques2010ERS | El reporte ERR-137 lo escriben Rada & Valdes; Gasques esta solo en agradecimientos | ROJO | Corregir autoria a "Rada, N. & Valdes, C. (2012)" o re-descargar el documento Gasques original si existe separado |
| Bazile2016Quinoa | 4 paises mal listados en seccion descriptiva | AMARILLO | Sustituir lista por: Kyrgyzstan, Tajikistan, Algeria, Egypt, Iraq, Iran, Lebanon, Mauritania, Yemen |
| WorldBank2021Bolivia | Ano publicado vs portada inconsistente | AMARILLO | Decidir ano oficial (probablemente 2020 segun copyright) y documentar la decision en nota |
| Fuglie2024, Ludena2010, Arias2017Brazil | Cifras TBV o sin pagina exacta | AMARILLO | Anadir paginas exactas tras lectura completa del PDF |
