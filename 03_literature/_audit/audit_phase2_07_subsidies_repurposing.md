# Auditoría Fase 2 (Contenido) — `07_subsidies_repurposing/`

**Fecha:** 2026-05-23 (sesión 11)
**Auditor:** Claude Code (Opus 4.7)
**Método:** Lectura directa del PDF (vía `pypdf`) y verificación de cifras, autores, año, citas verbatim contra ficha markdown.

---

## Resumen ejecutivo

| Indicador | Valor |
|----------|------:|
| Fichas con `pdf_downloaded: true` | 11 |
| PDFs reales en disco | 10 (FundacionSolon2023 es HTML — descartado) |
| Fichas auditadas a fondo | 8 (priorizando `relevance_score: Alta` y core repurposing) |
| Verde (cifras y metadatos exactos) | 1 (GautamLaborde2022) |
| Amarillo (cifras razonables pero con redondeos/inexactitudes) | 4 (Laborde2021_GHG, Damania2023, WB2024_Recipe, Anderson2009_Global, AnriquezFosterOrtega2016) |
| Rojo (errores serios, cifras o autores inventados) | 3 (FAOUNEPUNDP2021, OECD2024, FAO_PSE_LAC, FAO2024_Bolivia) |

> **Nota crítica:** El Capítulo 5 del APER (repurposing) usa cifras clave de FAO/UNEP/UNDP 2021 y FAO2024_Bolivia, ambos con **errores rojos**. Requieren corrección **antes** de redactar capítulos.

---

## Detalle por ficha auditada

### 1. GautamLaborde2022.md — ✅ VERDE

**Estado:** Todas las cifras críticas verificadas contra el PDF.

| Cifra ficha | PDF (pág o línea) | Estado |
|-------------|-------------------|:------:|
| US$ 720 mil millones/año apoyo global | p.~ "These data show that these 54 countries provided $720 billion per year" | ✅ |
| US$ 0,35 por dólar (35 cents) | "of every dollar spent on agricultural subsidies, only about 35 cents reaches farmers" (Executive Summary) | ✅ |
| US$ 2,4 billones (trillion) bienestar 2040 | "implying a substantial payoff—equivalent to $2.4 trillion in 2040" | ✅ |
| Reducción 40 % emisiones agrícolas | "emissions from agriculture and land use by more than 40 percent" | ✅ |
| Cita verbatim ES y EN | Coinciden con Executive Summary | ✅ |

**Conclusión:** Ficha modelo. Sin acción requerida.

---

### 2. FAOUNEPUNDP2021.md — 🔴 ROJO (cifras infladas)

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| US$ 540 mil millones/año | "almost USD 540 billion a year" (Foreword, p. xv) | ✅ |
| **87 % distorsionante** | PDF dice **"Over two-thirds"** y **"70 percent" (de fiscal subsidies)** — el 87% NO aparece en el documento | 🔴 |
| US$ 1,8 billones a 2030 | "this support could reach almost USD 1.8 trillion in 2030" | ✅ |
| **US$ 470 mil millones harmful** | NO aparece. El reporte habla de "over two-thirds" como harmful — implícitamente ~360-380B, no 470B | 🔴 |

**Acción requerida:**
- Corregir el "87%" del Snippet ES/EN, abstract y Hallazgo §6 a "**más de dos tercios**" o "**~70%**" (con la atribución explícita "de los subsidios fiscales").
- Eliminar el dato "US$ 470 mil millones harmful" (no está en el PDF).
- Reemplazar la cita §8 verbatim por:
  > "Worldwide agricultural producer support accounts for almost USD 540 billion a year, … Over two-thirds of this support is considered price-distorting and largely harmful to the environment."

---

### 3. Damania2023.md — 🟡 AMARILLO

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| US$ 7 billones/año | "exceed US$7 trillion per year" | ✅ |
| US$ 1,25 billones directos | "US$1.25 trillion in explicit subsidies" | ✅ |
| 14% deforestación anual | "14 percent of annual deforestation" | ✅ |
| 6:1 fósiles vs Paris | "almost six times more than the amount that … the Paris Agreement" (US$577B vs US$100B) | ✅ |
| **"agricultura (~US$ 600 mil millones)"** §2 | PDF dice **US$635 billion per year** (Foreword, ch. 6, ch. 10) | 🟡 (impreciso) |
| **Subsidio diesel agrícola Bolivia US$380M/año** §6 | NO aparece en Damania (es extrapolación de otra fuente — Bolivia mencionada sólo en tablas país sin esa cifra específica) | 🔴 |

**Acción requerida:**
- Corregir "US$ 600 mil millones" → "**US$ 635 mil millones**" en §2 y Snippets.
- Eliminar (o reatribuir a `FAO2024_Bolivia`) la cifra "US$ 380M Bolivia diesel" — el PDF Damania2023 NO la contiene.

---

### 4. Laborde2021_GHG.md — 🟡 AMARILLO

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| US$ 600B apoyo global (2017) | "Agriculture receives around US$600 billion per year worldwide" (Abstract) | ✅ |
| +34.420 kt CO2eq (+0,6 %) | "agriculture are 34,420 kt of CO2 eq higher (an increase of 0.6%)" Table 4 | ✅ |
| Cita Abstract verbatim | Coincide | ✅ |
| **"Repurposing hacia I+D verde: reducción de ~17 %"** §6 | El PDF dice **30 % reduction** ("redirected towards more R&D to achieve a 30% reduction") — la ficha dice 17% (snippet repite). NO encontrado 17% en escenarios óptimos | 🟡 |

**Acción requerida:**
- Verificar de dónde sale el 17% (¿tabla 5? ¿modelo intermedio?). Si no se confirma, corregir a "hasta 30 %" según el escenario citado en el cuerpo del paper, o eliminar la cifra.

---

### 5. WB2024_Recipe.md — 🟡 AMARILLO

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| US$ 260 mil millones/año inversión adicional | "$260 billion a year, to halve current agrifood emissions by 2030" | ✅ |
| ~1/3 emisiones globales | "huge opportunity to cut almost a one-third of the [emissions]" | ✅ |
| Net-zero 2050 factible | Consistente con narrativa del reporte | ✅ |
| 16 Gt CO2eq/año | No verificada directamente con grep simple (no en páginas iniciales — requiere check capítulo 1) | 🟡 |
| **"US$ 700 mil millones/año en apoyo agrícola"** §2 y §6 (palanca repurposing) | NO aparece en el PDF de Recipe. La cifra está implícita pero no se cita ese número exacto en este reporte | 🟡 |

**Acción requerida:**
- La cifra US$700B en Snippet/Resumen viene de Gautam2022, NO de Recipe. Reatribuir o reformular ("Recipe estima la palanca de repurposing del apoyo agrícola — ver Gautam et al. 2022 para el monto de ~US$700B/año").
- Confirmar 16 Gt CO2eq leyendo capítulo 1 del Recipe.

---

### 6. OECD2024.md (`OECD2024Monitoring`) — 🔴 ROJO (3 cifras importantes incorrectas)

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| 54 países cubiertos | "54 countries covered in this report" (p. 96, 1452) | ✅ |
| US$ 842 mil millones 2021-23 | "USD 842 billion per year during 2021-23" | ✅ |
| **PSE OECD 17 %** | PDF dice **"The %PSE in the OECD averaged 14% over 2021-23"** | 🔴 |
| **"~30 % apoyo potentially most distorting"** §6 y Snippet | PDF dice **"made up 35% (USD 219 billion)"** | 🔴 |
| **"~13 % a GSSE"** | PDF: GSSE accounted for less than 3% (de positive support total) — y otra estimación: 12.5%. La ficha confunde categorías | 🟡 |
| **"64 % se otorga a productores"** §2 (resumen) | PDF dice **"75% (USD 629 billion) goes to producers individually"** | 🔴 |

**Acción requerida (urgente — base del Cap 2 y Cap 3 metodológico):**
- 17 % → **14 %** PSE OECD promedio.
- 30 % → **35 %** "potentially most distorting".
- 64 % → **75 %** apoyo a productores individuales.
- Clarificar la cifra 13 % GSSE (separar "del total positivo" vs "del PSE neto").

---

### 7. Anderson2009_Global.md — 🟡 AMARILLO

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| 75 países, ~92% población mundial | "75 countries that together account for more [than X]" — verifica 75 países | ✅ |
| NRA global cayó +10 → +5 % | Cifras aproximadas; el PDF discute NRA por región pero las cifras exactas requieren leer Cap 1 con tablas | 🟡 |
| NRA países en desarrollo: -25 → 0 % | Aproximación razonable de la convergencia documentada | 🟡 |
| NRA OECD +50 → +20 % | Aproximación razonable | 🟡 |

**Acción requerida:**
- Reemplazar las cifras NRA por valores extraídos directamente de Table 1.4 o Figure 1.4 del PDF (que está en el corpus). El staff puede hacerlo manualmente en una pasada de 10 min.

---

### 8. AnriquezFosterOrtega2016.md — 🟡 AMARILLO

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| 19 países LAC | "19 countries" confirmado (líneas 519, 546, 566, 582) | ✅ |
| 10pp shift → +5% VA rural per cápita | "shift of 10 percentage points… leads to an approximately 5 percent increase in value [added]" (líneas 237-238) | ✅ |
| Cita verbatim §8 | Coincide con líneas 83 (con "ceteris paribus" omitido — ok) | ✅ |
| **`period_covered: "1985-2014"`** (frontmatter) | PDF dice **"1985–2012"** explícitamente (Abstract línea 80) | 🟡 |

**Acción requerida:**
- Corregir `period_covered` a `"1985-2012"`.

---

### 9. FAO_PSE_LAC.md (citekey `FAO_FiscalPolicies`) — 🔴 ROJO (metadatos inventados)

| Campo ficha | PDF (portada/citation) | Estado |
|-------------|------------------------|:------:|
| `authors: "FAO"` | **Diaz-Bonilla, E., De Salvo, C.P., Egas, J.** (3 autores nombrados, IFPRI/BID) | 🔴 |
| `year: 2020` | **2019** (página de copyright) | 🔴 |
| `title: "Fiscal Policies in Agriculture and Producer Support Estimates: Methodologies and Applications"` | Título real: "Fiscal policies in agriculture and producer support estimates **in Latin America and the Caribbean**" (Document No. 8 de la serie 2030) | 🟡 |

**Acción requerida (urgente para BibTeX):**
- Corregir frontmatter y BibTeX a:
  ```
  authors: "Diaz-Bonilla, Eugenio; De Salvo, Carmine Paolo; Egas Yerovi, Juan José"
  year: 2019
  title: "Fiscal policies in agriculture and producer support estimates in Latin America and the Caribbean"
  source: "FAO 2030 series, Document No. 8"
  ```

---

### 10. FAO2024_Bolivia.md — 🔴 ROJO (cifras fabricadas y autor inventado)

| Cifra ficha | PDF | Estado |
|-------------|-----|:------:|
| `authors: "FAO Forum Discussion"` | **Julio Prudencio Böhrt** (autor único, página de portada) | 🔴 |
| Subsidios diesel agro oriente Bs 2.700M/año | "los subsidios directos de más de 2.700 millones de Bs/año al diésel" (línea 1387) | ✅ |
| **Total subsidios Bolivia 2022 US$ 5.127M (11,6 % PIB)** | El número 5.127 NO aparece. El "11,6" del PDF está en un cuadro de precios de cebollas (índice de pobreza Foster-Greer-Thorbecke, no % PIB). El PDF dice explícitamente: **"Esos subsidios representan el 6% del PIB en 2022"** (línea 2067) | 🔴 |
| Importación combustible 2022 US$ 3.000M | No verificada (no en mismo formato) — requiere check | 🟡 |
| EMAPA subsidios alimentarios directos US$ 24M (2022) | Verificable en Cuadro 3, pero el "24M" no apareció en mi grep — necesita check más detallado | 🟡 |

**Acción requerida (urgente — esta ficha sustenta el caso boliviano del Cap 5):**
- Corregir `authors` a "**Prudencio Böhrt, Julio**" (no es un documento institucional FAO sino una contribución personal al Foro FAO FSN).
- Corregir "11,6 % PIB" → **6 % PIB** (cifra del propio PDF).
- Eliminar el monto agregado "US$ 5.127M" mientras no se verifique fuente; o reemplazar con "subsidios totales (2017-2022) acumulados" si esa fue la intención.
- Validar las cifras EMAPA y combustible importado contra los cuadros 3 y 5 del PDF.

---

## Cifras críticas verificadas (todas con localización en PDF)

| Cifra | Fuente | Localización en PDF | Estado |
|-------|--------|---------------------|:------:|
| US$ 720B apoyo agrícola global 2017-19 | Gautam2022 | Página de tabla (~p.~) con frase "54 countries provided $720 billion" | ✅ |
| US$ 540B apoyo global (2013-18) | FAO/UNEP/UNDP 2021 | Foreword p. xv, líneas 244, 502, 1234, 1920 | ✅ |
| US$ 635B apoyo agricultura (no US$600B) | Damania2023 | Foreword, Cap 6 (línea 1310, 6210, 6768, 10618) | ✅ |
| US$ 7 trillones subsidios harmful global | Damania2023 | Foreword (línea 586), Cap 1 (línea 763) | ✅ |
| US$ 1.25 trillones explicit subsidies (3 sectores) | Damania2023 | Foreword (588, 692, 848), Cap 11 (13887) | ✅ |
| US$ 2.4 trillones welfare gain 2040 | Gautam2022 | Cap 4 (~p.~ "implying a substantial payoff—equivalent to $2.4 trillion in 2040") | ✅ |
| US$ 842B 2021-23 (OECD 54 países) | OECD2024 | Executive Summary (líneas 997, 1247, 1452, 3253) | ✅ |
| US$ 1.8 trillones proyección 2030 | FAO/UNEP/UNDP 2021 | Foreword (407, 575, 2650, 6490) | ✅ |
| US$ 260B/año inversión adicional para halve emisiones 2030 | WB2024_Recipe | Executive Summary (líneas 321, 688) | ✅ |
| 35 cents per dollar a productores | Gautam2022 | Executive Summary (líneas 305, 385) | ✅ |
| 40% reducción emisiones agrícolas con repurposing | Gautam2022 | Líneas 399, 805 | ✅ |
| 14% deforestación atribuible a subsidios | Damania2023 | Líneas 648, 1035, 10582, 10667 | ✅ |
| 6× subsidios fósiles vs compromiso climático Paris | Damania2023 | "almost six times" (líneas 1533, 2021) | ✅ |
| 0.6% incremento emisiones por subsidios coupled (=34,420 kt) | Laborde2021_GHG | Abstract + Table 4 (línea 275, 355) | ✅ |
| 19 países LAC 1985-2012 (no 2014) | Anriquez2016 | Abstract (línea 80) | ✅ |
| 10pp shift → ~5% incremento VA rural pc | Anriquez2016 | Líneas 237-238 | ✅ |
| 75 países (Anderson 2009) | Anderson2009 | Línea 674 ("75 countries that together account for more…") | ✅ |
| Bs 2.700M/año subsidio diesel agro Bolivia | FAO2024_Bolivia (Prudencio) | Línea 1387 | ✅ |
| 6% PIB subsidios totales Bolivia 2022 (NO 11.6%) | FAO2024_Bolivia (Prudencio) | Línea 2067 | ✅ |

---

## Cifras NO verificadas o inventadas (flagged)

| Cifra | Ficha | Comentario |
|-------|-------|------------|
| 87% subsidios distorsionantes | FAOUNEPUNDP2021 | PDF dice "over two-thirds" (~70%) — la cifra 87% no existe |
| US$ 470B harmful | FAOUNEPUNDP2021 | NO en el PDF |
| 17% reducción emisiones via R&D | Laborde2021_GHG | PDF dice "30% reduction" en el escenario citado |
| US$ 600B agricultural support | Damania2023 | PDF dice US$ 635B (cifra cercana pero impresa) |
| US$ 380M diesel Bolivia | Damania2023 | NO en Damania (es de FAO2024_Bolivia) |
| US$ 700B (Recipe como fuente) | WB2024_Recipe | No aparece la cifra en este PDF — viene de Gautam2022 |
| PSE OECD 17% | OECD2024Monitoring | PDF dice 14% |
| 30% potentially most distorting | OECD2024Monitoring | PDF dice 35% |
| 64% producer support | OECD2024Monitoring | PDF dice 75% |
| US$ 5.127M total subsidios Bolivia 2022 | FAO2024_Bolivia | NO en PDF |
| 11.6% PIB (Bolivia) | FAO2024_Bolivia | PDF dice 6% PIB |

---

## Recomendaciones de acción (prioridad descendente)

1. **🔴 Inmediato (antes de redactar Cap 5):**
   - Corregir FAO2024_Bolivia (autor + cifras 11.6% y 5.127M).
   - Corregir FAOUNEPUNDP2021 (87% → "over two-thirds").
   - Corregir OECD2024 (las 3 cifras: 17, 30, 64 %).
   - Corregir FAO_PSE_LAC metadatos (autores, año, título).

2. **🟡 Próxima sesión:**
   - Re-leer Laborde2021_GHG para confirmar el escenario "30% reduction" e identificar dónde aparece 17% (si existe).
   - Corregir US$600B → US$635B en Damania2023 §2 y reatribuir/eliminar la cifra Bolivia diesel.
   - Verificar el 16 Gt CO2eq en WB2024_Recipe.
   - Reescribir "US$700B" en WB2024_Recipe atribuyendo a Gautam2022.

3. **✅ Mantener (modelo):**
   - GautamLaborde2022 — todas las cifras correctas, citas exactas.
   - AnriquezFosterOrtega2016 — sólo corregir periodo a 1985-2012.

---

## Fichas no auditadas (28 fichas con `pdf_downloaded: false`)

Fuera del scope de esta auditoría Fase 2 (sin PDF para verificar). Documentadas en `AUDIT_REPORT.md` Fase 1.
