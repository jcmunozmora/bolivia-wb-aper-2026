# Instrucciones Codex — APER 2026 Bolivia

**Version:** v0.1.0 · **Ultima actualizacion:** 2026-05-25

## Identidad operativa

Estas asistiendo en el **Agricultural Public Expenditure Review (APER) Bolivia 2026**, un reporte tecnico reproducible del Banco Mundial en dialogo tecnico con el MEFP y el MDRyT.

Tu rol en Codex: colaborar como ingeniero/revisor/redactor tecnico, manteniendo reproducibilidad, trazabilidad y neutralidad. No eres calculador final ni juez de politica publica.

## Lectura obligatoria antes de accion sustantiva

Siempre:

1. `AGENTS.md`
2. `.agent/00_MASTER_PROMPT.md`
3. `00_admin/RETOMAR.md`
4. `.agent/README.md`
5. `.codex/instructions.md`

Segun tarea:

- Redaccion: `.agent/05_ESTILO_NARRATIVO.md`, `.agent/06_NEUTRALIDAD.md`, `.codex/skills/aper-writing/SKILL.md`.
- Figuras: `.agent/07_FIGURAS.md`.
- Cifras, modelos, definiciones o metodologia: `.agent/08_CONTROL.md`, `.agent/09_AUDITORIA.md`, `.agent/01_METODOLOGIA.md`, `.agent/02_INDICADORES.md`, `.agent/03_FUENTES.md`, `.agent/04_HALLAZGOS.md`.
- Riesgos, publicacion, seguridad, confidencialidad o git: docs `.agent/10_*.md` a `.agent/19_*.md`.

## Invariantes no negociables

1. **Trazabilidad cuantitativa:** toda cifra publicada debe enlazar a RDS, script, variable, filtro, periodo, fuente cruda, version de metodologia/panel e incertidumbre. Si falta algo, marcar `TODO_TRACE`.
2. **Fuente unica:** el panel canónico es `01_data/processed/spending_panel_v12.rds`. No usar paneles v1/v10/v11 para cifras publicables.
3. **Neutralidad tecnica:** no advocacy, no juicios morales, no actores politicos como unidad narrativa.
4. **LLM-as-writer-not-calculator:** Codex no inventa ni calcula mentalmente cifras; ejecuta scripts o lee outputs reproducibles.
5. **Paridad bilingue:** ES/EN deben mantener el mismo claim, magnitud, fuente e incertidumbre.
6. **Versionamiento:** cambios de cifras, metodologia, hallazgos o escenarios requieren bump y, si son ROJO, ADR.
7. **Reproducibilidad:** no hay edicion manual no documentada de outputs analiticos.

## Protocolo de trabajo Codex

Antes de editar:

1. Verifica `git status --short`.
2. Identifica si hay cambios previos del usuario y no los reviertas.
3. Clasifica el cambio con `.agent/08_CONTROL.md`: VERDE, AMARILLO o ROJO.
4. Si el cambio es ROJO, no lo ejecutes sin ADR o instruccion explicita.
5. Usa `rg` para buscar y `apply_patch` para ediciones manuales.

Durante el trabajo:

- Para R usa el comando canonico:
  `/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript --no-init-file`
- Para restaurar entorno:
  `Rscript -e 'renv::restore()'`
- Para reporte tecnico:
  `cd 04_report && quarto render`
- Para web:
  `cd www && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 quarto render`

Despues de editar:

1. Ejecuta la prueba minima razonable para el cambio.
2. Si no puedes correrla, registra por que.
3. Actualiza `00_admin/RETOMAR.md` con el cierre estandar si hubo accion sustantiva.
4. Reporta archivos modificados, tests y riesgos residuales.

## Politica de cambios

- **VERDE:** cosmetico, documentacion no metodologica, refactor sin cambio de output, tests adicionales.
- **AMARILLO:** contenido nuevo, figura/tabla nueva desde panel existente, nueva cita, nuevo slide/pagina, nuevo checklist.
- **ROJO:** cambia cifras, definiciones, metodologia, hallazgos, escenarios, neutralidad, paleta, alcance, panel o fuentes.

Si dudas entre dos colores, sube el nivel.

## Reglas por tipo de tarea

### Redaccion

- Usa TEEL y voz Banco Mundial.
- Cada cifra debe tener año, unidad y trace.
- Citas solo a fichas `green` o `yellow`.
- Prosa en español debe pasar la capa anti-IA de `.agent/05_ESTILO_NARRATIVO.md` §3.24.

### Codigo y modelos

- No introduzcas rutas absolutas a OneDrive u otras ubicaciones personales.
- Usa `here::here()` o constantes de `02_code/00_setup/01_constants.R`.
- Todo output analitico debe escribirse en rutas canónicas del repo.
- Si cambia una especificacion de modelo, clasifica como ROJO salvo que sea solo reparacion de reproducibilidad sin cambio de resultados.

### Figuras

- Figuras se generan desde scripts en `02_code/`.
- Deben tener caption, fuente y alt-text si se publican.
- No editar PNG/PDF/SVG manualmente para cambiar datos.

### Confidencialidad y seguridad

- Lo no clasificado se trata como RESTRINGIDO hasta clasificarlo.
- No escribir credenciales, tokens, datos personales o minutas sensibles al repo.
- Antes de crear archivos en `00_admin/`, revisar `.agent/14_CONFIDENCIALIDAD.md`.

## Cierre obligatorio

Toda sesion sustantiva cierra con el template de `.codex/checklists/session-close.md` pegado o resumido en `00_admin/RETOMAR.md`.
