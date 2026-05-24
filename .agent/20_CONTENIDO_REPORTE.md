# 20_CONTENIDO_REPORTE.md — Control detallado del contenido del Quarto book

**Versión:** v0.5.0 · **Última actualización:** 2026-05-24
**Path canónico:** `.agent/20_CONTENIDO_REPORTE.md`
**Propósito:** **control granular** del contenido de cada capítulo del Quarto book (`04_report/`). Complementa [`00_MASTER_PROMPT §6`](00_MASTER_PROMPT.md) que es el plan **estratégico**; este archivo es el plan **operativo** sub-sección por sub-sección, párrafo por párrafo cuando aplica.
**Estado:** este archivo se actualiza **cada sesión** que toca un capítulo. Cierre de sesión obligatorio: actualizar el bloque correspondiente al capítulo trabajado.

**Lecturas relacionadas:** [`00_MASTER_PROMPT §6`](00_MASTER_PROMPT.md) (plan estratégico) · [`04_HALLAZGOS`](04_HALLAZGOS.md) (8 findings) · [`05_ESTILO_NARRATIVO`](05_ESTILO_NARRATIVO.md) (TEEL + anti-IA) · [`07_FIGURAS`](07_FIGURAS.md) (estándar gráfico) · [`09_AUDITORIA §5`](09_AUDITORIA.md) (A3 por capítulo).

---

## 1. Principio rector

> Este archivo es la **bitácora viva** del contenido del reporte. Antes de tocar un capítulo, **léelo**. Después de tocar un capítulo, **actualízalo**. Si algo del capítulo no está aquí, está pendiente de planearse. Si algo está aquí pero no en el `.qmd`, está pendiente de escribirse.

Cuatro reglas operativas:

1. **Una fila por sub-subsección** (h3 dentro del capítulo). Granularidad suficiente para asignar un párrafo TEEL completo a una fila.
2. **Estados explícitos por unidad de contenido**: `vacío` | `outline` | `draft` | `reviewed` | `MEFP_validated` | `book_ready`.
3. **Trazabilidad cruzada**: cada figura, tabla, hallazgo y cita aparece referenciada por `figure_id` / `table_id` / `F<NN>` / `@key`.
4. **Bitácora por capítulo**: cada cambio sustantivo registrado con fecha y autor.

Lo que **NO** vive aquí:

- Cifras concretas (vienen del panel v12 y se citan desde RDS, no se copian).
- Prosa redactada (esa va al `.qmd`).
- Decisiones metodológicas ROJAS (esas son ADRs).

---

## 2. Dashboard general — estado de los 7 capítulos + 2 apéndices

| # | Capítulo | qmd | Status | Cifras | Figuras | Tablas | Hallazgos | Anti-IA score | Last A3 |
|:-:|---|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 0 | Resumen Ejecutivo | `index.qmd` | 🟡 esqueleto | 0 / ~25 | 0 / 3 | 0 / 1 | 8 / 8 | — | — |
| 1 | Introducción, alcance, metodología | `01_introduction.qmd` | 🟡 borrador | ~3 / ~12 | 0 / 1 | 0 / 0 | 0 / 0 | — | — |
| 2 | Desempeño del sector | `02_sector_performance.qmd` | 🟡 borrador parcial | ~8 / ~40 | ~4 / ~10 | 1 / 4 | 1 / 3 (F01, F06, F08) | — | — |
| 3 | Presupuestos e instituciones | `03_budget_institutions.qmd` | 🟡 borrador largo | ~5 / ~35 | ~3 / 7 | 0 / 5 | 0 / 2 (F04, F05) | — | — |
| 4 | Organización del gasto | `04_spending_organization.qmd` | 🟡 esquemático | ~2 / ~30 | ~1 / ~10 | 0 / 4 | 0 / 1 (F07) | — | — |
| 5 | Análisis del gasto | `05_spending_analysis.qmd` | 🔴 placeholder | 0 / ~30 | 0 / 7 | 0 / 4 (regresiones) | 0 / 2 (F02, F03) | — | — |
| 6 | Recomendaciones | `06_recommendations.qmd` | 🔴 placeholder | 0 / ~10 | 0 / 3 | 0 / 2 | 0 / 0 (síntesis) | — | — |
| A | Apéndice — Fuentes de datos | `appendix/A_data_sources.qmd` | 🟡 borrador parcial | n/a | 0 / 0 | 1 / 3 | n/a | — | — |
| B | Apéndice — Metodología detallada | `appendix/B_methodology.qmd` | 🔴 placeholder | n/a | 0 / 0 | 0 / 0 | n/a | — | — |
| C | Apéndice — **Glosario MAFAP bilingüe** | `appendix/C_glosario_mafap.qmd` | 🟢 **borrador** (formalizado como Quarto, 171 líneas) | n/a | 0 / 0 | 5 / 5 (A–E) | n/a | — | — |
| D | Apéndice — Crosswalk clasificaciones | `appendix/D_crosswalk_clasificaciones.qmd` | 🟡 **CSV listo (41 entradas), qmd pendiente** | n/a | 0 / 0 | 1 / 2 | n/a | — | — |
| E | Apéndice — Tablas regresión panel FE | `appendix/E_regresiones_panel_fe.qmd` | 🔴 placeholder | n/a | 0 / 0 | 0 / 7 | n/a | — | — |
| F | Apéndice — Resultados DEA Simar-Wilson | `appendix/F_dea_simar_wilson.qmd` | 🔴 placeholder | n/a | 0 / 2 | 0 / 3 | n/a | — | — |
| G | Apéndice — Programas BM activos | `appendix/G_programas_bm.qmd` | 🟡 outline | n/a | 0 / 0 | 0 / 2 | n/a | — | — |
| H | Apéndice — ADRs metodológicos | `appendix/H_adrs_metodologicos.qmd` | 🟡 outline | n/a | 0 / 0 | 1 / 1 | n/a | — | — |

**Leyenda de status:**

- 🟢 `book_ready` — pasó A3 + A4; cifras finales; sin TODO_TRACE.
- 🟢 `reviewed` — pasó A3 (revisor par firmó); sin TODO_TRACE bloqueante.
- 🟡 `borrador` — texto sustantivo en `.qmd` pero pendiente revisar/cifrar.
- 🟡 `outline` — estructura definida, prosa pendiente.
- 🟡 `esqueleto` — archivo creado, headers, sin contenido.
- 🔴 `placeholder` — archivo sin contenido sustantivo / bloqueado por dependencia.
- ⚪ `vacío` — no existe el archivo.

**Cifras totales objetivo del book:** ~180 cifras trazadas, ~45 figuras (40 legacy + ~5 nuevas MAFAP/DEA/scenarios), ~30 tablas (incluye crosswalks y regresiones), 8 hallazgos, 8 apéndices.

**Decisión sobre apéndices (v0.2.0):** se amplía la estructura original de 2 apéndices (A, B) a **8 apéndices (A–H)** para capturar la complejidad metodológica del APER 2026:
- A. Fuentes de datos (versión publicable de `03_FUENTES.md`)
- B. Metodología detallada (versión publicable de `01_METODOLOGIA.md`)
- **C. Glosario MAFAP bilingüe ES/EN** — formalización del archivo existente `glosario_mafap_es_en.md`
- **D. Crosswalk MAFAP ↔ OECD-PSE ↔ COFOG ↔ MEFP funcional** — nuevo, a generar
- E. Tablas de regresión panel FE detalladas
- F. Resultados DEA Simar-Wilson detallados
- G. Inventario de programas BM activos
- H. Decisiones metodológicas (ADRs referenciados)

Esta ampliación es **AMARILLO** según [CONTROL §4.2](08_CONTROL.md) (agrega contenido sin cambiar cifras). Apertura propuesta: requiere validación TTL.

---

## 3. Esquema canónico por capítulo

Cada bloque sigue esta estructura. Mantener formato YAML-friendly para auditoría automatizada futura.

```text
PREGUNTA DE POLÍTICA del capítulo
LONGITUD: target (X pp) / actual (Y pp aproximado)
STATUS: ver dashboard §2

SECCIONES (h2) y SUB-SECCIONES (h3) — outline detallado:
  H2.1 título
    H3.1.1 título — estado, hallazgo asignado, figura(s) ref, cifras clave
    H3.1.2 ...
  H2.2 título
    ...

FIGURAS — tabla con figure_id, título, fuente, status, ubicación en cap
TABLAS — tabla con table_id, título, fuente, status, ubicación en cap
HALLAZGOS asignados — lista F<NN> con sub-secciones donde aparecen
CIFRAS CLAVE — lista con su trazabilidad
CITAS REQUERIDAS — lista @key con status (verificada / pendiente)
CROSS-REFS INTERNAS — qué otros capítulos del book referencia / le referencian
APENDICES — qué del apéndice A o B se invoca
TODO LIST específico del capítulo
OPEN QUESTIONS — decisiones pendientes
LAST UPDATE — fecha + autor
AI-LIKELIHOOD del capítulo — promedio §3.10 ESTILO
GATES G1–G7 — checklist por capítulo del MASTER §11.1
```

---

## 4. Capítulo 0 — Resumen Ejecutivo (`index.qmd`)

**Pregunta de política:** ¿Qué cambió en el gasto agropecuario boliviano entre el APER 2011 y 2026, y qué implica para el diseño de política sectorial?

**Longitud:** **4–6 pp objetivo** (alineado con `Main_TOR_JC.pdf` Deliverable 4 — Executive Summary 4-6 pp).
**Bilingüe:** **sí — paridad ES/EN obligatoria**. Versión ES es el deliverable formal D4.
**Status:** 🟡 esqueleto (existe `index.qmd`, reescribir con cifras v12).
**Dependencia:** integra cifras OECD-PSE de **Hector** ([21_COORDINACION_STC §3.1](21_COORDINACION_STC.md)) — específicamente F02 (PSE 5.8% LAC) y F03 (NRP dual).

### 4.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status | Hallazgo | Figura | Cifras clave |
|:-:|---|:-:|:-:|:-:|---|
| H2.1 | Contexto y motivación | outline | — | — | gasto agro ×10 (1990–2024); pobreza rural 45%; FIES 74%; frontera 9.4M ha |
| | H3.1.1 ¿Por qué actualizar el APER 2011? | outline | — | — | brecha temporal 15 años |
| | H3.1.2 Estructura de este resumen | outline | — | — | n/a |
| H2.2 | Ocho hallazgos clave | outline | **F01–F08** | fig10, fig13, fig22 | una cifra por hallazgo |
| | H3.2.1 H1 — Inversión ×10 sin TFP | outline | F01 | fig10 | TFP +30% / Inv ×10 (2000–2015) |
| | H3.2.2 H2 — PSE 5.8% en LAC | outline | F02 | fig13 | 5° puesto LAC |
| | H3.2.3 H3 — Patrón dual NRP | outline | F03 | — | soya −37% / maíz +46% |
| | H3.2.4 H4 — Maputo nunca alcanzado | outline | F04 | — | máx 3.48% en 1990 |
| | H3.2.5 H5 — Sustitución gasto → crédito | outline | F05 | — | crédito ×11.7; Ley 393 |
| | H3.2.6 H6 — Pobreza rural revierte | outline | F06 | — | 55→40→45% (2012–2024); FIES 49→74% |
| | H3.2.7 H7 — PAR III subejecutado | outline | F07 | — | 16% financiero 2024 |
| | H3.2.8 H8 — Frontera agropecuaria | outline | F08 | fig22 | 9.4 M ha; 64% Santa Cruz |
| H2.3 | Mensajes de política | placeholder | síntesis | — | (escribir al final, post cap 6) |
| | H3.3.1 Repurposing como ventana | placeholder | F02+F03 | — | margen S02 |
| | H3.3.2 Limitaciones a reconocer | placeholder | — | — | gaps datos (Tier B) |
| H2.4 | Estructura del reporte | placeholder | — | — | n/a |

### 4.2. Figuras

| figure_id | título corto | status | script |
|---|---|:-:|---|
| `fig10` | Inversión pública agropecuaria 1990–2024 | 🟡 pre-generada | `02_code/04_visualization/fig10_*.R` |
| `fig13` | Composición PSE/GSSE/CSE Bolivia | 🟡 pre-generada | `02_code/04_visualization/fig13_*.R` |
| `fig22` | Mapa gasto agro per cápita rural 2020 | 🟡 pre-generada | `02_code/04_visualization/fig22_*.R` |

### 4.3. Tablas

| table_id | título corto | status | script |
|---|---|:-:|---|
| `tab_es_01` | Síntesis de los 8 hallazgos (cifra única) | vacío | TODO_TRACE: derivar de `04_HALLAZGOS.md` |

### 4.4. Cifras clave (trazabilidad)

```text
[TODO_TRACE: para cada hallazgo del resumen ejecutivo, anclar a RDS+script+variable+período]
Estimado: ~25 cifras (una por bullet de los 8 hallazgos + contexto).
```

### 4.5. Citas requeridas

```text
[TODO_TRACE: lista @keys cuando se redacte; estimado < 10 citas, executive summary lleva pocas citas inline]
```

### 4.6. Cross-refs y apéndices

- **Referencia a:** todos los capítulos 1–6, apéndice A (fuentes), apéndice B (metodología).
- **Es referenciado por:** ninguno (es la puerta de entrada).
- **APER 2011:** caja comparativa "Lo que ha cambiado desde 2011".

### 4.7. TODO list

- [ ] Decidir si el resumen ejecutivo va antes o después del índice general (convención WB: antes).
- [ ] Confirmar 3 figuras de alto impacto (fig10/fig13/fig22 vs. alternativas).
- [ ] Redactar versión EN en paralelo (no traducir post-hoc).
- [ ] Disclaimer técnico §14 al cierre.

### 4.8. Bitácora del capítulo

| Fecha | Autor | Cambio |
|---|---|---|
| 2026-05-23 | JCM | Outline inicial migrado de MASTER §6 cap 0. |

---

## 5. Capítulo 1 — Introducción, alcance, metodología (`01_introduction.qmd`)

**Pregunta de política:** ¿Por qué actualizar el APER 2011 ahora, y con qué método?

**Longitud:** 8–10 pp objetivo · pendiente medición.
**Status:** 🟡 borrador existente, requiere actualizar metodología DEA y mencionar Ley 393.

### 5.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status | Hallazgo | Figura | Cifras clave |
|:-:|---|:-:|:-:|:-:|---|
| H2.1 | Objetivos del APER 2026 | outline | — | — | n/a |
| | H3.1.1 Pregunta central | outline | — | — | n/a |
| | H3.1.2 Audiencias y uso esperado | outline | — | — | n/a |
| H2.2 | Justificación: por qué ahora | borrador | — | fig01 o fig04 | FIES 74% (2024); pobreza rural 45%; frontera 9.4 M ha |
| | H3.2.1 Brecha temporal vs APER 2011 | outline | — | — | 15 años |
| | H3.2.2 Cambios estructurales recientes | outline | — | — | Ley 393 (2014), COVID, sequía 2023 |
| H2.3 | Alcance y delimitación | outline | — | — | sectorial / temporal / institucional |
| | H3.3.1 Qué cubre | outline | — | — | n/a |
| | H3.3.2 Qué no cubre | outline | — | — | (referenciar MASTER §2.4) |
| H2.4 | Metodología | placeholder | — | — | — |
| | H3.4.1 Marco PER + adaptación bolivariana | placeholder | — | — | — |
| | H3.4.2 PSE/CSE (OECD-BID) | placeholder | — | — | METODOLOGIA §4.4 |
| | H3.4.3 DEA Simar-Wilson | placeholder | — | — | METODOLOGIA + literatura |
| | H3.4.4 Panel FE econométrico | placeholder | — | — | `fixest`, `post_ley393` |
| | H3.4.5 Clasificación dual MAFAP + PSE | outline | — | — | METODOLOGIA + glosario apéndice A |
| H2.5 | Fuentes — resumen | outline | — | — | 30+ fuentes (detalle en apéndice A) |
| | H3.5.1 Fuentes nacionales | outline | — | — | BOOST, VIPFE, INE, MDRyT, BCB, Jubileo |
| | H3.5.2 Fuentes internacionales | outline | — | — | FAO, OECD, IDB AgriMonitor, WDI |
| | H3.5.3 Gaps documentados (Tier B) | outline | — | — | referencia `00_admin/ESTADO_DE_DATOS.md` |

### 5.2. Figuras

| figure_id | título corto | status |
|---|---|:-:|
| `fig01` | VA agropecuario como % PIB, 1990–2024 | 🟡 pre-generada |
| `fig04` | Outcomes trends Bolivia (pobreza, FIES, producción) | 🟡 pre-generada |

### 5.3. Citas requeridas

**Fuentes ancla obligatorias** (ver §23.4 mapeo evidencia ↔ capítulos, derivado de [`03_literature/evidence_map.md`](../03_literature/evidence_map.md)):

```text
@WorldBank2021_TappingBolivia, @WorldBank2021_SCDUpdate,
@IMF2025_ArticleIV2024, @IMF2025_ArticleIV2025,
@IPCC2022_Ch12, @FAO2024Bolivia,
@CIPCA2021, @INE2015_Censo,
@Andersen_Faris2002_NaturalGas, @WFP2022_BoliviaACR
```

Adicional para sub-sección de metodología: `@WB2014_PEMethodGuideVolII`, `@MAFAP2013_MethodGuideVolI`, `@SimarWilson1998`, `@SimarWilson2007`, `@WB2011_BoliviaAgPER`, `@OECD_PSE_Manual`.

### 5.4. Cross-refs

- **Referencia a:** apéndice B (metodología detallada), todos los capítulos 2–6 (vista previa).
- **Apéndices:** B (metodología), A (fuentes).
- **APER 2011:** subsección dedicada "Lo que cubrió el APER 2011 y lo que añade 2026".

### 5.5. TODO list

- [ ] Reescribir sección metodología tras cerrar DEA Simar-Wilson y panel FE.
- [ ] Incluir mención de Ley 393 (2014) como evento estructural.
- [ ] Validar lista de fuentes con `03_FUENTES.md` v0.2.0.
- [ ] Decisión: ¿glosario operativo aquí o solo en apéndice A?

### 5.6. Bitácora del capítulo

| Fecha | Autor | Cambio |
|---|---|---|
| 2026-05-23 | JCM | Outline inicial migrado de MASTER §6 cap 1. |

---

## 6. Capítulo 2 — Desempeño del sector (`02_sector_performance.qmd`)

**Pregunta de política:** ¿Por qué la inversión agropecuaria ×10 no se tradujo en TFP, y cuáles son las consecuencias sociales y ambientales?

**Longitud:** 15–20 pp objetivo · pendiente medición.
**Status:** 🟡 borrador parcial, falta sección FIES y sección cobertura.

### 6.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status | Hallazgo | Figuras | Cifras clave |
|:-:|---|:-:|:-:|:-:|---|
| H2.1 | Importancia macro del sector | borrador | — | fig01 | VA agro %PIB, empleo agro 28%, exportaciones |
| | H3.1.1 Valor agregado y empleo | borrador | — | fig01, fig04 | agr_value_added_pct_gdp; agr_employment_pct |
| | H3.1.2 Exportaciones agropecuarias | outline | — | — | wdi_agr_export_pct |
| H2.2 | Productividad — TFP y descomposición | borrador parcial | **F01** | fig12 | TFP +30% / Inv ×10 |
| | H3.2.1 TFP USDA-ERS 1990–2023 | borrador | F01 | fig06, fig07 | `tfp_index`, `tfp_input`, `tfp_output` |
| | H3.2.2 Descomposición input vs output | outline | F01 | fig08 | tfp_per_mbob |
| | H3.2.3 Comparación con LAC | outline | F01 | fig09 | benchmark Peru/Colombia/Ecuador |
| | H3.2.4 ¿Por qué la inversión no movió la TFP? | outline | F01 | fig12 | composición transferencias vs bienes públicos |
| H2.3 | Pobreza rural y seguridad alimentaria | placeholder | **F06** | — | 55→40→45% (2012–2024); FIES 49→74% |
| | H3.3.1 Pobreza rural — serie y reversión | placeholder | F06 | — | INE EH; ciclos |
| | H3.3.2 FIES — inseguridad alimentaria | placeholder | F06 | — | FAOSTAT FIES; punto de quiebre |
| | H3.3.3 Cross-section: pobreza × producción | placeholder | F06 | — | scatter o small multiples |
| H2.4 | Cobertura del suelo y frontera agropecuaria | placeholder | **F08** | fig33–fig40 | 9.4 M ha (1985–2024); 64% Santa Cruz |
| | H3.4.1 MapBiomas — antrópico vs natural | placeholder | F08 | fig33, fig34 | `lc_antropico`, `lc_natural` |
| | H3.4.2 Hansen GFC — pérdida forestal | placeholder | F08 | fig35 | `hansen_defor_ha` |
| | H3.4.3 Distribución departamental | placeholder | F08 | fig36, fig37 | concentración en Santa Cruz |
| | H3.4.4 Implicaciones climáticas | placeholder | F08 | — | emisiones GEI agropecuarias |
| H2.5 | Ciclos políticos y choques | outline | — | — | Ley 393 (2014); COVID (2020); sequía 2023 |
| | H3.5.1 Estructurales | outline | — | — | dummy `post_ley393` |
| | H3.5.2 Coyunturales | outline | — | — | shock-by-shock |

### 6.2. Figuras

| figure_id | título corto | status | hallazgo |
|---|---|:-:|:-:|
| `fig01` | VA agro %PIB 1990–2024 | 🟡 pre-generada | — |
| `fig04` | Outcomes trends Bolivia | 🟡 pre-generada | F06 |
| `fig06` | TFP Bolivia 1990–2023 | 🟡 pre-generada | F01 |
| `fig07` | Decomposición TFP input/output | 🟡 pre-generada | F01 |
| `fig08` | TFP por millón BOB de gasto | 🟡 pre-generada | F01 |
| `fig09` | TFP comparado LAC | 🟡 pre-generada | F01 |
| `fig12` | Inversión vs TFP (scatter o doble eje) | 🟡 pre-generada | F01 |
| `fig33`–`fig40` | Cobertura del suelo y frontera | 🟡 pre-generadas | F08 |

### 6.3. Tablas

| table_id | título corto | status |
|---|---|:-:|
| `tab_02_01` | Macro del sector 1990–2024 (VA, empleo, exportaciones) | outline |
| `tab_02_02` | TFP y descomposición — Bolivia y LAC | outline |
| `tab_02_03` | Pobreza rural y FIES 2012–2024 | outline |
| `tab_02_04` | Cobertura del suelo — antrópico/natural por depto | outline |

### 6.4. Cifras clave (trazabilidad pendiente)

```text
[TODO_TRACE: lista completa cuando avance la redacción]
Estimado: ~40 cifras (TFP, pobreza, FIES, cobertura, exportaciones, comparaciones LAC).
```

### 6.5. Citas requeridas

**Fuentes ancla obligatorias** (ver §23.4 + §23.3 patrones 3, 4, 5):

```text
Productividad (F01):
  @Bragagnolo2021, @Fuglie2024, @FuglieRada2013, @Ludena2010,
  @WorldBank2021_TappingBolivia
Pobreza rural + FIES (F06):
  @WorldBank2024_PovertyEquityBrief, @UDAPE2025_BrechasSociales,
  @WFP2022_BoliviaACR, @Vargas_Garriga2015_Inequality
Frontera + cobertura (F08):
  @Pacheco2006 (dualismo oriente-occidente),
  Censo INE + MapBiomas + Hansen GFC (panel v12, no biblio externa)
Estructura agraria + AF:
  @CIPCA2014, @CIPCA2021, @INE2015_Censo
Clima:
  @Rabatel2013, @Canedo2021, @IPCC2022_Ch12, @AndersenVerner2009
Cadenas (cuando aplique):
  Carpeta 05_value_chains/ (34 fichas — quinoa, soya, coca, café, etc.)
```

### 6.6. Cross-refs

- **Referencia a:** cap 3 (gasto que no movió TFP), cap 4 (distribución territorial del gasto que se vincula con cobertura), cap 5 (PSE y eficiencia), apéndice B (TFP methodology).
- **Es referenciado por:** cap 0 (RE), cap 1 (justificación FIES + frontera), cap 6 (motivación recomendaciones).
- **APER 2011:** caja "TFP en APER 2011 vs hoy — qué cambió".

### 6.7. TODO list

- [ ] Redactar sección H2.3 (pobreza + FIES) — bloqueada por confirmación serie INE EH.
- [ ] Construir small multiples para H2.4 (cobertura por depto) usando MapBiomas + Hansen.
- [ ] Escribir caja comparativa APER 2011 vs 2026.
- [ ] Verificar que F01 (TFP cifra clave) coincide con valor en `04_HALLAZGOS.md`.
- [ ] Confirmar que `agr_employment_pct` n=24 cubre la ventana del claim (panel `02_INDICADORES §G17`).

### 6.8. Open questions

- ¿Reportar TFP con base 2015 o con base 2010? (METODOLOGIA dice 2015 — confirmar consistencia con USDA-ERS).
- ¿Sección H2.5 (ciclos políticos) entra como subsección o como caja transversal?
- ¿Incluir mapa global "Bolivia en LAC" como apertura del cap o solo regionalizar dentro de figuras de pobreza/FIES/TFP?

### 6.9. Bitácora del capítulo

| Fecha | Autor | Cambio |
|---|---|---|
| 2026-05-23 | JCM | Outline inicial migrado de MASTER §6 cap 2, con desagregación por sub-subsección. |

---

## 7. Capítulo 3 — Presupuestos e instituciones (`03_budget_institutions.qmd`)

**Pregunta de política:** ¿Cómo se compone el gasto público agropecuario boliviano, por qué nunca alcanzó Maputo, y cómo se sustituyó por crédito post-Ley 393?

**Longitud:** 18–22 pp objetivo.
**Status:** 🟡 borrador largo existente; requiere integrar Ley 393, cifras v12 y re-clasificación MAFAP.

### 7.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status | Hallazgo | Figuras | Cifras clave |
|:-:|---|:-:|:-:|:-:|---|
| H2.1 | Arquitectura institucional del sector | borrador | — | fig02 (org chart) | n/a |
| | H3.1.1 MDRyT y entidades adscritas (INIAF, SENASAG, INRA, EMAPA) | borrador | — | — | INIAF; SENASAG; INRA; EMAPA |
| | H3.1.2 BDP — banco público sectorial | borrador | — | — | cartera BDP |
| | H3.1.3 Subnacionales (departamentales + municipales) | outline | — | — | Ley de Autonomías |
| H2.2 | Evolución presupuestaria 1990–2024 — **clasificación dual MAFAP + económica** | borrador | — | fig10, fig11, fig18, fig19 | inv_agro_*; boost_* |
| | H3.2.1 Cifra agregada 1990–2024 (USD reales 2015 + %PIB + %gasto público) | borrador | — | fig10 | `inv_agro_usd_mm` n=35; `inv_agro_pct_gdp`; `speed_ag_pctexp` |
| | H3.2.2 **Clasificación MAFAP (FAO 2013) — narrow vs full definition** | placeholder | — | — | apéndice C glosario; apéndice D crosswalks |
| | H3.2.3 **Composición MAFAP A — Apoyo al productor** (MPS + subsidios input + variable input subsidies + decoupled payments) | placeholder | — | fig18a | shares categoría A 1990–2024 |
| | H3.2.4 **Composición MAFAP B + C — Apoyo al consumidor + a otros agentes** (transferencias consumidor + subsidio precios alimentos + agroprocesadores) | placeholder | — | fig18b | shares B, C |
| | H3.2.5 **Composición MAFAP D — Apoyo general al sector** (I+D INIAF, extensión, sanidad SENASAG, infraestructura, inspección, capacitación) | placeholder | — | fig18c | shares D — clave para repurposing |
| | H3.2.6 **Composición MAFAP E — Gasto agropecuario-soporte** (caminos rurales, electrificación rural, agua rural, educación rural, salud rural) | placeholder | — | fig18d | shares E — diferencia narrow vs full |
| | H3.2.7 Composición económica (corriente vs capital) | borrador | — | fig11, fig19 | `boost_pct_capital`; `boost_gasto_corriente_mm` |
| | H3.2.8 Fuentes de financiamiento (TGN, RR.EE., crédito interno/externo, donación) | outline | — | fig20 | `boost_fuente_*` |
| | H3.2.9 Tabla resumen: clasificación dual MAFAP × Económica (matriz) | placeholder | — | tab_03_03 | tabla cruzada |
| H2.3 | Maputo y compromisos sectoriales | placeholder | **F04** | — | máx 3.48% (1990); media histórica ~1.4% |
| | H3.3.1 Compromiso Maputo (10% gasto público) | placeholder | F04 | — | benchmark CAADP |
| | H3.3.2 Bolivia vs LAC en cumplimiento Maputo | placeholder | F04 | — | speed_ag_pctexp |
| | H3.3.3 ¿Por qué nunca se alcanzó? | placeholder | F04 | — | factores institucionales |
| H2.4 | Sustitución gasto → crédito post-Ley 393 | placeholder | **F05** | — | crédito ×11.7 (2010–2024) |
| | H3.4.1 Ley 393/2014 — qué cambió | placeholder | F05 | — | shares mínimos cartera productiva |
| | H3.4.2 Cartera agropecuaria BCB 2010–2024 | placeholder | F05 | — | `bcb_cred_agro_*` |
| | H3.4.3 Subsidio cuasi-fiscal | placeholder | F05 | — | crédito subsidiado BDP |
| | H3.4.4 Costo fiscal vs gasto presupuestario | placeholder | F05 | — | TODO_TRACE revenue foregone |
| H2.5 | Comparación APER 2011 vs 2026 | outline | — | — | composición histórica |

### 7.2. Figuras

| figure_id | título corto | status | hallazgo |
|---|---|:-:|:-:|
| `fig02` | Arquitectura institucional sector agro Bolivia | 🟡 pre-generada | — |
| `fig03` | Organigrama detallado MDRyT y adscritas | 🟡 pre-generada | — |
| `fig10` | Evolución inv pública agro 1990–2024 | 🟡 pre-generada | F04 |
| `fig11` | Composición corriente vs capital | 🟡 pre-generada | — |
| `fig18a` | Composición MAFAP categoría A (apoyo productor) | placeholder | F03 indirecto |
| `fig18b` | Composición MAFAP categorías B+C (consumidor + otros agentes) | placeholder | — |
| `fig18c` | Composición MAFAP categoría D (apoyo general al sector — bienes públicos) | placeholder | F02 indirecto |
| `fig18d` | Composición MAFAP categoría E (agropecuario-soporte — rural) | placeholder | — |
| `fig18_summary` | Composición MAFAP A–E total — barras apiladas 1990–2024 | placeholder | — |
| `fig19` | Composición económica detallada (corriente vs capital) | 🟡 pre-generada | — |
| `fig20` | Fuentes de financiamiento por año | 🟡 pre-generada | — |

### 7.3. Citas requeridas

**Fuentes ancla obligatorias** (ver §23.4 Cap 3 + §23.3 patrón 1):

```text
Método de clasificación (MAFAP + GFSM + BOOST):
  @WB2014_PEMethodGuideVolII, @MAFAP2013_MethodGuideVolI,
  @IMF_GFSM2014, @WB_BOOST

Composición LAC (benchmarks):
  @LopezGalinato2007, @Anriquez2017IDB,
  @FAO2021_PEFoodAgricultureSSA, @Pernechele2018

Antecedente Bolivia:
  @WB2011_BoliviaAgPER (APER 2011 — caja comparativa)

Ley 393 + crédito:
  @gobiernobolivia-ley393-2014 (cuando se agregue),
  Carpeta 08_institutions_programs/ (fichas BDP)
```

### 7.4. Cross-refs y apéndices

- **Referencia a:** apéndice B (metodología clasificación MAFAP), apéndice A (fuentes BOOST, BCB).
- **Es referenciado por:** cap 4 (organización detallada del gasto), cap 5 (PSE y eficiencia del gasto), cap 6 (recomendaciones sobre BDP y subsidios).
- **APER 2011:** caja "Composición del gasto en APER 2011 vs 2026" + tabla simétrica al cap 4 del APER 2011.

### 7.5. TODO list

- [x] ~~**CRÍTICO MAFAP:** crear script `11_mafap_classification.R`~~ → ✓ creado como `02_code/02_cleaning/17_mafap_classification.R` (siguiendo numeración secuencial del proyecto). **Pendiente:** ejecutar script para producir `mafap_bolivia.rds`.
- [x] ~~**CRÍTICO MAFAP:** generar `01_data/processed/crosswalk_mafap_oecd_cofog.csv`~~ → ✓ creado (41 entradas: A:9, B:5, C:5, D:14, E:8) formalizado por ADR-0010.
- [x] ~~**CRÍTICO MAFAP:** construir 5 figuras MAFAP (fig18a–d + fig18_summary)~~ → ✓ script `02_code/04_visualization/11_figures_mafap.R` creado. **Pendiente:** ejecutar tras correr clasificación.
- [x] ~~Caja metodológica "Por qué dos clasificaciones"~~ → ✓ formalizada por ADR-0009; texto base disponible en `C_glosario_mafap.qmd §C.1`.
- [ ] Reportar **dos series paralelas** del GAP en prosa del cap 3 (cuando se redacte): MAFAP narrow vs full. Marco metodológico ya está; falta narrativa.
- [ ] Calcular `revenue_foregone_bdp` y formalizar como ítem `_rf` en panel (futuro script `18_revenue_foregone.R` — capturado parcialmente en BT_agg).
- [ ] Validar serie crédito post-Ley 393 vs cartera anterior (sin doble conteo).
- [ ] Caja sobre Ley 393 con timeline 2013–2024.
- [ ] Cita explícita: Manual MAFAP Vol II (FAO 2013) `@ghins2013mafap`, PER SSA usando MAFAP (Pernechele et al. 2021) — agregar a `references.bib`.

### 7.6. Bitácora del capítulo

| Fecha | Autor | Cambio |
|---|---|---|
| 2026-05-23 | JCM | Outline migrado y desagregado a sub-subsecciones. |
| 2026-05-23 | JCM | **6 bloqueadores MAFAP cerrados.** ADR-0009 (adopción narrow+full) + ADR-0010 (crosswalk operacional) + `crosswalk_mafap_oecd_cofog.csv` (41 entradas) + script `17_mafap_classification.R` + script `11_figures_mafap.R` + `C_glosario_mafap.qmd`. Pendiente solo ejecución de scripts y redacción narrativa. |

---

## 8. Capítulo 4 — Organización del gasto (`04_spending_organization.qmd`)

**Pregunta de política:** ¿Quién ejecuta el gasto agropecuario en Bolivia y con qué calidad de ejecución?

**Longitud:** 15–18 pp objetivo.
**Status:** 🟡 esquemático, requiere narrativa de PAR III, mapas y benchmarks regionales.

### 8.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status | Hallazgo | Figuras | Cifras clave |
|:-:|---|:-:|:-:|:-:|---|
| H2.1 | Distribución nacional–departamental–municipal — **bajo MAFAP** | outline | — | fig05, fig21 | `mun_*` n=10 |
| | H3.1.1 Cuota por nivel de gobierno (matriz MAFAP × nivel) | outline | — | fig05 | %nacional / %dept / %muni × A/B/C/D/E |
| | H3.1.2 Series 2012–2023 — agropecuario estricto (MAFAP A+C+D) vs rural-soporte (MAFAP E) | outline | — | fig21 | `mun_agro_strict_bob_mm_2015` vs `mun_rural_infra_bob_mm_2015` |
| | H3.1.3 **Coherencia con definiciones MAFAP narrow/full** a nivel subnacional | placeholder | — | — | apéndice C |
| H2.2 | Heterogeneidad subnacional — **Santa Cruz, La Paz, Cochabamba** focus | placeholder | — | fig22, fig25–fig32 | Lorenz, Gini territorial |
| | H3.2.1 Mapa departamental gasto per cápita rural | placeholder | — | fig22 | `gini_territorial` |
| | H3.2.2 **Santa Cruz** (70.5% del área cultivada nacional) — gasto vs producción | placeholder | — | fig25 | `mun_*` filtrado a Santa Cruz |
| | H3.2.3 **La Paz** (7.5% área cultivada) — capital + altiplano | placeholder | — | fig26 | `mun_*` La Paz |
| | H3.2.4 **Cochabamba** (5.6% área cultivada) — valles + ciudades intermedias | placeholder | — | fig27 | `mun_*` Cochabamba |
| | H3.2.5 Top-20 municipios concentración | placeholder | — | fig28 | concentración |
| | H3.2.6 Heterogeneidad por categoría MAFAP (D riego, D5 sanidad, D2 extensión) | placeholder | — | fig29–fig30 | small multiples |
| | H3.2.7 Correlación con necesidad (pobreza, FIES) | placeholder | — | fig31, fig32 | scatter focalización |
| H2.3 | Programas del Banco Mundial activos | borrador | **F07** | — | PAR III, MIAGRA |
| | H3.3.1 PAR III — diseño y status | borrador | F07 | — | 16% ejecución financiera 2024 |
| | H3.3.2 MIAGRA y otros | outline | — | — | inventario BM |
| | H3.3.3 Lecciones operativas | outline | F07 | — | benchmarks regionales |
| H2.4 | Capacidad de ejecución y gaps | outline | F07 | — | tasas de ejecución |
| | H3.4.1 Tasa de ejecución por entidad | outline | F07 | — | `boost_tasa_ejecucion` |
| | H3.4.2 Comparación PER SSA (Pernechele 2021): 21% no ejecutado | outline | F07 | — | benchmark |
| | H3.4.3 Comparación Filipinas (WB 2023): 85–92% DA | outline | F07 | — | benchmark Mandanas |

### 8.2. Figuras

| figure_id | título corto | status |
|---|---|:-:|
| `fig05` | Cuota gasto por nivel de gobierno | 🟡 pre-generada |
| `fig21` | Serie gasto municipal agropecuario 2012–2023 | 🟡 pre-generada |
| `fig22` | Mapa departamental gasto per cápita rural 2020 | 🟡 pre-generada |
| `fig25`–`fig32` | Heterogeneidad subnacional y correlaciones | 🟡 pre-generadas |

### 8.3. Citas requeridas

**Fuentes ancla obligatorias** (ver §23.4 Cap 4):

```text
Eficiencia del gasto (DEA Simar-Wilson):
  @SimarWilson1998, @SimarWilson2007,
  @Coelli1996_DEAP21Guide, @Wilson2008FEAR,
  @Ludena2010 (DEA LAC 26 países)

Programas y evaluaciones BM:
  @PAR_WorldBank2024_ICR, @PICAR_WorldBank2021,
  @PlanVida_IFAD_ImpactAssessment

Titulación INRA:
  @Schling2024LandRegularization (+38.6% eficiencia)

Benchmarks regionales:
  @FAO2021_PEFoodAgricultureSSA / @Pernechele2018 (PER SSA — 21% no ejecutado)

Mandanas Ruling Filipinas (analogía Ley de Autonomías):
  Carpeta 09_methods_per_pse/ — PER Filipinas (WB 2023)
```

### 8.4. Cross-refs

- **Referencia a:** cap 3 (presupuestos), cap 5 (eficiencia DEA), cap 6 (recomendaciones operacionales).
- **Es referenciado por:** cap 0 (RE — F07), cap 6.
- **APER 2011:** "el APER 2011 tuvo poca cobertura subnacional — aquí se gana más" (caja).

### 8.5. TODO list

- [ ] Validar inventario de programas BM activos (`00_admin/Inventario_*.xlsx`).
- [ ] Generar 4 mapas departamentales (gasto, pobreza, FIES, mismatch).
- [ ] Calcular Lorenz y Gini territorial.
- [ ] Adaptar lecciones de Mandanas (Filipinas) a Ley de Autonomías Bolivia.

### 8.6. Bitácora

| Fecha | Autor | Cambio |
|---|---|---|
| 2026-05-23 | JCM | Outline desagregado a sub-subsecciones. |

---

## 9. Capítulo 5 — Análisis del gasto (`05_spending_analysis.qmd`)

**Pregunta de política:** ¿Qué tan eficiente es el gasto agropecuario boliviano comparado con LAC, qué tipo de apoyo predomina (PSE), y cómo se relaciona con seguridad alimentaria?

**Longitud:** 20–25 pp objetivo (capítulo más largo).
**Status:** 🔴 placeholder — bloqueado hasta re-correr `08_extended_regressions.R` + DEA Simar-Wilson + **outputs Hector** ([21_COORDINACION_STC §3.1](21_COORDINACION_STC.md)).
**Inputs principales de Hector** (Secondary TOR): §H2.1 PSE/GSSE/TSE Bolivia + §H2.2 NRP por commodity. JC produce: §H2.3 DEA + §H2.4 regresiones. **Integración**: §5 del archivo de coordinación STC.

### 9.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status | Hallazgo | Figuras | Cifras clave |
|:-:|---|:-:|:-:|:-:|---|
| H2.1 | PSE/GSSE/TSE Bolivia | placeholder | **F02** | fig13, fig14 | %PSE 5.8% (2018) |
| | H3.1.1 Nivel del PSE — Bolivia vs LAC | placeholder | F02 | fig13 | 5° puesto LAC (Brasil/Chile/Colombia/Argentina) |
| | H3.1.2 Composición OECD-PSE (MPS, BT, GSSE) | placeholder | F02 | fig14 | shares por categoría |
| | H3.1.3 GSSE — bienes públicos | placeholder | F02 | fig15 | GSSE/TSE |
| | H3.1.4 CSE — transferencias a consumidores | placeholder | F02 | — | CSE_BOB_2015 |
| H2.2 | Patrón dual NRP por commodity | placeholder | **F03** | fig16, fig17 | NRP soya −37%, maíz +46% |
| | H3.2.1 NRP exportables (soya, arroz) | placeholder | F03 | fig16 | nrp_soya −37%, nrp_arroz −33% |
| | H3.2.2 NRP food security (maíz, trigo) | placeholder | F03 | fig17 | nrp_maiz +46%, nrp_trigo +28% |
| | H3.2.3 Interpretación — sesgo de política | placeholder | F03 | — | export tax + food protection |
| H2.3 | Eficiencia técnica DEA Simar-Wilson | placeholder | — | fig23, fig24 | scores de eficiencia |
| | H3.3.1 Especificación inputs/outputs | placeholder | — | — | METODOLOGIA |
| | H3.3.2 Bootstrap Simar-Wilson | placeholder | — | fig23 | intervalos confianza |
| | H3.3.3 Heterogeneidad temporal y subnacional | placeholder | — | fig24 | scores por año/depto |
| | H3.3.4 Cross-check con PER SSA Box 11 | placeholder | — | — | stochastic frontier |
| H2.4 | Regresiones panel FE — gasto vs productividad y FIES | placeholder | — | — | β, SE, R² |
| | H3.4.1 Especificación econométrica | placeholder | — | — | `fixest`, cluster, `post_ley393` |
| | H3.4.2 Resultado principal — gasto agro → TFP | placeholder | F01+ | — | tabla regresiones |
| | H3.4.3 Resultado FIES — gasto → seguridad alimentaria | placeholder | F06+ | — | tabla regresiones |
| | H3.4.4 Robustez (deflactor, ventana, cluster) | placeholder | — | — | sensibilidad |

### 9.2. Figuras y tablas

| id | título corto | status | hallazgo |
|---|---|:-:|:-:|
| `fig13` | PSE/GSSE/CSE Bolivia 2006–2023 | 🟡 pre-generada | F02 |
| `fig14` | Composición OECD-PSE — barras apiladas | 🟡 pre-generada | F02 |
| `fig15` | GSSE share del apoyo total | 🟡 pre-generada | F02 |
| `fig16` | NRP exportables (soya/arroz) | 🟡 pre-generada | F03 |
| `fig17` | NRP food security (maíz/trigo) | 🟡 pre-generada | F03 |
| `fig23` | DEA scores Simar-Wilson | placeholder | — |
| `fig24` | Heterogeneidad DEA temporal/subnacional | placeholder | — |
| `tab_05_01`–`tab_05_04` | Tablas de regresión FE | placeholder | F01+, F06+ |

### 9.3. Citas requeridas

**Fuentes ancla obligatorias** (ver §23.4 Cap 5 — **capítulo más denso en literatura**):

```text
Marcos del repurposing (TEMA CENTRAL):
  @Gautam2022 (WB-IFPRI), @FAOUNEPUNDP2021 (FAO/UNEP/UNDP),
  @WorldBank2024_RepurposingSupport (Recipe), @Damania2023 (Detox)

Método PSE:
  @OECD2025_APME, @OECD_PSE_Manual,
  @DeSalvoEtAl2018_IDB_AgSupportLAC, @IDB_Agrimonitor

NRP y precios:
  @KruegerSchiffValdes1988 (clásico), @AndersonRausserSwinnen2013,
  @LopezGalinato2007 (subasignación bienes públicos LAC)

Reasignación cuantitativa:
  @AnriquezFosterOrtega2020_RuralSubsidiesLAC, @Anriquez2017IDB,
  @SpringmannFreund2022 (143k vidas/año UE), @MasonDCroz2022

Perspectiva Bolivia + economía política:
  @FundacionSolon2023, @FundacionTierra2024,
  @Rentschler2017 (gasolinazo 2010)

Retornos I+D con caveat MIRR:
  @Alston2011, @AlstonPardey2000 (mediana ~44%),
  @Hurley2014 (MIRR realista 9-12%) ← caveat obligatorio

DEA + econometría (caps 5 §H2.3, §H2.4):
  @SimarWilson1998, @SimarWilson2007 (método base)
```

### 9.4. Cross-refs

- **Referencia a:** apéndice B (metodología DEA, panel FE, OECD-PSE), cap 6 (síntesis para repurposing).
- **Es referenciado por:** cap 0 (RE — F02, F03), cap 6 (recomendaciones).
- **APER 2011:** capítulo nuevo metodológicamente (PSE y DEA no estaban en 2011) — caja "qué añade el APER 2026".

### 9.5. TODO list

- [ ] **BLOQUEADOR:** re-correr `08_extended_regressions.R` con panel v12.
- [ ] **BLOQUEADOR:** ejecutar DEA Simar-Wilson sobre `dea_dataset.rds`.
- [ ] Reportar bandas de sensibilidad PSE alto/medio/bajo.
- [ ] Tabla de regresión final formato `gt` (no Word).
- [ ] Verificar consistencia NRP soya/maíz/arroz/trigo con FAOSTAT PP + WB Pink Sheet.

### 9.6. Open questions

- ¿DEA con orientación input o output? (Decisión técnica — proponer en ADR).
- ¿Reportar PSE con o sin GHG component del IDB AgriMonitor?
- ¿Cluster a nivel departamental o municipal en panel FE?

### 9.7. Bitácora

| Fecha | Autor | Cambio |
|---|---|---|
| 2026-05-23 | JCM | Outline desagregado. Status `placeholder` por bloqueador regresiones+DEA. |

---

## 10. Capítulo 6 — Recomendaciones (`06_recommendations.qmd`)

**Pregunta de política:** ¿Qué debe hacer Bolivia para mejorar la efectividad del gasto agropecuario en los próximos 5 años?

**Longitud:** 10–12 pp objetivo.
**Status:** 🔴 placeholder — escribir al final, **coordinado con Hector** ([21_COORDINACION_STC](21_COORDINACION_STC.md)).
**Inputs principales de Hector** (Secondary TOR §c objetivo): §H2.3 **fiscal cost del repurposing** (Q1 reducción MPS + foregone tariff income; Q2 aumentar public goods a niveles globales) + benchmarking LAC (Colombia 2016, Perú 2020). JC produce: §H2.1 mensajes policy + §H2.2 recomendaciones institucionales + §H2.3 composición ex-ante/ex-post de S01-S03 + §H2.4 roadmap.

### 10.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status | Hallazgo | Cifras clave |
|:-:|---|:-:|:-:|---|
| H2.1 | Mensajes de política (cross-cutting) | placeholder | síntesis | — |
| | H3.1.1 Síntesis transversal | placeholder | F01–F08 | — |
| | H3.1.2 Principios rectores del repurposing | placeholder | — | (NEUTRALIDAD: opciones técnicas) |
| H2.2 | Recomendaciones por institución | placeholder | — | — |
| | H3.2.1 MDRyT — INIAF y SENASAG | placeholder | F02 | reasignar 30% MPS → I+D |
| | H3.2.2 MEFP — marco fiscal del sector | placeholder | F04, F05 | Maputo + revenue foregone |
| | H3.2.3 BDP — instrumentos de crédito | placeholder | F05 | costo fiscal explícito |
| | H3.2.4 Subnacionales — capacidad de ejecución | placeholder | F07 | Mandanas-like |
| H2.3 | Repurposing — opciones técnicas cuantificadas | placeholder | F02, F03, F08 | S01, S02, S03 |
| | H3.3.1 S01 — reasignar transferencias a I+D | placeholder | F02 | 30% MPS → INIAF |
| | H3.3.2 S02 — desplazamiento bienes públicos | placeholder | F02, F03 | composición ex-ante/ex-post |
| | H3.3.3 S03 — repurposing climático | placeholder | F08 | productivos vs ambientales |
| | H3.3.4 Banda de incertidumbre por escenario | placeholder | — | elasticidades IFPRI/FAO |
| H2.4 | Roadmap + indicadores de seguimiento | placeholder | — | M&E framework |
| | H3.4.1 Cronograma 5 años | placeholder | — | hitos por año |
| | H3.4.2 Indicadores M&E (output, outcome) | placeholder | — | lista breve |
| | H3.4.3 Articulación con consultor STC | placeholder | — | sinergia `00_admin/SINERGIA_*` |

### 10.2. Figuras y tablas

| id | título corto | status |
|---|---|:-:|
| `fig_06_01_priorization_matrix` | Priorización costo-efectividad de opciones | placeholder |
| `fig_06_02_repurposing_waterfall` | Waterfall composición ex-ante → ex-post S02 | placeholder |
| `fig_06_03_roadmap` | Roadmap 5 años con hitos | placeholder |
| `tab_06_01` | Resumen de escenarios S01–S03 | placeholder |
| `tab_06_02` | Indicadores M&E sugeridos | placeholder |

### 10.3. Citas requeridas

**Fuentes ancla obligatorias** (ver §23.4 Cap 6 — recomendaciones):

```text
Heredadas del Cap 5 (TEMA CENTRAL — todas las del repurposing):
  @Gautam2022, @FAOUNEPUNDP2021, @WorldBank2024_RepurposingSupport,
  @Damania2023, @SpringmannFreund2022, @AnriquezFosterOrtega2020_RuralSubsidiesLAC

Casos de éxito (en @Gautam2022):
  India, Indonesia, China — repurposing exitoso

Secuenciación y diseño:
  @WB2014_PEMethodGuideVolII, @FOLU2019 (10 transiciones sistema alimentario)

Casos comparables LAC:
  Carpeta 11_local_multilateral_bolivia/ + literatura comparada Colombia 2016, Perú 2020

Economía política de la reforma:
  @Rentschler2017 (gasolinazo Bolivia 2010 como advertencia)
```

### 10.4. Cross-refs

- **Referencia a:** todos los capítulos 2–5 (síntesis), apéndice B (supuestos escenarios).
- **Es referenciado por:** cap 0 (RE — mensajes de política).
- **APER 2011:** caja "Recomendaciones del APER 2011 — qué se implementó y qué no".
- **Sinergia STC:** ver `../00_admin/SINERGIA_ToR_PSE_Repurposing.md`.

### 10.5. TODO list

- [ ] **BLOQUEADOR:** insumos de caps 2–5 deben estar cerrados.
- [ ] **BLOQUEADOR:** coordinación con STC sobre escenarios cuantificados.
- [ ] Definir set de elasticidades de literatura (IFPRI 2022, FAO+WB 2022).
- [ ] Marcar TODOS los escenarios como "opción técnica para consideración del MEFP" (NEUTRALIDAD §2.3, ESTILO §8.3).
- [ ] Caja con seguimiento de implementación de recomendaciones APER 2011.

### 10.6. Open questions

- ¿Cuántos escenarios? (Propuesta: 3 = S01 reasign productivo, S02 bienes públicos, S03 climático.)
- ¿Cronograma 5 años o 10 años? (WB típicamente 5; MEFP puede preferir 5 con extensión.)
- ¿Indicadores M&E acá o en apéndice?

### 10.7. Bitácora

| Fecha | Autor | Cambio |
|---|---|---|
| 2026-05-23 | JCM | Outline detallado de recomendaciones y escenarios. Bloqueador STC. |

---

## 11. Apéndice A — Fuentes de datos (`appendix/A_data_sources.qmd`)

**Pregunta operativa:** ¿de dónde vienen los datos del reporte, con qué cobertura, qué licencia, y qué gaps de acceso persisten?

**Longitud objetivo:** 8–10 pp.
**Status:** 🟡 borrador parcial — export desde diccionario v12 + crosswalk scripts.

### 11.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status |
|:-:|---|:-:|
| H2.1 | Marco de gobernanza de fuentes (resumen de [`03_FUENTES.md`](03_FUENTES.md)) | outline |
| | H3.1.1 Principios: inmutabilidad, licencia explícita, fecha de descarga, trazabilidad | outline |
| | H3.1.2 Pipeline de ingesta (raw → processed → panel v12) | outline |
| H2.2 | Fuentes nacionales (10) | borrador |
| | H3.2.1 BOOST Bolivia 2024 — clasificación funcional + económica | borrador |
| | H3.2.2 VIPFE — inversión pública 1990–2024 | borrador |
| | H3.2.3 INE Bolivia (PIB sectorial, IPC, EH, Censo Agropecuario 2013) | borrador |
| | H3.2.4 MDRyT memorias + INIAF + SENASAG | borrador |
| | H3.2.5 BCB cartera de crédito 2010–2024 | borrador |
| | H3.2.6 Fundación Jubileo (subnacional) + CIPCA (riego) + PEFA | outline |
| H2.3 | Fuentes regionales LAC (9) | outline |
| | H3.3.1 IDB AgriMonitor (PSE/CSE/GSSE LAC) | outline |
| | H3.3.2 FAOSTAT (PP, QCL, FBS, TCL, emisiones) | outline |
| | H3.3.3 WB Pink Sheet + WDI | outline |
| | H3.3.4 IFPRI SPEED + USDA-ERS TFP + OECD PSE | outline |
| | H3.3.5 CEPALSTAT + IMF | outline |
| H2.4 | Fuentes geoespaciales (4) | outline |
| | H3.4.1 MapBiomas Bolivia Colección 3 | outline |
| | H3.4.2 Hansen GFC v1.11 | outline |
| | H3.4.3 CHIRPS + ESA WorldCover | outline |
| H2.5 | Diccionario del panel v12 — 176 variables × 17 grupos | placeholder |
| | H3.5.1 Tabla auto-generada desde `spending_panel_v12_dictionary.csv` | placeholder |
| | H3.5.2 Variables con cobertura baja (< 30%) — declaración explícita | placeholder |
| H2.6 | Gaps documentados (Tier B) | borrador |
| | H3.6.1 MDRyT/INIAF/SENASAG ejecución 2009–2024 — Carta MEFP pendiente | borrador |
| | H3.6.2 Memorias MDRyT 2015–2018, 2020, 2022–2023 — no en Wayback | borrador |
| | H3.6.3 BDP cartera detallada por programa | borrador |
| | H3.6.4 SIIF subnacional municipal 2009–2023 | borrador |
| H2.7 | **Corpus de literatura** (resumen — detalle en §23) | **borrador** |
| | H3.7.1 Estructura: 11 carpetas temáticas + 325 fichas + 359 entradas BibTeX | outline |
| | H3.7.2 Niveles de evidencia (jerarquía 1–7) y reglas de citación | outline |
| | H3.7.3 Manual MAFAP Vol I (`@MAFAP2013_MethodGuideVolI`) + Manual PER WB Vol II (`@WB2014_PEMethodGuideVolII`) | outline |
| | H3.7.4 Tabla resumen del corpus por tema con número de fichas y nivel medio de evidencia | outline |
| | H3.7.5 Vacíos de evidencia identificados (Bolivia-específicos, global, metodológicos) | outline |
| H2.8 | Licencias y atribuciones | outline |

### 11.2. Cross-refs

- **Autoridad:** [`03_FUENTES.md`](03_FUENTES.md) v0.2.0 (este apéndice es la versión publicable user-friendly).
- **Glosario MAFAP**: ver Apéndice C.
- **Crosswalks**: ver Apéndice D.

### 11.3. TODO

- [ ] Generar tabla MD del diccionario v12 vía `02_code/00_setup/03_dictionary_to_md.R`.
- [ ] Completar fuentes secundarias pendientes (~30 más del inventario `00_admin/Inventario_*.xlsx`).
- [ ] Verificar todas las URLs y DOIs (script `audit_citations.R`).
- [ ] Tabla de checksums SHA-256 para fuentes inmutables.

---

## 12. Apéndice B — Metodología detallada (`appendix/B_methodology.qmd`)

**Pregunta operativa:** ¿cómo se construyó cada cifra del reporte, con qué definiciones formales, supuestos y robustez?

**Longitud objetivo:** 12–15 pp (apéndice más extenso del book).
**Status:** 🔴 placeholder — bloqueado hasta cerrar regresiones + DEA.

### 12.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status | Conexión |
|:-:|---|:-:|---|
| H2.1 | Marcos de referencia adoptados | outline | METODOLOGIA §2 |
| | H3.1.1 OECD-PSE Manual (última edición) | outline | — |
| | H3.1.2 **FAO MAFAP — Manual Vol II (FAO 2013)** y PER SSA con MAFAP (FAO 2021) | placeholder | apéndice C |
| | H3.1.3 WB BOOST + MEFP clasificación funcional/económica | outline | — |
| | H3.1.4 PER Filipinas (WB 2023) — template estructural | outline | — |
| H2.2 | Cobertura del APER 2026 | outline | METODOLOGIA §3 |
| | H3.2.1 Sectorial (CIIU-A + subsectores) | outline | — |
| | H3.2.2 Geográfica (nacional + 9 deptos + sub-departamental) | outline | — |
| | H3.2.3 Temporal (panel 1990–2024; base 2015) | outline | — |
| | H3.2.4 Institucional (gobierno general + empresas estatales + subnacionales) | outline | — |
| H2.3 | Definiciones operativas core | placeholder | METODOLOGIA §4 |
| | H3.3.1 Gasto Agrícola Público (GAP) — narrow vs full | placeholder | §4.1 |
| | H3.3.2 PIB agrícola — INE cuentas nacionales | placeholder | §4.2 |
| | H3.3.3 Bienes públicos vs transferencias privadas | placeholder | §4.3 |
| | H3.3.4 Repurposing (techo fiscal constante) | placeholder | §4.6 |
| | H3.3.5 Brechas territoriales (score 5-component) | placeholder | §4.7 |
| H2.4 | **Clasificación MAFAP/FAO — operacionalización Bolivia** | **placeholder** | apéndices C+D |
| | H3.4.1 **Taxonomía MAFAP A–E** (5 categorías mayores) | placeholder | apéndice C glosario |
| | H3.4.2 **Definición narrow vs full** — qué incluye cada una | placeholder | — |
| | H3.4.3 **Sub-categorías A — Apoyo al productor** (MPS, input subsidies, payments based on output/area/headage/historical) | placeholder | crosswalk OECD-PSE |
| | H3.4.4 **Sub-categorías B + C** — apoyo consumidor + otros agentes | placeholder | — |
| | H3.4.5 **Sub-categorías D — Apoyo general al sector** (I+D, extensión, sanidad, infraestructura, inspección, capacitación, marketing) | placeholder | clave para repurposing |
| | H3.4.6 **Sub-categorías E — Agropecuario-soporte** (rural roads, electrificación, agua, educación rural, salud rural) | placeholder | diferencia narrow/full |
| | H3.4.7 **Crosswalk MAFAP ↔ OECD-PSE ↔ COFOG** | placeholder | apéndice D |
| | H3.4.8 **Adaptación Bolivia**: cómo se mapea BOOST + VIPFE + EMAPA + crédito BDP a MAFAP | placeholder | script `11_mafap_classification.R` |
| | H3.4.9 **Comparabilidad con APER 2011** — el APER 2011 no usó MAFAP; recálculo aproximado para empalme | placeholder | — |
| | H3.4.10 **Comparabilidad con Maputo/CAADP** — uso de MAFAP narrow | placeholder | — |
| H2.5 | OECD PSE/CSE — definiciones formales | placeholder | METODOLOGIA §4.4–§4.5 |
| | H3.5.1 PSE = MPS + BOT — fórmula completa | placeholder | — |
| | H3.5.2 MPS — Market Price Support — supuestos precios referencia | placeholder | — |
| | H3.5.3 GSSE — General Services Support Estimate — sub-categorías | placeholder | — |
| | H3.5.4 CSE — Consumer Support Estimate | placeholder | — |
| | H3.5.5 NRP — Nominal Rate of Protection por commodity | placeholder | — |
| | H3.5.6 Sensibilidad: PSE alto / medio / bajo | placeholder | — |
| H2.6 | Construcción del panel v12 | outline | METODOLOGIA §5 |
| | H3.6.1 Unidad de observación + pipeline | outline | — |
| | H3.6.2 Reglas de imputación y missing | outline | — |
| | H3.6.3 Deflactor (PIB total) y año base 2015 | outline | — |
| | H3.6.4 Conversión USD (tipo de cambio oficial BCB) | outline | — |
| H2.7 | DEA Simar-Wilson — especificación | placeholder | — |
| | H3.7.1 Inputs y outputs seleccionados | placeholder | — |
| | H3.7.2 Bootstrap y bandas de confianza | placeholder | — |
| | H3.7.3 Comparación con stochastic frontier (PER SSA Box 11) | placeholder | — |
| H2.8 | Panel FE econométrico | placeholder | — |
| | H3.8.1 Especificación `fixest` | placeholder | — |
| | H3.8.2 Cluster, robustez, `post_ley393` | placeholder | — |
| | H3.8.3 Resultados completos (apéndice E) | placeholder | apéndice E |
| H2.9 | Tratamientos especiales | outline | METODOLOGIA §6 |
| | H3.9.1 Empresas estatales (EMAPA) | outline | — |
| | H3.9.2 Subsidios indirectos (combustible, fertilizantes) | outline | — |
| | H3.9.3 Cooperación internacional | outline | — |
| | H3.9.4 Crédito agrícola subsidiado | outline | — |
| | H3.9.5 Gasto subnacional | outline | — |
| H2.10 | Manejo de incertidumbre | outline | METODOLOGIA §8 |
| | H3.10.1 Niveles baja/media/alta | outline | — |
| | H3.10.2 Requisitos por nivel | outline | — |

### 12.2. Cross-refs

- **Autoridad:** [`01_METODOLOGIA.md`](01_METODOLOGIA.md) m0.1.0.
- **Glosario MAFAP**: apéndice C (operativo bilingüe ES/EN).
- **Crosswalk**: apéndice D — `01_data/processed/crosswalk_mafap_oecd_cofog.csv` (a generar).
- **Citas:** Manual MAFAP Vol II (FAO 2013), PER SSA (Pernechele et al. 2021), OECD PSE Manual, Simar-Wilson 1998/2007.

### 12.3. TODO

- [ ] **CRÍTICO:** completar §H2.4 (MAFAP operacionalización Bolivia) — 10 sub-subsecciones, todo placeholder.
- [ ] Replicar §4 de METODOLOGIA en prosa apéndice (definiciones formales).
- [ ] Generar tabla crosswalk MAFAP ↔ OECD-PSE ↔ COFOG (apéndice D).
- [ ] Documentar especificación DEA (escogencia inputs/outputs).
- [ ] Documentar especificación panel FE (cluster, robustez).
- [ ] Caja: "Por qué dos clasificaciones — MAFAP vs OECD-PSE" (resumen del crosswalk).

---

## 13. Apéndice C — Glosario MAFAP bilingüe (`appendix/C_glosario_mafap.qmd`)

**Pregunta operativa:** ¿qué significa cada código MAFAP y cómo se mapea a instrumentos bolivianos concretos?

**Longitud objetivo:** 6–8 pp.
**Status:** 🟢 **borrador avanzado** — archivo `glosario_mafap_es_en.md` ya existe + CSV con 45 entradas. Formalizar como apéndice `.qmd`.

### 13.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status |
|:-:|---|:-:|
| H2.1 | Conceptos previos | borrador |
| | H3.1.1 Qué es MAFAP y por qué se usa en este reporte | borrador |
| | H3.1.2 Diferencia entre MAFAP, OECD-PSE y COFOG | placeholder |
| | H3.1.3 Cobertura conceptual: gasto sectorial completo vs apoyo al productor | placeholder |
| H2.2 | **Categoría A — Apoyo al productor / Producer support** | borrador |
| | H3.2.1 A1 Market price support (MPS) | borrador |
| | H3.2.2 A2 Input subsidies (variable inputs, fixed capital, on-farm services) | borrador |
| | H3.2.3 A3 Payments based on output | borrador |
| | H3.2.4 A4 Payments based on area planted / animal numbers | borrador |
| | H3.2.5 A5 Payments based on historical entitlements | borrador |
| H2.3 | **Categoría B — Apoyo al consumidor / Consumer support** | borrador |
| | H3.3.1 B1 Food consumption subsidies | borrador |
| | H3.3.2 B2 Cash transfers (componente alimentario) | borrador |
| H2.4 | **Categoría C — Apoyo a otros agentes** | borrador |
| | H3.4.1 C1 Processors, traders, transporters | borrador |
| H2.5 | **Categoría D — Apoyo general al sector / General sector support** (GSSE OECD-equivalent) | borrador |
| | H3.5.1 D1 Investigación agropecuaria (INIAF) | borrador |
| | H3.5.2 D2 Extensión y asistencia técnica | borrador |
| | H3.5.3 D3 Sanidad e inocuidad (SENASAG) | borrador |
| | H3.5.4 D4 Infraestructura sectorial (riego, mercados públicos) | borrador |
| | H3.5.5 D5 Inspección, certificación, normas | borrador |
| | H3.5.6 D6 Educación agrícola formal y técnica | borrador |
| | H3.5.7 D7 Información de mercado | borrador |
| | H3.5.8 D8 Capacitación administrativa | borrador |
| H2.6 | **Categoría E — Gasto agropecuario-soporte / Agriculture-supportive expenditure** | borrador |
| | H3.6.1 E1 Caminos rurales | borrador |
| | H3.6.2 E2 Electrificación rural | borrador |
| | H3.6.3 E3 Agua y saneamiento rural | borrador |
| | H3.6.4 E4 Educación rural | borrador |
| | H3.6.5 E5 Salud rural | borrador |
| H2.7 | Notas operativas para Bolivia | borrador |
| | H3.7.1 Mapeo BOOST → MAFAP | placeholder |
| | H3.7.2 Mapeo VIPFE → MAFAP | placeholder |
| | H3.7.3 Mapeo EMAPA → MAFAP (A1 + D según componente) | placeholder |
| | H3.7.4 Mapeo crédito BDP subsidiado → MAFAP A2 (revenue foregone) | placeholder |
| | H3.7.5 Casos ambiguos y cómo se clasifican | placeholder |
| H2.8 | Coexistencia con OECD-PSE | borrador |
| | H3.8.1 Tabla de equivalencias MAFAP ↔ OECD-PSE | placeholder |
| H2.9 | Citación de este glosario | borrador |

### 13.2. Cross-refs

- **Archivo fuente:** `04_report/appendix/glosario_mafap_es_en.md` (ya existe, ~9 subsecciones).
- **CSV diccionario:** `01_data/processed/mafap_categories.csv` (45 entradas, bilingüe).
- **Manual:** `03_literature/Informacion_PER/manual MAFAP.pdf` (FAO 2013, Volumen II).
- **PER SSA:** `03_literature/Informacion_PER/PER subsaharan using MAFAP.pdf` (Pernechele et al. 2021).

### 13.3. TODO

- [ ] Convertir `glosario_mafap_es_en.md` (formato libre) a `C_glosario_mafap.qmd` (formato Quarto con tablas estructuradas).
- [ ] Tabla auto-generada desde `mafap_categories.csv` con columnas: code, level, name_en, def_en, def_es, instrumento boliviano ejemplo.
- [ ] Completar H2.7 (notas operativas Bolivia) — pendiente ejecución de `11_mafap_classification.R`.
- [ ] Verificar paridad bilingüe línea-a-línea.

---

## 14. Apéndice D — Crosswalk de clasificaciones (`appendix/D_crosswalk_clasificaciones.qmd`)

**Pregunta operativa:** ¿cómo se mapean entre sí las tres clasificaciones del gasto sectorial (MAFAP, OECD-PSE, COFOG) y la clasificación funcional MEFP?

**Longitud objetivo:** 4–6 pp.
**Status:** 🔴 placeholder — bloqueado hasta generar `crosswalk_mafap_oecd_cofog.csv`.

### 14.1. Outline detallado

| # | Sección (h2) → sub-secciones (h3) | Status |
|:-:|---|:-:|
| H2.1 | Cuatro clasificaciones en juego | outline |
| | H3.1.1 MAFAP (FAO) — categorías A–E con sub-códigos | outline |
| | H3.1.2 OECD-PSE — PSE, GSSE, CSE, TSE y sub-componentes | outline |
| | H3.1.3 COFOG — Classification of Functions of Government (UN/SNA), 04.2 Agricultura | outline |
| | H3.1.4 Clasificación funcional MEFP — agropecuario en funciones del Estado boliviano | outline |
| H2.2 | Tabla maestra de crosswalk | placeholder |
| | H3.2.1 Columnas: código MAFAP, equivalente OECD-PSE, equivalente COFOG, equivalente MEFP, ejemplos Bolivia | placeholder |
| | H3.2.2 Casos 1:1 (mapeo directo) | placeholder |
| | H3.2.3 Casos 1:N (un código MAFAP → varios OECD) | placeholder |
| | H3.2.4 Casos N:1 (varios MAFAP → un OECD) | placeholder |
| | H3.2.5 Casos ambiguos / discrecionales — con justificación | placeholder |
| H2.3 | Implicaciones cuantitativas del crosswalk | placeholder |
| | H3.3.1 Bolivia GAP bajo MAFAP narrow | placeholder |
| | H3.3.2 Bolivia GAP bajo MAFAP full | placeholder |
| | H3.3.3 Bolivia GAP bajo OECD-PSE+GSSE | placeholder |
| | H3.3.4 Bolivia bajo COFOG 04.2 | placeholder |
| | H3.3.5 Tabla comparativa de las 4 cifras paralelas + caveat | placeholder |

### 14.2. Cross-refs

- **Archivo principal:** `01_data/processed/crosswalk_mafap_oecd_cofog.csv` (a generar — script `02_code/02_classification/crosswalk_generation.R`).
- **Apéndices vinculados:** B (metodología), C (glosario MAFAP).

### 14.3. TODO

- [ ] **BLOQUEADOR:** generar `crosswalk_mafap_oecd_cofog.csv` (tabla maestra).
- [ ] Renderizar tabla Quarto con `gt` (alineación, agrupación por nivel).
- [ ] Tabla resumen 4-cifras-paralelas (narrow MAFAP, full MAFAP, OECD-PSE+GSSE, COFOG 04.2).

---

## 15. Apéndice E — Tablas de regresión panel FE (`appendix/E_regresiones_panel_fe.qmd`)

**Pregunta operativa:** ¿qué muestran los modelos econométricos del cap 5 en detalle, con qué especificación y robustez?

**Longitud objetivo:** 5–7 pp.
**Status:** 🔴 placeholder — bloqueado hasta re-correr `08_extended_regressions.R`.

### 15.1. Outline

| # | Sección | Status |
|:-:|---|:-:|
| H2.1 | Especificación econométrica | placeholder |
| H2.2 | Tabla principal — gasto agro → TFP | placeholder |
| H2.3 | Tabla principal — gasto agro → FIES / pobreza rural | placeholder |
| H2.4 | Robustez 1 — alternativas de deflactor | placeholder |
| H2.5 | Robustez 2 — alternativas de cluster (depto vs muni) | placeholder |
| H2.6 | Robustez 3 — interacciones con `post_ley393` | placeholder |
| H2.7 | Robustez 4 — subsamples (períodos políticos) | placeholder |

### 15.2. TODO

- [ ] Re-correr `08_extended_regressions.R` con panel v12.
- [ ] Producir tablas con `gt` + `modelsummary`.
- [ ] Caja de interpretación cautelosa (correlación ≠ causalidad).

---

## 16. Apéndice F — Resultados DEA Simar-Wilson (`appendix/F_dea_simar_wilson.qmd`)

**Pregunta operativa:** ¿cuál es la eficiencia técnica del gasto agropecuario boliviano comparado entre departamentos y años, y qué tan robustos son los scores?

**Longitud objetivo:** 5–7 pp.
**Status:** 🔴 placeholder — bloqueado hasta ejecutar DEA sobre `dea_dataset.rds`.

### 16.1. Outline

| # | Sección | Status |
|:-:|---|:-:|
| H2.1 | Especificación DEA — inputs, outputs, orientación | placeholder |
| H2.2 | Scores de eficiencia técnica (bootstrap Simar-Wilson 1998) | placeholder |
| H2.3 | Cambio en frontera — Simar-Wilson 2007 | placeholder |
| H2.4 | Heterogeneidad temporal (2012–2020) | placeholder |
| H2.5 | Heterogeneidad subnacional (9 deptos) | placeholder |
| H2.6 | Análisis de sensibilidad (selección de inputs/outputs) | placeholder |
| H2.7 | Cross-check con stochastic frontier (PER SSA Box 11) | placeholder |

### 16.2. TODO

- [ ] Ejecutar DEA con bootstrap Simar-Wilson sobre `01_data/processed/dea_dataset.rds`.
- [ ] Documentar selección de inputs/outputs en caja metodológica.
- [ ] Tabla de scores + figura de frontera.

---

## 17. Apéndice G — Inventario de programas BM activos (`appendix/G_programas_bm.qmd`)

**Pregunta operativa:** ¿qué programas del Banco Mundial están activos en el sector agropecuario boliviano, en qué fase, con qué desembolso?

**Longitud objetivo:** 4–6 pp.
**Status:** 🟡 borrador desde inventario.

### 17.1. Outline

| # | Sección | Status |
|:-:|---|:-:|
| H2.1 | PAR III — diseño y ejecución | borrador |
| H2.2 | MIAGRA y otros programas activos | borrador |
| H2.3 | Programas históricos completados | outline |
| H2.4 | Lecciones operativas para diseño de futuros préstamos | outline |

### 17.2. TODO

- [ ] Tabla resumen desde `00_admin/Inventario_Datos_APER_Bolivia_2026.xlsx`.
- [ ] Cifras de ejecución vía MEFP/SIIF.

---

## 18. Apéndice H — Decisiones metodológicas (ADRs referenciados) (`appendix/H_adrs_metodologicos.qmd`)

**Pregunta operativa:** ¿qué decisiones metodológicas clave se tomaron, con qué justificación y consecuencias?

**Longitud objetivo:** 3–5 pp.
**Status:** 🟡 outline — referenciar ADRs activos.

### 18.1. Outline

| # | ADR | Tema |
|:-:|---|---|
| ADR-0001 | Panel v12 como fuente canónica | METODOLOGIA §1 |
| ADR-0002 | Los 8 hallazgos (F01–F08) como unidades versionadas | HALLAZGOS §1 |
| ADR-0003 | Metodología PSE/CSE (OECD-BID adaptada Bolivia) | METODOLOGIA §4.4 |
| ADR-0004 | Escenarios de repurposing como opciones técnicas | METODOLOGIA §4.6 |
| ADR-0005 | TEEL + superestructura WB como estilo canónico | ESTILO §17 |
| ADR-0006 | Standard 0 anti-prosa-IA como pre-flight obligatorio | ESTILO §3 |
| ADR-0007 | Paleta visual híbrida (institucional + datos) | FIGURAS §6 |
| ADR-0008 | Master Prompt v0.4.0 — integración bloque D | `.agent/decisions/ADR-0008` |
| **ADR-0009** | **Adopción MAFAP narrow + full como clasificación dual** | (propuesto — formalizar) |
| **ADR-0010** | **Crosswalk MAFAP ↔ OECD-PSE ↔ COFOG ↔ MEFP funcional** | (propuesto — formalizar) |

### 18.2. Cross-refs

- ADRs viven en `.agent/decisions/`.
- Solo se incluyen ADRs **aceptados** (no propuestos pendientes).

### 18.3. TODO

- [ ] **Crear ADR-0009 sobre MAFAP narrow + full**.
- [ ] **Crear ADR-0010 sobre crosswalk de clasificaciones**.
- [ ] Para cada ADR: extracto del Resumen + Decisión + Consecuencias (no copiar el ADR entero — solo abstract).

---

## 19. Reglas de actualización de este archivo

`20_CONTENIDO_REPORTE.md` se actualiza con cada sesión que toque un capítulo. Reglas:

| Tipo de cambio | Color | Acción |
|---|---|---|
| Tachar TODO completado | VERDE | edit directo |
| Cambiar status de una sub-subsección (e.g. outline → draft) | VERDE | edit + entry en bitácora del capítulo |
| Añadir/quitar una sub-subsección | AMARILLO | edit + nota en bitácora; impacto en outline |
| Reasignar hallazgo a sección distinta | AMARILLO | edit + verificar consistencia con `04_HALLAZGOS.md` |
| Cambiar la pregunta de política de un capítulo | ROJO | ADR + actualizar MASTER §6 + este archivo |
| Cambiar el outline canónico de los 7 capítulos | ROJO | ADR + actualizar MASTER §4.1 + este archivo |

**Cada sesión que toca contenido debe cerrar con:**

1. Status de la(s) sub-subsección(es) tocada(s) actualizado en la tabla outline.
2. TODO list del capítulo actualizada (tachar lo hecho, agregar lo nuevo).
3. Entry en la bitácora del capítulo con fecha + autor + cambio breve.
4. Si se tocó cifra: actualizar el bloque "Cifras clave" con trazabilidad RDS+script.

---

## 20. Integración con el resto de la gobernanza

| Doc | Relación |
|---|---|
| [`00_MASTER_PROMPT §6`](00_MASTER_PROMPT.md) | plan estratégico (alto nivel); este archivo es el plan operativo (granular) |
| [`04_HALLAZGOS.md`](04_HALLAZGOS.md) | cada hallazgo F<NN> aparece en una o más sub-subsecciones; consistencia bidireccional |
| [`05_ESTILO_NARRATIVO §11–§12`](05_ESTILO_NARRATIVO.md) | checklist por párrafo / por capítulo que cada sub-subsección debe pasar |
| [`07_FIGURAS §15`](07_FIGURAS.md) | cada `figure_id` listado en este archivo debe pasar el checklist FIGURAS |
| [`08_CONTROL §4`](08_CONTROL.md) | clasificación verde/amarillo/rojo aplica a modificaciones de este archivo |
| [`09_AUDITORIA §5`](09_AUDITORIA.md) | A3 por capítulo usa este archivo como insumo de cobertura |
| [`../00_admin/RETOMAR.md`](../00_admin/RETOMAR.md) | bitácora de sesión; resume cambios al `.qmd` y a este archivo |

---

## 21. TODO list general (transversal al book)

### TODO MAFAP — bloqueadores críticos ✅ todos cerrados (sesión 2026-05-23)

- [x] ~~**CRÍTICO MAFAP-1:** crear script `11_mafap_classification.R`~~ → ✓ creado en `02_code/02_cleaning/17_mafap_classification.R` (270 líneas). Lee panel v12 + crosswalk → produce `mafap_bolivia.rds` con 2 cifras paralelas del GAP. **Pendiente ejecución por el usuario.**
- [x] ~~**CRÍTICO MAFAP-2:** generar `crosswalk_mafap_oecd_cofog.csv`~~ → ✓ generado en `01_data/processed/` (41 entradas: A:9, B:5, C:5, D:14, E:8) con columnas `mafap_code`, `oecd_pse_equivalent`, `cofog_code`, `mefp_functional_range`, `bolivia_examples`, `mapping_type`, `notes`.
- [x] ~~**CRÍTICO MAFAP-3:** crear ADR-0009 sobre MAFAP narrow + full~~ → ✓ `.agent/decisions/ADR-0009_mafap_narrow_full.md` (166 líneas).
- [x] ~~**CRÍTICO MAFAP-4:** crear ADR-0010 sobre crosswalk con decisiones de mapeo ambiguo~~ → ✓ `.agent/decisions/ADR-0010_crosswalk_clasificaciones.md` (197 líneas) con 5 reglas operacionales.
- [x] ~~**CRÍTICO MAFAP-5:** convertir glosario MAFAP a apéndice Quarto formal~~ → ✓ `04_report/appendix/C_glosario_mafap.qmd` (171 líneas) con tablas estructuradas A–E + notas operativas Bolivia + tabla de equivalencias con OECD-PSE.
- [x] ~~**CRÍTICO MAFAP-6:** construir las 5 figuras MAFAP del cap 3~~ → ✓ script `02_code/04_visualization/11_figures_mafap.R` (243 líneas) genera fig18a–d + fig18_summary en SVG + PNG 600 DPI + PDF + contratos JSON. **Pendiente ejecución por el usuario.**

### TODO MAFAP — siguiente fase (ejecución)

- [ ] Ejecutar `Rscript 02_code/02_cleaning/17_mafap_classification.R` → verificar cobertura > 95% y tests T1-T5 del log.
- [ ] Ejecutar `Rscript 02_code/04_visualization/11_figures_mafap.R` → revisar 5 figuras visualmente, validar paleta y captions.
- [ ] Render `quarto render 04_report/appendix/C_glosario_mafap.qmd` → verificar referencias internas.
- [ ] Agregar cita `@ghins2013mafap` a `04_report/references.bib`.
- [ ] Firma TTL de ADR-0009 y ADR-0010 (campos `[TODO_TRACE]` en footer).
- [ ] Una vez ejecutados los scripts, actualizar `04_HALLAZGOS.md` F04 (Maputo) con la cifra real bajo MAFAP narrow.
- [ ] Crear `D_crosswalk_clasificaciones.qmd` (apéndice D Quarto) renderizando el CSV con `gt` agrupado por categoría MAFAP.
- [ ] Futuro: script `18_revenue_foregone.R` para separar BDP credit subsidy de BT_agg (sub-categoría A2.2 explícita).

### TODO transversal

- [ ] **Cifras totales:** ~180 esperadas, ~18 trazadas (estimación grosera). Mantener proporción de TODO_TRACE bajo cierre de cada capítulo.
- [ ] **Figuras:** 40 pre-generadas + ~10 nuevas (5 MAFAP cap 3 + 2 DEA cap 5 + 3 escenarios cap 6). Convención dual de naming (master §5.2).
- [ ] **Tablas:** ~30 totales (incluye crosswalks D + regresiones E + DEA F + síntesis 0/6). ~5 listas.
- [ ] **Hallazgos F01–F08:** los 8 deben aparecer al menos una vez en su "capítulo casa" + una vez en el resumen ejecutivo.
- [ ] **APER 2011 cajas comparativas:** una por capítulo 2–6.
- [ ] **Disclaimer técnico:** al cierre de cada capítulo + resumen ejecutivo + apéndices.
- [ ] **Paridad bilingüe:** confirmada para resumen ejecutivo; pendiente para mensajes clave de cada capítulo y para apéndice C (glosario MAFAP).
- [ ] **Cuatro cifras paralelas del GAP** declaradas explícitamente en cap 3 + apéndice D: MAFAP narrow, MAFAP full, OECD-PSE+GSSE, COFOG 04.2. Tabla resumen con caveat.

### Apéndices — estado consolidado

- [ ] **A. Fuentes** — 🟡 borrador parcial → completar inventario 30+ fuentes desde `00_admin/Inventario_*.xlsx`.
- [ ] **B. Metodología detallada** — 🔴 placeholder → escribir tras cerrar DEA + regresiones; §H2.4 MAFAP **desbloqueada** por ADR-0009/ADR-0010 (10 sub-subsecciones listas para redactar con base material).
- [x] ~~**C. Glosario MAFAP bilingüe** — convertir a `.qmd` formal~~ → ✓ **formalizado** en `C_glosario_mafap.qmd` (171 líneas, 9 secciones C.1–C.9).
- [ ] **D. Crosswalk** — 🟡 **CSV maestro listo** (41 entradas) → falta crear `D_crosswalk_clasificaciones.qmd` Quarto que renderice el CSV con `gt`.
- [ ] **E. Regresiones FE** — 🔴 placeholder → bloqueado por re-correr `08_extended_regressions.R`.
- [ ] **F. DEA Simar-Wilson** — 🔴 placeholder → bloqueado por ejecutar DEA.
- [ ] **G. Programas BM** — 🟡 outline → tabla desde inventario + cifras MEFP.
- [x] ~~**H. ADRs metodológicos** — ADR-0009 y ADR-0010 pendientes~~ → ✓ ADR-0009 y ADR-0010 **creados** (166 + 197 líneas). Pendiente: renderizar resumen en `H_adrs_metodologicos.qmd` Quarto.

---

## 22. Cross-walk ToR ↔ Capítulos (verificación de cobertura)

> **Propósito.** Verificar que cada elemento de los dos ToR del proyecto está cubierto por el contenido planeado del book. Esta sección se actualiza cuando se modifica el plan de un capítulo o cuando se ajusta el ToR.

### 22.1 Main TOR (JC — `00_Tor/Main_TOR_JC.pdf`)

**Objetivos del ToR:**

| Objetivo TOR | Cobertura en el reporte | Status |
|---|---|:-:|
| (a) Analizar gasto público agro+rural **2008-2024**, nivel + composición + distribución | Caps 2, 3, 4 | ✓ planeado |
| (a) Indicadores estándar (% gasto total, % PIB, % PIB agro) | Cap 3 H2.2.1; MASTER §5.3 | ✓ planeado |
| (a) Interpretación food security + poverty + sustainability + recomendaciones | Caps 2, 6 + RE | ✓ planeado |
| (b) **Aplicar metodología MAFAP** (categorización + subcategorización) | Caps 3, 4 + Apéndice C glosario + Apéndice D crosswalk | ✓ ADR-0009 + ADR-0010 + script `17_mafap_classification.R` |
| (c) Recolectar info fiscal/financiera nacional y sectorial | Apéndice A + `03_FUENTES.md` | ✓ planeado |
| (d) **Producir Full Report consolidando OECD analysis** | Cap 5 + Cap 6 + integración Hector | ✓ [21_COORDINACION_STC](21_COORDINACION_STC.md) §2.2 |

**Scope del PER:**

| Elemento Scope TOR | Cobertura | Status |
|---|---|:-:|
| Total expenditure executed national gov 2008-2024 | Cap 3 H2.2.1 | ✓ |
| Public expenditure dirigido al sector agro+rural | Cap 3 H2.2 completo | ✓ |
| **Functional disaggregation MAFAP** | Cap 3 H2.2.2–H2.2.6 + Apéndice C | ✓ |
| Administrative classification (current vs investment) | Cap 3 H2.2.7 + variables `boost_gasto_corriente_mm`, `boost_gasto_capital_mm` | ✓ |
| Economic classification (internal vs external sources) | Cap 3 H2.2.8 + `boost_fuente_*` | ✓ |
| Institutional classification (executing agencies) | Cap 3 H2.1 + `boost_n_entidades` | ✓ |
| **Subnacional Santa Cruz, La Paz, Cochabamba** | Cap 4 H2.2.2–H2.2.4 | ✓ explícito tras update v0.4.0 |

**Indicadores requeridos:**

| Indicador TOR | Variable panel / cálculo | Cap | Status |
|---|---|:-:|:-:|
| Agro+rural / total public expenditure | `inv_agro_pct_total` + `mafap_full / govt_total` | 3 | ✓ |
| Total/agro/rural % PIB | `inv_agro_pct_gdp` + WDI `wdi_govt_exp_pct_gdp` | 3 | ✓ |
| Total/agro/rural % **PIB agropecuario** | derivado de `agr_value_added_pct_gdp` | 3 | ✓ |
| Nominal growth | calculado en script | 3 | ⚠ falta función `g_real` formal |
| **Real growth** (BOB 2015) | calculado en script con deflactor | 3 | ✓ |

**Research Questions:**

| RQ | Cobertura | Status |
|---|---|:-:|
| RQ1: Level + composition spending agro+rural 2008-2024 + behavior durante shocks (commodity, COVID) | Cap 2 H2.5 + Cap 3 + Cap 5 | ⚠ Cap 2 H2.5 cubre genérico; falta explícito de commodity cycles + COVID |
| RQ2: Structure consistent con climate adaptation + productivity convergence + food security | F08 (climate), F01 (productivity), F06 (food security) — caps 2, 5, 6 | ✓ los 3 hallazgos cubren las 3 dimensiones |

**International Benchmarks:**

| Benchmark | Cobertura | Status |
|---|---|:-:|
| **MAFAP partner countries** primary | Caps 3, 4 — PER SSA Pernechele 2021 + PER Filipinas Weiss 2023 | ✓ |
| OECD PSE/CSE complementary | Cap 5 — IADB AgriMonitor LAC | ✓ (input Hector) |

**Deliverables del Main TOR:**

| # | Deliverable Main TOR | Mapeo en el reporte | Fecha | Status |
|:-:|---|---|---|:-:|
| D1 | Initial work plan (5 días post-inicio) | `00_admin/RETOMAR.md` + cronograma | May 17 | ✓ |
| D2 | **Database 2008-2024 MAFAP-coded + crosswalk MEFP + methodological note** | `01_data/processed/mafap_bolivia.rds` (output script `17_mafap_classification.R`) + `crosswalk_mafap_oecd_cofog.csv` + Apéndice B | May 31 | 🟡 scripts creados, pendiente ejecutar |
| D3 | **Analytical PowerPoint comprehensive** | `slides/` (deck analítico, distinto del executive deck de 20 láminas) | Jun 15 | ⨯ pendiente — crear deck analítico |
| D4 | **Executive Summary 4-6 pp ES** + final consolidated PowerPoint | Cap 0 del book + slides ejecutivas | Jun 30 | 🟡 cap 0 esqueleto, longitud ajustada a 4-6 pp |
| D5 | **Full Report consolidating + OECD inputs** | Quarto book completo (7 caps + 8 apéndices) | Jun 30 | 🟡 outline completo, redacción pendiente |

### 22.2 Secondary TOR (Hector — `00_Tor/Secondary_TOR_Hector.pdf`)

**Lo que Hector produce y cómo entra al reporte JC:**

| Objetivo TOR Hector | Output Hector | Entra a reporte JC en | Status |
|---|---|---|:-:|
| (a) Analizar indicadores PSE IADB + comparaciones OECD + regional | PPT IADB analysis | Cap 5 §H2.1 + Cap 0 | 🟡 esperando |
| (b) Training OECD on-site La Paz "learning by doing" | Sesión presencial (~2 sem) | NO entra al book | n/a |
| (c) **Repurposing fiscal cost** (Q1 reducir MPS + Q2 aumentar public goods) | Repurposing Report | Cap 6 §H2.3 + apéndice | 🟡 esperando |
| Trends prices, production, trade, consumption | Material para training | Cap 5 §H2.2 (NRP) | 🟡 |
| Alignment con climate, biodiversity, productivity | Material analytical | Cap 6 + Cap 2 H2.4 | 🟡 |
| **GHG emissions, fertilizer, land use, water productivity** | Datos environmental | Cap 2 H2.4 + panel | ⚠ water productivity es gap (R-016) |

**Lo que JC entrega a Hector:**

| Output JC | Para Hector | Fecha |
|---|---|---|
| MAFAP-coded panel (D2) | Verificación cruzada vs OECD | May 31 |
| Apéndice C glosario MAFAP | Insumo training | semana 4 |
| Apéndice D crosswalk MAFAP↔OECD↔COFOG↔MEFP | Insumo training | semana 4 |

### 22.3 Brechas de cobertura identificadas (sesión 2026-05-24)

| # | Brecha | Acción | Doc |
|:-:|---|---|---|
| 1 | Período 2008-2024 explícito como canónico | ✓ aplicado en MASTER §5.3 | 00_MASTER_PROMPT |
| 2 | MAFAP Group I/II clarificación | ✓ aplicado en MASTER §5.3 | 00_MASTER_PROMPT |
| 3 | Cap 0 longitud 4-6 pp (no 6-8) | ✓ aplicado en MASTER §4.1 + 20 §4 | 00_MASTER + 20_CONTENIDO |
| 4 | Coordinación formal con Hector | ✓ creado `21_COORDINACION_STC.md` | 21 (nuevo) |
| 5 | Inputs Hector marcados en Cap 5 y Cap 6 | ✓ aplicado en 20 §9, §10 | 20_CONTENIDO |
| 6 | Santa Cruz/La Paz/Cochabamba explícitos en Cap 4 | ✓ aplicado en 20 §8 | 20_CONTENIDO |
| 7 | Crosswalk MAFAP→MEFP funcional con códigos reales VIPFE | ⨯ pendiente — completar `crosswalk_mafap_oecd_cofog.csv` columna `mefp_functional_range` con códigos reales | crosswalk CSV |
| 8 | 5 riesgos R-014–R-018 coordinación Hector | ⨯ pendiente — agregar a 10_RIESGOS | 10_RIESGOS |
| 9 | Water productivity gap → solicitar a Hector | ⨯ pendiente — flag en 03_FUENTES + 21_COORDINACION §3.1 ya documentado | 03_FUENTES |
| 10 | Commodity cycles + COVID explícitos en Cap 2 H2.5 | ⨯ pendiente — desagregar sub-subsecciones específicas | 20_CONTENIDO §6 |
| 11 | D3 Analytical PowerPoint (distinto de slides ejecutivas) | ⨯ pendiente — crear plan de deck analítico | nuevo file en slides/ |
| 12 | Cita BibTeX `@ghins2013mafap` + `@pernechele2021` | ⨯ pendiente | `04_report/references.bib` |

---

## 23. Integración del corpus de literatura (sesión 11 — revisión profunda)

> **Cambio v0.5.0.** Tras la revisión profunda de literatura (sesión 11 del proyecto), el corpus se reorganizó por completo. Esta sección reemplaza la sección de citas dispersa en cada capítulo con una estrategia consolidada de evidencia, alineada con [`03_literature/evidence_map.md`](../03_literature/evidence_map.md) y [`03_literature/README.md`](../03_literature/README.md).

### 23.1 Estado del corpus

| Métrica | Antes (v0.4.0) | Después (v0.5.0) | Δ |
|---|---:|---:|---:|
| Entradas BibTeX | 11 (en `04_report/references.bib`) | **359** (en `03_literature/references_master.bib`) + 313 únicas en evidence_map | +32× |
| Fichas markdown | ~7 (MDRyT + PER) | **325** | +46× |
| PDFs descargados | ~10 | **163** (434 MB) | +16× |
| Cobertura temporal | esporádica | **1957–2025** (Farrell 1957 / Schultz 1964 → IMF 2025 / OECD 2025) | sistemática |
| Carpetas temáticas | 2 ad-hoc | **11 sistemáticas** + MDRyT + PER | + sistema |

### 23.2 Las 11 carpetas temáticas

Ubicación canónica: `03_literature/<carpeta>/`. Naming: `<AuthorYYYY>_<slug>.md` para fichas, `*.pdf` para PDFs.

| # | Carpeta | Fichas | Nivel evidencia | Cap casa principal |
|:-:|---|:-:|:-:|:-:|
| 01 | `01_systematic_reviews/` | 23 | **1–2** ★★★★★ | Caps 2, 5 (transversal alta) |
| 02 | `02_public_spending/` | 34 | 3–5 | Cap 3 |
| 03 | `03_productivity_efficiency/` | 33 | 3–5 | Caps 2, 4 |
| 04 | `04_climate_food_security/` | 33 | 1–5 | Caps 1, 2 |
| 05 | `05_value_chains/` | 34 | 4–6 | Cap 2 |
| 06 | `06_smallholder_indigenous/` | 29 | 4–7 | Cap 2 |
| 07 | `07_subsidies_repurposing/` | 39 | 2–4 | **Cap 5 (tema central) + Cap 6** |
| 08 | `08_institutions_programs/` | 32 | 5–7 | Cap 4 |
| 09 | `09_methods_per_pse/` | 38 | 2–5 | Caps 3, 4, 5 + Apéndice B |
| 10 | `10_macro_growth_poverty/` | 23 | 4–7 | Cap 1 |
| 11 | `11_local_multilateral_bolivia/` | 46 | varia | transversal Bolivia |
| | `mdryt_fichas/` | 7 | 7 | Cap 3 (fichas institucionales) |
| | `Informacion_PER/` | 1+ manuals | 7 | Apéndice B (método) |

**Niveles de evidencia (jerarquía):**

- **1** Revisiones Cochrane / meta-análisis registrados (★★★★★)
- **2** Meta-análisis no-Cochrane / revisiones sistemáticas (★★★★)
- **3** Quasi-experimentales rigurosos (DiD, RDD, IV) (★★★)
- **4** Estudios observacionales con buen control (★★★)
- **5** Estudios descriptivos / cross-section (★★)
- **6** Working papers / pre-print (★★)
- **7** Literatura gris institucional (★) — usar con caveat

### 23.3 Patrones transversales identificados (6 temas)

| # | Patrón | Fuentes ancla | Capítulos donde aplica |
|:-:|---|---|---|
| 1 | **Composición del gasto** — mover 10pp de transferencias a bienes públicos eleva ingreso rural ~5% en LAC | `@Anriquez2017IDB`, `@AnriquezFosterOrtega2020_RuralSubsidiesLAC`, `@LopezGalinato2007` | Caps 3, 5 |
| 2 | **Repurposing de subsidios (TEMA CENTRAL CAP 5)** — soporte global ~USD 600 mil M/año, 87% con efectos negativos | `@Gautam2022`, `@FAOUNEPUNDP2021`, `@WorldBank2024_RepurposingSupport`, `@Damania2023`, `@SpringmannFreund2022`, `@MasonDCroz2022` | **Cap 5 + Cap 6** |
| 3 | **Productividad y eficiencia** — TFP Bolivia 0.61%/año (más bajo LAC), crecimiento por área no por productividad | `@Bragagnolo2021`, `@Fuglie2024`, `@FuglieRada2013`, `@Ludena2010`, `@WorldBank2021_TappingBolivia` | Caps 2, 4 |
| 4 | **Clima + seguridad alimentaria + resiliencia** — glaciares andinos −30-50%, ENSO 25% variabilidad lluvia, 41% hogares rurales no costean canasta | `@Rabatel2013`, `@Canedo2021`, `@WFP2022_BoliviaACR`, `@IPCC2022_Ch12`, `@AndersenVerner2009` | Caps 1, 2 |
| 5 | **Agricultura familiar e indígena Bolivia** — 87.6% producción nacional alimentos AFCI, 92.2% UPAs en 20.6% del área | `@CIPCA2014`, `@CIPCA2021`, `@INE2015_Censo`, `@Pacheco2006`, `@PICAR_WorldBank2021` | Cap 2 |
| 6 | **Macro y pobreza Bolivia** — pobreza 60→37% (2002–2018), modelo MESCP en agotamiento, reservas en mínimos 2024-25 | `@WorldBank2021_SCDUpdate`, `@WorldBank2024_PovertyEquityBrief`, `@IMF2025_ArticleIV2025`, `@UDAPE2025_BrechasSociales` | Cap 1 |

### 23.4 Mapeo evidencia ↔ capítulos (fuentes ancla obligatorias)

Reemplaza el bloque "Citas requeridas" disperso en cada capítulo. **Cada capítulo debe citar al menos las fuentes ancla listadas.**

#### Cap 1 — Contexto sectorial y macro
1. `@WorldBank2021_TappingBolivia` — diagnóstico sectorial BM
2. `@WorldBank2021_SCDUpdate` — diagnóstico país BM
3. `@IMF2025_ArticleIV2024`, `@IMF2025_ArticleIV2025` — macro reciente
4. `@IPCC2022_Ch12` — clima Sudamérica
5. `@FAO2024Bolivia` — subsidios Bolivia 11.6% PIB
6. `@CIPCA2021`, `@INE2015_Censo` — estructura productiva
7. `@Andersen_Faris2002_NaturalGas` — Dutch disease
8. `@WFP2022_BoliviaACR` — inseguridad alimentaria 41%

#### Cap 2 — Estructura y desempeño del sector
1. `@Bragagnolo2021` — TFP Bolivia 0.61%/año
2. `@Fuglie2024` — TFP LAC comparativo
3. `@FuglieRada2013` — TFP global LAC
4. `@INE2015_Censo` — Censo Agropecuario 2013
5. `@IBCE2024_Exportaciones` — comercio agrícola
6. `@CIPCA2014`, `@CIPCA2021` — agricultura familiar
7. (frontera/cobertura) MapBiomas + Hansen GFC (panel v12, no biblio externa)

#### Cap 3 — Composición y trayectoria del gasto agrícola
1. `@WB2014_PEMethodGuideVolII`, `@MAFAP2013_MethodGuideVolI` — método clasificación
2. `@LopezGalinato2007`, `@Anriquez2017IDB` — composición LAC
3. `@FAO2021_PEFoodAgricultureSSA`, `@Pernechele2018` — síntesis SSA
4. `@IMF_GFSM2014` — clasificación funcional
5. `@WB_BOOST` — método BOOST
6. `@WB2011_BoliviaAgPER` — antecedente Bolivia 2011

#### Cap 4 — Eficiencia del gasto (DEA + programas)
1. `@SimarWilson1998`, `@SimarWilson2007` — método DEA bootstrap
2. `@Coelli1996_DEAP21Guide`, `@Wilson2008FEAR` — software
3. `@Ludena2010` — DEA LAC 26 países
4. `@Schling2024LandRegularization` — titulación INRA +38.6% eficiencia
5. `@PAR_WorldBank2024_ICR`, `@PICAR_WorldBank2021` — evaluaciones BM
6. `@PlanVida_IFAD_ImpactAssessment` — eval IFAD

#### Cap 5 — PSE Bolivia + opciones de repurposing (**capítulo más denso en literatura**)
1. `@Gautam2022` — marco WB-IFPRI repurposing
2. `@FAOUNEPUNDP2021` — marco FAO/UNDP/UNEP
3. `@WorldBank2024_RepurposingSupport`, `@Damania2023` — WB Recipe / Detox
4. `@OECD2025_APME`, `@OECD_PSE_Manual` — método PSE
5. `@DeSalvoEtAl2018_IDB_AgSupportLAC`, `@IDB_Agrimonitor` — PSE LAC
6. `@AnriquezFosterOrtega2020_RuralSubsidiesLAC` — cuantificación reasignación
7. `@SpringmannFreund2022`, `@MasonDCroz2022` — beneficios reforma
8. `@FundacionSolon2023`, `@FundacionTierra2024` — perspectiva Bolivia
9. `@Rentschler2017` — economía política gasolinazo 2010
10. `@Alston2011`, `@AlstonPardey2000`, `@Hurley2014` — retornos I+D (con caveat MIRR)

#### Cap 6 — Recomendaciones
1. (Todas las anteriores como soporte) +
2. Casos de éxito repurposing: India, Indonesia, China (en `@Gautam2022`)
3. `@WB2014_PEMethodGuideVolII` — secuenciación
4. `@FOLU2019` — 10 transiciones del sistema alimentario

### 23.5 Reglas de citación adoptadas (de `03_literature/README.md` §5)

#### Cuándo citar literatura externa

✅ **Sí citar:**
- Cifras o tamaños de efecto de fuera del panel v12 (e.g., retornos a I+D globales).
- Marcos conceptuales (e.g., repurposing framework Gautam 2022).
- Decisiones metodológicas (e.g., DEA Simar-Wilson).
- Comparaciones Bolivia vs LAC o mundo.

❌ **No citar externa:**
- El número se calculó desde panel v12 → citar el panel y `02_INDICADORES.md`.
- Dato boliviano de fuente oficial (BOOST/INE/VIPFE) → citar fuente primaria, no literatura secundaria.

#### Citaciones combinadas (síntesis de 2-3 fuentes convergentes)

```markdown
La evidencia LAC sugiere que reasignar 10 pp del gasto desde transferencias hacia bienes
públicos eleva el ingreso rural en aproximadamente 5%
[@Anriquez2017IDB; @AnriquezFosterOrtega2020_RuralSubsidiesLAC; @LopezGalinato2007].
```

#### Caveats obligatorios con incertidumbre

```markdown
El meta-análisis de retornos a I+D agrícola reporta una mediana de ~44%/año
[@AlstonPardey2000], aunque Hurley et al. [-@Hurley2014] muestran que corrigiendo por
reinversión la MIRR realista cae a 9-12%/año.
```

### 23.6 Vacíos de evidencia identificados

#### Bolivia-específicos

| Vacío | Severidad | Cómo se aborda en el APER 2026 |
|---|:-:|---|
| No existe PER agrícola Bolivia posterior a 2011 (`@WB2011_BoliviaAgPER`) | 🔴 Alta | **El APER 2026 llena este vacío de 15 años** (justificación central del proyecto) |
| PSE Bolivia oficial OECD no existe; Agrimonitor IDB cubre parcialmente | 🔴 Alta | El APER construirá PSE Bolivia 2010–2024 con coordinación Hector como aporte metodológico ([21_COORDINACION_STC](21_COORDINACION_STC.md)) |
| MAFAP no cubre LAC (solo África) | 🟡 Media | Adaptación MAFAP-PSE dual del APER cubre esto ([ADR-0009](decisions/ADR-0009_mafap_narrow_full.md)) |
| Evaluación causal Mi Riego, BDP, EMAPA: solo literatura gris | 🟡 Media | Cap 4 marca como gap de evaluación |
| Censo Agropecuario 2024 no público aún | 🟡 Media | Usar Censo 2013 (INE) + extrapolaciones panel v12 |

#### Literatura global

| Vacío | Severidad | Implicación |
|---|:-:|---|
| Meta-análisis específicos Bolivia: cero | 🟡 Media | Bolivia aparece solo como caso secundario en síntesis LAC |
| Estudios cuantitativos cadenas bolivianas en journals top: limitado | 🟡 Media | Mucha literatura gris CIPCA, TIERRA, CIRAD |

#### Metodológicos

| Vacío | Severidad | Cómo se aborda |
|---|:-:|---|
| DEA aplicado a eficiencia del gasto público (no fincas) en LAC: escaso | 🟡 Media | Aporte original del APER Cap 4 |
| MIRR vs IRR en retornos I+D Bolivia: no existe estimación | 🟡 Media | Cap 5 usa rangos globales con caveats explícitos |

### 23.7 Sincronización con references.bib del book

**Decisión operativa:**

- `03_literature/references_master.bib` (159 KB, 359 entradas) es la **fuente única canónica**.
- `04_report/references.bib` (3 KB actual, 11 entradas) está **OBSOLETO** y debe ser reemplazado.

**Acción TODO (P0):**

```bash
# Antes de cualquier render del book, sincronizar:
cp 03_literature/references_master.bib 04_report/references.bib
```

O preferiblemente: configurar `_quarto.yml` para que apunte directo a `03_literature/references_master.bib`.

### 23.8 Workflow de incorporación de nueva literatura

Cuando aparezca un nuevo documento relevante:

1. Decidir la carpeta temática (01–11) según taxonomía §23.2.
2. Crear ficha `<AuthorYYYY>_<slug>.md` siguiendo `03_literature/_template_external.md`.
3. Agregar entrada BibTeX a `references_master.bib`.
4. Si el documento aporta cifra ancla para un capítulo, agregar a §23.4 (mapeo capítulo) **y** actualizar el bloque del capítulo correspondiente en 20_CONTENIDO_REPORTE.
5. Sincronizar `references.bib` (ver §23.7).
6. Si es revisión sistemática / meta-análisis (nivel 1-2), considerar como evidencia ancla automáticamente.

### 23.9 Auditoría de citas pendiente

Cuando un capítulo entre a estado `reviewed`:

- Correr `/check-citations <path-qmd>` (gate §13B literatura, [09_AUDITORIA](09_AUDITORIA.md)).
- Verificar que **todas** las cifras del capítulo se mapean a una de: (a) panel v12, (b) cita en references_master.bib con audit_status `green` o `yellow`, (c) `[TODO_TRACE]` declarado.
- Para citas con audit_status `red` (no verificable): re-buscar fuente primaria o eliminar la afirmación.

### 23.10 Brechas pendientes (post-integración)

| # | Brecha | Acción | Prioridad |
|:-:|---|---|:-:|
| L-1 | Sincronizar `04_report/references.bib` con `03_literature/references_master.bib` | `cp` o configurar `_quarto.yml` | P0 |
| L-2 | Auditoría manual de fichas con TBV marks (cifras críticas) | Sesión dedicada | P1 |
| L-3 | Cruzar evidencia ↔ hallazgos F01–F08 (validar que cada hallazgo tiene fuentes ancla suficientes) | Edit en `04_HALLAZGOS.md` | P1 |
| L-4 | Activar `/write-section` para Cap 1 (el más dependiente de literatura externa) | Próxima sesión de redacción | P1 |
| L-5 | Cita TBC `@ghins2013mafap` ya cubierta por entradas existentes (`@WB2014_PEMethodGuideVolII`, `@MAFAP2013_MethodGuideVolI`) — verificar | Edit BibTeX | P2 |

---

## 24. Bitácora general

| Fecha | Autor | Cambio |
|---|---|---|
| 2026-05-23 | JCM | v0.1.0 — Versión inicial. Migrado outline de MASTER §6 (alto nivel) y desagregado a sub-subsecciones (h3) por capítulo. Status inicial heredado del MASTER. Bloqueadores identificados (cap 5: regresiones+DEA; cap 6: STC). Total: 9 bloques de contenido (7 capítulos + 2 apéndices). |
| 2026-05-23 | JCM | **v0.2.0 — Integración FAO MAFAP + expansión de apéndices.** Cap 3 expandido con 9 sub-subsecciones MAFAP A–E (narrow/full). Cap 4 integra MAFAP a nivel subnacional. Apéndice B expandido con §H2.4 dedicado a MAFAP operacionalización Bolivia (10 sub-subsecciones). **Nuevos apéndices:** C (Glosario MAFAP bilingüe, formaliza archivo existente), D (Crosswalk MAFAP↔OECD-PSE↔COFOG↔MEFP), E (Regresiones panel FE), F (DEA Simar-Wilson), G (Programas BM), H (ADRs metodológicos). Total apéndices: 2 → 8. Total figuras objetivo: 40 → 45 (+5 MAFAP). Tablas: 25 → 30 (+5 crosswalks/regresiones). MASTER §4.1 sincronizado con los 8 apéndices y nota explícita sobre clasificación dual MAFAP+PSE. 6 TODOs MAFAP críticos identificados. |
| 2026-05-23 | JCM | **v0.3.0 — Los 6 bloqueadores MAFAP críticos ejecutados.** Artefactos creados: ADR-0009 (166 líneas, adopción narrow+full); ADR-0010 (197 líneas, crosswalk con 5 reglas de mapeo ambiguo); `crosswalk_mafap_oecd_cofog.csv` (41 entradas 4-way: A:9, B:5, C:5, D:14, E:8); `C_glosario_mafap.qmd` (171 líneas, 9 secciones C.1–C.9, tablas estructuradas A–E + equivalencias OECD-PSE); script `17_mafap_classification.R` (270 líneas, produce mafap_bolivia.rds con 2 cifras del GAP + 5 tests T1–T5 + log cobertura); script `11_figures_mafap.R` (243 líneas, 5 figuras MAFAP en SVG+PNG 600 DPI+PDF). Total: 1273 líneas de artefactos canónicos. Pendiente: ejecución de scripts por el usuario + firma TTL de ADRs + cita BibTeX `@ghins2013mafap` + creación de `D_crosswalk_clasificaciones.qmd` Quarto desde el CSV maestro. |
| 2026-05-24 | JCM | **v0.4.0 — Alineación con los dos ToR + coordinación formal con consultor Hector.** Cross-walk completo Main TOR JC + Secondary TOR Hector contra contenido del book. **MASTER §5.3** actualizado con: ventana canónica 2008–2024 (ext. 2025) + MAFAP Group I=narrow / Group I+II=full + indicadores TOR obligatorios + shocks explícitos (commodity, COVID, sequía 2023, Ley 393) + RQ2 mapeo a F08/F01/F06. **MASTER §4.1** Cap 0 ajustado a 4–6 pp (alineación TOR D4). **Nuevo doc canónico**: `.agent/21_COORDINACION_STC.md` (Bloque F — coordinación inter-consultor) con división operativa de contenido por capítulo + outputs esperados de Hector + cronograma integrado 7 semanas + protocolo de integración + 5 riesgos R-014 a R-018. **Cap 0, 5, 6** marcados con dependencia explícita de outputs Hector. **Cap 4 H2.2** desagregado con Santa Cruz, La Paz, Cochabamba explícitos (alineación TOR JC Scope). **Nueva §22 Cross-walk ToR ↔ Capítulos** con verificación de cobertura: 12 brechas identificadas, 6 cerradas en esta sesión, 6 pendientes (códigos VIPFE reales en crosswalk, registro R-014–R-018, gap water productivity, commodity+COVID sub-secciones, deck D3 analytical, citas BibTeX). |
| 2026-05-24 | JCM | **v0.5.0 — Integración del corpus de literatura (sesión 11 revisión profunda).** Antes: 11 entradas BibTeX en `04_report/references.bib`. Ahora: **359 entradas en `03_literature/references_master.bib` + 325 fichas markdown en 11 carpetas temáticas + 163 PDFs (434 MB)**. Cobertura temporal 1957–2025. **Nueva §23 "Integración del corpus"** (~250 líneas, 10 subsecciones): estado del corpus, taxonomía 11 carpetas con nivel de evidencia, **6 patrones transversales** con fuentes ancla, **mapeo evidencia ↔ 6 capítulos** (fuentes ancla obligatorias por cap), reglas de citación (cuándo citar externa, citaciones combinadas, caveats), 10 vacíos de evidencia identificados (Bolivia-específicos + global + metodológicos), sincronización `references_master.bib` ↔ `references.bib` (TODO P0), workflow de incorporación, auditoría de citas pendiente, 5 brechas L-1 a L-5. **Bloques "Citas requeridas" reescritos en caps 5, 6, 7, 8, 9, 10** apuntando a fuentes ancla concretas con `@keys` (Cap 5 destacado con 10+ ancla como capítulo más denso). **Apéndice A H2.7 expandido** con 5 sub-subsecciones para documentar corpus en el book final. **Cap 5 confirmado como capítulo más denso en literatura** (repurposing TEMA CENTRAL): Gautam 2022 + FAO/UNEP/UNDP + WB Recipe + OECD APME + Springmann + Anriquez-Foster-Ortega + Rentschler + Alston/Hurley (caveat MIRR). |
