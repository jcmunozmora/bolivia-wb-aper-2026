# Checklist Codex — Cierre de sesion

Toda sesion sustantiva debe dejar un bloque en `00_admin/RETOMAR.md`.

## Template

```markdown
## Sesion NN (YYYY-MM-DD) — <titulo corto>

**Resumen del cambio:** <1-2 lineas>
**Tipo de cambio:** VERDE | AMARILLO | ROJO
**Archivos modificados:** <lista>
**Cifras tocadas (con trazabilidad):** ninguna | <lista con RDS/script/variable/periodo/fuente>
**Hallazgos afectados:** ninguno | FNN
**Capitulos del book afectados:** ninguno | <lista>
**Slides / web actualizadas:** ninguna | <lista>
**Tests ejecutados:** <comandos + resultado>
**Tests no ejecutados:** <comando + motivo>
**Impacto en panel:** ninguno | <detalle + panel_version>
**Impacto en metodologia:** ninguno | <detalle + methodology_version>
**Impacto en hallazgos:** ninguno | <detalle + findings_version>
**Impacto en MEFP handoff:** ninguno | <detalle>
**Pre-flight anti-IA (A1):** no aplica | corrido
**AI-likelihood score promedio:** no aplica | N/10 (idioma)
**Banderas anti-IA activadas y resueltas:** no aplica | <detalle>
**A2 firmada por:** pendiente revisor par — YYYY-MM-DD
**Riesgos pendientes:** <lista>
**ADR requerido:** no | si, ADR-NNNN
**Siguientes pasos:**
1. <paso concreto>
2. <paso concreto>
```

## Antes de finalizar

- [ ] `git status --short` revisado.
- [ ] Cambios propios distinguidos de cambios previos.
- [ ] Tests relevantes reportados.
- [ ] Limitaciones o bloqueadores reportados.
- [ ] Si hubo cambio ROJO, ADR y bumps documentados.
