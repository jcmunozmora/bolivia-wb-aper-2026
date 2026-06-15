# `.codex/` — Configuracion runtime de Codex · APER 2026

**Version:** v0.1.0 · **Ultima actualizacion:** 2026-05-25

Esta carpeta adapta la gobernanza del proyecto para sesiones de Codex. No reemplaza a [`.agent/`](../.agent/README.md).

## Regla de fuente unica

- `.agent/` = gobernanza canonica del APER: identidad, invariantes, metodologia, hallazgos, estilo, control, auditoria.
- `AGENTS.md` = puerta de entrada comun para agentes.
- `.codex/` = instrucciones runtime para Codex: como leer, ejecutar, auditar y cerrar sesiones siguiendo `.agent/`.

Si hay conflicto, prevalece `.agent/00_MASTER_PROMPT.md`, luego `AGENTS.md`, luego esta carpeta.

## Mapa

```text
.codex/
├── README.md
├── instructions.md
├── agents/
│   └── claude-writing-verifier.md
├── checklists/
│   ├── preflight.md
│   ├── trace-and-citations.md
│   └── session-close.md
├── commands/
│   └── verify-claude-writing.md
└── skills/
    ├── aper-governance/SKILL.md
    ├── aper-writing/SKILL.md
    └── aper-audit/SKILL.md
```

## Quickstart para Codex

1. Lee `AGENTS.md`.
2. Lee `.agent/00_MASTER_PROMPT.md`, `00_admin/RETOMAR.md` y `.agent/README.md`.
3. Lee `.codex/instructions.md`.
4. Segun la tarea, carga el checklist o skill local relevante:
   - escritura: `.codex/skills/aper-writing/SKILL.md`;
   - auditoria/revision: `.codex/skills/aper-audit/SKILL.md`;
   - verificacion de escritura de Claude: `.codex/agents/claude-writing-verifier.md`;
   - codigo, datos, figuras o gobernanza: `.codex/skills/aper-governance/SKILL.md`.
5. Clasifica el cambio con `.agent/08_CONTROL.md` antes de editar.
6. Cierra la sesion actualizando `00_admin/RETOMAR.md` con `.codex/checklists/session-close.md`.

## Limitacion importante

Codex no ejecuta automaticamente los hooks definidos en `.claude/`. Por eso esta carpeta convierte esos controles en checklists manuales y skills locales. Si una validacion debe ser bloqueante para todos los agentes, debe implementarse en scripts o CI del repositorio, no solo como instruccion.
