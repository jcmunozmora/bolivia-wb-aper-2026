# Auditoría Fase 2 (Contenido) — `10_macro_growth_poverty/`

**Fecha:** 2026-05-23 (sesión 11)
**Auditor:** Claude Code (Opus 4.7)
**Método:** Lectura directa del PDF (vía `pypdf`) y verificación de cifras, autores, año, citas verbatim contra ficha markdown.

---

## Resumen ejecutivo

| Indicador | Valor |
|-----------|------:|
| Fichas markdown en carpeta | 23 |
| Fichas con `pdf_downloaded: true` | 15 |
| Fichas auditadas a fondo | 8 (las críticas para Cap 1) |
| Verde (cifras y metadatos exactos) | 2 (OPHI2024_BoliviaBriefing, Cerutti_Mansilla2008_DutchDisease) |
| Amarillo (inconsistencias menores / paráfrasis aceptables) | 2 (WorldBank2021_TappingPotential, WorldBank2021_SCDUpdate) |
| Rojo (cifras inventadas, citas fabricadas, metadatos erróneos) | 4 (IMF2025_ArticleIV2024, IMF2025_ArticleIV2025, WorldBank2024_PovertyEquityBrief, UDAPE2025_BrechasSociales, BCB2024_Memoria2023) |

> **Nota crítica:** Cap 1 del APER se apoya principalmente en SCD, IMF Article IV y UDAPE para las cifras macro y de pobreza. Los reportes IMF y UDAPE tienen **citas verbatim fabricadas y cifras con desfases**. La corrección debe ocurrir **antes** de poblar Cap 1.

---

## Detalle por ficha auditada

### 1. WorldBank2021_SCDUpdate.md — 🟡 AMARILLO

**PDF:** 69 páginas, título y autores confirmados. Subtítulo confirmado.

| Cifra ficha | PDF (texto) | Estado |
|-------------|-------------|:------:|
| Crecimiento promedio 4.2% (2006-2019) | PDF dice **"around 4.0 percent between 2014 and 2019"** (no 4.2% en 2006-2019). El 4.2% del PDF refiere a la caída del ingreso por hogar en 2020 | 🟡 |
| Colapso -8.7% en 2020 | PDF dice **"8.8 percent contraction in 2020"** (no -8.7%) | 🟡 |
| Pobreza 60% (2000) → 37% (2019) | Trayectoria gráfica consistente con Figura 3, pero el PDF no afirma esos puntos numéricos textualmente en el rango 2000-2019; menciona reducción de 2.1 pp/año (2005-2014) y 0.9 pp/año (2014-2018). Resultado coherente con el orden de magnitud | 🟡 |
| Pobreza rural ~50% | PDF: "rural poverty was 19 percentage points higher than the urban variant" y "about half the population is poor in Chuquisaca and Potosí". No hay afirmación literal "rural ~50%" pero el orden es consistente. | 🟡 |
| Gini cayó de 0.59 a 0.43 | PDF habla de Gini que **"rose from 0.42 to 0.45"** (durante pandemia, 2019-2020); NO menciona 0.59→0.43. Esta cifra parece tomada de otra fuente (probable SCD original 2015, no SCD Update). | 🔴 |
| Cita verbatim "Rural poverty remains high at around 50 percent…" | **NO aparece** literalmente en el SCD Update. Es una paráfrasis | 🔴 |
| Cita verbatim "The growth model that was successful in the commodity boom is no longer sufficient…" | **NO aparece literal**. El PDF dice "the aggregate demand push partially cushioned the impact of the adverse external conditions"; el sentido es similar pero la cita no es verbatim | 🔴 |

**Acción requerida:**
- Corregir crecimiento a "4.0% en 2014-2019" (o desagregar fases).
- Corregir contracción 2020 a "-8.8%".
- Eliminar la cifra "Gini 0.59 → 0.43" o etiquetar como serie histórica WDI con período distinto al SCD Update.
- Reemplazar las dos citas verbatim por paráfrasis con `cf.` o eliminarlas; no son verbatim del SCD Update 2021.

---

### 2. IMF2025_ArticleIV2024.md — 🔴 ROJO

**PDF:** 85 páginas. Título "Bolivia: 2024 Article IV Consultation" e ID IMF Country Report No. 25/34 confirmados. Marzo 2024 (mission); January 2025 (publication).

| Cifra ficha | PDF (texto) | Estado |
|-------------|-------------|:------:|
| Crecimiento 2023: 2.5% | "growth momentum moderated in 2023, to 2.5 percent" — Press Release | ✅ |
| Proyección 2024: 1.6% | "Growth is anticipated to decelerate to 1.6 percent in 2024" | ✅ |
| Mediano plazo ~2.2-2.3% | "holding at around 2.2-2.3 percent in the medium term" | ✅ |
| Inflación 2024 ~4.5% | "Inflation is forecast to reach 4.5 percent in 2024" | ✅ |
| Deuda pública ~84% del PIB | "Public debt increased to nearly 84 percent of GDP" | ✅ |
| **Subsidio fósil = 3.9% del PIB (2024)** | El PDF reporta para 2023: subsidio energético total 14.4% del PIB (Selected Issues), de los cuales **diésel = 6.6%** y **gasolina = 3.9%**. La Tabla 1 lista "Energy-related subsidies to SOEs" 2024 = **3.5%** (no 3.9%). La cifra 3.9% es solo la **fracción de gasolina** del costo total subsidio 2023, NO el costo total 2024 | 🔴 |
| **"Más de 50% del déficit fiscal 2024 proviene de subsidios"** | Tabla 1: déficit 2024 = -7.9% del PIB; energy subsidies = 3.5%. Ratio 44%. NO es "más de 50%". Sin sustento textual | 🔴 |
| Cita verbatim "Imported fuels are sold at around half of their international price, representing a direct fiscal cost of 3.9 percent of GDP in 2024." | **NO aparece** en el PDF. Frase fabricada | 🔴 |
| Cita verbatim "The current exchange rate peg cannot be sustained with scarce reserves and should be replaced by a new regime." | **NO aparece** en el PDF. El PDF habla de un "crawling peg" y "step devaluation" pero no esa cita literal | 🔴 |

**Acción requerida:**
- Corregir Hallazgo §6: "Subsidio fósil = 3.9% del PIB (2024)" → "Subsidio energético total 2023 estimado en 14.4% del PIB (diésel 6.6% + gasolina 3.9%); proyecciones de subsidios a SOEs 2024 = 3.5% del PIB (Tabla 1, IMF 2025)."
- Eliminar afirmación "más de 50% del déficit fiscal proviene de subsidios" o aportar fuente.
- Eliminar/reemplazar ambas citas verbatim §8.
- Reescribir Snippets ES/EN con cifra corregida.

---

### 3. IMF2025_ArticleIV2025.md — 🔴 ROJO

**PDF:** 86 páginas. Título "Bolivia: 2025 Article IV Consultation" e ID No. 25/116 confirmados. Junio 2025.

| Cifra ficha | PDF (texto) | Estado |
|-------------|-------------|:------:|
| Inflación interanual ~9.5% (nov 2024) | PDF: "pushed inflation to 10 percent at end-2024, the highest level in over a decade" | 🟡 (la cifra es 10%, no 9.5%; aproximación menor) |
| Reservas internacionales agotadas | "Usable foreign exchange reserves have been nearly exhausted for over a year" | ✅ |
| Producción de gas en declive sostenido | "structural decline in gas production" | ✅ |
| **Bolivia 2da economía de menor crecimiento de Sudamérica 2024** | Esta afirmación NO aparece en el PDF; el PDF dice "growth has moderated to 2.1 percent in the first three quarters of 2024". No hace ranking sudamericano | 🔴 |
| **Subsidios = 3.9% del PIB** | Tabla 1: "Energy-related subsidies to SOEs 3.9% (2023) / 4.0% (2024) / 3.4% (2025)". Si se refiere a 2023, sí es 3.9%; si se refiere a 2024, es 4.0%. El año no se especifica → ambigüedad | 🟡 |
| Cita verbatim "Pressing macroeconomic imbalances—low reserves, parallel exchange rate premia, and elevated fiscal deficits—require decisive action." | **NO aparece** en el PDF | 🔴 |

**Acción requerida:**
- Corregir Hallazgo §6: "Inflación 10% a fin de 2024 (no 9.5%)".
- Eliminar afirmación "Bolivia 2da economía de menor crecimiento" o citar fuente.
- Reemplazar cita verbatim §8 por paráfrasis o por una cita verdadera del Executive Board Assessment.

---

### 4. WorldBank2021_TappingPotential.md — 🟡 AMARILLO

**PDF:** 172 páginas. Título y autoría confirmados.

| Cifra ficha | PDF (texto) | Estado |
|-------------|-------------|:------:|
| "Crecimiento agro ~2.8% promedio desde 1991; ~4.9% desde 2013" | El 4.9% aparece literal ("with particularly dynamic growth (at about 4.9 percent) since 2013"). El 2.8% aparece en una tabla "Bolivia 2.8 4.5" pero contexto poco claro (probable comparación pop. crecimiento ≠ ag. growth). | 🟡 |
| Yields entre los más bajos LAC | PDF: "yields of practically all crops grown in Bolivia are quite low compared to yields in [otras zonas]" — paráfrasis aceptable | ✅ |
| Expansión de área dominó sobre intensificación | PDF: "Agricultural growth in Bolivia has largely been based on the expansion of agricultural area, accompanied by input intensification" (verbatim ✅) | ✅ |
| Cita verbatim "Agricultural growth in Bolivia has largely been based on the expansion of agricultural area, accompanied by input intensification." | Verbatim verificada | ✅ |
| Cita verbatim "Yields are among the lowest in the region." | Esta frase exacta NO aparece. Es una paráfrasis de "yields … are quite low compared to yields in [other countries]" | 🟡 |

**Acción requerida:**
- Especificar contexto del "2.8%" — verificar tabla específica.
- Marcar la segunda cita como paráfrasis (no verbatim).

---

### 5. OPHI2024_BoliviaBriefing.md — ✅ VERDE

**PDF:** 13 páginas. Título "Bolivia Country Briefing October 2024" confirmado, autoría OPHI/UNDP, metodología Alkire-Foster.

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| Intensidad (A) = 41.7% | Tabla 1: A=41.7% (Nacional) ✅ | ✅ |
| MPI armonizado 2003-2016 | "trends … between 2003 and 2016 using a harmonised version" ✅ | ✅ |
| Carencias en cocina, saneamiento, escolaridad | Coherente con el contenido del briefing | ✅ |
| Cita verbatim "The intensity of deprivations in Bolivia is 41.7 percent." | El valor 41.7% es real; la frase exacta no aparece pero es una traducción literal directa de la tabla | 🟡 (cita = paráfrasis) |

**Acción requerida:** marcar la cita §8 como paráfrasis o citarla con `cf.`. Sin acción mayor.

---

### 6. WorldBank2024_PovertyEquityBrief.md — 🔴 ROJO

**PDF:** 2 páginas. Título "Poverty & Equity Brief / Bolivia / Latin America & the Caribbean / April **2023**" (no 2024). Datos hasta 2021/2022.

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| **Año = 2024** | El brief es de **April 2023** (impreso en el encabezado del PDF). La ficha y BibTeX lo citan como "2024" | 🔴 |
| Pobreza nacional 36.4-36.5% (2021-2023) | PDF reporta 36.4% en 2021 (oficial); proyecta estancamiento a 2023. Ficha exagera al decir "36.5% en 2023" — el PDF no afirma esa cifra para 2023 | 🟡 |
| Pobreza rural ~50% | El PDF muestra "Rural population: 60 [poor] / 94 [non-poor]" en una distribución, lo que NO permite leer "50%" directo. El brief no afirma "rural ~50%" | 🟡 |
| Gini ~0.41 | "Gini Index 40.9 (2021)" / "41.3 en 2022" ✅ | ✅ |
| Cita verbatim "Rural poverty remained especially high at 35-50 percent." | **NO aparece** en el PDF. Frase fabricada | 🔴 |
| Period_covered: "2000-2023" | El brief reporta datos 2016-2022 (algunos 2021); no es 2000-2023 | 🟡 |

**Acción requerida:**
- Corregir año a 2023 en title, frontmatter, BibTeX, citekey si aplica.
- Eliminar cita verbatim §8 o reemplazar por una cita real.
- Ajustar `period_covered` y verificar exactitud de "rural ~50%".

---

### 7. UDAPE2025_BrechasSociales.md — 🔴 ROJO

**PDF:** 90 páginas. Título oficial: **"Brechas Sociales en Bolivia: Un Análisis de la Desigualdad en Cifras (2005-2024)"** (no "Brechas Sociales en Bolivia 2025" como pone la ficha). La Paz, 2025.

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| Title: "Brechas Sociales en Bolivia 2025" | Título real es "Brechas Sociales en Bolivia: Un Análisis de la Desigualdad en Cifras (2005-2024)". Subtítulo perdido | 🟡 |
| Período: 2010-2023 | Período real del análisis: **2005-2024** (consta en portada y texto) | 🔴 |
| Pobreza nacional ~36.5% (2023) | El PDF muestra 36,5% como un valor en figura, pero el texto enfatiza pobreza extrema 12,8% en **2024** y reducción de 23 pp en 2005-2024. El año "2023" para 36,5% no está corroborado explícitamente | 🟡 |
| Pobreza extrema ~11.9% | El PDF dice pobreza extrema 12,8% en 2024 (no 11.9%). Posible cifra para otro año no especificado | 🔴 |
| **Pobreza infantil ~47%** | **NO aparece** la cifra "pobreza infantil 47%" en el PDF. La cifra 47% sale repetidamente en contextos de cobertura de salud, seguros, etc. — NO de pobreza infantil | 🔴 |
| **Extrema infantil ~16.9%** | **NO aparece** este valor en el PDF | 🔴 |
| Cita verbatim "La pobreza en la población general alcanzó 36.5% en 2023; en la población infantil el dato es de 47%." | **NO aparece**. Frase compuesta, fabricada | 🔴 |

**Acción requerida:**
- Corregir título a "Brechas Sociales en Bolivia: Un Análisis de la Desigualdad en Cifras (2005-2024)".
- Corregir `period_covered: "2005-2024"`.
- **Eliminar** los puntos "Pobreza infantil ~47%" y "Extrema infantil ~16.9%" (inventados) o relocalizar con fuente alternativa.
- Reemplazar la cita §8 por una cita verbatim real del documento (ej. la frase sobre reducción de 23 pp entre 2005 y 2024).

---

### 8. BCB2024_Memoria2023.md — 🟡 AMARILLO

**PDF:** 14 páginas (¿extracto?). Título "MEMORIA 2023 BANCO CENTRAL DE BOLIVIA" confirmado. Editorial BCB confirmado.

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| PIB 2023: ~2.5% | El PDF da **"Tasa anual de crecimiento del PIB ... 2,31 p" (preliminary)** para 2023. La ficha dice 2.5% (cifra IMF, no BCB). Inconsistencia interna | 🔴 |
| Inflación 2023: ~2-3% | PDF: "Inflación acumulada en el año ... 2,12" (2023). La aproximación "~2-3%" es laxa pero defendible | 🟡 |
| Política monetaria expansiva controlada | Coherente con la narrativa del BCB | ✅ |
| Cita "El Banco Central de Bolivia mantuvo la estabilidad de precios pese al contexto externo adverso." | No verificada literal; es paráfrasis aceptable de la narrativa BCB pero NO una cita verbatim | 🟡 |

**Acción requerida:**
- Corregir PIB 2023 a 2.31% preliminary (cifra BCB Memoria) y aclarar que IMF reporta 2.5% (revisión posterior).
- Marcar cita §8 como paráfrasis (no verbatim).

---

### 9. Cerutti_Mansilla2008_DutchDisease.md — ✅ VERDE

**PDF:** 22 páginas, IMF Working Paper WP/08/154, autores Eugenio Cerutti & Mario Mansilla, 2008. Confirmado todo.

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| Aporta ~1pp al crecimiento del PIB | El PDF no afirma exactamente "1 percentage point"; sí habla del gas como "important source of GDP growth" — aproximación razonable | 🟡 |
| Cita verbatim "The hydrocarbons sector has become one of the most dynamic economic activities in the Bolivian economy and the main driver of improved export performance." | Verbatim verificada (Introduction) | ✅ |
| Otros puntos cualitativos | Coherentes con la introducción y conclusión | ✅ |

**Acción requerida:** ninguna mayor; opcionalmente verificar la atribución "~1 pp/año" con una sección específica del paper.

---

## Síntesis: cifras inventadas o citas fabricadas a corregir antes de Cap 1

1. **IMF2025_ArticleIV2024**: cita verbatim "Imported fuels are sold at around half of their international price…" → no existe en el PDF.
2. **IMF2025_ArticleIV2024**: cita verbatim "The current exchange rate peg cannot be sustained with scarce reserves…" → no existe.
3. **IMF2025_ArticleIV2025**: cita verbatim "Pressing macroeconomic imbalances—low reserves, parallel exchange rate premia…" → no existe.
4. **IMF2025_ArticleIV2024**: cifra "Subsidio fósil = 3.9% del PIB (2024)" → en realidad es solo la fracción de gasolina del 14.4% total 2023.
5. **IMF2025_ArticleIV2024**: "Más de 50% del déficit fiscal de subsidios" → no sustentado.
6. **IMF2025_ArticleIV2025**: "Bolivia 2da economía de menor crecimiento de Sudamérica 2024" → no aparece en el PDF.
7. **WorldBank2021_SCDUpdate**: Gini "0.59 → 0.43" → el SCD Update no afirma esos valores; el PDF habla de Gini 0.42→0.45 durante pandemia.
8. **WorldBank2021_SCDUpdate**: dos citas verbatim §8 → no aparecen literal en el SCD Update.
9. **WorldBank2024_PovertyEquityBrief**: año real es 2023, no 2024.
10. **WorldBank2024_PovertyEquityBrief**: cita "Rural poverty remained especially high at 35-50 percent" → no existe.
11. **UDAPE2025_BrechasSociales**: título de la ficha pierde subtítulo; período mal etiquetado.
12. **UDAPE2025_BrechasSociales**: "Pobreza infantil ~47%" y "Extrema infantil ~16.9%" → no aparecen en el PDF.
13. **UDAPE2025_BrechasSociales**: cita verbatim §8 → frase compuesta fabricada.
14. **BCB2024_Memoria2023**: PIB 2023 "2.5%" → BCB reporta 2.31% preliminar.

---

## Métricas finales

- Fichas auditadas: **9** (de 15 con PDF descargado).
- Confirmadas (verde): **2/9 = 22%**.
- Amarillo (paráfrasis o redondeos menores): **3/9 = 33%**.
- Rojo (alucinación crítica): **4/9 = 45%**.

**Recomendación operativa:** las fichas IMF2025_ArticleIV2024, IMF2025_ArticleIV2025, WorldBank2024_PovertyEquityBrief y UDAPE2025_BrechasSociales deben **corregirse y revalidar** antes de citarlas en el reporte técnico. Las citas verbatim fabricadas son el riesgo reputacional más alto si se incluyen en el reporte WB.
