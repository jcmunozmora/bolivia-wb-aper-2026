# `.agent/` — Gobernanza centralizada del APER Bolivia 2026

**Convención:** Anthropic-style governance folder (ver [`00_MASTER_PROMPT.md`](00_MASTER_PROMPT.md) Parte 16).
**Última actualización:** 2026-05-23
**Estructura:** archivos canónicos con prefijo numérico `0N_` / `1N_` que fijan el orden de lectura recomendado.

Esta carpeta contiene **toda la gobernanza editorial, metodológica y operativa** del APER 2026. Cualquier agente (humano o LLM) que opere sobre el repo debe leer al menos [`00_MASTER_PROMPT.md`](00_MASTER_PROMPT.md) antes de actuar.

---

## Mapa canónico de la carpeta (20 archivos en 4 bloques)

### Bloque A — Identidad y datos (orden 00–04)

| # | Archivo | Versión | Función |
|---|---|:-:|---|
| 00 | [`00_MASTER_PROMPT.md`](00_MASTER_PROMPT.md) | **v0.4.0** | **Fuente única.** Identidad, invariantes, arquitectura, plan sección × sección, contratos JSON, semáforo, mesa técnica, criterios de aceptación, mapa de los 20 docs, conflict resolution hierarchy. |
| 01 | [`01_METODOLOGIA.md`](01_METODOLOGIA.md) | m0.1.0 | Definiciones operativas (GAP, PSE, CSE, repurposing, brechas), fórmulas, supuestos, marcos de referencia adoptados. |
| 02 | [`02_INDICADORES.md`](02_INDICADORES.md) | v0.2.0 | Diccionario prosa-friendly del panel v12 (176 variables, 17 grupos, tipo, n_obs, %, fuente, unidad). |
| 03 | [`03_FUENTES.md`](03_FUENTES.md) | v0.2.0 | Inventario de fuentes crudas (30+ fuentes), licencias, fechas de descarga, paths, scripts de ingesta, gaps documentados. |
| 04 | [`04_HALLAZGOS.md`](04_HALLAZGOS.md) | v0.1.0 | Los 8 hallazgos centrales (F01–F08) con contrato JSON, evidencia trazable, ciclo de vida, notas de divergencia con MEFP. |

### Bloque B — Reglas de output (orden 05–07)

| # | Archivo | Versión | Función |
|---|---|:-:|---|
| 05 | [`05_ESTILO_NARRATIVO.md`](05_ESTILO_NARRATIVO.md) | v0.3.0 | **Cómo se arman los párrafos.** Anatomía TEEL + superestructura WB (BLUF + pirámide + signposting) + Standard 0 anti-prosa-IA (12 banderas + NEVER WRITE bilingüe + capa profunda ES con 11 subsecciones). |
| 06 | [`06_NEUTRALIDAD.md`](06_NEUTRALIDAD.md) | v0.1.0 | **Qué palabras se pueden usar y cuáles no.** Reglas de vocabulario. |
| 07 | [`07_FIGURAS.md`](07_FIGURAS.md) | v0.1.0 | **Cómo se construyen los gráficos.** Anatomía, decision tree, tipografía, paleta APER 2026, resolución, captions, alt-text, anti-IA gráfico. |

### Bloque C — Gate-keeping (orden 08–09)

| # | Archivo | Versión | Función |
|---|---|:-:|---|
| 08 | [`08_CONTROL.md`](08_CONTROL.md) | v0.1.0 | Semáforo de cambios verde/amarillo/rojo, zonas críticas, plantilla ADR, política de versionamiento, gates CI. |
| 09 | [`09_AUDITORIA.md`](09_AUDITORIA.md) | v0.1.0 | Sistema A1–A5 de verificación (pre-flight, sesión, capítulo, pre-handoff MEFP, release), log append-only, roles, protocolo de falla. |

### Bloque D — Gobernanza operativa extendida (orden 10–19) ✓ **nuevo en v0.3.0 de README**

| # | Archivo | Versión | Función |
|---|---|:-:|---|
| 10 | [`10_RIESGOS.md`](10_RIESGOS.md) | v0.1.0 | Risk register ISO 31000 adaptado, 8 categorías, 20 riesgos canónicos identificados, periodicidad, escalación. |
| 11 | [`11_EQUIPO.md`](11_EQUIPO.md) | v0.1.0 | Stakeholder map (3 círculos), org chart, RACI sobre 22 decisiones clave, authorship ICMJE adaptado, política COI. |
| 12 | [`12_REPRODUCIBILIDAD.md`](12_REPRODUCIBILIDAD.md) | v0.1.0 | Stack canónico, comando único de rebuild, snapshot policy, plan de larga duración 5+ años con Zenodo, Docker opcional. |
| 13 | [`13_PUBLICACION.md`](13_PUBLICACION.md) | v0.1.0 | 10 productos del release, cronograma T-16 → T+12, embargo MEFP, licencias CC-BY 4.0 + MIT, DOI dual (WB OKR + Zenodo), citación canónica, datos abiertos. |
| 14 | [`14_CONFIDENCIALIDAD.md`](14_CONFIDENCIALIDAD.md) | v0.1.0 | 3 niveles (PÚBLICO/INTERNO/RESTRINGIDO), matriz por artefacto, política manejo comentarios MEFP, PII, watermark de borradores. |
| 15 | [`15_SEGURIDAD.md`](15_SEGURIDAD.md) | v0.1.0 | Secrets, .env, .gitignore obligatorio, detección de filtración, backup verificado, control de accesos, disaster recovery. |
| 16 | [`16_INCIDENTES.md`](16_INCIDENTES.md) | v0.1.0 | 12 tipos de incidente, matriz P0–P3, protocolos detallados, errata formal vs silenciosa, post-mortem blameless. |
| 17 | [`17_GIT_WORKFLOW.md`](17_GIT_WORKFLOW.md) | v0.1.0 | Trunk-based simplificado (main + red/ + hotfix/ + exp/), conventional commits con 14 tipos APER, tags semver inmutables, releases. |
| 18 | [`18_ONBOARDING.md`](18_ONBOARDING.md) | v0.1.0 | Día 1, primera semana, checkpoint a 30 días, casos especiales (TTL nuevo, STC, revisor express), offboarding. |
| 19 | [`19_COMUNICACION.md`](19_COMUNICACION.md) | v0.1.0 | 10 canales canónicos, cadencia, voceros por audiencia, protocolo mesa técnica MEFP, Q&A canónico, crisis communication. |

### Bloque E — Control de contenido (orden 20–)

| # | Archivo | Versión | Función |
|---|---|:-:|---|
| 20 | [`20_CONTENIDO_REPORTE.md`](20_CONTENIDO_REPORTE.md) | v0.3.0 | **Plan operativo granular** del Quarto book: 7 capítulos + 8 apéndices, cada uno con outline detallado h3, hallazgos asignados, figuras/tablas, cifras, citas, cross-refs, TODO list, open questions, bitácora. Se actualiza cada sesión que toca un capítulo. Complementa MASTER §6 (alto nivel). |

### Bloque F — Coordinación inter-consultor (orden 21–)

| # | Archivo | Versión | Función |
|---|---|:-:|---|
| 21 | [`21_COORDINACION_STC.md`](21_COORDINACION_STC.md) | v0.1.0 | **Integración formal con consultor STC (Héctor Peña — OECD PSE/Repurposing).** Cross-walk de los dos ToR (Main JC + Secondary Hector). División operativa de contenido por capítulo. Outputs esperados de Hector (H1–H4) + lo que JC necesita de Hector. Cronograma integrado 7 semanas. Protocolo de integración de outputs + atribución. 5 riesgos específicos de coordinación (R-014 a R-018). |

---

## Subcarpetas operativas (creadas, a poblar)

```text
.agent/
  policies/      ← policy-as-code YAML (planeado para v1.0)
  checklists/    ← MD checklists derivados de los .md por niveles A1–A5
  prompts/       ← Prompts especializados (writer, reviewer, figure, pse, ...)
  protocols/     ← Protocolos de cambio operativos
  decisions/     ← ADRs activos
  schemas/       ← JSON schemas (finding, figure, scenario, mefp_comment)
  legacy/        ← Documentos superseded (no editar)
```

---

## Archivos legacy

| Archivo | Reemplazado por |
|---|---|
| [`legacy/Master_Prompt_APER2026_v0_1_0.md`](legacy/Master_Prompt_APER2026_v0_1_0.md) | `00_MASTER_PROMPT.md` v0.4.0+ |

---

## Orden de lectura recomendado al iniciar sesión

### Sesión típica (cualquier rol)

1. [`00_MASTER_PROMPT.md`](00_MASTER_PROMPT.md) — Partes 1–5.
2. [`../00_admin/RETOMAR.md`](../00_admin/RETOMAR.md) — estado actual.
3. Aplicar §3.4 anti-IA pre-flight si vas a redactar.

### Si vas a redactar prosa

4. [`05_ESTILO_NARRATIVO.md`](05_ESTILO_NARRATIVO.md) §3 y §3.24.
5. [`06_NEUTRALIDAD.md`](06_NEUTRALIDAD.md).

### Si vas a tocar figuras

4. [`07_FIGURAS.md`](07_FIGURAS.md).

### Si vas a cambiar cifras / metodología

4. [`08_CONTROL.md`](08_CONTROL.md) — clasificar.
5. [`01_METODOLOGIA.md`](01_METODOLOGIA.md) / [`02_INDICADORES.md`](02_INDICADORES.md) / [`03_FUENTES.md`](03_FUENTES.md) / [`04_HALLAZGOS.md`](04_HALLAZGOS.md).

### Antes de un release

4. [`09_AUDITORIA.md`](09_AUDITORIA.md) §7 (A5).
5. [`13_PUBLICACION.md`](13_PUBLICACION.md).
6. [`12_REPRODUCIBILIDAD.md`](12_REPRODUCIBILIDAD.md) §5.

### Si entrás nuevo al equipo

4. [`18_ONBOARDING.md`](18_ONBOARDING.md).

### Si hay incidente

4. [`16_INCIDENTES.md`](16_INCIDENTES.md).
5. [`10_RIESGOS.md`](10_RIESGOS.md) — verificar si materializó un riesgo registrado.

---

## Reglas de modificación rápidas

| Cambio | Color | Doc relevante |
|---|---|---|
| Typo o redacción sin cambiar claim | VERDE | [`08_CONTROL.md`](08_CONTROL.md) §4.1 |
| Nueva figura sobre panel existente | AMARILLO | [`08_CONTROL.md`](08_CONTROL.md) §4.2 + [`07_FIGURAS.md`](07_FIGURAS.md) §15 |
| Nueva variable del panel | ROJO | [`08_CONTROL.md`](08_CONTROL.md) §4.3 + [`02_INDICADORES.md`](02_INDICADORES.md) + ADR |
| Cambio de definición / metodología | ROJO | [`01_METODOLOGIA.md`](01_METODOLOGIA.md) + ADR + bump |
| Cambio de hallazgo | ROJO | [`04_HALLAZGOS.md`](04_HALLAZGOS.md) + ADR + bump del hallazgo |
| Cambio en banderas anti-IA o estilo TEEL | ROJO | [`05_ESTILO_NARRATIVO.md`](05_ESTILO_NARRATIVO.md) + ADR |
| Cambio en paleta de figuras | ROJO | [`07_FIGURAS.md`](07_FIGURAS.md) + ADR + regenerar figuras |
| Nuevo riesgo identificado | AMARILLO | [`10_RIESGOS.md`](10_RIESGOS.md) entrada nueva |
| Incidente P0/P1 detectado | seg. severidad | [`16_INCIDENTES.md`](16_INCIDENTES.md) §5 |
| Onboarding nuevo miembro | AMARILLO | [`18_ONBOARDING.md`](18_ONBOARDING.md) + [`11_EQUIPO.md`](11_EQUIPO.md) §7 |

---

## Documentos que NO viven aquí

| Documento | Path real | Razón |
|---|---|---|
| `README.md` (público) | raíz `/` | Convención GitHub |
| `CONTRIBUTING.md` | raíz `/` | Convención GitHub |
| `AGENTS.md` | raíz `/` | Convención Anthropic SDK / OpenAI Codex — thin pointer |
| `CLAUDE.md` | raíz `/` | Convención Claude Code — thin pointer |
| `RETOMAR.md` | `00_admin/` | Bitácora operativa de sesiones (estado) |
| `ESTADO_DE_DATOS.md` | `00_admin/` | Gaps de acceso a datos (estado operativo) |
| `SINERGIA_ToR_PSE_Repurposing.md` | `00_admin/` | Coordinación con consultor STC |
| `syncs/`, `mesas_tecnicas/`, `incidents/`, `coi/`, `handoff/`, `cartas/`, `comms/` | `00_admin/` | Operacional (minutas, registros) |
| Fichas de lectura | `03_literature/*/` | Material primario |
| Capítulos del reporte | `04_report/*.qmd` | Producto |
| Glosario MAFAP bilingüe | `04_report/appendix/glosario_mafap_es_en.md` | Apéndice del reporte |
| `.env` / credenciales | local, nunca commiteado | [`15_SEGURIDAD.md`](15_SEGURIDAD.md) |

---

## Convenciones de cross-reference

- **Dentro de `.agent/`:** usar nombre completo con prefijo numérico: `[texto](08_CONTROL.md)`.
- **Hacia raíz:** usar `[texto](../AGENTS.md)`.
- **Hacia subcarpetas del proyecto:** `[texto](../00_admin/RETOMAR.md)`.
- **Hacia capítulos del book:** `[texto](../04_report/05_spending_analysis.qmd)`.

Verificación automática (a implementar): `scripts/audit_governance_links.R` corre `grep` sobre `.agent/*.md` y reporta links rotos o referencias a archivos sin prefijo.

---

## Dimensiones de gobernanza — cobertura completa v0.4.0

✓ **20 dimensiones canónicas cubiertas:**

| # | Dimensión | Archivo |
|---|---|---|
| 1 | Identidad del proyecto y master prompt | 00_MASTER_PROMPT |
| 2 | Metodología analítica | 01_METODOLOGIA |
| 3 | Diccionario de variables | 02_INDICADORES |
| 4 | Inventario de fuentes y licencias | 03_FUENTES |
| 5 | Hallazgos versionados | 04_HALLAZGOS |
| 6 | Estilo de prosa policy + anti-IA | 05_ESTILO_NARRATIVO |
| 7 | Vocabulario controlado / neutralidad | 06_NEUTRALIDAD |
| 8 | Estándar de figuras y resolución | 07_FIGURAS |
| 9 | Semáforo de cambios + ADRs + versionamiento | 08_CONTROL |
| 10 | Sistema A1–A5 de auditoría | 09_AUDITORIA |
| 11 | Risk register (ISO 31000) | 10_RIESGOS |
| 12 | Stakeholder map + RACI + COI + authorship | 11_EQUIPO |
| 13 | Reproducibilidad técnica + larga duración | 12_REPRODUCIBILIDAD |
| 14 | Estrategia de publicación + licencias + DOI | 13_PUBLICACION |
| 15 | Clasificación y manejo de datos (3 niveles) | 14_CONFIDENCIALIDAD |
| 16 | Secrets, credenciales, backups, disaster recovery | 15_SEGURIDAD |
| 17 | Protocolo de incidentes y errata post-publicación | 16_INCIDENTES |
| 18 | Git workflow, branches, commits, tags, releases | 17_GIT_WORKFLOW |
| 19 | Onboarding y offboarding de personas | 18_ONBOARDING |
| 20 | Canales, cadencia, voceros, crisis comm | 19_COMUNICACION |

> Cobertura blindada para policy report WB-MEFP. Dimensiones futuras (e.g. ética de investigación si se incorporan datos primarios con sujetos humanos) se agregarían como `2N_ETICA.md` cuando aplique.

---

## Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Estructura inicial con archivos sin prefijo |
| v0.2.0 | 2026-05-23 | Reordenamiento canónico con prefijo `0N_` (10 archivos), inserción de 07_FIGURAS, renumeración de CONTROL (→08) y AUDITORIA (→09), resolución de duplicados (root → `.agent/`), expansión de 02_INDICADORES y 03_FUENTES con datos reales |
| v0.3.0 | 2026-05-23 | Bloque D — 10 dimensiones nuevas (10_RIESGOS, 11_EQUIPO, 12_REPRODUCIBILIDAD, 13_PUBLICACION, 14_CONFIDENCIALIDAD, 15_SEGURIDAD, 16_INCIDENTES, 17_GIT_WORKFLOW, 18_ONBOARDING, 19_COMUNICACION). 20 dimensiones canónicas cubiertas. Gobernanza blindada para release. |
| v0.4.0 | 2026-05-23 | Master bumpeado a v0.4.0 (integración bloque D + auditoría ADR-0008). README sincronizado: master citado como v0.4.0 (3 ocurrencias corregidas). + Bloque E (orden 20–): nuevo doc `20_CONTENIDO_REPORTE.md` v0.1.0 con plan operativo granular por capítulo del Quarto book (7 capítulos + 2 apéndices, ~745 líneas, outline detallado h3, hallazgos asignados, figuras/tablas, cifras, citas, cross-refs, TODO list, open questions, bitácora). |
