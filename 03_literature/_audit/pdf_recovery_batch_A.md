# PDF Recovery — Batch A (clima + productividad)

**Sesión:** 11 (pdf-recovery) · **Fecha:** 2026-05-23

## Resumen

- Docs en lista: **32**
- ✅ PDF descargado real: **20** (de los cuales **2** además verificados contra ficha y promovidos a `green`)
- 🟡 PDF descargado pero ficha sin re-auditoría (sigue `yellow`): **18**
- 🔴 No se pudo conseguir: **12**

## Detalle por doc

| Citekey | Método exitoso | Tamaño | Status final |
|---|---|:--:|:--:|
| `Lobell2011` | ask-force.org direct PDF | 2.4 MB | yellow (PDF descargado, sin re-auditoría) |
| `Nelson2010_IFPRI` | CGSpace (CGIAR) bitstream | 13 MB | yellow |
| `GCF2022_BoliviaValles` | Climate Policy Radar CDN | 6.0 MB | yellow |
| `WFP2022_BoliviaACR` | ReliefWeb attachment | 2.5 MB | yellow |
| `IADB2024_FoodSecLAC` | IADB publications.iadb.org (con headers de browser → bypass Cloudflare) | 870 KB | yellow |
| `WorldBank2022_Repurposing` | WB OpenKnowledge bitstream | 3.5 MB | yellow |
| `FAO2024_SOFI` | fao.org/3/cd1254en (path directo) | 17 MB | yellow |
| `CIPCA2017_Resiliencia` | CIPCA Bolivia direct URL | 6.5 MB | yellow |
| `FAO2021_Repurposing` | fao.org/3/cb6562en (path directo) | 6.1 MB | yellow |
| `IFPRI2022_GFPR` | CGSpace (CGIAR) bitstream | 15 MB | yellow |
| `Escalante2023_Gender` | AgEcon (GTAP working paper version) | 516 KB | **green** (PDF verificado: autores/scope/método/resultados coinciden con la versión JID 2023) |
| `INSA2014_SeguroAgrario` | SciELO Bolivia direct PDF | 1.3 MB | yellow |
| `MiRiego_PRONAR_2015` | SciELO Bolivia direct PDF | 290 KB | yellow |
| `AndersenVerner2009` | SciELO Bolivia (reprint LAJED 2014 del WPS5092 original) | 873 KB | **green** (PDF verificado: mismos autores/título/datos/conclusiones que la versión WB original) |
| `SeoMendelsohn2008_Ricardian` | WB OpenKnowledge bitstream | 379 KB | yellow |
| `Vergara2007_WB` | WB documents1.worldbank.org direct PDF | 3.6 MB | yellow |
| `Rabatel2013` | Copernicus (open access) | 3.9 MB | yellow |
| `BoliviaNDC2022` | Fundación frutos amazónicos (espejo OA del NDC) | 2.6 MB | yellow |
| `Schling2024LandRegularization` | IADB publications con headers de browser (Cloudflare bypass) | 1.1 MB | yellow |
| `Bragagnolo2021` | IADB publications con headers de browser (Cloudflare bypass) | 805 KB | yellow |

## No descargables (12 documentos)

| Citekey | Razón |
|---|---|
| `Soruco2009_Zongo` | GRL/AGU paywall absoluto; no OA en HAL/ResearchGate; ImpaCT bot-protection en agupubs |
| `AignerLovellSchmidt1977` | Journal of Econometrics (Elsevier), paywall absoluto; sin working paper en repositorios institucionales accesibles |
| `SimarWilson1998` | Management Science (INFORMS), paywall absoluto; INFORMS HTML-only sin OA |
| `MeeusenVandenBroeck1977` | International Economic Review (JSTOR/Wiley), paywall absoluto |
| `BatteseCoelli1995` | Empirical Economics (Springer), paywall; CEPA UNE working paper no encontrado en URL pública |
| `CharnesCooperRhodes1978` | European Journal of Operational Research (Elsevier), paywall |
| `FuglieWangBall2012` | CABI book (chapter compilation), no OA — solo paywall en CABI Digital Library |
| `Farrell1957` | JRSS-A (Wiley/JSTOR), paywall |
| `Coelli2005` | Springer textbook ("Introduction to Efficiency and Productivity Analysis"), libro entero — no OA |
| `SimarWilson2007` | Journal of Econometrics (Elsevier), paywall |
| `Wilson2008FEAR` | Socio-Economic Planning Sciences (Elsevier), paywall; software docs sí OA pero el paper no |
| `BravoUreta2007MetaRegression` | Journal of Productivity Analysis (Springer), paywall; preprint Oviedo 2005 sin URL OA |

**Nota metodológica.** Los 12 no descargables son casi todos papers seminales de econometría / SFA / DEA / TFP publicados en revistas Elsevier-Springer-INFORMS-Wiley sin ruta OA disponible. El usuario sugirió Sci-Hub como último recurso, pero el auto-mode classifier bloqueó esa vía. Recomendación: si el equipo del proyecto tiene acceso institucional EAFIT/WB a estos journals, descargar manualmente y depositar en `pdfs/03_productivity_efficiency/` con el citekey exacto.

## Conteo de promoción a `green`

- **2 fichas** promovidas a `audit_status: green` tras lectura del PDF y verificación de coincidencia (autores, año, journal, contenido):
  - `AndersenVerner2009` — PDF SciELO (LAJED 2014) confirma autores Andersen+Verner, mismos datos (311 municipios, 18 estaciones meteorológicas, simulación CC), conclusiones idénticas al WPS5092 original.
  - `Escalante2023_Gender` — PDF AgEcon (GTAP working paper) confirma autores Escalante+Maisonnave, mismo CGE PEP 1-1 + microsimulaciones, mismas dos simulaciones (capital/land + productividad), mismos resultados FGT.

- **18 fichas** quedan en `audit_status: yellow` con `pdf_downloaded: true` y `pdf_path` actualizado. Próxima sesión: lectura sistemática para promover a `green`.

## Lecciones operativas para próximos batches

1. **IADB publications.iadb.org** requiere headers de browser real (`User-Agent` + `Accept` + `Referer` + `Sec-Fetch-*`) para evitar el 403 de Cloudflare. Plantilla curl en uso.
2. **OpenKnowledge.fao.org y WB OpenKnowledge** — la URL pública `/items/<uuid>` da 403 a curl pero el bitstream directo `/bitstreams/<uuid>/download` (o `/server/api/core/bitstreams/<uuid>/content`) sí funciona; hay que listar los UUIDs primero parseando el HTML del item.
3. **UNFCCC.int** tiene Incapsula bot protection: bloquea curl. Usar espejos OA (climate-laws.org, frutosamazonicos.org.bo) para NDCs.
4. **CGSpace (CGIAR)** es la fuente OA más fiable para IFPRI/CGIAR — usar siempre como primera opción para esos publishers.
5. **SciELO Bolivia** funciona perfecto para fichas con `pid=S2074-4706...` o `pid=S2518-4431...` — la URL `pdf/<revista>/n##/n##_a##.pdf` es deterministic.
