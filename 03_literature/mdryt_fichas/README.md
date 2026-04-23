# Fichas de Lectura — MDRyT y documentos afines (2014-2024)

Documentos institucionales del Ministerio de Desarrollo Rural y Tierras (MDRyT) de Bolivia y fuentes secundarias, leídos para informar el Agricultural Public Expenditure Review (APER) 2026.

## Estructura de carpeta

- `_template.md` — plantilla estándar para fichas
- `YYYY_tipo_documento.md` — una ficha por documento
- `README.md` — este índice

## Inventario consolidado (7 fichas creadas)

| Año | Documento | Tipo | Páginas | PDF archivo | Ficha |
|:---:|-----------|------|:-------:|-------------|-------|
| **2014-2018** | Plan Estratégico Institucional MDRyT (PEI) | Estratégico | 35 | `PEI_2014_2018.pdf` | [`2014_2018_pei_institucional.md`](2014_2018_pei_institucional.md) |
| **2016-2020** | PSARDI (archivo nominal "Plan_Sectorial_2014_2018") | Estratégico | 290 | `PSARDI_2016_2020.pdf` | [`2014_2018_plan_sectorial.md`](2014_2018_plan_sectorial.md) |
| **2019** | Memoria Anual **INIAF** (⚠ NO es MDRyT) | Memoria | 151 | `INIAF_Memoria_2019.pdf` | [`2019_memoria_institucional.md`](2019_memoria_institucional.md) |
| **2019** | RPC Final — MDRyT consolidado | RPC | 101 | `RPC_2019.pdf` | [`2019_rpc_final.md`](2019_rpc_final.md) |
| **2021** | RPC Final — **solo IPD-PACU** (Pesca/Acuicultura) | RPC | 38 | `RPC_Final_2021.pdf` | [`2021_rpc_final.md`](2021_rpc_final.md) |
| **2024** | RPC Final — MDRyT consolidado | RPC | 34 | `RPC_Final_2024.pdf` | [`2024_rpc_final.md`](2024_rpc_final.md) |
| **2012** | CIPCA — Impacto riego/microriego 3 regiones | Secundaria | 142 | `CIPCA_impacto_riego.pdf` | [`cipca_impacto_riego_microriego.md`](cipca_impacto_riego_microriego.md) |

### Documentos no procesados

| Año | Motivo | Solución posible |
|:---:|--------|------------------|
| 2015, 2016, 2017, 2018 | No disponibles en Wayback | Carta formal MDRyT |
| 2020 | PDF truncado 1 MB en Wayback (corrupto) | Reintentar desde otro archivo |
| 2022 | PDF escaneado (14 pp, sin capa de texto) | OCR con `tesseract` |
| 2023 | PDF truncado 1 MB en Wayback (corrupto) | Reintentar / solicitud oficial |

## Descubrimientos metodológicos

Los nombres de archivo en el sitio MDRyT no corresponden al contenido real:

1. **"Memoria_2019.pdf"** → es **Memoria Anual INIAF 2019** (instituto descentralizado, no MDRyT consolidado). Renombrado a `INIAF_Memoria_2019.pdf`. Para programas MDRyT 2019 usar `RPC_2019.pdf`.

2. **"Plan_Sectorial_2014_2018"** (en sitio MDRyT) → contiene el **PSARDI 2016-2020** (Plan Sectorial Agropecuario y Rural con Desarrollo Integral, aprobado dic-2016). Renombrado a `PSARDI_2016_2020.pdf`. Referencia su antecesor "Plan 2014-2018 Hacia el 2025" pero NO lo es.

3. **RPC 2021** cubre solo IPD-PACU (Pesca y Acuicultura) — `Bs 13.68M`, NO el MDRyT consolidado. Para MDRyT 2021 faltan datos.

## Hallazgos cuantitativos consolidados (para APER)

### Presupuesto y ejecución MDRyT consolidado

| Año | Presup. vigente | Ejecutado | % financiero | % físico | Fuente |
|:---:|:---:|:---:|:---:|:---:|:---|
| 2019 | Bs 1,200M | Bs 996M | **83%** | — | RPC 2019 |
| 2024 | Bs 1,539M | Bs ~1,139M | **74%** | **54%** | RPC 2024 |
| — | — | — | (MEFP benchmark 42-96%) | — | MEFP Entidad 035, script 42 |

### Programas con desempeño contrastante

| Programa | 2019 (% ejec) | 2024 (% fin/fís) | Observación |
|----------|:-:|:-:|-------------|
| **EMPODERAR/PICAR** | 96.4% (Bs 161M) | n/d | Programa estrella 2019 |
| **CRIAR II** | 89.4% (Bs 74.8M) | n/d | Consistente |
| **PAR II** | 83.6% (Bs 41M) | — | Bajo en 2019 |
| **PAR III (BM)** | — | **16% / 60%** | 🔴 **Crítico 2024** — cofinanciamiento BM sub-ejecutado |
| **Nuestro Pozo** | 163 pozos + 40 rehab | 89% / 89% | Alto desempeño sostenido |
| **SENASAG** | 25% inversión | — | 🔴 Baja ejecución histórica |
| **IPD-PACU** | 18% inversión | 44.7% (2021) | 🔴 Sub-ejecución crónica |
| **Cacao** | n/d | 99% / 97% | Alto 2024 |
| **Frutas** | n/d | 100% / 86% | Alto 2024 |
| **Camélidos** | n/d | 100% / 96% | Alto 2024 |
| **Oleíferas** | n/d | **20% / 34%** | 🔴 Muy bajo 2024 |
| **ACCESOS RURAL** | n/d | **31% / 20%** | 🔴 Muy bajo 2024 |

### Escala de cobertura

| Indicador | 2019 | 2024 | Tendencia |
|-----------|:---:|:---:|-----------|
| Familias beneficiadas (MDRyT total) | 112,861 | n/d | — |
| Tractores entregados (mecanización) | 490 | n/d | — |
| Hectáreas mecanizadas | 132,400 | n/d | — |
| Predios regularizados (INRA) | 18,574 predios / 1.58M ha | 81% ejec | — |

### INIAF 2019 (entidad descentralizada)

- Presupuesto: Bs 98.3M vigente / Bs 82.3M ejecutado = **83.7%**
- 72 provincias, 130 municipios, 909 comunidades, ~12,200 beneficiarios
- Semillas certificadas: 76,988 t (65% de la meta)
- Cooperación internacional: KOPIA, CIMMYT, FONTAGRO, KRC/Corea

### PSARDI 2016-2020 — dimensión programática

- Inversión territorializada: **Bs 1,106.7M en 1,897 proyectos** por 7 macro-regiones
- Programas nacionales: Desarrollo Agropecuario USD 109M/año, Trigo USD 95.7M/año, Pesca/Acuicultura USD 9.9M/año
- 10 políticas priorizadas + 10+ entidades bajo tuición (INRA, INIAF, INSA, SENASAG, IPDSA, IPD-PACU, EMAPA, EMPODERAR, CRIAR II, ACCESOS)

### PEI MDRyT 2014-2018 — presupuesto plurianual

- **USD 1,105.66M programados** 2014-2018
- Composición: Desarrollo Rural 48.6% / Tierras 40.6% / Coca 10.8%
- Meta Saneamiento INRA: 65M ha (línea base 25.9M ha = 40% al 2015)
- **Riesgo institucional reconocido**: riego queda fuera de tuición MDRyT (MMAyA gestiona Mi Riego/MIAGUA) → fragmentación institucional

### CIPCA — Evaluación independiente de riego (fuente secundaria)

- Muestra: 9 comunidades, 7 municipios, 3 macro-regiones; 105 grupos focales + 36 entrevistas
- **Hallazgos críticos**:
  - Taraco: **los 3 sistemas estatales totalmente en desuso**
  - Anzaldo: **solo 128 de 372 atajados funcionan (34%)**
  - Timboycito: empresa contratada recortó sistema, excluyó familias previstas
  - Eficiencia agua: goteo 80-95%, aspersión 60-90%, inundación 20-40%
- **Impacto positivo cuando funciona**: ingresos familiares +200-236% (PROAGRO-GTZ); Bs 18K-24K anuales cebolla Tarenda
- **Crítica metodológica**: construcción masiva sin participación, sin contraparte, sin seguimiento — "por cumplir indicadores o lograr ejecución presupuestaria"

## Programas NO documentados en fuentes disponibles

Requieren carta formal al MDRyT o triangulación con BOOST/SIGEP:

- **EMAPA** (Empresa de Apoyo a la Producción de Alimentos) — subsidios a precios
- **FINPRO** (Fondo para la Revolución Industrial Productiva)
- **BDP** (Banco de Desarrollo Productivo) — crédito agropecuario (datos BCB disponibles, pero no por programa específico)
- **MI RIEGO / MIAGUA** — bajo tuición MMAyA (no MDRyT); buscar Memoria MMAyA
- **CRIAR III** (2024)
- **Mecanización** agregada post-2019

## Uso de las fichas en el APER

| Capítulo | Fichas clave | Uso |
|:--------:|--------------|-----|
| **Cap. 2 — Desempeño** | INIAF 2019, RPC 2024 | Indicadores de producción, rendimientos, cobertura |
| **Cap. 3 — Gasto institucional** | RPC 2019, RPC 2024, PSARDI 2016-2020, PEI 2014-2018 | Ejecución por programa, inversión programada |
| **Cap. 4 — Eficiencia** | CIPCA, RPC 2024, RPC 2021 | Evaluación externa, sub-ejecución, cuellos de botella |
| **Cap. 5 — Recomendaciones** | PSARDI, PEI, CIPCA | Perímetro reforma, coordinación multinivel |

## Fuentes PDFs

- PDFs descargados en `01_data/raw/mdryt/`
- Sitio oficial: `https://ruralytierras.gob.bo/` (protegido vía Cloudflare — no permite descarga directa)
- Backup exitoso: Wayback Machine (`http://web.archive.org/web/*/ruralytierras.gob.bo/*`) vía protocolo HTTP (no HTTPS)
- Secundarias: CIPCA (`cipca.org.bo`), CEDLA (`cedla.org`), Fundación TIERRA (`ftierra.org`)

---

*Última actualización: 2026-04-22 | 7 fichas creadas | 10 PDFs en raw*
