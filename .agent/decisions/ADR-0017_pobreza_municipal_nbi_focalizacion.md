# ADR-0017 — Pobreza municipal por NBI (INE Censo 2024) y análisis de focalización gasto↔necesidad

**Estado:** propuesto (pendiente firma TTL)
**Fecha:** 2026-06-14
**Autor(es):** Juan Carlos Muñoz Mora (líder técnico EAFIT)
**Revisor(es):** _[TODO_TRACE: firma TTL — Katie Kennedy Freeman]_
**Color de cambio:** rojo (incorpora una fuente externa nueva al repo y cierra una cifra del reporte —correlación gasto↔pobreza— antes marcada `TODO_TRACE`)
**Lecturas relacionadas:** [ADR-0015](ADR-0015_consolidacion_territorial_gasto.md), [`04_report/04_spending_organization.qmd`](../../04_report/04_spending_organization.qmd) §"Focalización y necesidad", [`04_report/appendix/A_data_sources.qmd`](../../04_report/appendix/A_data_sources.qmd).

---

## Contexto

El capítulo 4 afirmaba que la correlación entre el gasto agropecuario per cápita rural municipal y la pobreza rural municipal es "débil", pero la cifra estaba sin trazar (`TODO_TRACE`) y **no era computable**: el repo solo tenía pobreza a nivel **departamental** (`ine_pobreza_departamental.rds`, `eh_dept_anual.rds`), porque las Encuestas de Hogares (EH) del INE solo son representativas a nivel departamental/área, no municipal. Tampoco existía población municipal para el denominador per cápita.

Verificación de fuentes: el **único indicador de pobreza con desagregación municipal** en Bolivia es el **NBI (Necesidades Básicas Insatisfechas)** calculado de los Censos de Población y Vivienda. El INE publica el cuadro **"Población por condición de NBI, según departamento/provincia/municipio/TIOC y área, Censos 2012 y 2024"** (Cuadro 3.06.04.03), que entrega por municipio y por área (Total/Urbana/**Rural**) tanto la **tasa de pobreza NBI** como la **población de referencia** —cerrando en una sola tabla la pobreza municipal y el denominador per cápita.

## Decisión

1. **Incorporar la pobreza municipal por NBI (INE, censos 2012 y 2024)** como fuente del reporte. Insumo crudo en `01_data/raw/ine_pobreza/ine_nbi_municipio_2012_2024_3060403.xlsx` (+ `..._3060402_numero.xlsx`), con URLs de descarga registradas en `01_data/raw/ine_pobreza/FUENTE_nbi_municipal.txt` (servidor `nimbus.ine.gob.bo`, descargado 2026-06-14).

2. **Script de limpieza** `02_code/02_cleaning/52_prep_pobreza_municipal_nbi.R` → `01_data/processed/pobreza_municipal_nbi.rds` (municipio × área {Total,Urbana,Rural}; población y % NBI para 2012 y 2024). Validación nacional: NBI rural 79,8% (2012) y 61,8% (2024).

3. **Análisis de focalización** `02_code/03_analysis/11_focalizacion_gasto_pobreza.R` → `01_data/processed/focalizacion_gasto_pobreza.rds`. Especificación: **gasto agropecuario municipal total devengado (MEFP, acteco=2, 2024, USD const. 2015) por habitante rural (Censo 2024) vs tasa de NBI rural (Censo 2024)**, sección cruzada. Crosswalk de nombres municipio↔MEFP por nombre normalizado + departamento (mismo normalizador que ADR-0015). Resultado: **n=298 municipios; Pearson r=0,13 (p=0,02); Spearman ρ=0,06 (p=0,32, no significativa)** → correlación **débil y no robusta** (el signo ni siquiera es estable entre especificaciones alternativas con gasto Jubileo 2020/NBI 2012). Confirma el enunciado "débil" del capítulo, ahora trazado.

4. **Figura nueva** `fig_focalizacion_gasto_pobreza` (`02_code/04_visualization/29_fig_focalizacion_gasto_pobreza.R`, contrato en `05_outputs/figures/meta/`): scatter gasto per cápita rural × NBI rural con recta ajustada (casi plana) y coeficientes anotados. Se conecta en `@fig-cap4-focalizacion`.

5. **NBI como medida de pobreza, no IPM.** El reporte sustituye la mención previa "pobreza multidimensional (INE 2024)" y "FIES (FAO 2022)" —no disponible a nivel municipal— por **NBI rural (INE, Censo 2024)**, declarando explícitamente que es el único indicador municipal de pobreza disponible.

## Consecuencias

**Positivas:** cierra un `TODO_TRACE` con cifra trazable y reproducible; añade una representación visual de la (no) focalización; provee pobreza municipal (NBI 2012 y 2024) reutilizable para futuros cruces territoriales (refuerza la línea base 2024 del cap. 4 y conecta con F06 y F07).

**Negativas / limitaciones declaradas:**
- El **NBI no es pobreza monetaria ni IPM**: mide carencias estructurales (vivienda, servicios, educación, salud). Es la métrica municipal disponible, no una de ingresos.
- **Mismatch temporal menor** en especificaciones alternativas (gasto 2020 Jubileo vs NBI 2012/2024); la especificación principal es 2024×2024.
- Crosswalk gasto↔NBI alcanza **n=298** de ~339 municipios (homónimos/variantes de nombre sin código INE, misma limitación del ADR-0015).
- El gasto municipal capta el POA municipal, no la ejecución del nivel central/departamental (la focalización del gasto consolidado puede diferir).

## Pendientes

- [ ] Firma TTL.
- [ ] Registrar la fuente INE-NBI municipal en el apéndice A (hecho en esta sesión) y en `01_data/DATASET_INDEX.md`.
- [ ] Opcional: replicar el cruce con gasto Jubileo por instrumento (p10) y con NBI 2012 para una lectura de robustez en el apéndice.
- [ ] Opcional: usar componentes del índice NBI (cuadros 3.06.04.04/05) para descomponer la carencia rural por dimensión.
