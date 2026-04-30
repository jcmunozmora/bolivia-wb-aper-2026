# Nota de sinergia — APER Bolivia 2026 ↔ ToR Consultor PSE/Repurposing

**Documento:** `TORS FOR CONSULTANT INCLUDING REPURPOSING AND PSE ANALYSIS.docx`
**Coordinación BM:** Héctor Peña (contacto del ToR)
**Duración consultoría STC:** 20 días, presencial en La Paz para la capacitación
**Fecha de la nota:** 2026-04-27

---

## 1. Alcance del consultor STC (resumen)

Tres objetivos:

| # | Objetivo | Producto |
|:-:|----------|----------|
| **a** | Analizar **PSE Bolivia** con estimaciones IDB-AgriMonitor (incluyendo edición febrero 2026) | Reporte (PowerPoint) sobre nivel, distribución y proporcionalidad de PSE / GSSE / TSE / CSE en los últimos 5 años |
| **b** | **Capacitación** al equipo gubernamental boliviano en metodología OECD-PSE (modalidad *learning by doing*, ~2 semanas presenciales en La Paz) | Sesión de entrenamiento en colección de datos, generación de estimaciones e interpretación |
| **c** | Estimar costo fiscal de **Repurposing** (i) reducir MPS considerando ingresos arancelarios perdidos; (ii) aumentar inversión en bienes públicos | Reporte con estimaciones fiscales + benchmarking LAC |

---

## 2. Lo que el APER 2026 YA tiene y le sirve al consultor STC

### Datos PSE/GSSE/TSE listos (objetivo a)

| Dataset disponible | Cobertura | Uso para el consultor |
|--------------------|-----------|----------------------|
| `pse_gsse_bolivia.rds` | 2006-2023 (18 obs × 17 vars) | Base directa para análisis IDB Bolivia |
| `idb_agrimonitor_lac_full.rds` | 1986-2024 (134 581 obs × 27 vars) | Comparadores LAC sin necesidad de re-procesar |
| `pse_gsse_lac_panel.rds` | 2006-2023 × 10 países LAC | Benchmarking horizontal |
| `idb_psct_by_commodity.rds` | Bolivia × commodities | Descomposición PSE por producto |
| `idb_prices_gap_bolivia.rds` | 2006-2023 | Brecha precios doméstico-frontera (= input MPS) |

### NRP extendido pre-2006 (extiende el análisis MPS)

| Dataset | Cobertura | Aporte |
|---------|-----------|--------|
| `pse_nrp_extended.rds` | **1991-2024 × 7 commodities** | Serie histórica de protección 15 años antes de IDB |
| `faostat_pp_bolivia.rds` | 1991-2025 × 119 commodities | Precios productor (input MPS) |
| `wb_pink_sheet_agro.rds` | 1960-2025 | Precios mundiales referencia |
| `faostat_pp_lac.rds` | 1991-2025 × 9 países LAC | Comparadores regionales de precios |

### "Market information" pedida en ToR § 2.1

| Item del ToR | Disponibilidad APER 2026 |
|--------------|--------------------------|
| Producción y valor de commodities | ✅ `ine_agro_stats_long.rds` (1984-2024), `faostat_bolivia_qcl.rds`, `ine_campanas_long.rds` |
| Precios productor commodities | ✅ `faostat_pp_bolivia.rds` (119 commodities, 4 elementos) |
| Datos de consumo y feed | 🟡 vía FAOSTAT FBS (no procesado, pero scriptable) |
| Precios internacionales | ✅ `wb_pink_sheet_agro.rds` |
| Costos de transporte | ❌ Tier A pendiente (estimable vía FAOSTAT TCL) |

### "Trade information" pedida en ToR § 2.2

| Item | Estado en APER 2026 |
|------|---------------------|
| Exports/imports values y volumes | 🟡 FAOSTAT TCL parcialmente probado (gap A.4 en nuestra auditoría) — el consultor lo necesitará procesar |
| Tariff schedule | ❌ Pendiente — requiere ALADI / Aduana Nacional |

### "Budget support en sub-categorías OECD" (ToR § 2.3)

| Sub-categoría OECD | Disponibilidad |
|--------------------|---------------|
| PSE (productor) — A1+A2+B+C+D+E+F | ✅ vía IDB AgriMonitor |
| GSSE (sectorial) — H+I+J+K+L+M+N | ✅ vía IDB AgriMonitor |
| CSE (consumidor) | ✅ vía IDB AgriMonitor |
| Cross-check con datos nacionales | ✅ panel v12 + BOOST 1996-2008 + VIPFE 1990-2024 |

### "GHG emissions agro" (ToR § 2.4)

| Item | Estado |
|------|:------:|
| GHG total Gg CO2e Bolivia | ✅ `idb_agrimonitor` (var `GHG_total_GgCO2e`, 5 años 2019-2023) |
| Uso de fertilizantes | ✅ FAOSTAT QCL (kg/ha) |
| Uso de pesticidas | ✅ FAOSTAT (`use_of_pesticides_per_area_of_cropland`) |
| Cobertura del suelo | ✅ MapBiomas Bolivia Col.3 (1985-2024) |
| Deforestación anual | ✅ Hansen GFC v1.11 (2001-2023) |

### Documentos de soporte para Repurposing (objetivo c)

| Documento | Uso |
|-----------|-----|
| 7 fichas MDRyT (PSARDI, PEI, RPC 2019/2021/2024, INIAF, CIPCA) | Mapeo cualitativo de programas existentes |
| Inventario_Datos Excel (5 hojas) | Catálogo institucional de gasto público |
| Timeline 1990-2025 (61 hitos) | Contexto político de las medidas MPS (export bans, controles de precios) |
| BOOST 1996-2008 desagregado | Línea base de gasto en bienes públicos pre-2009 |
| MEFP Ejecucion 2015-2023 | Benchmark de tasas de ejecución |

---

## 3. Lo que el consultor STC produce y nos sirve a NOSOTROS

| Producto del STC | Insumo al APER 2026 | Capítulo APER beneficiado |
|------------------|---------------------|---------------------------|
| Reporte IDB con estimaciones febrero 2026 | Actualización de PSE 2024 (un año más) | Cap. 4a — PSE/GSSE/TSE |
| Estimación costo fiscal de reducir MPS | Argumento cuantitativo de reforma | Cap. 5 — Recomendaciones |
| Estimación costo aumento inv. en bienes públicos | Cifra-meta para el Repurposing | Cap. 5 — Recomendaciones |
| Benchmarking LAC del Repurposing | Comparativa regional | Cap. 4a — comparadores |
| Capacitación al MEFP/MDRyT (presencial La Paz) | **Puede destrabar gap B.1** (datos institucionales 2009-2024) | Cap. 3 — gasto institucional |

---

## 4. Áreas de overlap potencial — coordinación necesaria

| Tema | APER 2026 (mi enfoque) | Consultor STC (su enfoque) | Acción de coordinación |
|------|------------------------|----------------------------|------------------------|
| **MPS por commodity** | NRP histórico 1991-2024 vía precios FAO/WB | PSE 2006-2024 vía IDB | Asegurar **convergencia metodológica**: que las cifras 2006-2024 coincidan en sentido y magnitud |
| **Bienes públicos** | Lado del gasto: BOOST + VIPFE + MEFP | Lado OECD-GSSE: clasificación A-N | Acordar **mapeo UDAPE-FAM ↔ GSSE** para evitar doble conteo |
| **GHG agro** | Macro: MapBiomas + Hansen + emisiones IDB | Estimación específica por actividad | Compartir factores de emisión usados |
| **Repurposing** | No es el enfoque central del APER (queda como recomendación cualitativa) | Es el output principal del STC | El APER refiere al reporte STC para la cifra fiscal |

---

## 5. Productos compartibles (paquete de transferencia al consultor STC)

Si el consultor llega y necesita una caja de herramientas inicial, podemos entregarle en 1 día:

1. **Sitio público** con todo el contexto: https://jcmunozmora.github.io/bolivia-wb-aper-2026/
2. **Panel v12 + diccionario**: `01_data/processed/spending_panel_v12.rds` + `spending_panel_v12_dictionary.csv` (176 vars en 17 grupos clasificados)
3. **5 datasets PSE/NRP**: `pse_gsse_bolivia.rds`, `pse_gsse_lac_panel.rds`, `idb_agrimonitor_lac_full.rds`, `pse_nrp_extended.rds`, `wb_pink_sheet_agro.rds`
4. **Inventario Excel** con 63 datasets, 23 gaps clasificados, 7 capítulos
5. **Slides del kickoff BM** (20 láminas, 8 hallazgos cuantitativos)
6. **Timeline interactivo** de política agropecuaria 1990-2025
7. **Carta MEFP DS 28168** ya redactada — el consultor PSE en La Paz puede ser el canal natural para gestionarla

---

## 6. Cronograma sugerido de coordinación

```
Sem 1 STC  · Plan de trabajo + recibo de paquete de datos APER 2026
Sem 2 STC  · Capacitación presencial La Paz (gestión paralela carta MEFP)
Sem 3 STC  · Análisis IDB + redacción reporte PSE
Sem 4 STC  · Estimación Repurposing + benchmarking LAC

APER 2026 paralelo:
- DEA bootstrap Simar-Wilson (independiente del STC)
- Reporte técnico Quarto book Cap. 2-4 (poblamiento)
- Cap. 5 Recomendaciones espera reporte STC para integrar cifra Repurposing
```

---

## 7. Decisiones de coordinación recomendadas (a definir con Héctor Peña)

1. **¿El reporte STC se incluye como anexo del APER 2026 o como documento autónomo?**
   - Recomendación: anexo metodológico + sección de recomendaciones del APER cita el reporte STC como fuente principal del costo fiscal.
2. **¿La capacitación incluye a UDAPE / VIPFE / DGAA?**
   - Recomendación: sí — son los custodios de los datos que el APER necesita (gap B.1).
3. **¿Quién gestiona la carta MEFP DS 28168 ya preparada?**
   - Recomendación: oficina BM Bolivia firma + Héctor Peña / consultor STC entregan en mano durante la capacitación.
4. **¿El consultor STC tiene acceso al repo privado o público?**
   - Recomendación: público — todo está en https://github.com/jcmunozmora/bolivia-wb-aper-2026 + sitio Pages.
5. **Convergencia metodológica MPS** — ¿se hace cross-check antes de cerrar reportes?
   - Recomendación: una sesión técnica conjunta entre STC y APER 2026 al final de la capacitación (1-2 horas).

---

**Conclusión:** Las dos consultorías son **fuertemente complementarias y no superpuestas**. El APER 2026 ofrece la base de datos consolidada y el contexto narrativo; el STC PSE/Repurposing aporta las estimaciones OECD actualizadas y la cifra fiscal del Repurposing. Coordinándolas se obtiene un producto integrado más sólido del que produciría cualquiera de las dos por separado.
