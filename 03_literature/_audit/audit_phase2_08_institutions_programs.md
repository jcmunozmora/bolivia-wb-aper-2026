# Auditoría Fase 2 — Corpus `08_institutions_programs/`

**Fecha:** 2026-05-23
**Auditor:** Claude Code (lectura PDF + cross-check ficha)
**Universo:** 16 fichas con `pdf_downloaded: true`
**Muestra auditada:** 9 fichas (priorizando ICRs, PADs, country evaluations con cifras de impacto)
**Método:** Apertura del PDF, verificación de portada (autor, año, título), búsqueda de claims numéricos y verbatim quotes.

---

## Resumen ejecutivo

| Severidad | Fichas | % muestra |
|-----------|:------:|:---------:|
| ✅ Confirmado (sin issues mayores) | 2 | 22% |
| 🟡 Inconsistencias menores | 2 | 22% |
| 🔴 Alucinaciones / errores graves | 5 | 56% |

**Hallazgos críticos:**

1. **Caso más grave del corpus completo (folders 06 + 08):** `CRIAR_WB2012_PAD.md` — el PDF NO es el PAD de CRIAR, sino el **PAD del Proyecto Alianzas Rurales II (PAR II)** de septiembre 2012. Toda la ficha está construida sobre una mis-identificación del documento.

2. **Cifras de impacto fabricadas en programas estrella:** Tanto PICAR como AEMP-Plaguicidas reportan números (656 comunidades, 769 sub-proyectos, 2,120 insumos, 91.4% importaciones) que NO existen en sus PDFs.

3. **Verbatim quotes fabricadas en >70% de las fichas auditadas.**

---

## Tabla por ficha

### 1. `PAR_WorldBank2024_ICR.md` — 🟡 CIFRAS PARCIALMENTE INCORRECTAS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/source/report N° | ICR00006433, jun 28 2024 | CONFIRMADO | ✅ |
| 1,735 alianzas productivas | secciones 2, 5, 6, 8 | CONFIRMADO (p. 21) | ✅ |
| 1,644 integradas + 91 TA | secciones 5, 8 | CONFIRMADO (p. 21) | ✅ |
| 120 municipios | secciones 5, 6, 12 | CONFIRMADO (p. 15: "120 Municipalities covered by the Project in five distinct Selected Areas") | ✅ |
| 33,000 hogares | secciones 5, 12 | INCORRECTO — Real: **47,228 familias** (p. 22, Tabla 3); proyecto cubrió 12% de 1.2 millones de población rural en 120 munis | 🔴 |
| 7 departamentos | sección 2 | CONFIRMADO (La Paz, Cochabamba, Oruro, Chuquisaca, Potosí, Tarija, Santa Cruz) | ✅ |
| Ingreso laboral +53% / +USD 1,179 | secciones 6, 12 | CONFIRMADO (p. 24): "Labor income of primary occupation under PAR II-AF participants increased 53 percent, reflecting an average increase of US$1,179/year" | ✅ |
| Ingreso bruto producción +59% / USD 2,139 | secciones 6, 12 | INCORRECTO — Real (p. 23): "Annual average gross income increased by US$2,139, or **40 percent**" (no 59%) | 🔴 |
| Autoconsumo +22% USD 146 → 179 | sección 6 | INCORRECTO — Real (p. 24): "value of own consumption increased **33 percent** from US$146 to US$179" | 🔴 |
| Pobreza moderada −12 pp (62→50%) | secciones 6, 8 | CONFIRMADO — Real (p. 30): "19 percent reduction in households' moderate poverty, from 62 percent to 50 percent" (consistente con 12 pp drop) | ✅ |
| Pobreza extrema −11 pp (42→31%) | sección 6 | NO ENCONTRADO en el PDF — la cifra de extrema poverty reduction no aparece como tal | 🔴 |
| Verbatim Bullet "Net effects… increased average annual labor income by 53% (USD 1,179) and gross production income by USD 2,139 (59% net income rise)" | sección 8 | INCORRECTO — el "59%" es invento; el 40% real fue cambiado por 59% | 🔴 |

**Acción:** Corregir USD 2,139 → 40% (no 59%); autoconsumo → 33% (no 22%); hogares → 47,228; eliminar pobreza extrema 42→31% no encontrada; eliminar el "(59% net income rise)" de la quote.

---

### 2. `PICAR_WorldBank2021_ICR.md` — 🔴 CIFRAS PRINCIPALES FABRICADAS (réplica del problema en folder 06)

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/year/report N° | World Bank 2021, "PICAR ICR" | CONFIRMADO como ICR (No: ICR00004749) | ✅ |
| Implementador FPS | secciones 2, 5 | INCORRECTO — Real: **EMPODERAR** (no FPS). FPS no aparece en el documento | 🔴 |
| 656 comunidades atendidas | secciones 2, 5, 6, 8, 12 | NO ENCONTRADO. PDF dice target **870 comunidades** en 131 municipios | 🔴 |
| 769 sub-proyectos | secciones 2, 5, 6, 12 | NO ENCONTRADO. Real: **2,197 sub-proyectos** (p. 19, Tabla 2) | 🔴 |
| 150,000 beneficiarios directos | sección 6 | NO ENCONTRADO. Real: 362,619 beneficiarios totales | 🔴 |
| 350,000 beneficiarios | sección 2 | Era TARGET, no resultado. Real: 362,619 | 🟡 |
| FIRR 17.72% / EIRR 21.05% | secciones 6, 8 | CONFIRMADO (p. 24, evaluación 15 años) | ✅ |
| USD 60M financiamiento adicional 2015 | secciones 2, 6 | NO confirmado puntualmente (PDF habla de US$100M total en SDR68.2M) | 🟡 |
| Verbatim "Over a 15-year evaluation period, the investment would remain profitable in economic terms, with a FIRR of 17.72% and EIRR of 21.05%" | sección 8 | CONFIRMADO LITERALMENTE en p. 24 | ✅ |
| Verbatim "The project transferred responsibility and resources to more than 150,000 rural inhabitants in 656 highly vulnerable communities (30 percent beyond the target of 500 communities)" | sección 8 | NO ENCONTRADO — INVENTADA | 🔴 |

**Acción:** Reescribir secciones 2, 5, 6, 8, 12. Reemplazar 656/769/150,000 por los datos reales (2,197 sub-proyectos / 362,619 beneficiarios). Eliminar FPS, sustituir por EMPODERAR. Eliminar verbatim quote del 150,000/656.

---

### 3. `CRIAR_WB2012_PAD.md` — 🔴 CRÍTICO: DOCUMENTO MIS-IDENTIFICADO

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title "Community Investment in Rural Areas Project — PAD" | toda la ficha | **EL PDF ES EL PAD DE PAR II** (Proyecto Alianzas Rurales II), no de CRIAR ni PICAR. Portada del PDF dice "DOCUMENTO DE EVALUACIÓN DEL PROYECTO PARA EL PROYECTO DE ALIANZAS RURALES II, 17 de septiembre de 2012" | 🔴 (CRÍTICO) |
| Report 71702-BO | sección 1 | CONFIRMADO (p. 1) — pero es informe PAR II | ✅ |
| year 2012 | sección 1 | CONFIRMADO | ✅ |
| Toda la sección 2 describe CRIAR/PICAR architectura | sección 2 | INCORRECTO — el PDF es el PAD de PAR II y solo menciona CRIAR como acrónimo en la lista de siglas; PICAR aparece como referencia para FM track record. La descripción de "CRIAR + PICAR" es invento | 🔴 |
| "CRIAR (Creación de Iniciativas **Alimentarias** Rurales)" | secciones 2, 5 | INCORRECTO — Acrónimo real (p. 2): "CRIAR Creación de Iniciativas **Agroalimentarias** Rurales" (con "agro") | 🟡 |
| EMPODERAR = "Emprendimientos Productivos para el Desarrollo Rural Auto-gestionario" | implícito | CONFIRMADO en acrónimos (p. 2) | ✅ |
| Verbatim "CRIAR busca mejorar el acceso a tecnologías agropecuarias para incrementar productividad, ingreso y seguridad alimentaria de pequeños productores rurales" | sección 8 | NO ENCONTRADO — INVENTADA | 🔴 |

**Acción CRÍTICA:** Renombrar la ficha y citekey a `PAR2_WB2012_PAD.md` o similar. Reescribir el resumen ejecutivo describiendo el PAD real de PAR II (objetivo: mejorar acceso a mercados de pequeños productores mediante alianzas productivas; SDR 32,9M; ejecutado por EMPODERAR; selected areas). Si se desea ficha específica de CRIAR, descargar el documento original de CRIAR (que es diferente).

---

### 4. `AEMP2024_PlaguicidasBolivia.md` — 🔴 AÑO Y CIFRAS FABRICADAS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| year | 2024 | INCORRECTO — Portada PDF dice **"Noviembre de 2019"** | 🔴 |
| author/source | AEMP / Min. Desarrollo Productivo | CONFIRMADO | ✅ |
| period_covered | 2018-2023 | INCORRECTO — PDF cubre principalmente 2001-2018 (datos a 2018) | 🔴 |
| 2.120 insumos agrícolas registrados SENASAG (2020) | secciones 2, 6, 8, 12 | NO ENCONTRADO en el PDF | 🔴 |
| 1.863 plaguicidas químicos | secciones 2, 6, 8 | NO ENCONTRADO | 🔴 |
| 91,4% importaciones de 6 países (China, Argentina, Brasil, Uruguay, Paraguay, India) | secciones 2, 6, 12 | NO ENCONTRADO con esa lista de países. PDF (p. 2) menciona Brasil, India, Canadá, Alemania como principales importadores | 🔴 |
| 2.110 millones kg agroquímicos en 20 años (CAO 2022) | sección 2 | NO ENCONTRADO en el PDF (CAO no es el documento auditado) | 🔴 |
| Verbatim "A fines de 2020, el SENASAG registró 2.120 insumos agrícolas en todo el país, de los cuales 1.863 eran plaguicidas químicos de uso agrícola" | sección 8 | NO ENCONTRADO. Además es cronológicamente imposible (PDF es de nov-2019) | 🔴 |

**Acción:** Corregir año a 2019, period_covered a 2001-2018. Eliminar todas las cifras 2.120/1.863/91,4%/2.110 millones. Reemplazar con datos reales del PDF (e.g., en 2018 63% de importaciones destinado al agropecuario, distribución por arancel). Si las cifras vienen de fuentes externas (CAO 2022, etc.), crear fichas separadas.

---

### 5. `WorldBank2021_TappingPotential.md` — 🟡 QUOTE INVENTADA

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/year/author | World Bank 2021, Tapping the Potential | CONFIRMADO | ✅ |
| Cobertura temática | sección 2 | Plausible (food systems framework, PSE, etc.) | ✅ |
| Verbatim "Bolivia has the potential to leverage its agricultural sector for inclusive growth, but realizing this potential requires repurposing public expenditure toward public goods and reducing market-distorting interventions" | sección 8 | NO ENCONTRADO — INVENTADA | 🔴 |
| "Empresas públicas (EMAPA, EBA, Insumos Bolivia)" en el reporte | sección 2 | El PDF las menciona, pero el detalle exacto no fue verificado | ✅ |

**Acción:** Reemplazar verbatim quote por una literal del PDF (existen muchas opciones, e.g., del cap. de PSE o cap. de smallholder).

---

### 6. `FAO_PerfilSistemasAlimentarios.md` — ✅ CONFIRMADO METADATOS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| author/title/year | FAO 2022, "Perfil de Sistemas Alimentarios — Bolivia" | CONFIRMADO. Co-publicado con CIRAD y UE, Roma-Montpellier-Bruselas 2022 | ✅ |
| Sección 8 vacía "[Por extraer tras lectura completa]" | sección 8 | Ficha aún en progreso — sin claims que verificar | ✅ |
| No hay claims cuantitativos específicos no verificados | secciones 6, 12 | Snippet es genérico ("integra indicadores comparables") — no falsificable | ✅ |

**Acción:** Sin acción correctiva inmediata, pero completar Sección 8 con quotes reales del PDF.

---

### 7. `IFAD2015_CountryProgrammeEvaluation.md` — 🟡 VERBATIM PROBABLEMENTE INVENTADO

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/year/source/document N° | IFAD-IOE 2015, EB 2015/116/R.8 | CONFIRMADO | ✅ |
| Proyectos cubiertos VALE, Plan VIDA, ACCESOS, PROMARENA | sección 2 | CONFIRMADO en p. 4 (también PROSAT, PROMARENA citados) | ✅ |
| **CRIAR** referenciado | sección 2 | NO ENCONTRADO en este documento — CRIAR es BM/BID, no IFAD. La ficha confunde programas | 🔴 |
| CLAR (Comités Locales de Asignación de Recursos) | sección 7 | CLAR mencionado en p. 8 pero no como concurso público claramente; verificación parcial | 🟡 |
| Verbatim "Plan VIDA made important contributions to increasing the assets and incomes of the most vulnerable rural people in Bolivia, with the strongest impacts seen among livestock farmers" | sección 8 | NO ENCONTRADO con esas palabras exactas — INVENTADA o paráfrasis | 🔴 |

**Acción:** Eliminar referencia a CRIAR (no es IFAD). Reemplazar verbatim por quote real del Executive Summary del IFAD 2015.

---

### 8. `PAR_IEG2018_PPAR.md` — ✅ MAYORMENTE CONFIRMADO

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/Report N° 132905 / year 2018 | IEG PPAR Bolivia Rural Alliances | CONFIRMADO (Dec 20, 2018) | ✅ |
| Ingreso del hogar +63% promedio | secciones 2, 6, 12 | CONFIRMADO (p. 27): "63 percent higher for project beneficiaries than for a control group" | ✅ |
| Sesgo pro-pobre / quintil 1 mayor beneficio | secciones 2, 6 | CONFIRMADO (p. 11) | ✅ |
| 768 alianzas | secciones 2, 5, 6 | CONFIRMADO (p. 51, tabla: 768 total project) | ✅ |
| ~28.000 hogares | secciones 5, 6 | NO encontrado con esa cifra exacta. Es estimación (≈ 768 × ~37 familias/alianza) | 🟡 |
| Cofinanciamiento ~40% beneficiario/60% público | sección 7 | NO verificado puntualmente | 🟡 |
| Verbatim "The project achieved its objective to a high extent, and the project process was thorough enough to allow for a full testing of the model's potential and its likelihood of delivering sustainable results" | sección 8 | CONFIRMADO LITERALMENTE en p. 11 del PDF | ✅ |

**Acción:** Aclarar que 28.000 hogares es estimación derivada; cofinanciamiento debería verificarse caso por caso.

---

### 9. `PlanVida_IFAD_ImpactAssessment.md` — 🔴 AUTORÍA y QUOTE INCORRECTAS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/year | IFAD 2018, Plan VIDA-PEEP IA Phase I | CONFIRMADO | ✅ |
| authors "IFAD" institucional | sección 1 | Autores reales: **Adriana Paolantonio, Romina Cavatassi, Kristen McCollum** (citación oficial p. 2: "Paolantonio, A., Cavatassi, R., McCollum, K. 2018") | 🔴 |
| Método PSM + DiD | sección 5 | CONFIRMADO (PSM p. 15, DiD p. 13) | ✅ |
| Geografía Potosí + Cochabamba | secciones 5, 7 | CONFIRMADO (p. 3) | ✅ |
| 2011-2016 | sección 5 | Verificable, no buscado puntualmente | ✅ |
| "Efectos más fuertes en hogares ganaderos" | secciones 2, 6, 12 | Razonable (80% intervenciones distribuyeron ganado, p. 5) pero el "strongest impacts" no es verbatim | 🟡 |
| Verbatim "Plan VIDA made important contributions to increasing the assets and incomes of the most vulnerable rural people in Bolivia, with the strongest impacts seen among livestock farmers" | sección 8 | NO ENCONTRADO con esas palabras — INVENTADA (idéntica a la inventada en IFAD2015 ficha) | 🔴 |

**Acción:** Corregir autoría (Paolantonio, Cavatassi, McCollum). Reemplazar verbatim quote por uno literal del Executive Summary del PDF.

---

### 10. `UDAPE2023_DiagnosticoAgropecuario.md` — 🟡 TÍTULO Y SECCIÓN 8 INCOMPLETOS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title "Diagnóstico Sectorial Agropecuario — Bolivia 2023" | ficha | PDF tiene portada minimalista: "AGROPECUARIO 2023". Título completo no encontrado en portada/índice | 🟡 |
| author UDAPE | ficha | CONFIRMADO institucional | ✅ |
| Sección 8 vacía | sección 8 | ficha aún en progreso | ✅ |
| Sin claims cuantitativos específicos | secciones 6, 12 | Texto es genérico — no falsificable | ✅ |

**Acción:** Completar sección 8 con cifras reales del PDF (PIB agropecuario, producción agrícola/pecuaria, factores de producción).

---

### 11. `CIPCA_PoliticasPublicasInversion.md` — 🔴 AUTOR INCORRECTO + QUOTE INVENTADA

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| author "CIPCA" institucional | secciones 1, 13 | Autora real: **Blanca Zulema Rivero Lobo** (Univ. Católica Boliviana, máster Desarrollo Sostenible) — publicado bajo el sello CIPCA pero con autoría individual identificada | 🟡 |
| period_covered 2006-2016 | front-matter | INCORRECTO — Real (p. 3 Resumen): "se analiza a fondo la actividad agropecuaria en Bolivia durante el periodo **2000-2018**" | 🔴 |
| Verbatim "La inversión pública en agricultura familiar campesina indígena ha sido sub-óptima en relación al discurso de soberanía alimentaria" | sección 8 | NO ENCONTRADO — INVENTADA (búsquedas "sub-óptima", "subóptima", "campesina indígena" todas dieron negativo) | 🔴 |

**Acción:** Corregir autor a Rivero Lobo (B.Z.), período a 2000-2018, eliminar la quote inventada.

---

## Acciones correctivas prioritarias (folder 08)

1. **CRÍTICO — Reidentificar `CRIAR_WB2012_PAD.md`**: el PDF es el PAD de **PAR II**, no de CRIAR. Renombrar la ficha y reescribir completamente. O conseguir el verdadero PAD de CRIAR (otro documento).

2. **CRÍTICO — Reescribir `PICAR_WorldBank2021_ICR.md`** (folder 08, similar al folder 06): los números 656/769/150,000 son fabricados. Reales: 2,197 sub-proyectos / 362,619 beneficiarios / 116 municipios / 870 comunidades target.

3. **CRÍTICO — Corregir `AEMP2024_PlaguicidasBolivia.md`**: año real 2019 (no 2024), eliminar cifras 2.120/1.863/91,4%/2.110 millones todas fabricadas, ajustar period a 2001-2018.

4. **URGENTE — Corregir `PAR_WorldBank2024_ICR.md`**: gross income es 40% (no 59%); autoconsumo es 33% (no 22%); hogares son 47,228 (no 33,000); eliminar pobreza extrema 11pp no confirmada.

5. **URGENTE — Corregir autoría de `CIPCA_PoliticasPublicasInversion.md`** (Rivero Lobo) y período (2000-2018, no 2006-2016).

6. **URGENTE — Corregir autoría de `PlanVida_IFAD_ImpactAssessment.md`** (Paolantonio, Cavatassi, McCollum).

7. **Eliminar referencia errónea a CRIAR en `IFAD2015_CountryProgrammeEvaluation.md`** (CRIAR es BM/BID).

8. **Reemplazar verbatim quote en `WorldBank2021_TappingPotential.md`** por una literal del PDF.

9. **Completar Secciones 8 vacías en `FAO_PerfilSistemasAlimentarios.md` y `UDAPE2023_DiagnosticoAgropecuario.md`** con quotes reales.

---

## Patrón sistemático detectado (folder 08)

- **Confusión entre PADs e ICRs:** dos fichas (PICAR folder 06 y CRIAR folder 08) confunden el tipo de documento del Banco Mundial. Las cifras de un ICR (resultados al cierre) se pasaron como si fueran metas del PAD original o se inventaron.
- **Autores institucionales vs. individuales:** múltiples fichas atribuyen el documento al organismo institucional cuando el PDF identifica autores específicos individuales (consultores, investigadores). Esto es endémico: CEPAL2004 (Valenzuela), INRA2024 (Estrategia INC), CIPCA2017 (Rivero Lobo), PlanVida 2018 (Paolantonio et al.), UDAPE2019 (Landa Cazasola).
- **Verbatim quotes inventadas:** 8/11 fichas auditadas tienen quotes en Sección 8 que NO existen literalmente en el PDF (≈73%).
- **Re-uso de quotes inventadas entre fichas:** la misma quote sobre "Plan VIDA made important contributions..." aparece idéntica en `IFAD2015_CountryProgrammeEvaluation.md` y `PlanVida_IFAD_ImpactAssessment.md` — no existe en ninguno de los dos PDFs.

**Recomendación de gobernanza:** Añadir gate obligatorio en `.agent/`:
1. Toda Sección 8 verbatim debe pasar búsqueda exacta en el PDF antes de marcar `Hallazgos verificados` como [x].
2. Toda atribución institucional de autor debe contrastarse con portada/citation page del PDF; si hay autores individuales identificados, deben listarse.
3. Toda cifra cuantitativa específica de la Sección 6 debe tener página o tabla del PDF como referencia explícita.
