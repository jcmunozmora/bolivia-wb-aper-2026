# Cambios de auditoría — `APER2026_Bolivia_20260614.docx`

**Generado:** 2026-06-14 · **Auditor:** Claude Code (skill `aper-audit`) · **Destino:** agente de edición en Word
**Veredicto de la auditoría:** 🔴 FAIL (no apto como entregable final / mesa MEFP hasta resolver Prioridad 1).

---

## Cómo usar este documento

Cada cambio tiene: **Ubicación** (sección + frase para localizarlo), **Buscar** (texto actual), **Reemplazar por** (texto nuevo) y **Razón**.

> ⚠️ **Sobre guiones y comillas:** el texto "Buscar" usa la tipografía real del Word (guion largo `—`, guion de rango `–`, comillas `«»`/`"`). Si no encuentras una cadena exacta, localiza el pasaje por la **frase distintiva** indicada en *Ubicación* y aplica el cambio por contexto. No cambies cifras que no estén listadas aquí.

> **Verificado y CORRECTO (no tocar):** la afirmación composición→pobreza ("≈10 pp hacia bienes públicos ≈ ≈2 pp menos de pobreza extrema, significativa") **está respaldada** por el Apéndice E (BT3 = −17,8 pp, p=0,019; BT2 = −19,0 pp, p=0,085) y es trazable a `panel_fe_by_type_results.rds`. NO es cifra inventada. Solo se ajusta su contexto (ver B3 y T4).

---

# PRIORIDAD 1 — Bloqueantes (deben quedar en cero antes de publicar)

## B1 · Eliminar marcadores de trabajo sin terminar

El Word contiene **2 placeholders explícitos** y **14 marcadores `TODO_TRACE`** visibles en la prosa. **Ninguno puede aparecer en el documento final.** Para cada uno: completar el contenido o eliminar el marcador y dejar la frase cerrada.

**Placeholders a eliminar (críticos):**
- `[POR TERMINAR - A LA ESPERA DE INPUT]` — aparece **2 veces**. Uno de ellos es **toda la sección §5.2 "Patrón dual de protección: NRP por producto básico"** (la que debe presentar maíz +46% / trigo +28%). Esa sección está vacía: hay que redactarla o marcarla como pendiente fuera del cuerpo publicable.

**Marcadores `TODO_TRACE` a resolver/eliminar** (texto entre corchetes que empieza con `TODO_TRACE`):
1. `revenue_foregone_bdp` — estimación del subsidio cuasi-fiscal (sección §3.4, costo cuasi-fiscal).
2. `scores DEA pendientes de ejecución` — caja de Mensajes claves del Cap. de desempeño. **(ver B3: ya no es cierto, eliminar)**
3. `coeficientes pendientes de re-corrida de 08_extended_regressions.R sobre v12` — misma caja. **(ver B3: eliminar)**
4. `confirmar tasa de crecimiento real del VBP agro 2006–2023…` — §5.1 (serie %PSE).
5. `shares promedio 2018–2023 de MPS, BT y GSSE pendientes de output Hector…` — §5.1.2.
6. `GSSE/TSE Bolivia promedio 2018–2023 + benchmark LAC mediano…` — §5.1.3 (GSSE).
7. `cifra fiscal pendiente coordinación STC` — Opción O1.
8. `revisar APER 2011 cap. 6 contra evidencia 2024` — Opción O2.
9. `tabla composición ex-ante/ex-post — pendiente outputs Hector…` — Escenario **S01**.
10. `rango cuantitativo` — banda de incertidumbre S01.
11. `figura fig_06_02_reasignación_waterfall — pendiente…` — Escenario **S02**.
12. `rango cuantitativo` — banda S02.
13. `rango cuantitativo` — banda S03.
14. `set de elasticidades final` — banda de incertidumbre por escenario.

## B2 · Cuantificar (o reetiquetar) los escenarios S01 / S02 / S03

El capítulo de recomendaciones anuncia "opciones técnicas **cuantificadas** (S01, S02, S03)" pero las tres carecen de tabla de composición ex-ante/ex-post y de banda de efecto (todas en `TODO_TRACE`). **Acción:** completar la cuantificación, **o** cambiar el título de la sección y el texto para que digan explícitamente "opciones técnicas (cuantificación pendiente de cierre con STC)", de modo que no se prometa lo que no se entrega.

- **Buscar:** `Reasignación — opciones técnicas cuantificadas (S01, S02, S03)`
- **Reemplazar por (si no se cuantifica a tiempo):** `Reasignación — opciones técnicas para consideración del MEFP (S01, S02, S03)`
- **Razón:** evitar prometer cifras que el cuerpo no contiene.

## B3 · Resolver la contradicción "resultados pendientes" vs "resultados definitivos"

La caja de Mensajes claves y la síntesis del Cap. 5 dicen que el DEA y el panel FE están "pendientes/en consolidación", pero §5.3 presenta el DEA como final (score 0,60) y §5.4 + Apéndice E presentan coeficientes definitivos. **Como el DEA y el panel FE ya están corridos, hay que borrar los disclaimers de "pendiente".**

### B3.1 — Síntesis del Cap. 5
- **Buscar:** `El análisis cuantitativo dEl Capítulo V produce dos hallazgos cifrados (F02, F03) y tres bloques de evidencia en consolidación (PSE descompuesto, DEA Simar-Wilson, panel FE).`
- **Reemplazar por:** `El análisis cuantitativo del Capítulo V produce dos hallazgos cifrados (F02, F03) y tres bloques de evidencia adicionales: el PSE descompuesto, la frontera de eficiencia DEA Simar-Wilson y el panel de efectos fijos.`
- **Razón:** corrige la errata "dEl Capítulo V" y elimina "en consolidación" (los resultados están).

### B3.2 — Cierre de la síntesis (punto iv)
- **Buscar:** `y (iv) la relación gasto-resultados a nivel departamental y la eficiencia técnica subnacional requieren completarse con las corridas pendientes para cerrar el diagnóstico.`
- **Reemplazar por:** `y (iv) a igual nivel de gasto, una mayor participación de bienes públicos se asocia con menor pobreza departamental, mientras el nivel de gasto por sí solo no muestra asociación robusta (Apéndice E).`
- **Razón:** reemplaza el disclaimer de "pendiente" por el resultado real ya verificado.

### B3.3 — Viñeta de incertidumbre del Cap. 5
- **Buscar:** `DEA pendiente de decisión orientación input vs output (ADR a generar); regresiones FE pendientes de re-corrida sobre v12.`
- **Reemplazar por:** `DEA estimado con orientación al input bajo retornos variables a escala (ADR-0016); panel FE estimado sobre el gasto municipal MEFP del panel v12 (script de regresión por tipo de gasto).`
- **Razón:** describe la metodología real en lugar de marcarla como pendiente.

### B3.4 — Caja de Mensajes claves (Cap. de desempeño)
Eliminar las dos viñetas/notas que contienen `[TODO_TRACE: scores DEA pendientes de ejecución]` y `[TODO_TRACE: coeficientes pendientes de re-corrida…]` (ver B1 ítems 2 y 3). Dejar la viñeta cerrada describiendo el resultado, no el pendiente.

---

# PRIORIDAD 2 — Contradicciones y cifras inconsistentes

## C1 · Año base del FIES (49% → 74%): unificar a promedios trienales

El Cap. 6 y el hallazgo canónico **F06** usan **"49% (promedio 2014–2016) → 74% (promedio 2022–2024)"**. El Cap. 1 usa años puntuales (2019/2024). Corregir el Cap. 1 para que coincida.

### C1.1 — Caja de Mensajes claves (Cap. de desempeño)
- **Buscar:** `la inseguridad alimentaria FIES pasó de 49% (2019) a 74% (2024) (F06)`
- **Reemplazar por:** `la inseguridad alimentaria FIES pasó de 49% (promedio 2014–2016) a 74% (promedio 2022–2024) (F06)`

### C1.2 — Cuerpo, sección "Pobreza rural y seguridad alimentaria"
- **Buscar:** `La prevalencia de inseguridad moderada o severa (FIES) pasó del 49% en 2019 al 74% en 2024, un aumento de 25 puntos porcentuales`
- **Reemplazar por:** `La prevalencia de inseguridad moderada o severa (FIES) pasó del 49% en el promedio 2014–2016 al 74% en el promedio 2022–2024, un aumento de 25 puntos porcentuales`

- **Razón (C1):** regla de consistencia del proyecto — prevalece `04_HALLAZGOS.md` (F06).

## C2 · Cita del FIES en la Introducción (fuente errónea)

La introducción atribuye el 74% (2022–2024) a "WFP, 2022": temporalmente imposible (una fuente de 2022 no reporta dato de 2024) y FIES es una métrica **FAO/FAOSTAT**, no WFP. El cuerpo ya lo cita bien como "FAO et al., 2024".

- **Ubicación:** Introducción, frase "el 74% de la población registró inseguridad alimentaria moderada o severa".
- **Buscar:** `(escala FIES; WFP, 2022)`
- **Reemplazar por:** `(escala FIES; FAO et al., 2024)`
- **Razón:** corregir agencia y año de la fuente; alinear con el cuerpo.

## C3 · Numeración de capítulos — ⚠️ DECISIÓN ESTRUCTURAL REQUERIDA

Hay **tres esquemas en conflicto** en el mismo documento:
- **Índice (TOC):** capítulos **I–IV** (4 capítulos).
- **Encabezados del cuerpo:** "Capítulo I: Desempeño…", "Capítulo IV: Recomendaciones…".
- **Narrativa de la introducción + referencias cruzadas:** esquema de **6 capítulos** → "El Capítulo II caracteriza el desempeño… III… IV… V desarrolla el análisis de eficiencia… VI sintetiza", y a lo largo del texto: "Capítulo V", "capítulo 6", "§5.4", "§6.3", "Figura 5.6".

Un lector al que se le dice "ver §5.4 / Capítulo V" **no encuentra** ese capítulo en el cuerpo. Las figuras del capítulo de eficiencia, además, llevan prefijo **"3.x"** mientras el texto las llama "5.x".

**Esquema canónico recomendado** (el que ya asumen la introducción, las referencias cruzadas y `04_HALLAZGOS.md` → `02_…`, `03_…`, `04_…`, `05_…`, `06_…`):

| Contenido | Capítulo | Prefijo de figuras |
|---|---|---|
| Introducción | 1 | — |
| Desempeño del sector | 2 | Fig. 2.x |
| Estructura/dinámica del gasto (presupuesto + MAFAP) | 3 | Fig. 3.x |
| Organización territorial del gasto | 4 | Fig. 4.x |
| Análisis: PSE/NRP, DEA, panel FE | 5 | Fig. 5.x |
| Recomendaciones y opciones | 6 | Fig. 6.x |

**Acción para el agente de Word:** elegir UN esquema (se recomienda el de 6 capítulos de la tabla) y aplicarlo de forma global a: (a) encabezados de capítulo, (b) índice/TOC, (c) prefijos de todas las figuras, (d) todas las referencias cruzadas en prosa ("Capítulo …", "capítulo …", "§…", "Figura …"). Verificar que cada "§5.4", "§6.3", "Capítulo V", "capítulo 6", "capítulo 3", "capítulo 2" del texto apunte al capítulo correcto bajo el esquema elegido.

## C4 · Defectos de numeración/título de figuras (concretos)

### C4.1 — Caption "Figura 3.2" duplicado
El caption `Figura 3.2: Eficiencia técnica frente al nivel y la composición del gasto agropecuario, por departamento` aparece **dos veces**. La segunda corresponde en realidad a la figura de **coeficientes del panel de efectos fijos** (el texto contiguo la llama "la figura 5.6").
- **Acción:** renumerar y retitular la **segunda** ocurrencia. Bajo el esquema de 6 capítulos:
- **Reemplazar la 2.ª por:** `Figura 5.6: Coeficientes del panel de efectos fijos — gasto y resultados departamentales, con intervalos de confianza.`
- **Razón:** el caption repetido y el desfase "figura 5.6" ↔ "Figura 3.2" confunden al lector.

### C4.2 — Año en la Figura del valor agregado (PIB)
El caption dice "Bolivia 2000–2024" pero el texto alternativo de la imagen dice "Bolivia 1990–2024".
- **Acción:** unificar el rango de años (confirmar el eje X real de la figura y dejar **un solo** rango en caption y alt-text).

## C5 · 🔴 CIFRAS FALSAS en §5.4 — corregir contra el RDS (VERIFICADO)

**El subagente de trazabilidad leyó los RDS y confirmó que los porcentajes de composición de §5.4 ("Lo que importa es la composición") NO se reconstruyen desde ningún corte del panel.** Las cifras correctas (de `panel_fe_by_type_results.rds$panel`, vía `02_code/03_analysis/11_panel_fe_by_type.R`, mismo gasto municipal MEFP devengado 2016–2024) son:

| Grupo | docx §5.4 (ACTUAL, incorrecto) | RDS (CORRECTO, 2016→2024) |
|---|---|---|
| Apoyo directo a la producción | 43% → 63% 🔴 | **33% → 51%** |
| Riego e infraestructura | 27% → 16% 🔴 | **39% → 29%** |
| Servicios técnicos (I+D, ext., sanidad) | ~14% "estancado" 🟡 | **17% → 13% (cayó, no se estancó)** |
| Tierras y otros | 15% → 7% 🟡 | **11% → 7%** |

> ⚠️ Estas son exactamente las cifras del borrador en edición (Untitled-2). **No las publiques: corrígelas a la columna del RDS antes de cerrar.**

### C5.1 — Reemplazo del párrafo de composición (§5.4)
- **Buscar:** `El apoyo directo a la producción se expandió del 43% al 63% del presupuesto sectorial. En paralelo, el riego e infraestructura se contrajo del 27% al 16%, y la categoría de tierras y otros bajó del 15% al 7%. Los servicios técnicos — investigación, extensión y sanidad, clasificados como los bienes públicos de mayor retorno social documentado (§5.1.3) — se mantuvieron estancados en aproximadamente el 14% a lo largo de toda la serie, sin mostrar expansión.`
- **Reemplazar por:** `El apoyo directo a la producción se expandió del 33% al 51% del gasto agropecuario municipal entre 2016 y 2024. En paralelo, el riego e infraestructura se contrajo del 39% al 29% y la categoría de tierras y otros bajó del 11% al 7%. Los servicios técnicos — investigación, extensión y sanidad, clasificados como los bienes públicos de mayor retorno social documentado (§5.1.3) — no solo no ganaron terreno sino que retrocedieron, del 17% al 13% de la serie. Esta es la misma base de gasto municipal MEFP del capítulo de organización del gasto, leída aquí en cuatro grupos funcionales (apoyo, riego, servicios técnicos, tierras) en lugar de la dicotomía apoyo directo (A) / bienes públicos (D).`
- **Razón:** los números actuales no provienen del panel; los del RDS sí. Además se aclara el universo para que §5.4 no parezca contradecir al capítulo de organización (ver C5.3). Nota: el redondeo "≈2 pp" de la asociación composición→pobreza **no cambia** (los coeficientes BT2/BT3 quedaron confirmados, ver Anexo).

### C5.2 — Si el texto repite "43%/63%" en cualquier viñeta o resumen
Buscar también cualquier otra aparición de "43%" y "63%" asociada a la composición del gasto y aplicar la misma corrección (33%/51%).

### C5.3 — Los dos pasajes SON el mismo gasto, distinta clasificación (no son contradicción real una vez corregido)
- El Cap. de organización (Pasaje A: apoyo A **33%→53%**, bienes públicos D **67%→47%**, "riego 58%→28%") usa letras MAFAP: "riego" ahí es la sub-categoría **D6 dentro de D**. **Está correcto** (verificado contra `gasto_agro_prog_muni_mafap.rds`).
- **Acción opcional (recomendada):** añadir nota al pie en el Pasaje A aclarando "riego = sub-categoría D6 dentro de bienes públicos D", porque el lector ve "riego 58%→28%" junto a "D 67%→47%" y puede confundirlos.
- ⚠️ **Ojo con el "apoyo 33%→53%" del Pasaje A vs "33%→51%" del RDS de grupos:** difieren porque A (letra MAFAP) ≠ grupo "apoyo" (el grupo no incluye exactamente las mismas actividades que la letra A). Verificar cuál corresponde a cada pasaje; si el Pasaje A cita 53% para "A" y §5.4 cita 51% para "apoyo", **etiquetar la diferencia** o unificar la definición.

## C6 · "339 municipios" en la Introducción vs. realidad de 9 departamentos

La introducción anuncia "regresiones de panel con efectos fijos a nivel subnacional para **339 municipios (2012–2021)**", pero el DEA y el panel FE del Cap. 5 son a **nivel departamental (9 unidades, N=45–81)**; lo municipal es la *clasificación* del gasto y las correlaciones de Spearman, no las regresiones FE.

- **Buscar:** `aplica análisis de eficiencia técnica mediante DEA Simar-Wilson bootstrap y regresiones de panel con efectos fijos a nivel subnacional para 339 municipios (2012–2021) —dimensión inexistente en el APER 2011—`
- **Reemplazar por:** `aplica análisis de eficiencia técnica mediante DEA Simar-Wilson bootstrap y regresiones de panel con efectos fijos a nivel departamental (DEA 2012–2020; panel de efectos fijos 2016–2024), apoyadas en la clasificación MAFAP del gasto agropecuario municipal —dimensión inexistente en el APER 2011—`
- **Razón:** describir el diseño realmente ejecutado; no atribuir las regresiones FE a 339 municipios.

---

# PRIORIDAD 3 — Caveats de transparencia

## T1 · Crédito "×11,7": es NOMINAL; el real es ×7,1 (convención USD 2015)

El reporte declara que todos los montos van en USD constantes de 2015, pero el titular "×11,7" es **nominal**; en términos reales el factor es **7,1** (USD 385→2.725 M de 2015, ya explicado una vez en el cuerpo). **Regla recomendada:** en cada titular emparejar el real con el nominal, liderando con el real.

### T1.1 — Introducción
- **Buscar:** `el crédito agropecuario se multiplicó por 11,7 entre 2010 y 2024 (Banco Central de Bolivia, 2024)`
- **Reemplazar por:** `el crédito agropecuario se multiplicó por 7,1 en términos reales —×11,7 en términos nominales— entre 2010 y 2024 (Banco Central de Bolivia, 2024)`

### T1.2 — Caja de Mensajes claves (Cap. de desempeño)
- **Buscar:** `el crédito agropecuario se multiplicó por 11,7 entre 2010 y 2024 (F05)`
- **Reemplazar por:** `el crédito agropecuario se multiplicó ×7,1 en términos reales (×11,7 nominal) entre 2010 y 2024 (F05)`

### T1.3 — Caja "diez veces el gasto presupuestario" (revisar unidades)
- **Ubicación:** caja que dice "el crédito regulado… se multiplicó ×11,7 hasta alcanzar USD 3,4 mil millones en 2024 — diez veces el gasto presupuestario del mismo año".
- **Problema:** "diez veces" compara crédito **nominal** (3.397) contra gasto **real** (341). En términos reales (2.725 vs 341) el múltiplo es **~8×**, no 10×.
- **Reemplazar por:** `…el crédito regulado al sector agropecuario alcanzó USD 2.725 millones (constantes de 2015) en 2024 —alrededor de ocho veces el gasto presupuestario del sector ese año—`
- **Razón:** comparar magnitudes en la misma unidad (real). **Confirmar el múltiplo exacto contra el panel.**

> Las demás menciones de "×11,7 / 11,7 veces" en el cuerpo (hipótesis del desacople, Ley 393, Mensaje 2, Opción O6) pueden conservarse si en su primera aparición por capítulo se añade "(nominal; ×7,1 real)". Decisión del equipo.

## T2 · Período del factor ×10 (F01): 2000–2015 vs 1990–2015

El Cap. 1 dice "2000–2015"; el Cap. 6 y el hallazgo canónico **F01** dicen "1990–2015" (≈USD 30 M a comienzos de los noventa → 320 M en 2015). Alinear el Cap. 1 a **1990–2015**. *(Confirmar que el panel tenga dato de inversión desde 1990; si arranca en 2000, alinear al revés.)*

### T2.1 — Introducción
- **Buscar:** `Entre 2000 y 2015, la inversión pública en el sector agropecuario boliviano se multiplicó por diez`
- **Reemplazar por:** `Entre 1990 y 2015, la inversión pública en el sector agropecuario boliviano se multiplicó por diez`

### T2.2 — Caja de Mensajes claves
- **Buscar:** `La inversión pública sectorial se multiplicó por diez (2000–2015) mientras la PTF creció 30% (F01)`
- **Reemplazar por:** `La inversión pública sectorial se multiplicó por diez (1990–2015) mientras la PTF creció 30% (F01)`

### T2.3 — Sección "Inversión y PTF"
- **Buscar:** `La inversión pública agropecuaria se multiplicó por diez entre 2000 y 2015, mientras que el índice PTF se mantuvo en una banda estrecha`
- **Reemplazar por:** `La inversión pública agropecuaria se multiplicó por diez entre 1990 y 2015, mientras que el índice PTF se mantuvo en una banda estrecha`

### T2.4 — §5.1 (referencia a F01)
- **Buscar:** `F01: inversión real ×10 entre 2000 y 2015`
- **Reemplazar por:** `F01: inversión real ×10 entre 1990 y 2015`

## T3 · EMAPA 25%→42% son 17 pp, no 16

- **Buscar:** `Ese desplazamiento de 16 puntos porcentuales tiene un espejo claro: el bloque subnacional se contrajo del 38% al 22%.`
- **Reemplazar por:** `Ese desplazamiento de 17 puntos porcentuales tiene un espejo claro: el bloque subnacional se contrajo 16 puntos, del 38% al 22%.`
- **Razón:** 42 − 25 = 17 pp (la otra viñeta del mismo capítulo ya dice "17 puntos"); el −16 corresponde a la contracción subnacional.

## T4 · Afirmación composición→pobreza: registrar como hallazgo y precisar el redondeo

La afirmación es correcta y trazable, pero (a) **no está registrada como hallazgo** (no hay F09) pese a ser la base de la lógica de repurposing (S01/S02), y (b) el "≈2 pp en pobreza extrema" sale de BT3 = 1,78 pp.

- **Acción 1 (gobernanza, fuera del Word):** crear contrato F09 en `04_HALLAZGOS.md` para la asociación composición→pobreza.
- **Acción 2 (texto, opcional):** asegurarse de que diga "**alrededor de** 2 puntos porcentuales" (no "2,0"), para reflejar el rango 1,8–1,9 pp del Apéndice E. La redacción actual ("alrededor de 2 puntos") ya cumple — solo no cambiarla a una cifra exacta.

---

# Checklist final antes de regenerar el Word

- [ ] B1 — 0 marcadores `TODO_TRACE` y 0 `[POR TERMINAR]` en el cuerpo.
- [ ] B1 — §5.2 (NRP por producto: soya/arroz/maíz/trigo) redactada y completa.
- [ ] B2 — S01/S02/S03 cuantificados o reetiquetados.
- [ ] B3 — eliminados los disclaimers de "pendiente/en consolidación" del DEA y panel FE.
- [ ] C1/C2 — FIES a promedios trienales + cita FAO et al., 2024.
- [ ] C3 — un único esquema de numeración de capítulos aplicado de forma global.
- [ ] C4 — captions de figuras únicos y correctos.
- [ ] C5 — composición MAFAP reconciliada o etiquetada por universo.
- [ ] C6 — corregido "339 municipios" en la introducción.
- [ ] T1/T2/T3 — crédito real vs nominal, período F01, EMAPA 17 pp.

---

---

# ANEXO A — Verificación de trazabilidad (`aper-trace-verifier`, completado)

**Cifras verificadas directamente contra los RDS del panel v12.**

### ✅ Composición→pobreza (coeficientes BT2/BT3) — CONFIRMADO, NO tocar
- **Pobreza extrema (BT3):** coef `sh_tecnicos` = **−17,833**, p = **0,0194** → docx "−17,8 (p=0,019)" ✅
- **Pobreza moderada (BT2):** coef `sh_tecnicos` = **−19,014**, p = **0,0851** → docx "−19,0 (p=0,085)" ✅
- Fuente: `panel_fe_by_type_results.rds` · `02_code/03_analysis/11_panel_fe_by_type.R` (l. 72–73). El "≈2 pp por cada 10 pp hacia bienes públicos" se sostiene.

### 🟡 DEA score medio 0,60 — CORRECTO pero frágil a la definición
- `mean(eff_bc_in)` = **0,601** (orientación **input, bias-corrected**) → redondea a 0,60 ✅
- Otras definiciones del mismo RDS dan distinto: input sin corregir 0,69; output bias-corrected 0,71; output sin corregir 0,76. **El 0,60 solo se sostiene con input + bias-corrected.**
- **Acción:** en §5.3 escribir explícitamente "score medio bias-corrected, orientación input = 0,60" (refuerza B3.3). Período correcto: **2012–2020** (no 2012–2021).

### ✅ Crédito real/nominal — aritmética CONFIRMADA
- Real: 2.725 / 385 = **7,08×** ✅ · Nominal: 3.397 / 290 = **11,71×** ✅
- "Diez veces el gasto presupuestario": 3.397 (nominal) / 341 (real) = 9,96 ≈ 10× — **mezcla bases**; real/real = 2.725 / 341 = **8,0×** (confirma T1.3 → usar ~8×).
- 🟡 **Gap de trazabilidad:** las 4 cifras del crédito (290/385/3.397/2.725) viven **solo en prosa + URL del BCB**; no hay un RDS local que las contenga (`18_revenue_foregone.R` está pendiente). Acción de pipeline (no del Word): materializar la serie de cartera BCB 2010–2024 en un RDS reproducible y tabular real+nominal juntos.

### Resumen de acciones nuevas que introdujo esta verificación
1. **C5.1 — corregir las cifras de §5.4** (43→63 etc. son falsas; usar 33→51, 39→29, 17→13, 11→7). ← lo más importante.
2. **B3.3 / C-DEA — fijar la definición del 0,60** ("bias-corrected, input-oriented") y período 2012–2020.
3. **T1.3 — confirmado** el "~8×" real.
4. **Pipeline (fuera del Word):** crear RDS reproducible de la cartera BCB.

---

# ANEXO B — Verificación de citas (`aper-citation-auditor`, completado)

**Veredicto: 🔴 FAIL.** Bibs auditados: `04_report/references.bib` (375) y `03_literature/references_master.bib` (361). Gate §13B.

## 🔴 Bloqueos de citas

### CB1 — Cifra "7–15 veces" NO está en la fuente citada (Mogues et al., 2012)
- **Ubicación:** Cap. de estructura, §MAFAP, frase con "(Mogues et al., 2012)".
- **Buscar:** `el retorno a la investigación y la extensión es 7–15 veces mayor que el de las transferencias directas (Mogues et al., 2012)`
- **Problema:** la ficha `MoguesEtAl2012.md` (green, PDF verificado) reporta **mediana 30–50% de retorno social**; **no contiene el múltiplo "7–15×"**. Cifra no trazable a la fuente.
- **Acción:** re-verificar contra el PDF; si no aparece, reformular a "el retorno social de I+D y extensión (mediana 30–50%) supera al de las transferencias directas (Mogues et al., 2012)" **o** citar la fuente real del "7–15×".

### CB2 — Goyal y Nash (2017): elasticidades y geografía equivocadas
- **Ubicación:** Cap. de desempeño, §"Inversión y PTF", mecanismo composicional.
- **Buscar:** `Goyal y Nash (2017) estiman elasticidades de 0,1–0,3 para bienes públicos frente a elasticidades negativas para transferencias genéricas en América Latina`
- **Problema:** Goyal-Nash 2017 es *Public Spending Priorities for **African** Agriculture* (`scope: Subsaharan`); la ficha no registra esas elasticidades ni resultados para LAC. Doble error: cifra ausente + atribución geográfica errónea (SSA presentado como "América Latina").
- **Acción:** corregir a "África subsahariana" y verificar el rango en el PDF, **o** mover las elasticidades a una fuente LAC real (p. ej. Anríquez/López-Galinato).

### CB3 — Citas que apuntan a fichas RED con gemelo GREEN (mismatch de citekey)
Anclar a los citekeys **green** y depurar las fichas rojas duplicadas:
| Cita en el texto | Citekey ROJO (no usar) | Citekey VERDE (usar) |
|---|---|---|
| Gautam et al. 2022 (P3, S01, S02) | `02_public_spending/Gautam2022` | `01_systematic_reviews/Gautam2022` |
| Pernechele et al. 2021/2018 (O2, O4, O9) | `02_public_spending/Pernechele2021` | `FAO2021_PEFoodAgricultureSSA` |
| Anríquez et al. 2016 (O1, S01) | `02_public_spending/Anriquez2016` | `AnriquezEtAl2016_IDB_PE_LAC` |
- **Acción (pipeline/.qmd, no Word):** corregir los `[@key]` en los `.qmd` fuente a la versión green antes de re-renderizar. El contenido es verificable; el riesgo es que el render apunte a la ficha roja.

### CB4 — Referencias huérfanas (sin entrada .bib): Hansen 2013 y MapBiomas 2024
- **Ubicación:** Cap. de desempeño, §Cobertura del suelo; MapBiomas también en Introducción y Figura 1.8.
- **Problema:** ninguna tiene entrada en los `.bib` (existen solo como APA manual en el Word) → **se perderán/desincronizarán en el próximo render de Quarto**.
- **Acción (pipeline):** crear `Hansen2013` (@article *Science* 342:850–853, DOI 10.1126/science.1244693) y `MapBiomas2024` (@misc/dataset) en `references.bib`.

### CB5 — 🔴 La bibliografía del Word está INCOMPLETA (solo capítulos I–II)
- **Problema:** la sección "Referencias" renderizada (~33 entradas) contiene **solo** fuentes de los capítulos I–II. **Faltan todas las de los capítulos III y IV** (~22): OECD 2016/2025, De Salvo & Egas Yerovi 2018, Simar & Wilson 1998/2007, Krueger et al. 1988, Anderson et al. 2013, López & Galinato 2007, Barreiro-Hurlé & Witwer 2013, Pernechele 2018/2021, Anríquez 2016/2020, Gautam 2022, Damania 2023, World Bank 2024b, Searchinger 2019, Laborde 2021, FOLU 2019, Rentschler & Bazilian 2017, Coady 2019, Hurley 2014, Alston 2000/2011, WB & MwAPATA 2025.
- **La mayoría SÍ existe en el `.bib`**; es un fallo de **render** (Quarto no procesó los `[@key]` de Cap. III/IV, o el documento se ensambló parcialmente).
- **Acción (bloqueante):** re-renderizar verificando que la bibliografía cubra los 4 capítulos. Sin esto el lector ve docenas de citas sin entrada en Referencias.

## 🟡 Caveats de citas

### CB6 — Fuglie: ventana 1990–2020, no 2023; y el "30%/15 años" es cálculo propio
- **Ubicación:** Cap. de desempeño, §PTF (y figuras 1.5/1.6 rotuladas "1961–2023").
- **Buscar:** `Entre 1990 y 2023, la tasa media anual de crecimiento de la PTF en Bolivia se ubicó aproximadamente 30% por debajo del promedio de Perú, Colombia y Ecuador, según estimaciones armonizadas del USDA (Fuglie et al., 2024).`
- **Reemplazar por:** `Entre 1990 y 2020, la tasa media anual de crecimiento de la PTF en Bolivia se ubicó aproximadamente 30% por debajo del promedio de Perú, Colombia y Ecuador (cálculo propio sobre el índice USDA-ERS; Fuglie et al., 2024).`
- **Problema:** `Fuglie2024.md` (green) cubre **1961–2020**; el "30% por debajo / rezago de 15 años" no figura en la ficha (es inferencia del equipo, no claim citable de Fuglie). **Confirmar la cobertura real de la serie TFP**: si termina en 2020, relabelar las figuras 1.5/1.6/1.7 (que muestran 2023) a 2020.
- **OJO:** no usar la ficha roja gemela `Fuglie2024_USDA_TFP` (red — inventa una mención a Bolivia y la cifra −0,04%). Usar `Fuglie2024`.

### CB7 — "Fuglie y Wang (2013)" → citekey con metadata inconsistente
- La cita autor-año es correcta, pero el citekey `FuglieRada2013` (yellow) en realidad es *Choices* 27(4) **2012**. Riesgo de año/volumen erróneo en la referencia compilada. **Acción (pipeline):** corregir a `FuglieWang2012` con año/volumen reales.

### CB8 — FIES: refuerza C2 (y reserva WFP para lo territorial)
- Además de cambiar "WFP, 2022" → "FAO et al., 2024" en la Introducción (ver **C2**): la ficha `WFP2022_BoliviaACR.md` (green) reporta "**75% de familias sin acceso regular a alimentos**" — cifra **distinta** de la serie FIES 49→74. **Acción:** atribuir el 74% FIES a `FAO2024_SOFI`/FAOSTAT en todo el documento, y reservar WFP 2022 **solo** para la frase territorial (Chuquisaca/Potosí/Oruro), que sí está en su ficha.

### CB9 — "World Bank 2024b" es ambiguo
- 4 candidatos en `.bib` (`WorldBank2024Recipe`, `WB2024_LACEconomicReview`, `WorldBank2024_PovertyEquityBrief`, `WorldBank2024_RepurposingSupport`). **Acción:** fijar el citekey único por contexto (probablemente `WorldBank2024_RepurposingSupport` o `…Recipe`).

### CB10 — Afirmaciones no triviales sin cita
- **Mandato de etanol "10% en 2018, meta 25% para 2025"** (Introducción): **sin cita** → agregar fuente (norma/DS o fuente secundaria).
- **Desglose crédito ×11,7 nominal vs ×7,1 real:** atribuido a BCB 2024 (ficha green) pero el desglose nominal/real no tiene cita → verificar trazable a panel/RDS (ver Anexo A: hoy vive solo en prosa).
- **Soya 98,8% en Santa Cruz / 64,7% superficie en Santa Cruz** (INE 2015/Censo 2013, fichas green): confirmar que la cifra exacta sale del Censo y no es inferencia.
- **"Sistema alimentario global ~25% de emisiones GEI"** (S03): citado a Searchinger/Laborde/FOLU, pero `Searchinger2019WRI` y `Laborde2021GHG` **no tienen ficha** → `unverified` para el gate §13B aunque existan en `.bib`. Crear fichas o marcar.

---

# RESUMEN EJECUTIVO DE ACCIONES (consolidado)

**Texto en el Word (find/replace listos):** C1, C2, C5.1, C6, T1, T2, T3, CB1, CB2, CB6, CB8, B3.1–B3.3.
**Decisiones tuyas:** C3 (esquema de numeración), B2 (cuantificar o reetiquetar S01–S03), CB9 (citekey WB 2024b), CB10 (citas faltantes).
**Bloqueos de render/pipeline (fuera del Word, antes de regenerar):** CB3 (citekeys green), CB4 (orphans en .bib), CB5 (bibliografía Cap. III–IV faltante), CB7 (FuglieWang), DEA-RDS y crédito-RDS (Anexo A).
**Contenido a producir:** B1 (§5.2 NRP vacía), B2 (escenarios).
