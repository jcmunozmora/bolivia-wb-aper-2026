---
description: Scaffold de un nuevo hallazgo F<NN> con contrato JSON/YAML completo según `.agent/04_HALLAZGOS.md` §4. Bumpa version, marca como draft, vincula a capítulo y figuras.
argument-hint: <F<NN>> [titulo_corto] — Ej. "F09 frontera_ganadera"
allowed-tools: Read, Edit, Grep
---

# Crear hallazgo nuevo

**Argumento:** `$ARGUMENTS`

## Tu tarea

1. **Parsear `$ARGUMENTS`** → `finding_id` (Fxx) + título corto opcional.

2. **Verificar que no existe** ya en `.agent/04_HALLAZGOS.md`:
   ```bash
   grep "finding_id: F<NN>" .agent/04_HALLAZGOS.md
   ```

3. **Confirmar con usuario** el alcance del hallazgo (1 frase) y el capítulo casa antes de scaffold.

4. **Crear bloque YAML** siguiendo el contrato §4 de `04_HALLAZGOS.md`:

```yaml
---
finding_id: F<NN>
version: v1
title_es: "[TODO — título completo]"
title_en: "[TODO — equivalent EN]"
claim_es: |
  [TODO_TRACE — cuantificar con cifras del panel v12, declarar período]
claim_en: |
  [TODO_TRACE — equivalent EN]
magnitude:
  value: [TODO_TRACE]
  unit: "[TODO]"
  period: "[TODO_TRACE]"
  geographic_scope: "[nacional / depto / municipal]"
evidence:
  rds_path: "01_data/processed/spending_panel_v12.rds"
  script_path: "[TODO — 02_code/03_analysis/...]"
  variable: "[TODO]"
  filter: "[TODO]"
  raw_source: "[TODO — BOOST / FAO / IDB / etc.]"
  evidence_span: "[TODO — enlace a figura del book]"
benchmark:
  description_es: "[TODO]"
  description_en: "[TODO]"
  source: "[TODO — [@key] o URL]"
uncertainty:
  level: "[baja|media|alta]"
  reason_es: |
    [TODO — supuestos sensibles, outliers, gaps]
  reason_en: |
    [TODO — equivalent EN]
methodology_version: m0.1.0
panel_version: v12
policy_implication_es: |
  [TODO — opción técnica, NO prescripción; "una opción técnica sería..."]
policy_implication_en: |
  [TODO — equivalent EN, "a technical option would be..."]
linked_chapters:
  - "04_report/[NN_capitulo].qmd"
linked_scenarios:
  - "[TODO si aplica — S01, S02...]"
linked_figures:
  - "[TODO — fig_NN_NN_slug]"
status: draft
review_log:
  - date: <hoy YYYY-MM-DD>
    auditor: "Juan Carlos Muñoz"
    audit_id: "A1-<año>-<seq>"
    note: "Esqueleto inicial, todos los campos sustantivos son TODO_TRACE."
divergence_with_mefp: null
last_updated: <hoy YYYY-MM-DD>
---
```

5. **Insertar el bloque** en `.agent/04_HALLAZGOS.md`:
   - Después del último `F<NN>` existente, antes de `## Histórico` (si existe).
   - Si es el F<NN+1> esperado: posición natural.
   - Si salta números (ej. F09 cuando estaba en F03): pedir confirmación.

6. **Recordar al usuario que es cambio ROJO** (creación de hallazgo):
   - Crear ADR en `.agent/decisions/ADR-NNNN-finding-F<NN>.md` con motivación.
   - Bumpar `findings_version` global (si existe variable global; sino, este finding va con `version: v1`).
   - Anotar en MASTER_PROMPT Parte 17 (bitácora editorial).
   - Anotar en `00_admin/RETOMAR.md`.

7. **Sugerir siguientes pasos**:
   - Identificar el script en `02_code/03_analysis/` que produce la cifra (o crear nuevo).
   - Correr el script y poblar `magnitude.value` real.
   - Sustituir todos los TODO_TRACE.
   - Pasar a `status: reviewed` cuando A3 firme (auditoría).
   - Mesa técnica MEFP para `status: MEFP_validated`.

## Reglas

- NO inventar cifras para `magnitude.value` — siempre TODO_TRACE hasta correr el script.
- NO usar `version: v0` ni `v1.0` — el versionamiento de findings es `v1`, `v2`, etc. (entero).
- NO marcar `status: reviewed` desde scaffold — siempre `draft` hasta auditoría.
- NO saltarse el ADR si es un nuevo hallazgo (= cambio ROJO).
