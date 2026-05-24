---
description: Verifica trazabilidad cuantitativa (invariante 3.1) sobre uno o varios archivos del reporte. Delega a aper-trace-verifier.
argument-hint: <path | glob> — Ej. "04_report/02_sector_performance.qmd"
allowed-tools: Read, Grep, Glob, Bash, Task
---

# Verificación de trazabilidad cuantitativa — invariante 3.1

**Target:** `$ARGUMENTS`

## Tu tarea

1. Expandir glob `$ARGUMENTS`.

2. Para cada archivo: invocar **`aper-trace-verifier`** vía Task tool (paralelo si ≤ 5 archivos).

3. Consolidar:

```markdown
# Trazabilidad /check-trace $ARGUMENTS — <fecha>

| Archivo | Total cifras | Trazadas | TODO_TRACE | Verdict |
|---------|:------------:|:--------:|:----------:|:-------:|

## TODO_TRACE pendientes globales
1. Cifra "X" en archivo A línea N — falta [campo]
2. ...

## Acciones requeridas
- Crear script `02_code/03_analysis/12_<nombre>.R` para [cifra].
- Documentar incertidumbre de [cifra] en `.agent/01_METODOLOGIA.md`.
- ...
```

4. Si hay TODO_TRACE pendiente: NO sugerir publicar/marcar reviewed.

## Reglas

- Cifras de literatura externa son responsabilidad de `aper-citation-auditor`, no del trace-verifier. Si una cifra cita `[@key]`, dejar nota "delegado a citation-auditor".
- Cifras de benchmark internacional (FAO, OECD, WDI) pueden pasar sin RDS local si tienen URL + año de descarga documentados en `.agent/03_FUENTES.md`.
