# `.claude/` — Configuración runtime de Claude Code · APER 2026

**No confundir con [`.agent/`](../.agent/README.md):**
- `.agent/` = **gobernanza editorial** (specs, hallazgos, metodología) — para cualquier agente.
- `.claude/` = **configuración runtime + agentes + hooks** — solo Claude Code.

---

## Mapa

```
.claude/
├── settings.json            # Compartido (committed). Permisos, env vars, hooks.
├── settings.local.json      # Personal (gitignored). Overrides locales.
├── README.md                # Este archivo.
│
├── hooks/                   # Validación automática (bloquean o avisan)
│   ├── validate-qmd-edit.sh        ← PreToolUse: bloquea advocacy + panel viejo + nombres políticos
│   ├── validate-citations.sh       ← PreToolUse: bloquea citas red/unverified/orphan (gate §13B)
│   ├── governance-zone-warn.sh     ← PostToolUse: avisa cuando se edita zona crítica .agent/
│   ├── session-close-prompt.sh     ← Stop: recuerda actualizar RETOMAR.md
│   └── git-commit-push-status.sh   ← Stop: estado git + sugerencia de commit/push
│
├── agents/                  # Subagentes especializados
│   ├── aper-writer.md              ← Redactor con voz WB + TEEL + filtro anti-IA
│   ├── aper-auditor.md             ← Auditor adversarial A1–A6 + G1–G7
│   ├── aper-trace-verifier.md      ← Solo invariante 3.1 (trazabilidad cifras)
│   └── aper-citation-auditor.md    ← Solo gate §13B (citas literatura)
│
├── commands/                # Slash commands de proyecto
│   ├── write-section.md            ← /write-section <NN> → contexto + delega a aper-writer
│   ├── audit-chapter.md            ← /audit-chapter <NN> → 3 auditores en paralelo
│   ├── check-trace.md              ← /check-trace <path> → trazabilidad cifras
│   ├── check-citations.md          ← /check-citations <path> → gate §13B
│   ├── new-finding.md              ← /new-finding F<NN> → scaffold con contrato JSON
│   ├── close-session.md            ← /close-session → bloque Parte 15 → RETOMAR.md
│   └── commit-push.md              ← /commit-push → commit estructurado + push con safeguards
│
└── skills/                  # Skills auto-invocables (Claude las carga según contexto)
    ├── aper-governance/SKILL.md    ← Identidad + 7 invariantes + datasets + findings catalog
    ├── aper-writing/SKILL.md       ← TEEL + WB voice + filtro anti-IA detallado
    └── aper-audit/SKILL.md         ← Gates A1–A6 + G1–G7 + protocolo de falla
```

---

## Hooks — cuándo se disparan y qué hacen

| Hook | Evento | Matcher | Comportamiento |
|------|--------|---------|----------------|
| `validate-qmd-edit.sh` | **PreToolUse** | `Edit\|Write\|MultiEdit` | Si edita `04_report/*.qmd`: bloquea (exit 2) frases advocacy explícitas (`se equivocó`, `Bolivia necesita`, etc.), imperativos institucionales (`el gobierno debe`, `urge implementar`), nombres políticos, referencias a panel v1/v10/v11. Pasa con warning (exit 0) primera persona plural y cifras grandes sin moneda. |
| `validate-citations.sh` | **PreToolUse** | `Edit\|Write\|MultiEdit` | Si edita `04_report/*.qmd`: extrae `[@citekey]`, busca ficha en `03_literature/`, lee `audit_status` del frontmatter. **Bloquea** (exit 2) citas a `red`, `unverified` u `orphan`. Pasa con warning para `yellow`. Silencioso para `green`. |
| `governance-zone-warn.sh` | **PostToolUse** | `Edit\|Write\|MultiEdit` | Si edita `.agent/04_HALLAZGOS.md`, `01_METODOLOGIA.md`, `02_INDICADORES.md`, `06_NEUTRALIDAD.md`, `08_CONTROL.md`, `09_AUDITORIA.md`, o panel dictionary: imprime recordatorio explícito de bump versión + ADR requerido. No bloquea. |
| `session-close-prompt.sh` | **Stop** | `*` | Si hay cambios sustantivos (`.agent/`, `04_report/`, `02_code/`, `01_data/processed/`, `.claude/`, `slides/`) y `RETOMAR.md` no está modificado: imprime recordatorio de pegar bloque Parte 15. |
| `git-commit-push-status.sh` | **Stop** | `*` | Si hay archivos sin commit o commits unpushed: lista archivos agrupados por scope, detecta archivos sospechosos (`.env`, secrets) y binarios grandes, sugiere comando seguro. No ejecuta. |

---

## Subagentes — cómo se invocan

Vía Task tool con `subagent_type: <nombre>`:

```typescript
Task({
  subagent_type: "aper-writer",
  description: "Redactar Cap 2 §3",
  prompt: "<contexto del slash command write-section + bloque del capítulo>"
})
```

Los slash commands (`/write-section`, `/audit-chapter`) ya los invocan en paralelo. Para uso manual: ver descripciones de cada agente en su `.md`.

---

## Skills — cuándo se cargan

Claude Code carga automáticamente skills cuando detecta contexto relevante. Para este proyecto:

- **`aper-governance`** se activa cuando trabajás en `04_report/`, `.agent/`, `02_code/`, `01_data/processed/`, `slides/`, `www/` o cuando el usuario menciona el reporte, hallazgos, metodología, invariantes, gates.
- **`aper-writing`** se activa cuando vas a redactar prosa (capítulos `.qmd`, slides, briefs, web).
- **`aper-audit`** se activa cuando vas a auditar/verificar/revisar.

Las skills añaden contexto operativo sin que tengas que pegarlo cada vez.

---

## Quickstart para Claude (al entrar en este repo)

1. **Lee CLAUDE.md** (raíz) — thin pointer.
2. **Lee `.agent/README.md` + `.agent/00_MASTER_PROMPT.md` Partes 1–5.**
3. **Si vas a editar `04_report/*.qmd`:** los hooks van a validar. Anticipá las reglas leyendo `.agent/06_NEUTRALIDAD.md` + `.agent/05_ESTILO_NARRATIVO.md`.
4. **Para tareas grandes:** usá los slash commands (`/write-section`, `/audit-chapter`, `/check-trace`, `/check-citations`).
5. **Al cierre:** `/close-session` para actualizar RETOMAR, luego `/commit-push`.

---

## Convención de modificación

- **Hooks**: cambios = AMARILLO. Probar el smoke-test (pipe JSON al script) antes de commitear. Verificar exit codes.
- **Agentes**: cambios en system prompt = AMARILLO si refinamiento, ROJO si cambia el rol (afecta a quién delega `/write-section` etc.).
- **Commands**: AMARILLO. Documentar el nuevo `argument-hint` y `allowed-tools`.
- **Skills**: cambios en `description` o `name` = AMARILLO (afecta auto-invocación).
- **settings.json**: cambios sustantivos = AMARILLO ([`.agent/08_CONTROL.md`](../.agent/08_CONTROL.md)).
- **settings.local.json**: libre (gitignored).

---

## Testing los hooks manualmente

```bash
# Hook validate-qmd-edit
echo '{"tool_name":"Edit","tool_input":{"file_path":"04_report/02_sector_performance.qmd","old_string":"","new_string":"El gobierno se equivocó."}}' | .claude/hooks/validate-qmd-edit.sh
# Esperado: exit 2 + mensaje de bloqueo

# Hook validate-citations
echo '{"tool_name":"Edit","tool_input":{"file_path":"04_report/02_sector_performance.qmd","old_string":"","new_string":"Según [@OECD2023_APME] ..."}}' | .claude/hooks/validate-citations.sh
# Esperado: exit 2 si la ficha es unverified/red

# Hook governance-zone-warn
echo '{"tool_name":"Edit","tool_input":{"file_path":".agent/04_HALLAZGOS.md","old_string":"x","new_string":"y"}}' | .claude/hooks/governance-zone-warn.sh
# Esperado: exit 0 + recordatorio rojo + ADR
```

---

*v1.0 · 2026-05-23 · Ecosistema completo: 5 hooks + 4 agents + 7 commands + 3 skills + settings.json wireado.*
