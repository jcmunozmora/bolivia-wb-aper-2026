# PDF Recovery — Batch B (cadenas valor + subsidios)

**Sesión:** pdf-recovery sesión 11
**Fecha:** 2026-05-23
**Operador:** Claude Code
**Input:** `_audit/_batch_B_cadenas_subsidios.txt` (34 documentos)

## Resumen

| Estado | Cantidad |
|--------|----------|
| OK PDF descargado y verificado (magic bytes %PDF, >100KB típicamente) | **23** |
| FALTA No descargable (paywall sin OA, Cloudflare/IMF block, web-only) | **11** |
| Total batch | 34 |

**Tasa de éxito:** 23/34 = 67.6%

## Documentos descargados (23)

| Citekey | Carpeta | Tamaño | Método | Notas |
|---------|---------|--------|--------|-------|
| UNODC2024 | 05 | 34 MB | UNODC direct PDF | Monitoreo coca 2022 (no había 2023 disponible) |
| Bazile2015 | 05 | 31 MB | FAO direct | Libro completo State of Quinoa |
| McKay2015 | 05 | 906 KB | TNI/BICAS WP6 | Working paper |
| FairLabor2024 | 05 | 1.4 MB | Fair Labor Association | Brazil nuts baseline |
| FarthingLedebur2015 | 05 | 1.2 MB | Open Society Foundations | Habeas Coca |
| Verite2016 | 05 | 2.9 MB | Verité direct | Forced labor report |
| IBCE2024 | 05 | 23 MB | IBCE Bolivia direct | Cifras Comercio Exterior |
| BazileBaudron2015 | 05 | 491 KB | Frontiers OA | Plant Science article |
| McKayColque2015 | 05 | 853 KB | BICAS conference paper (cohd.cau.edu.cn) | Versión preprint, no JPS |
| CIPAndean2020 | 05 | 16 MB | CGSpace REST API | Strategy 2020-2030 |
| Bellemare2018 | 05 | 735 KB | Towson University WP 2016-06 | Versión working paper |
| EMAPA2012 | 05 | 148 KB | Revistas Bolivianas Ciencia (Umbrales n23) | Soruco (2012) artículo completo |
| WalshDilley2014 | 05 | 1.1 MB | Cornell eCommons DSpace REST API | Dissertation 2012 (no el JPS article, mismo contenido empírico) |
| SpringmannFreund2022 | 07 | 813 KB | Nature direct OA | Nat Comm article |
| KruegerSchiffValdes1988 | 07 | 6.9 MB | World Bank documents1 | Multi-page volume |
| Mamun2024 | 07 | 806 KB | CGSpace REST API | IFPRI Discussion Paper 2245 |
| CoadyParry2019 | 07 | 652 KB | Australian Parliament mirror | IMF WP/19/89 |
| Scott2010 | 07 | 2.5 MB | CIDE repositorio | Subsidios México |
| AndersonRausserSwinnen2013 | 07 | 1.2 MB | World Bank WPS 6433 | Pre-print JEL article |
| SadouletDavisDeJanvry2001 | 07 | 132 KB | CGSpace REST API (bitstream UUID) | IFPRI FCND DP99 (brief 6 pp, no el WD article completo) |
| Searchinger2019WRI | 07 | 9.7 MB | WRI Research direct | Creating Sustainable Food Future v2.5 |
| AndersonValdes2008 | 07 | 4.1 MB | World Bank documents1 | Distortions to Agric Incentives |
| Rentschler2017 | 07 | 1.3 MB | World Bank documents1 | Reforming Fossil Fuel (versión journal) |

## No descargables (11)

| Citekey | Carpeta | Razón | Próximo paso |
|---------|---------|-------|--------------|
| PROBOLIVIA2023 | 05 | URL en frontmatter es página web home (no PDF). RPC Final 2023 no localizable en sitio gob.bo | Reasignar metadata como `type: webpage`, no aspirar PDF |
| IFAD2023 | 05 | URL es opinion piece web (no PDF) | Reasignar metadata como `type: webpage`/blog |
| Mongabay2023 | 05 | URL es web article serializado (no PDF) | Reasignar metadata como `type: news`/blog |
| Jacobsen2011 | 05 | Wiley paywall sin preprint OA encontrado | Solicitar via biblioteca WB / institucional EAFIT |
| RickerGilbertJayneChirwa2011 | 07 | Oxford/AJAE paywall, sin MSU staff paper version del AJAE article (existe staff paper relacionado pero diferente — "Enduring Effects") | Solicitar via biblioteca WB |
| AndersonRausserSwinnen2013 (JEL) | 07 | ✓ Descargado WB WPS 6433 (pre-print) en lugar del JEL paywalled | OK como pre-print |
| IDB2018Review | 07 | Cloudflare bloquea publications.iadb.org en non-browser clients | Acceso manual desde navegador requerido |
| ParryBlackVernon2021 | 07 | IMF Akamai bloquea `imf.org/-/media/` paths con Access Denied | Acceso manual desde navegador IMF |
| IMF2024AgSubsidies | 07 | IMF Akamai/eLibrary bloquea descarga directa | Acceso manual desde navegador |
| IDB_Agrimonitor | 07 | Cloudflare bloquea publications.iadb.org y agrimonitor.iadb.org | Acceso manual; o citar como base de datos (no documento PDF) |
| Anriquez2020 | 07 | Wiley DPR paywall, sin pre-print en RePEc ni ResearchGate | Solicitar via biblioteca WB |
| FundacionTierra2024 | 07 | URL es opinion piece web (no hay PDF) | Reasignar como `type: webpage` |

> **Nota sobre Sci-Hub:** El playbook del batch mencionaba sci-hub como fallback para paywall papers, pero el sandbox del agente bloqueó esas descargas explícitamente. Los items paywalled (Jacobsen2011, RickerGilbert2011, Anriquez2020, IDB2018Review, ParryBlackVernon2021, IMF2024AgSubsidies, IDB_Agrimonitor) requieren acceso vía credenciales WB.

## Notas operativas

- **Cornell eCommons (Walsh-Dilley):** AWS WAF CAPTCHA en página HTML, pero **DSpace REST API funcionó** (`/server/api/core/items/.../bundles/.../bitstreams/.../content`) — patrón replicable para otros repositorios DSpace.
- **CGSpace (CIP, Mamun, Sadoulet):** Mismo patrón DSpace REST API `/server/api/core/bitstreams/{uuid}/content` con UUID extraído del JSON de bundles.
- **IDB publications:** Cloudflare challenge agresivo, todos los intentos fallaron incluso con Wayback Machine.
- **IMF:** Akamai/edge bloquea ashx y -/media/ paths sistemáticamente. eLibrary `/downloadpdf/view/` redirige a HTML.
- **World Bank documents1.worldbank.org:** Funciona con curl simple para WPS papers (Anderson Rausser Swinnen, Anderson Valdes, Krueger Schiff Valdes, Rentschler journal version).

## Validación post-descarga

Todos los 23 PDFs verificados con magic bytes `%PDF` (`25504446`) en primeros 4 bytes vía `head -c 4 | xxd`. PDFs HTML/error eliminados antes de copiar a destino.

## Actualización de fichas

23 archivos `.md` actualizados con:
- `pdf_downloaded: true`
- `pdf_path: "03_literature/pdfs/{folder}/{filename}.pdf"`

**No se promovieron yellow→green** automáticamente. Los PDFs deben leerse en una segunda pasada (audit phase 4) para verificar coincidencia con metadata.

## Casos con discrepancia entre PDF y ficha

| Citekey | Discrepancia | Resolución sugerida |
|---------|--------------|---------------------|
| WalshDilley2014 | PDF es dissertation Cornell 2012 (Walsh-Dilley); ficha cita JPS article 2013 (mismo contenido empírico, diferente edición) | Aceptar como evidencia, citar dissertation o pedir versión publicada |
| McKayColque2015 | PDF es BICAS conference paper (CN repository); ficha cita JPS article (versión final) | Aceptar como preprint, marcar en notes |
| Bellemare2018 | PDF es Towson WP 2016-06; ficha cita World Development 2018 (versión final) | Aceptar como preprint, citar Towson WP en notes |
| SadouletDavisDeJanvry2001 | PDF es brief de 6 páginas; original es World Dev article de 14 páginas | Marcar pdf_notes: "brief, not full article" |
| UNODC2024 | PDF es Bolivia Monitoreo coca **2022** (publicado 2023); ficha cita 2023 | Aceptar — el "2024" UNODC report en realidad documenta cultivo de 2023, full report en español es del año 2022 |
| CoadyParry2019 | PDF descargado de Australian Parliament mirror | Verificar integridad (autor mismo, contenido idéntico) |

## Outputs

- 23 PDFs en `03_literature/pdfs/05_value_chains/` y `03_literature/pdfs/07_subsidies_repurposing/`
- 23 fichas `.md` actualizadas con `pdf_downloaded: true` y `pdf_path`
- Este reporte: `_audit/pdf_recovery_batch_B.md`

## Recomendaciones para sesión 12

1. **Acceso manual con browser:** Para IDB (4 items) e IMF (3 items), un humano debe descargar manualmente con sesión browser autenticada.
2. **Reasignar 4 fichas web:** PROBOLIVIA2023, IFAD2023, Mongabay2023, FundacionTierra2024 son páginas web — actualizar metadata `type: webpage` y dejar `pdf_downloaded: false` con nota explicativa.
3. **Solicitar 3 papers paywall:** Jacobsen2011, RickerGilbertJayneChirwa2011, Anriquez2020 via biblioteca World Bank o EAFIT.
4. **Audit fase 4:** Leer los 23 PDFs descargados, verificar coincidencia con metadata, promover yellow→green cuando proceda.
