---
description: Genera el bloque estandarizado de cierre de sesión (MASTER_PROMPT Parte 15) basado en los cambios reales del repo desde último commit, y lo pega en `00_admin/RETOMAR.md`.
argument-hint: [opcional — número de sesión, si no se infiere del último N en RETOMAR]
allowed-tools: Bash, Read, Edit, Grep
---

# Cierre estandarizado de sesión

**Argumento (opcional):** número de sesión `$ARGUMENTS`

## Tu tarea

### 1. Inferir número de sesión

```bash
grep -oE "[Ss]esi[oó]n\s+(\d+)" 00_admin/RETOMAR.md | head -3
```

Si `$ARGUMENTS` está vacío, usar el N anterior + 1.

### 2. Recolectar telemetría real (NO inventar)

En paralelo:
- `git status --porcelain` → archivos modificados
- `git diff --stat HEAD` → magnitud del cambio
- `git log --oneline -10` → commits de la sesión (estimar por fecha si hay timestamp)
- `git diff HEAD -- .agent/04_HALLAZGOS.md` → hallazgos tocados (si hay)
- `git diff HEAD -- .agent/01_METODOLOGIA.md` → cambios metodológicos
- `git diff HEAD -- 01_data/processed/spending_panel_v12_dictionary.csv` → cambios al panel

### 3. Clasificar color del cambio (de `.agent/08_CONTROL.md` §4)

| Detección | Color sugerido |
|-----------|:--------------:|
| Edición a `.agent/01_METODOLOGIA.md`, `04_HALLAZGOS.md`, `02_INDICADORES.md`, `06_NEUTRALIDAD.md`, `08_CONTROL.md`, `09_AUDITORIA.md` | 🔴 Rojo |
| Cambio en panel v12 dictionary o script que produce cifra publicada | 🔴 Rojo |
| Nueva figura/tabla, nuevo párrafo, nueva referencia | 🟡 Amarillo |
| Refactor `.claude/`, infra | 🟡 Amarillo |
| Typos, redacción menor sin cambio de claim | 🟢 Verde |

Si detecta 🔴 Rojo y NO hay ADR nuevo en `.agent/decisions/` → flagear.

### 4. Componer bloque siguiendo Parte 15 del MASTER_PROMPT

```markdown
## Sesión N (YYYY-MM-DD) — [título corto del cambio principal]

**Tipo de cambio:** 🟢 verde | 🟡 amarillo | 🔴 rojo
**Archivos modificados:** N
**Tests ejecutados:** [lista o "ninguno"]
**ADR requerido:** sí (ADR-NNNN-slug) | no

### Qué se hizo
1. ...
2. ...

### Cifras tocadas (con trazabilidad)
- ...
- (o "ninguna en esta sesión")

### Hallazgos afectados
- F<NN>: <cambio> (status: draft/reviewed)
- (o "ninguno")

### Capítulos del book afectados
- 04_report/0N_<nombre>.qmd — <subsección>
- (o "ninguno")

### Slides / web actualizadas
- (lista o "ninguna")

### Impacto en panel / metodología
- panel_version: v12 (sin cambio) | v12→v13
- methodology_version: m0.1.0 (sin cambio) | m0.1.0→m0.2.0

### Impacto en MEFP handoff
- (preparación para mesa técnica, ajustes solicitados, etc., o "ninguno")

### Riesgos pendientes
- ...

### Siguientes pasos
1. ...
2. ...
```

### 5. Confirmar el bloque con el usuario ANTES de pegarlo

Mostrar el bloque drafteado y preguntar:
- ¿Faltan cifras tocadas?
- ¿El color del cambio es correcto?
- ¿Hay ADR pendiente?

### 6. Pegar en `00_admin/RETOMAR.md`

Insertar el bloque **al inicio** del archivo, entre el título principal y la sección "0bis" o "0" más reciente. Mantener el orden anti-cronológico (más reciente arriba).

Update también la línea 3 (`**Última sesión:** ...`) con la nueva fecha y descripción corta.

### 7. Verificación

Mostrar al usuario:
- `head -50 00_admin/RETOMAR.md` para confirmar que la entrada se ve bien.
- Sugerir correr `/commit-push` para sellar la sesión.

## Reglas

- NO inventar tests ejecutados ni cifras tocadas — siempre desde git diff.
- NO marcar 🟢 si en realidad se tocó `.agent/04_HALLAZGOS.md` o panel dictionary.
- NO saltarse la confirmación con el usuario antes de pegar.
- Mantener el bloque ≤ 40 líneas (Parte 15 es resumen, no narrativa).
