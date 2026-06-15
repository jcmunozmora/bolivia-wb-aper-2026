# Búsqueda agresiva — gasto público agropecuario 2009–2015 (cierre del gap)

**Fecha:** 2026-06-14 · **Disparador:** instrucción de cerrar la brecha 2009–2015 del gasto agropecuario total.
**Método:** 3 frentes de adquisición en paralelo (sub-agentes), descarga + lectura literal de cada fuente, sin interpolación.
**Relación:** complementa [`2026-06-14_revision_gasto_agro_externo.md`](2026-06-14_revision_gasto_agro_externo.md) §6 y [`ADR-0012`](../../.agent/decisions/ADR-0012_gasto_externo_empalme_mefp.md) §2.

---

## Veredicto

**El gap 2009–2015 de gasto público agropecuario TOTAL (corriente + capital, devengado) NO se cierra con fuentes públicas.** Se agotaron las ocho fuentes plausibles. Todas las compilaciones internacionales cortan Bolivia en **2007–2008**; el portal nacional (MEFP Presupuesto Abierto) arranca en **2016**; el World Bank BOOST **no tiene dataset-país para Bolivia**. La posición de ADR-0012 §2 (declarar el gap, reportar inversión VIPFE como cota inferior, **no interpolar**) queda ahora respaldada por una búsqueda exhaustiva y trazable.

Resultado positivo colateral: la **cota inferior de inversión** quedó **triple-validada** y aparece una **veta parcial nueva** (ASTI, sólo I+D/categoría D).

---

## Matriz de fuentes (todas verificadas hoy)

| Fuente | Endpoint / acceso | Último año con dato (agro) | ¿Cierra 2009–2015? |
|---|---|---|:--:|
| **MEFP Presupuesto Abierto** | `GET /api/acteco-data?codigo=2&tipo=clasificador`; `GET /api/finfun-data?codigo=4.2&tipo=clasificador` | **2016+** (acteco no anuncia pre-2016; finfun 4.2 lista 2011–2015 pero `estados` vacío; consultas año-a-año → HTTP 400) | ❌ |
| **World Bank BOOST** | `worldbank.org/.../boost-portal/country-data` | **Bolivia ausente** de los 50 países BOOST | ❌ |
| **IFPRI SPEED 2019** (release más nueva) | Harvard Dataverse `doi:10.7910/DVN/MKX1TU` → `speed2019.xls` | **2007** (NA estructural desde 2008 en todos los sectores) | ❌ |
| **FAOSTAT Government Expenditure** | bulk S3 `Investment_GovernmentExpenditure_E_All_Data.zip` (area 19) | **2007** (cols Y2001–Y2024 existen; valores vacíos 2008+) | ❌ |
| **IMF GFS-COFOG** (GF0402) | DBnomics (descargado sesión previa) | **NA 2008–2014** (usable sólo 2002–2007) | ❌ |
| **CEPALSTAT** | API `indicator/4409/data` (gasto público por función, Bs) | Bolivia **no reporta** la función "Agricultura" ni "Asuntos económicos" (0 registros) | ❌ |
| **UDAPE Dossier / Diagnóstico Agropecuario 2023** | `udape.gob.bo` (xls Cuadro 3.7.1; PDF diagnóstico) | sólo **inversión** (= cota inferior ya conocida) | ❌ (valida, no agrega) |
| **IFPRI ASTI** | `asti.cgiar.org/countries/bolivia` + factsheet 2023 PDF | **I+D 2009–2021** (sólo categoría D; serie anual en el data-tool interactivo, no en tabla) | ⚠️ parcial |

Endpoints y archivos crudos quedan en `01_data/raw/external_gasto_2026/` (FAOSTAT bulk + `bolivia_govexp_all.csv`; `speed2019.xls`; `cepal_4409_*`/`cepalstat_4409_bolivia_funcional.csv`; `asti_bolivia_factsheet_2023.pdf`; `mefp_*_clasificador.json` + `SOURCES_pre2016_probe.txt`).

---

## Cota inferior de inversión — triple-validada (USD M, ejecutado)

| Año | 2009 | 2010 | 2011 | 2012 | 2013 | 2014 | 2015 |
|---|---|---|---|---|---|---|---|
| Inversión agro | 90 | 84 | 135 | 180 | 223 | 275 | 320 |

Tres fuentes independientes coinciden: panel `inv_agro_usd_mm` (VIPFE/SISIN) = UDAPE Dossier Cuadro 3.7.1 (miles USD, ejecutado) = UDAPE Diagnóstico Agropecuario 2023 (VIPFE). Es **cota inferior** del gasto total (excluye corriente/transferencias/empresas; recordar que para 2016–2024 el total ≈ 2,1× la inversión).

**Contexto pre-ventana (FAOSTAT GovExp, agro, gobierno general, USD M):** 2002≈73.9 · 2003≈58.8 · 2004≈77.7 · 2005≈78.4 · 2006≈92.2 · 2007≈133.1 — coherentes con BOOST 1996–2008 e IMF GF0402 2002–2007.

---

## Implicaciones para el reporte

1. **Mantener ADR-0012 §2 tal cual** — ahora con respaldo de búsqueda exhaustiva. En el Cap. 3 / Apéndice A: declarar el **salto 2008→2016** de la serie de gasto total y reportar 2009–2015 sólo como inversión etiquetada "cota inferior". **No interpolar.**
2. **El único camino al TOTAL 2009–2015** es la solicitud directa al MEFP/VIPFE de la ejecución por finalidad-función pre-2016 (canal marcado 🔴 bloqueado / "no será posible" en `03_FUENTES.md` y ADR-0012 §contexto).
3. **Veta parcial accionable (ASTI):** la serie I+D de INIAF 2009–2021 (Bs const. 2017) poblaría/enriquecería la **categoría D** del MAFAP en los años del gap; requiere extracción del data-tool interactivo de ASTI. Dato citable ya disponible: la intensidad de investigación agropecuaria cayó de **1.0% a 0.5% del PIB agrícola (2015–2020)** y el gasto I+D estuvo estancado 2009–2013 (ASTI factsheet 2023, IFPRI–BID).

---

## Conclusión de una línea

Se buscó agresivamente en 8 fuentes; el gasto agropecuario **total** 2009–2015 no existe en datos públicos (todas las compilaciones mueren en 2007–08; MEFP arranca 2016). El gap es real y se declara; la inversión queda como cota inferior triple-validada; ASTI ofrece sólo el componente I+D.
