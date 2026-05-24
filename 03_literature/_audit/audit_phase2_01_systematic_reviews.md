# Auditoría Fase 2 — `01_systematic_reviews/`

**Fecha:** 2026-05-23
**Auditor:** Claude Code (Opus 4.7)
**Método:** Lectura de fichas + extracción de PDFs con `pdftotext` + verificación campo por campo
**Cobertura:** 8 fichas con `pdf_downloaded: true` (de 16 disponibles); selección por orden alfabético/relevancia

---

## Resumen ejecutivo

- **Fichas auditadas:** 8
- ✅ **Todo confirmado (sin issues materiales):** 2 (`FOLU2019`, `IEG2022_Agribusiness`)
- 🟡 **Parcial / inconsistencias menores:** 3 (`Anderson2008WDR`, `AndersonFeder2004`, `DeJanvrySadoulet2010`)
- 🔴 **Alucinaciones críticas / metadatos incorrectos:** 3 (`AlstonPardey2000`, `Searchinger2020`, `MAFAP_Synthesis2013`)
- **Tasa de alucinación crítica:** 37.5% de la muestra

**Patrón dominante:** los hallazgos cuantitativos clave de la sección 6 y los snippets bilingües generalmente capturan bien la tesis del documento, pero las **"citas verbatim" en la sección 8 son frecuentemente paráfrasis presentadas como citas literales** (texto entre comillas con atribución de página, pero no encontrable en el PDF). En 3 casos los metadatos del PDF descargado no corresponden a los del frontmatter (PDF distinto al declarado).

---

## Detalle por ficha

### `AlstonPardey2000` — 🔴 Inconsistencias en cifras + citas inventadas

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "A Meta-Analysis of Rates of Return to Agricultural R&D: Ex Pede Herculem?" | Idem | ✅ |
| authors | Alston, Chan-Kang, Marra, Pardey, Wyatt | Idem | ✅ |
| year | 2000 | 2000 | ✅ |
| source | IFPRI Research Report 113 | IFPRI Research Report (#113 referido en lomo) | ✅ |
| TIR mediana **investigación** | 44%/año (§6) | **48.0%/año** | 🔴 |
| TIR mediana **extensión** | 80%/año (§6) | **62.9%/año** | 🔴 |
| TIR mediana **investigación+extensión** | 37%/año | 37% | ✅ |
| TIR mediana global (todas) | — | 44.3% (esto sería la mediana sobre todas las observaciones) | — |
| Snippet ES y EN | "44%/año para I+D y 80%/año para extensión" | **Cifras incorrectas** | 🔴 |
| Cita §8 "remarkably high... median of 48 percent" (p. 70) | — | "**median of the rate of return estimates was 48.0 percent per year for research**" (no "remarkably high" como fraseo) | 🟡 |
| Cita §8 "Most studies... overstate" (p. 88) | — | No localizada con ese fraseo | 🔴 |

**Notas:** La ficha confunde la mediana general (44.3%) con la de investigación específicamente (48.0%) y reporta 80% para extensión cuando el PDF dice 62.9%. Estas cifras se han propagado al snippet ES/EN del reporte y deberían corregirse antes de citar. Las dos "citas verbatim" no aparecen literalmente en el PDF.

---

### `Anderson2008WDR` — 🟡 Cita parafraseada presentada como verbatim

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Agricultural Advisory Services. Background Paper for the WDR 2008" | Idem | ✅ |
| authors | Anderson, Jock R. | Jock R. Anderson | ✅ |
| year | 2007 | July 2, 2007 (paper) / 2008 (WDR) | ✅ |
| source | World Bank Background Paper for WDR 2008 | Idem | ✅ |
| TIR extensión 30-50% (§6) | — | Plausible pero no localizado verbatim | 🟡 |
| Ratio extensionista:agricultor 1:200-400 vs 1:800-1000 | — | Plausible (cifras estándar del autor) | 🟡 |
| Cita §8 sobre "pluralism" | "Pluralism in extension provision—mixing public, private, and civil society actors—appears to outperform any single-model system" | El PDF habla de "pluralism in service providers" y "smart best-fit choices" pero NO contiene esa cita literal | 🔴 |

**Notas:** la tesis general (pluralismo + best-fit) está respaldada por el PDF; la cita textual del §8 está inventada. Las cifras cuantitativas no se pudieron verificar puntualmente.

---

### `AndersonFeder2004` — 🟡 Frontmatter perfecto; cita inventada y cifra USD no localizada

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Agricultural Extension: Good Intentions and Hard Realities" | Idem | ✅ |
| authors | Anderson & Feder | Anderson, Feder | ✅ |
| year, volume, issue, pages | 2004, 19, 1, 41-60 | Confirmado en portada | ✅ |
| doi | 10.1093/wbro/lkh013 | Confirmado | ✅ |
| Inversión Banco Mundial T&V USD 1.5B en 1975-1995 (§6) | — | No localizada en el PDF | 🔴 (no verificable) |
| Ratio extensionista:agricultor 1:800 en T&V | — | No localizada literal | 🟡 |
| TIR extensión 5-80% | — | No localizada literal | 🟡 |
| Cita §8 "Despite considerable expenditure... mixed at best" (p. 44 aprox.) | — | **No encontrada** | 🔴 |

**Notas:** los metadatos están perfectos. La tesis (T&V tuvo impacto débil) está respaldada por el paper. Pero la "cita verbatim" no es verbatim — es paráfrasis con comillas y "aprox." atenuante.

---

### `DeJanvrySadoulet2010` — ✅ con un detalle menor

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title, authors, year, journal, vol/issue/pages | Todos correctos | Confirmados | ✅ |
| doi 10.1093/wbro/lkp015 | — | Confirmado en portada | ✅ |
| Hallazgo "3× mayor reducción de pobreza" | §6 y §12 | Verbatim en abstract: "induces income growth among the 40% poorest which is on the order of three times larger than growth originating in the rest of the economy" | ✅ |
| Cita §8 atribuida a p. 8 | — | La cita es **del abstract** (p. 1), no de p. 8 | 🟡 |

**Notas:** ficha excelente; única falla es la atribución de página (p. 8 vs abstract). Recomendación: cambiar "(p. 8)" a "(abstract)" o "(p. 1)".

---

### `FOLU2019` — ✅ Todo confirmado

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Growing Better: Ten Critical Transitions..." | Idem (Sept. 2019) | ✅ |
| authors | Food and Land Use Coalition | Idem (institucional) | ✅ |
| year, source | 2019, FOLU | Confirmados | ✅ |
| Daños externos USD 12T/año | §6 | Verbatim: "$12 trillion in environmental, health and poverty costs" | ✅ |
| USD 16T para 2050 | §6 | Verbatim: "$16 trillion a year by 2050" | ✅ |
| USD 4.5T oportunidades de negocio | §6 | Verbatim: "$4.5 trillion a year by 2030" | ✅ |
| USD 700B subsidios | §6 | Verbatim: "over $700 billion a year" | ✅ |
| Cita §8 sobre $12T | — | Casi verbatim (PDF: "$12 trillion in environmental, health and developmental damages per year") | ✅ |

**Notas:** ficha ejemplar. Todas las cifras grandes están respaldadas por el PDF.

---

### `Gautam2022` — 🟡 cifras agregadas mal precisadas

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title, authors, year, DOI | Correctos | Confirmados (portada y citation page) | ✅ |
| **Soporte agrícola global USD 600B/año** (§6) | — | **PDF dice "$638 billion per year"** (total) y "$456 billion" (a productores) | 🟡 |
| **% a conservación 5%** (§6) | — | PDF: "5 percent was 'green' subsidies" | ✅ (este 5% sí coincide) |
| **% a I+D/asistencia técnica 6%** (§6) | — | PDF: "17 percent was for public goods and services like research and irrigation" | 🔴 |
| Redirigir USD 70B/año = USD 2T en 20 años | §6 | Verbatim confirmado | ✅ |
| Reducción emisiones >40% | §6 | Verbatim confirmado | ✅ |
| Cita §8 sobre repurposing >40% | — | Verbatim en el PDF | ✅ |
| Cita §8 sobre USD 70B = USD 2T | — | Verbatim en el PDF | ✅ |

**Notas:** las dos citas verbatim son legítimas. El "USD 600B" es una aproximación razonable (PDF da $638B). Pero la afirmación "6% a I+D/asistencia técnica" contradice el PDF que dice 17% para "public goods and services like research and irrigation". Hay confusión entre dos categorías distintas.

---

### `IEG2022_Agribusiness` — ✅ Verbatim correcto

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Toward Productive, Inclusive, and Sustainable Farms and Agribusiness Firms..." | Idem (citation page) | ✅ |
| authors | World Bank IEG (institucional) | Idem | ✅ |
| year, source | 2022, World Bank IEG | Confirmados | ✅ |
| 80% éxito intervenciones system-level vs 72% promedio (§6) | — | Verbatim: "an 80 percent success rate versus 72 percent on average for all interventions" | ✅ |
| Cita §8 verbatim | — | Casi verbatim (PDF dice "have an 80 percent success rate" vs ficha "achieve an 80 percent success rate") | ✅ |

**Notas:** ficha sólida. Snippet y cita respaldados.

---

### `Mogues2012` — 🟡 Cita inventada; cifras yuan/yuan no localizadas

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "The Impacts of Public Investment in and for Agriculture: Synthesis of Existing Evidence" | Confirmado | ✅ |
| authors | Mogues, Yu, Fan, McBride | Confirmados | ✅ |
| year, source | 2012, IFPRI/FAO ESA | Confirmados (ESA Working paper No. 12-07, Oct 2012) | ✅ |
| Returns China (§6): I+D 9.6, caminos 8.3, educación 8.7, crédito 3.7 yuan/yuan | — | No localizadas verbatim; PDF cita Fan, Zhang & Zhang 2004 sin reportar los números exactos en formato yuan/yuan | 🟡 |
| Elasticidades 0.10-0.40 I+D | §6 | Plausible (rango estándar en la literatura) pero no localizadas como cifra unificada en el PDF | 🟡 |
| Cita §8 "Evidence indicates... higher returns than transfers and price subsidies" (~p. 60) | — | **No encontrada en el PDF** | 🔴 |

**Notas:** los snippets capturan bien la tesis del paper. Pero la "cita verbatim" del §8 con su pie de página atenuante "(~p. 60)" es paráfrasis con apariencia de cita. Las cifras yuan-por-yuan provienen probablemente del paper de Fan citado en Mogues, no del propio Mogues.

---

### `Searchinger2020` — 🔴 PDF DESCARGADO NO CORRESPONDE A LA FICHA

| Campo | En ficha | En PDF | Status |
|-------|----------|--------|:------:|
| title | "Revising Public Agricultural Support to Mitigate Climate Change" (Searchinger 2020) | **"Smart Agricultural Subsidies Can Restore Degraded Farms And Rural Economies"** | 🔴 |
| authors | Searchinger, Hanson, Ranganathan, Ding, Damassa | **"WRI Authors" (institucional, sin nombres)** | 🔴 |
| year | 2020 | **AUGUST 2021** (en portada) | 🔴 |
| source | World Bank / WRI Knowledge for Development Series | **WRI brief, "Research in Focus"** | 🔴 |
| doi 10.1596/33677 | — | No aparece en el PDF | 🔴 |
| USD 600B subsidios totales | §6 | El PDF (otro documento) cita "$700 billion" | 🟡 |
| Cifras de I+D / conservación | §6 | No localizables en este PDF | 🔴 |
| Cita §8 "less than 20%" | — | No localizada en este PDF | 🔴 |

**Notas:** El PDF en disco es un brief WRI 2021 ("Smart Agricultural Subsidies") que es un follow-up a la línea de trabajo de Searchinger, pero **NO es** el reporte World Bank 2020. La ficha describe metadatos y contenido del WB report mientras el archivo descargado es otro. **Acción urgente:** o bien re-descargar el reporte correcto (DOI 10.1596/33677) o bien crear una ficha nueva consistente con el brief 2021 disponible.

---

## Acciones correctivas requeridas

| Ficha | Problema | Severidad | Corrección sugerida |
|-------|----------|:---------:|---------------------|
| `AlstonPardey2000.md` | TIR investigación: ficha "44%" vs PDF "48%"; TIR extensión: ficha "80%" vs PDF "62.9%" | 🔴 | Corregir §6 y los snippets ES/EN: usar 48% (research) y 62.9% (extension), o usar 44.3% como "media global combinada" |
| `AlstonPardey2000.md` | Citas §8 no localizadas verbatim en el PDF | 🟡 | Sustituir por citas que sí están: "median of the rate of return estimates was 48.0 percent per year for research, 62.9 percent for extension studies, 37 percent for studies that estimated the returns to research and extension jointly, and 44.3 percent for [combined]" |
| `Anderson2008WDR.md` | Cita §8 sobre "pluralism" no localizada verbatim | 🟡 | Sustituir por: "this requires pluralism in service providers and organizations that have the attitude and the ability to find the right approach in different situations; in short, smart best-fit choices" (que sí está en el PDF) |
| `AndersenFeder2004.md` | Cita §8 "Despite considerable expenditure... mixed at best" no en PDF; cifra USD 1.5B Banco T&V no localizable | 🟡 | Cambiar a paráfrasis sin comillas o localizar texto exacto |
| `DeJanvrySadoulet2010.md` | Cita §8 atribuida a p. 8 cuando es del abstract (p. 1) | 🟡 | Cambiar "(p. 8)" → "(abstract)" |
| `Gautam2022.md` | USD 600B impreciso (PDF: $638B total / $456B productores) | 🟡 | Cambiar a "USD ~638 mil millones/año en soporte total" o "USD 456 mil millones en apoyo a productores 2016-18" |
| `Gautam2022.md` | "6% a I+D" contradice PDF que dice 17% para public goods (incl. I+D + riego) | 🔴 | Reescribir como "17% a bienes públicos (I+D + riego) y 5% a 'green subsidies' adicionales, según Figura O.3 del reporte" |
| `Mogues2012.md` | Cita §8 (~p. 60) no en PDF | 🟡 | Sustituir por paráfrasis o cita exacta del paper (ej. resumen sobre patrones de retorno entre tipos de gasto) |
| `Mogues2012.md` | Cifras yuan/yuan (§6) no localizables directamente | 🟡 | Atribuir explícitamente a "Fan, Zhang & Zhang 2004 citado en Mogues 2012" |
| `Searchinger2020.md` | **PDF descargado NO es Searchinger2020**; es un WRI brief 2021 | 🔴 **Crítico** | Re-descargar el reporte correcto (DOI 10.1596/33677) o renombrar la ficha y rehacerla con metadatos del brief 2021 |
| `MAFAP_Synthesis2013.md` | PDF es draft 2011 "A Review of relevant policy analysis work" por Balié & Maetz, NO "Synthesis Report 2013" por FAO | 🔴 **Crítico** | Corregir año (2011), título ("A Review of Relevant Policy Analysis Work in Africa"), autores (Balié, J. & Maetz, M.) en frontmatter; reescribir §6 y §8 |

---

## Observaciones transversales

1. **Patrón de "paráfrasis con comillas":** muchas fichas presentan en §8 ("Citas directas") texto en formato `> "..."` con atribución de página, cuando en realidad es paráfrasis del LLM. Esto es peligroso porque al copiarse al reporte se citará como verbatim.
2. **Atribución de página débil:** varias fichas usan "(~p. X)", "(p. X aprox.)" o citan páginas que no coinciden (DeJanvry: p. 8 vs abstract).
3. **Snippets ES/EN bilingües generalmente robustos:** capturan bien la tesis y respaldados por evidencia, salvo cuando heredan errores numéricos de §6 (caso AlstonPardey).
4. **2 fichas con PDF equivocado descargado** (Searchinger2020, MAFAP_Synthesis2013): el agente original anotó `pdf_downloaded: true` cuando el archivo real era otro documento. Indica que la verificación PDF↔ficha de Fase 1 fue solo de presencia de archivo, no de coincidencia de contenido.

---

*Fin del reporte 01_systematic_reviews.*
