# 04_HALLAZGOS.md — APER 2026 Bolivia

**Versión:** v0.2.0
**Última actualización:** 2026-05-24 (ADR-0011 — reasignación de finding_ids a numeración canónica)
**Propósito:** registro versionado de los hallazgos del APER 2026, expresados como **unidades técnicas independientes** con contrato JSON, evidencia trazable y estado de validación. Es la fuente única de los claims que alimentan executive summary, capítulos del book, slides, web y briefs.
**Lecturas relacionadas:** [01_METODOLOGIA.md](01_METODOLOGIA.md), [02_INDICADORES.md](02_INDICADORES.md), [03_FUENTES.md](03_FUENTES.md), [05_ESTILO_NARRATIVO.md](05_ESTILO_NARRATIVO.md), [08_CONTROL.md](08_CONTROL.md), [09_AUDITORIA.md](09_AUDITORIA.md), [00_MASTER_PROMPT.md](00_MASTER_PROMPT.md) §7.1, §9.

---

## 1. Principio rector

> Un hallazgo es la unidad mínima de evidencia técnica reproducible del APER 2026. Si un hallazgo no puede reconstruirse desde panel v12 + script, **no existe**. Si su magnitud cambia, **es otro hallazgo o una versión nueva del mismo**.

Reglas:

1. Los hallazgos viven en este archivo, no en los capítulos. Los capítulos **citan** hallazgos por `finding_id`.
2. Cada hallazgo tiene **contrato JSON completo** (§4).
3. Cada hallazgo declara **incertidumbre** explícita.
4. Cada hallazgo declara **estado de validación**: `draft` → `reviewed` → `MEFP_validated`.
5. Cambiar magnitud, dirección o interpretación de un hallazgo es **ROJO** (CONTROL §4.3) y requiere ADR + bump de versión interno (`F03 v1` → `F03 v2`).
6. Retirar un hallazgo no lo borra: cambia su estado a `retired` con motivo y fecha.

---

## 2. Ciclo de vida de un hallazgo

```text
draft           → contrato JSON completo o casi; al menos cifra y evidencia
                  declaradas; equipo APER lo escribió pero no lo revisó.

reviewed        → A3 firmada (09_AUDITORIA.md): cifras verificadas, trazabilidad
                  completa, lenguaje neutral, paridad bilingüe si aplica,
                  incertidumbre declarada.

MEFP_validated  → A4 firmada y MEFP lo discutió en mesa técnica sin
                  objeción que cambie magnitud. Puede coexistir con nota
                  de divergencia si MEFP discrepa en interpretación pero
                  no en cifra.

contested       → MEFP u otro revisor formal objeta cifra o interpretación;
                  se documenta la disputa; el hallazgo NO se retira.

retired         → el hallazgo ya no se sostiene (e.g., panel v13 contradice
                  la cifra; metodología actualizada lo subsume); se mantiene
                  visible con motivo y referencia al ADR que lo retiró.
```

Las transiciones `reviewed → MEFP_validated → contested` ocurren tras mesa técnica con el MEFP. Transiciones a `retired` requieren ADR.

---

## 3. Versionamiento

| Componente | Esquema | Cambia cuando |
|---|---|---|
| Identificador del hallazgo | `F<NN>` (e.g. `F03`) | nunca — es estable |
| Versión interna | `v<m>` (e.g. `v1`, `v2`) | cambia magnitud, dirección o interpretación |
| `methodology_version` | `m<x.y>` (e.g. `m0.4`) | hereda de 01_METODOLOGIA.md |
| `panel_version` | `v<n>` (e.g. `v12`) | hereda del panel |

Regla: si `methodology_version` o `panel_version` cambian para el mismo `F<NN>`, el hallazgo bumpa su `v<m>`. El histórico previo no se borra (§4.7).

---

## 4. Contrato JSON canónico

Cada hallazgo se registra como bloque YAML/JSON dentro de este archivo, con esta forma (ejemplo ilustrativo — `finding_id: F-EJEMPLO` es deliberado para no colisionar con la numeración canónica F01–F08; las cifras del ejemplo son ilustrativas y no representan claims auditados del proyecto):

```yaml
---
finding_id: F-EJEMPLO
version: v1
title_es: "El gasto agrícola público se concentra en transferencias a productores y empresas estatales"
title_en: "Public agricultural spending is concentrated in transfers to producers and state enterprises"
claim_es: |
  Entre 2018 y 2023, las transferencias representaron en promedio 62% del
  gasto agrícola público ejecutado, mientras los bienes públicos (I+D,
  extensión, sanidad animal y vegetal) se ubicaron entre 14% y 19%.
claim_en: |
  Between 2018 and 2023, transfers averaged 62% of executed public
  agricultural spending, while public goods (R&D, extension, animal and
  plant health) ranged between 14% and 19%.
magnitude:
  value: [TODO_TRACE: confirmar valor exacto desde panel v12]
  unit: "share of total agricultural spending"
  period: "2018-2023"
  geographic_scope: "nacional"
evidence:
  rds_path: "01_data/processed/panel_v12.rds"
  script_path: "02_code/03_construct/03_compose_public_vs_private.R"
  variable: "share_transfers"
  filter: "year >= 2018 & year <= 2023"
  raw_source: "BOOST 2024 release + clasificación funcional MEFP + OECD-PSE adaptado"
  evidence_span: "[TODO_TRACE: enlace a figura 5.2 del book cuando esté]"
benchmark:
  description_es: "Países comparables de la región andina típicamente muestran > 25% en bienes públicos."
  description_en: "Comparable Andean countries typically show > 25% in public goods."
  source: "[@oecd2022]"
uncertainty:
  level: "media"
  reason_es: |
    Sensible al tratamiento de subsidios indirectos (fertilizantes,
    combustibles) y a la clasificación funcional vs. económica;
    apéndice A.3 reporta el rango.
  reason_en: |
    Sensitive to the treatment of indirect subsidies (fertilizers, fuel)
    and to functional vs. economic classification; Annex A.3 reports the
    range.
methodology_version: m0.4
panel_version: v12
policy_implication_es: |
  Existe margen de repurposing hacia bienes públicos manteniendo techo
  fiscal constante; se cuantifica en el escenario S02 (capítulo 6).
policy_implication_en: |
  There is room for repurposing toward public goods while holding the
  fiscal envelope constant; quantified in scenario S02 (chapter 6).
linked_chapters:
  - "04_report/05_spending_analysis.qmd"
  - "04_report/06_recommendations.qmd"
linked_scenarios:
  - "S02"
linked_figures:
  - "fig_05_02_composition_by_instrument"
status: draft
review_log:
  - date: 2026-05-23
    auditor: "Juan Carlos Muñoz"
    audit_id: "A1-2026-0001"
    note: "Borrador inicial sin cifras cerradas; pendiente A2."
divergence_with_mefp: null
last_updated: 2026-05-23
---
```

Campos obligatorios:

```text
finding_id, version, title_es, title_en, claim_es, claim_en,
magnitude, evidence, uncertainty,
methodology_version, panel_version,
linked_chapters, status, last_updated.
```

Campos opcionales pero recomendados:

```text
benchmark, policy_implication_es, policy_implication_en,
linked_scenarios, linked_figures, review_log, divergence_with_mefp.
```

### 4.7. Histórico de versiones

Cuando un hallazgo bumpa `v<m>`, la versión previa se mueve a `## Histórico — F<NN>` al final de este archivo, con la fecha del retiro y el ADR responsable. **No se borra.**

---

## 5. Los 8 hallazgos del APER 2026 — numeración canónica

> Numeración canónica conforme a **ADR-0011** (2026-05-24): los `finding_id` F01–F08 se alinean con el plan editorial (`20_CONTENIDO_REPORTE.md`), el Resumen Ejecutivo (`04_report/index.qmd`), los capítulos 1–6 y `00_admin/RETOMAR.md §6`. El esqueleto previo v0.1.0 se archiva en `.agent/legacy/04_HALLAZGOS_v0_1_0.md`.
>
> Estado actual: **todos en `status: draft`**. Las cifras son reproducibles desde panel v12 + scripts; los gates A1–A6 de `09_AUDITORIA.md` aún no han corrido sobre estos contratos.

### F01 — Inversión pública agropecuaria ×10 con productividad estancada

```yaml
---
finding_id: F01
version: v1
title_es: "La inversión pública agropecuaria se multiplicó por un factor cercano a diez entre 1990 y 2015, mientras la productividad total de los factores creció aproximadamente 30 por ciento"
title_en: "Public agricultural investment grew by a factor close to ten between 1990 and 2015, while total factor productivity increased by approximately 30 percent"
claim_es: |
  La inversión pública agropecuaria boliviana, en dólares constantes de 2015,
  pasó de niveles inferiores a USD 30 millones a comienzos de los noventa a
  un máximo de USD 320 millones en 2015 (≈ ×10), antes de descender a
  USD 261 millones en 2024. En la misma ventana, el índice de TFP USDA-ERS
  para Bolivia creció aproximadamente 30 por ciento. El desacople persiste
  cuando se compara con Perú, Colombia y Ecuador.
claim_en: |
  Public agricultural investment in Bolivia, in constant 2015 USD, rose from
  levels below USD 30 million in the early 1990s to a peak of USD 320 million
  in 2015 (≈ ×10), before falling to USD 261 million in 2024. Over the same
  window, the USDA-ERS TFP index for Bolivia grew by approximately 30 percent.
  The decoupling persists when benchmarked against Peru, Colombia and Ecuador.
magnitude:
  inv_2015: 320     # USD millones constantes 2015
  inv_2024: 261     # USD millones constantes 2015
  factor_growth: 10   # factor aproximado 1990–2015
  tfp_growth_pct: 30  # variación porcentual aproximada 1990–2015
  unit: "USD millones (2015) | factor | variación porcentual"
  period: "1990–2024 (énfasis 1990–2015 para factor y TFP)"
  geographic_scope: "nacional"
evidence:
  rds_path: "01_data/processed/spending_panel_v12.rds"
  script_path: "02_code/03_analysis/03_inversion_vs_tfp.R [TODO_TRACE: verificar script exacto]"
  variable: "inv_agro_usd_mm, tfp_index"
  filter: "year ∈ [1990, 2024]"
  raw_source: "BOOST + VIPFE (inversión); USDA-ERS International Agricultural Productivity (TFP)"
benchmark:
  description_es: "Perú, Colombia y Ecuador presentan trayectorias de TFP creciente con menor dispersión respecto al gasto público sectorial."
  source: "@Fuglie2024, @Ludena2010"
uncertainty:
  level: "media"
  reason_es: |
    TFP sensible al método de agregación (Solow vs. Malmquist) y a la
    elección del deflactor. La cifra del 30 por ciento corresponde al
    índice USDA-ERS estándar.
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  El nivel del gasto no es la variable determinante de la productividad sectorial
  observada; la composición del gasto entre transferencias y bienes públicos
  emerge como dimensión relevante para el análisis de repurposing (Cap 5).
linked_chapters:
  - "04_report/02_sector_performance.qmd"
  - "04_report/05_spending_analysis.qmd"
status: draft
last_updated: 2026-05-24
---
```

### F02 — Producer Support Estimate de 5,8 por ciento, quinto puesto regional

```yaml
---
finding_id: F02
version: v1
title_es: "El Producer Support Estimate de Bolivia se ubica en 5,8 por ciento del valor bruto de la producción agropecuaria en 2018, quinto puesto regional, con composición sesgada hacia sostén de precios e insumos variables"
title_en: "Bolivia's Producer Support Estimate stands at 5.8 percent of gross agricultural production in 2018, fifth in the region, with composition skewed toward market price support and variable input subsidies"
claim_es: |
  El PSE estimado por OECD-IDB AgriMonitor para Bolivia se ubica en
  5,8 por ciento del valor bruto de la producción agropecuaria en 2018,
  quinto puesto regional después de Brasil, Chile, Colombia y Argentina.
  La composición está dominada por Market Price Support (MPS) y subsidios
  a insumos variables; la participación de bienes públicos generales (GSSE)
  es comparativamente baja respecto a referentes OECD.
claim_en: |
  The Producer Support Estimate calculated by OECD-IDB AgriMonitor for
  Bolivia stands at 5.8 percent of gross agricultural production in 2018,
  fifth in the region behind Brazil, Chile, Colombia and Argentina.
  Composition is dominated by Market Price Support (MPS) and variable input
  subsidies; the share of general public goods (GSSE) is comparatively low
  relative to OECD benchmarks.
magnitude:
  pse_pct: 5.8     # % del valor bruto de la producción
  ranking_lac: 5    # quinto puesto regional
  year_ref: 2018
  unit: "porcentaje del valor bruto de la producción"
  period: "2018 (cifra ancla); serie completa 2006–2023"
  geographic_scope: "nacional"
evidence:
  rds_path: "01_data/processed/spending_panel_v12.rds"
  script_path: "[TODO_TRACE: 02_code/03_analysis/pse_composition.R — pendiente de output Hector]"
  variable: "pse_pct, pse_mps, pse_gsse, pse_cse"
  raw_source: "OECD-IDB AgriMonitor + cálculo propio sobre panel v12"
benchmark:
  description_es: "Brasil ≈ 8%, Chile ≈ 7%, Colombia y Argentina entre 6 y 7%. Promedio OECD del orden del 18% (rango amplio)."
  source: "@DeSalvoEtAl2018_IDB_AgSupportLAC, @OECD2025_APME, @IDB_Agrimonitor"
uncertainty:
  level: "alta"
  reason_es: |
    MPS sensible a la elección del precio de referencia internacional,
    al tipo de cambio aplicado y al tratamiento de bienes no
    comercializables. Sensibilidad por escenarios PSE alto/medio/bajo
    documentada en Cap 5 §5.1 y en el Apéndice B.
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  La posición intermedia del PSE y la composición dominada por MPS y
  subsidios a insumos describen el espacio analítico para opciones de
  repurposing hacia bienes públicos generales (Cap 5, Cap 6 S02).
linked_chapters:
  - "04_report/05_spending_analysis.qmd"
  - "04_report/06_recommendations.qmd"
linked_scenarios:
  - "S02"
status: draft
last_updated: 2026-05-24
---
```

### F03 — Patrón dual de protección por commodity (exportables vs seguridad alimentaria)

```yaml
---
finding_id: F03
version: v1
title_es: "El Nominal Rate of Protection presenta sesgo opuesto entre exportables y commodities de seguridad alimentaria: soya y arroz negativos, maíz y trigo positivos"
title_en: "The Nominal Rate of Protection shows opposite biases between exportables and food security commodities: soybean and rice negative, maize and wheat positive"
claim_es: |
  Para 2018–2023, el Nominal Rate of Protection estimado por IDB AgriMonitor
  registra soya en aproximadamente −37 por ciento y arroz en −33 por ciento,
  consistente con cargas tributarias y restricciones a la exportación. Maíz
  y trigo muestran NRP positivos del orden de +46 y +28 por ciento,
  atribuibles a importaciones administradas y a precios soporte.
claim_en: |
  For 2018–2023, the IDB AgriMonitor Nominal Rate of Protection registers
  soybean at approximately −37 percent and rice at −33 percent, consistent
  with export taxes and trade restrictions. Maize and wheat show positive
  NRPs of approximately +46 and +28 percent, attributable to managed imports
  and price support.
magnitude:
  nrp_soya_pct: -37
  nrp_arroz_pct: -33
  nrp_maiz_pct: 46
  nrp_trigo_pct: 28
  unit: "porcentaje (Nominal Rate of Protection)"
  period: "2018–2023 (cifras ancla); serie completa 2006–2023"
  geographic_scope: "nacional, por commodity"
evidence:
  rds_path: "01_data/processed/spending_panel_v12.rds"
  script_path: "[TODO_TRACE: 02_code/03_analysis/nrp_commodities.R — pendiente integración output Hector]"
  variable: "nrp_soya, nrp_arroz, nrp_maiz, nrp_trigo"
  raw_source: "IDB AgriMonitor + FAOSTAT PP + WB Pink Sheet + INE PIB sectorial"
benchmark:
  description_es: "Patrón consistente con la literatura clásica sobre tributación implícita de exportables agrícolas en LATAM."
  source: "@KruegerSchiffValdes1988, @AndersonRausserSwinnen2013, @LopezGalinato2007"
uncertainty:
  level: "media"
  reason_es: |
    NRP sensible al precio frontera de referencia, al margen de
    transporte y comercialización y al tipo de cambio. Anomalía documentada
    en caña de azúcar 2015 (PP doméstico USD 261/t vs referencia USD 37/t)
    en revisión con INE.
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  El patrón dual sugiere coexistencia de dos lógicas de política: gravamen
  implícito a exportables y protección a importables de seguridad alimentaria.
  Cualquier discusión de reasignación bajo techo fiscal constante debe
  internalizar la economía política asociada a ambos lados.
linked_chapters:
  - "04_report/05_spending_analysis.qmd"
status: draft
last_updated: 2026-05-24
---
```

### F04 — Compromiso de Maputo nunca alcanzado

```yaml
---
finding_id: F04
version: v1
title_es: "El gasto público agropecuario nunca alcanzó el referente del 10 por ciento del gasto público total (Maputo/CAADP): máximo histórico de 3,48 por ciento en 1990"
title_en: "Public agricultural spending never reached the 10 percent of total public spending benchmark (Maputo/CAADP): historical peak of 3.48 percent in 1990"
claim_es: |
  La participación del gasto agropecuario en el gasto público total
  alcanzó su máximo histórico de 3,48 por ciento en 1990, muy por
  debajo del referente CAADP del 10 por ciento. El promedio del período
  1990–2007 fue 1,72 por ciento; el promedio 2000–2007 fue 1,87 por
  ciento.
claim_en: |
  The share of agricultural spending in total public spending reached its
  historical peak of 3.48 percent in 1990, well below the 10 percent CAADP
  benchmark. The 1990–2007 average was 1.72 percent; the 2000–2007 average
  was 1.87 percent.
magnitude:
  max_value_pct: 3.48
  max_year: 1990
  avg_1990_2007_pct: 1.72
  avg_2000_2007_pct: 1.87
  unit: "porcentaje del gasto público total"
  period: "1990–2024"
  geographic_scope: "nacional"
evidence:
  rds_path: "01_data/processed/spending_panel_v12.rds"
  script_path: "02_code/03_analysis/02_maputo_caadp.R [TODO_TRACE: verificar nombre script]"
  variable: "speed_ag_pctexp"
  filter: "panel$speed_ag_pctexp[year==1990] = 3.4844"
  raw_source: "BOOST + IFPRI SPEED + benchmark CAADP (Maputo 2003)"
benchmark:
  description_es: "Referente CAADP: 10% del gasto público total. Países que cumplieron Maputo en algún año: Etiopía, Burkina Faso, Malawi, Niger."
  source: "@FAO2021_PEFoodAgricultureSSA, @PernecheleEtAl2018_MAFAP"
uncertainty:
  level: "baja"
  reason_es: |
    Cifra robusta al cambio de denominador (gasto público total
    consolidado vs ejecutado). Verificación cruzada BOOST vs SPEED
    consistente en orden de magnitud.
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  La trayectoria histórica del gasto sectorial sitúa a Bolivia
  estructuralmente por debajo del referente regional. El análisis del
  Cap 3 documenta los factores de arquitectura institucional asociados
  a esta posición.
linked_chapters:
  - "04_report/03_budget_institutions.qmd"
  - "04_report/index.qmd"
status: draft
last_updated: 2026-05-24
---
```

### F05 — Sustitución del gasto presupuestario por crédito sectorial dirigido post-Ley 393

```yaml
---
finding_id: F05
version: v1
title_es: "La cartera de crédito agropecuario del sistema bancario se multiplicó por 11,7 entre 2010 y 2024 tras la Ley 393, asumiendo parte de la función de financiamiento sectorial que el presupuesto no cubrió"
title_en: "The agricultural credit portfolio of the banking system grew by a factor of 11.7 between 2010 and 2024 following Law 393, absorbing part of the sectoral financing function that the budget did not cover"
claim_es: |
  La cartera bruta agropecuaria del sistema bancario nacional, reportada
  por el BCB, pasó de USD 290 millones (5,07 por ciento de la cartera
  total) en 2010 a USD 3 397 millones (11,70 por ciento) en 2024, un
  crecimiento por factor de 11,71. La Ley 393 de Servicios Financieros
  (2014) estableció cuotas mínimas de cartera productiva y un régimen
  de tasas reguladas; los DS 1842 (2013) y DS 2055 (2014) la operacionalizaron.
  El subsidio cuasi-fiscal asociado al diferencial de tasas no se reporta
  en el presupuesto general del Estado.
claim_en: |
  Gross agricultural credit portfolio reported by the BCB rose from
  USD 290 million (5.07 percent of total portfolio) in 2010 to USD 3 397
  million (11.70 percent) in 2024, a factor of 11.71. Law 393 (2014)
  established minimum productive portfolio quotas and a regulated rate
  regime; SD 1842 (2013) and SD 2055 (2014) operationalized it. The
  quasi-fiscal subsidy associated with the rate differential is not
  reported in the general government budget.
magnitude:
  cartera_2010_usd_mm: 290
  cartera_2024_usd_mm: 3397
  factor_growth: 11.7
  share_2010_pct: 5.07
  share_2024_pct: 11.70
  unit: "USD millones | factor | porcentaje de cartera total"
  period: "2010–2024"
  geographic_scope: "nacional"
evidence:
  rds_path: "01_data/processed/bcb_credito_sectorial_anual.rds"
  script_path: "02_code/01_collection/06_bcb_credito.R [TODO_TRACE: verificar script]"
  variable: "bcb_cred_agro_mm_usd, bcb_cred_agro_share_total"
  filter: "year ∈ [2010, 2024]"
  raw_source: "Banco Central de Bolivia — Boletines mensuales de Sistema Financiero"
benchmark:
  description_es: "Patrón de regulación de cartera con cuotas mínimas observable también en otros marcos LATAM (Brasil PRONAF, Argentina segmento productivo)."
  source: "[TODO_TRACE: añadir refs LAC sobre crédito dirigido]"
uncertainty:
  level: "media"
  reason_es: |
    Magnitud del subsidio cuasi-fiscal pendiente de cuantificación
    (requiere estimación de tasa de mercado de referencia y serie BDP
    desagregada). Validación de la serie post-Ley 393 contra cartera
    anterior pendiente para descartar doble conteo.
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  La sustitución parcial del gasto presupuestario por crédito regulado
  desplaza el costo fiscal hacia un cuasi-fiscal no reportado en el PGE.
  La consideración integral del apoyo sectorial debe internalizar ambos
  flujos (Cap 3 §3.4, Cap 6 H2.2.3).
linked_chapters:
  - "04_report/03_budget_institutions.qmd"
  - "04_report/06_recommendations.qmd"
status: draft
last_updated: 2026-05-24
---
```

### F06 — Pobreza rural y seguridad alimentaria con trayectoria de reversión

```yaml
---
finding_id: F06
version: v1
title_es: "La pobreza monetaria rural descendió de 55 por ciento en 2012 a aproximadamente 40 por ciento en 2018 y revirtió a cerca de 45 por ciento en 2024; la inseguridad alimentaria moderada o severa (FIES) escaló de 49 a 74 por ciento entre 2014–2016 y 2022–2024"
title_en: "Rural monetary poverty fell from 55 percent in 2012 to approximately 40 percent in 2018 and reverted to about 45 percent in 2024; moderate-or-severe food insecurity (FIES) rose from 49 to 74 percent between 2014–2016 and 2022–2024"
claim_es: |
  La pobreza monetaria rural, medida por la Encuesta de Hogares del INE,
  descendió de 55 por ciento en 2012 a aproximadamente 40 por ciento en
  2018 y se ubicó cerca del 45 por ciento en 2024. La prevalencia de
  inseguridad alimentaria moderada o severa medida con la escala FIES
  de FAOSTAT pasó de 49 por ciento en el promedio 2014–2016 a 74 por
  ciento en el promedio 2022–2024.
claim_en: |
  Rural monetary poverty, measured by the INE Household Survey, fell
  from 55 percent in 2012 to approximately 40 percent in 2018 and
  reverted to about 45 percent in 2024. Moderate-or-severe food insecurity
  prevalence measured with the FAOSTAT FIES scale rose from 49 percent in
  the 2014–2016 average to 74 percent in the 2022–2024 average.
magnitude:
  pobreza_rural_2012_pct: 55
  pobreza_rural_2018_pct: 40
  pobreza_rural_2024_pct: 45
  fies_2014_2016_pct: 49
  fies_2022_2024_pct: 74
  unit: "porcentaje de hogares"
  period: "2012–2024 (pobreza) y 2014–2024 (FIES)"
  geographic_scope: "nacional rural"
evidence:
  rds_path: "01_data/processed/eh_nacional_anual.rds [TODO_TRACE: verificar disponibilidad]"
  script_path: "[TODO_TRACE: 02_code/01_collection/04_ine_eh.R]"
  variable: "rural_poverty_pct, fies_insecure_pct"
  raw_source: "INE Bolivia — Encuesta de Hogares; FAOSTAT — escala FIES"
benchmark:
  description_es: "Trayectoria divergente respecto al promedio LATAM, que muestra reducción sostenida de pobreza monetaria en el mismo período."
  source: "@WFP2022_BoliviaACR, @FAO2024_SOFI, @OPHI2024_BoliviaBriefing"
uncertainty:
  level: "media"
  reason_es: |
    Pobreza monetaria sensible a la línea de pobreza usada y a la
    metodología de imputación de ingreso. FIES robusta a cambios en
    cobertura del cuestionario; promedios trianuales mitigan ruido.
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  La reversión simultánea de pobreza rural y la escalada de FIES describen
  un sistema rural cuya expansión productiva agregada no se ha traducido
  en mejora sostenida del bienestar de los hogares más vulnerables (Cap 2
  §2.3, Cap 6 H2.1).
linked_chapters:
  - "04_report/02_sector_performance.qmd"
  - "04_report/06_recommendations.qmd"
status: draft
last_updated: 2026-05-24
---
```

### F07 — Ejecución financiera reducida en programas activos del Banco Mundial

```yaml
---
finding_id: F07
version: v1
title_es: "El Programa de Alianzas Rurales III (PAR III) reporta ejecución financiera acumulada del 16 por ciento en 2024, por debajo del benchmark regional MAFAP-FAO y del referente Mandanas Ruling en Filipinas"
title_en: "The Rural Alliances Program III (PAR III) reports cumulative financial execution of 16 percent in 2024, below the MAFAP-FAO regional benchmark and the Philippines Mandanas Ruling benchmark"
claim_es: |
  El Implementation Status Report 2024 del PAR III reporta una ejecución
  financiera acumulada del 16 por ciento. El benchmark regional MAFAP-FAO
  (PER Subsahariana) reporta un promedio de 21 por ciento de subejecución
  en el agregado sectorial africano. El PER Filipinas (Banco Mundial 2023)
  reporta tasas del 85–92 por ciento en el Department of Agriculture tras
  la reforma Mandanas Ruling.
claim_en: |
  The PAR III 2024 Implementation Status Report records cumulative financial
  execution of 16 percent. The MAFAP-FAO regional benchmark (Sub-Saharan PER)
  reports an average of 21 percent under-execution at the African sectoral
  aggregate. The Philippines PER (World Bank 2023) reports execution rates of
  85–92 percent in the Department of Agriculture following the Mandanas
  Ruling reform.
magnitude:
  par_iii_ejecucion_pct: 16
  par_iii_year_ref: 2024
  ssa_subejecucion_pct: 21
  ph_da_ejecucion_pct_rango: [85, 92]
  unit: "porcentaje de ejecución financiera"
  period: "2024 (PAR III); promedios multianuales para benchmarks"
  geographic_scope: "nacional + benchmarks comparados"
evidence:
  rds_path: "[TODO_TRACE: serie ejecución PAR III no consolidada en panel v12]"
  script_path: "[TODO_TRACE: añadir 02_code/01_collection/09_isr_par_iii.R]"
  variable: "[TODO_TRACE: par_iii_disb_pct]"
  raw_source: "PAR III ISR (BM 2024) + FAO MAFAP PER SSA (Pernechele 2018) + PER Filipinas (WB 2023)"
benchmark:
  description_es: "Ejecución del 16% es sustancialmente inferior al referente MAFAP-FAO SSA (≈ 79% de ejecución implícito) y al rango filipino post-Mandanas."
  source: "@PAR_WorldBank2024_ICR, @PernecheleEtAl2018_MAFAP, @FAO2021_PEFoodAgricultureSSA"
uncertainty:
  level: "media"
  reason_es: |
    Cifra del 16% pendiente de verificación directa contra el ISR oficial
    2024; tomada del plan editorial §8. Diferencias metodológicas con
    benchmarks comparados (Mandanas mide DA agregado, no programa).
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  La capacidad de ejecución es una restricción operativa que condiciona
  la efectividad de cualquier expansión presupuestaria sectorial.
  La analogía operativa con la reforma filipina Mandanas se discute en
  Cap 4 §4.4 y en Cap 6 H2.2.4.
linked_chapters:
  - "04_report/04_spending_organization.qmd"
  - "04_report/06_recommendations.qmd"
status: draft
last_updated: 2026-05-24
---
```

### F08 — Frontera agropecuaria con concentración territorial

```yaml
---
finding_id: F08
version: v1
title_es: "La frontera agropecuaria se expandió por aproximadamente 9,4 millones de hectáreas entre 1985 y 2024 con 64 por ciento de la expansión concentrada en el departamento de Santa Cruz"
title_en: "The agricultural frontier expanded by approximately 9.4 million hectares between 1985 and 2024 with 64 percent of the expansion concentrated in the Santa Cruz department"
claim_es: |
  MapBiomas Bolivia Colección 3 documenta una pérdida acumulada de
  aproximadamente 9,4 millones de hectáreas de cobertura natural
  reconvertidas a usos antrópicos entre 1985 y 2024. Aproximadamente
  64 por ciento de esa expansión se concentra en el departamento de
  Santa Cruz. La pérdida forestal anual reportada por Hansen Global
  Forest Change v1.11 se mantiene elevada en el período reciente.
claim_en: |
  MapBiomas Bolivia Collection 3 documents a cumulative loss of
  approximately 9.4 million hectares of natural cover reconverted to
  anthropic uses between 1985 and 2024. Approximately 64 percent of
  that expansion is concentrated in the Santa Cruz department. Annual
  forest loss reported by Hansen Global Forest Change v1.11 remains
  elevated in the recent period.
magnitude:
  area_perdida_ha: 9400000   # 9,4 millones de hectáreas
  santa_cruz_share_pct: 64
  period_text: "1985–2024"
  unit: "hectáreas | porcentaje del total"
  period: "1985–2024"
  geographic_scope: "nacional, desagregación departamental"
evidence:
  rds_path: "01_data/processed/spending_panel_v12.rds + 01_data/processed/[TODO_TRACE: mapbiomas/hansen processed]"
  script_path: "[TODO_TRACE: 02_code/02_cleaning/14_mapbiomas.R + 15_hansen.R]"
  variable: "lc_antropico, lc_natural, hansen_defor_ha"
  raw_source: "MapBiomas Bolivia Colección 3 (Wikimedia) + Hansen Global Forest Change v1.11"
benchmark:
  description_es: "Patrón de concentración consistente con la literatura sobre dualismo oriente-occidente en el uso del suelo boliviano."
  source: "@Pacheco2006, @INE2015_Censo"
uncertainty:
  level: "media"
  reason_es: |
    Cobertura del suelo sensible al algoritmo de clasificación
    (MapBiomas Colección 3 vs colecciones anteriores). Cifra Hansen
    sensible al umbral de cobertura forestal mínimo aplicado.
methodology_version: m0.1
panel_version: v12
policy_implication_es: |
  La expansión y concentración de la frontera agropecuaria interactúa
  con la lectura de F01 (productividad), F03 (NRP de exportables) y
  con los escenarios climáticos del Cap 6 (S03).
linked_chapters:
  - "04_report/02_sector_performance.qmd"
  - "04_report/06_recommendations.qmd"
linked_scenarios:
  - "S03"
status: draft
last_updated: 2026-05-24
---
```

---

## 6. Cómo se actualiza un hallazgo

### 6.1. Cambio cosmético (wording sin cambiar claim)

- Color: **VERDE** (CONTROL §4.1).
- No bumpa versión.
- Actualizar `last_updated`.
- Entrada en `review_log` opcional.

### 6.2. Cambio de magnitud o interpretación

- Color: **ROJO** (CONTROL §4.3).
- Bump de `version` (e.g. `v1` → `v2`).
- ADR obligatorio.
- Versión previa se mueve a `## Histórico — F<NN>` al final del archivo.
- Regenerar figuras / slides / briefs que citaban la versión previa.
- Verificación A3 + A4 (09_AUDITORIA.md).

### 6.3. Cambio de estado de validación

- `draft → reviewed`: A3 firmada.
- `reviewed → MEFP_validated`: A4 firmada + mesa técnica con MEFP.
- `MEFP_validated → contested`: registro de la objeción con fecha y fuente.
- `* → retired`: ADR + motivo documentado; el hallazgo permanece visible.

### 6.4. Incorporación de comentario MEFP

- Si el MEFP propone una corrección de cifra **con fuente verificable**: aplicar como cambio de magnitud (§6.2).
- Si el MEFP propone una corrección **sin fuente verificable**: documentar en `divergence_with_mefp` como nota de divergencia; el hallazgo mantiene su versión.
- Si el MEFP propone reformulación de interpretación sin cambiar la cifra: amarillo; actualizar wording; registrar en `review_log`.

---

## 7. Integración con otros productos

| Producto | Cómo cita el hallazgo |
|---|---|
| Capítulos del book | citan por `finding_id` (e.g. "ver F03 en 04_HALLAZGOS.md") y reflejan magnitud + período idénticos |
| Executive summary | claim del hallazgo es la fuente del bullet del BLUF |
| Slides ejecutivas | bullet trae `finding_id` en metadatos del slide |
| Sitio público | página por hallazgo con título bilingüe, magnitud, fuente |
| Briefs derivados | bullets atados a `finding_id` |
| Cartas MEFP | hallazgos en estado `reviewed` o superior; nunca `draft` |

Regla de consistencia: si en cualquier producto la cifra de un hallazgo difiere de lo declarado acá, **prevalece 04_HALLAZGOS.md**; los demás se corrigen.

---

## 8. Notas de divergencia con MEFP (apéndice)

Cuando un comentario del MEFP no se incorpora porque no tiene fuente verificable o porque cambiaría la metodología versionada sin ADR, se registra acá:

```yaml
divergence_id: D-NNNN
finding_id: F-EJEMPLO   # usar F01..F08 según corresponda al hallazgo divergente
date: YYYY-MM-DD
mefp_position_es: "El MEFP indica que la clasificación X debería ser Y."
team_position_es: "El equipo APER mantiene la clasificación X por consistencia con la metodología m0.4; ver METODOLOGIA §X.Y."
status: open | closed
resolution_note: ""
---
```

Las divergencias se publican en el appendix del book; no se ocultan.

---

## 9. Histórico — versiones retiradas

(vacío en v0.1.0)

Cuando un hallazgo bumpe versión, su versión previa se mueve acá con:

```text
### F<NN> v<m-1>  (retirada YYYY-MM-DD por ADR-NNNN)
<bloque YAML completo>
Motivo: ...
```

---

## 10. Cómo modificar este archivo

`04_HALLAZGOS.md` es zona crítica (CONTROL §3). Reglas:

- Agregar `[TODO_TRACE: ...]` a un hallazgo en `draft`: VERDE.
- Llenar un `[TODO_TRACE]` con cifra trazada: AMARILLO si el hallazgo está `draft`; ROJO si está `reviewed` o superior.
- Cambiar cualquier campo del contrato JSON: ROJO + ADR + bump.
- Cambiar el ciclo de vida §2 o los estados: ROJO + ADR sobre `04_HALLAZGOS.md`.
- Cambiar el contrato canónico §4 (agregar / quitar campos obligatorios): ROJO + ADR sobre `04_HALLAZGOS.md`.

---

## 11. Changelog

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: principio rector, ciclo de vida, contrato JSON canónico, esqueletos v0.1.0 para F01–F08 con TODO_TRACE, protocolo de actualización, divergencias MEFP, histórico vacío |
