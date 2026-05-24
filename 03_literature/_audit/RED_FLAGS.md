# 🔴 Fichas con Alucinaciones Confirmadas — Lista Roja APER 2026

**Última actualización:** 2026-05-23 (sesión 11, auditoría Fase 2)
**Estado del corpus:** 317 fichas totales · 93 auditadas (29% del corpus) · **39 con alucinación crítica confirmada**
**Regla operativa:** ❌ **NINGUNA ficha de esta lista debe citarse en `04_report/` sin re-verificación humana contra el PDF**.

---

## ¿Qué significa "alucinación"?

Las fichas en esta lista contienen al menos UNO de los siguientes problemas verificados:

1. **Autores fabricados** (nombres que no aparecen en el PDF)
2. **Año incorrecto** (e.g., ficha dice 2024 pero el PDF dice 2019)
3. **Cifras inventadas** en sección 6 (Hallazgos cuantitativos) — números que no existen en el PDF
4. **Citas verbatim fabricadas** en sección 8 — comillas + número de página que no corresponde a ningún texto real
5. **PDF descargado ≠ paper de la ficha** (e.g., ficha sobre Anríquez 2017 pero el PDF en disco es López 2004)

---

## Conteo por carpeta

| Carpeta | 🔴 Rojas | 🟡 Amarillas | ✅ Verdes | ❓ No auditadas |
|---------|:-------:|:------------:|:--------:|:--------------:|
| 01_systematic_reviews | 2 | 4 | 3 | 14 |
| 02_public_spending | 4 | 2 | 2 | 26 |
| 03_productivity_efficiency | 5 | 2 | 5 | 21 |
| 04_climate_food_security | 5 | 2 | 3 | 23 |
| 05_value_chains | 2 | 3 | 1 | 28 |
| 06_smallholder_indigenous | 8 | 3 | 3 | 15 |
| 07_subsidies_repurposing | 2 | 5 | 1 | 31 |
| 08_institutions_programs | 5 | 4 | 2 | 21 |
| 09_methods_per_pse | 2 | 2 | 2 | 31 |
| 10_macro_growth_poverty | 4 | 3 | 2 | 14 |
| **TOTAL** | **39** | **30** | **24** | **224** |

> **Lectura crítica:** 70% del corpus (224 fichas) no se ha auditado contra PDF. De las 93 auditadas, **42% tienen alucinación crítica y solo 26% están limpias.** Por extrapolación estadística, se estima ~130 alucinaciones en el corpus completo.

---

## Lista detallada de fichas ROJAS (con tipo de problema)

### `01_systematic_reviews/`
| Citekey | Problema principal |
|---------|-------------------|
| `AlstonPardey2000` | Cifras TIR fabricadas: ficha dice "44%" real 48%; "80% extensión" real 62.9% |
| `Searchinger2020` | PDF descargado NO es Searchinger 2020 (es WRI Brief 2021) |
| `MAFAP_Synthesis2013` | PDF descargado es draft Balié & Maetz 2011 (no Synthesis 2013) |

### `02_public_spending/`
| Citekey | Problema principal |
|---------|-------------------|
| `AllcottLedermanLopez2006` | `geographic_scope: Global, ~70 países` falso — el paper es solo LAC |
| `Anriquez2016` | PDF descargado es López 2004 (RUR-04-01), no Anríquez 2016 |
| `ASTI_Bolivia2023` | Autoría incorrecta; período "2010-2021" real 2015-2020 |
| `Pernechele2021` | PDF descargado es Pernechele/Balié/Ghins 2018 |

### `03_productivity_efficiency/`
| Citekey | Problema principal |
|---------|-------------------|
| `AndersenSDSN2023` | Autores fabricados ("Doyle & Branisa"); reales son 6 autores distintos |
| `AndersonFeder2007` | PDF es WDR 2008 background paper de Anderson (solo); NO el Handbook chapter |
| `Anriquez2017IDB` | Autores reales son López/Salazar/De Salvo; tipo paper IDB-TN-1242 (no IDB-WP-768) |
| `AvilaEvenson2010` | PDF es capítulo 71 (Avila/Romano/Garagorry), NO Avila & Evenson |
| `Gasques2010ERS` | ERR-137 está escrito por Rada & Valdes (Gasques solo en agradecimientos) |

### `04_climate_food_security/`
| Citekey | Problema principal |
|---------|-------------------|
| `Andersen2010_ClimateGDP` | PDF descargado es doc del gobierno boliviano sobre programa de riego, NO el paper |
| `Canedo2021` | Autores incorrectos; cifra "ENSO explica 25% variabilidad" INVENTADA |
| `Frontiers_QuinoaResilience` | Autores totalmente fabricados ("Meldrum et al. 10 autores" vs real 4 autores Keleman/Cadima/Gonzales/Humphries) |
| `Springmann2022` | Cifra "143,000 vidas salvadas EU en 2030" NO existe en el paper |
| `WB2022_Innovation` | pdf_path apunta al mismo archivo erróneo que Andersen2010_ClimateGDP |

### `05_value_chains/`
| Citekey | Problema principal |
|---------|-------------------|
| `Coca_Grisaffi2022` | Issue 2 ficha vs 6 Crossref; pp 459-481 ficha vs 1273-1294 real; año 2022 vs 2021 real |
| `Soya_McKay2018` | Issue 1 ficha vs 2 Crossref; pp 108-129 ficha vs 406-424 real |

### `06_smallholder_indigenous/`
| Citekey | Problema principal |
|---------|-------------------|
| `CIPCA2021` | Título incorrecto + nombre autora (Coraly → Carola) |
| `AlianzaAgroecologia` | Cifras "30-60% ingresos mayores" FABRICADAS; AOPEB/PROBIOMA no son autores |
| `BerdegueSchejtman2007` | Tipología "ganadores/no-equitativos/estancados" no existe; quote verbatim p.11 inventada |
| `CEPAL_Inequidad` | Autor real Valenzuela Fernández (no Molina B.); año 2004 (no 2005) |
| `INRA2024` | Autor real Consultora Estrategia INC SRL (no INRA); año 2022 (no 2024); avance 40.85% (no 85%) |
| `UDAPE2019` | Verbatim "23.4%" y "30.5%" rurales INVENTADO. Reales: 84.4→53.9% / 67.8→33.4% |
| `RimispTierraMujeres` | Autores reales Deere/Lastarria-Cornhiel/Ranaboldo (no Costas Monje) |
| `PlanVida_IFAD_ImpactAssessment` | Autores reales Paolantonio/Cavatassi/McCollum (no IFAD institucional) |

### `07_subsidies_repurposing/`
| Citekey | Problema principal |
|---------|-------------------|
| `FAOUNEPUNDP2021` | "87% subsidios distorsionantes" NO existe en PDF (real ~70%); cifra US$ 470B no aparece |
| `OECD2024Monitoring` / `OECD2024` | PSE OECD real 14% (no 17/18%); "30/60% most distorting" real 35%; "64% productores" real 75% |

### `08_institutions_programs/`
| Citekey | Problema principal |
|---------|-------------------|
| `WB_PICAR_2021` / `PICAR_WorldBank2021` | Cifras "656 com / 769 sub / 150K benef" FABRICADAS. Reales: 2,197 sub / 362,619 benef / 116 municipios |
| `CRIAR_WB2012_PAD` | PDF es el PAD de PAR II (sept 2012), NO el PAD de CRIAR |
| `AEMP2024_PlaguicidasBolivia` | Año real 2019 (no 2024); cifras 2,120/1,863/91.4%/2,110M kg todas FABRICADAS |
| `CIPCA_PoliticasPublicasInversion` | Autora real Blanca Zulema Rivero Lobo; período 2000-2018 (no 2006-2016) |

### `09_methods_per_pse/`
| Citekey | Problema principal |
|---------|-------------------|
| `FAO_PSE_LAC` / `FAO_FiscalPolicies` | Autores reales Diaz-Bonilla/De Salvo/Egas 2019 (no FAO 2020); doc No. 8 serie 2030 |
| `MAFAP2014_PEMethodGuideVolII` | Autores reales Ghins/Ilicic-Komorowska/Mas Aparisi 2013 (no 2014); pp 56 (no 80) |

### `10_macro_growth_poverty/`
| Citekey | Problema principal |
|---------|-------------------|
| `IMF2025_ArticleIV2024` | DOS citas verbatim FABRICADAS; "3.9% PIB subsidios" mal etiquetado (es solo gasolina, total 14.4%) |
| `IMF2025_ArticleIV2025` | Cita verbatim FABRICADA; "Bolivia 2da menor crecimiento Sudamérica" sin sustento; inflación 9.5% vs 10% real |
| `WorldBank2021_SCDUpdate` | Cifra "Gini 0.59→0.43" no aparece (real 0.42→0.45 pandemia); 2 citas §8 no son literales |
| `WorldBank2024_PovertyEquityBrief` | Brief es de April 2023 (no 2024); cita "Rural poverty 35-50%" no existe |
| `UDAPE2025_BrechasSociales` | Cifras "pobreza infantil ~47%" y "extrema infantil ~16.9%" NO aparecen; cita §8 compuesta artificialmente |
| `BCB2024_Memoria2023` | PIB 2023 ficha dice 2.5% pero BCB reporta 2.31% preliminar |

### `09_methods_per_pse/` (segunda mitad y adicionales)
| Citekey | Problema principal |
|---------|-------------------|
| `FAO2024_Bolivia` | Autor real Julio Prudencio Böhrt (no "FAO Forum"); "11.6% PIB" real 6%; "USD 5,127M" no aparece |

---

## Patrón sistémico (causa raíz)

**Hipótesis:** los 10 agentes de búsqueda originales usaron principalmente `WebSearch` para encontrar referencias. Crearon fichas basadas en snippets de búsqueda + memoria del LLM, **sin abrir realmente el PDF**. El frontmatter (autor, año, DOI) generalmente sale bien porque WebSearch devuelve metadata correcta. Pero:

- **Sección 6 (Hallazgos cuantitativos)** — cifras inventadas o tomadas de papers parecidos
- **Sección 8 (Citas verbatim "p. X")** — sistemáticamente fabricadas; el LLM compone "comillas plausibles" + número de página inventado
- **Sección 12 (Snippets ES/EN)** — paráfrasis interpretativas que pueden añadir conclusiones no respaldadas
- **PDFs descargados** — varios agentes hicieron `curl` a URLs sin verificar que el archivo descargado corresponde al paper buscado

## Lo que NO está afectado

- ✅ **El BibTeX consolidado** está bien (313 entradas únicas, 0 huérfanos). Los DOIs reportados son verificables vía Crossref/OpenAlex.
- ✅ **313 citekeys ↔ 313 fichas** (cross-reference limpio)
- ✅ Las **fichas previas a sesión 11** (MDRyT, Informacion_PER) están bien — fueron hechas con el método antiguo de leer el PDF primero.
- ✅ Los **PDFs reales descargados** (138 después de cuarentena) son **archivos genuinos** y útiles para re-verificación humana.

---

## Plan de remediación

### Inmediato (sesión 11)
1. ✅ Marcado de `audit_status` en frontmatter de las 317 fichas (red/yellow/green/unverified)
2. ✅ 11 PDFs falsos movidos a cuarentena
3. ✅ Esta lista pública publicada

### Próximas sesiones
4. **Decisión humana**: ¿re-hacer las 39 rojas? ¿con qué método?
   - **Opción A** (conservadora): para cada roja, leer el PDF y reescribir secciones 6/8/12 manualmente
   - **Opción B** (radical): eliminar secciones 8 (citas verbatim) de TODAS las fichas (son sistemáticamente fabricadas) y reescribir secciones 6 sólo cuando se vayan a citar en el reporte
   - **Opción C** (auditar todo): Fase 3 — auditar las 224 unverified contra PDF antes de cualquier uso

5. **Gate de gobernanza nuevo en `.agent/09_AUDITORIA.md`**:
   > "Una ficha sólo puede citarse en `04_report/*.qmd` si `audit_status` ∈ {green, yellow}. Las rojas y unverified requieren re-verificación contra PDF + actualización de audit_status antes de citación."

6. **Reporte por capítulo del APER**: cuando se redacte cada sección, el agente debe consultar primero `_audit/RED_FLAGS.md` y nunca citar una entrada roja sin re-verificación.

---

*Mantenido por: equipo APER. Próxima revisión: tras decidir opción de remediación.*
