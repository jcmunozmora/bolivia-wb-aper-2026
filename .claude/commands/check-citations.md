---
description: Verifica el gate §13B de literatura (audit_status green/yellow) sobre uno o varios archivos. Delega a aper-citation-auditor.
argument-hint: <path | glob> — Ej. "04_report/02_sector_performance.qmd", "04_report/*.qmd"
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Verificación de citas literatura — gate §13B

**Target:** `$ARGUMENTS`

## Tu tarea

1. **Expandir el glob** `$ARGUMENTS` a la lista concreta de archivos.

2. **Verificar pre-condiciones:**
   - `03_literature/references_master.bib` existe.
   - `03_literature/_audit/RED_FLAGS.md` existe (para referencia).
   - Las fichas están en subcarpetas numeradas + `mdryt_fichas/` + `Informacion_PER/`.

3. **Invocar `aper-citation-auditor`** vía Task tool **por cada archivo** del glob (en paralelo si son ≤ 5; sino en lotes de 5).

4. **Consolidar el reporte global**:

```markdown
# Auditoría de citas — $ARGUMENTS — <fecha>

**Archivos procesados:** N
**Verdict global:** ✅ TODO PASS  |  🟡 CAVEATS  |  🔴 FAIL — N bloqueos en M archivos

## Resumen agregado

| Archivo | Total citas | Green | Yellow | Red | Unverified | Orphan | Verdict |
|---------|:-----------:|:-----:|:------:|:---:|:----------:|:------:|:-------:|
| ... |

## Citas problemáticas globales (acción requerida)

| Citekey | Estado | Aparece en | Acción sugerida |
|---------|:------:|------------|-----------------|
| @MoguesEtAl2012 | unverified | 02_sector_performance.qmd, 03_budget_institutions.qmd | Re-verificar contra PDF |
| @InventedAuthor2020 | orphan | 05_spending_analysis.qmd | Eliminar cita o crear ficha |

## Detalle por archivo
[outputs collapsable de cada subagente]
```

5. **Si hay bloqueos**: listar acciones concretas:
   - Para unverified/red → abrir el PDF en `03_literature/pdfs/<carpeta>/<key>.pdf` y verificar.
   - Para orphan → eliminar la cita o crear la ficha.
   - Para yellow → leer la nota y ajustar prosa si aplica.

## Cuando arrancar `/check-citations`

- Después de escribir una sección y antes de marcar como `reviewed`.
- Antes de cualquier `/audit-chapter` (es prerequisito).
- Después de re-verificar una ficha unverified → green/yellow.
- Antes de cualquier `/commit-push` que incluya cambios en `.qmd` con nuevas citas.
