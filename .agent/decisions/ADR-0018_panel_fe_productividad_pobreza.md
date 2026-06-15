# ADR-0018 — Panel FE de §5.4: outcomes realizables (productividad de la tierra + pobreza INE), no TFP/FIES departamental

**Estado:** propuesto (pendiente firma TTL)
**Fecha:** 2026-06-14
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: firma TTL — Katie Kennedy Freeman]_
**Color de cambio:** rojo (redefine los outcomes de un análisis central del Cap 5, incorpora una fuente de datos nueva —pobreza departamental INE—, fija el estimador, y reescribe §5.4; reemplaza una especificación irrealizable por una corrible)
**Lecturas relacionadas:** [`04_report/05_spending_analysis.qmd`](../../04_report/05_spending_analysis.qmd) §5.4, [`04_report/appendix/E_panel_fe.qmd`](../../04_report/appendix/E_panel_fe.qmd), [`02_code/02_cleaning/12_build_productivity_panel.R`](../../02_code/02_cleaning/12_build_productivity_panel.R), [`02_code/03_analysis/09_panel_fe_productivity.R`](../../02_code/03_analysis/09_panel_fe_productivity.R), [`02_code/03_analysis/10_panel_fe_poverty.R`](../../02_code/03_analysis/10_panel_fe_poverty.R), [`02_code/01_data_collection/34_ine_poverty_departamental.R`](../../02_code/01_data_collection/34_ine_poverty_departamental.R), [ADR-0016](ADR-0016_dea_simar_wilson_especificacion.md).

---

## Contexto

§5.4 describía un panel departamento-año con efectos fijos cuya ecuación canónica usaba dos outcomes —**TFP departamental** (espec. 1) y **FIES departamental** (espec. 2)— sobre `ln(gasto agro per cápita rural)`, con FE depto+año, dummies `post_ley393`/COVID y `fixest::feols`. Las cifras estaban como `TODO_TRACE` ("pendiente de re-corrida sobre v12"). La auditoría de esta sesión encontró que **la especificación no es corrible con el dato disponible**:

1. **TFP departamental no existe.** El TFP boliviano solo está a nivel **nacional** (`usda_tfp_bolivia.rds`, `tfp_index` en panel v12). Un TFP multifactor (Törnqvist) por departamento-año requeriría capital y trabajo anuales, que solo existen en puntos censales (ENA 2008/2015, CNA 2013) — no hay serie anual. El panel canónico `subnacional_panel_v2.rds` no contiene ninguna variable TFP.

2. **FIES departamental no existe como panel regresable.** El módulo de Seguridad Alimentaria de la Encuesta de Hogares (de donde sale FIES) solo se levantó en 2019, 2021, 2022, 2023 y 2024. El gasto departamental (Jubileo) termina en 2021 ⇒ **solo 2 años solapan** (2019, 2021) ⇒ con FE depto(9)+año(2) no quedan grados de libertad.

3. **Regresores irrealizables o mal especificados.** (a) `gasto per cápita rural` no es construible: no hay denominador de población rural departamental anual. (b) Con FE de año (τ_t), los dummies con timing fijo `post_ley393` y `covid` quedan **perfectamente colineales** con los efectos de año — la ecuación canónica los incluía junto a τ_t (mis-especificación).

4. **Entorno y reproducibilidad.** `fixest` no está instalado ni en `renv.lock` (los scripts 04/08 que lo usan nunca corrieron reproduciblemente). `08_extended_regressions.R` y `33_process_encuestas_hogares.R` leían datos desde un **path absoluto a OneDrive** (rompe el invariante 7). `04_regression_outcomes.R` leía paneles **no canónicos** (`spending_panel.rds`, `subnacional_panel.rds`, no v12/v2) y variables inexistentes (rompe el invariante 2).

Datos verificados: `subnacional_panel_v2.rds` (9 deptos × 2012–2021); INE `ine_agro_stats_long.rds` (producción/superficie 1984–2020); `cereal_yield_dept.rds`; `pib_departamental_agro.rds` (2017–2021); precipitación departamental en `chirps_dept_annual_complete.rds`; pobreza departamental oficial descargable de INE (`nube.ine.gob.bo`).

## Decisión

1. **Outcome de productividad = productividad de la tierra (producción por hectárea), no TFP.** El outcome principal del panel FE departamental es `ln(producción agrícola total / superficie cultivada)` (ton/ha, INE), un índice de productividad de la tierra anual y de cobertura completa (81 DMU-años, 2012–2020). Robustez: `ln(rendimiento de cereales)` (un solo dominio) y `ln(PIB agropecuario)` (valor agregado, 2017–2021, N=45). El **TFP nacional** se mantiene en el hallazgo F01 (Cap 2). En el reporte el outcome se nombra **"productividad de la tierra"**, no "TFP departamental" (neutralidad + trazabilidad).

2. **Outcome de bienestar = pobreza departamental OFICIAL del INE, en reemplazo de FIES.** Incidencia de pobreza **moderada** y **extrema** por departamento (INE, Encuestas de Hogares; tablas ya calculadas, sin reprocesar microdatos). Dos series por cambio de Canasta Básica Alimentaria —`cba_2011_2018` (antigua) y `cba_2016_2024` (vigente)— que **NO se encadenan** (el solape 2016–2018 muestra ~4–9 pp de salto); se corren por separado. FIES se descarta de la regresión por cobertura insuficiente.

2bis. **Insumo fiscal principal = gasto agropecuario MUNICIPAL ejecutado del MEFP (Presupuesto Abierto), USD const. 2015, 2016–2024** (devengado, árbol acteco). Es el dato oficial más reciente y reemplaza a Jubileo como regresor principal (petición del usuario, sesión actual). **Límite duro: la API MEFP no expone gestiones < 2016** (devuelve vacío para 2013–2015; verificado en vivo 2026-06-14); pre-2016 solo existe la serie consolidada de Jubileo (2012–2021) o una solicitud SIIF directa al ministerio ([10_siif_request_letter.md](../../02_code/01_data_collection/10_siif_request_letter.md)). La serie Jubileo se conserva como robustez/ventana larga. **Advertencia:** las dos series de gasto correlacionan solo 0,17 *within-department* (0,75 en niveles) → miden variación distinta año a año; MEFP es municipal, Jubileo consolidado.

3. **Estimador: FE bidireccional (depto+año) en base R `lm` + errores cluster-robustos (`sandwich::vcovCL`, HC1/CR1) por departamento.** Se evita `fixest` (no instalado, no en `renv.lock`) → cero dependencias nuevas más allá de `sandwich` (ya disponible) y `readxl` (parser INE). La inferencia usa t con G−1=8 g.l. **Caveat de pocos clusters (9 departamentos): la inferencia cluster-robusta es anticonservadora**; el wild cluster bootstrap queda como refinamiento pendiente.

4. **Corrección de especificación.** Con FE de año, `post_ley393` y `covid` solo se reportan en la variante con **FE de departamento únicamente** (M7), no junto a los FE de año.

5. **Identificación asociativa, no causal** (se preserva la declaración de §5.4).

6. **Reproducibilidad.** Pipeline nuevo conectado al canónico vía `here::here()`/`DIR_DATA_PRO`:
   - `34_ine_poverty_departamental.R` → `ine_pobreza_departamental.rds`
   - `12_build_productivity_panel.R` → `subnacional_productivity_panel.rds`
   - `09_panel_fe_productivity.R` → `panel_fe_productivity_results.rds`
   - `10_panel_fe_poverty.R` → `panel_fe_poverty_results.rds`
   Se corrige el path OneDrive de `08` y `33` a rutas relativas; `04_regression_outcomes.R` se **deprecia** (superado por 08 nacional + 09/10 subnacional) para eliminar la lectura de paneles no canónicos.

## Resultados (de los RDS, semilla/d.f. fijos) — NULO ROBUSTO

Con el dato oficial más reciente (gasto MEFP 2016–2024), el gasto agropecuario **no muestra asociación estadísticamente significativa ni con la productividad ni con la pobreza** a nivel departamental, una vez absorbidos los FE depto+año:

- **Productividad ↔ gasto: nulo.** `ln(prod/ha) ~ ln(gasto MEFP) + lluvia | depto+año`: coef +0,005 (p=0,90, N=45). Con gasto Jubileo (ventana larga 2012–2020) +0,032 (p=0,25, N=81). Ninguna variante alcanza significancia. Triangula con **F01** (inversión real ×10 / TFP estancada).
- **Pobreza ↔ NIVEL de gasto: NO robusto.** Con gasto MEFP (vigente 2016–2024): coef **+1,2 a +0,2 pp, no significativo** (moderada y extrema). La asociación **negativa** aparece **solo con la serie Jubileo y la ventana 2012–2018** (moderada −4,96 pp p<0,01); con Jubileo en 2016–2021 ya cae a −2,3 pp (ns al 5%). El signo depende de la fuente y la ventana → **el "dividendo de pobreza" del NIVEL de gasto no es robusto.**
- **Pobreza ↔ COMPOSICIÓN del gasto: SÍ importa** (script 11, `gasto_agro_prog_muni_grupo.rds`, MEFP 2016–2024). A igual gasto total, una mayor **participación de bienes públicos** (servicios técnicos: I+D, extensión, sanidad) se asocia con **menor pobreza**: moderada **−19,0 pp** por unidad de participación (p=0,085), extrema **−17,8 pp** (p=0,019); el coeficiente del nivel total es no significativo en ambos. Descriptivamente, el apoyo directo a la producción pasó de 43% a 63% del gasto agro (2016–2024) mientras los servicios técnicos siguen en ~14% (figura `fig42`). Las regresiones de nivel por tipo individual son ruidosas/ns (multicolinealidad entre tipos).

**Lectura de policy:** a nivel departamental el **nivel** del gasto agropecuario no se asocia de forma robusta con resultados, pero la **composición** sí (más bienes públicos → menor pobreza, a igual gasto total). Es el sustento empírico directo del repurposing del capítulo 6 (reasignar, no necesariamente gastar más). Refuerza F01/F03. La baja correlación within-dept entre fuentes de gasto (0,17) es un caveat de medición.

## Consecuencias

**Positivas:** §5.4 pasa de una especificación irrealizable (`TODO_TRACE` perpetuo) a un análisis **corrible y reproducible** con datos canónicos, el gasto oficial más reciente (MEFP) y una fuente de bienestar oficial (pobreza INE); los outcomes coinciden con lo que el dato soporta; el nulo robusto es un resultado honesto que refuerza F01 y el repurposing; se elimina la dependencia no resuelta de `fixest` y los paths a OneDrive.

**Negativas / limitaciones declaradas:**
- Identificación **asociativa**; **9 clusters** ⇒ inferencia anticonservadora (wild cluster bootstrap pendiente).
- La pobreza INE es **total** departamental, no rural (la rural-por-depto solo vive en microdatos confidenciales).
- Dos series de pobreza **no encadenables**; los resultados se leen dentro de cada metodología.
- `prod/ha` agrega toneladas de cultivos heterogéneos (medida cruda de productividad de la tierra); el PIB agropecuario tiene N corto (2017–2021).
- Microdatos crudos EH no viven en el repo (tamaño/confidencialidad, invariante 14): el reemplazo por tablas INE pre-calculadas es además una ventaja de reproducibilidad.

## Pendientes

- [ ] Firma TTL.
- [ ] `renv::snapshot()` tras confirmar `readxl` + `sandwich` en el lockfile.
- [ ] Reescribir §5.4 (TFP→productividad de la tierra, FIES→pobreza INE) y el Apéndice E con cifras de los nuevos RDS.
- [ ] Wild cluster bootstrap para inferencia con pocos clusters (p.ej. `fwildclusterboot`), o reportar p-valores con la salvedad explícita.
- [ ] Evaluar pobreza **rural** por departamento vía microdatos EH (script 33) si la mesa técnica lo requiere, con su ADR de confidencialidad.
- [ ] Decidir si el panel FE nacional de TFP de `08` (sección 1) se mantiene como complemento o se absorbe en F01.
