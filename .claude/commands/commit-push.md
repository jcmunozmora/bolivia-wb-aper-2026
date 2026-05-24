---
description: Crea un commit estructurado siguiendo las convenciones del APER (scope, tipo de cambio, Co-Authored-By) y opcionalmente pushea. Con safeguards: bloquea archivos sospechosos, exige clasificación verde/amarillo/rojo, recuerda ADR si rojo.
argument-hint: [opcional: mensaje corto custom — si no, se infiere de los cambios]
allowed-tools: Bash, Read, Grep
---

# Commit + push estructurado del APER 2026

**Argumento (opcional, mensaje corto):** `$ARGUMENTS`

## Tu tarea

### 1. Inspección previa (NO commitear nada todavía)

Ejecutá en paralelo (un mensaje, múltiples Bash tool calls):
- `git status --porcelain`
- `git diff --stat`
- `git log --oneline -5`
- `git rev-parse --abbrev-ref HEAD`

### 2. Validaciones de seguridad

- **Branch protegida:** si estamos en `main` o `master`, advertir explícitamente al usuario antes de proceder. Pedir confirmación.
- **Archivos sospechosos:** si hay `.env`, `credentials`, `secret`, `*.pem`, `*.key` en el diff → **PARÁ** y reportá. NO commitear hasta resolver.
- **Binarios grandes:** si hay archivos > 5 MB (PDFs, RDS, ZIPs) → confirmar con usuario que deben ir al repo (no a `.gitignore`).

### 3. Clasificar el cambio según `.agent/08_CONTROL.md`

Por scope detectado (de `git status`):

| Path tocado | Color sugerido |
|-------------|:--------------:|
| Solo prosa/typos en `.qmd` sin cambio de cifra | 🟢 Verde |
| Nueva figura/tabla derivada de panel existente | 🟡 Amarillo |
| Nuevo párrafo explicativo, nueva referencia | 🟡 Amarillo |
| Edición a `.agent/01_METODOLOGIA.md`, `04_HALLAZGOS.md`, `02_INDICADORES.md`, `06_NEUTRALIDAD.md`, `08_CONTROL.md`, `09_AUDITORIA.md` | 🔴 Rojo |
| Cambio en script que produce cifra publicada | 🔴 Rojo |
| Cambio en panel v12 dictionary o RDS canónico | 🔴 Rojo |
| Refactor de `.claude/` (hooks, agents) | 🟡 Amarillo |
| Setup de infra (renv.lock, .gitignore, README) | 🟢/🟡 según alcance |

**Si es 🔴 Rojo**: confirmar que existe ADR correspondiente en `.agent/decisions/`. Si no, **PARÁ** y pedí al usuario que lo cree antes de commitear.

### 4. Componer mensaje de commit

Formato canónico:

```
<tipo>(<scope>): <resumen imperativo en 1 línea, < 72 chars>

<cuerpo opcional: por qué del cambio, no qué — el diff dice qué>
- Bullet con dato relevante 1
- Bullet con dato relevante 2

[Color: 🟢/🟡/🔴 | si rojo: ADR-NNNN-slug]

Co-Authored-By: Claude Opus 4.7 (1M context) <noreply@anthropic.com>
```

**Tipos** (convención del proyecto, basada en commits previos):
- `feat` — nueva funcionalidad/script/figura/sección
- `fix` — corrección de bug/cifra/typo crítico
- `docs` — documentación, gobernanza, RETOMAR, fichas
- `refactor` — reorganización sin cambio funcional
- `chore` — infra, dependencias, .gitignore, settings
- `audit` — adiciones/cambios de gates de auditoría
- `slides` — específico a slides/
- `ci` — workflows GitHub Actions

**Scopes** (sugeridos según diff):
- `data` (01_data/), `code` (02_code/), `lit` (03_literature/), `report` (04_report/), `outputs` (05_outputs/), `gov` (.agent/), `claude` (.claude/), `slides`, `web` (www/), `admin` (00_admin/)

Si el usuario pasó `$ARGUMENTS`, usar como resumen; si no, inferir del diff.

### 5. Ejecutar commit con HEREDOC

```bash
git add <archivos específicos — NO usar git add -A>
git commit -m "$(cat <<'EOF'
<mensaje compuesto arriba>
EOF
)"
```

**Reglas para `git add`:**
- Listar archivos por path explícito (jamás `-A` o `.`).
- Excluir cualquier sospechoso aunque pase la validación inicial.
- Si hay submodules o cambios fuera del scope esperado, listar y pedir confirmación.

### 6. Verificar éxito del commit

```bash
git status
git log -1 --stat
```

### 7. Push

- Si todo OK y branch ≠ `main`/`master`: `git push -u origin <branch>` o `git push`.
- Si branch es `main`/`master`: confirmar UNA VEZ MÁS con el usuario antes de pushear. Mostrar `git log --oneline -3` para que vea qué pushea.
- **NUNCA** `--force` ni `-f` sin que el usuario lo solicite explícitamente y la rama no sea protegida.

### 8. Reportar al usuario

```
✅ COMMIT + PUSH EXITOSOS
  Branch: <branch>
  Commit: <hash> "<resumen>"
  Files: <N>
  Color: <verde/amarillo/rojo>
  ADR: <ref si aplica>
  Remote: <upstream> ahora a +0 / pushed
```

## Cosas que NUNCA hacés

- `git add -A` o `git add .` o `git add *`.
- `git push --force` / `--force-with-lease` sin pedido explícito.
- `git commit --amend` (siempre commits nuevos, no modificar pasados).
- `git push` con `--no-verify` (no saltarse hooks).
- `-c commit.gpgsign=false` u otras desactivaciones de firma.
- Commitear `.env`, credenciales, RDS grandes sin verificar.
- Commitear si el archivo `.qmd` tiene TODO_TRACE pendiente sin advertir al usuario.
- Marcar el push como exitoso si `git push` devolvió error.
