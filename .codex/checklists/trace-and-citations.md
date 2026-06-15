# Checklist Codex — Trazabilidad y citas

Usar para cualquier capitulo, figura, tabla, slide o pagina web con cifras/citas.

## Cifras

Por cada cifra:

- [ ] Magnitud exacta.
- [ ] Año o periodo.
- [ ] Unidad.
- [ ] `rds_path`.
- [ ] `script_path`.
- [ ] `variable_name`.
- [ ] `filter_or_subset`.
- [ ] `raw_source`.
- [ ] `panel_version`.
- [ ] `methodology_version`.
- [ ] `uncertainty_note`.

Si falta algun campo: reemplazar por `TODO_TRACE`.

## Panel

- [ ] Cifras publicables salen de `spending_panel_v12.rds` o derivado documentado.
- [ ] No hay referencias a `spending_panel.rds`, v10 o v11 como fuente final.
- [ ] Si se usa excepcion externa, esta citada y justificada.

## Citas

- [ ] Cada `[@key]` existe en `04_report/references.bib`.
- [ ] Cada ficha existe en `03_literature/`.
- [ ] `audit_status` es `green` o `yellow`.
- [ ] No se cita ficha `red`, `unverified` u orphan.
- [ ] No hay citas verbatim salvo que el PDF y pagina hayan sido verificados directamente.

## Comandos utiles

```bash
rg -n "TODO_TRACE|spending_panel\\.rds|spending_panel_v10|spending_panel_v11" 04_report
rg -o "@[A-Za-z][A-Za-z0-9_:\\.-]*" 04_report/*.qmd | sort -u
```
