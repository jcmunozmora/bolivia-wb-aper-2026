# 04_HALLAZGOS.md — APER 2026 Bolivia

**Versión:** v0.1.0
**Última actualización:** 2026-05-23
**Propósito:** registro versionado de los hallazgos del APER 2026, expresados como **unidades técnicas independientes** con contrato JSON, evidencia trazable y estado de validación. Es la fuente única de los claims que alimentan executive summary, capítulos del book, slides, web y briefs.
**Lecturas relacionadas:** [01_METODOLOGIA.md](01_METODOLOGIA.md), [02_INDICADORES.md](02_INDICADORES.md), [03_FUENTES.md](03_FUENTES.md), [05_ESTILO_NARRATIVO.md](05_ESTILO_NARRATIVO.md), [08_CONTROL.md](08_CONTROL.md), [09_AUDITORIA.md](09_AUDITORIA.md), [00_MASTER_PROMPT.md](00_MASTER_PROMPT.md) §7.1, §9.

---

## 1. Principio rector

> Un hallazgo es la unidad mínima de evidencia técnica reproducible del APER 2026. Si un hallazgo no puede reconstruirse desde panel v12 + script, **no existe**. Si su magnitud cambia, **es otro hallazgo o una versión nueva del mismo**.

Reglas:

1. Los hallazgos viven en este archivo, no en los capítulos. Los capítulos **citan** hallazgos por `finding_id`.
2. Cada hallazgo tiene **contrato JSON completo** (§4).
3. Cada hallazgo declara **incertidumbre** explícita.
4. Cada hallazgo declara **estado de validación**: `draft` → `reviewed` → `MEFP_validated`.
5. Cambiar magnitud, dirección o interpretación de un hallazgo es **ROJO** (CONTROL §4.3) y requiere ADR + bump de versión interno (`F03 v1` → `F03 v2`).
6. Retirar un hallazgo no lo borra: cambia su estado a `retired` con motivo y fecha.

---

## 2. Ciclo de vida de un hallazgo

```text
draft           → contrato JSON completo o casi; al menos cifra y evidencia
                  declaradas; equipo APER lo escribió pero no lo revisó.

reviewed        → A3 firmada (09_AUDITORIA.md): cifras verificadas, trazabilidad
                  completa, lenguaje neutral, paridad bilingüe si aplica,
                  incertidumbre declarada.

MEFP_validated  → A4 firmada y MEFP lo discutió en mesa técnica sin
                  objeción que cambie magnitud. Puede coexistir con nota
                  de divergencia si MEFP discrepa en interpretación pero
                  no en cifra.

contested       → MEFP u otro revisor formal objeta cifra o interpretación;
                  se documenta la disputa; el hallazgo NO se retira.

retired         → el hallazgo ya no se sostiene (e.g., panel v13 contradice
                  la cifra; metodología actualizada lo subsume); se mantiene
                  visible con motivo y referencia al ADR que lo retiró.
```

Las transiciones `reviewed → MEFP_validated → contested` ocurren tras mesa técnica con el MEFP. Transiciones a `retired` requieren ADR.

---

## 3. Versionamiento

| Componente | Esquema | Cambia cuando |
|---|---|---|
| Identificador del hallazgo | `F<NN>` (e.g. `F03`) | nunca — es estable |
| Versión interna | `v<m>` (e.g. `v1`, `v2`) | cambia magnitud, dirección o interpretación |
| `methodology_version` | `m<x.y>` (e.g. `m0.4`) | hereda de 01_METODOLOGIA.md |
| `panel_version` | `v<n>` (e.g. `v12`) | hereda del panel |

Regla: si `methodology_version` o `panel_version` cambian para el mismo `F<NN>`, el hallazgo bumpa su `v<m>`. El histórico previo no se borra (§4.7).

---

## 4. Contrato JSON canónico

Cada hallazgo se registra como bloque YAML/JSON dentro de este archivo, con esta forma:

```yaml
---
finding_id: F03
version: v1
title_es: "El gasto agrícola público se concentra en transferencias a productores y empresas estatales"
title_en: "Public agricultural spending is concentrated in transfers to producers and state enterprises"
claim_es: |
  Entre 2018 y 2023, las transferencias representaron en promedio 62% del
  gasto agrícola público ejecutado, mientras los bienes públicos (I+D,
  extensión, sanidad animal y vegetal) se ubicaron entre 14% y 19%.
claim_en: |
  Between 2018 and 2023, transfers averaged 62% of executed public
  agricultural spending, while public goods (R&D, extension, animal and
  plant health) ranged between 14% and 19%.
magnitude:
  value: [TODO_TRACE: confirmar valor exacto desde panel v12]
  unit: "share of total agricultural spending"
  period: "2018-2023"
  geographic_scope: "nacional"
evidence:
  rds_path: "01_data/processed/panel_v12.rds"
  script_path: "02_code/03_construct/03_compose_public_vs_private.R"
  variable: "share_transfers"
  filter: "year >= 2018 & year <= 2023"
  raw_source: "BOOST 2024 release + clasificación funcional MEFP + OECD-PSE adaptado"
  evidence_span: "[TODO_TRACE: enlace a figura 5.2 del book cuando esté]"
benchmark:
  description_es: "Países comparables de la región andina típicamente muestran > 25% en bienes públicos."
  description_en: "Comparable Andean countries typically show > 25% in public goods."
  source: "[@oecd2022]"
uncertainty:
  level: "media"
  reason_es: |
    Sensible al tratamiento de subsidios indirectos (fertilizantes,
    combustibles) y a la clasificación funcional vs. económica;
    apéndice A.3 reporta el rango.
  reason_en: |
    Sensitive to the treatment of indirect subsidies (fertilizers, fuel)
    and to functional vs. economic classification; Annex A.3 reports the
    range.
methodology_version: m0.4
panel_version: v12
policy_implication_es: |
  Existe margen de repurposing hacia bienes públicos manteniendo techo
  fiscal constante; se cuantifica en el escenario S02 (capítulo 6).
policy_implication_en: |
  There is room for repurposing toward public goods while holding the
  fiscal envelope constant; quantified in scenario S02 (chapter 6).
linked_chapters:
  - "04_report/05_spending_analysis.qmd"
  - "04_report/06_recommendations.qmd"
linked_scenarios:
  - "S02"
linked_figures:
  - "fig_05_02_composition_by_instrument"
status: draft
review_log:
  - date: 2026-05-23
    auditor: "Juan Carlos Muñoz"
    audit_id: "A1-2026-0001"
    note: "Borrador inicial sin cifras cerradas; pendiente A2."
divergence_with_mefp: null
last_updated: 2026-05-23
---
```

Campos obligatorios:

```text
finding_id, version, title_es, title_en, claim_es, claim_en,
magnitude, evidence, uncertainty,
methodology_version, panel_version,
linked_chapters, status, last_updated.
```

Campos opcionales pero recomendados:

```text
benchmark, policy_implication_es, policy_implication_en,
linked_scenarios, linked_figures, review_log, divergence_with_mefp.
```

### 4.7. Histórico de versiones

Cuando un hallazgo bumpa `v<m>`, la versión previa se mueve a `## Histórico — F<NN>` al final de este archivo, con la fecha del retiro y el ADR responsable. **No se borra.**

---

## 5. Los 8 hallazgos del APER 2026 (esqueletos v0.1.0)

> Los títulos y temas son **propuestas iniciales** alineadas con la estructura del Quarto book (capítulos 02–06) y con la práctica habitual de los APER del WB. **Todos los esqueletos requieren validación del equipo APER antes de pasar a `draft` formal y luego a `reviewed`.**

### F01 — Magnitud y evolución del gasto agrícola público

```yaml
---
finding_id: F01
version: v1
title_es: "El gasto agrícola público promedió X% del PIB sectorial en YYYY–YYYY"
title_en: "Public agricultural spending averaged X% of agricultural GDP in YYYY–YYYY"
claim_es: |
  [TODO_TRACE: cuantificar gasto agrícola público total en bolivianos
   reales y como % del PIB agrícola y del gasto público total, con
   período 2010-2023 o el que defina el panel v12.]
claim_en: |
  [TODO_TRACE: equivalent EN.]
magnitude:
  value: [TODO_TRACE]
  unit: "share of agricultural GDP and share of total public spending"
  period: "[TODO_TRACE]"
  geographic_scope: "nacional"
evidence:
  rds_path: "01_data/processed/panel_v12.rds"
  script_path: "[TODO_TRACE: script de agregación del gasto agrícola total]"
  variable: "[TODO_TRACE: variable del panel — e.g. ag_spending_real_2015_bob]"
  filter: "[TODO_TRACE]"
  raw_source: "BOOST 2024 + INE (PIB sectorial) + MEFP"
benchmark:
  description_es: "[TODO_TRACE: comparar con promedio LATAM / región andina / países comparables del WDI]"
  source: "[TODO_TRACE: FAO MAFAP / WB ASTI / OECD]"
uncertainty:
  level: "[TODO_TRACE: baja/media/alta]"
  reason_es: |
    [TODO_TRACE: declarar sensibilidad a deflactor, clasificación funcional
     y cobertura de empresas estatales.]
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  [TODO_TRACE: framing técnico — no recomendación. Por ejemplo: "el
   tamaño del gasto define el espacio de repurposing posible bajo techo
   fiscal constante".]
linked_chapters:
  - "04_report/02_sector_performance.qmd"
  - "04_report/04_spending_organization.qmd"
status: draft
last_updated: 2026-05-23
---
```

### F02 — Brechas sectoriales: productividad, bienestar rural, resiliencia

```yaml
---
finding_id: F02
version: v1
title_es: "La productividad agrícola y los indicadores de bienestar rural muestran brechas frente a benchmarks regionales"
title_en: "Agricultural productivity and rural welfare indicators show gaps relative to regional benchmarks"
claim_es: |
  [TODO_TRACE: cuantificar TFP, rendimientos por hectárea, pobreza rural,
   inseguridad alimentaria, exposición climática frente a benchmarks
   regionales — Perú, Colombia, Ecuador, Paraguay.]
claim_en: |
  [TODO_TRACE]
magnitude:
  value: [TODO_TRACE]
  unit: "varias — TFP index, yields t/ha, poverty headcount, GHI"
  period: "[TODO_TRACE]"
evidence:
  rds_path: "01_data/processed/panel_v12.rds"
  script_path: "[TODO_TRACE: scripts de brechas sectoriales]"
  variable: "[TODO_TRACE: tfp_index, yield_*, rural_poverty_*]"
  raw_source: "INE EH, USDA-ERS TFP, FAOSTAT, WDI"
uncertainty:
  level: "media"
  reason_es: |
    Definición de TFP sensible a método (Solow vs. Malmquist); pobreza
    rural sensible a línea de pobreza usada.
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  [TODO_TRACE: framing en términos de qué brechas son potencialmente
   abordables con repurposing del gasto.]
linked_chapters:
  - "04_report/02_sector_performance.qmd"
status: draft
last_updated: 2026-05-23
---
```

### F03 — Composición del gasto: transferencias vs. bienes públicos

```yaml
---
finding_id: F03
version: v1
title_es: "El gasto agrícola se concentra en transferencias; los bienes públicos quedan por debajo del benchmark regional"
title_en: "Agricultural spending is concentrated in transfers; public goods fall below the regional benchmark"
claim_es: |
  [TODO_TRACE: porcentaje en transferencias vs bienes públicos vs gasto
   en infraestructura, periodo 2015-2023.]
claim_en: |
  [TODO_TRACE]
magnitude:
  value: [TODO_TRACE]
  unit: "share of agricultural spending"
  period: "[TODO_TRACE]"
evidence:
  rds_path: "01_data/processed/panel_v12.rds"
  script_path: "[TODO_TRACE: 02_code/03_construct/compose_public_vs_private.R]"
  variable: "share_transfers, share_public_goods, share_infrastructure"
  raw_source: "BOOST 2024 + clasificación funcional MEFP + OECD-PSE adaptado"
benchmark:
  description_es: "Países andinos comparables muestran > 25% en bienes públicos."
  source: "[@oecd2022], [@ifpri2023]"
uncertainty:
  level: "media"
  reason_es: |
    Sensible al tratamiento de subsidios indirectos (fertilizantes,
    combustible agrícola) y a la clasificación funcional MEFP vs.
    OECD-PSE.
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  Margen identificado para repurposing hacia bienes públicos; ver S02.
linked_chapters:
  - "04_report/05_spending_analysis.qmd"
  - "04_report/06_recommendations.qmd"
linked_scenarios:
  - "S02"
status: draft
last_updated: 2026-05-23
---
```

### F04 — Distribución territorial del gasto agrícola

```yaml
---
finding_id: F04
version: v1
title_es: "La distribución territorial del gasto agrícola muestra concentración en X departamentos y baja regionalización"
title_en: "The territorial distribution of agricultural spending is concentrated in X departments with limited regionalization"
claim_es: |
  [TODO_TRACE: identificar departamentos con mayor / menor gasto per cápita
   rural, gasto por hectárea cultivada, y comparar con índices de pobreza
   rural y potencial productivo.]
claim_en: |
  [TODO_TRACE]
magnitude:
  value: [TODO_TRACE]
  unit: "bolivianos per capita rural, bolivianos per hectare"
  period: "[TODO_TRACE]"
  geographic_scope: "departamental — los 9 departamentos"
evidence:
  rds_path: "01_data/processed/panel_v12.rds"
  script_path: "[TODO_TRACE: 02_code/04_analysis/territorial_distribution.R]"
  variable: "[TODO_TRACE]"
  raw_source: "BOOST 2024 + INE Censo Agropecuario 2013 + INE proyecciones rurales"
uncertainty:
  level: "alta"
  reason_es: |
    Asignación territorial del gasto sensible a definición de "ejecución
    en territorio" vs. "registro contable"; subnacionales pueden ejecutar
    parte sin trazabilidad.
methodology_version: m0.1
panel_version: v12
linked_chapters:
  - "04_report/04_spending_organization.qmd"
  - "04_report/05_spending_analysis.qmd"
status: draft
last_updated: 2026-05-23
---
```

### F05 — Eficiencia y focalización del gasto

```yaml
---
finding_id: F05
version: v1
title_es: "La focalización del gasto presenta dispersión y limitada conexión con indicadores de necesidad"
title_en: "Spending targeting shows dispersion and limited connection to need-based indicators"
claim_es: |
  [TODO_TRACE: correlación entre gasto departamental per cápita y
   pobreza rural / inseguridad alimentaria; identificar departamentos
   sub-atendidos relativo a brecha.]
claim_en: |
  [TODO_TRACE]
magnitude:
  value: [TODO_TRACE: coeficientes de correlación, índice de concentración, varianza no explicada]
  unit: "coefficient + index"
  period: "[TODO_TRACE]"
evidence:
  rds_path: "01_data/processed/panel_v12.rds"
  script_path: "[TODO_TRACE: 02_code/04_analysis/targeting_efficiency.R]"
  variable: "[TODO_TRACE]"
  raw_source: "panel v12 + INE EH"
uncertainty:
  level: "media"
  reason_es: |
    Identificación de focalización es asociativa, no causal. Dependencia
    de cómo se mide "necesidad" (pobreza, brecha de rendimiento, exposición
    climática).
methodology_version: m0.1
panel_version: v12
linked_chapters:
  - "04_report/05_spending_analysis.qmd"
status: draft
last_updated: 2026-05-23
---
```

### F06 — PSE / CSE: nivel y composición

```yaml
---
finding_id: F06
version: v1
title_es: "El PSE de Bolivia se ubica en X% del ingreso bruto agrícola; CSE en Y%; composición sesgada hacia transferencias precio-distorsionantes"
title_en: "Bolivia's PSE stands at X% of gross farm receipts; CSE at Y%; composition skewed toward price-distorting transfers"
claim_es: |
  [TODO_TRACE: nivel del PSE, nivel del CSE, composición por categorías
   OECD-PSE: MPS (market price support), payments based on output, input
   use, area planted, fixed parameters, etc.]
claim_en: |
  [TODO_TRACE]
magnitude:
  value: [TODO_TRACE]
  unit: "share of gross farm receipts (PSE) and share of agricultural consumption (CSE)"
  period: "[TODO_TRACE]"
evidence:
  rds_path: "01_data/processed/pse_panel_v12.rds"
  script_path: "02_code/07_pse/[TODO_TRACE]"
  variable: "pse_total, pse_mps, pse_*, cse_total"
  raw_source: "FAO MAFAP + cálculo propio sobre panel v12 + balances comerciales INE"
benchmark:
  description_es: "Promedio LATAM en MAFAP; promedio OECD para referencia."
  source: "FAO MAFAP database, OECD PSE database"
uncertainty:
  level: "alta"
  reason_es: |
    MPS sensible a elección del precio de referencia internacional, tasa
    de cambio, y tratamiento de no comercializables. Sensibilidad reportada
    en escenarios PSE alto/medio/bajo.
methodology_version: m0.1
panel_version: v12
linked_chapters:
  - "04_report/05_spending_analysis.qmd"
status: draft
last_updated: 2026-05-23
---
```

### F07 — Arquitectura institucional y ejecución del gasto

```yaml
---
finding_id: F07
version: v1
title_es: "La ejecución del gasto agrícola se distribuye entre MDRyT, empresas estatales y subnacionales con baja trazabilidad pública"
title_en: "Execution of agricultural spending is distributed between MDRyT, state enterprises, and subnationals with limited public traceability"
claim_es: |
  [TODO_TRACE: porcentaje ejecutado por MDRyT, EMAPA, INIAF, otras
   empresas; porcentaje ejecutado por subnacionales; brechas de
   trazabilidad en reportes públicos.]
claim_en: |
  [TODO_TRACE]
magnitude:
  value: [TODO_TRACE]
  unit: "share of executed agricultural spending by executing entity"
  period: "[TODO_TRACE]"
evidence:
  rds_path: "01_data/processed/panel_v12.rds"
  script_path: "[TODO_TRACE: 02_code/04_analysis/execution_by_entity.R]"
  variable: "[TODO_TRACE]"
  raw_source: "BOOST 2024 + informes de gestión MEFP + reportes anuales empresas estatales (cuando disponibles)"
uncertainty:
  level: "alta"
  reason_es: |
    Reportes de empresas estatales con cobertura desigual; gobiernos
    subnacionales ejecutan vía SIGEP con clasificación funcional
    heterogénea.
methodology_version: m0.1
panel_version: v12
linked_chapters:
  - "04_report/03_budget_institutions.qmd"
  - "04_report/04_spending_organization.qmd"
status: draft
last_updated: 2026-05-23
---
```

### F08 — Oportunidades de repurposing

```yaml
---
finding_id: F08
version: v1
title_es: "Existen oportunidades técnicas de repurposing del gasto agrícola hacia instrumentos de mayor retorno social, productivo y climático bajo techo fiscal constante"
title_en: "Technical opportunities exist to repurpose agricultural spending toward instruments with higher social, productive, and climate returns under a constant fiscal envelope"
claim_es: |
  [TODO_TRACE: síntesis de escenarios S01–S0N con sus rangos esperados
   de efecto sobre TFP, ingreso rural, emisiones, equidad territorial,
   bajo techo fiscal constante.]
claim_en: |
  [TODO_TRACE]
magnitude:
  value: [TODO_TRACE: rango por escenario]
  unit: "expected change in TFP, rural income, emissions per scenario"
  period: "horizonte 5 años desde implementación"
evidence:
  rds_path: "01_data/processed/scenarios_v12.rds"
  script_path: "02_code/08_scenarios/[TODO_TRACE]"
  variable: "[TODO_TRACE]"
  raw_source: "panel v12 + elasticidades de [@ifpri2023], [@fao2023], [@laborde2021]"
uncertainty:
  level: "alta"
  reason_es: |
    Escenarios dependen de elasticidades estimadas en otros contextos
    productivos. Bandas de incertidumbre reportadas por escenario.
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  Los escenarios se presentan como opciones técnicas para consideración
  del MEFP, sin compromiso de adopción y sujetos a calibración con datos
  bolivianos en la fase de consultoría PSE.
linked_chapters:
  - "04_report/06_recommendations.qmd"
linked_scenarios:
  - "S01"
  - "S02"
  - "S03"
status: draft
last_updated: 2026-05-23
---
```

---

## 6. Cómo se actualiza un hallazgo

### 6.1. Cambio cosmético (wording sin cambiar claim)

- Color: **VERDE** (CONTROL §4.1).
- No bumpa versión.
- Actualizar `last_updated`.
- Entrada en `review_log` opcional.

### 6.2. Cambio de magnitud o interpretación

- Color: **ROJO** (CONTROL §4.3).
- Bump de `version` (e.g. `v1` → `v2`).
- ADR obligatorio.
- Versión previa se mueve a `## Histórico — F<NN>` al final del archivo.
- Regenerar figuras / slides / briefs que citaban la versión previa.
- Verificación A3 + A4 (09_AUDITORIA.md).

### 6.3. Cambio de estado de validación

- `draft → reviewed`: A3 firmada.
- `reviewed → MEFP_validated`: A4 firmada + mesa técnica con MEFP.
- `MEFP_validated → contested`: registro de la objeción con fecha y fuente.
- `* → retired`: ADR + motivo documentado; el hallazgo permanece visible.

### 6.4. Incorporación de comentario MEFP

- Si el MEFP propone una corrección de cifra **con fuente verificable**: aplicar como cambio de magnitud (§6.2).
- Si el MEFP propone una corrección **sin fuente verificable**: documentar en `divergence_with_mefp` como nota de divergencia; el hallazgo mantiene su versión.
- Si el MEFP propone reformulación de interpretación sin cambiar la cifra: amarillo; actualizar wording; registrar en `review_log`.

---

## 7. Integración con otros productos

| Producto | Cómo cita el hallazgo |
|---|---|
| Capítulos del book | citan por `finding_id` (e.g. "ver F03 en 04_HALLAZGOS.md") y reflejan magnitud + período idénticos |
| Executive summary | claim del hallazgo es la fuente del bullet del BLUF |
| Slides ejecutivas | bullet trae `finding_id` en metadatos del slide |
| Sitio público | página por hallazgo con título bilingüe, magnitud, fuente |
| Briefs derivados | bullets atados a `finding_id` |
| Cartas MEFP | hallazgos en estado `reviewed` o superior; nunca `draft` |

Regla de consistencia: si en cualquier producto la cifra de un hallazgo difiere de lo declarado acá, **prevalece 04_HALLAZGOS.md**; los demás se corrigen.

---

## 8. Notas de divergencia con MEFP (apéndice)

Cuando un comentario del MEFP no se incorpora porque no tiene fuente verificable o porque cambiaría la metodología versionada sin ADR, se registra acá:

```yaml
divergence_id: D-NNNN
finding_id: F03
date: YYYY-MM-DD
mefp_position_es: "El MEFP indica que la clasificación X debería ser Y."
team_position_es: "El equipo APER mantiene la clasificación X por consistencia con la metodología m0.4; ver METODOLOGIA §X.Y."
status: open | closed
resolution_note: ""
---
```

Las divergencias se publican en el appendix del book; no se ocultan.

---

## 9. Histórico — versiones retiradas

(vacío en v0.1.0)

Cuando un hallazgo bumpe versión, su versión previa se mueve acá con:

```text
### F<NN> v<m-1>  (retirada YYYY-MM-DD por ADR-NNNN)
<bloque YAML completo>
Motivo: ...
```

---

## 10. Cómo modificar este archivo

`04_HALLAZGOS.md` es zona crítica (CONTROL §3). Reglas:

- Agregar `[TODO_TRACE: ...]` a un hallazgo en `draft`: VERDE.
- Llenar un `[TODO_TRACE]` con cifra trazada: AMARILLO si el hallazgo está `draft`; ROJO si está `reviewed` o superior.
- Cambiar cualquier campo del contrato JSON: ROJO + ADR + bump.
- Cambiar el ciclo de vida §2 o los estados: ROJO + ADR sobre `04_HALLAZGOS.md`.
- Cambiar el contrato canónico §4 (agregar / quitar campos obligatorios): ROJO + ADR sobre `04_HALLAZGOS.md`.

---

## 11. Changelog

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: principio rector, ciclo de vida, contrato JSON canónico, esqueletos v0.1.0 para F01–F08 con TODO_TRACE, protocolo de actualización, divergencias MEFP, histórico vacío |
