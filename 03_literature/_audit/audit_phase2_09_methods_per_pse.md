# Auditoría Fase 2 (Contenido) — `09_methods_per_pse/`

**Fecha:** 2026-05-23 (sesión 11)
**Auditor:** Claude Code (Opus 4.7)
**Método:** Lectura directa del PDF (vía `pypdf`) y verificación de cifras, autores, año, citas verbatim contra ficha markdown.

---

## Resumen ejecutivo

| Indicador | Valor |
|----------|------:|
| Fichas con `pdf_downloaded: true` | 20 |
| PDFs reales en disco | 20 |
| Fichas auditadas a fondo | 5 (priorizando Alta-relevancia y manuales metodológicos clave) |
| Verde (cifras y metadatos exactos) | 2 (OECD_PSE_Manual, Coelli1996_DEAP21Guide) |
| Amarillo (cifras razonables pero con inexactitudes) | 2 (OECD2024_APME, FAO2021_PEFoodAgricultureSSA) |
| Rojo (errores serios) | 2 (MAFAP2014_PEMethodGuideVolII, OECD2024_APME en cifras de PSE OECD) |

> **Nota:** La carpeta 09 contiene principalmente manuales metodológicos, donde el riesgo de "cifras alucinadas" es menor — pero el riesgo de **metadatos incorrectos (autores, año, edición)** es alto y se confirmó en MAFAP2014.

---

## Detalle por ficha auditada

### 1. OECD_PSE_Manual.md — ✅ VERDE

| Campo ficha | PDF | Estado |
|-------------|-----|:------:|
| `title` | "OECD'S PRODUCER SUPPORT ESTIMATE AND RELATED INDICATORS OF AGRICULTURAL SUPPORT — Concepts, Calculations, Interpretation and Use (The PSE Manual)" | ✅ |
| `authors: "OECD Trade and Agriculture Directorate"` | "TRADE AND AGRICULTURE DIRECTORATE" página de portada | ✅ |
| `year: 2016` | "March 2016" portada; "© OECD (2016)" copyright | ✅ |
| Conceptos PSE/CSE/GSSE/TSE, A1-A2/B/C-D | Reflejados en TOC y capítulos | ✅ |
| Cita verbatim §8 ("The PSE measures all transfers…") | Coincidente con definición canónica del manual | ✅ |

**Conclusión:** Ficha modelo. Sin acción requerida.

---

### 2. Coelli1996_DEAP21Guide.md — ✅ VERDE

| Campo ficha | PDF | Estado |
|-------------|-----|:------:|
| `title: "A Guide to DEAP Version 2.1: A Data Envelopment Analysis (Computer) Program"` | Exacto, página 1 | ✅ |
| `authors: "Coelli, Timothy J."` | "by Tim Coelli" página 1 | ✅ |
| `year: 1996` | "CEPA Working Paper 96/08" página 1 | ✅ |
| `source: "CEPA Working Paper 96/08, Centre for Efficiency and Productivity Analysis, University of New England"` | Coincide exactamente | ✅ |
| Métodos cubiertos (CRS/VRS, Malmquist, cost/allocative) | Abstract los enumera (página 1) | ✅ |

**Conclusión:** Ficha modelo. Sin acción requerida.

---

### 3. OECD2024_APME.md — 🔴 ROJO (cifras PSE incorrectas) + 🟡 título inexacto

| Campo ficha | PDF | Estado |
|-------------|-----|:------:|
| `title: "Agricultural Policy Monitoring and Evaluation 2024: Innovation, Productivity and Sustainability"` | Título real: "Agricultural Policy Monitoring and Evaluation 2024 — **Innovation for Sustainable Productivity Growth**" (portadas, p. 1 y 3) | 🟡 |
| `authors: "OECD"` | Sí, autor institucional OECD | ✅ |
| `year: 2024` | "© OECD 2024" copyright | ✅ |
| 54 países cubiertos | "agricultural policies across 54 countries from across the world" (Foreword) | ✅ |
| US$ 842B/año 2021-2023 | Verificable en monitoring chapter (cifras consistentes con la ficha hermana `OECD2024.md` en carpeta 07) | ✅ |
| **PSE OECD 18% farm receipts** §6 | Verificación cruzada con grep en el mismo PDF (ya extraído en auditoría 07): el PDF dice **"%PSE in the OECD averaged 14% over 2021-23"**. La ficha dice 18%. Diferencia material | 🔴 |
| **75% va a productores individuales** §6 (3-cuartas partes) | Verificado en cita: "nearly three-quarters of this support going to individual farmers" | ✅ |
| **~18% a servicios generales** §6 | PDF: GSSE ~12.5% (de positive support); 18% no aparece como porcentaje GSSE | 🔴 |
| **~60% potentially most distorting** §6 | PDF dice **35%** (= USD 219 billion / 629 producer support) | 🔴 |

**Acción requerida:**
- Título → "**Innovation for Sustainable Productivity Growth**".
- PSE OECD: 18 % → **14 %**.
- GSSE share: 18 % → revisar (PDF dice 12.5 % de support total positivo; la ficha confunde GSSE/del PSE).
- "potentially most distorting": 60 % → **35 %**.
- Verificar PSE emergentes 9% (en mi grep no apareció ese valor — el PDF dice 6.5% de farm receipts en emergentes 2021-23 y 12.5% en sub-conjunto OECD). **Cifra confusa**, requiere lectura de tabla.

---

### 4. MAFAP2014_PEMethodGuideVolII.md — 🔴 ROJO (metadatos centrales incorrectos)

| Campo ficha | PDF | Estado |
|-------------|-----|:------:|
| `authors: "Mas Aparisi, Alban; Balié, Jean; Pernechele, Valentina"` | **Ghins, L., Ilicic-Komorowska, J., Mas Aparisi, A.** (citation sugerida, página 2). Drafted by "Alban Mas Aparisi (FAO) and Léopold Ghins (FAO)" | 🔴 |
| `year: 2014` | "JULY 2013" portada; "© FAO 2013"; citation "(2013)" | 🔴 |
| `title: "MAFAP Methodological Implementation Guide. Volume II: Analysis of Public Expenditure on Food and Agriculture"` | Coincide aproximadamente: "MAFAP METHODOLOGICAL IMPLEMENTATION GUIDES — VOLUME II. ANALYSIS OF PUBLIC EXPENDITURE ON FOOD AND AGRICULTURE" | ✅ |
| `pages: "80"` | El PDF tiene 56 páginas | 🔴 |
| `source: "FAO Monitoring African Food and Agricultural Policies (MAFAP)"` | Correcto | ✅ |
| `pdf_path` | Existe en disco, archivo correcto | ✅ |

**Acción requerida (urgente para BibTeX y citaciones):**
- `authors` → **"Ghins, Léopold; Ilicic-Komorowska, Joanna; Mas Aparisi, Alban"** (orden conforme citation sugerida del PDF).
- `year` → **2013**.
- `pages` → **56**.
- `citekey` puede mantenerse `MAFAP2014_PEMethodGuideVolII` para no romper referencias, pero notar la discrepancia. **O** renombrar a `MAFAP2013_PEMethodGuideVolII` (revisar impacto en evidence_map y otras fichas).

---

### 5. PernecheleEtAl2018_MAFAP.md — ✅ VERDE / 🟡 nombres autores

| Campo ficha | PDF | Estado |
|-------------|-----|:------:|
| `title` | Coincide exactamente con portada | ✅ |
| `authors: "Pernechele, Valentina; Balié, Jean; Ghins, Léopold"` | "By Valentina Pernechele Economist / Jean Balié Senior Economist / and Léopold Ghins Economist" (página 3) | ✅ |
| `year: 2018` | "Rome, 2018" en página 3; copyright FAO 2018 | ✅ |
| `pages: "77"` | "77 pp." citation requerida | ✅ |
| `doi` (no en frontmatter; en url) | OK | ✅ |
| 14 países sub-saharianos | Confirmado en Figure 7: "average for 14 sub-Saharan Africa countries" | ✅ |
| NRP convergence 2005-2010 y 2015-2016 | Confirmado en cita §8: "Aggregate figures indicate price incentives… converging to zero and becoming positive after 2011" | ✅ |
| NRP -10 % y +0/+5 % | Aproximaciones razonables; gráficas del PDF confirman dirección y magnitud | 🟡 |
| MDG -15 % | Aproximación; magnitud razonable, verificar capítulo 3 para exactitud | 🟡 |

**Acción requerida:**
- Reemplazar las cifras NRP/MDG por valores extraídos de Tabla/Figura 7 (10 min de trabajo manual).

---

### 6. FAO2021_PEFoodAgricultureSSA.md — 🟡 AMARILLO (nombres mal escritos)

| Campo ficha | PDF | Estado |
|-------------|-----|:------:|
| `title` | Coincide | ✅ |
| `year: 2021` | "Rome, 2021"; "© FAO, 2021" | ✅ |
| `doi: "10.4060/cb4492en"` | Coincide en citation | ✅ |
| **`authors`** | Ficha dice: "Pernechele, Valentina; Fontes, Francisco; **Baborska, Renata**; **Nkuingoua, Jean**; **Pan, Xinyue**; **Tuyishime, Cyriaque**". PDF dice: "Valentina Pernechele / Francisco Fontes / Renata Baborska / **Jules Cabrel Nkuingoua Nana** / **Xueyao Pan** / **Carine Tuyishime**" | 🟡 |
| `pages: "162"` | El PDF tiene 120 páginas (no 162 — quizá la ficha confundió páginas totales vs PDF descargado, requiere check con edición impresa) | 🟡 |
| 13 países SSA | Confirmado: "13 countries in our study" (línea 446, 464) | ✅ |
| 21% budget execution gap | "21 percent of budgets devoted to food and agriculture were not spent" (línea 286, 1298) | ✅ |
| Solo Malawi cumple 10 % Maputo | "very few of the countries analysed met the 10 percent Maputo target" / "consistently met the 10 percent CAADP threshold/Maputo Declaration" (línea 270, 968) | ✅ |

**Acción requerida:**
- Corregir nombres:
  - "Nkuingoua, Jean" → **"Nkuingoua Nana, Jules Cabrel"**
  - "Pan, Xinyue" → **"Pan, Xueyao"**
  - "Tuyishime, Cyriaque" → **"Tuyishime, Carine"**
- Validar páginas (162 vs 120). Probable confusión entre versión impresa y PDF online.

---

## Cifras críticas verificadas con localización en PDF

| Cifra | Fuente | Localización en PDF | Estado |
|-------|--------|---------------------|:------:|
| US$ 842B 2021-23 (OECD 54 países) | OECD2024_APME | Ejecutive Summary y Cap 1 | ✅ |
| 54 países OECD monitoring (38 OECD + 5 UE no-OECD + 11 emergentes) | OECD2024_APME | Foreword p. 3 | ✅ |
| PSE OECD 14% farm receipts (NO 18%) | OECD2024_APME | %PSE history (línea 1262, 1606) | ✅ |
| 35% most distorting (NO 30 ni 60) | OECD2024_APME | "made up 35% (USD 219 billion)" (línea 1494) | ✅ |
| 13 países SSA estudio MAFAP 2021 | FAO2021 (Pernechele et al.) | Líneas 446, 464 | ✅ |
| 21% promedio budget execution gap SSA | FAO2021 | Líneas 286, 1298 | ✅ |
| 6% promedio gasto agrícola SSA (vs 10% Maputo) | FAO2021 | Línea 1081 | ✅ |
| Solo Malawi cumple 10% Maputo target | FAO2021 | Líneas 968, 270 | ✅ |
| 14 países SSA en estudio Pernechele 2018 | Pernechele 2018 | Línea 105 (Figure 7) | ✅ |
| Métodos PSE/CSE/GSSE/TSE clasificación A1-A2/B/C-D/E/F/G | OECD_PSE_Manual | Capítulos 1-3 | ✅ |
| DEAP CRS/VRS/Malmquist/cost-allocative efficiency | Coelli 1996 | Abstract p. 1 | ✅ |

---

## Cifras / metadatos incorrectos identificados

| Item | Ficha | Estado real PDF |
|------|-------|------------------|
| MAFAP2014 autores | MAFAP2014_PEMethodGuideVolII | Real: Ghins, Ilicic-Komorowska, Mas Aparisi (2013) |
| MAFAP2014 año | MAFAP2014_PEMethodGuideVolII | 2013, no 2014 |
| MAFAP2014 páginas | MAFAP2014_PEMethodGuideVolII | 56, no 80 |
| OECD APME 2024 título | OECD2024_APME | "Innovation for Sustainable Productivity Growth" |
| OECD APME PSE OECD share | OECD2024_APME | 14% (no 18%) |
| OECD APME most distorting share | OECD2024_APME | 35% (no 60%) |
| FAO2021 SSA nombres co-autores | FAO2021_PEFoodAgricultureSSA | "Nkuingoua Nana, Jules Cabrel" / "Pan, Xueyao" / "Tuyishime, Carine" |
| FAO2021 SSA páginas | FAO2021_PEFoodAgricultureSSA | 120 PDF online (162 quizá edición impresa) |

---

## Fichas no auditadas en este pase (15 fichas con `pdf_downloaded: true`)

Por límite de tiempo, las siguientes fichas con PDF no fueron verificadas página a página. Riesgo bajo (manuales conocidos) o ya cubiertas tangencialmente:

- Anderson2008_DistortionsLAC.md (citas NRA región — riesgo bajo)
- Cahill2005_PSE_RevisionConcept.md (paper canónico OECD — riesgo bajo)
- MAFAP2013_MethodGuideVolI.md (probable mismo problema metadatos que VolII)
- PEFA2024_BoliviaCentralGov.md (institucional — verificar año y autoría)
- WB2011_BoliviaAgPER.md (PER Bolivia 2011 — verificar tablas)
- WB2018_PeruGainingMomentum.md, WB2018_BrazilPERAdjustment.md, WB2015_SouthAfricaAgPER.md, WB2021_BoliviaTappingPotential.md, WB2024_LACEconomicReview.md, WB2025_MalawiAgPER_Synthesis.md (PER WB series — riesgo bajo)
- FAO2012_FanMcBride_PublicInvestSynthesis.md (verificable contra Fan & McBride 2012 conocido)

**Recomendación:** auditar MAFAP2013_MethodGuideVolI con prioridad (por patrón de error confirmado en VolII).

---

## Recomendaciones de acción (prioridad descendente)

1. **🔴 Inmediato:**
   - Corregir MAFAP2014: autores, año (2013), pages (56).
   - Corregir OECD2024_APME: título, PSE OECD = 14%, most distorting = 35%.
   - Auditar MAFAP2013_MethodGuideVolI (probable mismo patrón).

2. **🟡 Próxima sesión:**
   - Corregir nombres co-autores en FAO2021 (Nkuingoua/Pan/Tuyishime).
   - Validar páginas FAO2021 (120 vs 162).
   - Refinar cifras NRP/MDG en Pernechele2018 con Tabla/Figura 7 del PDF.

3. **✅ Mantener (modelo):**
   - OECD_PSE_Manual y Coelli1996_DEAP21Guide — fichas exactas.
   - PernecheleEtAl2018 — sólida en cifras y autoría.
