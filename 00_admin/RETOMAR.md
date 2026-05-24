# Cómo retomar el proyecto — APER Bolivia 2026

**Última sesión:** 2026-05-24 (sesión 12 cerrada — gobernanza canónica completa + 6 bloqueadores MAFAP + corpus literatura integrado)
**Estado global:** ✅ Datos consolidados · ✅ Sitio público live · ✅ Gobernanza centralizada (21 docs + 3 ADRs) · ✅ MAFAP listo para ejecutar · ✅ Corpus literatura integrado · 🟡 Reporte técnico pendiente redacción · 📨 Carta MEFP lista · 🔴 Corpus literatura requiere remediación TBV

---

## 0. Sesión 12 (2026-05-24) — Gobernanza canónica completa + 6 bloqueadores MAFAP cerrados + corpus literatura integrado

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
