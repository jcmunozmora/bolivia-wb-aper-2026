# Revisión profunda — Gasto público agropecuario con fuentes externas nuevas

**Fecha:** 2026-06-14 · **Cap. 3 (presupuesto e instituciones)**
**Fuentes nuevas:** MEFP Presupuesto Abierto (API, 2016–2025), UDAPE Dossier (1990–2022), IMF GFSCOFOG (1972–2014, usable solo 2002–2007).
**Método:** descarga + parseo (`02_code/01_data_collection/45_parse_gasto_agro_externo.R`) + revisión multi-agente (8 agentes) con verificación adversarial. Todas las cifras releídas de los RDS crudos.

> **Caveat bloqueante (invariante 3.1):** los 5 RDS `gasto_agro_externo_*` son **externos al panel v12**. Antes de citar cualquier cifra en el `.qmd` deben integrarse al panel con trace (`rds_path`, `script_path`, `raw_source`) **o quedan como `TODO_TRACE`**. Gasto sensible → validación humana antes de numerar hallazgos (invariante 9).

---

## 1. Hallazgos nuevos (verificados)

1. **Gasto agropecuario TOTAL devengado (corriente+capital) 2016–2025 cierra el gap post-2008.** Bs 2.239–4.390 MM/año (media 3.122; piso 2020-COVID; pico 2023). = **2,04% del gasto público total** (banda 1,69%–2,58%). Primera cifra comparable al numerador Maputo desde 2007; confirma F04 sobre base de *gasto total*, no inversión.
2. **El gasto total es 2,1× la inversión VIPFE.** La inversión es solo **47,8%** del total; el ~52% restante es corriente/transferencias/empresas públicas. En USD (peg 6,91): total ≈USD 455 M/año vs inversión ≈USD 216 M/año. La serie "inversión-only" invisibilizaba la mitad del esfuerzo fiscal.
3. **EMAPA es el mayor ejecutor y se disparó: 25,3% (2016) → 42,6% (2023) → 56,2% (2025).** El núcleo del gasto agro reciente no es fomento ni bienes públicos (D), sino una **empresa estatal de compras de alimentos con precio sostén** (intervención por el lado de la demanda). En 2023 EMAPA ejecutó ~USD 232 M ≈ *toda* la inversión VIPFE del sector ese año.
4. **Recentralización: el gasto agro subnacional colapsó.** Subnacional (gobernaciones+municipios) 37,9% (2016) → 22,4% (2024); gobernaciones solas 23,2% → 6,7%. Vs era BOOST (subnacional ≈62%): de **territorial-descentralizado a centralizado-empresarial (EMAPA)**.

---

## 2. Actualizaciones al Cap. 3 (de 2008 → 2024/2025)

| # | Claim actual | Actualización | Cifra |
|---|---|---|---|
| A1 | Maputo termina 2007 | Extender a 2016–2025 sobre gasto total = 2,04% media; confirma F04 con base correcta | pct_del_total 2,01(16)·2,58(23)·1,72(24)·2,01(25) |
| A2 | "post-2008 sin desagregación" | Total devengado existe 2016–2024 y es 2,1× la inversión (inv = ~48%) | ratio 2,10× |
| A3 | proxy Maputo s/inversión 6,6% | Reemplazar por ratio gasto-total ≈2,0%; elimina caveat repetido 3× | 2,04% vs 6,6% |
| A4 | arquitectura cualitativa | Cuantificar fragmentación 2024: EMAPA 41,7%, MDRyT 18,5%, subnacional 22,4%, MMAyA/riego 7,5%, INIAF 4,8%, INRA 1,2%; **360 ejecutores** | share_ejecutor.rds 2024 |
| A5 | TODO_TRACE INIAF | INIAF share 1,8%(18) → máx 6,3%(23), 4,8%(24) | INIAF share serie |

---

## 3. Hallazgos candidatos (cifra ancla verificada) — NO numerar hasta validación humana

- **F-cand-1 — EMAPA mayor ejecutor y creciente** (25,3%→56,2%). El "repurposing real" empírico está en EMAPA, no en D. Pivote §3.1, §3.2.4, Cap. 5–6.
- **F-cand-2 — Gasto total ≈ 2× inversión** (USD 455 vs 216 M; corriente+empresas ≈52%). Nuevo §3.2.7.
- **F-cand-3 — Recentralización** (subnacional 37,9%→22,4%; gobernaciones 23,2%→6,7%). §3.1.3 + Cap. 4.
- **F-cand-4 — Total sin tendencia real, shock 2023→24** (USD 635→423 M, −33%; restricción de divisas). §3.2.6.

---

## 4. Correcciones de TODO_TRACE (L128 `03_budget_institutions.qmd`)

El texto afirma "INIAF ≈ Bs 98 M (2019)" y "SENASAG ≈ Bs 108 M (2019)". **Ambas incorrectas:**
- **INIAF 2019 real = Bs 82,3 MM** (no 98M). Serie 2016–2024 (MM Bs): 85,7 / 68,5 / 56,2 / **82,3** / 63,4 / 75,7 / 166,6 / **276,8** / 140,6. Salto 2022–2024 (probable préstamo BM). El "98M" no corresponde a INIAF en ningún año (≈98–100M es INRA). **Descartar.**
- **SENASAG NO es ejecutor independiente en el clasificador MEFP-SIGEP** (0 coincidencias en 383 entidades); se consolida dentro del MDRyT. La cifra "Bs 108 M" no es verificable. **Eliminar.** (El "Bs 108M" del audit previo era INIAF 2022 = Bs 108,7M.)

**Reemplazo trazable (L128):** *"El INIAF concentra el gasto público en investigación e innovación agropecuaria, con un devengado de Bs 82 M en 2019 que ascendió a Bs 277 M en 2023 (3,5% promedio del sector 2016–2024; MEFP-SIGEP devengado). La sanidad agropecuaria (SENASAG) no es identificable como ejecutor independiente en el clasificador MEFP —se consolida en el MDRyT— y no es trazable por separado en esta fuente."*

**Correlato Cap. 6:** la masa movible para repurposing está en **EMAPA (42–56%)**, no en D (pequeña). Matizar "D = núcleo del repurposing".
**Cap. 4:** MDRyT ejecuta **≈16–17% promedio** (rango 12,8%–20,6%), no "18–20%".

---

## 5. Correcciones cuantitativas adicionales

- **L276 "crédito ×13 la inversión" → ×8 sobre gasto total** (USD 3.397 M / USD 423 M = 8,0×). Sobre gasto total la "sustitución" F05 es menos extrema: el gasto total **no cayó** (~2% estable); el crédito creció *encima*, no necesariamente *en lugar de*. Reformular F05 como "crédito como instrumento dominante en magnitud", sin afirmar caída del gasto.
- **EMAPA redacción precisa:** "25,3% (2016) → pico 42,6% (2023) → 41,7% (2024) → 56,2% (2025); mínimo 18,6% (2018)". El salto fuerte es 2021→2023; no sugerir ascenso lineal.

---

## 6. Gaps que PERSISTEN

1. **2009–2015 sigue en blanco para gasto TOTAL** (MEFP arranca 2016; BOOST termina 2008; IMF COFOG solo 2002–2007). Serie Maputo continua tendrá salto 2008→2016 — **declararlo, no interpolar.**
2. **Split corriente/capital reciente:** el dato nuevo es devengado total, no desagregado; el corriente (~52%) se *infiere*, no se mide.
3. **Departamental granular reciente** (subnacional solo agregado post-2021).
4. **MAFAP A–E granular:** el funcional nuevo es COFOG 4.2 agregado, no reconstruye A–E; `no_data` de B/C persiste.
5. **Subsidio implícito BDP / revenue foregone** (sin tocar).

**Bug de pipeline:** en `gasto_agro_externo_imf_cofog.rds` la col `gasto_agri_cofog_lcu` está como carácter → forzar `as.numeric()`. Excluir siempre `year=0` de `mefp_sector.rds` (agregado 2016–2025) y el outlier UDAPE 1997.

---

## 7. Serie recomendada por tramo temporal

| Tramo | Concepto | Serie | Nota |
|---|---|---|---|
| 1972–2014 | Gasto agro COFOG | IMF GF0402 — **solo 2002–2007** | Resto NA; solo check robustez BOOST (corr 0,97) |
| 1990–2022 | Inversión agro | VIPFE/UDAPE = panel `inv_agro_usd_mm` | Misma serie (corr 0,9998); UDAPE valida, no agrega |
| 1996–2008 | Gasto total | **BOOST** | Validado por IMF GF0402 (corr 0,97 en 2002–07) |
| 2009–2015 | Gasto total | **GAP** — usar inversión VIPFE como cota inferior | Declarar |
| 2016–2025 | Gasto total | **MEFP sector (acteco=2)** primaria; funcional COFOG 4.2 como sensibilidad ±5% | Cierra el gap |

**Empalme BOOST→MEFP (2008→2016):** no directo (8 años sin overlap, taxonomías distintas) → requiere **ADR nuevo**. Conversión a USD hereda peg 6,91 Bs/USD.

---

## 8. Acciones priorizadas

1. **[BLOQUEANTE]** Integrar los 5 RDS al panel v12 con trace + ADR del empalme BOOST→MEFP.
2. **[ALTA]** Extender Maputo a 2016–2025 (2,04%).
3. **[ALTA]** Nuevo §3.2.7: gasto total = 2,1× inversión.
4. **[ALTA]** Cuantificar fragmentación §3.1 con shares 2024 (n=360).
5. **[ALTA]** F-cand-1 EMAPA + consecuencia repurposing (margen en EMAPA, no en D).
6. **[ALTA]** Corregir L276 "×13" → "×8".
7. **[MEDIA]** Resolver TODO_TRACE L128 (INIAF 82M→277M; eliminar 98M/SENASAG 108M).
8. **[MEDIA]** F-cand-3 recentralización; reemplazar proxy 6,6% por 2,0%.
9. **[MEDIA]** Matizar F05; MDRyT ≈16–17% (Cap. 4).
10. **[BAJA]** Documentar gaps en Apéndice A; `as.numeric` en pipeline IMF.
