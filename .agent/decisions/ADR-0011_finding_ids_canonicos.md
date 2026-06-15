# ADR-0011 — Reasignación de `finding_id` a la numeración canónica del plan editorial

**Estado:** aceptado
**Fecha:** 2026-05-24
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: pendiente firma TTL]_
**Color de cambio:** rojo (toca `.agent/04_HALLAZGOS.md` — fuente única de claims y zona crítica según `.agent/08_CONTROL.md §3`)

---

## Contexto

Durante la redacción del borrador v0.1 del reporte técnico (sesión 13, 2026-05-24) se detectó que la numeración de los ocho hallazgos del APER 2026 está **desalineada** entre la fuente única de claims (`.agent/04_HALLAZGOS.md`) y el resto del proyecto.

`.agent/04_HALLAZGOS.md` v0.1.0 (creado en sesión 12) fue documentado explícitamente como **esqueleto** con propuestas iniciales de títulos y todos los `claim_es` en `[TODO_TRACE]`. La sección §5 del archivo dice literalmente: *"Los títulos y temas son **propuestas iniciales** alineadas con la estructura del Quarto book — requieren validación del equipo APER antes de pasar a `draft` formal".*

En paralelo, la numeración real con cifras canónicas se consolidó en:

1. `00_admin/RETOMAR.md §6` (tabla "8 hallazgos cuantitativos del estudio") — desde sesión 10.
2. `.agent/20_CONTENIDO_REPORTE.md` (plan editorial v0.5.0) — cap a cap.
3. Caps 1–6 + RE (`04_report/`) — redactados en sesión 13.
4. Slides del kickoff BM 2026-04-27.

La numeración usada en (1)–(4) — referida en adelante como **numeración canónica** — fija una asignación distinta a la del esqueleto:

| ID | Numeración canónica (RE + caps + plan + RETOMAR + slides) | ID en HALLAZGOS.md v0.1.0 | Estado claim_es en v0.1.0 |
|:-:|---|:-:|:-:|
| F01 | Inversión ×10 vs TFP estancada | F02 ("Brechas sectoriales") | TODO_TRACE |
| F02 | PSE 5,8% (5° LAC) | F06 ("PSE/CSE nivel y composición") | TODO_TRACE |
| F03 | Patrón dual NRP (soya −37%, maíz +46%) | — (no existe) | n/a |
| F04 | Maputo nunca (máx 3,48% en 1990) | F01 ("Magnitud y evolución del gasto") | TODO_TRACE |
| F05 | Sustitución gasto → crédito (×11,7 post-Ley 393) | — (no existe) | n/a |
| F06 | Pobreza rural 55→40→45% (2012–2024) + FIES 49→74% | parcial en F02 actual | TODO_TRACE |
| F07 | PAR III subejecutado (16% financiero 2024) | F07 ("Arquitectura institucional") | TODO_TRACE |
| F08 | Frontera agropecuaria (9,4 M ha; 64% Santa Cruz) | — (no existe) | n/a |

Adicionalmente, el esqueleto v0.1.0 contiene tres entries que en la numeración canónica **no son hallazgos** sino dimensiones absorbidas u objetos distintos:

- F03 ("Composición transferencias vs bienes públicos") → absorbida por F02 canónico (composición OECD-PSE) y por la prosa del Cap 3 (composición MAFAP).
- F04 ("Distribución territorial") → absorbida por F07 canónico (organización del gasto).
- F05 ("Eficiencia y focalización") → absorbida por F02 canónico (PSE/GSSE) + Cap 5 DEA.
- F08 ("Oportunidades de repurposing") → no es un hallazgo sino una agenda de **escenarios** S01/S02/S03 documentados en el Cap 6 y en `.agent/06_NEUTRALIDAD.md §8.3`.

## Decisión

Se adopta la **numeración canónica** del plan editorial como única numeración válida para todos los productos del APER 2026 (HALLAZGOS, RE, caps, slides, briefs, web, ADRs futuros). En consecuencia:

1. **Reescritura completa de `.agent/04_HALLAZGOS.md` §5**: las ocho entries pasan a la numeración canónica F01–F08 con `title_es`, `title_en`, `claim_es`, `claim_en`, `magnitude`, `evidence`, `benchmark`, `uncertainty`, `methodology_version`, `panel_version`, `policy_implication_es`, `linked_chapters` y `status` completos, no en TODO_TRACE.
2. **Las cifras de los claims** son las verificadas durante sesión 13 contra el panel v12 (verificación documentada en `00_admin/RETOMAR.md §0 — Sesión 13 → Cifras tocadas`).
3. **`version: v1`** se mantiene para los 8 hallazgos: representa la **primera versión formal** del contrato, no la segunda; el esqueleto v0.1.0 anterior se considera draft pre-formal sin necesidad de bumpear.
4. **`status: draft`** se mantiene: las cifras existen y son reproducibles, pero los gates A1–A6 de `09_AUDITORIA.md` aún no han corrido sobre los contratos nuevos.
5. **Versión del archivo `04_HALLAZGOS.md`** bumpa **v0.1.0 → v0.2.0** (segundo nivel, cambio mayor en contenido pero no en estructura del contrato).
6. **El esqueleto v0.1.0 anterior se archiva** en `.agent/legacy/04_HALLAZGOS_v0_1_0.md` con cabecera explícita que indica su superseción por v0.2.0 vía este ADR.
7. **Trazabilidad de mapeo** entre numeraciones se preserva en este ADR (tabla anterior) para casos en los que un script o documento legacy aún use la numeración del esqueleto.

## Alcance

Este ADR afecta directamente:

- `.agent/04_HALLAZGOS.md` (reescritura completa de §5).
- `.agent/legacy/04_HALLAZGOS_v0_1_0.md` (creación del archivado).

Y confirma como ya correctas las referencias a F01–F08 en:

- `04_report/index.qmd` (RE).
- `04_report/01_introduction.qmd` a `06_recommendations.qmd` (caps).
- `.agent/20_CONTENIDO_REPORTE.md` (plan editorial).
- `00_admin/RETOMAR.md §6`.
- `slides/2026-04-27_kickoff/`.

No requiere re-redacción de los caps porque ya usan la numeración canónica.

## Consecuencias

**Positivas.**

- Habilita el gate A1 de `09_AUDITORIA.md` (verificación de contratos finding-by-finding) — bloqueado hasta ahora por contratos vacíos.
- Cierra el riesgo de inconsistencia entre referencias `[@F02]` en caps y contrato en HALLAZGOS.
- Permite que el auditor adversarial (`/audit-chapter`) corra sobre los seis caps redactados.
- Deja `04_HALLAZGOS.md` listo para la transición `draft → reviewed → MEFP_validated` definida en `.agent/08_CONTROL.md`.

**Negativas y mitigaciones.**

- **Pérdida del esqueleto antiguo**: mitigada por archivado en `legacy/`.
- **Posibles referencias a la numeración antigua en scripts o docs**: mitigada por trazabilidad explícita en este ADR. Cualquier script que aún use la numeración antigua debe corregirse al actualizarse; este ADR es el punto de referencia.
- **Las cifras siguen en `status: draft`**: hasta que pasen el gate A3 de auditoría, no se promueven a `reviewed`. El MEFP_validated requiere validación formal en mesa técnica.

**Neutralidad.**

Esta decisión es de gobernanza, no de contenido. No introduce sesgo en los hallazgos ni en su interpretación. Los `policy_implication_es` se redactan siguiendo `.agent/06_NEUTRALIDAD.md` (lenguaje no prescriptivo, sin actores políticos, opciones técnicas para consideración del MEFP).

## Referencias

- `.agent/00_MASTER_PROMPT.md` v0.4.0 (ADR-0008).
- `.agent/04_HALLAZGOS.md` v0.1.0 (esqueleto que este ADR supera).
- `.agent/08_CONTROL.md` §3 (gobernanza de cambios rojos).
- `.agent/09_AUDITORIA.md` (gates A1–A6).
- `.agent/20_CONTENIDO_REPORTE.md` v0.5.0 (plan editorial — fuente de la numeración canónica).
- `00_admin/RETOMAR.md §6` (tabla 8 hallazgos cuantitativos del estudio).
- `04_report/index.qmd` (RE redactado en sesión 13 con la numeración canónica).
