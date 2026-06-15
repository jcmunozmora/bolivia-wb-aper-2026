---
name: aper-audit
description: Use when reviewing, auditing or verifying APER Bolivia 2026 artifacts: chapters, sections, figures, tables, slides, web pages, findings, citations, model outputs or reproducibility. Produces risk-first findings grounded in files, lines and governance gates.
---

# APER Audit For Codex

## Read Before Auditing

1. `.agent/08_CONTROL.md`
2. `.agent/09_AUDITORIA.md`
3. `.agent/04_HALLAZGOS.md`
4. `.codex/checklists/trace-and-citations.md`

For prose audits also read `.agent/05_ESTILO_NARRATIVO.md` and `.agent/06_NEUTRALIDAD.md`.

If the audit is specifically about Claude-generated writing in `04_report/` (or the user says `05_report`), read `.codex/agents/claude-writing-verifier.md` and use its stricter AI-pattern and line-level reporting rules.

## Audit Stance

Lead with findings, ordered by severity. Include file and line references. Focus on bugs, traceability failures, reproducibility gaps, governance violations and publication risk.

Do not rewrite the audited artifact unless the user explicitly asks for fixes.

## Core Gates

- Data: numbers come from panel v12 or documented exception.
- Trace: every number has RDS, script, variable, filter, period, source and uncertainty.
- Findings: F01-F08 claims match `.agent/04_HALLAZGOS.md`.
- Citations: no red/unverified/orphan literature.
- Voice: neutral, impersonal, no advocacy.
- Reproducibility: scripts run from repo paths and outputs are deterministic.
- Versioning: red changes have ADR and bumps.

## Review Output Format

```markdown
Findings
1. High/Medium/Low — <issue>. File:line. Why it matters. Required fix.

Open Questions
- <question if needed>

Verification
- Commands run and result.
- Commands not run and why.
```

If no issues are found, say that clearly and list residual risk or test gaps.
