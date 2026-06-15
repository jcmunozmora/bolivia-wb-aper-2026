---
name: aper-writing
description: Use when drafting or editing prose for APER Bolivia 2026: Quarto report chapters, executive summaries, slides, web pages, briefs, letters, captions, alt text, or bilingual text. Enforces World Bank technical voice, TEEL structure, neutrality, traceability and anti-AI prose checks.
---

# APER Writing For Codex

## Read Before Writing

1. `.agent/05_ESTILO_NARRATIVO.md`
2. `.agent/06_NEUTRALIDAD.md`
3. `.agent/04_HALLAZGOS.md` if citing F01-F08
4. `.codex/checklists/trace-and-citations.md`

## Voice

Write in World Bank technical voice: sober, evidence-based, impersonal third person, no advocacy and no moral adjectives.

Do not write:

- first-person plural (`encontramos`, `nuestro`, `creemos`);
- imperatives (`Bolivia debe`, `urge`, `se necesita`);
- political actor framing (`el gobierno de X`);
- unsupported generalities (`la evidencia muestra` without evidence).

Use:

- period framing (`en 2006-2019`, `durante los años fiscales...`);
- `la evidencia disponible indica`;
- `una opcion tecnica para consideracion del MEFP`;
- `la brecha frente al benchmark`.

## Paragraph Unit

Use TEEL:

```text
T — one claim, preferably finding-first.
E — evidence with year, unit and trace.
X — mechanism, benchmark or caveat.
L — link to next paragraph or policy option.
```

Target 80-140 words per substantive paragraph. If above 160, split.

## Numbers

Every number needs year, unit and source. If trace is missing, write `TODO_TRACE` instead of a plausible number.

Codex must not calculate averages or ratios mentally for report prose. Run the script or read the RDS/output.

## Citations

Only cite literature fiches with `audit_status` in `{green, yellow}`. Do not cite `red`, `unverified` or orphan keys.

Avoid verbatim quotations unless the PDF and page have been directly verified.

## Anti-AI Check

Before returning prose, apply `.agent/05_ESTILO_NARRATIVO.md` Standard 0 and the Spanish deep layer. Remove:

- `Cabe destacar`, `Es importante senalar`, `En este contexto`;
- generic three-item lists;
- decorative connectors;
- vague potential language without quantified evidence;
- English syntax transferred into Spanish.

Report remaining `TODO_TRACE` explicitly.
