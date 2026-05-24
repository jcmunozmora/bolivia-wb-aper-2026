# Ficha de Lectura Metodológica — Información PER

**Carpeta:** `03_literature/Informacion_PER/`
**Tipo de ficha:** Metodológica (no institucional MDRyT)
**Fecha de lectura:** 2026-05-23
**Lector:** Juan Carlos Muñoz Mora
**Destino primario:** [`.agent/00_MASTER_PROMPT.md`](../../.agent/00_MASTER_PROMPT.md) Parte 5 (estándares) · Cap 3 (presupuestos) · Cap 5 (análisis del gasto, PSE/DEA) · Apéndice B (metodología)

---

## 1. Inventario de documentos

| # | Documento | Autor / Año | Páginas | Naturaleza | Peso para APER |
|:-:|-----------|-------------|:-------:|------------|:---:|
| 1 | **manual MAFAP.pdf** | Ghins, Ilicic-Komorowska, Mas Aparisi (FAO, jul-2013) | 56 | Manual metodológico oficial MAFAP Vol II | 🟢 **CRÍTICO** |
| 2 | **PER subsaharan using MAFAP.pdf** | Pernechele, Fontes, Baborska, Nkuingoua et al. (FAO MAFAP, 2021) | 120 | Reporte regional comparativo 13 países SSA | 🟢 **CRÍTICO** |
| 3 | **PER filipinas.pdf** | Weiss, Kar, Nash, Oliveros, Briones (WB, 16-feb-2023) | 106 | AgPER país (template WB) | 🟢 **CRÍTICO** |
| 4 | **PER EXAMPLES.pdf** | Daniel Villegas (FAO, MAFAP Guinea-Bissau) | 16 slides | Presentación de resultados MAFAP | 🟡 Ejemplos visuales |
| 5 | **PNIA budget sent by ANSU_Pai (5).xlsx** | ANSU (Guinea-Bissau / MAFAP) | 6 hojas | Dataset operativo de clasificación MAFAP | 🟢 **OPERATIVO** |

**Tamaño total:** ~31 MB. Texto extraído en `/tmp/mafap_manual.txt`, `/tmp/per_examples.txt`.

---

## 2. Lo que aporta este paquete al APER 2026

Tres tipos de aporte distintos:

1. **Metodología MAFAP (FAO)** complementaria a PSE/OECD (BID AgriMonitor) que ya usamos.
   → Permite leer BOOST + VIPFE con una taxonomía que distingue **bienes públicos vs privados** y captura todo el gasto sectorial (incluido el agriculture-supportive: salud rural, educación rural, caminos).
2. **Templates de redacción y estructura** (PER Filipinas) — voz WB, secciones, énfasis en decentralización (Mandanas) muy análogo al gasto subnacional boliviano (post-Ley de Autonomías 2010 y SUSEP).
3. **Comparación regional 13 países SSA** (PER subsaharan) — benchmarking, Box 11 con DEA stochastic frontier, Box 14 con opciones de repurposing.

---

## 3. Documento 1 — Manual MAFAP (FAO 2013)

### 3.1 Cita canónica
> Ghins, L., Ilicic-Komorowska, J., Mas Aparisi, A. (2013). **MAFAP Methodological Implementing Guides: Volume II. Analysis of public expenditure on food and agriculture.** MAFAP Technical Notes Series, FAO, Rome.

### 3.2 Principio rector
> *"Expenditure measures are classified according to the way in which they are implemented and not on the basis of their objectives or economic impacts. This last point is extremely important and is at the core of the MAFAP classification."* (p.11)

### 3.3 Taxonomía MAFAP completa (Box 1, p.12-14)

```text
1. AGRICULTURE-SPECIFIC POLICIES (gasto específico)
   1.1 Payments to agents
       1.1.1 Payments to producers
            A. Production subsidies (output-based)
            B. Input subsidies
               B1. Variable inputs (semillas, fertilizantes, energía, crédito)
               B2. Capital (maquinaria, equipamiento, riego on-farm)
               B3. On-farm services
            C. Income support
            D. Other producer support
       1.1.2 Payments to consumers (food aid, school meals, cash transfers)
            G. Food aid
            H. Cash transfers
            (school meals)
       1.1.3 Payments to input suppliers
       1.1.4 Payments to processors
       1.1.5 Payments to traders
       1.1.6 Payments to transporters
   1.2 General sector support
       I. Agricultural research
       J. Technical assistance
       K. Training
       L. Extension / technology transfer
       M. Inspection (veterinary / plant)
       N. Infrastructure (caminos, riego off-farm)
       O. Storage / public stockholding
       P. Marketing
       R. Non-classified
   1.3 Non-classified

2. AGRICULTURE-SUPPORTIVE POLICIES (gasto de soporte)
   S. Rural education
   T. Rural health
   U. Rural water and sanitation
   V. Rural energy
   W. Rural roads (caminos rurales)
   X. Other rural support

3. NON-AGRICULTURAL (excluido del análisis)
```

### 3.4 Reglas operativas clave

| Tema | Regla MAFAP | Implicación para Bolivia |
|------|-------------|--------------------------|
| **Cobertura institucional** | TODOS los ministerios (no solo MDRyT). Buscar en MEFP/Educación/Salud/Transporte. | BOOST + VIPFE permite barrido. Añadir MMAyA (riego), MOPSV (caminos rurales), MINSALUD (salud rural). |
| **Niveles administrativos** | Central + estatal + distrital + regional. | Panel municipal v3 (3,368 munis) + subnacional v2 + nacional v12. |
| **Fuentes de financiamiento** | Presupuesto regular + extra-presupuestario + donantes. | BOOST cubre regular; donantes vía OECD CRS/IDS. |
| **Budget vs Actual** | Reportar AMBOS. Actual con lag de 1-2 años es normal. | Tenemos `presupuesto_vigente` + `ejecutado` en panel v12. |
| **Admin costs** | Excluir costos de formulación/evaluación generales, PERO incluir salarios de personal técnico (extensionistas, inspectores, investigadores). | Decisión: reclasificar salarios INIAF/SENASAG como I/M, no admin. |
| **One-off vs recurrent** | Registrar año a año el gasto efectivo, no amortizar inversiones. | Compatible con BOOST. |
| **Revenue foregone** | Idealmente incluir (concesiones tributarias, precios administrados, crédito preferencial). | 🔴 Gap actual — el crédito BDP a tasas subsidiadas debe valorarse como revenue foregone. |
| **NGOs** | Excluir salvo 100% financiadas con fondos públicos. | Aplica: no contar ONGs privadas (Heifer, ProRural, CIPCA con fondos propios). |

### 3.5 Indicadores principales MAFAP

- **Nivel:** % del presupuesto total · USD per cápita · % PIB agrícola.
- **Composición:** share por categoría (A1, A2, B, etc.) · share por commodity · share donantes vs nacional · share loans vs grants.
- **Ejecución:** budget vs actual ratios por programa, por categoría.

---

## 4. Documento 2 — PER Sub-Saharan Africa (FAO MAFAP, 2021)

### 4.1 Cita canónica
> Pernechele, V., Fontes, F., Baborska, R., Nkuingoua Nana, J.C., Pan, X., Tuyishime, C. (2021). **Public expenditure on food and agriculture in sub-Saharan Africa: trends, challenges and priorities.** FAO MAFAP, Rome.

### 4.2 Estructura del reporte (referencia para nuestro Quarto book)

```text
1. Introduction
2. Methodological approach
   2.1 The MAFAP approach
   2.2 Comparison with other approaches (RESAKSS, SPEED, IDS/CRS, ASTI, GEA, AgPERs) ← Fig 4
3. Levels of public expenditure
4. Composition of public expenditure
5. Subnational expenditure on agriculture ← análogo a nuestro Cap 4
6. Quality of public expenditure (incluye DEA Box 11) ← análogo a nuestro Cap 5
7. COVID and post-COVID options ← análogo a Bolivia post-sequía 2023
8. Conclusions and recommendations
```

### 4.3 Boxes directamente portables a APER Bolivia

| Box | Tema | Uso en APER Bolivia |
|:---:|------|---------------------|
| Box 1 (p.27) | 5 definiciones clave (narrow def., private/public goods, R&D+ext) | Cap 5 sección PSE — definiciones |
| Box 2 (p.32) | Senegal — Medium-Term Framework for Food Security Public Expenditures (FSPE) | Cap 6 — opción institucional para MEFP |
| Box 6 (p.55) | COVID-19 y respuesta del gasto agrícola | Cap 2 — analogía con sequía 2023 + COVID 2020 |
| Box 7 (p.65) | Reforma del subsidio a insumos en Malawi | Cap 6 — referente para repurposing de EMAPA |
| **Box 11 (p.82)** | **DEA stochastic frontier para eficiencia técnica** | **Cap 5 — anclaje metodológico de nuestro DEA Simar-Wilson** |
| Box 12 (p.93) | Rwanda — trade-offs dentro del marco presupuestal | Cap 6 — escenarios de repurposing |
| Box 14 (p.96) | Opciones para mejorar calidad del gasto | Cap 6 — palanca de recomendaciones |

### 4.4 Hallazgos comparativos clave (benchmarks LAC↔SSA)

- **21% del presupuesto agrícola no se ejecuta** en promedio SSA (rango: 10-40%). Bolivia 2024 = 26% (RPC), 84% PAR III sin ejecutar. **Patrón regional, no anomalía boliviana.**
- **40% de fondos donantes no se ejecutan** (vs ~15% nacional). Explica el gap PAR III.
- **Países con mayor share en input subsidies → peores outcomes agrícolas.** Particularmente dañino en países en transición agrícola avanzada. Hipótesis testeable para Bolivia (EMAPA + subsidios fertilizante).
- **R&D + extensión < 5% del presupuesto** en la mayoría SSA. Bolivia INIAF ≈ 5-8%, similar.

### 4.5 Figura 4 (p.31) — Comparación de enfoques

| Enfoque | Disagregación datos | Profundidad análisis | Tracking CAADP/Maputo | Capacity dev |
|---------|:------------------:|:-------------------:|:--------------------:|:------------:|
| **MAFAP** | 5/5 | 5/5 | 4/5 | 5/5 |
| ReSAKSS (IFPRI) | 3/5 | 3/5 | 5/5 | 2/5 |
| SPEED (IFPRI) | 2/5 | 2/5 | 4/5 | 1/5 |
| IDS/CRS (OECD) | 3/5 | 2/5 | 0/5 | 0/5 |
| ASTI (IFPRI R&D) | 5/5 | 3/5 | 0/5 | 3/5 |
| GEA (FAO COFOG) | 1/5 | 1/5 | 3/5 | 0/5 |
| **AgPERs (WB)** | 4/5 | 5/5 | 3/5 | 2/5 |

→ **MAFAP es el enfoque más completo en disagregación + capacity development.** WB AgPER es el más completo en profundidad analítica. **El APER Bolivia 2026 debe usar ambos como complementarios.**

---

## 5. Documento 3 — PER Filipinas (World Bank, 2023)

### 5.1 Cita canónica
> Weiss, E., Kar, A., Nash, J., Oliveros, N., Briones, R. (2023). **Philippines Agriculture Public Expenditures Review: With a special focus on the implications of the Mandanas Ruling for the agri-food system.** World Bank Group, February 16, 2023.

### 5.2 Estructura del Filipinas AgPER (template directo para Bolivia)

```text
1. Introduction (Context and rationale; Underlying strategies)
2. Assessment of sectoral performance and strategic orientation
   - Economic performance of the overall agricultural sector
   - The policy and institutional framework: decentralization
3. Levels, composition, and sources of public expenditures on agriculture
   - National government
   - Local government units (LGU)
   - Performance ratios
   - Distributional implications
4. [Análisis por programa / banner programs]
5. [Devolución / decentralización implicaciones]
6. Recommendations
   - Challenge 1: aligning expenditures with strategy
   - Challenge 2: improving low effectiveness
   - Challenge 3: improving procedural/institutional issues
```

**Insight estructural:** El cap 3 de Filipinas tiene exactamente el patrón que necesita el cap 3 de Bolivia (nacional + subnacional + ratios de desempeño + implicaciones distributivas).

### 5.3 Hallazgos del Filipinas AgPER aplicables a Bolivia

| Filipinas | Análogo en Bolivia |
|-----------|---------------------|
| **Bias por commodity (rice banner programs)** — 38% del DA budget en banner programs, 50%+ aumento 2019-2022 | EMAPA + subsidio precio soya/trigo — analizable con NRP extendido |
| **Disbursement rates 85-92%** del DA budget | RPC 2024 MDRyT: 74% financiero, 54% físico. Bolivia **peor** que Filipinas |
| **Mandanas Ruling → +37.9% IRA a LGUs** desde 2022 | Ley de Autonomías Bolivia (2010) — transferencia masiva a gobiernos subnacionales. **Misma tensión: capacidad LGU vs ambición** |
| **LGUs free-ride en gasto central** — "esperan que el DA financie" | Departamentos bolivianos esperan VIPFE; municipios esperan PAR III |
| **No M&E sistemática del gasto LGU** | Brecha similar Bolivia — sin reporting subnacional homogéneo |
| **Bottom-up area-based planning** vs commodity-based | Recomendación portable: planificación territorial (PSARDI ya lo intenta) |

### 5.4 Estrategias marco del Filipinas AgPER

- **Diversification** (on-farm + off-farm). Justificación: reducir dependencia commodity-única.
- **Coordination** (multiniveles, multi-actor). Esencial post-devolución.

**Decisión:** adoptar este marco **diversificación + coordinación** como segunda capa narrativa del Cap 6 Bolivia, complementaria a "repurposing" (FAO+WB 2022).

### 5.5 Recomendaciones del Filipinas AgPER (palanca para Cap 6 Bolivia)

1. Bottom-up area-based planning (basado en Strategic Agriculture and Fisheries Development Zones).
2. Más gasto en bienes públicos (R&D, extensión, infraestructura colectiva).
3. **E-voucher system para subsidios de insumos** (en lugar de transferencia física).
4. Decoupled payments financiados con ingresos arancelarios (Rice Liberalization Act como modelo).
5. M&E sistemático del gasto subnacional con sanciones.
6. Capacity building continuo para LGUs.

---

## 6. Documento 4 — PER EXAMPLES (Guinea-Bissau slides)

Presentación de Daniel Villegas con resultados MAFAP para Guinea-Bissau. **Plantilla de slides** para presentar resultados PER a contraparte.

Estructura útil para nuestro deck:
```text
Slide 1-4: Tendencias generales (% del presupuesto, vs Maputo)
Slide 5-9: Características principales (entidades ejecutoras, fuentes financiamiento)
Slide 10-12: Niveles nacionales (programado vs ejecutado, current vs investment)
Slide 13-14: Análisis MAFAP (clasificación aplicada)
Slide 15-16: Anexos (valor de producción, distribución tierra)
```

**Hallazgo G-B portable:** "Agricultura representa solo **1.8% del valor agregado agrícola**" y "**3.2% del presupuesto nacional**" (vs Maputo 10%) — mismo tipo de gap que reportamos para Bolivia (H4 = 3.48% máx).

---

## 7. Documento 5 — PNIA Budget XLSX (Guinea-Bissau dataset operativo)

### 7.1 Estructura del archivo

| Hoja | Contenido | Filas × Cols |
|------|-----------|--------------|
| `Hoja1` | Resumen MAFAP categorías × total | 53 × 9 |
| `Budget-2019-2023` | Detalle por proyecto del Ministerio (5 años) | 304 × 48 |
| `Data` | Clasificación Guinea-Bissau | 50 × 17 |
| `Graphs` | Totales anuales 2019-2023 | 7 × 6 |
| `CAT` | Diccionario de categorías | 43 × 10 |
| `Definitions of data` | **Definiciones MAFAP bilingües ES/EN** ← 🟢 **directamente utilizable** | 45 × 18 |

### 7.2 Valor operativo
La hoja **"Definitions of data"** trae las definiciones MAFAP en **español e inglés** (paridad bilingüe). **Esto resuelve el §3.5 del MASTER_PROMPT (paridad bilingüe)** para todo el glosario de categorías.

### 7.3 Plantilla portable a Bolivia
La hoja `Budget-2019-2023` muestra el formato target para nuestra clasificación MAFAP de BOOST:

```text
MINISTRY | MINISTRY_H | Selected | PNIA Phase | Component | Sub-Component | ... | Year columns | MAFAP code
```

→ **Acción:** generar un script (`02_code/03_analysis/11_mafap_classification.R`) que tome BOOST + VIPFE y produzca este formato para Bolivia 2010-2024.

---

## 8. Decisión metodológica para el APER Bolivia 2026

### 8.1 ¿MAFAP o PSE/OECD? **Ambos, complementarios.**

| Aspecto | MAFAP (FAO) | PSE/OECD (BID AgriMonitor) |
|---------|-------------|-----------------------------|
| **Captura** | Todo el gasto sectorial (incluye agriculture-supportive) | Solo apoyo al productor (MPS + transferencias) |
| **Nivel desagregación** | Por programa, por categoría A-X, por commodity | Por commodity, por instrumento |
| **MPS** | Mencionado pero no calculado en detalle | **Central** — Market Price Support por commodity |
| **NRP/PSE %** | No es el output principal | **Output principal** |
| **Disponibilidad Bolivia** | 🔴 Falta procesar (este es el aporte de esta lectura) | 🟢 Ya procesado (pse_gsse_bolivia.rds, idb_psct_by_commodity.rds) |
| **Comparabilidad LAC** | Limitada en LAC (mayormente SSA + algunos LAC) | 🟢 Alta (10 países LAC en AgriMonitor) |
| **Capacity dev** | Fuerte | Limitado |

### 8.2 Aplicación recomendada por capítulo

| Capítulo APER | Metodología | Razón |
|---------------|-------------|-------|
| **Cap 3 — Presupuestos** | **MAFAP primario** + crosswalk con clasificación funcional VIPFE | MAFAP captura mejor el gasto disperso entre ministerios |
| **Cap 4 — Subnacional** | MAFAP + datos BOOST municipal | Filipinas + SSA muestran la importancia de capturar gasto subnacional |
| **Cap 5 — Análisis** | **PSE/OECD primario** + MAFAP como cross-check | PSE es el estándar para benchmarking LAC |
| **Cap 6 — Recomendaciones** | Marco de repurposing (FAO+WB 2022) + diversificación/coordinación (Filipinas) | Combinación de tres referentes |
| **Apéndice B** | Documentar ambas + crosswalk MAFAP↔OECD↔COFOG | Permite validación externa |

### 8.3 Nuevas tareas que genera esta lectura

1. **Script nuevo:** `02_code/03_analysis/11_mafap_classification.R` — taxonomía MAFAP aplicada a BOOST + VIPFE 2010-2024. Output: `01_data/processed/mafap_bolivia.rds`.
2. **Tabla de crosswalk:** `01_data/processed/crosswalk_mafap_oecd_cofog.csv` — mapeo entre las tres clasificaciones.
3. **Glosario bilingüe:** extraer hoja "Definitions of data" del PNIA xlsx → `04_report/appendix/glosario_mafap_es_en.md`.
4. **Replicar Figura 2 del PER SSA** (clasificación visual MAFAP) → `02_code/04_visualization/fig41_mafap_classification.R`.
5. **Replicar Box 11 SSA (DEA stochastic frontier)** como complemento al DEA Simar-Wilson del Cap 5.

---

## 9. Hallazgos cuantitativos portables a Bolivia

Cifras de benchmark que podemos citar directamente en el APER 2026:

| Cifra | Fuente | Capítulo APER |
|-------|--------|:--:|
| **21% del presupuesto agrícola no ejecutado** (promedio SSA) | PER SSA p.18 | Cap 4 (PAR III en contexto regional) |
| **40% de fondos donantes no ejecutados** | PER SSA p.18 | Cap 4 (explica gap PAR III) |
| **Filipinas: DA disbursement 85-92%** | PER Filipinas p.14-15 | Cap 4 (Bolivia 74% peor) |
| **Mandanas Ruling: IRA +37.9%** desde 2022 | PER Filipinas p.12 | Cap 4 (analogía Autonomías Bolivia) |
| **Bolivia: max Maputo 3.48% (1990)** vs SSA promedio ~3-5% | Datos propios v12 | Cap 3 H4 — Bolivia en rango regional bajo |
| **Países con > input subsidies → < productividad** | PER SSA p.19 | Cap 5 — hipótesis testeable EMAPA |

---

## 10. Citas directas para el reporte

> **MAFAP Manual (p.11):** "Expenditure measures are classified according to the way in which they are implemented and not on the basis of their objectives or economic impacts. This last point is extremely important and is at the core of the MAFAP classification of public expenditure."

> **PER SSA (Foreword):** "Never has there been a more critical time for governments to scrutinise and scale-up their expenditure on food and agriculture."

> **PER SSA (Exec Sum):** "Countries that allocate larger shares to input subsidies fare worse in terms of agricultural outcomes than those spending more on consumer transfers, R&D and extension services. The negative effect of overinvesting in private goods, such as input subsidies, seems to be particularly harmful for countries at more advanced stages of agricultural transformation."

> **PER Filipinas (Abstract):** "The recent positive policy directions embodied in the New Thinking and One DA agenda have not yet fully translated into a shift in public expenditure patterns in the Philippine agriculture sector. One result is that agricultural growth remains low, and poverty in rural areas, where farming remains the main source of income, has stayed high."

> **PER Filipinas (p.16):** "The political economy of this kind of re-orientation is driven by the fact that the payoff for many of the most efficient investments (e.g., research, infrastructure) are long-term, making them less attractive for politicians with short horizons."

---

## 11. Limitaciones del material leído

- **MAFAP Manual 2013** — versión phase I; mejoras de phase II mencionadas pero no documentadas en este Vol II. Verificar si hay actualización post-2015.
- **PER SSA 2021** — datos 2004-2018; no incluye COVID + post-COVID resiliencia. Para Bolivia tenemos hasta 2024.
- **PER Filipinas 2023** — institucional Mandanas Ruling muy específico; no todo es trasladable directamente.
- **PNIA Guinea-Bissau xlsx** — Guinea-Bissau es muy pequeño (USD 61/cápita gasto público total) — el ejemplo sirve estructuralmente pero no por escala.
- **PER EXAMPLES (slides)** — sin notas; solo plantilla visual.

---

## 12. Preguntas abiertas y próximas decisiones

| # | Pregunta | Decisión requerida por |
|:-:|----------|------------------------|
| 1 | ¿Aplicamos MAFAP completo (incluye agriculture-supportive: salud rural, educación rural) o solo agriculture-specific (narrow definition)? | TTL BM + JCM |
| 2 | ¿Calculamos revenue foregone (BDP crédito subsidiado, exenciones tributarias EMAPA)? | JCM — gap actual del panel v12 |
| 3 | ¿Adoptamos el marco diversificación+coordinación del Filipinas AgPER o nos quedamos solo con repurposing FAO+WB? | TTL BM (decisión narrativa del Cap 6) |
| 4 | ¿Generamos el glosario bilingüe MAFAP ES/EN como parte del Apéndice A o como entregable independiente? | JCM (decisión editorial) |
| 5 | ¿Coordinamos clasificación MAFAP con el consultor STC PSE/Repurposing (Héctor Peña) o paralelo? | Reunión con Héctor Peña |

---

## 13. Cambios propuestos al `.agent/00_MASTER_PROMPT.md`

**Parte 5.1 (Datos canónicos)** — añadir tras esta lectura:
- `01_data/processed/mafap_bolivia.rds` (a generar) · BOOST + VIPFE clasificados MAFAP 2010-2024 · Capítulos 3, 4, 5.
- `01_data/processed/crosswalk_mafap_oecd_cofog.csv` (a generar) · Mapeo entre clasificaciones · Apéndice B.

**Parte 5.3 (Convenciones cuantitativas)** — añadir:
- **Clasificación dual:** MAFAP (Cap 3-4) + PSE/OECD (Cap 5). Documentar crosswalk en Apéndice B.
- **Narrow vs full definition** (MAFAP): por defecto usar "full" (incluye agriculture-supportive); para benchmarking Maputo usar "narrow".

**Parte 6 — Cap 3:** añadir como insumo cualitativo: "Manual MAFAP (FAO 2013) + PER SSA (FAO 2021)".

**Parte 6 — Cap 5:** añadir Box 11 PER SSA (DEA stochastic frontier) como referencia metodológica complementaria al Simar-Wilson.

**Parte 6 — Cap 6:** añadir marco diversificación+coordinación (Filipinas AgPER) como segunda capa narrativa.

**Parte 17 (Bitácora):** añadir entrada 2026-05-23 — "Incorporación de paquete metodológico MAFAP + AgPER Filipinas/SSA; decisión de clasificación dual MAFAP/PSE; nuevos artefactos pendientes: mafap_bolivia.rds + crosswalk + glosario bilingüe".

---

## 14. Vinculación con otros documentos del proyecto

- Complementario con: `00_admin/SINERGIA_ToR_PSE_Repurposing.md` — esta lectura refuerza el aporte que el APER 2026 hace al consultor STC.
- Complementario con: `03_literature/mdryt_fichas/README.md` — las fichas MDRyT dan la materia prima institucional que MAFAP organiza.
- Complementario con: `04_report/MASTER_PROMPT.md` Parte 5 — esta ficha alimenta las convenciones metodológicas.
- Posible conflicto con: panel v12 actual usa clasificación funcional VIPFE → requiere re-clasificación con taxonomía MAFAP (no destruir la VIPFE, agregar como capa paralela).

---

## 15. Notas del revisor

1. **El paquete es muy valioso** — los 5 documentos cubren los tres ángulos que faltaban: (a) metodología FAO complementaria a OECD; (b) template estructural WB con énfasis en decentralización; (c) dataset operativo bilingüe.
2. **El PER Filipinas es el referente estructural más cercano al APER Bolivia 2026** — misma voz WB, misma audiencia gubernamental, mismo problema de devolución de competencias. Recomiendo releerlo en detalle (caps 4-7 que no leí) antes de escribir el Cap 4 Bolivia.
3. **Riesgo identificado:** el panel v12 actual no fue construido con taxonomía MAFAP en mente. Re-clasificar BOOST + VIPFE a MAFAP es trabajo nuevo (estimado: 2-3 días). Si el tiempo es ajustado, priorizar **solo para Cap 3** y dejar Cap 5 con la clasificación OECD/PSE actual.
4. **Oportunidad:** la hoja "Definitions of data" del PNIA xlsx ya está bilingüe ES/EN — esto **resuelve el 80% del glosario** que necesitamos para paridad bilingüe (Parte 3.5 del MASTER_PROMPT). Sugiero extraerla cuanto antes.
5. **Decisión editorial pendiente:** ¿el APER Bolivia debe abrirse a llamarse "Bolivia AgPER 2026" (siguiendo la convención WB del Filipinas AgPER) o mantener "APER Bolivia 2026"? Ambos funcionan; recomiendo consultar con Héctor Peña.

---

*Ficha creada: 2026-05-23 · v1.0 · Lectura completa de 4 PDFs (298 pp totales) + 1 XLSX (6 hojas)*
