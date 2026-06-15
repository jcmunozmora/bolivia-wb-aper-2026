# Checklist Codex — Pre-flight

Usar antes de cualquier accion sustantiva.

## Contexto minimo

- [ ] `AGENTS.md` leido.
- [ ] `.agent/00_MASTER_PROMPT.md` Partes 1-5 leidas.
- [ ] `00_admin/RETOMAR.md` leido.
- [ ] `.agent/README.md` leido.
- [ ] `.codex/instructions.md` leido.

## Estado del repo

- [ ] `git status --short` revisado.
- [ ] Cambios existentes del usuario identificados.
- [ ] No se va a revertir nada no solicitado.

## Clasificacion del cambio

- [ ] Cambio clasificado con `.agent/08_CONTROL.md`.
- [ ] Si ROJO: ADR identificado o pendiente antes de editar.
- [ ] Si toca prosa: `.agent/05_ESTILO_NARRATIVO.md` y `.agent/06_NEUTRALIDAD.md` leidos.
- [ ] Si toca figuras: `.agent/07_FIGURAS.md` leido.
- [ ] Si toca cifras/modelo/metodologia: `.agent/01_METODOLOGIA.md`, `.agent/02_INDICADORES.md`, `.agent/03_FUENTES.md`, `.agent/04_HALLAZGOS.md`, `.agent/09_AUDITORIA.md` leidos.

## Reproducibilidad

- [ ] Script/input canonico identificado.
- [ ] Output esperado identificado.
- [ ] Prueba minima definida antes de editar.
