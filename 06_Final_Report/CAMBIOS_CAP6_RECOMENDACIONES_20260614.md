# Cambios — Capítulo de Recomendaciones (propuesta inicial v1)

**Generado:** 2026-06-14 · **Skill:** `aper-writing` · **Destino:** agente de edición en Word
**Aplica a:** "Capítulo IV — Recomendaciones y opciones de política" del `.docx` (= Capítulo 6 del fuente `04_report/06_recommendations.qmd`).

## Estado de partida (importante)
- ✅ **Citas:** las 17 referencias del capítulo son todas **green/yellow** con entrada en `.bib`. El gate §13B **pasa**. (Las citas rojas del Word venían de un render viejo de los capítulos 2–5, no de este capítulo.)
- ✅ **Mensajes 1–3 del Word ya traen las cifras correctas** (FIES 49% prom 2014–2016 → 74% prom 2022–2024; ×10 en 1990–2015). No hay que corregir cifras de los mensajes.
- 🔴 **Falta la evidencia empírica del repurposing** (composición→pobreza) — se agrega en R1.
- 🟡 **Escenarios S01–S03 sin anclar** y con marcadores `TODO_TRACE` crudos — se resuelven en R4–R7 anclando el ex-ante verificado y dejando el costo fiscal al STC.
- 🔴 **§6.4 (Cronograma + M&E + Caja APER 2011) parece NO estar en el render del Word** — se restaura en R9.

> ⚠️ Tipografía: usa los guiones reales del Word (`—`, `–`). Si una cadena "Buscar" no aparece literal, localiza el pasaje por la frase distintiva.

---

## R1 · Mensaje 1 — integrar la evidencia composición→pobreza (la más importante)

El Mensaje 1 afirma "la composición, no el nivel" pero no cita la evidencia departamental que lo prueba. Agregar el resultado verificado (Apéndice E, BT3).

- **Buscar:** `una magnitud inferior al esfuerzo presupuestario y a la trayectoria observada en comparadores andinos (F01, capítulo 2). El nivel agregado de apoyo al productor`
- **Reemplazar por:** `una magnitud inferior al esfuerzo presupuestario y a la trayectoria de los comparadores andinos (F01, capítulo 2). El análisis departamental confirma que lo determinante es la composición y no el monto: a igual nivel de gasto total, una mayor participación de bienes públicos —I+D, extensión y sanidad— se asocia con menor pobreza, de manera estadísticamente significativa para la pobreza extrema, mientras el nivel de gasto total no se distingue de cero; en orden de magnitud, elevar cerca de 10 puntos esa participación se asocia con alrededor de 2 puntos porcentuales menos de pobreza extrema (capítulo 5, Apéndice E). El nivel agregado de apoyo al productor`
- **Razón:** ancla el mensaje central del capítulo en el resultado verificado (BT3 = −17,8 pp, p=0,019). Es descriptivo/asociativo, no causal — el texto lo dice así.
- **Nota de gobernanza:** este resultado debería registrarse como **F09** en `04_HALLAZGOS.md`; mientras tanto se cita como "capítulo 5, Apéndice E".

---

## R2 · Mensaje 2 — crédito real vs nominal

- **Buscar:** `la cartera de crédito agropecuario obligatorio del sistema financiero se multiplicó por 11,7, configurando una sustitución`
- **Reemplazar por:** `la cartera de crédito agropecuario obligatorio del sistema financiero se multiplicó por 7,1 en términos reales (×11,7 en términos nominales), configurando una sustitución`
- **Razón:** consistencia con la convención de USD constantes de 2015 (mismo criterio T1 de la auditoría).

---

## R3 · Opción O6 — mismo ajuste de factor

- **Buscar:** `El factor 11,7 de expansión de la cartera de crédito obligatorio post-Ley 393 (F05)`
- **Reemplazar por:** `El factor de expansión de la cartera de crédito obligatorio post-Ley 393 (×7,1 real; ×11,7 nominal) (F05)`

---

## R4 · Escenario S01 — anclar ex-ante verificado + efecto ilustrativo, costo fiscal al STC

Reemplazar el encabezado "Composición ex-ante / ex-post" + el marcador `[TODO_TRACE: tabla composición…]` + el párrafo de banda con `[TODO_TRACE: rango cuantitativo]` por el siguiente bloque:

- **Buscar (desde):** `Composición ex-ante / ex-post (panel v12 MAFAP narrow, 2018–2023 → horizonte 2025–2029).` **(hasta el final del párrafo de "Banda de incertidumbre" que termina en)** `una vez calibrada con los outputs del consultor STC [TODO_TRACE: rango cuantitativo].`
- **Reemplazar por:**

  > **Composición observada (punto de partida).** En el gasto agropecuario municipal (MEFP, 2016–2024), el apoyo directo a la producción pasó del 33% al 51% del total, mientras los servicios técnicos —I+D, extensión y sanidad— retrocedieron del 17% al 13% y el riego e infraestructura cayó del 39% al 29% (capítulo 5). S01 explora revertir parcialmente esa tendencia reasignando una fracción de referencia del 30% del MPS del período base hacia el presupuesto operativo de INIAF y SENASAG (MAFAP categoría D).
  >
  > **Efecto ilustrativo y banda.** A título descriptivo, la asociación departamental estimada (capítulo 5, Apéndice E) sugiere que elevar en torno a 10 puntos la participación de bienes públicos, a gasto total constante, se asocia con alrededor de 2 puntos porcentuales menos de pobreza extrema; es una referencia de orden de magnitud, no una proyección causal, sensible a la ventana corta y a la colinealidad entre tipos de gasto. La cuantificación del costo fiscal —el monto de MPS liberado en USD constantes de 2015 y su reasignación entre instrumentos— y la banda de efecto sobre la productividad se consolidan con el consultor STC.

- **Razón:** ancla el ex-ante con cifras del panel ya verificadas (trayectoria observada del gasto municipal), incorpora el efecto ilustrativo de pobreza, y deja explícito que el cierre fiscal (en términos MPS) es del STC. Elimina dos `TODO_TRACE` crudos sin inventar cifras fiscales.
- ⚠️ **Universo:** las cifras 33→51 / 17→13 son del **gasto municipal MEFP en 4 grupos** (la serie de §5.4), no del MPS/PSE; por eso se presentan como "trayectoria observada" y el lever del 30% del MPS se mantiene como exploración a cerrar con el STC. No fusionar ambos universos en una sola tabla.

---

## R5 · Escenario S02 — limpiar marcadores, ex-ante cualitativo

- **Buscar (desde):** `Composición ex-ante / ex-post.` **(el de S02, hasta)** `Para Bolivia, la banda se calibrará con los outputs del consultor STC [TODO_TRACE: rango cuantitativo].`
- **Reemplazar por:**

  > **Composición ex-ante / ex-post.** S02 parte de la misma composición observada (capítulo 5) y explora un desplazamiento más amplio: reducción simultánea de transferencias atadas (MAFAP A), crédito subsidiado (vía el cómputo de *revenue foregone* de la opción O4) y subsidios implícitos al consumidor (MAFAP B), con aumento equivalente de los bienes públicos al sector (MAFAP D: I+D, extensión, sanidad, infraestructura rural pública). La descomposición (gráfico de cascada) y la banda de efecto se reportan en la versión consolidada con el consultor STC.

---

## R6 · Escenario S03 — limpiar marcadores

- **Buscar (desde):** `Composición ex-ante / ex-post.` **(el de S03, hasta)** `condiciona la banda de efecto esperada [TODO_TRACE: rango cuantitativo].`
- **Reemplazar por:**

  > **Composición ex-ante / ex-post.** El componente climático y de frontera de S03 depende del cómputo de emisiones del sector (panel v12, en consolidación con el consultor STC y el especialista en desempeño ambiental). La banda de efecto es alta y sensible al cambio de uso del suelo asociado, concentrado en Santa Cruz (F08, 64% del avance de frontera).

---

## R7 · Limpiar `TODO_TRACE` restantes en opciones y bandas

### R7.1 — Opción O1
- **Buscar:** `se especifica en §6.3.1 [TODO_TRACE: cifra fiscal pendiente coordinación STC].`
- **Reemplazar por:** `se especifica en §6.3.1; su cierre fiscal se consolida con el consultor STC.`

### R7.2 — Opción O2
- **Buscar:** `el seguimiento de implementación está pendiente [TODO_TRACE: revisar APER 2011 cap. 6 contra evidencia 2024].`
- **Reemplazar por:** `el seguimiento de implementación se documenta en la Caja 6.1 (§6.4.4).`

### R7.3 — Banda de incertidumbre por escenario (ítem 1)
- **Buscar:** `a partir de la mejor evidencia comparable (Gautam et al. 2022; World Bank 2024b) [TODO_TRACE: set de elasticidades final].`
- **Reemplazar por:** `a partir de la mejor evidencia comparable (Gautam et al. 2022; World Bank 2024b).`

> Tras R4–R7 no debe quedar ningún `TODO_TRACE` en el capítulo.

---

## R8 · (Redacción) Partir los Mensajes 1–3 en TEELs — opcional pero recomendado

Cada Mensaje es un párrafo de ~190 palabras con 3–4 ideas. Para voz WB, conviene dejar la oración en negrita como *topic sentence* y abrir 1–2 párrafos cortos de evidencia. No cambia cifras; solo mejora legibilidad. Si el tiempo apremia, dejar como está (no es bloqueante).

---

## R9 · 🔴 Restaurar §6.4 (Cronograma + M&E + Caja APER 2011)

El render del Word salta de "Banda de incertidumbre por escenario" directo a "Referencias": **falta toda la sección §6.4**, que sí existe en el fuente y aparece en el índice (pág. 75). Hay que insertarla antes de Referencias. Contenido a traer del fuente `04_report/06_recommendations.qmd` (§6.4.1–6.4.4):
- **6.4.1** Cronograma indicativo de cinco años (tabla de 8 hitos por año).
- **6.4.2** Indicadores de seguimiento M&E (tres niveles: instrumento / resultado intermedio / resultado final).
- **6.4.3** Articulación con el consultor STC.
- **6.4.4** Caja 6.1 — seguimiento de las recomendaciones del APER 2011.
- **Acción:** lo más limpio es **re-renderizar el capítulo desde el fuente** (ver nota de cierre); si se edita a mano en Word, copiar §6.4 del `.qmd`.

---

## Nota de cierre (recomendación de flujo)

El capítulo fuente `04_report/06_recommendations.qmd` está **más completo y limpio** que el render actual del Word (citas correctas, §6.4 presente, banner de escenarios). La vía más eficiente para dejar la propuesta inicial es **aplicar R1–R7 al `.qmd` y re-renderizar el Word**, en lugar de parchear el Word a mano (que además no recupera §6.4). R1–R7 están redactados para funcionar igual en ambos lados.

### Checklist
- [ ] R1 — evidencia composición→pobreza en Mensaje 1.
- [ ] R2/R3 — crédito ×7,1 real (×11,7 nominal).
- [ ] R4 — S01 con ex-ante observado + efecto ilustrativo + cierre fiscal STC.
- [ ] R5/R6 — S02/S03 limpios.
- [ ] R7 — 0 `TODO_TRACE` en el capítulo.
- [ ] R9 — §6.4 restaurada.
- [ ] (gobernanza) registrar F09 = composición→pobreza en `04_HALLAZGOS.md`.
