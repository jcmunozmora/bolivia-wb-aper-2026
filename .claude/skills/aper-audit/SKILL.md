---
name: aper-audit
description: Activar cuando se va a auditar/verificar/revisar un producto del APER 2026 — capítulos, slides, hallazgos, figuras, fichas de literatura. Carga los checklists A1–A6 + G1–G7 + gate §13B y los protocolos de fallo. Skip si la tarea es redactar/editar contenido nuevo (eso es `aper-writing`).
---

# Cómo se audita en el APER 2026

## Principio rector

> Nada se publica sin auditoría documentada. La auditoría se firma. Los hallazgos quedan trazables. El log es inmutable.

`08_CONTROL.md` define las **reglas**; `09_AUDITORIA.md` las **verifica**. Sin auditoría, las reglas son aspiracionales.

## Los 6 niveles de auditoría (A1–A6)

| Nivel | Cuándo | Quién audita | Output |
|:-----:|--------|--------------|--------|
| **A1 Pre-flight** | Antes de empezar a escribir | Auditor + autor | Lista de gaps que bloquean |
| **A2 Cifras y figuras** | Después de incluir cada cifra/figura | Auditor | Pass/fail por ítem |
| **A3 Texto** | Capítulo en draft completo | Auditor adversarial (≠ autor) | Pass/fail por sección |
| **A4 Hallazgos** | Antes de marcar finding como `reviewed` | Auditor + humano | Verdict + ADR si aplica |
| **A5 Slides/web** | Antes de publicar | Auditor | Pass/fail por slide/página |
| **A6 Cierre** | Antes de mesa técnica MEFP | Auditor + TTL | Sign-off documental |

Detalle completo en `.agent/09_AUDITORIA.md`.

## Gates G1–G7 (de `00_MASTER_PROMPT.md` Parte 11.1)

Ningún capítulo cierra sin pasar los 7 gates:

- **G1 Datos:** todas las cifras del panel v12. Ninguna del v1/v10/v11.
- **G2 Hallazgos:** cada F<NN> asignado al capítulo aparece con cifra exacta.
- **G3 Figuras:** todas con caption + fuente + alt-text bilingüe (donde aplica web).
- **G4 APER 2011:** caja comparativa o párrafo explícito de conexión.
- **G5 Citas:** toda afirmación no trivial con `[@key]`, ficha green/yellow.
- **G6 Voz:** tercera impersonal, sin advocacy, cifras con año+fuente.
- **G7 Longitud:** dentro del target ±15%.

## Gate §13B — literatura

> Una ficha de `03_literature/` sólo puede citarse en `04_report/*.qmd` si su `audit_status ∈ {green, yellow}`.

Razón: sesión 11 detectó 42% de alucinación en el corpus. Ver `03_literature/_audit/RED_FLAGS.md`.

## Protocolo de auditoría (workflow estándar)

### Paso 1 — Pre-flight A1

Verificar disponibilidad de:
- [ ] Panel v12 (`01_data/processed/spending_panel_v12.rds`)
- [ ] Datasets canónicos del capítulo (ver Parte 5.1 MASTER_PROMPT)
- [ ] Figuras requeridas (en `05_outputs/figures/`)
- [ ] Findings citados existen en `04_HALLAZGOS.md`
- [ ] Fichas de literatura citadas tienen `audit_status` verificable

### Paso 2 — A2 cifra por cifra

Por cada número del texto:
- [ ] Año explícito
- [ ] Unidad (% / BOB / USD / hectáreas)
- [ ] RDS de origen identificable
- [ ] Script de cálculo en `02_code/03_analysis/` localizable
- [ ] Fuente cruda citada (BOOST / FAO / IDB / WDI / etc.)
- [ ] Si cita `[@key]`: status green/yellow

### Paso 3 — A3 texto

```bash
# Neutralidad
grep -nE "(se equivocó|fracasó|debe|tiene que|urge|Bolivia necesita|gobierno de [A-Z])" <archivo>

# Voz
grep -nE "\b(encontramos|nuestro|nuestra|creemos|pensamos|opinamos)\b" <archivo>

# Panel version
grep -nE "spending_panel(?!_v12)|panel_v(1\b|10|11)" <archivo>

# Citas
grep -oE '@[A-Za-z][A-Za-z0-9_:.\-]+' <archivo> | sort -u
```

### Paso 4 — A4 hallazgos

Por cada `F<NN>` mencionado:
- [ ] Existe en `04_HALLAZGOS.md`
- [ ] `magnitude` del .qmd coincide con `magnitude` del HALLAZGOS
- [ ] `status` ∈ {draft, reviewed, MEFP_validated} (no `retired`)
- [ ] `panel_version` y `methodology_version` consistentes

### Paso 5 — Gates G1–G7

Aplicar checklist arriba.

### Paso 6 — Verdict

```
✅ READY FOR REVIEW (todos los gates pasan, A1–A4 firmados)
🟡 PASS CON CAVEATS (gates pasan; caveats listados deben resolverse antes de A6)
🔴 FAIL (algún gate fallado; lista de acciones requeridas)
```

## Protocolo de falla (A2/A3/A4 FAIL)

Si una auditoría falla:

1. **NO** modificar el archivo auditado (sos solo lectura como auditor).
2. Generar reporte estructurado con:
   - Verdict
   - Bloqueos (qué impide pasar)
   - Acciones requeridas (concretas, por archivo y línea)
3. Devolver al autor para corrección.
4. Re-auditar después de corrección — no asumir que la corrección fue completa.

## Cosas que el auditor NUNCA hace

- Editar el archivo auditado.
- Suavizar verdicts.
- Aceptar "lo verificaré después".
- Aprobar TODO_TRACE pendiente.
- Aprobar cita a ficha unverified/red.
- Auditar prosa que él mismo escribió (independencia).

## Subagentes disponibles para delegar

- `aper-auditor` → A1–A6 + G1–G7 (general)
- `aper-trace-verifier` → solo invariante 3.1 (trazabilidad cifras)
- `aper-citation-auditor` → solo gate §13B (citas literatura)

Para auditar un capítulo completo: `/audit-chapter <NN>` lanza los 3 en paralelo y consolida.
