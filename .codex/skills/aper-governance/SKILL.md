---
name: aper-governance
description: Use when working in the APER Bolivia 2026 repository on governance, code, data, models, figures, report chapters, web, slides, reproducibility, methodology, findings, or project state. Loads the project-specific invariants and points Codex to the canonical `.agent/` documents before acting.
---

# APER Governance For Codex

## Source Of Truth

`.agent/` is canonical. This skill is a runtime adapter for Codex.

Read first:

1. `AGENTS.md`
2. `.agent/00_MASTER_PROMPT.md`
3. `00_admin/RETOMAR.md`
4. `.agent/README.md`
5. `.codex/instructions.md`

## Non-Negotiables

- Trace every published number to RDS, script, variable, filter, period, raw source, panel/methodology version and uncertainty.
- Use `01_data/processed/spending_panel_v12.rds` as the quantitative source of truth.
- Keep technical neutrality; do not use advocacy, moral judgment or political actors as narrative units.
- Codex writes, audits and runs scripts; it does not invent numbers.
- Preserve ES/EN parity where content is bilingual.
- Version methodology, findings and panel changes. Red changes require ADR.
- Keep work reproducible from scripts and documented outputs.

## Change Classification

Before editing, classify with `.agent/08_CONTROL.md`.

- VERDE: cosmetic, non-methodological docs, refactor without output change.
- AMARILLO: new content, new figure/table from existing panel, new citation or page.
- ROJO: any change to figures already published, definitions, formulas, filters, findings, methodology, scenarios, panel, neutral language rules, scope or published numbers.

If unsure, raise the level.

## Canonical Commands

```bash
/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript --no-init-file
Rscript -e 'renv::restore()'
cd 04_report && quarto render
cd www && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 quarto render
cd docs && python3 -m http.server 8000
```

## Operational Rules

- Check `git status --short` before substantive edits.
- Never revert user changes unless explicitly asked.
- Prefer `rg` for search and `apply_patch` for manual edits.
- Avoid absolute personal paths in scripts; use `here::here()` or setup constants.
- Close substantive sessions by updating `00_admin/RETOMAR.md` using `.codex/checklists/session-close.md`.
