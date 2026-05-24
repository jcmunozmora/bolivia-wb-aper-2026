# INDICADORES.md — Diccionario del panel v12 (176 variables)

**Versión:** v0.2.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/02_INDICADORES.md`
**Diccionario CSV autoritativo:** [`01_data/processed/spending_panel_v12_dictionary.csv`](../01_data/processed/spending_panel_v12_dictionary.csv) (176 vars × 5 cols, 17 grupos).
**Panel canónico:** [`01_data/processed/spending_panel_v12.rds`](../01_data/processed/spending_panel_v12.rds) (también CSV gemelo).
**Cobertura temporal:** 1990–2024 (35 años, ventana máxima del panel; cada variable trae su `n_obs` y `pct_filled`).
**Estado:** 🟢 **Estructurado** — cada grupo describe variables canónicas, fuente, unidad, transformaciones y cobertura. Pendiente: para v1.0, definición bilingüe ES/EN línea-a-línea de variables clave.

---

## Cómo se mantiene

1. El **CSV es la fuente**; este MD es la lectura humana.
2. Cualquier cambio en variable del panel → primero al CSV (vía script de construcción), luego sincronizar este MD.
3. Cambio en definición/filtro/unidad de variable existente = **ROJO** ([`CONTROL.md`](08_CONTROL.md)) → ADR.
4. Variable nueva = **AMARILLO** → entrada nueva + nota.
5. Para sincronizar automáticamente: `02_code/00_setup/03_dictionary_to_md.R` (a implementar).

---

## Notación

```text
n          : observaciones no-NA (de 35 años posibles)
%          : pct_filled = n / 35 × 100
unidad     : USD mm = millones de USD corrientes; BOB mm = millones BOB; BOB mm 2015 = BOB constantes 2015
trans.     : transformación aplicada en construcción del panel
fuente     : ver FUENTES.md
```

---

## G00 — Identificador (1 var)

| Variable | Tipo | n | % | Descripción | Fuente |
|---|---|---|---|---|---|
| `year` | integer | 35 | 100 | Año calendario, clave del panel. Cobertura 1990–2024. | construcción interna |

---

## G01 — Macro general (16 vars)

Variables macroeconómicas de contexto, mayormente WDI con complementos BCB e IDB.

| Variable | Tipo | n | % | Descripción | Fuente | Unidad |
|---|---|---|---|---|---|---|
| `bob_per_usd` | num | 24 | 69 | Tipo de cambio promedio anual oficial | BCB / WDI | BOB / USD |
| `bob_per_usd_idb` | num | 4 | 11 | Tipo de cambio del módulo IDB AgriMonitor (cross-check) | IDB AgriMonitor | BOB / USD |
| `cpi_2010base` | num | 24 | 69 | Índice de precios al consumidor, base 2010=100 | WDI | índice |
| `cpi_2015base` | num | 24 | 69 | IPC reconvertido a base 2015=100 (usado en deflactor del panel) | derivado | índice |
| `cpi_index` | num | 24 | 69 | IPC en base original WDI | WDI | índice |
| `gdp_current_usd` | num | 24 | 69 | PIB total a precios corrientes | WDI | USD mm |
| `gdp_deflator` | num | 24 | 69 | Deflactor del PIB total | WDI | índice |
| `gdp_per_capita_const2015` | num | 24 | 69 | PIB per cápita a USD constantes 2015 | WDI | USD |
| `gdp_per_capita_usd` | num | 24 | 69 | PIB per cápita corriente | WDI | USD |
| `inflation_cpi` | num | 24 | 69 | Inflación anual IPC | WDI | % |
| `inv_pub_total_usd_mm` | num | 35 | 100 | Inversión pública ejecutada total (cobertura VIPFE 1990–2024) | VIPFE | USD mm |
| `inv_productivos_usd_mm` | num | 35 | 100 | Inversión pública sectores productivos (incluye agropecuario + industria + minería + hidrocarburos) | VIPFE | USD mm |
| `inv_sociales_usd_mm` | num | 35 | 100 | Inversión pública social (educación, salud, saneamiento) | VIPFE | USD mm |
| `inv_infraestr_usd_mm` | num | 35 | 100 | Inversión pública en infraestructura | VIPFE | USD mm |
| `inv_multisec_usd_mm` | num | 35 | 100 | Inversión pública multisectorial | VIPFE | USD mm |
| `inv_hidrocarb_usd_mm` | num | 35 | 100 | Inversión pública en hidrocarburos (subset de productivos) | VIPFE | USD mm |

**Nota.** El deflactor canónico del panel para conversión a BOB constantes es `gdp_deflator` salvo nota explícita; ver [METODOLOGIA §5.4](01_METODOLOGIA.md).

---

## G02 — Inversión pública agropecuaria VIPFE (5 vars)

Núcleo cuantitativo del **gasto público agropecuario** desde la cuenta de inversión pública del MEFP-VIPFE.

| Variable | Tipo | n | % | Descripción | Fuente | Unidad |
|---|---|---|---|---|---|---|
| `inv_agro_usd_mm` | num | 35 | 100 | Inversión pública agropecuaria ejecutada, USD corrientes | VIPFE | USD mm |
| `inv_agro_bob_mm_current` | num | 24 | 69 | id., BOB corrientes (requiere `bob_per_usd`) | VIPFE × BCB | BOB mm |
| `inv_agro_bob_mm_2015` | num | 24 | 69 | id., BOB constantes 2015 (deflactor PIB) | derivado | BOB mm 2015 |
| `inv_agro_pct_gdp` | num | 24 | 69 | Inversión agropecuaria como % del PIB total | derivado | % |
| `inv_agro_pct_total` | num | 35 | 100 | Inversión agropecuaria como % de la inversión pública total | derivado | % |

**Caveat.** VIPFE registra inversión, no gasto corriente; el agregado de gasto público agropecuario requiere combinar VIPFE + BOOST + EMAPA + municipal (ver [METODOLOGIA §4.1](01_METODOLOGIA.md)).

---

## G03 — APER 2011 (10 vars)

Serie histórica replicada del APER Bolivia 2011 (WB N° 59696-BO) para empalme con el reporte previo. Cobertura limitada (n=9 años, ventana 1999–2009).

| Variable | Tipo | n | % | Descripción | Fuente | Unidad |
|---|---|---|---|---|---|---|
| `aper_agro_spend_bob_current_aper` | num | 9 | 26 | Gasto público agropecuario según APER 2011, BOB corrientes | APER 2011 | BOB mm |
| `aper_agro_spend_bob_2015` | num | 9 | 26 | id., BOB 2015 | derivado | BOB mm 2015 |
| `aper_agro_spend_usd` | num | 9 | 26 | id., USD corrientes | derivado | USD mm |
| `aper_agro_spend_usd_2015` | num | 9 | 26 | id., USD constantes 2015 | derivado | USD mm 2015 |
| `aper_agro_spend_pct_gdp` | num | 9 | 26 | id., % PIB total | derivado | % |
| `aper_spend_administracion_general` | num | 9 | 26 | Componente: administración general del sector | APER 2011 | BOB mm |
| `aper_spend_fomento_produccion` | num | 9 | 26 | Componente: fomento a la producción | APER 2011 | BOB mm |
| `aper_spend_investigacion_extension` | num | 9 | 26 | Componente: investigación y extensión | APER 2011 | BOB mm |
| `aper_spend_riego_agua` | num | 9 | 26 | Componente: riego y manejo de agua | APER 2011 | BOB mm |
| `aper_spend_sanidad_inocuidad` | num | 9 | 26 | Componente: sanidad e inocuidad | APER 2011 | BOB mm |

**Uso.** Comparabilidad histórica de la composición del gasto antes/después de la Ley 393 (servicios financieros) y del cambio de marco político 2009–2013.

---

## G04 — Gasto BOOST (12 vars)

Ejecución presupuestaria desde la base BOOST (WB), cobertura 2009–2024 (n=13 hasta 2024; las primeras observaciones son sparse).

| Variable | Tipo | n | % | Descripción | Fuente | Unidad |
|---|---|---|---|---|---|---|
| `boost_presup_aprobado_mm` | num | 13 | 37 | Presupuesto aprobado del sector agropecuario | BOOST | BOB mm |
| `boost_presup_ejecutado_mm` | num | 13 | 37 | Presupuesto ejecutado | BOOST | BOB mm |
| `boost_tasa_ejecucion` | num | 13 | 37 | Ratio ejecutado / aprobado | derivado | % |
| `boost_gasto_corriente_mm` | num | 13 | 37 | Componente corriente del gasto ejecutado | BOOST | BOB mm |
| `boost_gasto_capital_mm` | num | 13 | 37 | Componente de capital (inversión) | BOOST | BOB mm |
| `boost_pct_capital` | num | 13 | 37 | Capital / total | derivado | % |
| `boost_fuente_tgn_mm` | num | 13 | 37 | Financiamiento desde Tesoro General de la Nación | BOOST | BOB mm |
| `boost_fuente_rec_esp_mm` | num | 13 | 37 | Financiamiento desde recursos específicos | BOOST | BOB mm |
| `boost_fuente_credito_int_mm` | num | 13 | 37 | Financiamiento desde crédito interno | BOOST | BOB mm |
| `boost_fuente_credito_ext_mm` | num | 13 | 37 | Financiamiento desde crédito externo | BOOST | BOB mm |
| `boost_fuente_donacion_mm` | num | 13 | 37 | Financiamiento desde donaciones | BOOST | BOB mm |
| `boost_n_entidades` | int | 13 | 37 | Conteo de entidades ejecutoras con gasto agropecuario en el año | derivado | conteo |

**Caveat.** BOOST cubre administración central y entidades descentralizadas; la cobertura de subnacionales se complementa con G05 (municipal); las empresas estatales tienen tratamiento aparte (G06 + secundaria).

---

## G05 — Gasto municipal (11 vars)

Gasto subnacional municipal agropecuario y rural, dos definiciones (estricta vs. programa 10) más infraestructura rural ampliada.

| Variable | Tipo | n | % | Descripción | Fuente | Unidad |
|---|---|---|---|---|---|---|
| `mun_agro_strict_bob_mm` | num | 10 | 29 | Gasto municipal estrictamente agropecuario (clasificación funcional A) | SIIF / Jubileo | BOB mm |
| `mun_agro_strict_bob_mm_2015` | num | 10 | 29 | id., BOB 2015 | derivado | BOB mm 2015 |
| `mun_p10_agropecuario_bob_mm` | num | 10 | 29 | Gasto municipal en programa 10 (Desarrollo Agropecuario), definición amplia | SIIF / Jubileo | BOB mm |
| `mun_p10_agropecuario_bob_mm_2015` | num | 10 | 29 | id., BOB 2015 | derivado | BOB mm 2015 |
| `mun_p10_corriente_bob_mm` | num | 10 | 29 | Programa 10, componente corriente | SIIF / Jubileo | BOB mm |
| `mun_p10_inversion_bob_mm` | num | 10 | 29 | Programa 10, componente inversión | SIIF / Jubileo | BOB mm |
| `mun_p10_pct_presup_total` | num | 10 | 29 | Programa 10 como % del presupuesto municipal total | derivado | % |
| `mun_rural_infra_bob_mm` | num | 10 | 29 | Infraestructura rural municipal (caminos vecinales, electrificación rural, agua rural) | SIIF / Jubileo | BOB mm |
| `mun_rural_infra_bob_mm_2015` | num | 10 | 29 | id., BOB 2015 | derivado | BOB mm 2015 |
| `mun_rural_total_bob_mm` | num | 10 | 29 | Gasto rural municipal agregado (agro estricto + infra rural) | derivado | BOB mm |
| `mun_rural_total_bob_mm_2015` | num | 10 | 29 | id., BOB 2015 | derivado | BOB mm 2015 |

**Caveat.** Cobertura municipal parcial: depende de qué municipios reportaron al SIIF. Jubileo provee compilación complementaria; ver [FUENTES §1](03_FUENTES.md). El gap es zona crítica documentada en `00_admin/ESTADO_DE_DATOS.md`.

---

## G06 — EMAPA (2 vars)

Gasto de la Empresa de Apoyo a la Producción de Alimentos (estatal). Cobertura 2000–2024 con huecos.

| Variable | Tipo | n | % | Descripción | Fuente | Unidad |
|---|---|---|---|---|---|---|
| `emapa_bob_mm` | num | 25 | 71 | Gasto operativo + compras públicas EMAPA, BOB corrientes | informes EMAPA + Jubileo | BOB mm |
| `emapa_bob_mm_2015` | num | 24 | 69 | id., BOB 2015 | derivado | BOB mm 2015 |

**Caveat.** EMAPA opera compras públicas (sostenimiento de precios) que entran al MPS del PSE (G08); el componente operativo entra al GAP. La separación se documenta en [METODOLOGIA §6.1](01_METODOLOGIA.md).

---

## G07 — SPEED IFPRI (5 vars)

Serie internacional de gasto público en agricultura del IFPRI SPEED database, comparable cross-country.

| Variable | Tipo | n | % | Descripción | Fuente | Unidad |
|---|---|---|---|---|---|---|
| `speed_ag_con_usd` | num | 18 | 51 | Gasto agropecuario público, USD corrientes (SPEED) | IFPRI SPEED | USD mm |
| `speed_ag_con_ppp` | num | 18 | 51 | id., PPP USD | IFPRI SPEED | USD mm PPP |
| `speed_ag_pctgdp` | num | 18 | 51 | id., % PIB total | IFPRI SPEED | % |
| `speed_ag_pctaggdp` | num | 18 | 51 | id., % PIB agropecuario | IFPRI SPEED | % |
| `speed_ag_pctexp` | num | 18 | 51 | id., % gasto público total | IFPRI SPEED | % |

**Uso.** Benchmarking internacional. SPEED puede no coincidir con VIPFE+BOOST locales por diferencias metodológicas; cuando hay divergencia, se reporta rango.

---

## G08 — PSE IDB (43 vars)

**El grupo más extenso.** Producer Support Estimate y agregados relacionados desde IDB AgriMonitor, calculados con metodología OECD-PSE adaptada a LATAM. Cobertura 2006–2023 (n=18) en formato BOB current/BOB 2015/% gross farm receipts; USD solo para snapshot reciente (n=4).

### G08.a — Núcleo OECD-PSE en BOB y %

| Variable | Tipo | n | % | Descripción | Unidad |
|---|---|---|---|---|---|
| `PSE_BOB_mm` | num | 18 | 51 | Producer Support Estimate, BOB corrientes | BOB mm |
| `PSE_BOB_2015` | num | 18 | 51 | PSE, BOB constantes 2015 | BOB mm 2015 |
| `PSE_USD_mm` | num | 4 | 11 | PSE, USD corrientes (snapshot reciente) | USD mm |
| `PSEP_pct` | num | 18 | 51 | %PSE = PSE / Gross Farm Receipts | % |
| `MPS_BOB_mm` | num | 18 | 51 | Market Price Support, BOB corrientes | BOB mm |
| `MPS_BOB_2015` | num | 18 | 51 | MPS, BOB 2015 | BOB mm 2015 |
| `MPS_USD_mm` | num | 4 | 11 | MPS, USD corrientes | USD mm |
| `BT_BOB_mm_agg` | num | 18 | 51 | Budgetary Transfers (componente del PSE), BOB corrientes | BOB mm |
| `BT_agg_BOB_2015` | num | 18 | 51 | BT, BOB 2015 | BOB mm 2015 |
| `CSE_BOB_mm` | num | 18 | 51 | Consumer Support Estimate, BOB corrientes | BOB mm |
| `CSE_BOB_2015` | num | 18 | 51 | CSE, BOB 2015 | BOB mm 2015 |
| `CSE_USD_mm` | num | 4 | 11 | CSE, USD | USD mm |
| `CSEP_pct` | num | 18 | 51 | %CSE | % |
| `GSSE_BOB_mm` | num | 18 | 51 | General Services Support Estimate, BOB corrientes | BOB mm |
| `GSSE_BOB_2015` | num | 18 | 51 | GSSE, BOB 2015 | BOB mm 2015 |
| `GSSE_USD_mm` | num | 4 | 11 | GSSE, USD | USD mm |
| `GSSEP_pct` | num | 13 | 37 | %GSSE | % |
| `GSSE_pct_total_support` | num | 18 | 51 | GSSE / TSE — proxy de share de bienes públicos en apoyo total | % |
| `TSE_BOB_mm` | num | 18 | 51 | Total Support Estimate, BOB corrientes | BOB mm |
| `TSE_BOB_2015` | num | 18 | 51 | TSE, BOB 2015 | BOB mm 2015 |
| `TSE_USD_mm` | num | 4 | 11 | TSE, USD | USD mm |
| `TSEP_pct` | num | 18 | 51 | TSE / PIB agropecuario | % |
| `NAC_producer` | num | 18 | 51 | Nominal Assistance Coefficient (productor) | ratio |
| `NPC_producer` | num | 18 | 51 | Nominal Protection Coefficient (productor) | ratio |
| `GDP_BOB_mm` | num | 18 | 51 | PIB del módulo IDB AgriMonitor (cross-check con G01) | BOB mm |
| `GDP_USD_mm` | num | 4 | 11 | id., USD | USD mm |
| `GHG_total_GgCO2e` | num | 5 | 14 | Emisiones GEI totales agropecuarias (módulo climático IDB) | Gg CO2eq |

### G08.b — Variables `pse_*` (espejo en otra notación, mismas series)

Las variables con prefijo `pse_` replican las anteriores en notación equivalente para el módulo de gráficos y la reproducción de tablas IDB:

| Variable | Equivale a |
|---|---|
| `pse_PSE` | PSE_BOB_2015 |
| `pse_PSEP` | PSEP_pct |
| `pse_MPS` (no listado por separado) | MPS_BOB_2015 |
| `pse_BT` | BT_agg_BOB_2015 |
| `pse_CT` | composante de transferencias al consumidor (componente del CSE) |
| `pse_CO` | otros componentes específicos del PSE-IDB |
| `pse_CSE` | CSE_BOB_2015 |
| `pse_CSEP` | CSEP_pct |
| `pse_GSSE` | GSSE_BOB_2015 |
| `pse_GSSEA` | GSSE subcomponente A (I+D / extensión) |
| `pse_GSSEB` | GSSE subcomponente B (inspección / control) |
| `pse_GSSEC` | GSSE subcomponente C (infraestructura) |
| `pse_GSSED` | GSSE subcomponente D (otros) |
| `pse_GSSEP` | GSSEP_pct |
| `pse_TSE` | TSE_BOB_2015 |
| `pse_TSEAO` | TSE como % al consumidor / componente al consumidor |
| `pse_TSEP` | TSEP_pct |

**Decisión metodológica congelada en m0.1.0.** Definiciones, fórmulas, supuestos y sensibilidad alta/media/baja del PSE están en [METODOLOGIA §4.4–§4.5](01_METODOLOGIA.md). Cambios al cálculo PSE son **ROJO + ADR** (típicamente ADR-0003).

---

## G09 — Precios y NRP por commodity (12 vars)

Precios al productor y Nominal Rate of Protection por commodity clave de Bolivia. Cobertura 1990–2023 (n=31–33).

### G09.a — Precios al productor (USD/t)

| Variable | n | % | Commodity |
|---|---|---|---|
| `pp_arroz_usd` | 31 | 89 | Arroz |
| `pp_maiz_usd` | 31 | 89 | Maíz |
| `pp_papa_usd` | 33 | 94 | Papa |
| `pp_quinua_usd` | 31 | 89 | Quinua |
| `pp_soya_usd` | 31 | 89 | Soya |
| `pp_trigo_usd` | 31 | 89 | Trigo |

### G09.b — Nominal Rate of Protection por commodity

| Variable | n | % | Descripción |
|---|---|---|---|
| `nrp_arroz` | 31 | 89 | NRP arroz = (P_productor − P_referencia ajustado) / P_referencia |
| `nrp_maiz` | 31 | 89 | NRP maíz |
| `nrp_soya` | 31 | 89 | NRP soya |
| `nrp_trigo` | 31 | 89 | NRP trigo |
| `avg_nrp` | 31 | 89 | NRP promedio ponderado del set de commodities cubiertos |
| `n_commodities_nrp` | 33 | 94 | Conteo de commodities con NRP disponible en el año |

**Uso.** Entrada al MPS del PSE (G08); el set de commodities define el alcance del PSE boliviano. Ver [METODOLOGIA §4.4](01_METODOLOGIA.md) para precios de referencia y ajustes por flete.

---

## G10 — Crédito agropecuario BCB (8 vars)

Cartera de crédito del sistema financiero por sector económico, desde el BCB. Cobertura 2010–2024.

| Variable | Tipo | n | % | Descripción | Unidad |
|---|---|---|---|---|---|
| `bcb_cred_agro_mm_bs` | num | 15 | 43 | Cartera agropecuaria, BOB corrientes | BOB mm |
| `bcb_cred_agro_mm_usd` | num | 15 | 43 | id., USD corrientes | USD mm |
| `bcb_cred_agro_pct_total` | num | 15 | 43 | Cartera agropecuaria / cartera total | % |
| `bcb_cred_total_mm_bs` | num | 15 | 43 | Cartera total sistema financiero | BOB mm |
| `bcb_cred_total_mm_usd` | num | 15 | 43 | id., USD | USD mm |
| `bcb_cred_industria_mm_bs` | num | 15 | 43 | Cartera industria (referencia) | BOB mm |
| `bcb_cred_comercio_mm_bs` | num | 15 | 43 | Cartera comercio (referencia) | BOB mm |
| `bcb_cred_construccion_mm_bs` | num | 15 | 43 | Cartera construcción (referencia) | BOB mm |

**Uso.** Contexto de Ley 393 (Servicios Financieros) — share mínimo de cartera al sector productivo. El costo fiscal del subsidio implícito se calcula aparte y entra al PSE como BT ([METODOLOGIA §6.4](01_METODOLOGIA.md)).

---

## G11 — Uso del suelo (MapBiomas Bolivia Col. 3) (14 vars)

Cobertura terrestre desde MapBiomas Bolivia Colección 3 (1985–2024). El panel cubre 1990–2024 completo (n=35).

### G11.a — Áreas y shares

| Variable | n | % | Descripción | Unidad |
|---|---|---|---|---|
| `lc_total_ha` | 35 | 100 | Área total cubierta por la colección | ha |
| `lc_antropico` | 35 | 100 | Área antrópica (agricultura + pasto manejado + urbano) | ha |
| `lc_natural` | 35 | 100 | Área natural (bosque + sabana + humedales + agua) | ha |
| `lc_no_definido` | 35 | 100 | Área sin clasificación | ha |
| `lc_antropico_share` | 35 | 100 | Antrópico / total | % |
| `lc_natural_share` | 35 | 100 | Natural / total | % |
| `mb_antropico_ha` | 35 | 100 | Espejo de `lc_antropico` (notación alterna) | ha |
| `mb_natural_ha` | 35 | 100 | Espejo de `lc_natural` | ha |
| `mb_no_definido_ha` | 35 | 100 | Espejo | ha |

### G11.b — Cambios anuales

| Variable | n | % | Descripción | Unidad |
|---|---|---|---|---|
| `lc_antropico_delta_ha` | 35 | 100 | Cambio anual antrópico | ha/año |
| `lc_natural_delta_ha` | 35 | 100 | Cambio anual natural | ha/año |
| `lc_antrop_growth_pct` | 34 | 97 | Crecimiento anual % antrópico | % |
| `defor_nacional_ha` | 23 | 66 | Deforestación nacional (definición MapBiomas alineada con G12) | ha |
| `gasto_usd_por_ha_antrop` | 35 | 100 | Gasto agropecuario USD / ha antrópica (intensidad fiscal por hectárea) | USD/ha |

**Uso.** Insumo para escenarios de repurposing con dimensión climática (S03 cuando aplica) y para escala territorial.

---

## G12 — Deforestación (Hansen Global Forest Change v1.11) (3 vars)

Deforestación tropical desde Hansen GFC v1.11. Cobertura 2001–2023.

| Variable | n | % | Descripción | Unidad |
|---|---|---|---|---|
| `hansen_forest_2000_ha` | 23 | 66 | Cobertura forestal año 2000 (línea base) | ha |
| `hansen_defor_ha` | 23 | 66 | Pérdida acumulada de bosque al año | ha |
| `hansen_defor_pct_2000` | 23 | 66 | id., como % del bosque 2000 | % |

**Uso.** Cross-check con MapBiomas (G11) — las dos series difieren por definición de "bosque" y umbral de canopy; el book reporta rango cuando hay divergencia.

---

## G13 — Clima (CHIRPS) (3 vars)

Precipitación nacional anual desde CHIRPS (Climate Hazards Group InfraRed Precipitation with Station data).

| Variable | Tipo | n | % | Descripción | Unidad |
|---|---|---|---|---|---|
| `precip_nacional_mm` | num | 34 | 97 | Precipitación media nacional ponderada por área | mm/año |
| `precip_interp_mm` | num | 34 | 97 | Versión interpolada (corrige gap puntuales) | mm/año |
| `precip_fuente` | chr | 35 | 100 | Etiqueta de la versión CHIRPS usada en el año | string |

**Uso.** Contexto climático para análisis de sensibilidad agrícola y para vincular gasto agropecuario con shocks de precipitación.

---

## G14 — TFP USDA-ERS (4 vars)

Total Factor Productivity agropecuaria desde USDA-ERS International Agricultural Productivity database.

| Variable | n | % | Descripción | Unidad |
|---|---|---|---|---|
| `tfp_index` | 34 | 97 | Índice TFP, base 2015=100 | índice |
| `tfp_output` | 34 | 97 | Índice de output agregado | índice |
| `tfp_input` | 34 | 97 | Índice de input agregado | índice |
| `tfp_per_mbob` | 24 | 69 | TFP por millón BOB de gasto agropecuario público (intensidad productiva del gasto) | índice / BOB mm |

**Uso.** F02 (brechas sectoriales) + F08 (escenarios de repurposing — outcome esperado).

---

## G15 — Producción y rendimiento cereales (FAO + INE) (4 vars)

Cross-check Bolivia (INE) con benchmark internacional (FAO).

| Variable | n | % | Fuente | Descripción | Unidad |
|---|---|---|---|---|---|
| `ine_cereal_prod_ton` | 35 | 100 | INE | Producción nacional cereales | t |
| `fao_cereal_prod_ton` | 31 | 89 | FAOSTAT | id. según FAOSTAT | t |
| `ine_cereal_yield_kg_ha` | 31 | 89 | INE | Rendimiento promedio cereales | kg/ha |
| `fao_cereal_yield_kg_ha` | 24 | 69 | FAOSTAT | id. según FAOSTAT | kg/ha |

---

## G16 — World Development Indicators (15 vars)

Indicadores WDI complementarios para benchmarking internacional.

| Variable | n | % | Descripción | Unidad |
|---|---|---|---|---|
| `wdi_agr_va_usd` | 34 | 97 | Valor agregado agropecuario, USD corrientes | USD |
| `wdi_agr_export_pct` | 32 | 91 | Exportaciones agropecuarias / exportaciones totales | % |
| `wdi_agr_import_pct` | 32 | 91 | Importaciones agropecuarias / importaciones totales | % |
| `wdi_agr_land_pct` | 34 | 97 | Tierra agrícola / superficie total | % |
| `wdi_arable_land_pct` | 34 | 97 | Tierra arable / superficie total | % |
| `wdi_irrigated_land_pct` | 1 | 3 | Tierra irrigada / tierra agrícola — **cobertura crítica baja**, ver §gaps | % |
| `wdi_cereal_yield_kg_ha` | 34 | 97 | Rendimiento cereales WDI | kg/ha |
| `wdi_crop_prod_index` | 33 | 94 | Índice de producción de cultivos | índice 2014–2016=100 |
| `wdi_livestock_prod_index` | 33 | 94 | Índice de producción pecuaria | índice |
| `wdi_gdp_pc_usd` | 34 | 97 | PIB per cápita USD WDI | USD |
| `wdi_gfcf_pct_gdp` | 34 | 97 | Formación bruta de capital fijo / PIB | % |
| `wdi_govt_exp_pct_gdp` | 18 | 51 | Gasto público total / PIB | % |
| `wdi_inflation_pct` | 34 | 97 | Inflación CPI WDI | % |
| `wdi_total_area_km2` | 34 | 97 | Superficie total del país | km² |
| `wdi_vit_a_deficiency_pct` | 21 | 60 | Prevalencia de deficiencia de vitamina A | % |

---

## G17 — Otros outcomes (8 vars)

Resultados socio-económicos y ambientales para hallazgos sustantivos (F02, F08).

| Variable | n | % | Descripción | Fuente | Unidad |
|---|---|---|---|---|---|
| `agr_value_added_pct_gdp` | 24 | 69 | VAB agropecuario / PIB total | WDI / INE | % |
| `agr_gdp_usd` | 24 | 69 | VAB agropecuario USD | derivado | USD mm |
| `agr_employment_pct` | 24 | 69 | Empleo agropecuario / empleo total | WDI / ILO | % |
| `agr_food_prod_index` | 23 | 66 | Índice de producción alimentaria | FAOSTAT | índice |
| `all_meat_prod_ton` | 35 | 100 | Producción total de carne | FAOSTAT | t |
| `rural_pop_pct` | 24 | 69 | Población rural / total | WDI / INE | % |
| `undernourishment_pct` | 23 | 66 | Prevalencia de subalimentación | FAOSTAT | % |
| `use_of_pesticides_per_area_of_cropland` | 34 | 97 | Uso de pesticidas por área cultivada | FAOSTAT | kg/ha |

---

## Variables vinculadas a hallazgos

| Hallazgo | Variables primarias |
|---|---|
| F01 magnitud y evolución del GAP | G02 (`inv_agro_*`), G04 (`boost_presup_ejecutado_mm`), G07 (`speed_ag_*`) |
| F02 brechas sectoriales | G14 (`tfp_*`), G15, G16, G17 |
| F03 composición transferencias vs bienes públicos | G08 (`PSE_*`, `GSSE_*`, `BT_*`, `MPS_*`) |
| F04 distribución territorial | G05 (`mun_*`) — pendiente componente departamental |
| F05 eficiencia y focalización | G02 × G17 + brechas territoriales |
| F06 PSE / CSE nivel y composición | G08 completo + G09 (NRP) |
| F07 arquitectura institucional | G04 (`boost_fuente_*`, `boost_n_entidades`) + G06 (EMAPA) |
| F08 oportunidades de repurposing | G08 + G11 (uso suelo) + G14 (TFP outcome) |

---

## Variables con cobertura crítica baja (< 30%)

```text
wdi_irrigated_land_pct           n=1   (3%)   ← solo 1 observación, no usable como serie
GHG_total_GgCO2e                 n=5   (14%)  ← solo snapshot reciente
PSE_USD_mm / CSE_USD_mm /
  TSE_USD_mm / MPS_USD_mm /
  GSSE_USD_mm / GDP_USD_mm       n=4   (11%)  ← formato USD del módulo PSE solo cobertura reciente
bob_per_usd_idb                  n=4   (11%)  ← cross-check, no fuente primaria
aper_*                           n=9   (26%)  ← ventana histórica del APER 2011, intencional
boost_*                          n=13  (37%)  ← BOOST arranca tarde
mun_*                            n=10  (29%)  ← cobertura municipal limitada (gap conocido — ver ESTADO_DE_DATOS.md)
GSSEP_pct                        n=13  (37%)  ← derivada del módulo IDB
```

Para hallazgos que usan estas variables se requiere:

- declarar `uncertainty: alta` en el contrato JSON ([HALLAZGOS §4](04_HALLAZGOS.md));
- reportar rango cuando la cobertura no permite tendencia;
- no usar como evidencia primaria si hay una fuente con cobertura mejor para el mismo concepto.

---

## Convenciones de nombres

```text
prefijos:
  inv_agro_   inversión pública agropecuaria (VIPFE)
  boost_      ejecución presupuestaria BOOST
  mun_        gasto municipal
  emapa_      empresa estatal EMAPA
  speed_      IFPRI SPEED database
  pse_, PSE_  módulo OECD-PSE / IDB AgriMonitor
  CSE_, GSSE_, TSE_, MPS_, BT_  componentes del support estimate
  nrp_        Nominal Rate of Protection
  pp_         precio al productor
  bcb_cred_   cartera de crédito BCB
  lc_, mb_    cobertura del suelo MapBiomas
  hansen_     Hansen Global Forest Change
  tfp_        Total Factor Productivity USDA
  fao_, ine_, wdi_  fuente del valor (cuando hay varias series del mismo concepto)
  agr_        outcomes agropecuarios genéricos

sufijos:
  _bob_mm           BOB corrientes (millones)
  _bob_mm_2015      BOB constantes 2015 (millones) ← canónico para series reales
  _usd_mm           USD corrientes
  _usd_mm_2015      USD constantes 2015
  _pct_gdp          % PIB total
  _pct_total        % del total de referencia (presupuesto, gasto, exportaciones)
  _pct_agr_gdp      % PIB agropecuario
  _ha               hectáreas
  _ton              toneladas
  _kg_ha            kg / hectárea
  _index            índice (especificar base en cada caso)
```

---

## TODOs para alcanzar v1.0

- [ ] Para cada variable: definición ES + EN línea-a-línea (no solo descripción agregada).
- [ ] Marcar qué figuras del Quarto book usan cada variable (cross-reference inverso).
- [ ] Documentar outliers conocidos y su tratamiento por variable.
- [ ] Sincronización automatizada CSV ↔ MD vía `02_code/00_setup/03_dictionary_to_md.R`.
- [ ] Tabla de transformaciones explícitas por variable derivada (función + fuentes).
- [ ] Tests de integridad: para cada variable del CSV, verificar que aparece en este MD y viceversa.
- [ ] Anclar definiciones PSE (G08) a la versión del manual OECD-PSE usado y al release de IDB AgriMonitor.

---

## Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Stub inicial: lista de 17 grupos con TODOs |
| v0.2.0 | 2026-05-23 | Expansión completa: 17 grupos × variables canónicas con tipo, n, %, descripción, fuente, unidad. Vinculación variables × hallazgos. Identificación de cobertura crítica baja. Convenciones de nombres. |
