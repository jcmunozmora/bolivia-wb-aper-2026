---
description: Corre los gates de auditoría A1–A6 + G1–G7 sobre un capítulo del APER y devuelve verdict pass/fail con evidencia.
argument-hint: <NN | path> — Ej. "02", "04_report/02_sector_performance.qmd"
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Auditoría de capítulo APER Bolivia 2026

**Argumento:** `$ARGUMENTS`

## Tu tarea

1. **Resolver el target** `$ARGUMENTS` al archivo `04_report/*.qmd` correspondiente.

2. **Verificar que el archivo existe** y tiene contenido sustantivo (no es placeholder vacío).

3. **Invocar 3 subagentes en paralelo** vía Task tool:
   - **`aper-auditor`** — gates A1–A6 + G1–G7 (verdict global del capítulo)
   - **`aper-trace-verifier`** — invariante 3.1 (trazabilidad cuantitativa de cada cifra)
   - **`aper-citation-auditor`** — gate §13B (citas literatura green/yellow)

   Lanzá los 3 en un mismo mensaje con múltiples Task tool calls (paralelo, no secuencial).

4. **Consolidar los 3 reportes** en un veredicto único:

```markdown
# Auditoría /audit-chapter $ARGUMENTS — <fecha>

**Archivo:** <path>
**Verdict global:** ✅ READY FOR REVIEW  |  🟡 PASS CON ACCIONES  |  🔴 FAIL

## Resumen por dominio

| Dimensión | Auditor | Verdict |
|-----------|---------|:-------:|
| Gates A1–A6 + G1–G7 | aper-auditor | ✅ / 🟡 / 🔴 |
| Trazabilidad cuantitativa | aper-trace-verifier | ✅ / 🟡 / 🔴 |
| Citas literatura | aper-citation-auditor | ✅ / 🟡 / 🔴 |

## Bloqueos (si los hay)
[lista consolidada — todo lo que impide marcar como reviewed]

## Caveats (no bloqueantes pero atención)
[lista]

## Acciones requeridas antes de pasar a reviewed
1. ...
2. ...

## Reportes detallados
[Inline los 3 outputs de los subagentes en formato collapsable o referenciados]
```

5. **Si verdict es FAIL**: NO sugerir marcar como `reviewed`. Reportar al usuario qué bloqueos resolver primero.

6. **Si verdict es PASS**: sugerir:
   - Actualizar `status` del capítulo en `.agent/00_MASTER_PROMPT.md` Parte 6 (de 🟡 a 🟢).
   - Si todos los findings del capítulo están `reviewed` o `MEFP_validated`, considerar A6 (cierre) — mesa técnica.
   - Bump versión del `.qmd` (footer del archivo) y entrada en bitácora MASTER_PROMPT Parte 17.

## Reglas

- **NO** modificar el `.qmd` auditado — los 3 subagentes son solo lectura.
- **NO** suavizar verdicts — si hay 3 fallas críticas, son 3 fallas críticas.
- **NO** marcar PASS si hay TODO_TRACE pendiente o ficha red citada.
