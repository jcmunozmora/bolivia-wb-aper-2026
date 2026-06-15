# ADR-0016 — Especificación de la frontera DEA Simar-Wilson (orientación, outputs, segunda etapa)

**Estado:** propuesto (pendiente firma TTL)
**Fecha:** 2026-06-14
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: firma TTL — Katie Kennedy Freeman]_
**Color de cambio:** rojo (fija la especificación metodológica de un análisis central del Cap 5, reemplaza un proxy por la frontera real, cambia la 2ª etapa de Tobit a regresión truncada, y añade paquetes al renv)
**Lecturas relacionadas:** [`04_report/05_spending_analysis.qmd`](../../04_report/05_spending_analysis.qmd) §5.3, [`04_report/appendix/F_dea_simar_wilson.qmd`](../../04_report/appendix/F_dea_simar_wilson.qmd), [`02_code/03_analysis/03_dea_efficiency.R`](../../02_code/03_analysis/03_dea_efficiency.R), [`02_code/02_cleaning/11_build_dea_dataset.R`](../../02_code/02_cleaning/11_build_dea_dataset.R), [ADR-0015](ADR-0015_consolidacion_territorial_gasto.md).

---

## Contexto

El reporte (index, Cap 1 §, Cap 5 §5.3, Apéndice F) describe extensamente una **frontera DEA con bootstrap Simar-Wilson** sobre 81 DMUs (9 departamentos × 9 años, 2012–2020). La auditoría de la sesión 21 encontró que **ese cómputo nunca se ejecutó**:

1. **Lo que aparecía en el Apéndice F era un proxy, no DEA.** El "score" se construía en `08_extended_regressions.R:250` como `eff_score = (PIB/gasto) / max(PIB/gasto)` por año — una ratio de productividad parcial (1 input / 1 output) normalizada al máximo anual, sin frontera envolvente ni bootstrap. El Apéndice F lo declaraba honestamente como "proxy ratio-normalizado", pero el cuerpo del reporte lo presentaba como frontera no paramétrica con intervalos de confianza. Gap nombre ↔ cómputo.

2. **El script `03_dea_efficiency.R` estaba desconectado del dato.** Leía `subnacional_panel.rds` (no el canónico `dea_dataset.rds`) y seleccionaba columnas con `matches("agr_spending|credito|irrigated")` / `matches("agr_gdp|cereal_yield")`, patrones que **no coinciden con ninguna columna real** (las reales son `agro_strict_bob_mm_2015`, `pib_agrop_bob_2017_mm`, `rend_cereales_kg_ha`). Devolvía matrices vacías.

3. **Defectos metodológicos** aun si hubiera corrido: (a) DEA **por año sobre 9 DMUs**, que viola la regla de discriminación `n ≥ 3(m+s)` (con 3 inputs + 3 outputs se requieren ≥18 DMUs; con 9, casi todas salen "eficientes"); (b) **segunda etapa Tobit** (`censReg`), que es precisamente el estimador que Simar & Wilson (2007) demuestran *inconsistente* para scores DEA — el reporte cita SW2007 pero codificaba lo contrario; (c) `deuda_rural_mm_bob` como input candidato estaba en **BOB nominal**, no deflactado (viola invariante de valores reales); (d) el output de valor agregado `pib_agrop_bob_2017_mm` solo cubre **36/81** DMU-años (INE referencia 2017 → solo 2017–2020), de modo que una frontera basada en PIB tiene N=36, no 81.

4. **Entorno no restaurado.** Los paquetes DEA (`Benchmarking`, `rDEA`, `deaR`, `truncreg`) no estaban en `renv.lock` ni instalados; la librería renv de la máquina estaba degradada.

Datos verificados en `dea_dataset.rds` (81 filas, 32 columnas): inputs/outputs físicos con cobertura 81/81 (`agro_strict_bob_mm_2015`, `rural_total_bob_mm_2015`, `superficie_total_ha`, `produccion_total_ton`, `rend_cereales_kg_ha`); PIB agropecuario 36/81; covariables ambientales disponibles en `chirps_dept_annual_complete.rds` (precipitación) y deforestación/cobertura (`hansen_dept_annual_deforestation.rds`, ya usadas en `08`).

## Decisión

1. **Orientación: ambas (input y output), VRS, reportadas en paralelo.** Se estiman las dos orientaciones bajo retornos variables a escala (VRS, BCC) y se reporta la **correlación de Spearman entre los dos rankings** como prueba de robustez. La orientación *input* responde la pregunta de policy del reporte ("¿mismo producto con menos gasto?", coherente con repurposing); la *output* ("¿más producto con el mismo gasto?") se reporta como complemento. La cifra principal en prosa usa orientación **input**; el Apéndice F reporta ambas.

2. **Outputs físicos → 81 DMUs como especificación principal.** La frontera principal usa outputs físicos con cobertura completa: `produccion_total_ton` y `rend_cereales_kg_ha`. Preserva las 81 DMU-años (2012–2020) que el reporte declara. El **PIB agropecuario** (`pib_agrop_bob_2017_mm`, valor agregado) se reporta como **robustez en la submuestra de 36 DMU-años (2017–2020)**.

3. **Inputs.** Insumo fiscal: `agro_strict_bob_mm_2015` (gasto agropecuario estricto, BOB const. 2015 → USD const. 2015 ÷ 6,91 para reporte; el score DEA es invariante a unidades). Insumo productivo: `superficie_total_ha`. **Se excluye `deuda_rural`** de la frontera principal (está en BOB nominal → violaría el invariante de valores reales; y el crédito es un instrumento/resultado, no un insumo productivo controlable). Especificación alternativa de robustez con `rural_total_bob_mm_2015` (gasto rural amplio) en lugar del estricto.

4. **Frontera pooled intertemporal.** Una sola frontera estimada sobre las 81 DMU-años (en vez de 9 fronteras anuales de 9 DMUs cada una), satisfaciendo `n=81 ≥ 3(m+s)`. La heterogeneidad temporal se lee como posición relativa de cada par departamento-año respecto a la frontera común. (El índice Malmquist year-over-year queda como extensión futura, no como entregable de esta especificación.)

5. **Bootstrap Simar-Wilson (1998) para sesgo y bandas.** Scores corregidos por sesgo e intervalos de confianza al 95% mediante el bootstrap homogéneo de SW1998 (`Benchmarking::dea.boot`, B=2000). Reemplaza la afirmación de "2000 réplicas" del reporte por su ejecución real.

6. **Segunda etapa: regresión truncada SW2007 (reemplaza Tobit).** Los determinantes de la (in)eficiencia se estiman con la regresión truncada + doble bootstrap de Simar & Wilson (2007, Algoritmo 2), no con Tobit. Covariables ambientales `z` (no controlables por el gasto): precipitación CHIRPS, deforestación/cobertura antrópica, y participación del PIB agropecuario. Esto alinea el cómputo con la cita `@SimarWilson2007` que el reporte ya usa.

7. **Reproducibilidad.** El pipeline se reconecta al canónico `dea_dataset.rds` vía `here::here()` / `DIR_DATA_PRO`; se elimina el path hardcodeado a OneDrive en `11_build_dea_dataset.R` (mismo bug presente en `08_extended_regressions.R`, a corregir en sesión aparte). Se añaden `Benchmarking` y `truncreg` al renv y se snapshotea el lockfile.

## Consecuencias

**Positivas:** el reporte pasa de un proxy a la frontera DEA Simar-Wilson real que ya nombra; la 2ª etapa deja de contradecir su propia cita; el titular "81 DMUs" se sostiene con outputs físicos; scores con bandas de confianza estadísticamente válidas; ambas orientaciones permiten declarar estabilidad del ranking.

**Negativas / limitaciones declaradas:**
- La frontera principal no incorpora **valor agregado monetario** (PIB) por su cobertura 36/81; se reporta como robustez separada, con la advertencia de que la N corta limita el bootstrap de 2ª etapa en esa submuestra.
- Frontera **pooled** asume tecnología común 2012–2020; no captura cambio técnico (Malmquist pendiente).
- La 2ª etapa SW2007 depende de la disponibilidad y calidad de las covariables ambientales departamentales.
- DEA mide eficiencia **relativa** entre departamentos bolivianos, no absoluta ni comparada internacionalmente (el cross-check con stochastic frontier de la Box 11 PER SSA es referencial, no una corrida conjunta).
- El score DEA es invariante a unidades, pero los **inputs reportados** se expresan en USD const. 2015 por consistencia con el resto del reporte.

## Pendientes

- [ ] Firma TTL.
- [ ] `renv::snapshot()` tras confirmar `Benchmarking` + `truncreg` instalados; registrar en lockfile.
- [ ] Reemplazar en Apéndice F el proxy ratio-normalizado por los scores DEA reales + bandas; mantener nota de transición.
- [ ] Rellenar los `TODO_TRACE` de §5.3 (scores, bandas, Spearman input↔output, 2ª etapa) con cifras del RDS.
- [ ] Corregir el path hardcodeado de `08_extended_regressions.R` (mismo bug de reproducibilidad).
- [ ] Decidir si el índice Malmquist (cambio técnico) entra como extensión en una iteración futura.
