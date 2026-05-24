# ADR-0009 — Adopción de MAFAP narrow + full como clasificación dual del gasto agrícola público

**Estado:** aceptado
**Fecha:** 2026-05-23
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: pendiente firma TTL]_
**Color de cambio:** rojo (toca definición operativa del GAP, afecta cifras de capítulos 3 y 4) — ver [`08_CONTROL §4.3`](../08_CONTROL.md)

---

## Contexto

El **APER Bolivia 2026** debe medir el **Gasto Agrícola Público (GAP)** sobre una ventana de 35 años (1990–2024) y comparar Bolivia con benchmarks internacionales (Maputo/CAADP, países LAC, países andinos). Existen al menos cuatro marcos de clasificación posibles para gasto sectorial agropecuario:

1. **Clasificación funcional MEFP / VIPFE** (Bolivia) — clasifica por función del Estado boliviano; útil internamente pero **no comparable internacionalmente** sin recodificación.
2. **COFOG 04.2 Agricultura** (UN/SNA) — internacionalmente comparable pero **agregado** (no permite distinguir apoyo al productor vs. bienes públicos).
3. **OECD-PSE / IDB AgriMonitor** — mide **solo apoyo al productor** (PSE) + servicios generales (GSSE) + apoyo al consumidor (CSE). **Excelente para benchmarking LAC** pero **subestima el gasto sectorial total** porque excluye agriculture-supportive expenditure (caminos rurales, electrificación rural, etc.).
4. **MAFAP/FAO** — diseñado para PERs de FAO; **captura todo el gasto sectorial** con dos definiciones:
   - **narrow:** A (apoyo al productor) + B (consumidor) + C (otros agentes) + D (apoyo general al sector). Excluye E.
   - **full:** narrow + E (agriculture-supportive: caminos rurales, electrificación, agua, educación y salud rural).

El APER 2011 (WB Informe N° 59696-BO) usó una clasificación **funcional ad-hoc** que no es replicable internacionalmente y dificulta el empalme histórico. El APER 2026 actualizará 15 años de información con un marco internacionalmente reconocido.

El **PER Sub-Saharan Africa** (FAO MAFAP, Pernechele et al. 2021) y el **PER Filipinas** (WB AgPER 2023, Weiss et al.) usan MAFAP como marco operativo. El consultor STC para repurposing/PSE coordinará con OECD-PSE para el capítulo 5.

**Tensión a resolver:**

- Si solo usamos OECD-PSE: perdemos visibilidad de bienes públicos no clasificados como GSSE (caminos rurales) y subestimamos el GAP.
- Si solo usamos MAFAP: perdemos comparabilidad LAC (IDB AgriMonitor publica PSE/CSE/GSSE, no MAFAP).
- Si solo usamos MAFAP narrow: no podemos hablar de gasto rural total.
- Si solo usamos MAFAP full: no podemos comparar con compromisos Maputo/CAADP (que usan narrow).

---

## Decisión

**Adoptar MAFAP/FAO como clasificación primaria del gasto sectorial en los capítulos 3 y 4 del APER Bolivia 2026, reportando ambas definiciones (narrow y full) en paralelo.** Mantener OECD-PSE/IDB AgriMonitor como clasificación primaria en el capítulo 5 para benchmarking LAC y medición de apoyo al productor.

**Reglas operativas:**

1. **Capítulos 3 y 4** (presupuestos, instituciones, organización del gasto):
   - Cifra principal: **MAFAP full** (A + B + C + D + E).
   - Cifra secundaria reportada en paralelo: **MAFAP narrow** (A + B + C + D).
   - Composición desagregada: 5 figuras A–E (`fig18a` a `fig18d` + `fig18_summary`).
   - Crosswalk con clasificación funcional MEFP en apéndice D.

2. **Capítulo 5** (análisis del gasto):
   - Cifra principal: **OECD-PSE** (PSE + GSSE + CSE + TSE) — para benchmarking LAC con IDB AgriMonitor.
   - Crosswalk con MAFAP D ≈ GSSE OECD en apéndice D.

3. **Capítulo 0** (resumen ejecutivo):
   - Reportar **ambas cifras del GAP** (MAFAP narrow y full) en el bullet de magnitud del sector.
   - Disclaimer breve: "dos cifras complementarias según definición internacional adoptada".

4. **Comparaciones con Maputo/CAADP** (10% del gasto público a agricultura):
   - Usar **MAFAP narrow** (excluye E rural-soporte) por consistencia con el estándar CAADP.

5. **Comparaciones con APER 2011:**
   - Recálculo aproximado de las cifras 1999–2009 del APER 2011 bajo MAFAP (best-effort).
   - Caja explícita: "el APER 2011 no usó MAFAP; este recálculo es aproximado y se reporta en apéndice B §H3.4.9".

6. **Variables del panel v12:**
   - `mafap_narrow_bob_2015` y `mafap_full_bob_2015` se agregan al panel como variables derivadas calculadas por el script `11_mafap_classification.R` (ver MAFAP-1 / ADR-0010).
   - Resto del panel se mantiene sin cambios.

---

## Alternativas consideradas

| Alternativa | Pros | Contras | Decisión |
|---|---|---|---|
| **Adopción dual MAFAP narrow + full + OECD-PSE separado por capítulo** (escogida) | exhaustividad metodológica; comparabilidad LAC vía OECD-PSE; comparabilidad Maputo vía MAFAP narrow; bienes públicos completos vía MAFAP full | requiere crosswalk + 2 cifras del GAP que pueden confundir al lector | **aceptada** |
| Solo OECD-PSE | comparabilidad LAC fuerte; cap 5 sin fricción | subestima GAP (~30% menos); no captura agriculture-supportive; no comparable Maputo | rechazada |
| Solo MAFAP narrow | comparable Maputo; estándar FAO; cap 5 con GSSE ≈ MAFAP D | pierde gasto rural-soporte; pierde comparabilidad LAC fina | rechazada |
| Solo MAFAP full | exhaustividad sectorial | no comparable Maputo; cap 5 sin equivalente; clasificación más extensa | rechazada |
| Adoptar OECD-PSE como primario en todos los capítulos | consistencia interna | mismo problema que opción 2 + pierde el espíritu de PER FAO | rechazada |

---

## Consecuencias

### Sobre cifras del reporte

- **El GAP de Bolivia se reportará en dos cifras paralelas en todo el book.** Esto requiere disciplina narrativa: cada vez que se cite el GAP, declarar cuál definición se usa.
- **Maputo se evaluará con MAFAP narrow** (F04 — máx 3.48% en 1990). Recalcular si el script de clasificación produce serie ligeramente distinta.
- **Las series 2010–2024 cubren la ventana de mayor cobertura BOOST** (ver `02_INDICADORES §G04`). Las series 1990–2009 requerirán imputación documentada en apéndice B.

### Sobre el panel v12

- Se agregan 2 variables derivadas: `mafap_narrow_bob_2015`, `mafap_full_bob_2015`.
- **Bump del panel v12 → v13 NO requerido** (no se cambia ninguna variable existente; se agregan derivadas). Esto se mantiene como AMARILLO según [CONTROL §4.2](../08_CONTROL.md). Si el cálculo de MAFAP modifica retroactivamente alguna cifra existente, **promover a v13 con ADR adicional**.

### Sobre comparabilidad histórica con APER 2011

- Caja en cap 3 §H2.5 + apéndice B §H3.4.9 declarando explícitamente: "el APER 2011 no usó MAFAP; el recálculo bajo MAFAP es aproximado para empalme; no debe interpretarse como reescritura del APER 2011".

### Sobre el handoff MEFP

- Presentar las dos cifras del GAP en mesa técnica MEFP **explícitamente desde la primera entrega**. Documentar la decisión adoptada en una caja de la carta de remisión.
- Esperar que el MEFP pueda preferir una cifra sobre otra para sus comunicaciones internas. **No es problema**: el reporte muestra ambas; el MEFP escoge cuál enfatiza en su comunicación.

### Sobre el consultor STC de repurposing/PSE

- El consultor opera principalmente en OECD-PSE (cap 5). **Coordinar con él en sesión de handoff** para que use las variables `pse_*` y `PSE_*` ya consolidadas en el panel (grupo G08).
- En el cap 6 (recomendaciones de repurposing), las opciones técnicas se enmarcan como movimientos dentro de MAFAP (e.g., S02 reasigna de A a D), con cuantificación complementaria de impacto sobre PSE para benchmarking.

### Sobre auditoría futura

- Cualquier cifra del GAP citada en book/web/slides/briefs debe traer explícitamente su definición: `MAFAP narrow`, `MAFAP full`, o `OECD-PSE+GSSE`.
- Tests de neutralidad y trazabilidad ([CONTROL §9](../08_CONTROL.md), [AUDITORIA §3](../09_AUDITORIA.md)) deben agregar verificación de "cifra del GAP con definición declarada".

---

## Implementación

### Archivos modificados o a modificar

- `01_METODOLOGIA.md` → agregar §4.1.1 "Clasificación dual MAFAP narrow + full" tras §4.1 (definición de GAP).
- `02_INDICADORES.md` → agregar grupo G18 con las 2 variables derivadas MAFAP.
- `04_HALLAZGOS.md` → revisar F04 (Maputo) para citar MAFAP narrow explícitamente.
- `00_MASTER_PROMPT.md` §4.1 → ya actualizado en v0.4.0 (caja sobre clasificación dual al pie).
- `20_CONTENIDO_REPORTE.md` → ya integra MAFAP en caps 3, 4 y apéndice B §H2.4.
- **Nuevo archivo:** `02_code/02_classification/11_mafap_classification.R` (ADR-0009 desbloquea su creación).
- **Nuevo archivo:** `01_data/processed/mafap_bolivia.rds` (output del script).
- **Nuevo archivo:** `01_data/processed/crosswalk_mafap_oecd_cofog.csv` (ver ADR-0010).

### ADRs vinculados

- **ADR-0010** — Crosswalk MAFAP ↔ OECD-PSE ↔ COFOG ↔ MEFP funcional (operacionaliza esta decisión).
- **ADR-0003** — Metodología PSE/CSE (define el lado OECD-PSE del par dual).
- **ADR-0001** — Panel v12 canónico (este ADR agrega 2 variables derivadas sin bumpar el panel).

### Tests de verificación

- `test_gap_two_figures_declared`: para cada mención de "gasto agrícola público" o "GAP" en book/web, verificar que aparece la definición MAFAP usada.
- `test_mafap_narrow_equals_sum_abcd`: verificar que `mafap_narrow_bob_2015` = suma de categorías A+B+C+D del año.
- `test_mafap_full_equals_narrow_plus_e`: verificar que `mafap_full_bob_2015` = `mafap_narrow_bob_2015` + categoría E.
- `test_maputo_uses_narrow`: cualquier cita a benchmark Maputo (10% gasto público) debe usar MAFAP narrow.

---

## Validación

¿Cómo sabremos que la decisión fue correcta?

1. **Test inmediato:** tras correr `11_mafap_classification.R`, las dos cifras del GAP (narrow y full) son coherentes con BOOST + VIPFE agregados y la diferencia narrow→full es atribuible a gasto rural-soporte (E) identificable.
2. **Test funcional 3 meses:** el MEFP en mesa técnica no expresa confusión sobre las dos cifras; un revisor externo (peer review WB o académico) entiende la decisión y la justificación.
3. **Test de comparabilidad:** las cifras del APER 2026 bajo MAFAP narrow son razonablemente comparables (mismo orden de magnitud) con las del PER Filipinas 2023, PER SSA 2021, AgPER Colombia 2020 — i.e., otros PERs MAFAP.

---

## Referencias

- **FAO MAFAP — Manual Volumen II** (Ghins, Ilicic-Komorowska & Mas Aparisi, FAO 2013) — taxonomía operativa A–E.
- **PER Sub-Saharan Africa con MAFAP** (Pernechele et al., FAO MAFAP 2021) — aplicación a 13 países africanos.
- **PER Filipinas** (Weiss, Kar, Nash, Oliveros, Briones, WB 2023) — aplicación a país de ingreso medio.
- **OECD PSE Manual** — clasificación complementaria (cap 5).
- **APER Bolivia 2011** (WB Informe N° 59696-BO) — antecedente sin MAFAP; recálculo aproximado en apéndice B.

---

## Firma

Autor: Juan Carlos Muñoz Mora · 2026-05-23
Revisor TTL: _[TODO_TRACE: pendiente firma]_
Estado: aceptado (pendiente firma TTL para promoción a estado equivalente a `MEFP_validated`)
