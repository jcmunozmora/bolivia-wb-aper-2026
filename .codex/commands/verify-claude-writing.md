# Verify Claude Writing

Use this command pattern when the user asks to verify Claude's writing in the APER report.

## Argument

`<NN | path | all>`

Examples:

```text
05
04_report/05_spending_analysis.qmd
05_report
all
```

## Target Resolution

1. If argument is `all`, audit all main chapter files in `04_report/*.qmd`, excluding `references.qmd` unless explicitly requested.
2. If argument is a chapter number, resolve to `04_report/<NN>_*.qmd`.
3. If argument starts with `05_report` and `05_report/` does not exist, treat it as `04_report/` and state the assumption.
4. If argument is an existing path, audit that path.

## Procedure

1. Read `.codex/agents/claude-writing-verifier.md`.
2. Run the verifier workflow in read-only mode.
3. Produce a line-referenced verdict.
4. Do not edit the target file unless the user separately asks for fixes after the audit.

## Minimum Checks

```bash
rg -n "TODO_TRACE|CITA NECESARIA|\\[TODO|placeholder|pendiente" <target>
rg -n "(Cabe mencionar|Cabe destacar|Es importante senalar|Es importante señalar|En los ultimos anos|En los últimos años|puede contribuir|podria apoyar|podría apoyar)" <target>
rg -n "(se equivoco|se equivocó|fracas[oó]|debe|tiene que|urge|Bolivia necesita|gobierno de|administraci[oó]n de)" <target>
rg -n "spending_panel\\.rds|spending_panel_v10|spending_panel_v11|panel_v10|panel_v11" <target>
rg -o "@[A-Za-z][A-Za-z0-9_:\\.-]*" <target> | sort -u
```
