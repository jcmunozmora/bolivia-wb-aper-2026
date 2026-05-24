# ADR-0008 — Bump del MASTER_PROMPT a v0.4.0 e integración del bloque D

**Estado:** aceptado
**Fecha:** 2026-05-23
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: pendiente firma TTL]_
**Color de cambio:** rojo (toca MASTER_PROMPT — zona crítica según [`08_CONTROL §3`](../08_CONTROL.md))

---

## Contexto

El proyecto APER 2026 incorporó entre v0.3.0 y v0.3.3 once nuevos documentos canónicos de gobernanza en `.agent/`:

- `07_FIGURAS` (insertado en posición 07, requirió renumerar CONTROL y AUDITORIA a 08 y 09).
- Bloque D operativo: `10_RIESGOS`, `11_EQUIPO`, `12_REPRODUCIBILIDAD`, `13_PUBLICACION`, `14_CONFIDENCIALIDAD`, `15_SEGURIDAD`, `16_INCIDENTES`, `17_GIT_WORKFLOW`, `18_ONBOARDING`, `19_COMUNICACION`.

Una auditoría profunda del `00_MASTER_PROMPT.md` v0.3.1 (sesión 2026-05-23) detectó que el master **no había sido actualizado** para integrar estos 11 docs. Conteos:

| Doc | Menciones en master v0.3.1 |
|---|:-:|
| 07_FIGURAS | 0 |
| 09_AUDITORIA | 1 (solo como "doc a producir") |
| 10_RIESGOS, 11_EQUIPO, 12_REPRODUCIBILIDAD, 13_PUBLICACION, 14_CONFIDENCIALIDAD, 15_SEGURIDAD, 16_INCIDENTES, 17_GIT_WORKFLOW, 18_ONBOARDING, 19_COMUNICACION | 0 cada uno |

Adicionalmente, la auditoría detectó:

- **Contradicción de paleta visual**: master §4.3 fijaba 3 colores (`#14213D` + `#C2410C` + `#FAFAF9`); FIGURAS §6.1 propone 8 colores categóricos completamente distintos.
- **Naming de figuras divergente**: master §5.2 usa `fig01`–`fig40`; FIGURAS §8.1 propone `fig_<NN>_<MM>_<slug>`.
- **Modelo de amenazas duplicado** sin integrar con 10_RIESGOS (registro formal ISO 31000 de 20 riesgos).
- **Semáforo §9 incompleto** vs CONTROL §4 (lista canónica).
- **Formato de cierre §15 sin campos anti-IA** que ya existen en AGENTS.md y AUDITORIA.md.
- **Parte 16 con lista de "docs a producir" obsoleta** — la mayoría ya existen.

Consecuencia operativa: un LLM o miembro nuevo que leyera solo el master ignoraría 11 dimensiones de gobernanza vigentes, rompiendo el contrato de "single source de verdad".

---

## Decisión

Bump del MASTER_PROMPT a **v0.4.0** con 9 correcciones críticas que reintegran el bloque D y resuelven contradicciones detectadas.

### Cambios aplicados

1. **Header reorganizado** — sección "Documentos satélite" reescrita como tabla con 20 docs en 4 bloques (A identidad+datos, B reglas de output, C gate-keeping, D operativa extendida), cada uno con su versión y tema.

2. **Parte 1 — prompt raíz** — lista de "lectura obligatoria" expandida con apuntadores condicionales:
   - prosa → 05_ESTILO_NARRATIVO §3 y §3.24 (Standard 0 anti-IA)
   - figuras → 07_FIGURAS
   - cifras/metodología → 08_CONTROL + 09_AUDITORIA
   - Pre-flight anti-IA explicitado: AI-likelihood ≥ 4 EN o ≥ 3 ES dispara regeneración.

3. **§4.3 — Identidad visual híbrida** (resuelve contradicción con FIGURAS):
   - **Capa institucional** (3 colores WB: navy, terracota, paper) — para covers, headers, logos.
   - **Paleta de datos** — gobernada por [07_FIGURAS §6](../07_FIGURAS.md) — para contenido dentro de gráficos.
   - Tipografía explicitada por destino (book PDF Latin Modern, web/HTML/figuras Inter).
   - (Decisión adicional: este punto sustenta ADR-0007 sobre la paleta canónica.)

4. **§5.2 — Naming figuras coexistencia**:
   - Legacy `fig01`–`fig40`: no se renombran.
   - Nuevas (≥ 41): convención `fig_<NN>_<MM>_<slug>` con contrato JSON.
   - Migración opcional si se rehace la figura.

5. **§9 — Semáforo** apunta a [`08_CONTROL §4`](../08_CONTROL.md) como autoridad; lista local ampliada con banderas anti-IA, paleta y gobernanza canónica como casos ROJOS.

6. **§12 — Modelo de amenazas** convertido en pointer a [10_RIESGOS](../10_RIESGOS.md):
   - Resumen breve por clases (técnicas / editoriales / operacionales).
   - **Top-5 riesgos activos** visibles directamente en el master (R-001, R-003, R-002, R-006, R-018).
   - Tabla de mitigaciones por dominio con apuntadores.

7. **§15 — Formato de cierre de sesión** ampliado con bloque anti-IA:
   - AI-likelihood score promedio
   - Idioma de la prosa
   - Banderas anti-IA activadas y resueltas
   - `/quijote-writer` invocado sí/no
   - Firma A2 del revisor par
   - Bump de versión declarado
   - Apuntador a plantillas A3/A4/A5 de AUDITORIA cuando aplica.

8. **Parte 16 — Gobernanza agentic** reescrita en 5 subsecciones:
   - **16.1** Mapa canónico de los 20 docs (tabla con versión y "cuándo consultar").
   - **16.2** Estructura operativa de subcarpetas (`policies/`, `checklists/`, `prompts/`, etc.).
   - **16.3** **Conflict resolution hierarchy** explícita — 4 reglas + 11 prioridades.
   - **16.4** **Update protocol** del master mismo (ROJO + ADR + bump + verificación cross-refs + A3 retro).
   - **16.5** Estado de docs producidos (20 ✓; próximos artefactos pendientes).

9. **Parte 17 — Bitácora** ampliada con entradas v0.3.2 (creación FIGURAS + renumeración CONTROL/AUDITORIA), v0.3.3 (bloque D), y v0.4.0 (este ADR).

### Validación cuantitativa post-bump

Conteo de menciones de los 12 docs ausentes, tras v0.4.0:

| Doc | v0.3.1 | v0.4.0 |
|---|:-:|:-:|
| 07_FIGURAS | 0 | 12 |
| 09_AUDITORIA | 1 | 8 |
| 10_RIESGOS | 0 | 10 |
| 11_EQUIPO | 0 | 6 |
| 12_REPRODUCIBILIDAD | 0 | 6 |
| 13_PUBLICACION | 0 | 4 |
| 14_CONFIDENCIALIDAD | 0 | 6 |
| 15_SEGURIDAD | 0 | 8 |
| 16_INCIDENTES | 0 | 5 |
| 17_GIT_WORKFLOW | 0 | 4 |
| 18_ONBOARDING | 0 | 4 |
| 19_COMUNICACION | 0 | 5 |

---

## Alternativas consideradas

| Alternativa | Pros | Contras | Decisión |
|---|---|---|---|
| **Bump completo v0.4.0** (escogida) | resuelve gaps de un sopetón; master vuelve a ser autoridad real; ADR único | ~1h de edits; cambio extenso al master | **aceptada** |
| Bumps incrementales v0.3.2 → v0.3.5 | cada cambio aislado | dispersión; múltiples ADRs; lectores quedan confundidos sobre qué versión es canónica | rechazada |
| Solo ADR documentando el gap sin tocar master | menor riesgo de error | el gap persiste; el master sigue desactualizado | rechazada |
| Reescribir el master desde cero | máxima coherencia | pierde la historia editorial; pierde Parte 6 sustantiva ya escrita; alto costo | rechazada |

---

## Consecuencias

### Sobre el master

- Pasa de 932 a 1048 líneas (~12% más largo).
- Internamente coherente con los 20 docs satélite.
- Apunta autoridad por dominio en lugar de duplicar contenido.

### Sobre los docs satélite

- **07_FIGURAS** queda reconocido por el master como autoridad de paleta de datos y naming de figuras nuevas.
- **10_RIESGOS** queda reconocido como autoridad del risk register; el modelo de amenazas del master pasa a ser resumen, no fuente.
- **08_CONTROL §4** queda reconocido como autoridad del semáforo; el master conserva versión resumen.
- **09_AUDITORIA** queda reconocido como autoridad del sistema A1–A5; el master apunta a sus plantillas para handoff.

### Sobre el ecosistema

- Lector que entra solo por el master encuentra ahora apuntadores a las 20 dimensiones.
- Conflict resolution hierarchy explícita resuelve ambigüedades futuras antes de que escalen.
- Update protocol del master formalizado: futuras modificaciones siguen el mismo proceso (ROJO + ADR + bump + verificación).

### Sobre cifras publicadas

- **Cero impacto** — este ADR no toca cifras, ni hallazgos, ni metodología cuantitativa. Es gobernanza editorial pura.

---

## Implementación

- **Archivos modificados:** `00_MASTER_PROMPT.md` (8 secciones).
- **Archivos creados:** este ADR.
- **Tests añadidos:** verificación de menciones cruzadas (script informal en bash; a formalizar en `scripts/audit_governance_links.R`).
- **Bump:** master `v0.3.1 → v0.4.0`.
- **Plazo:** completado en sesión 2026-05-23.

---

## Validación

¿Cómo sabremos que la decisión fue correcta?

1. **Test inmediato (cumplido):** los 12 docs ausentes pasan de 0–1 menciones a 4–12 menciones cada uno.
2. **Test funcional próxima sesión:** un agente que recibe el master + RETOMAR.md y arranca a redactar debería llegar a 07_FIGURAS y al pre-flight anti-IA sin necesidad de consultar README.md.
3. **Test mensual:** revisión retrospectiva trimestral ([`09_AUDITORIA §12`](../09_AUDITORIA.md)) verifica que la conflict resolution hierarchy efectivamente resolvió disputas o si requiere ajustes.

---

## Referencias

- Documento auditado: `00_MASTER_PROMPT.md` v0.3.1 (snapshot pre-bump archivado en historia git).
- Sesión que originó el cambio: auditoría profunda 2026-05-23 (ver `00_admin/RETOMAR.md` cierre de sesión correspondiente).
- ADRs relacionados:
  - **ADR-0007** (próximo a formalizar) — Paleta visual híbrida APER 2026.
  - **ADR-0001** — Panel v12 canónico (referenciado en master §3.2, §5.1).
  - **ADR-0002** — 8 hallazgos como unidades versionadas (referenciado en master §5.4).
  - **ADR-0003** — Metodología PSE/CSE (referenciado en METODOLOGIA §4.4).

---

## Firma

Autor: Juan Carlos Muñoz Mora · 2026-05-23
Revisor TTL: _[TODO_TRACE: pendiente firma]_
Estado: aceptado (pendiente firma TTL para promoción a `MEFP_validated` equivalente en ADRs)
