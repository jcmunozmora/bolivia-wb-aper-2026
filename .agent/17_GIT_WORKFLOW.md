# 17_GIT_WORKFLOW.md — Branches, commits, tags y releases

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/17_GIT_WORKFLOW.md`
**Marco de referencia:** Trunk-based development simplificado + Conventional Commits + Semantic Versioning.
**Lecturas relacionadas:** [`08_CONTROL.md`](08_CONTROL.md), [`13_PUBLICACION.md`](13_PUBLICACION.md), [`12_REPRODUCIBILIDAD.md`](12_REPRODUCIBILIDAD.md), [`15_SEGURIDAD.md`](15_SEGURIDAD.md).

> Git es la columna vertebral del proyecto. Un repo desordenado se vuelve irreparable; uno disciplinado se audita en minutos.

---

## 1. Principio rector

Cuatro afirmaciones:

1. **`main` siempre publicable.** En cualquier commit de `main`, `quarto render` produce un book sin errores y los tests automatizados pasan.
2. **Trabajo verde directo en `main`.** Equipos chicos no necesitan PR para todo; sí necesitan disciplina.
3. **Cambios rojos en rama dedicada.** Todo cambio que toca cifras, hallazgos, metodología o paleta vive en `red/ADR-NNNN-<slug>` hasta que el ADR cierra.
4. **Tags son inmutables.** Lo que se tagueó `vX.Y.Z` no se reescribe; correcciones generan tag siguiente.

---

## 2. Modelo de branches

```text
main                           rama única persistente; siempre publishable
                               ←─ commits directos para cambios VERDE / AMARILLO
                               ←─ merges desde ramas dedicadas

red/ADR-NNNN-<slug>            cambios ROJOS (cifras, hallazgos, metodología)
                               vida típica: 1–3 semanas
                               merge a main cuando ADR cierra y A3 aprueba
                               ejemplos:
                                 red/ADR-0003-pse-methodology
                                 red/ADR-0006-panel-v13-migration

exp/<slug>                     experimentación libre (rama corta, < 1 semana)
                               nunca se mergea: se cherry-pick lo útil a una
                               rama main o red/
                               ejemplo: exp/scatter-targeting-prototype

hotfix/<slug>                  correcciones urgentes a un release publicado
                               vida típica: < 48h
                               merge a main + cherry-pick al tag de release
                               ejemplos:
                                 hotfix/errata-fig-05-02
                                 hotfix/broken-link-web-home

release/<vX.Y.Z>               rama de preparación de release (opcional)
                               solo si hay congelación pre-release > 1 semana
                               de otro modo: trabajar en main hasta el tag
```

### 2.1. Branch protection en `main` (a configurar en GitHub)

```text
[x] Require pull request for changes labeled `red:`
    (cambios ROJOS no se commitean directo)
[x] Require status checks to pass (cuando CI esté implementado):
    - reproducibility test
    - anti-AI scan
    - bilingual parity
    - render check
[x] Require signed commits (opcional pero recomendado)
[ ] Require linear history (no rebase forzado; merge commits OK)
[x] No force push
[x] No deletions
```

### 2.2. Convención de naming

```text
red/ADR-NNNN-<slug>            ADR número + slug corto en inglés/snake_case
hotfix/<slug>                  slug descriptivo (errata-fig-05-02)
exp/<slug>                     slug libre
release/v1.0.0                 estricto con versión semver
```

---

## 3. Conventional commits

### 3.1. Formato general

```text
<tipo>: <descripción corta en presente, ≤ 50 caracteres>

[cuerpo opcional, ≤ 72 caracteres por línea]

[footer opcional: Co-Authored-By, Refs ADR-NNNN, Closes #issue]
```

### 3.2. Tipos canónicos del APER

| Tipo | Cuándo usarlo | Color CONTROL típico |
|---|---|---|
| `docs:` | cambios a archivos `.agent/`, `README.md`, `CONTRIBUTING.md`, otra documentación no metodológica | VERDE / AMARILLO |
| `data:` | cambios a `01_data/raw/` o `01_data/processed/` (panel bumps, fuentes nuevas) | AMARILLO / ROJO |
| `analysis:` | scripts en `02_code/` (ingesta, limpieza, construcción, análisis) | AMARILLO / ROJO |
| `report:` | capítulos en `04_report/*.qmd`, executive summary | AMARILLO / ROJO |
| `figure:` | scripts `02_code/05_figures/` o outputs `05_outputs/figures/` | AMARILLO / ROJO |
| `table:` | scripts `02_code/06_tables/` o outputs `05_outputs/tables/` | AMARILLO / ROJO |
| `web:` | `www/` | VERDE / AMARILLO |
| `slides:` | `slides/` | VERDE / AMARILLO |
| `adr:` | nuevo / actualizado ADR en `.agent/decisions/` | ROJO |
| `gov:` | cambios a archivos de gobernanza `.agent/0N_*.md` | AMARILLO / ROJO |
| `chore:` | mantenimiento (deps, configs, .gitignore, hooks) | VERDE |
| `fix:` | corrección puntual de bug (typo en cifra, link roto, error de script) | VERDE / AMARILLO |
| `refactor:` | reescritura sin cambio funcional | VERDE |
| `test:` | agregar / ajustar tests, scripts de audit | VERDE / AMARILLO |
| `ci:` | cambios a `.github/workflows/` | AMARILLO |

### 3.3. Ejemplos canónicos

```text
docs: agregar 16_INCIDENTES.md con protocolo P0-P3

figure: fig_05_02_pse_composition draft inicial

  Refs: F03; panel v12; methodology m0.1.0

data: panel v12 → v13 con incorporación de MDRyT 2015-2018

  Refs: ADR-0010; bump methodology m0.1.0 → m0.2.0
  Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>

adr: ADR-0007 paleta APER 2026 fijada

  Refs: 07_FIGURAS §6.1

fix: corrige caption fig_05_02 (faltaba fuente)

report: capítulo 05_spending_analysis §2 redactado (TEEL primer pase)

  Refs: F03, F06; pendiente A3
```

### 3.4. Prefijos especiales

```text
red:    <tipo>:           prefijo opcional para cambios ROJOS, redundante
                          con la rama red/ pero útil en grep histórico

wip:    <tipo>:           work-in-progress; aceptable en ramas red/ y exp/;
                          NO aceptable en main

BREAKING:                 indica que el commit rompe compatibilidad
                          (e.g. cambio de definición de variable);
                          dispara bump de major version
```

---

## 4. Workflow por color de cambio

### 4.1. Cambio VERDE (typo, cosmético, doc no metodológica)

```text
1. trabajar en main
2. commit directo con tipo apropiado (docs:, chore:, fix:, ...)
3. push a origin main
4. opcional: revisar en GitHub si trigueó CI
```

### 4.2. Cambio AMARILLO (nueva figura, nueva sección, ajuste cosmético en cifra)

```text
1. trabajar en main
2. cumplir checklist AMARILLO de CONTROL.md §4.2 antes de commit
3. commit con tipo apropiado y, si la cifra es nueva, incluir Refs en el body
4. push
5. revisión asíncrona por un par del equipo (A2)
6. si A2 detecta problema: nuevo commit fix:; nunca rewrite history en main
```

### 4.3. Cambio ROJO (cifra publicada, hallazgo, metodología, paleta)

```text
1. abrir ADR en .agent/decisions/ en estado "propuesto"
2. crear rama: git checkout -b red/ADR-NNNN-<slug>
3. trabajar en la rama; commits con tipo y prefijo red: opcional
4. cuando ADR esté en estado "aceptado" y A3 aprobada:
   - merge a main (PR si branch protection lo requiere)
   - tag opcional para marcar el cambio
5. eliminar la rama una vez mergeada (al menos del remoto)
6. actualizar RETOMAR.md con cierre de sesión + referencia al ADR
```

---

## 5. Tags y versionamiento

### 5.1. Semver del reporte

```text
vMAJOR.MINOR.PATCH

MAJOR     próximo ciclo APER o cambio de scope radical (raro; típicamente
          v2.0.0 = próximo APER)

MINOR     incorporación de capítulo nuevo, hallazgo nuevo, sección
          sustantiva post-publicación que no contradice lo publicado

PATCH     errata, fix de link, ajuste cosmético, corrección de typo

ejemplos:
  v0.1.0     primera versión de gobernanza (cuando todos los .agent/
             estén en v0.x)
  v0.9.0     pre-release; A5 audit aprobada
  v1.0.0     release inicial al MEFP y público
  v1.0.1     errata tipográfica
  v1.0.2     fix de link roto
  v1.1.0     brief temático adicional
  v1.2.0     incorporación de nota post-publicación MEFP
  v2.0.0     próximo APER (2029?)
```

### 5.2. Cuándo se taguea

```text
- antes del release (A5 aprobada): tag de pre-release vX.Y.Z-rc.N
- en el release: tag vX.Y.Z + GitHub release notes + Zenodo deposit
- después de errata: tag vX.Y.(Z+1) + nota de errata
- antes de Zenodo deposit: tag firmado git tag -s
```

### 5.3. Tag de un ADR (opcional)

```text
algunos equipos taguean cuando un ADR cierra:
  git tag adr-0007-figuras-canonical -m "ADR-0007 aprobada"

permite navegar el repo en el estado "antes / después" del cambio rojo.
opcional; solo si el equipo lo encuentra útil.
```

### 5.4. Reglas duras

```text
- los tags son INMUTABLES: no se borran, no se reescriben
- si hay errata en un tag: se publica el tag siguiente (vX.Y.Z+1) con la
  corrección; el tag erróneo queda visible como histórico
- firma de tags recomendada para releases públicos (git tag -s)
- nunca push --force a un tag publicado
```

---

## 6. Pull requests

### 6.1. Cuándo son obligatorios

```text
- cambios ROJOS (rama red/) — por branch protection
- cambios que afectan release pendiente (rama release/)
- contribuciones de personas fuera del equipo core
```

### 6.2. Cuándo son opcionales

```text
- cambios VERDE / AMARILLO en el equipo core
- experimentos en exp/ (típicamente no se mergean)
- documentación interna en .agent/ (salvo cambios ROJOS)
```

### 6.3. Plantilla de PR

```markdown
## Tipo de cambio

<!-- marcar lo que aplique -->
- [ ] VERDE — cosmético, doc no metodológica, refactor
- [ ] AMARILLO — nueva figura/sección, ajuste cosmético
- [ ] ROJO — cifra, hallazgo, metodología, paleta

## ADR relacionado

ADR-NNNN (link) — estado: propuesto | aceptado | rechazado

## Descripción

<qué hace este PR>

## Checklist (según color)

<!-- copiar de 08_CONTROL.md según color -->
- [ ] A2 corrida (par del equipo revisó)
- [ ] trazabilidad de cifras (RDS + script + variable + período)
- [ ] anti-AI score reportado
- [ ] paridad bilingüe verificada (si aplica)
- [ ] render quarto pasa
- [ ] RETOMAR.md actualizado

## Hallazgos / capítulos afectados

F0X, capítulo NN

## Notas para el revisor

<contexto adicional>
```

---

## 7. Hooks

### 7.1. Pre-commit (recomendado)

Implementación en `scripts/install_git_hooks.sh`. Hooks que se instalan:

```text
1. detección de secrets (15_SEGURIDAD §11)
2. detección de unicode invisible (ESTILO §3.20)
3. linter markdown básico
4. opcional: scan anti-AI rápido sobre archivos `.qmd` modificados
```

### 7.2. Pre-push (opcional)

```text
- ejecutar `quarto render --to html` en archivos modificados para
  detectar render breaks antes del push
- ejecutar `Rscript -e 'renv::status()'` para detectar lockfile desync
```

### 7.3. Commit-msg (recomendado)

```text
- validar que el mensaje empiece con un tipo canónico (§3.2)
- si el body menciona "BREAKING:": confirmar que la rama es red/ o release/
- si el body menciona "Refs F0X": validar que F0X existe en HALLAZGOS.md
```

---

## 8. Releases en GitHub

### 8.1. Cuándo se crea un GitHub Release

```text
- en cada bump de tag (vX.Y.Z)
- nunca para pre-releases internos (vX.Y.Z-rc.N solo como tag)
```

### 8.2. Release notes — plantilla

```markdown
# APER Bolivia 2026 — vX.Y.Z

**Fecha de release:** YYYY-MM-DD
**DOI WB OKR:** 10.1596/XXXXX
**DOI Zenodo (concept):** 10.5281/zenodo.<C>
**DOI Zenodo (esta versión):** 10.5281/zenodo.<V>
**Checksums:** ver CHECKSUMS.md adjunto

## Resumen del release

<3-5 líneas>

## Cambios desde la versión previa

### Cifras

<lista de cambios cuantitativos significativos, con bump de hallazgo si
aplica>

### Metodología

<cambios en METODOLOGIA con referencia a ADR>

### Productos

<qué piezas se publican: book, web, slides, briefs, panel, etc.>

## ADRs incluidos

- ADR-NNNN: <título>
- ADR-NNNN: <título>

## Errata corregida desde versión previa (si aplica)

<lista de erratas con incident_id>

## Compatibilidad

<si BREAKING: explicar; e.g. panel v12 → v13 no es backward compatible>

## Verificación de reproducibilidad

`renv::restore()` + `bash scripts/rebuild_everything.sh` reproduce todos
los outputs publicados. Versiones canónicas del stack (12_REPRODUCIBILIDAD §2.1).

## Citación canónica

<bloque de 13_PUBLICACION §7>

---

🤖 Generated with care by the APER 2026 team.
```

---

## 9. Workflow especial — Errata sobre tag publicado

```text
SITUACIÓN: una errata se descubre en un release ya tagueado (v1.0.0)

PASOS

1. abrir incidente en 00_admin/incidents/ con severidad P0/P1
2. crear ADR de la corrección
3. crear rama hotfix/<slug>:
     git checkout -b hotfix/errata-fig-05-02 v1.0.0
4. aplicar fix
5. correr A3 sobre el artefacto afectado
6. merge a main + tag nuevo:
     git tag v1.0.1 -m "errata fig 05_02: <breve>"
7. GitHub release con notas claras de la errata
8. Zenodo deposit del nuevo tag (concept DOI se actualiza)
9. errata visible en sitio público (16_INCIDENTES §6.1 plantilla)
10. cerrar incidente

NUNCA:
- borrar v1.0.0 — queda visible como histórico
- editar release notes de v1.0.0 — agregar nota "ver v1.0.1" si aplica
- force-push a main que destruya historial
```

---

## 10. Buenas prácticas de higiene

```text
- commits atómicos: un commit = una unidad lógica de cambio
- mensajes en presente: "agrega" no "agregado"
- evitar commits "WIP" en main; sí están bien en red/ y exp/
- evitar commits que mezclan refactor + feature + fix
- antes de mergear: rebase si la historia es lineal y limpia, merge commit
  si hay valor en preservar la rama
- nunca commitear binarios grandes (> 100 MB) sin git-lfs
- nunca commitear datos crudos completos (van por separado o vía
  .gitignore + OneDrive/Zenodo)
- nunca commitear outputs derivados que están en .gitignore (05_outputs/
  no se commitea — se reproduce desde scripts)
```

### 10.1. Excepciones — qué SÍ commitear en outputs

```text
- 04_report/_book/ → NO commit (se regenera)
- www/_site/       → SÍ commit (necesario para GitHub Pages)
                     o usar workflow CI que lo deploye
- slides/_site/    → NO commit (se regenera)
- 05_outputs/      → NO commit (se regenera; deposit Zenodo en release)

excepción para sitio web: si se usa GitHub Pages desde `gh-pages` branch
o `docs/`, ese folder sí se commitea; convención del repo.
```

---

## 11. Integración con otros archivos

| Archivo | Cómo conecta |
|---|---|
| `08_CONTROL.md` | Color del cambio determina workflow (§4) |
| `13_PUBLICACION.md` | Versionamiento del reporte (§5) sigue su política |
| `12_REPRODUCIBILIDAD.md` | Tag = snapshot reproducible; CHECKSUMS por tag |
| `15_SEGURIDAD.md` | Hooks pre-commit detectan secrets |
| `16_INCIDENTES.md` | Errata sobre tag publicado sigue §9 |
| `09_AUDITORIA.md` | A5 requiere tag de release; A2/A3 pueden trabajar sobre commits intermedios |
| `.agent/decisions/` | Tag opcional por ADR cuando cierra |
| `00_admin/RETOMAR.md` | Cierre de sesión menciona commits / tags relevantes |

---

## 12. Cómo modificar este archivo

| Cambio | Color |
|---|---|
| Agregar tipo de commit | AMARILLO |
| Cambiar modelo de branches §2 | ROJO + ADR |
| Cambiar política de tags inmutables §5 | ROJO + ADR |
| Agregar hook §7 | AMARILLO |
| Cambiar plantilla de PR o release notes | VERDE |

---

## 13. TODOs para alcanzar v1.0

- [ ] Configurar branch protection rules en GitHub para `main`.
- [ ] Implementar `scripts/install_git_hooks.sh`.
- [ ] Crear plantillas de PR y release notes como archivos en `.github/`.
- [ ] Definir si firma de commits (gpg / ssh) es obligatoria.
- [ ] Definir convención de naming de tags pre-release (rc, beta, etc.) si se usan.
- [ ] Auditar el `.gitignore` actual con lista §10 y §4 de SEGURIDAD.
- [ ] Documentar el flujo de hotfix con un caso real una vez ocurra.

---

## 14. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: trunk-based simplificado (main + red/ + hotfix/ + exp/ + release/), branch protection, conventional commits con 14 tipos APER, tags semver inmutables, releases en GitHub con plantilla, workflow para errata sobre tag publicado, hooks pre-commit, buenas prácticas |
