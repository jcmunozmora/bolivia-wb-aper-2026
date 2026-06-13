# Cómo retomar el proyecto — APER Bolivia 2026

**Última sesión:** 2026-06-13 (sesión 20 cerrada — 4 rondas de revisión profunda writer/manuscript-WB/policy/comité-WB; 106 ediciones seguras aplicadas a los 7 archivos del cuerpo; dossier maestro P0–P3 con 146 ítems)
**Estado global:** ✅ Datos consolidados · ✅ Sitio público live · ✅ Gobernanza centralizada · ✅ MAFAP ejecutado · ✅ Corpus literatura integrado · ✅ Reporte v0.1 escrito (Caps 1–6 + RE) · ✅ Bib sincronizado (373 únicas) · ✅ Apéndices D–H · ✅ **HALLAZGOS.md v0.2.0** · ✅ **6 caps auditados (verdicts P0–P3)** · ✅ **Caps 1–6 + RE pasados por 4 lentes (sesión 20): prosa/neutralidad/anti-IA saneadas** · 🔴 13 P0 abiertos (datasets fantasma, cifras huérfanas, drift F01–F08, citas a auditar) · 🔴 Caps no promovibles a `reviewed` aún · 🟡 Render local pendiente

---

## Sesión 20 (2026-06-13) — Cuatro rondas de revisión profunda (writer · manuscript-WB · policy · comité-WB)

**Resumen del cambio:** se corrieron 4 lentes de revisión sobre los 7 archivos del cuerpo (Caps 1–6 + RE) vía workflow de 42 agentes (run `wf_14c8ca40-aa5`): L1 `/quijote-writer` (prosa+anti-IA), L2 `/quijote-manuscript` adaptado a reporte WB (vía `aper-auditor`), L3 `/policy-expert` (repurposing+neutralidad), L4 `/quijote-wb` (comité senior: director/editor/economista/político/género/narrativa/ministro). Pipeline: revisión→síntesis→edición segura por capítulo. Se aplicaron **106 ediciones seguras** (prosa, neutralidad, anti-IA, errata, framing no-prescriptivo); **11 ediciones rehusadas** por riesgo de tocar cifras; **146 ítems** de dossier priorizado.
**Tipo de cambio:** 🟡 AMARILLO (refinamiento masivo de prosa/neutralidad/anti-IA sin cambio de claim ni metodología) — **con 1 excepción a revisar** (ver abajo, índice L13).
**Archivos modificados:** los 7 del cuerpo (`index.qmd`, `01`–`06`); nuevo `00_admin/REVISION_4_RONDAS_2026-06-13.md` (dossier maestro, 134 KB).
**Cifras tocadas (con trazabilidad):** ninguna nueva por diseño. **Excepción a validar:** en `index.qmd` L13 el editor sustituyó "<30 millones" por "del orden de USD 35 millones" (valor panel v12 1990=35,0). Si el revisor humano prefiere no anclar a 35, revertir ese único item.
**Hallazgos afectados:** ninguno modificado en contrato; el dossier documenta drift de F01 (ventana/unidades), F03 (filtro NRP años/NA), F05 (RDS BCB vs panel), F06 (fuente FIES FAOSTAT vs EH-INE; ancla temporal), F07 (16% sin traza a ISR), F08 (base 1985 vs panel 1990) para resolución humana.
**Capítulos del book afectados:** los 7 (prosa/neutralidad/anti-IA). Veredictos de síntesis: RE BLOCK, Cap1 BLOCK, Cap2 BLOCK, Cap3 CONDITIONAL, Cap4 CONDITIONAL, Cap5 CONDITIONAL, Cap6 CONDITIONAL.
**AI-likelihood promedio:** bajó de ~4–5/10 a 3–5/10 post-edición (RE de 5 a ~25-30%; Cap2 a 3/10). Persisten señales en Caps 5/6 (P2).
**/quijote-writer invocado:** sí (lente L1, integrada al barrido).
**ADR requerido:** no para las ediciones de prosa; **sí** si se resuelven los P0 que cambian cifras/fuentes (F03 filtro, F06 fuente FIES, MAFAP E factor-1000).

### Qué se hizo

1. Workflow de 4 lentes × 7 capítulos → síntesis priorizada → edición segura (un `aper-writer` por archivo, sin colisión).
2. Se aplicaron 106 ediciones seguras: eliminación de muletillas IA (familia "integrar/integral", "robusto/clave"), ruptura de listicles y TEEL visible, em-dash estructurales, neutralización de lenguaje prescriptivo, errata de versión (HALLAZGOS v0.1.0→v0.2.0), tipografía decimal, frase de cierre de neutralidad (§11) en el RE.
3. Se consolidó el dossier maestro `00_admin/REVISION_4_RONDAS_2026-06-13.md` con 13 P0, 53 P1, 54 P2, 26 P3 + las 11 ediciones rehusadas.

### Riesgos pendientes (lo que el dossier prioriza)

- **13 P0**: datasets fantasma (`eh_nacional_anual.rds`, `pse_gsse_bolivia.rds`), callout RE que afirma trazabilidad universal a panel v12 (falsa para F06/F07/F08-base-1985), F03 NRP sin filtro documentado, fuente FIES sin decidir, MAFAP E factor-1000 script↔prosa, citas O9 Mandanas respaldada por fichas SSA/Malawi, Cap5 caña 2015 sin TODO_TRACE.
- Cap 5 (DEA/panel FE) y Cap 6 (composición repurposing) siguen bloqueados por outputs Hector/STC.
- Deliverable D4: falta versión EN del RE.
- Render Quarto local pendiente (R-019).

**Siguientes pasos:**
1. Revisar `00_admin/REVISION_4_RONDAS_2026-06-13.md` §1 (P0) y decidir capítulo por capítulo.
2. Validar/decidir la excepción `index.qmd` L13 (USD 35 M).
3. Resolver datasets fantasma y fuente FIES antes de re-auditar (A3).
4. Render local del book con las ediciones aplicadas.

---

## Sesión 18 (2026-05-26) — Apéndices D–H y limpieza de referencias del reporte técnico `04_report/`

**Resumen del cambio:** se incorporaron los apéndices D–H al book, se actualizó `_quarto.yml` para incluirlos en la estructura de salida y se limpiaron referencias rotas y residuos de borrador en capítulos 1, 3 y 6.
**Tipo de cambio:** 🟡 AMARILLO (nueva estructura documental y refinamiento de texto; no cambia metodología ni cifras publicadas).
**Archivos modificados:** `04_report/_quarto.yml`; `04_report/appendix/D_crosswalk_clasificaciones.qmd`; `04_report/appendix/E_regresiones_panel_fe.qmd`; `04_report/appendix/F_dea_simar_wilson.qmd`; `04_report/appendix/G_programas_bm.qmd`; `04_report/appendix/H_adrs_metodologicos.qmd`; `04_report/01_introduction.qmd`; `04_report/03_budget_institutions.qmd`; `04_report/04_spending_organization.qmd`; `04_report/06_recommendations.qmd`.
**Cifras tocadas (con trazabilidad):** ninguna nueva; solo se documentaron artefactos ya existentes y se verificaron códigos de proyectos BM contra fuentes oficiales.
**Hallazgos afectados:** ninguno; la edición reduce ruido de auditoría y completa la estructura del book.
**Capítulos del book afectados:** `01_introduction.qmd`, `03_budget_institutions.qmd`, `04_spending_organization.qmd`, `06_recommendations.qmd`, más apéndices D–H.
**Slides / web actualizadas:** ninguna.
**Tests ejecutados:**
- `rg -n "\\[\\]|roadmap|H2\\.3|H3\\.6\\.1|H3\\.2\\.9|Inventario_Datos_APER_Bolivia_2026\\.xlsx|sustancialmente" 04_report/*.qmd 04_report/appendix/*.qmd`
- `rg -n "P127743|P107137|P083051" 04_report/appendix/G_programas_bm.qmd`
- Lectura de `crosswalk_mafap_oecd_cofog.csv`, `extended_regression_results.rds` y `dea_dataset.rds` para sostener los apéndices nuevos.
- Verificación externa en fuentes oficiales del Banco Mundial para los códigos de PAR I, PAR II y PICAR.
**Tests no ejecutados:** `quarto render 04_report/` sigue bloqueado porque `quarto` no está en `PATH` en este entorno.
**Impacto en panel:** ninguno; `panel_version` sigue v12.
**Impacto en metodología:** ninguno; los apéndices documentan y exponen artefactos existentes.
**Impacto en hallazgos:** ninguno.
**Impacto en MEFP handoff:** mejora la navegabilidad del reporte y resuelve referencias rotas de apéndices, pero el render local sigue pendiente.
**Pre-flight anti-IA (A1):** revisado sobre las nuevas secciones; no aparecieron restos nuevos de TEEL visible ni de prosa mecanizada.
**AI-likelihood score promedio:** no reevaluado formalmente en esta sesión.
**/quijote-writer invocado:** no.
**Banderas anti-IA activadas y resueltas:** se limpiaron residuos de borrador en `01_introduction`, `03_budget_institutions` y `06_recommendations`; además se resolvieron referencias rotas a apéndices.
**A2 firmada por:** pendiente revisor par — 2026-05-26.

### Qué se hizo

1. Se añadieron los apéndices D, E, F, G y H al book y al `_quarto.yml`.
2. Se documentó el crosswalk de clasificaciones con el CSV maestro ya existente.
3. Se expusieron las regresiones guardadas y el proxy de eficiencia mientras la frontera DEA final sigue pendiente.
4. Se limpió texto roto de capítulos existentes y se corrigieron referencias rotas a apéndices.
5. Se verificaron códigos de programas BM con fuentes oficiales para el inventario selectivo del apéndice G.

### Riesgos pendientes

- `quarto` sigue sin estar disponible en el `PATH` del entorno actual, así que el render local no se pudo ejecutar.
- La frontera DEA final y la re-corrida del capítulo 5 siguen pendientes de cierre metodológico.
- Persisten `TODO_TRACE` cuantitativos en el cuerpo del reporte, aunque la estructura documental ya quedó completa.

**ADR requerido:** no para esta sesión; sí si se cambia la especificación DEA o cualquier definición cuantitativa.
**Siguientes pasos:**
1. Reintentar `quarto render` cuando el binario esté disponible.
2. Cerrar la orientación DEA y re-correr el cálculo definitivo.
3. Seguir limpiando `TODO_TRACE` cuantitativos del cuerpo del reporte.

---

## Sesión 17 (2026-05-26) — Auditoría multi-gobernanza del reporte técnico `04_report/`

**Resumen del cambio:** se corrió una auditoría read-only del book técnico bajo los gates de `.agent`, `.codex` y el verificador de escritura Claude para `04_report/*.qmd`.
**Tipo de cambio:** 🟡 AMARILLO (auditoría y bitácora; no cambia metodología, cifras publicadas ni outputs analíticos).
**Archivos modificados:** `00_admin/RETOMAR.md`.
**Cifras tocadas (con trazabilidad):** ninguna.
**Hallazgos afectados:** ninguno; la auditoría confirma deuda abierta y drift contra F01–F08, pero no modifica los contratos vigentes.
**Capítulos del book auditados:** `index.qmd`, `01_introduction.qmd`, `02_sector_performance.qmd`, `03_budget_institutions.qmd`, `04_spending_organization.qmd`, `05_spending_analysis.qmd`, `06_recommendations.qmd`, `appendix/A_data_sources.qmd`, `appendix/B_methodology.qmd`, `appendix/C_glosario_mafap.qmd`.
**Slides / web actualizadas:** ninguna.
**Tests ejecutados:**
- Auditoría paralela con 3 subagentes especializados: prosa/neutralidad/estructura, trazabilidad/citas, y reproducibilidad/render.
- `rg -n "TODO_TRACE|CITA NECESARIA|TODO_FIGURE|TODO_TABLE|\\[TODO|placeholder|pendiente" 04_report/*.qmd 04_report/appendix/*.qmd`
- `rg -n "Cabe mencionar|Cabe destacar|integral|robusto|clave|sustancialmente|Roadmap|debe|debería" 04_report/*.qmd 04_report/appendix/*.qmd`
- `/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript --no-init-file -e ...` para citas, fichas y estado `green/yellow/red`.
- `quarto --version` → `command not found` en este entorno.
- `sed`, `tail` y `rg` sobre `00_admin/RETOMAR.md`, `.agent/00_MASTER_PROMPT.md` y `.agent/09_AUDITORIA.md` para respetar el formato de cierre.
- `git status --short` para confirmar que no se tocaron archivos del book.
**Tests no ejecutados:** `quarto render 04_report/` no se pudo correr porque `quarto` no está en `PATH` del entorno actual.
**Impacto en panel:** ninguno; `panel_version` sigue v12.
**Impacto en metodología:** ninguno.
**Impacto en hallazgos:** ninguno.
**Impacto en MEFP handoff:** bloquea pre-review hasta cerrar deuda cuantitativa (`TODO_TRACE`), reconciliar drift de F02/F07/F08, normalizar citekeys alias y resolver reproducibilidad de render.
**Pre-flight anti-IA (A1):** corrido sobre el material auditado; la prosa de Cap. 5 sigue con score alto y señales de plantilla.
**AI-likelihood score promedio:** FAIL; el verificador externo reportó 6/10 en el capítulo 5 y ~3/10 sin el capítulo 5.
**/quijote-writer invocado:** no.
**Banderas anti-IA activadas y resueltas:** no resueltas en esta sesión; se registran TEEL visible, roadmap prose, listicle creep y prescriptivo residual como deuda de edición.
**A2 firmada por:** pendiente revisor par — 2026-05-26.

### Qué se hizo

1. Se corrió una auditoría read-only del book técnico con cobertura de prosa, trazabilidad, citas y reproducibilidad.
2. Se consolidaron los hallazgos de los subagentes y de los checks mecánicos locales.
3. Se confirmó que `04_report/` sigue bloqueado para pre-review por deuda cuantitativa y estructura, no por una caída del panel canónico.
4. Se dejó el resultado registrado en esta bitácora sin modificar el contenido sustantivo del reporte.

### Riesgos pendientes

- `TODO_TRACE` todavía concentra deuda abierta en `04_spending_organization.qmd`, `05_spending_analysis.qmd`, `06_recommendations.qmd` y partes del resumen ejecutivo.
- Hay drift entre el contrato de hallazgos `F01–F08` y el uso actual de esos identificadores en el texto.
- `quarto` no está disponible en el `PATH` del entorno actual, así que el gate de render local sigue bloqueado.
- Persisten referencias a apéndices que no están todos incluidos en `_quarto.yml`, más citas alias que no están normalizadas en las listas finales.

**ADR requerido:** no para esta auditoría; sí si se decide corregir metodología, hallazgos o estructura canónica.
**Siguientes pasos:**
1. Cerrar o reconciliar la deuda `TODO_TRACE` por capítulo.
2. Normalizar `F02`, `F07` y el resto del contrato de hallazgos antes de cualquier pre-review.
3. Resolver el entorno de render Quarto y repetir la verificación local.

---

## Sesión 16 (2026-05-25) — Agente Codex verificador de escritura Claude

**Resumen del cambio:** se agregó un agente read-only para verificar prosa escrita por Claude u otros LLM en el reporte técnico, con foco en `04_report/*.qmd` y alias documentado `05_report` → `04_report` cuando `05_report/` no existe.
**Tipo de cambio:** 🟡 AMARILLO (nueva capacidad operativa de auditoría; no cambia metodología, cifras, hallazgos ni outputs analíticos).
**Archivos modificados:** `.codex/agents/claude-writing-verifier.md`; `.codex/commands/verify-claude-writing.md`; `.codex/README.md`; `.codex/skills/aper-audit/SKILL.md`; `00_admin/RETOMAR.md`.
**Cifras tocadas (con trazabilidad):** ninguna.
**Hallazgos afectados:** ninguno.
**Capítulos del book afectados:** ninguno.
**Slides / web actualizadas:** ninguna.
**Tests ejecutados:**
- `find .codex -type f | sort` → confirma nueva estructura con `agents/` y `commands/`.
- `rg -n "claude-writing-verifier|05_report|04_report|AI-pattern|Verdict|TODO_TRACE|audit_status" .codex` → confirma referencias, alias y gates del agente.
- `git status --short .codex 00_admin/RETOMAR.md AGENTS.md` → confirma cambios propios sin tocar el book.
**Tests no ejecutados:** ejecución real del agente sobre capítulo; queda como siguiente paso para una auditoría específica.
**Impacto en panel:** ninguno; `panel_version` sigue v12.
**Impacto en metodología:** ninguno.
**Impacto en hallazgos:** ninguno.
**Impacto en MEFP handoff:** mejora el control previo de capítulos antes de revisión BM/MEFP; no cambia contenido entregable.
**Pre-flight anti-IA (A1):** no aplica; no se redactó prosa publicable del reporte.
**AI-likelihood score promedio:** no aplica.
**/quijote-writer invocado:** no.
**Banderas anti-IA activadas y resueltas:** no aplica.
**A2 firmada por:** pendiente revisor par — 2026-05-25.

### Qué se hizo

1. Se creó `.codex/agents/claude-writing-verifier.md`, agente read-only con verificación de:
   - huella Claude/LLM y Standard 0 anti-IA;
   - neutralidad técnica;
   - trazabilidad cuantitativa;
   - consistencia con F01–F08;
   - gate de citas `green/yellow`;
   - estructura BLUF/TEEL y placeholders.
2. Se creó `.codex/commands/verify-claude-writing.md` como patrón operativo de invocación (`<NN | path | all>`).
3. Se documentó el alias `05_report` → `04_report` si `05_report/` no existe.
4. Se actualizó `.codex/README.md` y `.codex/skills/aper-audit/SKILL.md` para que auditorías de escritura Claude usen el verificador estricto.

### Riesgos pendientes

- El agente vive como especificación runtime en `.codex/`; su auto-descubrimiento depende del cliente Codex. Si no se autodescubre, se invoca leyendo explícitamente `.codex/agents/claude-writing-verifier.md`.
- Aún no se corrió una auditoría real sobre `04_report/05_spending_analysis.qmd` o todo el book.
- Siguen abiertos los riesgos previos: R-019 render Quarto local; ventana canónica desalineada; DEA/panel FE pendiente de cierre metodológico.

**ADR requerido:** no.
**Siguientes pasos:**
1. Ejecutar el verificador sobre `04_report/05_spending_analysis.qmd` como prueba piloto.
2. Si el patrón funciona, correrlo sobre `04_report/*.qmd` antes de cualquier pre-review BM.
3. Convertir los comandos mínimos del verificador en script/CI si se requiere enforcement automático.

---

## Sesión 15 (2026-05-25) — Configuración `.codex/` para Codex

**Resumen del cambio:** se creó una capa runtime de Codex que traduce la gobernanza canónica de `.agent/` a instrucciones, skills locales y checklists accionables para futuras sesiones Codex.
**Tipo de cambio:** 🟡 AMARILLO (nueva configuración operativa de agente; no cambia metodología, cifras, hallazgos ni outputs analíticos).
**Archivos modificados:** `AGENTS.md`; `.codex/README.md`; `.codex/instructions.md`; `.codex/checklists/preflight.md`; `.codex/checklists/trace-and-citations.md`; `.codex/checklists/session-close.md`; `.codex/skills/aper-governance/SKILL.md`; `.codex/skills/aper-writing/SKILL.md`; `.codex/skills/aper-audit/SKILL.md`; `00_admin/RETOMAR.md`.
**Cifras tocadas (con trazabilidad):** ninguna.
**Hallazgos afectados:** ninguno.
**Capítulos del book afectados:** ninguno.
**Slides / web actualizadas:** ninguna.
**Tests ejecutados:**
- `find .codex -type f | sort` → estructura esperada creada.
- `rg -n "\.agent/|\.codex/|00_admin/|AGENTS.md|SKILL.md|TODO_TRACE|spending_panel_v12" .codex AGENTS.md` → referencias principales presentes y consistentes.
- `git diff -- AGENTS.md ...` → verificación de cambio mínimo en `AGENTS.md`.
**Tests no ejecutados:** `quarto render` (no aplica; no se tocaron archivos Quarto ni outputs publicables).
**Impacto en panel:** ninguno; `panel_version` sigue v12.
**Impacto en metodología:** ninguno.
**Impacto en hallazgos:** ninguno.
**Impacto en MEFP handoff:** ninguno directo; mejora la gobernanza operativa de futuras sesiones Codex.
**Pre-flight anti-IA (A1):** no aplica; no se redactó prosa publicable del reporte.
**AI-likelihood score promedio:** no aplica.
**/quijote-writer invocado:** no.
**Banderas anti-IA activadas y resueltas:** no aplica.
**A2 firmada por:** pendiente revisor par — 2026-05-25.

### Qué se hizo

1. Se creó `.codex/README.md` como mapa de la configuración runtime de Codex y relación jerárquica con `.agent/`.
2. Se creó `.codex/instructions.md` como entrada principal para Codex: lectura obligatoria, invariantes, protocolo de trabajo, política de cambios, reglas por tipo de tarea y cierre.
3. Se crearon tres checklists:
   - `preflight.md` para contexto mínimo, estado git, clasificación CONTROL y reproducibilidad.
   - `trace-and-citations.md` para trazabilidad cuantitativa y gate de literatura.
   - `session-close.md` con template operativo para `RETOMAR.md`.
4. Se crearon tres skills locales de Codex:
   - `aper-governance` para gobernanza general, código, datos, modelos, figuras y estado.
   - `aper-writing` para prosa WB, TEEL, neutralidad, trazabilidad y filtro anti-IA.
   - `aper-audit` para auditoría de capítulos, cifras, citas, hallazgos y reproducibilidad.
5. Se agregó en `AGENTS.md` un puntero mínimo a `.codex/instructions.md`, dejando claro que `.agent/` sigue siendo la fuente única.

### Riesgos pendientes

- Codex no ejecuta automáticamente los hooks de `.claude/`; los controles quedaron como skills/checklists manuales. Si se requiere bloqueo automático multi-agente, debe implementarse en scripts o CI.
- La detección automática de skills locales dependerá de cómo Codex cargue carpetas `.codex/skills/` en futuras sesiones; por eso `AGENTS.md` apunta explícitamente a `.codex/instructions.md`.
- Siguen abiertos los riesgos previos: R-019 render Quarto local; ventana canónica desalineada; DEA/panel FE pendiente de cierre metodológico.

**ADR requerido:** no.
**Siguientes pasos:**
1. Probar en una nueva sesión Codex si `.codex/skills/*/SKILL.md` se autodescubre; si no, mantener uso vía puntero explícito desde `AGENTS.md`.
2. Si se requiere enforcement automático, migrar checklists críticos a scripts CI reutilizables por todos los agentes.
3. Mantener `.codex/` como adaptador delgado: cualquier cambio sustantivo debe originarse en `.agent/`, no en `.codex/`.

---

## Sesión 14 (2026-05-25) — Revisión técnica del modelo DEA + panel FE

**Resumen del cambio:** revisión/adversarial check del bloque de modelo sin editar scripts, datos ni cifras publicadas.
**Tipo de cambio:** 🟢 VERDE (bitácora + auditoría; no cambia outputs analíticos).
**Archivos modificados:** `00_admin/RETOMAR.md` únicamente.
**Cifras tocadas (con trazabilidad):** ninguna.
**Hallazgos afectados:** ninguno modificado; F02/F03 siguen vigentes, DEA/panel FE permanecen como evidencia pendiente en Cap. 5.
**Capítulos del book afectados:** ninguno modificado; revisión se concentró en `04_report/05_spending_analysis.qmd`.
**Slides / web actualizadas:** ninguna.
**Tests ejecutados:**
- `/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript --no-init-file 02_code/03_analysis/08_extended_regressions.R` → corre estimaciones, pero falla al guardar por ruta absoluta fuera del workspace (`Operation not permitted`).
- `/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript --no-init-file 02_code/03_analysis/03_dea_efficiency.R` → falla al cargar `Benchmarking` (paquete no instalado).
- Check de paquetes: `Benchmarking`, `rDEA`, `deaR`, `censReg` no disponibles; `fixest`, `data.table`, `here` disponibles.
- Inspección de `extended_regression_results.rds`, `first_regression_results.rds`, `dea_dataset.rds` y completitud DEA.
**Tests no ejecutados:** `quarto render`; `renv::restore()`; bootstrap DEA Simar-Wilson.
**Impacto en panel:** ninguno; `panel_version` sigue v12.
**Impacto en metodología:** ninguno aplicado. La revisión identifica que cualquier corrección de especificación DEA/panel FE probablemente sería ROJO si cambia orientación, inputs/outputs, ventana o fórmula.
**Impacto en hallazgos:** ninguno.
**Impacto en MEFP handoff:** Cap. 5 no debería promoverse a pre-review MEFP con DEA/panel FE como resultados cerrados; deben mantenerse como `[TODO_TRACE]` hasta re-corrida reproducible.
**Pre-flight anti-IA (A1):** no aplica a prosa del reporte; solo bitácora operativa.
**AI-likelihood score promedio:** no aplica.
**/quijote-writer invocado:** no.
**Banderas anti-IA activadas y resueltas:** no aplica.
**A2 firmada por:** pendiente revisor par — 2026-05-25.

### Hallazgos de revisión del modelo

1. **Bloqueador reproducibilidad:** `08_extended_regressions.R` y `11_build_dea_dataset.R` usan rutas absolutas a OneDrive, no `here()`/constantes del repo.
2. **Bloqueador DEA:** `03_dea_efficiency.R` no corre en el entorno actual por paquetes ausentes (`Benchmarking`, `rDEA`, `deaR`, `censReg`) y esos paquetes no están en `renv.lock`.
3. **Bloqueador especificación DEA:** el script DEA selecciona columnas placeholder (`agr_spending|credito|irrigated`, `agr_gdp|cereal_yield|food_security`) que no existen en `subnacional_panel.rds`; el dataset real DEA-ready está en `dea_dataset.rds`.
4. **Brecha modelo vs capítulo:** `08_extended_regressions.R` no implementa todavía la especificación declarada en Cap. 5 (FIES, gasto per cápita rural, Ley 393, COVID, clustering por departamento, ventana 2008–2024, robusteces).
5. **DEA no Simar-Wilson completo:** el script intenta bootstrap solo para el último año, no para los 81 pares departamento-año descritos en el capítulo.

**Riesgos pendientes:** R-019 render Quarto local; issue estructural de ventana canónica (`YEAR_START=2000`, `YEAR_END=2023`) sigue abierto; DEA/panel FE bloquean cierre de Cap. 5.
**ADR requerido:** no para esta revisión; sí si se cambia la orientación DEA, inputs/outputs, ventana canónica o especificación econométrica.
**Siguientes pasos:**
1. Portar scripts de modelo a rutas relativas (`here::here()` + `DIR_*`) y escribir outputs en el repo.
2. Decidir por ADR la especificación DEA final: orientación, RTS, inputs/outputs, manejo de PIB faltante y cobertura 2012–2020.
3. Instalar y congelar dependencias DEA en `renv.lock` o cambiar a una implementación reproducible con paquetes ya disponibles.
4. Reescribir `08_extended_regressions.R` para que coincida con §5.4 o degradar la prosa del Cap. 5 a “exploratorio/proxy”.
5. Re-correr modelos y actualizar tablas/figuras solo después de resolver trazabilidad.

---

## Sesión 19 (2026-06-02) — Auditoría adversarial complementaria + ADR-0011 + HALLAZGOS.md v0.2.0

> **Contexto temporal**: esta sesión entró al repo tras el cierre de sesión 18 (2026-05-26). Trabajo parcialmente complementario a sesión 17 (auditoría multi-gobernanza) — extiende esa auditoría con verdicts P0/P1/P2/P3 explícitos por capítulo y resuelve la deuda estructural sobre `04_HALLAZGOS.md` (canonización de F01–F08).

**Tipo de cambio:** 🔴 ROJO (ADR-0011 reasigna numeración finding_ids; HALLAZGOS.md v0.1.0 → v0.2.0; toca gobernanza canónica).
**Archivos modificados:** ~10 (HALLAZGOS.md, ADR-0011 nuevo, legacy/HALLAZGOS_v0_1_0.md nuevo, references.bib limpio, 01_constants.R, Cap 1, Cap 6, RETOMAR.md).
**ADR requerido:** sí — **ADR-0011** (Reasignación finding_ids a numeración canónica) creado y aceptado.

### Qué se hizo

1. **Limpieza bib**: 10 duplicados eliminados de `04_report/references.bib`; pasó de 4 013 a 3 927 líneas, de 383 a **373 entries únicas**. Cero huérfanos.
2. **Constants canonizadas**: `02_code/00_setup/01_constants.R` actualizado a `YEAR_START=2008, YEAR_END=2024` (ventana canónica MASTER v0.4.0); preservado `YEAR_LEGACY_*=2000–2023` para scripts no migrados.
3. **ADR-0011 creado** en `.agent/decisions/`: documenta que la numeración canónica (RE + caps + plan + RETOMAR §6 + slides) es la única válida; reasigna F01–F08.
4. **HALLAZGOS.md v0.1.0 → v0.2.0**: 8 contratos YAML completos con cifras canónicas verificadas, magnitudes estructuradas, evidence trazable, uncertainty, policy_implication neutral. Esqueleto v0.1.0 archivado en `.agent/legacy/04_HALLAZGOS_v0_1_0.md`.
5. **6 auditorías adversariales completas** (1 secuencial + 5 paralelas) sobre Caps 1–6 con gates A1–A6 + G1–G7 + §13B. Resultado consolidado:

   | Cap | Verdict | Issues clave |
   |:-:|---|---|
   | 1 | CONDITIONAL_PROMOTE | dataset fantasma `pse_gsse_bolivia.rds`; `@WorldBank2021_SCDUpdate` conflicto green/red; F06 periodicidad FIES; "bolivariana"→"boliviana" |
   | 2 | BLOCK_PROMOTION | `eh_nacional_anual.rds` no existe → render falla; `@IBCE2024` huérfano; `@FuglieRada2013` mis-attribution; F01 ventana 2000–2015 vs canónica 1990–2015; pobreza extrema no contratada |
   | 3 | BLOCK_PROMOTION | 2 `TODO_TRACE` en prosa (`revenue_foregone_bdp`); fig02 reusada como organigrama; cifras huérfanas (BDP 68%, INIAF Bs 98M, SENASAG Bs 108M); tipografía decimal punto vs coma |
   | 4 | FAIL/BLOCK | 33 TODO_TRACE; F07 16% sin trazabilidad reproducible; Filipinas 85–92% sin ficha; Mandanas +37,9% huérfano; "reporte interno MDRyT 74%/54%"; 4 scripts no existen |
   | 5 | BLOCK (esperado) | fig16/fig17 caption-filename mismatch (sospecha placeholders); cifras DEA + regresiones FE + outputs Hector pendientes (todos los TODO_TRACE son legítimos) |
   | 6 | PASS con caveats P1 | F01 ventana errada (1990–2024 vs 1990–2015); F01 TFP "estancada" vs +30%; F02 año ancla 2018 faltante; F06 año inicial pobreza 2008 vs 2012; `@Searchinger2019_WRI` y `@Laborde2021_GHG` no auditadas |

6. **Pase 1 de remediación editorial** aplicado: errata "bolivariana"→"boliviana" en Cap 1 L65; F01/F02/F06 corregidas en Cap 6 (Mensaje 1, Mensaje 3, Opción O1). Tipografía decimal: punto→coma en Cap 6.

### Patrones sistémicos detectados (12 issues recurrentes a remediar en sesión 15)

1. **Datasets fantasma** (Cap 1, Cap 2): RDS citados que no existen en disco. Mapear a los reales (`idb_pse_bolivia_aggregate.rds`, etc.).
2. **Citas no auditadas o conflicto green/red** (Caps 1, 2, 4, 6): `SCDUpdate`, `IBCE2024`, `FuglieRada2013`, `Searchinger2019_WRI`, `Laborde2021_GHG`, Filipinas. Decisión: auditar o sustituir.
3. **Cifras huérfanas sin trazabilidad** (Caps 3, 4): BDP 68%, INIAF Bs 98M, SENASAG Bs 108M, Mandanas +37,9%, MDRyT 74%/54% "reporte interno".
4. **Scripts canónicos no existen** (Cap 4: 4; F01/F05/F06/F07/F08 contratos): crear stubs o eliminar referencias.
5. **TODO_TRACE en prosa visible** (todos los caps): reescribir defensivamente o cerrar con datos.
6. **Alt-text bilingüe ausente en figuras** (Caps 2: 0/14, 4, 5: 0/7): agregar `fig-alt=` ES + EN.
7. **fig02 reusada como organigrama** (Cap 3): construir org chart real o re-etiquetar.
8. **fig16/fig17 sospecha de placeholder** (Cap 5): verificar contenido PNG vs caption.
9. **Tipografía decimal inconsistente** (Cap 3: punto; HALLAZGOS: coma): normalizar a coma en bloques ES.
10. **F01/F06 ventanas desalineadas** texto↔contrato (Caps 2, 6): unificar.
11. **F06 periodicidad puntual vs trianual FIES** (Caps 1, 2): reformular según contrato.
12. **F-promoción**: para que un cap pueda promover a `reviewed`, sus findings deben estar en `reviewed`. Hoy todos en `draft`. Audit A3 sobre HALLAZGOS antes que sobre caps.

### Cifras tocadas (verificación cruzada)

Las 9 cifras canónicas verificadas en sesión 13 contra panel v12 siguen vigentes y replicadas en HALLAZGOS v0.2.0:

- F04: máx 3,48% (1990); media 1990–2007 = 1,72%; media 2000–2007 = 1,87%
- F05: cartera 2010 = USD 290 M (5,07%); cartera 2024 = USD 3 397 M (11,70%); factor ×11,7
- Inv USD 2015 / 2024 = USD 320 / 261 M
- MAFAP D 2008 / 2018 = 286 / 2 098 M BOB 2015
- BOOST media % capital 1996–2008 ≈ 62%

### Hallazgos afectados

Todos los 8 finding_ids (F01–F08) reescritos a numeración canónica con contratos completos. `status: draft` en los 8 — ningún `reviewed` aún.

### Capítulos del book afectados

- **Cap 1**: errata corregida (bolivariana→boliviana). Sigue CONDITIONAL_PROMOTE pendiente de P0–P1.
- **Cap 6**: 3 cifras canónicas corregidas (F01 ventana, F02 año, F06 ventana pobreza); tipografía decimal coma; "consistentemente" eliminado. Sigue PASS con P1 (citas no auditadas pendientes).
- Caps 2, 3, 4, 5: sin tocar (pendientes pase 2+ en sesión 15).

### Impacto en panel / metodología

- `panel_version`: **v12 (sin cambio)**.
- `methodology_version`: **m0.1 (sin cambio)** — HALLAZGOS v0.2.0 hereda m0.1.

### Impacto en MEFP handoff

- **Ningún cap promovible a `reviewed` aún**: bloqueado por audit gates A3 + dependencia F-promotion.
- Borrador v0.1 sigue siendo apto para **pre-review interno BM** con caveats documentados.
- Carta MEFP pendiente (R-001).

### Riesgos abiertos

- R-001 Carta MEFP (heredado).
- R-003 IADB AgriMonitor feb-2026 (heredado).
- R-014–R-018 Coordinación Hector (heredado).
- **R-019 Render Quarto local**: el render del book emite exit=1 en este entorno sin error visible; verificar localmente.
- **R-020 NUEVO — Audit gates dependencia circular**: caps no pueden promoverse hasta que findings estén `reviewed`; findings no pueden pasarse a `reviewed` hasta que scripts canónicos existan; scripts no existen para 5 contratos. Romper la dependencia: priorizar creación de scripts MAFAP-derived (F01, F05, F06).

### Siguientes pasos (orden sugerido sesión 15)

1. **Pase 2 — Citas**: resolver 5–6 citas no auditadas / conflicto green/red. Decisión: auditar PDF (incorporar al corpus) o sustituir por green equivalente.
2. **Pase 3 — Datasets fantasma**: mapear `pse_gsse_bolivia.rds` → `idb_pse_bolivia_aggregate.rds` (Cap 1); verificar `eh_nacional_anual.rds` (Cap 2) — si no existe, construir desde INE EH cruda o reescribir chunk.
3. **Pase 4 — Cifras huérfanas**: resolver BDP 68%, INIAF Bs 98M, SENASAG Bs 108M (Cap 3); Mandanas +37,9%, MDRyT 74%/54%, Filipinas 85–92% (Cap 4) — citar o eliminar.
4. **Pase 5 — TODO_TRACE prosa**: reescribir defensivamente los 7–10 TODO_TRACE más críticos en prosa visible (Caps 2, 3, 4).
5. **Pase 6 — Alt-text + figuras**: agregar `fig-alt=` ES + EN a ~30 figuras; verificar fig16/fig17 (Cap 5); re-etiquetar fig02 (Cap 3).
6. **Pase 7 — Scripts contratos**: crear stubs en `02_code/` para los scripts citados en F01/F05/F06/F07/F08, o reformular `script_path` con `[TODO_TRACE]` justificado.
7. **Re-correr auditores** sobre Caps 1–6 después de remediación; objetivo: 3+ caps en `CONDITIONAL_PROMOTE` para sesión 16.
8. **Promover F04, F05 a `reviewed`** (los más maduros) vía gate A3 sobre HALLAZGOS.
9. Render local del book.
10. Enviar carta MEFP (R-001).

---

**Tipo de cambio:** 🟡 AMARILLO (redacción masiva; bib sincronizado; sin cambio en gobernanza canónica ni en hallazgos cuantitativos validados).
**Archivos modificados:** ~12 (7 capítulos qmd + index + references.bib + wb_report.scss + outputs MAFAP).
**ADR requerido:** no — sigue las decisiones de sesión 12; pero al menos **3 issues nuevos requieren ADR en sesión 14** (F02 alineación, Gautam2022 conflicto, ventana canónica en `01_constants.R`).

### Qué se hizo

1. **Pipeline MAFAP ejecutado** (cierre del bloque pendiente de sesión 12):
   - `Rscript 02_code/02_cleaning/17_mafap_classification.R` → `01_data/processed/mafap_bolivia.rds` (35 años × 198 cols, +22 vars `mafap_*`); tests T1/T2/T4 pasan; T3 reporta 12 años con narrow>0 (2006–2023); T5 (E/narrow mediana) inflado por `no_pse_data` en años recientes — esperado.
   - `Rscript 02_code/04_visualization/11_figures_mafap.R` → 5 figuras × 3 formatos en `05_outputs/figures/{svg,png,pdf}/`: `fig18a_mafap_A_apoyo_productor`, `fig18b_mafap_BC_consumidor_otros`, `fig18c_mafap_D_apoyo_general`, `fig18d_mafap_E_rural_soporte`, `fig18_summary_mafap_ABCDE`.

2. **6 capítulos del book redactados en paralelo vía subagente `aper-writer`** (uno por archivo, sin solapamiento):

   | Cap | Archivo | Palabras | Citas | TODO_TRACE | Score anti-IA |
   |:-:|---|:-:|:-:|:-:|:-:|
   | 1 | `01_introduction.qmd` | 3 165 | 10 (8 g + 2 y) | 3 | 2/10 |
   | 2 | `02_sector_performance.qmd` | 4 331 | 25 (23 g + 2 y, 4 red sustituidas) | 9 | 1–2/10 |
   | 3 | `03_budget_institutions.qmd` | 5 996 | 12 (7 g + 4 y + 1 bib-only) | 5 | 2/10 |
   | 4 | `04_spending_organization.qmd` | 5 078 | 10 (7 g + 3 y) | 33 | 1/10 |
   | 5 | `05_spending_analysis.qmd` | 4 498 | 16 (9 g + 7 y) | 14 | 2/10 |
   | 6 | `06_recommendations.qmd` | 3 513 | 17 (14 g + 3 y, 4 red sustituidas) | 14 | 2/10 |
   | RE | `index.qmd` (manual) | 1 925 | 9 (g/y) | 1 | — |
   | **Total** | — | **28 506** | 99 únicas | **79 TODO_TRACE** | — |

3. **`04_report/references.bib` sincronizado** (era bloqueante: 192 → 4 013 líneas, 11 → 383 entries):
   - Copia de seguridad en `references.bib.legacy_backup`.
   - Concatenado: `03_literature/references_master.bib` (359 entries CamelCase del corpus auditado) + 11 entries legacy snake_case (compatibilidad caps pre-v0.4.0) + 2 aliases (`Laborde2021_GHG`, `Searchinger2019_WRI`) que el Cap 6 usa con underscore pero el master tiene sin.
   - **Cero citekeys huérfanos** en los 7 archivos qmd. Hay 6 duplicados (master vs Cap 3 writer paralelo) — BibLaTeX usa el primero y emite warning, no error.

4. **Fix SCSS theme**: `style/wb_report.scss` no tenía los layer boundaries de Quarto (`/*-- scss:defaults --*/`, `/*-- scss:rules --*/`); se añadieron para desbloquear el render HTML.

5. **Gate §13B aplicado disciplinadamente por los 6 writers**: 99 citas únicas, 0 red en el draft final. Sustituciones documentadas: `@Gautam2022` (conflicto green/red) → `@WorldBank2024_RepurposingSupport` o `@GautamLaborde2022`; `@PICAR_WorldBank2021` y `@PlanVida_IFAD` (red) → omitidas o descriptivas; `@CIPCA2014/2021` (red) → `@Urioste2011` + `@INE2015_Censo`; `@UDAPE2025_BrechasSociales` y `@WorldBank2024_PovertyEquityBrief` (red) → `@Vargas_Garriga2015_Inequality` + `@OPHI2024_BoliviaBriefing` + `@WFP2022_BoliviaACR`.

### Cifras tocadas (con trazabilidad — verificadas contra panel v12)

| Cifra | Valor | Verificación |
|---|---|---|
| F04 — Maputo máx 1990 | **3,48%** | `panel$speed_ag_pctexp[year==1990] = 3.4844` ✓ |
| F04 — media 2000–2007 | **1,87%** | `mean(panel$speed_ag_pctexp[2000:2007])` ✓ |
| F05 — cartera 2010 | **USD 290 M (5,07%)** | `panel$bcb_cred_agro_mm_usd[2010]` ✓ |
| F05 — cartera 2024 | **USD 3 397 M (11,70%)** | `panel$bcb_cred_agro_mm_usd[2024]` ✓ |
| F05 — factor ×11,7 | **3397/290 = 11,71** | ✓ |
| Inv USD 2015 / 2024 | **USD 320 / 261 M** | `panel$inv_agro_usd_mm` ✓ |
| MAFAP D 2008 / 2018 | **286 / 2 098 M BOB 2015** | `mafap$mafap_D_bob_2015` ✓ |
| MAFAP E banda 2012–2021 | **2 697–4 799 M BOB 2015** | ✓ |
| BOOST media % capital | **62%** (1996–2008) | ✓ |

Resto de cifras del reporte: marcadas como `[TODO_TRACE]` con descripción específica de qué hay que rastrear (79 marcadores totales — la lista canónica de deuda cuantitativa para sesión 14).

### Hallazgos afectados

- **F01–F08** todos referenciados en los caps correspondientes (no se modifica ningún `claim_es`; las cifras canónicas se replican literalmente).
- **F02 — discrepancia detectada**: el plan §9 dice "PSE 5,8% LAC" pero el contrato actual de F02 en `04_HALLAZGOS.md` habla de "brechas sectoriales". Requiere ADR de unificación.

### Capítulos del book afectados

Todos los 7 archivos qmd reescritos (placeholder → borrador v0.1). El status del dashboard (`20_CONTENIDO_REPORTE.md §2`) puede pasar de 🟡 borrador / placeholder a 🟢 borrador-v0.1 en todas las filas excepto el resumen ejecutivo que necesita versión EN para el deliverable D4.

### Slides / web actualizadas

Ninguna esta sesión.

### Impacto en panel / metodología

- `panel_version`: **v12 (sin cambio)** — el reporte se construye sobre el panel canónico.
- `methodology_version`: **m0.1.0 (sin cambio)** — la clasificación MAFAP estaba ya documentada en sesión 12; solo se materializó como dataset.
- `mafap_data`: **nuevo** — `01_data/processed/mafap_bolivia.rds` agrega 22 variables MAFAP al panel disponible para análisis.

### Impacto en MEFP handoff

- **Borrador v0.1 listo** para pre-review interna con equipo BM Bolivia antes de mesa técnica MEFP.
- **Carta MEFP sigue pendiente de envío** (R-001).
- **Outputs Hector pendientes**: bloquean cifras finales de Caps 5 (PSE/GSSE actualizado) y 6 (fiscal cost del repurposing) — actualmente marcados como `[TODO_TRACE]`.

### Riesgos pendientes (heredados + nuevos)

- **R-001** Carta MEFP sin respuesta (sigue abierto).
- **R-003** IADB AgriMonitor feb-2026 (sigue abierto).
- **R-014–R-018** Coordinación Hector — pendientes de formalizar en `10_RIESGOS.md`.
- **R-019 NUEVO** — Render Quarto local: el render del book emite exit=1 en este entorno sin error visible; verificar localmente con `cd 04_report && quarto render --to html`.

### Issues estructurales abiertos (lista canónica para sesión 14)

1. **`@WB2014_PEMethodGuideVolII`** sin ficha en `03_literature/` (citado en plan §5/§7 pero no resoluble). Sustituido por descriptiva en Cap 1 y por `@MAFAP2013_MethodGuideVolI` en Cap 3.
2. **Ventana canónica desalineada**: `02_code/00_setup/01_constants.R` define `YEAR_START=2000, YEAR_END=2023`; MASTER_PROMPT v0.4.0 fija 2008–2024. Los writers escribieron los años literales para evitar drift. Requiere actualizar constantes o crear `YEAR_CANONIC_START` separada.
3. **Typo en plan §5 H3.4.1**: "bolivariana" → corregir a "boliviana" si era no intencional.
4. **TFP exacta del APER 2011** no validada — Caja 2.1 en Cap 2 tiene TODO_TRACE.
5. **Chunk `eh_nacional_anual.rds` en Cap 2** no verificado contra disponibilidad del RDS.
6. **`@Gautam2022` conflicto green/red simultáneo** en el corpus (carpeta 01 green, carpeta 02 red) — requiere re-auditoría del PDF.
7. **F02 discrepancia** entre plan §9 ("PSE 5,8%") y `claim_es` actual del contrato — ADR.
8. **6 duplicados en `references.bib`** (master vs Cap 3 writer paralelo) — limpiar con `bibtool` o manual.
9. **References.qmd como capítulo final** vs convención WB de bibliografía como apéndice — confirmar.

### Siguientes pasos (orden sugerido sesión 14)

1. **Render local del book**: `cd 04_report && quarto render --to html` desde el entorno del usuario; capturar warnings y resolver chunks R que fallen.
2. **Pasar el borrador por `/quijote-reviewer` o `critical-reviewer`** adversarial antes de pre-review BM.
3. **Resolver issues 1–9 arriba** (especialmente 2, 7, 8 antes de pre-review).
4. **Sincronizar Cap 0 RE en EN** (paridad ES/EN obligatoria — deliverable D4 ToR JC).
5. **Activar `/audit-chapter` sobre Caps 1–6** (gates A1–A6) antes de promover a `reviewed`.
6. **Enviar carta MEFP** (R-001).
7. **Confirmar fechas reales** outputs Hector (H1–H4).

---

**Tipo de cambio:** 🔴 ROJO (3 ADRs nuevos; toca METODOLOGIA, HALLAZGOS, CONTROL, AUDITORIA + decisión metodológica MAFAP dual)
**Archivos modificados:** ~25 (21 docs canónicos en `.agent/`, 3 ADRs, 1 CSV crosswalk, 2 scripts R, 1 qmd apéndice)
**Tests ejecutados:** ninguno (scripts MAFAP listos pero pendientes de ejecutar)
**ADR requerido:** sí — **ADR-0008** (Master v0.4.0), **ADR-0009** (MAFAP narrow+full), **ADR-0010** (crosswalk clasificaciones) — los tres creados en esta sesión

### Qué se hizo

1. Construida gobernanza completa en `.agent/` (21 docs canónicos numerados 00–21 + README + 3 ADRs en decisions/).
2. **MASTER_PROMPT bumpeado a v0.4.0** (ADR-0008) integrando bloque D + paleta híbrida + naming dual figuras + ventana canónica **2008–2024** + MAFAP Group I/II + 5 shocks explícitos (commodity, COVID, sequía 2023, Ley 393) + RQ2 mapping F08/F01/F06.
3. **6 bloqueadores MAFAP cerrados**: ADR-0009 adopción narrow+full; ADR-0010 crosswalk; `crosswalk_mafap_oecd_cofog.csv` (41 entradas 4-way); `C_glosario_mafap.qmd` (171 líneas, 9 secciones); `17_mafap_classification.R` (270 líneas, 5 tests); `11_figures_mafap.R` (243 líneas, 5 figuras).
4. **Alineación con dos ToR**: nuevo `.agent/21_COORDINACION_STC.md` con división operativa JC↔Hector + cronograma 7 sem + protocolo de integración + 5 riesgos R-014–R-018.
5. **20_CONTENIDO_REPORTE bumpeado v0.1 → v0.5**: 8 apéndices A–H, 6 bloqueadores MAFAP cerrados, ToRs integrados, **§23 Integración corpus literatura** con mapeo evidencia↔caps + reglas citación + 10 vacíos + 6 patrones transversales.
6. Corpus literatura: 11 entries → **359 BibTeX + 325 fichas + 11 carpetas temáticas + 163 PDFs (434 MB)**.

### Cifras tocadas (con trazabilidad)

Ninguna cifra publicada modificada — sesión de infraestructura. Toda cifra concreta del MAFAP/PSE quedará disponible al ejecutar `17_mafap_classification.R` sobre panel v12.

### Hallazgos afectados

- **F04** (Maputo) — clarificada cita explícita a MAFAP narrow (Group I) según ADR-0009.
- **F01–F08** — todos ahora mapeados a fuentes ancla del corpus de literatura (§23.4 del 20_CONTENIDO).

### Capítulos del book afectados

- Plan operativo de **los 6 caps + 8 apéndices** actualizado en `20_CONTENIDO_REPORTE.md` v0.5.0.
- Cap 0 longitud ajustada **6-8 → 4-6 pp** (alineación TOR JC D4).
- Caps 5, 6 marcados con dependencia explícita de outputs Hector.
- Cap 4 H2.2 desagregado con Santa Cruz / La Paz / Cochabamba explícitos.
- Bloques "Citas requeridas" reescritos en caps 5–10 con fuentes ancla concretas.

### Slides / web actualizadas

Ninguna esta sesión.

### Impacto en panel / metodología

- `panel_version`: **v12 (sin cambio)** — solo se prepararon scripts derivados.
- `methodology_version`: **m0.1.0 (sin cambio explícito)** — METODOLOGIA expandida con MAFAP G I/II pero sin re-cálculo retroactivo.

### Impacto en MEFP handoff

- **Clasificación dual MAFAP** lista para presentar en mesa técnica (preparada doc + scripts).
- **Coordinación formal con Hector** documentada (división operativa, cronograma, protocolo).
- **Carta MEFP sigue pendiente de envío** (R-001).

### Riesgos pendientes

- **R-001** Carta MEFP sin respuesta (sigue abierto).
- **R-003** IADB AgriMonitor feb-2026 (sigue abierto).
- **R-014 a R-018** (coordinación Hector) — pendientes de registrar formalmente en `10_RIESGOS.md`.
- **Disco al 95%** — operacional, atendido en sesión.

### Siguientes pasos

1. **Ejecutar scripts MAFAP**: `Rscript 02_code/02_cleaning/17_mafap_classification.R` + `Rscript 02_code/04_visualization/11_figures_mafap.R`.
2. **Sincronizar biblio**: `cp 03_literature/references_master.bib 04_report/references.bib`.
3. **Enviar carta MEFP** (R-001).
4. **Confirmar fechas reales** de outputs Hector (H1–H4) en sesión 1:1.
5. **Registrar R-014–R-018** en `10_RIESGOS.md`.
6. **Activar `/write-section` Cap 1** (el más dependiente de literatura externa).

---

## 0bis. Sesión 11 (2026-05-23) — Revisión sistemática de literatura + auditoría anti-alucinación

**Tipo de cambio:** 🟡 AMARILLO (expansión del corpus + nuevo gate de auditoría); seguido de 🔴 ROJO al detectar problemas de calidad

### Qué se hizo
1. **Estructura expandida** en `03_literature/` con 10 carpetas temáticas:
   - `01_systematic_reviews/` · `02_public_spending/` · `03_productivity_efficiency/` · `04_climate_food_security/` · `05_value_chains/` · `06_smallholder_indigenous/` · `07_subsidies_repurposing/` · `08_institutions_programs/` · `09_methods_per_pse/` · `10_macro_growth_poverty/`
   - Template ficha externa (`_template_external.md`) con frontmatter YAML + 14 secciones

2. **10 agentes de búsqueda paralelos** (3 lotes) recorrieron WB / IDB / FAO / IFPRI / OECD / NBER / Google Scholar / RePEC:
   - **317 fichas externas** creadas + 7 MDRyT + 1 PER = **325 totales**
   - **149 PDFs** descargados (~434 MB) — pero 11 resultaron ser HTMLs landing pages
   - **313 entradas BibTeX únicas** en [`03_literature/references_master.bib`](../03_literature/references_master.bib)

3. **Evidence map maestro** generado en [`03_literature/evidence_map.md`](../03_literature/evidence_map.md): mapa por capítulo APER (Cap 1–6) con fuentes ancla, hallazgos transversales, vacíos detectados

4. **Auditoría anti-alucinación en 2 fases** (a petición del usuario):
   - **Fase 1 (estructural)**: 11 PDFs falsos (HTMLs) → cuarentena en `_audit/quarantine_fake_pdfs/`; 2 fichas BID corregidas; **0 huérfanos** en cross-reference fichas↔BibTeX; **0 placeholder DOIs**
   - **Fase 2 (contenido)**: 5 agentes paralelos leyeron PDFs reales y compararon con fichas:
     - **93 fichas auditadas** (29% del corpus)
     - **39 rojas** (42% — alucinación crítica confirmada)
     - **30 amarillas** (32% — inconsistencias menores)
     - **24 verdes** (26% — confirmadas limpias)

5. **Patrón sistémico detectado:** los agentes de búsqueda crearon fichas con base en snippets de WebSearch + memoria del LLM sin leer el PDF. Resultado: citas verbatim fabricadas, cifras inventadas, autores incorrectos, PDFs descargados que no corresponden al paper de la ficha. Ver [`03_literature/_audit/AUDIT_REPORT.md`](../03_literature/_audit/AUDIT_REPORT.md) y [`03_literature/_audit/RED_FLAGS.md`](../03_literature/_audit/RED_FLAGS.md).

6. **Remediación automática aplicada:**
   - Campo `audit_status` añadido al frontmatter de las **317 fichas** (red/yellow/green/unverified)
   - 11 HTMLs falsos en cuarentena
   - Lista pública de las 39 rojas con tipo de problema documentado
   - **Gate nuevo en `.agent/09_AUDITORIA.md` §13B**: "Una ficha sólo puede citarse en `04_report/*.qmd` si `audit_status ∈ {green, yellow}`"

### Productos clave de sesión 11
- [`03_literature/README.md`](../03_literature/README.md) — índice maestro con aviso de auditoría
- [`03_literature/evidence_map.md`](../03_literature/evidence_map.md) — mapa de evidencia por capítulo
- [`03_literature/references_master.bib`](../03_literature/references_master.bib) — **359 entradas únicas** (post-carpeta 11)
- [`03_literature/_audit/AUDIT_REPORT.md`](../03_literature/_audit/AUDIT_REPORT.md) — reporte consolidado final
- [`03_literature/_audit/RED_FLAGS.md`](../03_literature/_audit/RED_FLAGS.md) — lista pública de 83 alucinaciones
- [`03_literature/_audit/_green_list_final.md`](../03_literature/_audit/_green_list_final.md) — 44 fichas verdes citables
- 10 reportes Fase 2 + 10 reportes Fase 3 + 2 reportes Carpeta 11 en `03_literature/_audit/`
- [`.agent/09_AUDITORIA.md`](../.agent/09_AUDITORIA.md) §13B — gate de literatura

### 🆕 Carpeta 11 — `11_local_multilateral_bolivia/` (creada sesión 11)

**46 fichas + 48 PDFs reales** (585 MB total entre todas las carpetas), creadas con protocolo estricto anti-alucinación:
- **Multilaterales** (21 fichas, 3 green + 18 yellow): CAF, IICA, CAN, FAO Bolivia (5), IFAD/FIDA, WFP, UNDP/PNUD (HDR + INDH), UNODC, UE (MIP), AECID (×2), COSUDE, GIZ-PROAGRO, GCF (RECEM-Valles), GRUS, BIVICA, RedUnitas
- **Bolivia local** (18 fichas, 17 green + 1 yellow): CEDLA, IISEC-UCB, Fundación Milenio (×2), CEBEM, INESAD (×4 incluye SimPachamama), CIPCA (×2), TIERRA (×2), Solón, AGRECOL, IBCE (×2), CAO, INE (Censo 2013), BCB, UDAPE, EMAPA
- **0 fichas red** — el protocolo estricto funcionó

### 🔴 Resultado de auditoría sesión 11 (consolidado FINAL post-recovery)

| `audit_status` | # fichas | Citable? | Comentario |
|----------------|:------:|:------:|------------|
| 🟢 green | **126** | Sí | PDF leído y verificado |
| 🟡 yellow | 124 | Sí con caveat | Metadata OK, cifras pendientes |
| 🔴 red | 89 | NO | Alucinación confirmada — re-verificar antes |
| ⏳ unverified | 0 | — | Todo auditado |

**Δ vs estado inicial post-Fase 3:** +82 green (44→126), -88 yellow, +6 red (PDFs ≠ paper detectados durante promoción), +83 PDFs (186→269 = 1.0 GB)

**Tipología de alucinaciones detectadas:**
- 16 fichas con PDF descargado ≠ paper de la ficha (modo de falla más severo)
- 8 DOIs incorrectos que apuntan a otro paper
- 12 autores fabricados o atribución institucional vs individual mal
- 12 años/issues/pages incorrectos
- 25 cifras inventadas en §6
- 50+ citas verbatim "p. X" fabricadas (eliminadas en bloque via Opción B)

### Próximos pasos al cierre de sesión 11

Opciones B (eliminar §8) y C (Fase 3 completa) **ya ejecutadas**. Estado para empezar a redactar:

1. **256 fichas citables** (44 green + 212 yellow) cubren todos los capítulos del APER
2. **83 fichas rojas** documentadas y bloqueadas por gate §13B
3. **Carpeta 11 nueva con cero red** ofrece base sólida para citar instituciones bolivianas + multilaterales

### Decisiones operativas para redactar el reporte

1. **Antes de cada `/write-section`**: consultar `_audit/_green_list_final.md` (44 verdes seguras) + `_audit/RED_FLAGS.md` (83 rojas evitables)
2. **Gate §13B** enforced: no citar `red` o `unverified` (esta última en 0)
3. **Para cifras críticas del reporte**: usar fichas green primero; si solo yellow disponible, verificar la cifra específica abriendo el PDF antes de citar
4. **Workflow nuevo para futuras búsquedas**: descargar PDF → validar header `%PDF-` → abrir y leer con Read tool → componer ficha solo con lo verificado → §8 PROHIBIDA (sin citas verbatim "p. X")

---

> **Antes de cualquier acción:** lee [`AGENTS.md`](../AGENTS.md) (raíz, thin pointer) y luego [`.agent/00_MASTER_PROMPT.md`](../.agent/00_MASTER_PROMPT.md) (fuente única de gobernanza editorial v0.3.0).

## Orden de lectura canónico de gobernanza (en `.agent/`)
1. [`00_MASTER_PROMPT.md`](../.agent/00_MASTER_PROMPT.md) — spec maestro
2. [`01_METODOLOGIA.md`](../.agent/01_METODOLOGIA.md) — cómo se calcula
3. [`02_INDICADORES.md`](../.agent/02_INDICADORES.md) — qué se calcula (panel v12)
4. [`03_FUENTES.md`](../.agent/03_FUENTES.md) — de dónde viene
5. [`04_HALLAZGOS.md`](../.agent/04_HALLAZGOS.md) — qué se encontró (F01–F08)
6. [`05_ESTILO_NARRATIVO.md`](../.agent/05_ESTILO_NARRATIVO.md) — cómo se escribe
7. [`06_NEUTRALIDAD.md`](../.agent/06_NEUTRALIDAD.md) — qué palabras se usan
8. [`07_CONTROL.md`](../.agent/07_CONTROL.md) — cómo se cambia algo
9. [`08_AUDITORIA.md`](../.agent/08_AUDITORIA.md) — cómo se verifica

---

## 0. Sesión 10 (2026-05-23) — Centralización de gobernanza

**Tipo de cambio:** 🔴 ROJO (reorganización estructural)
**MASTER_PROMPT.md:** v0.2.0 → v0.3.0 (movido de `04_report/` a `.agent/`)

### Qué se hizo
1. **Sesión actual:** revisión del estado del proyecto + plan editorial.
2. **`04_report/MASTER_PROMPT.md`** creado (v0.1) — blueprint vivo con plan sección × sección.
3. **MASTER_PROMPT** fusionado con `Master_Prompt_APER2026_v0_1_0.md` (v0.1.0 spec) → v0.2.0/v0.2.1/v0.2.2.
4. **Ficha PER** creada en [`03_literature/Informacion_PER/FICHA_LECTURA.md`](../03_literature/Informacion_PER/FICHA_LECTURA.md) (5 docs leídos: manual MAFAP, PER Filipinas, PER SSA, PER EXAMPLES, PNIA xlsx).
5. **Glosario MAFAP bilingüe ES/EN** generado en [`04_report/appendix/glosario_mafap_es_en.md`](../04_report/appendix/glosario_mafap_es_en.md) + CSV reproducible [`01_data/processed/mafap_categories.csv`](../01_data/processed/mafap_categories.csv).
6. **Decisión metodológica:** clasificación dual MAFAP (Caps 3-4) + PSE/OECD (Cap 5).
7. **Gobernanza centralizada en `.agent/`** (v0.3.0): MASTER_PROMPT.md + ESTILO_NARRATIVO + NEUTRALIDAD + CONTROL + stubs (HALLAZGOS, METODOLOGIA, FUENTES, INDICADORES) + subcarpetas operativas (policies, checklists, prompts, protocols, decisions, schemas) + legacy archivado.
8. `EJEMPLO_BORRAR.md` eliminado.
9. `AGENTS.md` y `CLAUDE.md` (raíz) reducidos a thin pointers a `.agent/`.

### Próximos pasos (orden sugerido)
1. **Poblar stubs** de `.agent/` según se vayan necesitando (especialmente HALLAZGOS con contratos JSON completos).
2. **Re-correr regresiones** sobre panel v12 (script `08_extended_regressions.R`) — desbloquea Cap 5.
3. **DEA Simar-Wilson** sobre `dea_dataset.rds`.
4. **Generar script** `02_code/03_analysis/11_mafap_classification.R` (clasifica BOOST + VIPFE → `mafap_bolivia.rds`).
5. **Enviar carta MEFP** (completar 5 campos).
6. **Activar `/write-section` para Cap 2 o Cap 3** (los más autónomos).

---

---

## 1. Sitio público — vivo en GitHub Pages

**🌐 https://jcmunozmora.github.io/bolivia-wb-aper-2026/**

10 páginas: index · proyecto · **avances vs 2011** · sector · gasto · eficiencia · **timeline (componente custom)** · **slides (deck embebido)** · datos · recursos.

- **40 figuras** del pipeline integradas con narrativa coherente
- **3 figuras analíticas del timeline** (densidad anual, heatmap categoría×año, distribución por gobierno)
- **Timeline custom en JS vanilla** — sin dependencias externas, paleta navy/terracota, filtros por categoría + búsqueda
- **Galería visual** con 57 cards de hitos (imágenes Wikimedia locales)
- **Deck del kickoff BM 2026-04-27** embebido (HTML 3.8 MB + PDF 630 KB)
- **15 descargas** disponibles (reportes BM, carta MEFP + 3 anexos, inventario Excel, datasets, slides)

Source en [`www/`](../www) · Renderizado en [`docs/`](../docs) · Deploy automático cada push a `main` con cambios en `docs/` (GitHub Pages nativo, no usar el workflow custom `publish-site.yml.disabled`).

---

## 2. Estado de datos al cierre

### Datos consolidados
- **Panel v12** (canónico): `01_data/processed/spending_panel_v12.rds` — 35 años × **176 vars limpias**
- **Diccionario v12**: `spending_panel_v12_dictionary.csv` (17 grupos clasificados)
- **Panel subnacional v2**: 90 × 36 (2012-2021)
- **Panel municipal v3**: 3,368 × 70
- **DEA-ready**: 81 DMUs × 32 vars
- **125 datasets RDS**, 142 MB

### Inventario código y outputs
- **43** scripts recolección + **8** análisis + **4** visualización (incluye `09_figures_timeline.R` y `10_timeline_csv_to_json.R`)
- **40 figuras** PNG en `05_outputs/figures/`
- **7 fichas MDRyT** en `03_literature/mdryt_fichas/`
- **61 hitos** timeline + **61 imágenes** locales
- **Slide kickoff BM** en `slides/2026-04-27_kickoff/` (qmd + html + pdf)

---

## 3. Próximos pasos al retomar

### Esta semana
1. **Enviar carta MEFP** — completar 5 campos `⚠` (fecha, firmante, cargo, correo, teléfono) y coordinar con oficina BM Bolivia
2. **Re-correr regresiones** sobre panel v12 corregido (`02_code/03_analysis/08_extended_regressions.R`)

### Siguientes
3. **DEA bootstrap Simar-Wilson** sobre `dea_dataset.rds` (81 DMUs ya listo)
4. **Validar anomalía PP caña 2015** (PP doméstico 261 USD/t vs ref 37 USD/t — verificar con INE)
5. **Reporte técnico formal Quarto book** — `04_report/` tiene 6 capítulos con placeholders; poblar en paralelo al sitio web público
6. **Pre-review interno con equipo BM** una vez listo el primer borrador del reporte técnico

---

## 4. Comandos rápidos

```bash
# R del proyecto
/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript --no-init-file

# Cargar panel canónico
Rscript --no-init-file -e 'p <- readRDS("01_data/processed/spending_panel_v12.rds"); dim(p)'

# Renderizar el sitio (usa LANG=en_US.UTF-8 para acentos)
cd www && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 quarto render

# Estado git
git log --oneline -10

# Test local del sitio
cd docs && python3 -m http.server 8000  # → http://localhost:8000
```

---

## 5. Convenciones del proyecto (recordatorios)

- **Panel canónico actual:** v12 (176 vars). NO usar v10 ni v11 (tienen bugs).
- **Deflactor:** CPI base 2015 INE Bolivia; BOB 2015 + USD WDI.
- **Dummy estructural obligatorio:** `post_ley393` en regresiones de crédito.
- **CHIRPS:** flag `source` para distinguir interpolado vs original.
- **R con caracteres acentuados:** `Sys.setlocale("LC_ALL", "en_US.UTF-8")` antes de I/O.
- **JSON con UTF-8:** usar `jsonlite::write_json()`, NO `writeLines(toJSON(...))`.
- **MDRyT site:** bloqueado por Cloudflare — usar Wayback con HTTP (no HTTPS).
- **Workflow GitHub:** solo el nativo de Pages (Settings · Pages · Deploy from branch · main · /docs). El custom queda desactivado en `publish-site.yml.disabled`.

---

## 6. Hallazgos cuantitativos del estudio (8 para el reporte)

| # | Hallazgo | Cifra clave |
|:-:|----------|:-----------:|
| 1 | Inversión ×10 vs TFP estancada | TFP +30% / Inv ×10 (2000-2015) |
| 2 | PSE Bolivia en LAC | **5.8%** (5° puesto) |
| 3 | Patrón dual NRP | Soya −37% / Maíz +46% |
| 4 | Maputo nunca alcanzado | máx **3.48%** en 1990 |
| 5 | Sustitución gasto → crédito | Crédito ×11.7 (2010-2024), Ley 393 |
| 6 | Pobreza rural revierte | 55→40→**45%** (2012-2024) |
| 7 | PAR III subejecutado | **16%** financiero en 2024 |
| 8 | Frontera agropecuaria | **9.4 M ha** perdidas / 64% Santa Cruz |

---

## 7. Archivos clave para recuperar contexto

| Archivo | Contenido |
|---------|-----------|
| `00_admin/ESTADO_DE_DATOS.md` | Inventario completo y gaps |
| `00_admin/Inventario_Datos_APER_Bolivia_2026.xlsx` | Resumen ejecutivo (5 hojas) |
| `01_data/processed/spending_panel_v12_dictionary.csv` | Diccionario de las 176 vars |
| `03_literature/mdryt_fichas/README.md` | Índice de las 7 fichas MDRyT |
| `01_data/timeline/README.md` | Documentación timeline |
| `slides/README.md` | Convenciones de slides |
| `www/index.qmd` | Landing del sitio público |
| **Este archivo** | Tu punto de entrada para retomar |

---

## 8. Bugs corregidos en sesión 9 (no repetir)

1. **MapBiomas nombres truncados** — `gsub("[^a-z0-9]+", ...)` antes de `tolower()` consume mayúsculas iniciales (`Natural` → `atural`). Aplicar siempre `tolower()` PRIMERO.
2. **Duplicados WDI vs OWID** — verificar correlación antes de hacer merge; los idénticos elimine, los con diff renombre por fuente (`fao_*`, `ine_*`, `wdi_*`).
3. **JSON con bytes UTF-8 escapados como texto** — `writeLines()` en locale C escapa `—` como `<e2><80><94>`. Usar `jsonlite::write_json()` directo.
4. **Dos workflows GitHub Pages compitiendo** — custom + nativo causa race conditions y failures intermitentes. Mantener solo uno.
5. **Quarto .qmd con paths absolutos `here::here()`** — funciona local pero rompe en GitHub Pages. Usar paths relativos del sitio (`figures/`, `downloads/`).

---

**Responsable:** Juan Carlos Muñoz Mora — `jcmunozmora@gmail.com`
**Repositorio:** https://github.com/jcmunozmora/bolivia-wb-aper-2026
