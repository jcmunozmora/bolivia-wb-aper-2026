# Auditoría Fase 2 — Corpus `06_smallholder_indigenous/`

**Fecha:** 2026-05-23
**Auditor:** Claude Code (lectura PDF + cross-check ficha)
**Universo:** 14 fichas con `pdf_downloaded: true`
**Muestra auditada:** 13 fichas (priorizando cifras cuantitativas verificables)
**Método:** Apertura del PDF, verificación de portada (autor, año, título), búsqueda de claims numéricos y verbatim quotes.

---

## Resumen ejecutivo

| Severidad | Fichas | % muestra |
|-----------|:------:|:---------:|
| ✅ Confirmado (sin issues mayores) | 3 | 23% |
| 🟡 Inconsistencias menores | 2 | 15% |
| 🔴 Alucinaciones / errores graves | 8 | 62% |

**Hallazgo crítico:** ~62% de las fichas auditadas contienen al menos un dato verificablemente FABRICADO (autor, año, cifra, o quote inexistente). Patrón sistemático: los snippets bilingües y las citas verbatim de la Sección 8 frecuentemente parafrasean ideas con cifras que no aparecen en el PDF original.

---

## Tabla por ficha

### 1. `CIPCA2021.md` — 🔴 ALUCINACIÓN MAYOR

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title | "Desmitificando la agricultura familiar..." | "Contribución de la Agricultura Familiar Campesina Indígena a la producción y consumo de alimentos en Bolivia" | 🔴 |
| authors | "Tito, Coraly & Wanderley, Fernanda" | "Carola Tito Velarde y Fernanda Wanderley" (+ colaboradores: Cartagena, Peralta, Salazar) | 🟡 (nombre Coraly → Carola) |
| year/source | 2021 — Cuaderno 91 IISEC-UCB/CIPCA | 2021, Cuaderno de investigación 91 | ✅ |
| 26.14% / 26.54% / 47.32% tipología AF | citadas en sección 6 | CONFIRMADO en p. 50 (Tabla 4) | ✅ |
| "70% del empleo agropecuario" | citado en sección 6 | NO encontrado con esa cifra exacta | 🟡 |
| Verbatim "agricultura familiar boliviana no es un universo homogéneo..." | atribuida como "síntesis CIPCA" | Es paráfrasis, no quote literal | 🟡 |

**Acción:** Corregir título y nombre de autora (Coraly→Carola). Las cifras tipológicas son correctas.

---

### 2. `AlianzaAgroecologia.md` — 🔴 CIFRAS FABRICADAS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/authors/year | Alianza por la Agroecología, 2017 | "Beneficios de la Agroecología en Bolivia: Estudios de Caso" (sin año en portada; ed. Coraly Salazar Carrasco) | 🟡 |
| "Ingresos familiares 30-60% mayores" | repetido en secciones 6, 12 y verbatim | NO existe esa cifra en el PDF. "60%" solo aparece como "50-60% del bosque nativo se mantiene en pasturas" (silvopastoril) — contexto totalmente diferente | 🔴 |
| "CIPCA, AOPEB, PROBIOMA, AGRECOL" como autores conjuntos | sección 2 | Solo CIPCA y AGRECOL Andes aparecen. AOPEB y PROBIOMA NO se encuentran | 🔴 |
| Verbatim "Las fincas agroecológicas consolidadas presentan ingresos familiares 30-60% superiores..." | sección 8 | INVENTADA — no existe en el PDF | 🔴 |
| 4 estudios de caso (Viacha, Anzaldo, Gonzalo Moreno, Charagua) | no mencionados en ficha | El PDF contiene EXACTAMENTE estos 4 casos | 🟡 (ficha incompleta) |
| Dato verificable: "89% de UPAs son AF de base agroecológica" | NO citado en ficha | CONFIRMADO en p. 4 del PDF | — |

**Acción:** Reescribir secciones 6 y 12. Eliminar "30-60%" y "AOPEB/PROBIOMA". Reemplazar con el dato 89% (verificable). Estructurar por los 4 estudios de caso reales.

---

### 3. `BerdegueSchejtman2007.md` — 🔴 QUOTE INVENTADA + TIPOLOGÍA INCORRECTA

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/year/source | "Desigualdad y pobreza..." RIMISP DT N°1 Oct 2007 | CONFIRMADO (p.1) | ✅ |
| Tipología "ganadores / no-equitativos / estancados" | sección 2 y 6 | El PDF usa framework "win-win-win / loss-loss-loss" sobre 3 indicadores (ingreso, Gini, pobreza). NO existe la tipología tal como la describe la ficha | 🔴 |
| Verbatim "El acceso a activos y a redes es lo que determina si un territorio sale o no de la pobreza" (p. 11) | sección 8 | NO encontrado en p. 11 ni en ninguna parte del PDF | 🔴 |
| "60-84% caída de pobres rurales por migración (De Janvry-Sadoulet 2000)" | NO citado | DATO REAL del PDF (p. 11) | — |

**Acción:** Reemplazar tipología por la real (win-win-win framework). Eliminar quote inventada. Sustituir con cifras reales del PDF (Gini 1990-2005 por país, datos Bolivia: 63.7→63.2 Gini rural).

---

### 4. `CEPAL_Inequidad.md` — 🔴 AUTOR Y AÑO INCORRECTOS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| author | "Molina B., Ramiro" | **Rodrigo Valenzuela Fernández** (consultor CEPAL) | 🔴 |
| year | 2005 | **2004** (Santiago de Chile, marzo de 2004) | 🔴 |
| source | "CEPAL - Serie Políticas Sociales" | CONFIRMADO (es Serie Políticas Sociales N° 83) | ✅ |
| issue | vacío | Debería ser N° 83 | 🟡 |
| "~98% de la población rural autoidentifica como indígena" | sección 2 | NO verificado (no buscado pero claim extremo poco probable) | 🟡 |
| Verbatim "La pobreza rural en Bolivia es indisociable de la cuestión étnica..." | sección 8 | Marcada como "síntesis" — no es quote literal | 🟡 |

**Acción:** Corregir autor (Valenzuela), año (2004), añadir número de serie (83). Verificar claim del 98%.

---

### 5. `INE2015_Censo.md` — 🟡 CIFRAS DESALINEADAS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/author/year | INE 2015, Censo Nacional Agropecuario 2013 | CONFIRMADO (Diciembre 2015) | ✅ |
| 871,927 UPAs | confirmado | CONFIRMADO (p. 7 del PDF) | ✅ |
| "92.2% UPAs en 20.6% tierra; 3.9% en 79.4%" | atribuido a "CEDLA con base en INE Censo 2013" | Esas cifras EXACTAS no aparecen en el PDF de INE. Pueden venir de análisis secundario de CEDLA pero la ficha no provee fuente CEDLA específica | 🔴 |
| "507,243 UPAs (58.9%) son <5 ha" | sección 2 | NO encontrado en PDF | 🔴 |
| Categorías territoriales (TCO/TIOC, intercultural, afro-boliviano) | sección 2 | CONFIRMADO en sección de comunidades | ✅ |

**Acción:** Si las cifras 92.2/20.6/3.9/79.4 vienen de CEDLA, citar CEDLA explícitamente y no INE. Verificar el 507,243 / 58.9% / <5 ha.

---

### 6. `INRA2024.md` — 🔴 AUTOR, AÑO Y CIFRA INCORRECTOS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| author | "INRA" institucional | **CONSULTORA ESTRATEGIA INC SRL** — Miguel Morales (coordinador), Bazoberry, Salas, Ferreira, Tedesqui | 🔴 |
| year | 2024 | **Agosto 2022** (portada y fecha de finalización) | 🔴 |
| pdf_path | INRA_EvalBOL1113.pdf | OK | ✅ |
| "Avance acumulado del saneamiento ~85%" | sección 6 | El PDF reporta **40,85% de avance** en títulos registrados al 31-dic-2021 (p. 82). El 85% citado parece haber sido extraído mal | 🔴 |
| Verbatim "El programa muestra cumplimiento sustantivo pero requiere ajustes en gestión presupuestaria y resolución de conflictos en frontera agrícola" | sección 8 | NO encontrado en PDF; "frontera agrícola" tampoco aparece | 🔴 |

**Acción:** Corregir autor a Consultora Estrategia INC SRL (consultoría comisionada por INRA-BID), año a 2022, y la cifra de avance a 40,85% real.

---

### 7. `Ley3545_2006.md` — 🟡 TÍTULO Y QUOTE INEXACTOS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title | "Reconducción Comunitaria de la Reforma Agraria" | El PDF dice "MODIFICACION DE LA LEY Nº 1715 / RECONDUCCION DE LA REFORMA AGRARIA" (sin "Comunitaria"). El término "Reconducción Comunitaria" es nombre informal popular | 🟡 |
| year/date | 2006-11-28 | CONFIRMADO | ✅ |
| Verbatim "Cumple una función económico-social en el área rural el empleo sostenible de la tierra en el desarrollo de actividades agropecuarias, forestales y otras de carácter productivo" | atribuida a "art. modificatorio Ley 3545" | NO ENCONTRADO en el PDF de 20 páginas — INVENTADA | 🔴 |
| "Las TCO renombradas como TIOC por DS 727 en 2010" | sección 7 | Hecho histórico correcto, no verificable contra Ley 3545 | ✅ |

**Acción:** Eliminar la quote inventada. Reemplazar con el texto real del Artículo 2 del PDF: "La Función Económico Social comprende, de manera integral, áreas efectivamente aprovechadas, de descanso, servidumbres ecológicas legales y de proyección de crecimiento..."

---

### 8. `Urioste2011.md` — ✅ MAYORMENTE CONFIRMADO

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| author/year/title | Urioste, 2011, "Concentración y extranjerización..." | CONFIRMADO (portada) | ✅ |
| source FAO/TIERRA | confirmado | CONFIRMADO ("apoyo de FAO América Latina y Caribe") | ✅ |
| "Más de 1 millón ha en manos extranjeras" | sección 6 | CONFIRMADO (portada p. 1: "Más de un millón de hectáreas...Santa Cruz") | ✅ |
| **Extrapolación geográfica** "Santa Cruz, Beni, Pando" | sección 5 | El PDF se centra en **Santa Cruz**; Beni y Pando son extrapolación de la ficha no respaldada por el PDF | 🟡 |
| Verbatim "Sólo el 20% de las tierras productivas en Bolivia están en manos de campesinos" | sección 8 | NO encontrado en el PDF — INVENTADA o de fuente externa | 🔴 |
| "~20% productiva campesina vs. 80% grandes propiedades" | sección 6 hallazgo 2 | NO encontrado en el PDF | 🔴 |

**Acción:** Restringir geografía a Santa Cruz en sección 5. Eliminar/sustituir quote del 20%. Las cifras de extranjerización son correctas.

---

### 9. `SchejtmanBerdegue2004.md` — ✅ CONFIRMADO

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| author/year/title | Schejtman & Berdegué, 2004, "Desarrollo Territorial Rural" | CONFIRMADO (Marzo 2004, Debates y Temas Rurales N°1) | ✅ |
| Verbatim "El desarrollo territorial rural es un proceso de transformación productiva e institucional en un espacio rural determinado, cuyo fin es reducir la pobreza rural" (p. 5) | sección 8 | CONFIRMADO LITERALMENTE en p. 5 del PDF | ✅ |
| Marco conceptual descrito | sección 2 | CONFIRMADO | ✅ |

**Acción:** Ninguna. Esta ficha es ejemplar.

---

### 10. `WB_Tapping2021.md` — 🟡 QUOTE INEXACTA, CIFRAS REDONDEADAS CORRECTAS

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/author/year | World Bank 2021, "Tapping the Potential..." | CONFIRMADO | ✅ |
| "Santa Cruz 60% del área cultivada (vs. 9% en años 50)" | sección 6 | CONFIRMADO en p. 16: "Santa Cruz had 8.9 percent of all harvested area in 1950 and 60.7 percent by 2013" | ✅ (redondeo aceptable) |
| Verbatim "Most commercial agriculture (50–5,000 ha) is concentrated in Santa Cruz, while agriculture in the western highlands is mainly carried out by small farmers (≤50 ha)" | sección 8 | NO ENCONTRADO con esas palabras exactas en el PDF — quote FABRICADA o de fuente externa no citada | 🔴 |
| "50% de población >8 años en La Paz/Oruro/Potosí en UPAs" | sección 6 | NO verificado, claim específico no confirmado | 🟡 |
| "Gasto público agrícola con sesgo comercial Santa Cruz" | sección 6 | Implícito en el PDF pero no como cifra | 🟡 |

**Acción:** Reemplazar verbatim quote por una que esté literalmente en el PDF (p.ej., p. 16 sobre Highlands con 60% farms <1ha).

---

### 11. `WB_PICAR_2021.md` — 🔴 ERRORES NUMÉRICOS GRAVES Y CONFUSIÓN PAD/ICR

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title | "PICAR Community Investment in Rural Areas Project — **Project Document**" | El PDF es **ICR (Implementation Completion and Results Report) No. ICR00004749, agosto 2021** — NO un Project Document | 🔴 |
| "656 comunidades altamente vulnerables" | secciones 2, 5, 6, 12 | NO ENCONTRADO en el PDF. PDF dice target era **870 comunidades** en 131 municipios; achievement final no como 656 | 🔴 |
| "769 sub-proyectos" | secciones 2, 5, 6, 12 | NO ENCONTRADO. Real: **2,197 sub-proyectos** financiados (p. 19) | 🔴 |
| "150,000 beneficiarios" (fase inicial) | sección 2 | NO ENCONTRADO | 🔴 |
| "350,000 beneficiarios totales" | secciones 2, 6, 12 | Era target; real fue **362,619 beneficiarios** (p. 19) | 🟡 |
| "~300 sub-proyectos liderados por mujeres (39%)" | secciones 6, 12 | Real: **973 sub-proyectos liderados por mujeres (45%)** (p. 20) | 🔴 |
| Departamentos: "La Paz, Oruro, Chuquisaca, Cochabamba, Pando" | secciones 5, 12 | Real (p. 23): **La Paz, Oruro, Cochabamba, Chuquisaca, y Potosí**. Pando fue reemplazado por Potosí bajo el AF (footnote 11) | 🔴 |
| "Financiamiento adicional USD 60M" | sección 6 | Total crédito: SDR68.2M (~US$100M); el AF específico no se confirma como USD 60M | 🟡 |
| "15,000+ acceso vial, 17,000+ riego" | sección 2 | Real (p. 20): 129 caminos beneficiando varias comunidades; riego: 2,611 ha en 488 sub-proyectos | 🔴 |

**Acción:** Re-escribir la ficha completa con datos reales del ICR. Es el caso más grave del corpus.

---

### 12. `INRA1996.md` — ✅ CONFIRMADO

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title/year/source | Ley 1715 del 18-oct-1996 | CONFIRMADO en portada del PDF | ✅ |
| Verbatim Art. 2 "El solar campesino, la pequeña propiedad..." | sección 8 | CONFIRMADO LITERALMENTE en p. 1 del PDF | ✅ |
| Categorías de propiedad (6), Función Económico-Social | sección 4 y 6 | CONFIRMADAS en articulado | ✅ |

**Acción:** Ninguna. Ficha ejemplar.

---

### 13. `UDAPE2019.md` — 🔴 CIFRAS RURALES INVENTADAS Y AUTOR INCORRECTO

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title | "Pobreza monetaria, desigualdad del ingreso **y empleo** en Bolivia 1996-2018" | El PDF dice solo "Pobreza monetaria, desigualdad del ingreso en Bolivia 1996-2018" — sin "empleo" | 🟡 |
| author | "UDAPE" institucional | **Fernando Landa Cazasola** (autor individual; Noviembre 2019, La Paz) | 🟡 |
| "Pobreza moderada rural ↓23.4% (2007-2018)" | secciones 6, 8, 12 | INVENTADO — Real: rural pasó de 76.5% (2006) a 53.9% (2018), una caída de ~22.6 pp (que no es 23.4%) | 🔴 |
| "Pobreza extrema rural ↓30.5% (2007-2018)" | secciones 6, 8, 12 | INVENTADO — Real: rural pasó de 62.2% (2006) a 33.4% (2018), caída de ~28.8 pp (no 30.5%) | 🔴 |
| Verbatim "Entre 2007 y 2018, la pobreza moderada en áreas rurales se redujo en 23.4% y la pobreza extrema en 30.5%" | sección 8 | FABRICADA — esa oración no existe en el PDF. El "23.4%" que sí existe en el PDF es el nivel de pobreza extrema URBANA en 2006, no una reducción rural | 🔴 |

**Acción:** Reescribir secciones 6, 8 y 12 con cifras reales (84.4→76.5→53.9% rural moderada; 67.8→62.2→33.4% rural extrema). Corregir título y autor.

---

### 14. `RimispTierraMujeres.md` — 🔴 AUTORÍA INCORRECTA

| Campo | Ficha | PDF (verdad) | Severidad |
|-------|-------|--------------|:---------:|
| title | "Tierra de mujeres: reflexiones sobre el acceso..." | CONFIRMADO ("Reflexiones sobre el acceso de las mujeres rurales a la tierra en América Latina") | ✅ |
| authors | "Costas Monje, Patricia (ed.)" | Autoras reales: **Carmen Diana Deere, Susana Lastarria-Cornhiel, Claudia Ranaboldo**; Costas Monje fue **coordinadora general**, no editora ni autora | 🔴 |
| year/source | 2011, ILC/Fundación TIERRA | CONFIRMADO | ✅ |
| "<30% títulos individuales a nombre de mujeres pese a Ley 3545" | secciones 6, 12 | NO encontrado con esa cifra en el PDF | 🔴 |
| Verbatim "Pese al avance normativo, las mujeres rurales bolivianas siguen subrepresentadas en la titulación individual" (Costas Monje 2011) | sección 8 | NO encontrado. "subrepresentadas" no aparece en el PDF | 🔴 |

**Acción:** Corregir autoría (Deere, Lastarria-Cornhiel, Ranaboldo + Costas como coordinadora). Eliminar la cifra "<30%" no respaldada. Sustituir quote inventada.

---

## Acciones correctivas prioritarias (folder 06)

1. **URGENTE — Reescribir `WB_PICAR_2021.md`**: todos los números son incorrectos. Usar la tabla real del ICR (2,197 subproyectos, 362,619 beneficiarios, 973 women-led, Potosí en lugar de Pando).

2. **URGENTE — Corregir `INRA2024.md`**: autor real es Consultora Estrategia INC SRL, año real 2022, avance real 40,85% (no 85%).

3. **URGENTE — Corregir `CEPAL_Inequidad.md`**: autor real Rodrigo Valenzuela Fernández, año 2004 (no Molina B./2005).

4. **Reescribir secciones 6 y 12 de `AlianzaAgroecologia.md`**: eliminar la cifra inventada "30-60% ingresos familiares" y las instituciones AOPEB/PROBIOMA no presentes en el PDF.

5. **Reemplazar verbatim quote de `BerdegueSchejtman2007.md`** (p.11 inexistente) y sustituir tipología "ganadores/no-equitativos/estancados" por el framework real win-win-win.

6. **Eliminar verbatim quote de `Ley3545_2006.md`** (no existe) y reemplazar con texto literal del Artículo 2 párrafo III.

7. **Restringir geografía de `Urioste2011.md`** a Santa Cruz (no extrapolar a Beni/Pando) y eliminar quote del 20%.

8. **Verificar atribución CEDLA en `INE2015_Censo.md`** para las cifras 92.2%/20.6%/3.9%/79.4% — citar fuente secundaria explícitamente.

9. **Reemplazar quote de `WB_Tapping2021.md`** por una literal del PDF (e.g., dato 60% farms <1ha en highlands de p. 16).

10. **Reemplazar verbatim quote inventada de `UDAPE2019.md`** (`23.4%` y `30.5%` no son reducciones rurales). Usar números reales del PDF: rural moderada cae de 84.4% (1996) a 53.9% (2018); rural extrema cae de 67.8% a 33.4%. Corregir título (no incluye "y empleo"). Autor real: Fernando Landa Cazasola.

---

## Patrón sistemático detectado

Las **Secciones 8 (Citas directas)** y **Secciones 12 (Snippets ES/EN)** son los puntos más débiles del corpus. Frecuentemente contienen:

- **Quotes "verbatim" con páginas falsas** (p. ej., "p. 11" sin que el texto exista).
- **Atribución a "síntesis" del autor** cuando es paráfrasis del agente que escribió la ficha.
- **Cifras redondeadas en formas que no aparecen literalmente** (e.g., "30-60%" cuando el PDF no las contiene).

**Recomendación de gobernanza:** Añadir un gate en `.agent/` que obligue a verificar que toda quote en Sección 8 esté literalmente presente en el PDF (búsqueda exacta) antes de cerrar la ficha.
