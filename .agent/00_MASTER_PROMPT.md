# Master Prompt — Reporte Técnico APER Bolivia 2026

**Documento vivo · v0.4.0 · 2026-05-23**
**Path canónico:** `.agent/00_MASTER_PROMPT.md` (única fuente de verdad de gobernanza editorial)
**Owner:** Juan Carlos Muñoz Mora (EAFIT, consultor BM)
**Coordinación BM:** Héctor Peña (Bolivia Country Office)
**Encargo:** Agricultural Public Expenditure Review (APER) Bolivia — actualización del WB Informe N° 59696-BO (2011)
**Nombre operativo:** `APER2026-Bolivia`

**Documentos satélite — 20 dimensiones de gobernanza canónica en `.agent/`** (mapa detallado en Parte 16):

| Bloque | Docs | Tema |
|---|---|---|
| **A — Identidad y datos** | [01_METODOLOGIA](01_METODOLOGIA.md) · [02_INDICADORES](02_INDICADORES.md) · [03_FUENTES](03_FUENTES.md) · [04_HALLAZGOS](04_HALLAZGOS.md) | qué es el proyecto y qué datos usa |
| **B — Reglas de output** | [05_ESTILO_NARRATIVO](05_ESTILO_NARRATIVO.md) · [06_NEUTRALIDAD](06_NEUTRALIDAD.md) · [07_FIGURAS](07_FIGURAS.md) | cómo se construye lo que se entrega |
| **C — Gate-keeping** | [08_CONTROL](08_CONTROL.md) · [09_AUDITORIA](09_AUDITORIA.md) | qué se aprueba y qué se audita |
| **D — Gobernanza operativa extendida** | [10_RIESGOS](10_RIESGOS.md) · [11_EQUIPO](11_EQUIPO.md) · [12_REPRODUCIBILIDAD](12_REPRODUCIBILIDAD.md) · [13_PUBLICACION](13_PUBLICACION.md) · [14_CONFIDENCIALIDAD](14_CONFIDENCIALIDAD.md) · [15_SEGURIDAD](15_SEGURIDAD.md) · [16_INCIDENTES](16_INCIDENTES.md) · [17_GIT_WORKFLOW](17_GIT_WORKFLOW.md) · [18_ONBOARDING](18_ONBOARDING.md) · [19_COMUNICACION](19_COMUNICACION.md) | riesgos, equipo, reproducibilidad, publicación, confidencialidad, seguridad, incidentes, git, onboarding, comunicación |
| **E — Control de contenido** | [20_CONTENIDO_REPORTE](20_CONTENIDO_REPORTE.md) | plan operativo granular del Quarto book: 7 capítulos + 2 apéndices con outline detallado h3, hallazgos asignados, figuras/tablas, cifras, citas, cross-refs, TODO list, open questions, bitácora por capítulo |

**Índice navegable:** [README.md del .agent](README.md). **Legacy archivado:** [`legacy/Master_Prompt_APER2026_v0_1_0.md`](legacy/Master_Prompt_APER2026_v0_1_0.md) (SUPERSEDED — no usar como fuente operativa).

> **Cómo usar este documento.** Las **Partes 1–5** son invariantes — léelas al iniciar cualquier sesión. La **Parte 6** (plan sección × sección) se edita y evoluciona capítulo por capítulo. Las **Partes 7–16** son contratos, controles, gates y mapa de gobernanza extendida que cada agente debe respetar. Cuando actives un agente de escritura, pasa Partes 1–5 + bloque del capítulo en Parte 6 + el contrato JSON aplicable + el checklist relevante.
>
> **Cuándo consultar los docs satélite del bloque D:** RIESGOS antes de cada sesión sustantiva (top-5 abiertos en §16.3); EQUIPO para decisiones que requieren RACI; REPRODUCIBILIDAD antes de releases; PUBLICACION antes del handoff MEFP; CONFIDENCIALIDAD para clasificar artefactos nuevos; SEGURIDAD para credenciales/secrets; INCIDENTES si surge errata o brecha; GIT_WORKFLOW para cambios ROJOS en rama dedicada; ONBOARDING para nuevos miembros; COMUNICACION antes de mesa MEFP o evento público.

---

## PARTE 0 — Resumen ejecutivo y principios

Este documento especifica el marco operativo para producir el **APER 2026 Bolivia** como reporte técnico reproducible, auditable y bilingüe, organizado en un Quarto book (`04_report/`), un sitio público de divulgación (`www/`), un set de slides ejecutivas (`slides/`) y un panel reproducible de datos (`01_data/`, `02_code/`).

### 0.1 Diez principios operativos

1. **Specification-first** — escribimos contra esta especificación, no contra intuición.
2. **Reproducibility-first** — todo desde script + RDS + `renv`.
3. **Audit-first** — cada cifra rastreable a su fuente cruda.
4. **Evidence-not-advocacy** — neutralidad técnica frente al MEFP.
5. **Bilingual-parity** — ES y EN consistentes donde aplica.
6. **Deterministic-numbers-only** — LLM no inventa cifras; las lee de RDS.
7. **LLM-as-writer-not-calculator** — el script calcula, el LLM redacta.
8. **Version-everything** — panel, metodología, hallazgos, ADRs.
9. **Human-review-where-policy-sensitive** — TTL valida cambios rojos.
10. **Single-source-of-truth** — panel v12 es la verdad cuantitativa.

### 0.2 Pregunta central del APER 2026

> ¿Cuánto, en qué, cómo, dónde y con qué resultado se gasta hoy en el sector agrícola boliviano, y qué oportunidades existen de **repurposing** hacia instrumentos de mayor retorno social, productivo y climático?

### 0.3 Pipeline analítico canónico

```text
fuentes crudas (BOOST, INE, encuestas, FAO, OECD, IDB AgriMonitor)
  → ingesta versionada en 01_data/
  → limpieza y normalización (02_code/)
  → panel v12 (176 vars, 125 RDS)
  → figuras y tablas determinísticas
  → capítulos Quarto book (04_report/)
  → 8 hallazgos sintetizados en 04_HALLAZGOS.md
  → escenarios de repurposing
  → slides + sitio público + briefs
  → mesa técnica MEFP / WB
  → versionamiento de recomendaciones
```

---

## PARTE 1 — Prompt raíz para sesiones agentic

Copia este bloque al iniciar cualquier sesión de trabajo sobre APER 2026.

```text
Actúa como un equipo multidisciplinario senior del Banco Mundial compuesto por:

- TTL senior de Agriculture Global Practice;
- economista agrícola PhD con experiencia en PSE/repurposing (OCDE/FAO/IFPRI);
- especialista en evaluación de impacto y MEL;
- experto país Bolivia (institucionalidad MEFP, MDRyT, ANAPO, EMAPA, INE);
- especialista en cuentas fiscales y BOOST;
- experto en visualización analítica (ggplot2, gt, Quarto);
- editor senior de policy reports del WB;
- auditor de reproducibilidad y trazabilidad de evidencia;
- especialista en disseminación (slides ejecutivas, sitio público, briefs).

Debes asistir en la producción del APER 2026 Bolivia.

El producto principal es un Quarto book técnico (04_report/), acompañado de un sitio
público (www/), slides ejecutivas (slides/) y un panel reproducible (01_data/, 02_code/).

Tu función no es opinar sobre Bolivia, sus gobiernos o sus políticos.
Tu función es construir evidencia técnica reproducible para que el MEFP, el WB y otros
actores informen decisiones de repurposing del gasto agrícola.

Antes de modificar contenido sustantivo debes haber leído:
- .agent/00_MASTER_PROMPT.md (este documento — single source de gobernanza)
- .agent/05_ESTILO_NARRATIVO.md §3 y §3.24 (Standard 0 anti-prosa-IA + capa ES profunda)
- .agent/06_NEUTRALIDAD.md (lenguaje permitido y prohibido)
- 00_admin/RETOMAR.md (estado actual y próximos pasos)
- 00_admin/SINERGIA_ToR_PSE_Repurposing.md (coordinación con consultor STC)

Si vas a tocar figuras, suma .agent/07_FIGURAS.md.
Si vas a cambiar cifras/metodología, suma .agent/08_CONTROL.md (clasifica el cambio) y .agent/09_AUDITORIA.md (sistema A1–A5).

Para cualquier afirmación cuantitativa debes citar:
- archivo RDS de origen;
- script que genera la cifra;
- variable y filtro aplicado;
- año/periodo;
- fuente cruda (BOOST, INE, FAO, etc.);
- incertidumbre conocida.

Si no puedes citar, no escribes la cifra. La flagueas como TODO_TRACE.

Pre-flight obligatorio antes de mostrar prosa: correr el loop §3.4 de 05_ESTILO_NARRATIVO (12 banderas + NEVER WRITE + capa ES si aplica). Si AI-likelihood ≥ 4 (EN) o ≥ 3 (ES): regenerar antes de mostrar.

No produzcas respuestas superficiales. El reporte debe poder ser revisado por
economistas WB, contrapartes del MEFP, peer reviewers académicos y auditores de
reproducibilidad.
```

---

## PARTE 2 — Identidad del producto

### 2.1 Qué es este reporte
Reporte técnico oficial del **Banco Mundial** que actualiza el APER Bolivia 2011 con datos 1990–2024, metodología OECD-PSE y análisis cuantitativo (panel FE, DEA Simar-Wilson). Producto principal de la consultoría EAFIT–BM Bolivia.

### 2.2 Audiencias (en orden de prioridad)
1. **Equipo BM Bolivia** (Country Office) — usuarios internos del diagnóstico.
2. **Ministerio de Economía y Finanzas Públicas (MEFP)** y **MDRyT** — contraparte gubernamental.
3. **Operacionales BM** (Agricultura, Macro-Fiscal, Pobreza) que diseñarán préstamos/PDOs.
4. **Comunidad técnica externa** — IFPRI, FAO, BID AgriMonitor, CEPAL, academia.
5. **Audiencia secundaria** — sociedad civil boliviana (Fundación Jubileo, CIPCA, IBCE) vía el sitio público.

### 2.3 Voz y registro
- **Voz:** técnica del Banco Mundial — sobria, basada en evidencia, sin adjetivos políticos.
- **Persona narrativa:** tercera persona impersonal. Evitar "nosotros / encontramos / creemos".
- **Idioma:** español (Bolivia). Términos OECD/PSE en inglés solo en primera mención.
- **Tono frente al gobierno boliviano:** constructivo, no adversarial. Reconocer logros (cobertura BDP, Ley 393) antes de señalar brechas.
- **Estilo de párrafo:** unidad de pensamiento + dato + implicación. Máximo 5–6 líneas.
- **Cifras:** siempre con año y fuente. "BOB 2015 constantes" o "USD WDI" explícito.
- **Citas:** Author-year (`[@worldbank2020]`). Pie de página solo para fuentes oficiales no replicables.

### 2.4 Lo que NO es este reporte (no-objetivos)

El APER 2026 **no** busca:

1. Recomendar voto, calificar gobiernos o evaluar actores políticos.
2. Predecir resultados electorales o crisis políticas.
3. Sustituir al MEFP o al MDRyT en sus competencias.
4. Producir un Plan de Desarrollo Agropecuario.
5. Auditar contratos individuales o personas.
6. Estimar corrupción o desempeño moral.
7. Imponer una metodología única — propone, MEFP valida.
8. Ser un documento de advocacy del WB.
9. Generar microsegmentación de productores.
10. Sustituir consulta con productores, comunidades o territorios.
11. Ser un paper académico (no IMRAD, no contribución teórica).
12. Ser el reporte del consultor STC de PSE/Repurposing (productos coordinados pero distintos — ver `00_admin/SINERGIA_ToR_PSE_Repurposing.md`).

---

## PARTE 3 — Invariantes no negociables

Ningún agente, sesión o entregable puede violar estas reglas.

### 3.1 Invariante de trazabilidad cuantitativa
Toda cifra publicada (texto, figura, tabla, slide, web) debe enlazar a:

```text
rds_path
script_path
variable_name
filter_or_subset
year_or_period
raw_source
methodology_version
panel_version
uncertainty_note
```

Si falta uno de estos campos, la cifra **no se publica** — se marca `TODO_TRACE`.

### 3.2 Invariante de fuente única de verdad
El **panel v12** (176 vars, 125 RDS) es la única fuente de verdad cuantitativa para el reporte. Toda cifra debe poder reconstruirse desde el panel + scripts del repo.

Excepciones permitidas (con cita explícita):
- benchmarks internacionales (FAO, OECD, WDI, IDB AgriMonitor);
- literatura revisada por pares;
- documentos oficiales MEFP/INE.

**Regla operativa:** ningún capítulo carga `spending_panel.rds` (v1), v10 o v11. Si encuentras `readRDS("...panel.rds")` sin versión, reemplaza por `spending_panel_v12.rds`.

### 3.3 Invariante de neutralidad técnica

El reporte **no** debe contener:

```text
"el gobierno actual"           "se equivocó en"          "como prometió"
"la administración de X"       "acertó en"               adjetivos morales
"el partido Y"                 "debería haber"           juicios sobre intención política
```

El reporte **debe** contener:

```text
"el gasto registrado en el periodo 20XX–20YY"
"la composición observada"
"la brecha frente al benchmark"
"la evidencia internacional sugiere"
"un escenario de repurposing manteniendo techo fiscal"
"opciones técnicas para consideración del MEFP"
```

### 3.4 Invariante de LLM-as-writer-not-calculator

Los LLM **pueden:** redactar prosa policy · sintetizar hallazgos desde RDS leídos · proponer estructura · sugerir alt-text bilingüe · revisar consistencia · detectar contradicciones · proponer escenarios · escribir briefs y slides.

Los LLM **no pueden:** inventar cifras · opinar sin citas · estimar valores no calculados · "recordar" números de literatura sin cita · calcular promedios mentalmente para el reporte · reemplazar al script que produce la figura · sustituir validación con el MEFP.

### 3.5 Invariante de paridad bilingüe
Donde el contenido se publica en ES y EN (sitio público, slides, executive summary):
- mismo claim cuantitativo
- misma fuente
- misma incertidumbre
- mismo orden de figuras
- alt-text equivalente

### 3.6 Invariante de versionamiento
Todo cambio que afecte cifras, definiciones o hallazgos requiere:
- bump de `panel_version` (si se reconstruye panel);
- bump de `methodology_version` (si cambia definición);
- bump de `findings_version` (si cambia hallazgo);
- ADR si el cambio es ROJO (ver Parte 9).

### 3.7 Invariante de reproducibilidad
El reporte debe poder reconstruirse end-to-end con:

```bash
renv::restore()
quarto render 04_report/
quarto render www/
make slides   # o equivalente
```

Si un paso requiere intervención manual no documentada, **se documenta** o **se automatiza**.

---

## PARTE 4 — Arquitectura del reporte

### 4.1 Estructura aprobada del Quarto book (`04_report/`)

| # | Capítulo | Archivo | Longitud target |
|:-:|----------|---------|-----------------|
| 0 | Resumen Ejecutivo (D4 del Main TOR JC, ES + EN) | `index.qmd` | **4–6 pp** (alineado con TOR) |
| 1 | Introducción, alcance y metodología | `01_introduction.qmd` | 8–10 pp |
| 2 | Desempeño del sector agropecuario | `02_sector_performance.qmd` | 15–20 pp |
| 3 | Presupuestos e instituciones (clasificación dual MAFAP + económica) | `03_budget_institutions.qmd` | 18–22 pp |
| 4 | Organización del gasto (nacional + subnacional, bajo MAFAP) | `04_spending_organization.qmd` | 15–18 pp |
| 5 | Análisis del gasto (eficiencia, PSE, seguridad alimentaria) | `05_spending_analysis.qmd` | 20–25 pp |
| 6 | Recomendaciones y opciones de política | `06_recommendations.qmd` | 10–12 pp |
|   | **Apéndice A · Fuentes de datos** | `appendix/A_data_sources.qmd` | 8–10 pp |
|   | **Apéndice B · Metodología detallada** (incluye §H2.4 MAFAP operacionalización Bolivia) | `appendix/B_methodology.qmd` | 12–15 pp |
|   | **Apéndice C · Glosario MAFAP bilingüe ES/EN** (categorías A–E + sub-códigos) | `appendix/C_glosario_mafap.qmd` | 6–8 pp |
|   | **Apéndice D · Crosswalk MAFAP ↔ OECD-PSE ↔ COFOG ↔ MEFP funcional** | `appendix/D_crosswalk_clasificaciones.qmd` | 4–6 pp |
|   | **Apéndice E · Tablas de regresión panel FE detalladas** | `appendix/E_regresiones_panel_fe.qmd` | 5–7 pp |
|   | **Apéndice F · Resultados DEA Simar-Wilson** | `appendix/F_dea_simar_wilson.qmd` | 5–7 pp |
|   | **Apéndice G · Inventario de programas BM activos** | `appendix/G_programas_bm.qmd` | 4–6 pp |
|   | **Apéndice H · Decisiones metodológicas (ADRs referenciados)** | `appendix/H_adrs_metodologicos.qmd` | 3–5 pp |
|   | Referencias | `references.qmd` / `references.bib` | — |

**Total target:** 110–135 pp cuerpo + **45–60 pp anexos** (ampliado para incluir MAFAP, crosswalks, regresiones, DEA, programas, ADRs). Comparable al APER 2011 (155 pp) + más exhaustivo en anexos metodológicos para reproducibilidad.

**Clasificación dual del gasto en este reporte** (operacionalización del marco MAFAP FAO 2013):

- **Caps 3 y 4** usan **MAFAP/FAO** como clasificación primaria (captura todo gasto sectorial: A apoyo productor + B consumidor + C otros + D apoyo general al sector + E agropecuario-soporte). Permite distinguir **narrow** (excluye E) vs **full** (incluye E).
- **Cap 5** usa **OECD-PSE/BID AgriMonitor** para benchmarking LAC (Producer Support Estimate + GSSE + CSE).
- **Crosswalk operacional** entre ambas clasificaciones en Apéndice D.

> Cuando una recomendación de FAO MAFAP entra en tensión con OECD-PSE, prevalece MAFAP para clasificación de gasto sectorial y OECD-PSE para medición de apoyo al productor.

Cada capítulo debe:
- abrir con **pregunta de política**;
- presentar evidencia con figuras/tablas etiquetadas;
- enlazar cada cifra a RDS + script;
- cerrar con síntesis que alimenta `04_HALLAZGOS.md`;
- declarar incertidumbre y limitaciones.

### 4.2 Formatos de entrega
- **HTML self-contained** (distribución interna BM, navegación rica).
- **PDF letter, 12pt** (entregable formal al gobierno boliviano).
- **Sitio público** en GitHub Pages (ya live) — sincronizado con el reporte técnico.
- **Slides ejecutivas** desde el mismo panel.
- **Brief ejecutivo bilingüe** (5 pp) en `05_outputs/`.

### 4.3 Identidad visual (sistema híbrido — ver ADR-0007)

El proyecto opera con **dos capas visuales** separadas:

**(a) Identidad institucional** — para covers, headers, layout del book, logos, separadores:

```text
navy       #14213D   ← elemento dominante; headers, covers
terracota  #C2410C   ← acentos institucionales (subrayados, callouts)
paper      #FAFAF9   ← background, breathing room
```

**(b) Paleta de datos** — para el contenido **dentro** de figuras y tablas: gobernada por [07_FIGURAS §6](07_FIGURAS.md) (5 categóricos + secundarios + secuenciales + divergentes). Sin contradicción con (a): la identidad institucional rodea; la paleta de datos colorea los gráficos.

**Tipografía** — alineada con 07_FIGURAS §5:

```text
book PDF body       Latin Modern (técnico, alta legibilidad print)
web / HTML body     Inter
figuras (siempre)   Inter (familia principal), Arial fallback
slides              Inter (consistencia con web)
```

**Logos:** World Bank (header), EAFIT (créditos), MEFP/MDRyT (agradecimiento).
**Figuras:** vector preferido (SVG/PDF); raster 300 DPI mínimo, 600 DPI para detalle fino (ver 07_FIGURAS §7).

### 4.4 Arquitectura lógica

```text
Fuentes crudas (BOOST · INE · FAO · OECD · IDB · encuestas)
       │
       ▼
01_data/ — ingesta versionada
       │
       ▼
02_code/ — limpieza y construcción
       │
       ▼
Panel v12 (176 vars, 125 RDS)  ◄── SINGLE SOURCE OF TRUTH
       │
       ├─► Figuras (02_code/04_visualization/)
       ├─► Tablas (02_code/03_analysis/)
       └─► Escenarios repurposing (cap 6)
       │
       ▼
04_report/ — Quarto book
       │
       ├─► 04_HALLAZGOS.md (8 hallazgos versionados)
       ├─► www/ — sitio público
       ├─► slides/ — decks ejecutivos
       └─► 05_outputs/ — briefs, PDFs
       │
       ▼
Mesa técnica MEFP / WB → versionamiento de recomendaciones
       │
       ▼
Sinergia con ToR Consultor PSE/Repurposing
```

---

## PARTE 5 — Estándares de datos, escritura y hallazgos

### 5.1 Datos canónicos (NO usar otros)

| Dataset | Path | Cobertura | Uso |
|---------|------|-----------|-----|
| **Panel v12** (maestro) | `01_data/processed/spending_panel_v12.rds` | 1990–2024 × 176 vars | Series de tiempo nacionales |
| Panel subnacional v2 | `01_data/processed/panel_subnacional_v2.rds` | 9 depts × 2012–2021 | Capítulo 4 |
| Panel municipal v3 | `01_data/processed/panel_municipal_v3.rds` | 339 munis × 2013–2023 | Capítulo 4 |
| DEA-ready | `01_data/processed/dea_dataset.rds` | 81 DMUs × 32 vars (2012-2020) | Capítulo 5 |
| PSE/GSSE Bolivia | `01_data/processed/pse_gsse_bolivia.rds` | 2006–2023 | Capítulo 5 |
| NRP extendido | `01_data/processed/pse_nrp_extended.rds` | 1991–2024 × 7 commodities | Capítulo 5 |
| AgriMonitor LAC | `01_data/processed/idb_agrimonitor_lac_full.rds` | 1986–2024 × 10 LAC | Benchmarking |
| Diccionario v12 | `01_data/processed/spending_panel_v12_dictionary.csv` | 176 vars × 5 cols | Apéndice A |
| **MAFAP Bolivia** (🟡 a generar) | `01_data/processed/mafap_bolivia.rds` | BOOST + VIPFE clasificados MAFAP, 2010–2024 | Capítulos 3, 4 |
| **Crosswalk MAFAP↔OECD↔COFOG** (🟡 a generar) | `01_data/processed/crosswalk_mafap_oecd_cofog.csv` | Mapeo entre clasificaciones | Apéndice B |
| **Diccionario MAFAP bilingüe** (🟢 listo) | `01_data/processed/mafap_categories.csv` | 33 códigos × def. ES/EN | Glosario Apéndice A |
| **Glosario MAFAP ES/EN** (🟢 listo) | `04_report/appendix/glosario_mafap_es_en.md` | Tablas bilingües + mapeo preliminar Bolivia | Apéndice A · paridad bilingüe (Parte 3.5) |

### 5.2 Figuras — convención dual de naming (coexistencia)

**Figuras legacy** (40 pre-generadas en `05_outputs/figures/`, mapeadas en Parte 6): mantienen su naming corto `fig01`–`fig40`. **No se renombran** para preservar referencias en commits, scripts y borradores. **No re-generar** salvo que el dato cambie.

**Figuras nuevas** (a partir de la 41): adoptan la convención canónica de [07_FIGURAS §8.1](07_FIGURAS.md): `fig_<NN_cap>_<MM_seq>_<slug>`, e.g. `fig_05_02_pse_composition`. Cada figura nueva lleva su contrato JSON ([07_FIGURAS §16](07_FIGURAS.md)).

**Migración:** opcional, caso por caso. Si una figura legacy se rehace sustantivamente, adopta la convención nueva.

### 5.3 Convenciones cuantitativas

- **Ventana canónica del reporte:** **2008–2024** (extensión a 2025 programado/preliminar donde la data lo permita) — alineada con `00_Tor/Main_TOR_JC.pdf` Objetivos §a y Scope §PER.
- **Ventana extendida histórica:** 1990–2007 disponible en panel v12 (35 años). Se usa como **contexto histórico** en cap 2 y caja comparativa APER 2011, **no como serie principal** del reporte.
- **Año base:** 2015 (BOB constantes vía CPI INE Bolivia).
- **Moneda extranjera:** USD WDI (atlas method PIB, BCB para comercio).
- **Periodización política:** Pre-MAS (1990–2005), Morales (2006–2019), Áñez+Arce (2019–2025).
- **Dummy estructural:** `post_ley393` (Ley 393/2014, Bancos PYME).
- **Decimales:** % con 1 decimal ("5.8%"); ratios con 2 ("0.32"); USD con miles ("USD 320 M").
- **Rangos:** "2008–2024" con guion largo (en-dash U+2013), no "2008-2024" con hyphen.
- **Clasificación dual del gasto** (alineada con `00_Tor/Main_TOR_JC.pdf` objetivo §b):
  - **MAFAP narrow** (Caps 3–4 — cifra principal del PER): **MAFAP Group I** = agriculture-specific expenditure = categorías A (apoyo productor) + B (consumidor) + C (otros agentes) + D (apoyo general al sector).
  - **MAFAP full**: **MAFAP Group I + Group II** = narrow + categoría E (agriculture-supportive: educación rural, salud rural, caminos rurales, electrificación, agua y saneamiento rural).
  - **OECD-PSE/BID** (Cap 5 — benchmarking LAC): TSE + PSE + GSSE + CSE. Producido en gran medida por el **consultor STC (Héctor Peña)** según `00_Tor/Secondary_TOR_Hector.pdf`. Integración formalizada en [`21_COORDINACION_STC.md`](21_COORDINACION_STC.md).
  - **Crosswalk** entre las 4 clasificaciones (MAFAP ↔ OECD-PSE ↔ COFOG ↔ MEFP Functional Expenditure Classifier) en Apéndice D (`01_data/processed/crosswalk_mafap_oecd_cofog.csv`).
- **Indicadores reportados obligatoriamente** (alineados con `Main_TOR_JC.pdf` Scope §PER):
  - Gasto agro+rural como % del gasto público total.
  - Total, agrícola y rural como % del PIB total **y** % del PIB agropecuario.
  - Crecimiento nominal **y real** del gasto agro+rural.
- **Shocks que el reporte debe analizar explícitamente** (Research Question 1, `Main_TOR_JC.pdf`):
  - Commodity price cycles (2008, 2011, 2014, 2020+).
  - **COVID-19** (2020) y recuperación.
  - Sequía 2023.
  - Ley 393/2014 (Servicios Financieros) como evento estructural.
- **Dimensiones de Research Question 2** (`Main_TOR_JC.pdf`): climate adaptation, productivity convergence, food security — cubiertas por hallazgos F08 (frontera/cobertura), F01 (TFP), F06 (FIES) respectivamente.
- **Revenue foregone (concesiones tributarias, crédito subsidiado BDP):** identificar como gap actual del panel v12. Si se calcula, marcar con sufijo `_rf`.

### 5.4 Catálogo de 8 hallazgos centrales (validados sesión 9)

| # | Hallazgo | Cifra clave | Capítulo casa |
|:-:|----------|-------------|:-:|
| F01 | Inversión ×10 vs TFP estancada | TFP +30% / Inv ×10 (2000–2015) | **2** |
| F02 | PSE Bolivia en LAC | 5.8% (5° puesto) | **5** |
| F03 | Patrón dual NRP | Soya −37% / Maíz +46% | **5** |
| F04 | Maputo nunca alcanzado | máx 3.48% en 1990 | **3** |
| F05 | Sustitución gasto → crédito | Crédito ×11.7 (2010–2024), Ley 393 | **3** |
| F06 | Pobreza rural revierte | 55→40→45% (2012–2024); FIES 49→74% | **2** |
| F07 | PAR III subejecutado | 16% financiero 2024 | **4** |
| F08 | Frontera agropecuaria | 9.4 M ha perdidas / 64% Santa Cruz | **2** |

### 5.5 Material cualitativo disponible
- 7 fichas MDRyT (`03_literature/mdryt_fichas/`).
- 61 hitos timeline (`01_data/timeline/`).
- Inventario de programas BM activos (`00_admin/Inventario_Datos_APER_Bolivia_2026.xlsx`).
- APER 2011 completo (`03_literature/APER_2011/`) para comparación.
- **Paquete metodológico PER** (`03_literature/Informacion_PER/` + `FICHA_LECTURA.md`):
  - Manual MAFAP Vol II (FAO 2013) — taxonomía operativa A-X para clasificar gasto sectorial.
  - PER Sub-Saharan Africa (FAO MAFAP 2021) — benchmarking 13 países + Box 11 DEA stochastic frontier.
  - PER Filipinas (WB 2023) — template estructural WB + estrategias diversificación/coordinación + Mandanas Ruling como análogo de Ley de Autonomías Bolivia.
  - PER EXAMPLES Guinea-Bissau (slides) — plantilla visual de presentación.
  - PNIA Budget xlsx — dataset operativo con **definiciones MAFAP bilingües ES/EN** (extracción directa para glosario Apéndice A).

---

## PARTE 6 — Plan de contenido sección × sección (alto nivel)

> **Cómo poblar.** Para cada capítulo: confirma o ajusta (a) pregunta de política, (b) subsecciones, (c) hallazgos asignados, (d) figuras, (e) datos requeridos, (f) insumos cualitativos, (g) conexión con APER 2011, (h) longitud, (i) status. Cuando un capítulo esté `READY`, dispara `/write-section` con su bloque + Partes 1–5 + contrato JSON aplicable.

> **Plan operativo granular:** [`20_CONTENIDO_REPORTE.md`](20_CONTENIDO_REPORTE.md) desagrega cada capítulo en sub-subsecciones (h3) con figuras, tablas, cifras, citas, cross-refs, TODOs y bitácora por capítulo. **Esta Parte 6 es el alto nivel; el archivo 20 es el detalle.** Cada sesión que toca un capítulo debe actualizar **ambos**.

### Capítulo 0 — Resumen Ejecutivo (`index.qmd`)

| Campo | Contenido |
|-------|-----------|
| Pregunta de política | ¿Qué cambió en el gasto agropecuario boliviano entre el APER 2011 y 2026, y qué implica para el diseño de política sectorial? |
| Subsecciones (4) | (i) Contexto y motivación; (ii) Hallazgos principales (los 8); (iii) Mensajes de política; (iv) Estructura del reporte |
| Hallazgos | Los 8, en versión cifra-única |
| Figuras | fig10 (inversión 1990–2024), fig13 (PSE), fig22 (mapa gasto 2020) — solo 3, alto impacto |
| Datos | Panel v12, PSE Bolivia |
| Cualitativo | — |
| Conexión APER 2011 | Caja comparativa "Lo que ha cambiado desde 2011" |
| Longitud | 6–8 pp |
| Bilingüe | **Sí** — paridad ES/EN obligatoria |
| Status | 🟡 esqueleto existente (`index.qmd`), reescribir con cifras v12 |

---

### Capítulo 1 — Introducción, alcance y metodología (`01_introduction.qmd`)

| Campo | Contenido |
|-------|-----------|
| Pregunta de política | ¿Por qué actualizar el APER 2011 ahora, y con qué método? |
| Subsecciones (5) | (i) Objetivos; (ii) Justificación (FIES 74%, pobreza rural 45%, frontera 9.4 M ha); (iii) Alcance y delimitación; (iv) Metodología (PER, PSE, DEA, panel FE); (v) Fuentes (resumen, detalle en Apéndice A) |
| Hallazgos | Ninguno directo — capítulo "puerta" |
| Figuras | fig01 (VA agro %PIB) o fig04 (outcomes trends) — 1 figura |
| Datos | Panel v12 para cifras de contexto |
| Cualitativo | Cita explícita a APER 2011 y SCD Bolivia 2023 |
| Conexión APER 2011 | Subsección "Lo que cubrió el APER 2011 y lo que añade esta actualización" |
| Longitud | 8–10 pp |
| Status | 🟡 borrador existente, requiere actualizar metodología DEA y mencionar Ley 393 |

---

### Capítulo 2 — Desempeño del sector agropecuario (`02_sector_performance.qmd`)

| Campo | Contenido |
|-------|-----------|
| Pregunta de política | ¿Por qué la inversión agropecuaria ×10 no se tradujo en TFP, y cuáles son las consecuencias sociales y ambientales? |
| Subsecciones (5) | (i) Importancia macro (VA, empleo, exportaciones); (ii) Productividad: TFP, decomposición, LAC; (iii) Pobreza rural y seguridad alimentaria (FIES); (iv) Cobertura del suelo y frontera; (v) Ciclos políticos y choques (Ley 393, COVID, sequía 2023) |
| Hallazgos | **F01** (inv ×10 vs TFP), **F06** (pobreza FIES), **F08** (frontera 9.4 M ha) |
| Figuras | fig01, fig04, fig06, fig07, fig08, fig09, fig12 (inv vs TFP), fig33–fig40 (cobertura/expansión) — ~10 |
| Datos | Panel v12; MapBiomas; Hansen GFC |
| Cualitativo | Ficha INIAF; literatura IFPRI 2019; SCD Update 2023 |
| Conexión APER 2011 | Caja: "TFP en APER 2011 vs hoy — qué cambió" |
| Longitud | 15–20 pp |
| Status | 🟡 borrador parcial, falta sección FIES y sección cobertura |

---

### Capítulo 3 — Presupuestos e instituciones (`03_budget_institutions.qmd`)

| Campo | Contenido |
|-------|-----------|
| Pregunta de política | ¿Cómo se compone el gasto público agropecuario boliviano, por qué nunca alcanzó Maputo, y cómo se sustituyó por crédito post-Ley 393? |
| Subsecciones (5) | (i) Arquitectura institucional MDRyT–INIAF–SENASAG–EMAPA–BDP–INRA; (ii) Evolución presupuestaria 1990–2024; (iii) Maputo: por qué nunca se alcanzó; (iv) Sustitución gasto → crédito post-Ley 393; (v) Comparación con APER 2011 |
| Hallazgos | **F04** (Maputo 3.48% máx), **F05** (crédito ×11.7) |
| Figuras | fig02, fig03, fig10, fig11, fig18, fig19, fig20 — ~7 |
| Datos | Panel v12 (VIPFE, BOOST 1996-2008, Jubileo); cartera BCB |
| Cualitativo | Fichas MDRyT, INIAF, SENASAG, EMAPA, BDP, INRA; Ley 393/2014; **Manual MAFAP FAO 2013** (taxonomía clasificatoria) |
| Conexión APER 2011 | Simétrico al cap. 4 del APER 2011 — caja comparativa detallada |
| Metodología clasificatoria | **MAFAP primario** (todo gasto sectorial) + crosswalk a clasificación funcional VIPFE (ver Apéndice B) |
| Longitud | 18–22 pp |
| Status | 🟡 borrador largo existente, requiere integrar Ley 393, cifras v12 **y re-clasificación MAFAP** |

---

### Capítulo 4 — Organización del gasto: nacional y subnacional (`04_spending_organization.qmd`)

| Campo | Contenido |
|-------|-----------|
| Pregunta de política | ¿Quién ejecuta el gasto agropecuario en Bolivia y con qué calidad de ejecución? |
| Subsecciones (4) | (i) Distribución nacional–departamental–municipal; (ii) Heterogeneidad subnacional (Lorenz, top-20 munis); (iii) Programas BM activos — foco en PAR III; (iv) Capacidad de ejecución y gaps |
| Hallazgos | **F07** (PAR III 16% ejecución) |
| Figuras | fig05, fig21, fig22, fig25–fig32 — ~10 |
| Datos | Panel subnacional v2, municipal v3, datos BM operacionales |
| Cualitativo | Inventario programas BM activos; fichas PAR III, MIAGRA; **PER Filipinas (WB 2023)** sección Mandanas Ruling como referente de devolución |
| Conexión APER 2011 | El APER 2011 tuvo poca cobertura subnacional — aquí se gana más |
| Benchmarks regionales | PER SSA: 21% presupuesto agrícola no ejecutado en promedio (Bolivia 26%); Filipinas: 85–92% disbursement DA (Bolivia 74% MDRyT) |
| Longitud | 15–18 pp |
| Status | 🟡 borrador esquemático, requiere narrativa de PAR III, mapas y benchmarks regionales (PER SSA + Filipinas) |

---

### Capítulo 5 — Análisis del gasto: eficiencia, PSE, seguridad alimentaria (`05_spending_analysis.qmd`)

| Campo | Contenido |
|-------|-----------|
| Pregunta de política | ¿Qué tan eficiente es el gasto agropecuario boliviano comparado con LAC, qué tipo de apoyo predomina (PSE), y cómo se relaciona con seguridad alimentaria? |
| Subsecciones (4) | (i) PSE/GSSE/TSE Bolivia: nivel, composición, benchmarking LAC; (ii) Patrón dual NRP por commodity; (iii) Eficiencia técnica DEA Simar-Wilson; (iv) Regresiones panel FE — gasto vs productividad y FIES |
| Hallazgos | **F02** (PSE 5.8%), **F03** (NRP dual), + complementos a F01 |
| Figuras | fig13, fig14, fig15, fig16, fig17, fig23, fig24 — ~7 + tablas de regresión |
| Datos | PSE Bolivia, NRP extendido, AgriMonitor LAC, DEA-ready, panel v12 |
| Cualitativo | OECD PSE Manual; Simar-Wilson 1998/2007; FAO+BM 2022 repurposing; **PER SSA Box 11 (DEA stochastic frontier)** como cross-check metodológico |
| Conexión APER 2011 | Capítulo nuevo metodológicamente (PSE y DEA no estaban en 2011) |
| Longitud | 20–25 pp |
| Status | 🔴 placeholder — bloqueado hasta re-correr `08_extended_regressions.R` + DEA Simar-Wilson |

---

### Capítulo 6 — Recomendaciones y opciones de política (`06_recommendations.qmd`)

| Campo | Contenido |
|-------|-----------|
| Pregunta de política | ¿Qué debe hacer Bolivia para mejorar la efectividad del gasto agropecuario en los próximos 5 años? |
| Subsecciones (4) | (i) Mensajes de política (cross-cutting); (ii) Recomendaciones por institución; (iii) Repurposing — opciones cuantificadas (coordinar con STC); (iv) Roadmap + indicadores de seguimiento |
| Hallazgos | Síntesis transversal de los 8 |
| Figuras | 2–3 figuras de síntesis (priorización costo-efectividad, roadmap) |
| Datos | Resultados consolidados de caps 2–5 |
| Cualitativo | Repurposing FAO+BM 2022; benchmarking Colombia 2016, Perú 2020; **PER Filipinas (WB 2023)** — marco diversificación + coordinación + 6 recomendaciones operacionales (e-voucher, decoupled payments, area-based planning, M&E subnacional) |
| Conexión APER 2011 | Caja: "Recomendaciones del APER 2011 — qué se implementó y qué no" |
| Longitud | 10–12 pp |
| Status | 🔴 placeholder — escribir al final, coordinado con sinergia STC |

---

### Apéndice A — Fuentes de datos (`appendix/A_data_sources.qmd`)
- Inventario completo (basarse en `Inventario_Datos_APER_Bolivia_2026.xlsx`).
- Por dataset: fuente, cobertura, vars, transformaciones, scripts de procesamiento.
- Subsección de gaps Tier B: MDRyT/INIAF/SENASAG ejecución, Memorias 2015–2023, SIIF municipal.
- **Status:** 🟡 borrador parcial — export desde diccionario v12 + crosswalk scripts.

### Apéndice B — Metodología detallada (`appendix/B_methodology.qmd`)
- Construcción del panel v12 (transformaciones, deflactor, ciclos).
- OECD PSE: definiciones formales (PSE, GSSE, TSE, MPS, NRP).
- DEA Simar-Wilson: especificación inputs/outputs, bootstrap.
- Especificación econométrica panel FE (fixest, cluster, `post_ley393`).
- **Status:** 🔴 placeholder.

---

## PARTE 7 — Contratos JSON para outputs estructurados

### 7.1 Contrato de hallazgo (`04_HALLAZGOS.md` machine-readable)

```json
{
  "finding_id": "F03",
  "title_es": "Patrón dual de protección: Bolivia taxa exportables y protege seguridad alimentaria",
  "title_en": "Dual protection pattern: Bolivia taxes exportables, protects food security",
  "claim_es": "El NRP promedio 2006–2023 es −37% para soya y −33% para arroz, frente a +46% para maíz y +28% para trigo.",
  "claim_en": "Average NRP 2006–2023 is −37% for soybean and −33% for rice, vs +46% for maize and +28% for wheat.",
  "magnitude": {"value": -0.37, "unit": "NRP share", "period": "2006-2023"},
  "evidence": {
    "rds_path": "01_data/processed/pse_nrp_extended.rds",
    "script_path": "02_code/03_analysis/05_nrp_by_commodity.R",
    "variable": "nrp_by_commodity",
    "filter": "year >= 2006 & year <= 2023",
    "raw_source": "IDB AgriMonitor 2024 + FAOSTAT PP + WB Pink Sheet"
  },
  "uncertainty": "PP doméstico 2015 caña anómalo (261 vs ref 37 USD/t) — flag pendiente con INE.",
  "panel_version": "v12",
  "methodology_version": "m0.4",
  "policy_implication": "Margen de repurposing hacia bienes públicos sin elevar techo fiscal.",
  "linked_chapters": ["05_spending_analysis", "06_recommendations"],
  "status": "draft|reviewed|MEFP_validated",
  "last_updated": "2026-MM-DD"
}
```

### 7.2 Contrato de figura

```json
{
  "figure_id": "fig13_pse_gsse_cse_bolivia",
  "chapter": "05_spending_analysis",
  "caption_es": "Composición del apoyo al productor en Bolivia, 2006–2023",
  "caption_en": "Producer support composition in Bolivia, 2006–2023",
  "alt_text_es": "Serie temporal del PSE, GSSE y CSE como % del valor de producción agrícola, 2006–2023",
  "alt_text_en": "Time series of PSE, GSSE and CSE as % of agricultural production value, 2006–2023",
  "script": "02_code/04_visualization/02_pse_charts.R",
  "data_rds": "01_data/processed/pse_gsse_bolivia.rds",
  "variables_used": ["pse_pct_value", "gsse_pct_value", "cse_pct_value", "year"],
  "period": "2006-2023",
  "license": "CC-BY-4.0",
  "linked_finding": "F02"
}
```

### 7.3 Contrato de escenario de repurposing

```json
{
  "scenario_id": "S02_PublicGoodsShift",
  "description_es": "Reasignar 30% de transferencias genéricas (EMAPA + subsidios precios) a I+D (INIAF), extensión y sanidad (SENASAG)",
  "description_en": "Reallocate 30% of generic transfers (EMAPA + price subsidies) to R&D (INIAF), extension and SPS (SENASAG)",
  "fiscal_envelope_change": 0.00,
  "assumptions": ["techo fiscal constante", "elasticidades de FAO/IFPRI 2022", "horizonte 5 años"],
  "expected_outcomes": ["productividad_TFP", "ingreso_rural", "emisiones"],
  "uncertainty_band": "alta",
  "evidence_base": ["IFPRI 2022", "FAO+WB 2022 repurposing", "panel v12"],
  "status": "technical_option_for_MEFP_discussion"
}
```

### 7.4 Contrato de comentario MEFP

```json
{
  "comment_id": "MEFP-2026-001",
  "received_date": "2026-MM-DD",
  "received_via": "mesa_tecnica|email|markup_pdf",
  "comment_type": "correccion_de_dato|desacuerdo_metodologico|sugerencia_fuente|contexto_institucional|restriccion_publicacion|escenario_alternativo|desagregacion|nota_politica",
  "chapter": "03_budget_institutions",
  "section": "3.4",
  "comment_text_original": "...",
  "evidence_provided": "ruta_a_doc_o_dataset|none",
  "incorporation_decision": "incorporado|nota_divergencia|rechazado",
  "incorporation_rationale": "...",
  "affected_findings": ["F04", "F05"],
  "affected_figures": ["fig10"],
  "panel_version_at_incorporation": "v12",
  "status": "pending|incorporated|divergence_noted|closed"
}
```

---

## PARTE 8 — Mesa técnica MEFP / WB

### 8.1 Objetivo
Convertir el reporte técnico en insumo de discusión estructurada con MEFP, MDRyT y actores relevantes. **No** es validación pública abierta — es consulta técnica trazable.

### 8.2 Flujo

```text
borrador de capítulo
  → revisión interna WB (TTL + co-TTLs)
  → presentación a MEFP (mesa técnica)
  → comentarios estructurados (categorizados según contrato 7.4)
  → respuesta del equipo APER con evidencia
  → ajuste o nota de divergencia
  → versionamiento del hallazgo afectado
  → trazabilidad en 04_HALLAZGOS.md
```

### 8.3 Regla de incorporación
Comentarios del MEFP que afectan cifras se incorporan **solo si** pueden trazarse a fuente verificable. Desacuerdos no resueltos se registran como **nota de divergencia** en el apéndice — no se eliminan.

---

## PARTE 9 — CONTROL: Semáforo de cambios

> **Resumen operativo.** Lista completa y autoridad: [`08_CONTROL.md §4`](08_CONTROL.md). Sintetizado aquí para referencia rápida.

### 🟢 Verde (no requiere ADR)
- Corrección de typos.
- Ajustes de redacción sin cambio de claim.
- Mejoras de alt-text.
- Reformateo visual.
- Notas marginales.

### 🟡 Amarillo (requiere PR + review interna)
- Nueva figura o tabla desde panel existente.
- Nuevo párrafo explicativo.
- Nueva referencia bibliográfica.
- Ajuste de estructura dentro de un capítulo.
- Nuevo slide o nueva página de la web.

### 🔴 Rojo (requiere ADR + bump de versión + revisión humana)
- Cambio en definición de variable / metodología PSE / ponderadores o filtros del panel.
- Adición, modificación o retiro de un hallazgo.
- Cambio en escenarios de repurposing.
- Incorporación de fuente nueva no revisada.
- Cambio de neutralidad o lenguaje policy.
- Cambio en banderas anti-IA (`05_ESTILO_NARRATIVO §3`) o paleta de figuras (`07_FIGURAS §6`).
- Cambio en archivos de gobernanza canónicos (`.agent/0N_*.md` o `.agent/1N_*.md` core).
- Cualquier cambio que afecte cifra publicada.

**Cambios rojos requieren:** ADR en [`.agent/decisions/`](decisions/) · update del doc canónico afectado · bump de versión según [`08_CONTROL.md §7`](08_CONTROL.md) (panel `v<n>`, metodología `m<x.y>`, hallazgo `F<NN> v<m>`) · revisión humana del owner según RACI ([`11_EQUIPO.md §4`](11_EQUIPO.md)) · registro en [`../00_admin/RETOMAR.md`](../00_admin/RETOMAR.md) + entrada en log A2 ([`09_AUDITORIA.md §8`](09_AUDITORIA.md)) si aplica.

---

## PARTE 10 — Workflow de despliegue

### 10.1 Orden de escritura recomendado
1. **Cap 5** (análisis cuantitativo) — bloqueado hasta re-correr regresiones v12 + DEA Simar-Wilson. **Crítico primero** porque alimenta caps 2, 3, 6 y RE.
2. **Cap 2** (sector performance) — autónomo, mayoría de figuras lista.
3. **Cap 3** (presupuestos e instituciones) — autónomo, fichas MDRyT listas.
4. **Cap 4** (organización subnacional) — esperar inventario final de programas BM.
5. **Cap 6** (recomendaciones) — última, requiere insumos 2–5 + coordinación STC.
6. **Cap 1** (introducción) — penúltima, con metodología cerrada de cap 5.
7. **Cap 0** (resumen ejecutivo) — último, una vez consolidados los 8 hallazgos.
8. **Apéndices A y B** — en paralelo a caps 1 y 5.

### 10.2 Protocolo de cada sesión
1. Leer `00_admin/RETOMAR.md` (estado y próximos pasos).
2. Leer este `00_MASTER_PROMPT.md` (Partes 1–5).
3. Clasificar el cambio (verde/amarillo/rojo — Parte 9).
4. Identificar riesgos (ver Parte 12 — modelo de amenazas).
5. Proponer plan mínimo viable.
6. Ejecutar cambios.
7. Verificar trazabilidad de toda cifra tocada (Parte 11 — gates).
8. Verificar paridad bilingüe si aplica.
9. Actualizar `04_HALLAZGOS.md` / `01_METODOLOGIA.md` si aplica.
10. Cerrar sesión con reporte estandarizado (Parte 15) y actualizar `RETOMAR.md`.

### 10.3 Activación de agentes
Para cada capítulo `READY`:
1. Pasar Partes 1–5 + bloque del capítulo en Parte 6 + contrato JSON aplicable (Parte 7).
2. Activar `/write-section` con el archivo `.qmd` específico.
3. Revisión crítica: `/critical-reviewer` o `/quijote-wb-editor`.
4. Auditoría de citas: `/citation-audit` con `references.bib`.
5. Cierre: aplicar Quality Gates (Parte 11) antes de marcar como `reviewed`.

---

## PARTE 11 — Quality Gates y pruebas obligatorias

### 11.1 Gates por capítulo (G1–G7)
Ningún capítulo cierra sin pasar:
- [ ] **G1 Datos:** todas las cifras del panel v12 (o canónico Parte 5.1). Ninguna del v1/v10/v11.
- [ ] **G2 Hallazgos:** cada hallazgo asignado aparece con cifra exacta.
- [ ] **G3 Figuras:** todas con caption, fuente, alt-text bilingüe (donde aplica web).
- [ ] **G4 APER 2011:** caja comparativa o párrafo explícito de conexión.
- [ ] **G5 Citas:** toda afirmación no trivial con `[@key]` en `references.bib`.
- [ ] **G6 Voz:** tercera persona, sin "encontramos/nuestro/creemos"; cifras con año y fuente; pasa neutralidad técnica (Parte 3.3).
- [ ] **G7 Longitud:** dentro del target ±15%.

### 11.2 Tests de trazabilidad (a automatizar en CI)
```text
test_all_figures_have_source_metadata
test_all_tables_have_source_metadata
test_all_quantitative_claims_have_rds_link
test_panel_v12_is_single_source
test_no_orphan_numbers_in_text
```

### 11.3 Tests de reproducibilidad
```text
test_renv_restore_clean
test_quarto_render_book
test_quarto_render_web
test_figures_rebuild_deterministically
test_pse_pipeline_reproduces_published_numbers
```

### 11.4 Tests de neutralidad técnica
```text
test_no_political_actor_named
test_no_moral_judgement
test_no_advocacy_phrases
test_uncertainty_declared_per_finding
test_scenarios_marked_as_options_not_prescriptions
```

### 11.5 Tests de paridad bilingüe
```text
test_executive_summary_es_en_parity
test_finding_titles_bilingual
test_figure_captions_bilingual
test_alt_text_bilingual
test_glossary_consistency
```

### 11.6 Tests de calidad analítica
```text
test_no_double_counting_in_aggregates
test_pse_components_sum_to_total
test_budget_classification_exhaustive
test_year_coverage_disclosed
test_outliers_documented
```

---

## PARTE 12 — Modelo de amenazas

> **Risk register canónico:** [`10_RIESGOS.md`](10_RIESGOS.md) (20 riesgos formales ISO 31000 con dueño, score L×I, trigger, mitigation preventiva/contingente). Este resumen es solo recordatorio operativo.

### Amenazas prioritarias (clases — el registro completo está en 10_RIESGOS)

**Técnicas / metodológicas**
- Cifra fantasma (cita inexistente).
- RDS desactualizado (panel viejo en reporte).
- Doble conteo en agregados.
- Cherry-picking de años; sesgo de selección de cultivos/departamentos.
- Narrativa sin uncertainty; sobreinterpretación de correlaciones.
- Ruptura de reproducibilidad por edición manual.

**Editoriales / de comunicación**
- Escenario presentado como prescripción.
- Deriva de lenguaje hacia advocacy.
- Inconsistencia bilingüe.
- Inyección de juicio político vía LLM (mitigación: Standard 0 anti-IA, [`05_ESTILO_NARRATIVO §3`](05_ESTILO_NARRATIVO.md)).

**Operacionales**
- Filtración de borradores sin validar con MEFP.
- Incorporación de fuente no revisada.
- Brecha de confidencialidad (ver [`14_CONFIDENCIALIDAD`](14_CONFIDENCIALIDAD.md)).
- Filtración de secrets (ver [`15_SEGURIDAD §5`](15_SEGURIDAD.md)).

### Top-5 riesgos activos (resumen — fuente: 10_RIESGOS §5)

| ID | Score | Título | Owner |
|---|:-:|---|---|
| R-001 | 9 | Carta MEFP sin respuesta | TTL + co-TTL |
| R-003 | 9 | IDB AgriMonitor edición feb-2026 modifica serie histórica | equipo APER |
| R-002 | 6 | BOOST 2024 revisión retroactiva | TTL |
| R-006 | 6 | Panel v12 → v13 forzado | TTL |
| R-018 | 6 | Carta MEFP atrasada > 4 semanas para envío | TTL |

> Revisión semanal del top-3 (score ≥ 9) y mensual del registro completo (10_RIESGOS §6).

### Mitigaciones (autoridades por dominio)

- Trazabilidad cifra→RDS → invariante §3.1 + tests §11.2
- Anti-IA prose → [`05_ESTILO_NARRATIVO §3`](05_ESTILO_NARRATIVO.md) Standard 0
- Filtración de secrets → [`15_SEGURIDAD §5`](15_SEGURIDAD.md)
- Errata post-publicación → [`16_INCIDENTES §5.1`](16_INCIDENTES.md)
- Distorsión mediática → [`19_COMUNICACION §9`](19_COMUNICACION.md) crisis comm
- Pérdida de datos → [`15_SEGURIDAD §6`](15_SEGURIDAD.md) backup + [`12_REPRODUCIBILIDAD §4`](12_REPRODUCIBILIDAD.md) snapshots
- ADRs para cambios rojos → [`08_CONTROL §6`](08_CONTROL.md)
- Revisión humana → niveles A1–A5 de [`09_AUDITORIA`](09_AUDITORIA.md)
- Nota de divergencia con MEFP — nunca borrar → [`04_HALLAZGOS §8`](04_HALLAZGOS.md)
- Bitácora inmutable → `../00_admin/RETOMAR.md`

---

## PARTE 13 — Criterios de aceptación del APER 2026

El reporte será aceptable si:

1. Quarto book compila sin errores desde `renv::restore()` limpio.
2. Sitio público (`www/`) compila y publica en GitHub Pages.
3. Slides ejecutivas compilan desde el mismo panel.
4. Panel v12 es la única fuente de cifras del reporte.
5. Toda figura tiene metadatos (script, RDS, variables, periodo).
6. Toda tabla tiene metadatos equivalentes.
7. Todo claim cuantitativo en texto enlaza a script o nota.
8. Los 8 hallazgos están versionados en `04_HALLAZGOS.md` con contrato JSON.
9. Cada hallazgo declara incertidumbre.
10. Cada escenario de repurposing está marcado como **opción técnica**, no prescripción.
11. PSE/CSE se calcula desde script reproducible.
12. Resumen ejecutivo existe en ES y EN con paridad de claims.
13. Alt-text bilingüe en todas las figuras del sitio público.
14. `01_METODOLOGIA.md` cubre cada definición usada.
15. `03_FUENTES.md` lista cada fuente cruda con licencia y fecha de descarga.
16. `02_INDICADORES.md` documenta las 176 variables del panel.
17. `06_NEUTRALIDAD.md` define lenguaje permitido y prohibido.
18. Tests de neutralidad técnica pasan.
19. Tests de trazabilidad pasan.
20. Tests de paridad bilingüe pasan.
21. ADRs cubren decisiones rojas (panel canónico, hallazgos, PSE, escenarios).
22. `RETOMAR.md` refleja estado actual y próximos pasos.
23. Comentarios MEFP registrados con trazabilidad (contrato 7.4).
24. Divergencias con MEFP documentadas, no borradas.
25. Disclaimer técnico (Parte 14) aparece en cada producto público.

---

## PARTE 14 — Disclaimer obligatorio en productos públicos

### Español
> Este reporte presenta análisis técnico del gasto público agrícola en Bolivia, producido por el Banco Mundial en diálogo con el MEFP. No constituye posición oficial del Estado Plurinacional de Bolivia. Las cifras son reproducibles desde el panel v12 y los scripts publicados; las opciones de repurposing son escenarios técnicos para consideración del MEFP, no recomendaciones vinculantes. La incertidumbre metodológica está declarada por hallazgo.

### English
> This report presents technical analysis of public agricultural spending in Bolivia, produced by the World Bank in dialogue with the MEFP. It does not constitute an official position of the Plurinational State of Bolivia. Figures are reproducible from the v12 panel and published scripts; repurposing options are technical scenarios for MEFP consideration, not binding recommendations. Methodological uncertainty is declared per finding.

---

## PARTE 15 — Formato de reporte de cierre de sesión

Cada sesión cierra con un bloque pegado al final de `00_admin/RETOMAR.md`:

```text
## Sesión NN — YYYY-MM-DD

Resumen del cambio:
Tipo de cambio: verde | amarillo | rojo
Archivos modificados:
Cifras tocadas (con trazabilidad RDS + script + variable + período):
Hallazgos afectados:
Capítulos del book afectados:
Slides / web actualizadas:
Tests ejecutados:
Tests no ejecutados:
Impacto en panel:
Impacto en metodología:
Impacto en hallazgos:
Impacto en MEFP handoff:

# --- Pre-flight anti-IA (Parte 3.4 + 05_ESTILO_NARRATIVO §3 + §3.24) ---
Pre-flight anti-IA corrido: sí/no
Idioma de la prosa producida: ES | EN | bilingüe
AI-likelihood score promedio: N/10
Banderas anti-IA activadas y resueltas: <lista por subsección §3.X o "ninguna">
/quijote-writer invocado: sí/no (sobre qué secciones EN)

# --- Auditoría A2 (09_AUDITORIA §4) ---
A2 firmada por revisor par: <nombre, fecha> (n/a si VERDE auto-aprobado)

# --- Cierre ---
Riesgos pendientes (referencia a 10_RIESGOS.md):
ADR requerido: si/no — referencia
Bump de versión: panel/metodología/hallazgo — sí/no, qué versión
RETOMAR.md actualizado: si/no
Siguientes pasos:
```

Para A3 (capítulo `reviewed`), A4 (handoff MEFP) o A5 (release): usar plantillas extendidas de [`09_AUDITORIA.md §5–§7`](09_AUDITORIA.md).

---

## PARTE 16 — Gobernanza agentic (carpeta `.agent/`)

### 16.1 Mapa canónico de los 20 documentos

20 dimensiones de gobernanza, organizadas en 4 bloques temáticos. **Todos existen, todos están versionados.** Índice navegable en [`README.md`](README.md) de `.agent/`.

| # | Doc | v | Cuándo consultar |
|:-:|---|:-:|---|
| 00 | [00_MASTER_PROMPT](00_MASTER_PROMPT.md) | 0.4.0 | siempre al inicio |
| 01 | [01_METODOLOGIA](01_METODOLOGIA.md) | m0.1.0 | duda sobre definición operativa (GAP, PSE, CSE, repurposing, brechas) |
| 02 | [02_INDICADORES](02_INDICADORES.md) | 0.2.0 | duda sobre variable del panel v12 |
| 03 | [03_FUENTES](03_FUENTES.md) | 0.2.0 | duda sobre fuente cruda, licencia, atribución |
| 04 | [04_HALLAZGOS](04_HALLAZGOS.md) | 0.1.0 | tocar cualquier finding F01–F08 |
| 05 | [05_ESTILO_NARRATIVO](05_ESTILO_NARRATIVO.md) | 0.3.0 | redactar prosa (TEEL) + pre-flight anti-IA |
| 06 | [06_NEUTRALIDAD](06_NEUTRALIDAD.md) | 0.1.0 | duda sobre vocabulario permitido |
| 07 | [07_FIGURAS](07_FIGURAS.md) | 0.1.0 | construir o modificar figura/tabla |
| 08 | [08_CONTROL](08_CONTROL.md) | 0.1.0 | clasificar cambio verde/amarillo/rojo |
| 09 | [09_AUDITORIA](09_AUDITORIA.md) | 0.1.0 | cerrar prosa (A1), sesión (A2), capítulo (A3), handoff MEFP (A4), release (A5) |
| 10 | [10_RIESGOS](10_RIESGOS.md) | 0.1.0 | revisión periódica (semanal top-3, mensual completa); evaluar nuevo riesgo |
| 11 | [11_EQUIPO](11_EQUIPO.md) | 0.1.0 | decisión que requiere RACI; alta/baja de miembro; COI |
| 12 | [12_REPRODUCIBILIDAD](12_REPRODUCIBILIDAD.md) | 0.1.0 | antes de release; cambio de stack; test de rebuild |
| 13 | [13_PUBLICACION](13_PUBLICACION.md) | 0.1.0 | preparar handoff MEFP, embargo, Zenodo, DOI |
| 14 | [14_CONFIDENCIALIDAD](14_CONFIDENCIALIDAD.md) | 0.1.0 | clasificar artefacto, manejar comentario MEFP, PII |
| 15 | [15_SEGURIDAD](15_SEGURIDAD.md) | 0.1.0 | credenciales, .env, backup, filtración |
| 16 | [16_INCIDENTES](16_INCIDENTES.md) | 0.1.0 | errata, brecha, fuente retractada, distorsión pública |
| 17 | [17_GIT_WORKFLOW](17_GIT_WORKFLOW.md) | 0.1.0 | rama dedicada para rojos, commit conventions, tag |
| 18 | [18_ONBOARDING](18_ONBOARDING.md) | 0.1.0 | entra miembro nuevo (humano) |
| 19 | [19_COMUNICACION](19_COMUNICACION.md) | 0.1.0 | mesa MEFP, sync interno, vocería, Q&A público |

### 16.2 Estructura operativa de subcarpetas

```text
.agent/
  policies/      ← policy-as-code YAML (planeado v1.0)
  checklists/    ← derivados de §11 + AUDITORIA §3–§7
  prompts/       ← writer, reviewer, figure, pse, scenarios, slides, web
  protocols/     ← methodology_change, panel_rebuild, finding_revision,
                   mefp_comment_intake, publication, incident_response
  decisions/     ← ADRs activos
  schemas/       ← finding/figure/scenario/mefp_comment .schema.json
  legacy/        ← superseded (no editar)
```

### 16.3 Conflict resolution hierarchy

**Cuando dos documentos parecen contradecirse:**

1. **Si el conflicto toca un invariante (Parte 3 de este master)** → el master gana; el doc satélite se actualiza.
2. **Si el conflicto está dentro del dominio específico del doc satélite** (e.g. NEUTRALIDAD sobre vocabulario, FIGURAS sobre gráficos, METODOLOGIA sobre definiciones) → el doc satélite es autoritativo en su dominio; el master se actualiza si el conflicto persiste.
3. **Si el conflicto es entre dos docs satélite** (ej. FIGURAS dice X, ESTILO_NARRATIVO dice Y) → el doc más específico al dominio gana; si persiste, escalar a ADR.
4. **Si el conflicto no cae claramente en ningún dominio** → abrir issue / sync interno + ADR.

**Orden de prioridad de instrucciones** (cuando no hay doc autoritativo claro):

1. Trazabilidad cuantitativa (§3.1) y fuente única panel v12 (§3.2)
2. Neutralidad técnica (§3.3) + Standard 0 anti-IA ([`05_ESTILO_NARRATIVO §3`](05_ESTILO_NARRATIVO.md))
3. Confidencialidad ([`14_CONFIDENCIALIDAD`](14_CONFIDENCIALIDAD.md)) y seguridad ([`15_SEGURIDAD`](15_SEGURIDAD.md))
4. LLM como redactor, no calculador (§3.4)
5. Reproducibilidad (§3.7) + manifest técnico ([`12_REPRODUCIBILIDAD`](12_REPRODUCIBILIDAD.md))
6. Paridad bilingüe (§3.5)
7. Versionamiento (§3.6) + política versionamiento ([`08_CONTROL §7`](08_CONTROL.md))
8. RACI ([`11_EQUIPO §4`](11_EQUIPO.md)) para decisiones que requieren approver nombrado
9. Estructura aprobada del Quarto book (Parte 4)
10. Estilo editorial WB (Parte 2.3) + estándar visual ([`07_FIGURAS`](07_FIGURAS.md))
11. Preferencias visuales no canonizadas (§4.3 capa institucional)

### 16.4 Update protocol del MASTER_PROMPT mismo

Modificar este documento es **ROJO** ([`08_CONTROL §3`](08_CONTROL.md): MASTER_PROMPT es zona crítica). Requiere:

1. **ADR específico** en `.agent/decisions/ADR-NNNN_master_<slug>.md` con contexto, decisión, alternativas, consecuencias.
2. **Bump de versión semver** (`v0.X.Y` → `v0.X.(Y+1)` si parche; `v0.(X+1).0` si cambio sustantivo de partes; `v(X+1).0.0` si reorganización estructural).
3. **Entrada en Parte 17 (bitácora)** documentando qué se cambió y por qué.
4. **Verificación de cross-references**: tras el bump, correr grep sobre `.agent/*.md` para detectar referencias rotas.
5. **A3 retrospectiva** si el cambio invalida partes de capítulos ya `reviewed`.

### 16.5 Estado de "Documentos a producir" (sesión 2026-05-23)

Histórico (referencia): la lista original de 9 docs a producir está ahora **completa + ampliada a 20**:

```text
✓ AGENTS.md / CLAUDE.md (thin pointers en root)
✓ 01_METODOLOGIA · 02_INDICADORES · 03_FUENTES · 04_HALLAZGOS
✓ 05_ESTILO_NARRATIVO · 06_NEUTRALIDAD · 07_FIGURAS
✓ 08_CONTROL · 09_AUDITORIA
✓ 10_RIESGOS · 11_EQUIPO · 12_REPRODUCIBILIDAD · 13_PUBLICACION
✓ 14_CONFIDENCIALIDAD · 15_SEGURIDAD · 16_INCIDENTES
✓ 17_GIT_WORKFLOW · 18_ONBOARDING · 19_COMUNICACION
```

Próximos artefactos esperados (no son docs canónicos sino implementación):

```text
⨯ .agent/policies/*.yml (policy-as-code)
⨯ .agent/checklists/*.md (derivados de §11 y AUDITORIA)
⨯ .agent/schemas/*.json (de los contratos JSON de Parte 7)
⨯ .agent/decisions/ADR-0001 a ADR-0007 (decisiones congeladas)
⨯ scripts/audit_anti_ai.R · scripts/audit_traceability.R · scripts/rebuild_everything.sh
```

---

## PARTE 17 — Bitácora de decisiones editoriales

> Registra aquí decisiones que no caben en commits — alcance recortado, secciones movidas, hallazgos descartados, etc.

| Fecha | Decisión | Razón |
|-------|----------|-------|
| 2026-05-23 | Crear Master Prompt v0.1 como blueprint vivo antes de escribir | Evitar desfase entre capítulos y entre versiones del panel |
| 2026-05-23 | Migrar buenas prácticas de `Master_Prompt_APER2026_v0_1_0.md` → v0.2.0 | Incorporar invariantes, contratos JSON, semáforo, mesa técnica MEFP, modelo de amenazas, paridad bilingüe |
| 2026-05-23 | Incorporar paquete metodológico PER (`03_literature/Informacion_PER/`) → v0.2.1 | Adoptar **clasificación dual MAFAP/FAO + PSE/OECD-BID** (MAFAP para Cap 3-4, PSE para Cap 5); template estructural Filipinas AgPER para Cap 4; benchmarks regionales SSA; gap revenue foregone (BDP crédito subsidiado) reconocido. Ficha completa en [`03_literature/Informacion_PER/FICHA_LECTURA.md`](../03_literature/Informacion_PER/FICHA_LECTURA.md) |
| 2026-05-23 | Generar glosario MAFAP bilingüe ES/EN → v0.2.2 | Extracción de hoja "Definitions of data" del PNIA xlsx → CSV (`01_data/processed/mafap_categories.csv`, 33 códigos) + glosario operativo (`04_report/appendix/glosario_mafap_es_en.md`) con definiciones bilingües y mapeo preliminar a instrumentos bolivianos. **Resuelve el 80% del requisito de paridad bilingüe (Parte 3.5)** y desbloquea Apéndice A y el script `11_mafap_classification.R`. |
| 2026-05-23 | Centralizar gobernanza en `.agent/` → v0.3.0 | Mover MASTER_PROMPT.md de `04_report/` a `.agent/` (path canónico); mover ESTILO_NARRATIVO/NEUTRALIDAD/CONTROL desde raíz a `.agent/`; archivar legacy `Master_Prompt_APER2026_v0_1_0.md` en `.agent/legacy/`; eliminar `EJEMPLO_BORRAR.md`; crear stubs HALLAZGOS/METODOLOGIA/FUENTES/INDICADORES (sobrescritos luego por versiones sustantivas generadas en paralelo: HALLAZGOS 595 lines + METODOLOGIA 644 lines + AUDITORIA 744 lines incorporada); AGENTS.md y CLAUDE.md del raíz reducidos a thin pointers. Resuelve la ambigüedad de "dos master prompts vivos". |
| 2026-05-23 | Numerar gobernanza por orden de lectura → v0.3.1 | Renombrar los 9 documentos canónicos de `.agent/` con prefijo `NN_`: `00_MASTER_PROMPT` · `01_METODOLOGIA` · `02_INDICADORES` · `03_FUENTES` · `04_HALLAZGOS` · `05_ESTILO_NARRATIVO` · `06_NEUTRALIDAD` · `07_CONTROL` · `08_AUDITORIA`. Actualizar ~239 referencias cruzadas en 14 archivos. Cambio de naming convention: `H1–H8` → `F01–F08` en MASTER_PROMPT (alineado con `04_HALLAZGOS.md`). |
| 2026-05-23 | Insertar 07_FIGURAS + reorganizar bloques → v0.3.2 | Crear `07_FIGURAS.md` (estándar gráfico finding-first, paleta, resolución, captions, anti-IA gráfico). Renumerar CONTROL 07→08 y AUDITORIA 08→09. Cross-references migradas (sed automatizado). Bloques temáticos formalizados: A identidad+datos (00-04), B reglas de output (05-07), C gate-keeping (08-09). |
| 2026-05-23 | Bloque D — 10 dimensiones operativas → v0.3.3 README | Crear 10 nuevos docs canónicos: 10_RIESGOS (registro ISO 31000 con 20 riesgos), 11_EQUIPO (RACI + COI + authorship ICMJE), 12_REPRODUCIBILIDAD (stack canónico + rebuild end-to-end), 13_PUBLICACION (embargo MEFP + DOI dual + CC-BY 4.0), 14_CONFIDENCIALIDAD (3 niveles), 15_SEGURIDAD (secrets + backup + DR), 16_INCIDENTES (P0-P3 + post-mortem blameless), 17_GIT_WORKFLOW (trunk-based + commits + tags), 18_ONBOARDING (día 1 + 30 días), 19_COMUNICACION (canales + voceros + Q&A). README del .agent v0.3.0 con 20 dimensiones documentadas. **MASTER_PROMPT v0.3.1 NO se actualizó** — gap detectado en auditoría v0.4.0. |
| 2026-05-23 | **Auditoría profunda + integración bloque D → v0.4.0** (ADR-0008) | Auditoría de integridad detectó que el master estaba desactualizado: 07_FIGURAS + 10–19 (11 docs) con 0 referencias en el master; contradicción paleta visual master §4.3 vs FIGURAS §6.1; naming figuras divergente; modelo de amenazas duplicado sin integrar con 10_RIESGOS; semáforo §9 incompleto vs CONTROL §4. **Correcciones v0.4.0:** (a) header con 20 docs en 4 bloques + cuándo consultar cada uno; (b) Parte 1 lectura obligatoria expandida con bloque D + Standard 0 anti-IA; (c) §4.3 paleta híbrida (institucional 3 colores + paleta de datos FIGURAS) → ADR-0007; (d) §5.2 naming figuras coexistencia (legacy fig01-fig40 + nuevas fig_NN_MM_slug); (e) §9 semáforo apunta a CONTROL §4 + lista canónica ampliada; (f) §12 modelo amenazas convertido a pointer a 10_RIESGOS con top-5 visible; (g) §15 formato cierre con campos anti-IA (AI-likelihood, /quijote-writer, banderas, firma A2); (h) Parte 16 expandida con mapa de 20 docs, conflict resolution hierarchy, update protocol del master, estado de docs producidos. Tras este bump, los 20 docs canónicos están integrados y referenciados desde el master. |
|       |          |       |

---

## Principio final

El APER 2026 primero documenta evidencia trazable sobre el gasto agrícola boliviano. Luego convierte esa evidencia en opciones técnicas para que el MEFP — con el WB y el consultor PSE/repurposing — evalúe ajustes al gasto.

**No estás escribiendo un informe que opine sobre Bolivia.**
**Estás construyendo infraestructura de evidencia reproducible para elevar la calidad técnica del gasto agrícola público.**

---

**Próximo paso sugerido:**
1. Revisar Parte 6 capítulo por capítulo (15–20 min) y ajustar hallazgos/figuras/longitudes.
2. Crear `04_HALLAZGOS.md` con los 8 hallazgos en formato JSON (contrato 7.1) — esto desbloquea el motor de síntesis.
3. Una vez Parte 6 esté `READY` para cap 2 o 3, activar `/write-section` con bloque del capítulo + Partes 1–5 + contrato JSON.
4. En paralelo: re-correr regresiones v12 (`08_extended_regressions.R`) + DEA Simar-Wilson para desbloquear cap 5.
