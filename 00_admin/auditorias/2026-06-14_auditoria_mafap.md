# Auditoría profunda — Aplicación de la metodología MAFAP (Capítulo 3)

**Fecha:** 2026-06-14 · **Alcance:** Cap. 3 `03_budget_institutions.qmd` + pipeline MAFAP (`17_mafap_classification.R`, `11_figures_mafap.R`, `mafap_bolivia.rds`) + Apéndices C/D + ADR-0009/0010 + citas.
**Método:** 3 auditorías adversariales independientes (trazabilidad cuantitativa, gates metodológicos A1–A6/G1–G7 + rigor FAO-MAFAP, gate §13B citas) + revisión directa del código.
**Veredicto inicial:** 🔴 **FAIL** — núcleo MAFAP no publicable hasta resolver 2 críticos + 4 mayores.
**Estado tras esta sesión:** 🟡 **1 crítico resuelto** (unidades). Resto pendiente de decisión humana.

---

## 1. Resumen ejecutivo

Las cifras macro del capítulo (Maputo, inversión VIPFE, crédito BCB, BOOST) son **trazables y reproducen el panel v12**. El problema se concentra en el **núcleo MAFAP A–E**: un bug de unidades (ya corregido), una decisión metodológica no declarada (MPS dentro de A), una cita metodológica al manual equivocado, un crosswalk decorativo, y subcategorías citadas en prosa que no se calculan.

---

## 2. Hallazgos críticos

### C1 — Bug de unidades en categoría E y `full` · ✅ RESUELTO (m0.1.1, 2026-06-14)
`17_mafap_classification.R:117` multiplicaba `mun_rural_infra_bob_mm_2015` (ya en millones) ×1000, dejando E **1000× inflada**; `full = narrow + E` sumaba dos escalas. Además `11_figures_mafap.R` dividía **todas** las categorías por 1e6, aplastando A–D a ~0 y dejando E como única masa visible (causa del `fig18_summary` engañoso).
**Fix aplicado:** se eliminó el `*1000` (E queda en millones, igual que A–D) y el `/1e6` del script de figuras; `methodology_version` → `m0.1.1`. Verificado: D = 286–2.098 mm, E = 2.697–4.799 mm, `full = narrow + E` coherente. También se quitó el `*1000` análogo en `gap_cofog_042`.

### C2 — Taxonomía A–E citada contra el manual MAFAP equivocado · ⏳ PENDIENTE (decisión + verificación)
La definición de categorías A–E se atribuye a `@MAFAP2013_MethodGuideVolI`, que es el manual de **incentivos de precios (PSE/NRP)**, no de gasto público. El manual correcto es **Vol II — *Analysis of Public Expenditure*** (`MAFAP2014_PEMethodGuideVolII`), que está `audit_status: red` y por gate §13B **no es citable** hasta re-verificar contra PDF. El glosario (`C_glosario_mafap.qmd:12`) incluso escribe "Volumen II" en prosa pero usa la citekey de Volumen I.
**Acción:** re-verificar el PDF de Vol II → promover a green/yellow → re-citar A–E contra Vol II en el capítulo y el glosario.

---

## 3. Hallazgos mayores (requieren decisión humana / ADR)

### M1 — La categoría A mezcla MPS con gasto presupuestario (marco Vol I vs Vol II)
`17_mafap_classification.R:96–103`: `A1 = MPS_BOB_2015` (Market Price Support, transferencia **implícita vía precios**, no consume presupuesto) + `A2 = BT_agg` (transferencias presupuestarias). En la metodología FAO de **gasto público** (Vol II) las categorías A–E miden flujos de **gasto**; el MPS pertenece al marco OECD-PSE / Vol I. Consecuencia (ahora visible tras el fix de unidades): A oscila entre −8.020 y +2.285 mm, `narrow = A+B+C+D` no es interpretable como "gasto positivo", y la **"dinámica espejo A vs B"** es un artefacto mecánico (`B = CSE ≈ −MPS_consumidor`), no un hallazgo de política.
**Decisión requerida (ADR):** ¿A = gasto público MAFAP (Vol II, **sin** MPS) o lectura PSE-style (**con** MPS)? No pueden coexistir sin declararlo. Afecta a F02/F03 y a la coherencia con el Capítulo 5.

### M2 — El script no clasifica con el crosswalk; lo usa solo para validar
ADR-0010 afirma que `17_mafap_classification.R` "lee el CSV y aplica las reglas". En realidad el script clasifica con un mapeo **hardcoded** columna→categoría (líneas 90–146) y solo usa el crosswalk para un `setdiff` de validación. El crosswalk de 41 filas del Apéndice D **no gobierna ningún número**.
**Decisión:** o el script aplica el crosswalk como lookup, o ADR-0010/Apéndice D se degradan a "crosswalk conceptual, no operativo sobre panel v12 agregado".

### M3 — Subcategorías citadas en prosa que no se calculan
El script produce **solo agregados A–E**. La prosa cita A2.2 (crédito BDP), A1/B1 (EMAPA), B3 (desayuno escolar), D1–D9, E1–E3.3, y cifras **INIAF Bs 98M / SENASAG Bs 108M (2019)** y **cartera BDP USD 3.4bn / 68%** que **no existen como variable** en `mafap_bolivia.rds` ni en el diccionario del panel.
**Acción:** o se calculan las subcategorías y se crean las variables, o se degradan a `[TODO_TRACE]` / "según crosswalk conceptual (no cuantificado en este panel)" con cita a fuente cruda externa.

### M4 — Codificación de categoría E inconsistente entre fuentes
Glosario/`mafap_categories.csv`/prosa: E1=educación, E2=salud, E3=infraestructura (E3.1 caminos, E3.2 agua, E3.3 energía). ADR-0010 §3: E1=caminos, E2=electrificación, E4/E5=educación/salud. El mismo código `E1` significa cosas distintas.
**Acción:** unificar la codificación E en una sola fuente canónica.

---

## 4. Hallazgos menores (corregibles directamente)

| # | Hallazgo | Ubicación | Acción |
|---|---|---|---|
| m1 | Ruta de script desincronizada: ADR-0009/0010 y glosario citan `02_code/02_classification/11_mafap_classification.R` (no existe); real = `02_code/02_cleaning/17_mafap_classification.R` | ADR-0009, ADR-0010, C_glosario | Actualizar referencias |
| m2 | `mafap_C = 0` hardcoded presentado como "decisión metodológica"; en realidad es `no_data` | script:110, qmd §3.2 | Declarar `no_data` honestamente |
| m3 | Media de ejecución BOOST "~92%" → real 88.9% | qmd tbl-sintesis | Recalcular (o derivar inline) |
| m4 | Media % capital "62%" → real 64.6% | qmd §3.2.7 | Recalcular |
| m5 | Rango D-share "1.5%–9.6%" omite NA y valor >100% | qmd §3.2.5 | Reportar rango real con NA explícitos |
| m6 | Conteo "33 códigos" vs 41 filas reales | C_glosario, ADR-0010 | Unificar a 41 |
| m7 | Caption fig18c atribuye fuente "BOOST/VIPFE"; real = IDB AgriMonitor (GSSE) | qmd | Corregir fuente |
| m8 | `@oecd_pse_manual` (línea 128) apunta al reporte anual APME 2023, no al manual metodológico OECD-PSE; clave ausente del master bib | qmd:128, references.bib | Confirmar clave correcta + sincronizar bibs |
| m9 | COFOG familia C: nivel-1 declara 04.2.1 pero C2 (transportistas) → 04.5 | crosswalk CSV | Documentar reconciliación |

---

## 5. Lo que SÍ pasa (trazable y reproducible)

- **Maputo (F04):** máx 3,48% (1990); prom 1990–2007 1,72%; 2000–2007 1,87% → `speed_ag_pctexp` ✓
- **Inversión:** USD 76M (2006), 320M (2015), 261M (2024); media 2008–24 6,6% ✓
- **Crédito (F05):** 290→3.397 USD M, 5,07%→11,70%, ×11,7 ✓
- **D (GSSE):** 286→2.098 mm, ×7,3 ✓ (tras fix de unidades)
- **Citas metodológicas núcleo:** todas green salvo el problema conceptual C2.

---

## 6. Gates

| Gate | Estado | Nota |
|---|---|---|
| Trazabilidad (Inv. 3.1) | 🟡 | Macro ✓; INIAF/SENASAG/BDP/subcategorías sin variable (M3) |
| G5 citas §13B | 🟡 | Claves citadas green/yellow ✓; pero taxonomía A–E respaldada por manual equivocado (C2) |
| Rigor MAFAP-FAO | 🔴→🟡 | Unidades ✓; MPS-en-A (M1) y crosswalk (M2) pendientes |
| G6 neutralidad | ✅ | Voz WB, sin advocacy |

---

## 7. Acciones — orden de prioridad

1. ✅ ~~C1 unidades~~ (hecho).
2. ⏳ **M1 (ADR):** decidir tratamiento del MPS en A → reescribir §3.2.A y rediseñar figuras A/B/summary.
3. ⏳ **C2:** re-verificar Vol II PDF → re-citar A–E.
4. ⏳ **M2/M3/M4:** crosswalk operativo o conceptual; calcular o degradar subcategorías; unificar E.
5. **m1–m9:** correcciones menores directas.
6. Re-correr A2/A3/A4 + §13B sobre el capítulo corregido antes de `reviewed`.

---

## 8. Bitácora

| Fecha | Cambio |
|---|---|
| 2026-06-14 | Auditoría inicial (3 agentes + revisión código). C1 (unidades) resuelto en m0.1.1. |
| 2026-06-14 | **M1 resuelto (decisión: A = solo gasto público, Vol II) → m0.2.0.** `17_mafap_classification.R`: MPS excluido de A (A=BT presupuestario neto, puede ser negativo); B y C → `no_data` (CSE es price-inclusive → Cap. 5); D=GSSE, E=rural; narrow=A+D, full=+E; nuevo test T1b de coherencia de unidades; coverage_flag actualizado. RDS regenerado (tests T1–T5 ✓). **Figuras m0.2.0:** `16_fig_mafap_publicexp.R` (nueva summary honesta: D+E apilados + A línea neta); `11_figures_mafap.R` (fig18a reframe A neto +/−; fig18b RETIRADA—no_data; fig18c/d notas de subcategorías suavizadas; summary movida a script 16). fig18b eliminada de outputs. **Menores aplicados:** m1 (rutas script `02_cleaning/17_` en ADR-0009/0010 + glosario), m6 (conteo 33→41). |
| 2026-06-14 | **Reescritura de prosa §3.2 + cierre de pendientes (qmd).** §sec-mafap-marco, §sec-mafap-a, §sec-mafap-bc, §sec-mafap-d, §sec-mafap-e reescritas al marco Vol II (eliminada la "dinámica espejo" y el MPS-en-A; B/C declaradas `no_data`; D=GSSE componente positivo dominante). **C2 resuelto sin Vol II:** la taxonomía de gasto público A–E se re-cita a `@PernecheleEtAl2018_MAFAP` (green, FAO MAFAP *Public Expenditure*) en qmd (5 ocurrencias) y glosario; el Vol II queda fuera (PDF ausente + metadata errónea — confirmado por citation-auditor, sigue `red`). **M2:** crosswalk documentado como **conceptual** (no operativo sobre panel agregado) en §sec-mafap-e. **M3:** INIAF/SENASAG y cartera BDP marcadas `[TODO_TRACE]`; USD 3.4bn re-atribuido al sistema bancario (F05), no al BDP. **Menores:** 62%→64.6%, ~92%→~89%, flag `no_rural_data_E`, fig18b sin referencia colgante. fig18b retirada del set. |
| | **Pendiente:** re-verificar/corregir ficha+BibTeX Vol II (`MAFAP2014_PEMethodGuideVolII`: año 2013, autores Ghins/Ilicic-Komorowska/Mas Aparisi, 56 pp, conseguir PDF) y la entrada de reference-list del glosario (línea 165, citekey VolI con descripción VolII); M4 (unificar codificación E entre ADR-0010 y glosario); calcular subcategorías o `revenue_foregone_bdp` (script `18_revenue_foregone.R`); re-correr A2/A3/§13B sobre el capítulo corregido antes de `reviewed`. |
