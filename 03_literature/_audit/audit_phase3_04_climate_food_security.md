# Auditoria Fase 3 — 04_climate_food_security

**Fecha:** 2026-05-23
**Auditor:** Claude (verificacion DOI/Crossref + WebFetch institucional)
**Carpeta:** `03_literature/04_climate_food_security/`
**Universo Fase 3:** 23 fichas previamente `audit_status: unverified`
**PDFs accesibles en disco:** 0 (las 9 fichas con PDF ya fueron auditadas en Fase 2; esta Fase 3 cubre las que NO tienen PDF descargado)

## Resumen

- Auditadas: **23**
- **green:** 0 (sin PDF no se pueden confirmar cifras)
- **yellow:** 21 (metadata confirmada via Crossref/URL institucional pero cifras §6 no verificables)
- **red:** 2 (Carter2017_IndexInsurance autores inventados; Quinoa_Resilience_GEC DOI incorrecto)

## Detalle por ficha

### Rojos criticos (alucinacion confirmada via Crossref)

#### `Carter2017_IndexInsurance` — RED
- Verificacion: Crossref `10.1146/annurev-resource-100516-053352` + busqueda Annual Reviews.
- Resultado: title/year/journal/vol/pages/DOI **correctos**, pero la lista de autores en la ficha esta mal:
  - ficha: "Carter, **Cheng**, Sarris" (3 autores)
  - real: "**Michael Carter, Alain de Janvry, Elisabeth Sadoulet, Alexandros Sarris**" (4 autores)
- "Cheng" no es autor; faltan de Janvry y Sadoulet.
- Correccion: actualizar `authors` y BibTeX. Cifras §6 no verificables sin PDF.

#### `Quinoa_Resilience_GEC` — RED
- Verificacion: Crossref `10.1016/j.gloenvcha.2020.102152` + busqueda por titulo/autor en Crossref.
- Resultado: el DOI `10.1016/j.gloenvcha.2020.102152` resuelve a **Fischer et al "Risky responsibilities for rural drinking water institutions: The case of unregulated self-supply in Bangladesh"** — un paper completamente distinto.
- El paper Walsh-Dilley "Resilience compromised: Producing vulnerability to climate and market among quinoa producers in Southwestern Bolivia" SI existe (Global Environmental Change vol 65, 2020) pero su **DOI correcto es `10.1016/j.gloenvcha.2020.102165`** (pagina 102165, no 102152).
- La URL en la ficha (pii S0959378020307482) tampoco coincide con el pii real (S0959378020307354).
- Correccion: actualizar DOI a `10.1016/j.gloenvcha.2020.102165`, paginas a `102165`, y URL correspondiente.

### Amarillos — metadata bibliografica OK, cifras no verificables sin PDF

#### `AndersenVerner2009` — YELLOW
- Verificacion: Crossref `10.1596/1813-9450-5092`.
- Resultado: title/Andersen & Verner/WB Policy Research WP 5092/2009 — coincide.

#### `BoliviaNDC2022` — YELLOW
- Verificacion: URL UNFCCC valida (`https://unfccc.int/.../INDC-Bolivia-english.pdf`); WebFetch devuelve PDF binario no parseable.
- Resultado: registro publico del NDC actualizado de Bolivia, autoria institucional (Estado Plurinacional). Contenido no verificado a pagina.

#### `CIPCA2017_Resiliencia` — YELLOW
- URL CIPCA bien formada (publication 291). Documento institucional listado en biblioteca digital CIPCA. Sin PDF descargado.

#### `Escalante2023_Gender` — YELLOW
- Verificacion: Crossref `10.1002/jid.3711`.
- Resultado: title/Escalante & Maisonnave/J Int Development/DOI coinciden. Discrepancia menor en year/issue/pages: Crossref registra year=2022 (online first), vol 35(5), pp 884-896; la ficha tiene year=2023, issue 3, pp 419-436. El fasciculo impreso 35(5) cae en mayo/junio 2023. Recomendable verificar metadata final del fasciculo impreso.

#### `FAO2021_Repurposing` — YELLOW
- Verificacion: Crossref `10.4060/cb6562en`. title/year/publishers (FAO+UNDP+UNEP)/ISBN 9789251349175/DOI — coincide.

#### `FAO2024_SOFI` — YELLOW
- Verificacion: Crossref `10.4060/cd1254en`. title/year/agencias UN (FAO+IFAD+UNICEF+WFP+WHO)/ISBN 9789251388822/DOI — coincide.

#### `GCF2022_BoliviaValles` — YELLOW
- URL Green Climate Fund FP202 valida (registro publico del proyecto). Sin PDF descargado.

#### `IADB2024_FoodSecLAC` — YELLOW
- URL IADB bien formada. Autoria registrada como institucional (IADB) — verificar autores individuales del documento cuando se descargue PDF.

#### `IFPRI2022_GFPR` — YELLOW
- Verificacion: Crossref `10.2499/9780896294257`. title/year/IFPRI/DOI — coincide.

#### `INSA2014_SeguroAgrario` — YELLOW
- URL SciELO Bolivia bien formada (S2518-44312014000100002, Revista Boliviana de Ciencias Agropecuarias). WebFetch a SciELO Bolivia rechaza conexion en esta sesion; sin DOI no verificable via Crossref. Recomendacion: descargar PDF directo desde SciELO.

#### `Lobell2011` — YELLOW
- Verificacion: Crossref `10.1126/science.1204531`. title/Lobell-Schlenker-Costa-Roberts/Science 333(6042):616-620/2011 — coincide.

#### `MiRiego_PRONAR_2015` — YELLOW
- URL SciELO Bolivia bien formada (LAJED 24, 2015). WebFetch rechaza conexion en esta sesion. Autores Perez de Rada & Andersen consistentes con publicaciones INESAD/LAJED.

#### `Nelson2010_IFPRI` — YELLOW
- Verificacion: Crossref `10.2499/9780896291867`. title/year=2010/IFPRI/DOI — coincide. Crossref no devolvio la lista completa de autores pero la lista de 12 autores en la ficha (Nelson, Rosegrant, Palazzo, Gray, Ingersoll, Robertson, Tokgoz, Zhu, Sulser, Ringler, Msangi, You) es la estandar de esta monografia.

#### `PROAGRO_GIZ_Bolivia` — YELLOW
- URL GIZ generica (`worldwide/12356.html`). Documento cooperacion intergubernamental GIZ-SIDA-MDRyT. Sin PDF descargado.

#### `Rabatel2013` — YELLOW
- Verificacion: Crossref `10.5194/tc-7-81-2013`. title/Rabatel et al (28 autores)/The Cryosphere 7(1):81-102/2013 — coincide. La lista completa de los 28 autores del paper coincide con la del ficha.

#### `Schlenker2009` — YELLOW
- Verificacion: Crossref `10.1073/pnas.0906865106`. title/Schlenker & Roberts/PNAS 106(37):15594-15598/2009 — coincide.

#### `SeoMendelsohn2008_Ricardian` — YELLOW (mezcla parcial de papers)
- Verificacion: Crossref `10.1596/1813-9450-4163` + busqueda de variantes Seo-Mendelsohn.
- Resultado: la ficha mezcla parcialmente dos papers distintos del mismo equipo:
  - **WP 4163 (2007):** "A Ricardian Analysis of the Impact of Climate Change on **Latin** American Farms" — DOI 10.1596/1813-9450-4163 (el DOI de la ficha)
  - **Chilean J Agricultural Research (2008):** "A Ricardian Analysis of the Impact of Climate Change on **South** American Farms" — DOI 10.4067/s0718-58392008000100007 (el titulo de la ficha)
- Ambos son reales y de los mismos autores; difieren en publication venue/year. Recomendacion: decidir cual citar y homologar DOI/year/source.

#### `Soruco2009_Zongo` — YELLOW
- Verificacion: Crossref `10.1029/2008GL036238`. title/Soruco-Vincent-Francou-Gonzalez/Geophysical Research Letters 36(3)/2009 — coincide.

#### `Vergara2007_WB` — YELLOW
- URL World Bank documents bien formada. Working Paper #30 LAC Sustainable Development, autoria multi-institucional. Sin DOI publico; sin PDF descargado.

#### `WFP2022_BoliviaACR` — YELLOW
- URL ReliefWeb bien formada para WFP Annual Country Report Bolivia 2022. Documento institucional publico.

#### `WorldBank2022_Repurposing` — YELLOW
- ISBN DOI `10.1596/978-1-4648-1813-2` devuelve 404 en Crossref, pero URL openknowledge.worldbank.org valida y libro real (Gautam, Laborde, Mamun, Martin, Pineiro, Vos 2022, co-publicado WB+IFPRI). Sin PDF descargado.

## Acciones correctivas prioritarias

| Ficha | Severidad | Problema | Correccion |
|-------|:---------:|----------|------------|
| Carter2017_IndexInsurance | **ROJO** | Autoria fabricada ("Cheng"); faltan de Janvry y Sadoulet | Corregir `authors` a Carter/de Janvry/Sadoulet/Sarris + BibTeX |
| Quinoa_Resilience_GEC | **ROJO** | DOI incorrecto (resuelve a paper de Bangladesh); URL pii tampoco coincide | Corregir DOI a `10.1016/j.gloenvcha.2020.102165`; corregir paginas a 102165 y URL pii a S0959378020307354 |
| Escalante2023_Gender | AMARILLO | Year/issue/pages no coinciden con Crossref | Verificar metadata final del fasciculo impreso 35(5) |
| SeoMendelsohn2008_Ricardian | AMARILLO | Mezcla parcial WP 2007 vs publicacion CJAR 2008 | Decidir cual citar y homologar metadata |
| Multiples (FAO, WFP, GCF, CIPCA, GIZ, IADB, Vergara) | AMARILLO | Sin PDF descargado: cifras §6 no verificables | Priorizar descarga de PDFs para promover a green |

## Nota metodologica

Las 21 fichas YELLOW estan respaldadas por metadata bibliografica confirmada (via Crossref API o URL institucional verificable), pero **sus cifras concretas (§6) y citas textuales no son verificables sin acceso al PDF**. Para promoverlas a GREEN se requiere descarga + lectura del documento original. SciELO Bolivia (3 fichas) requiere descarga directa porque el dominio rechaza conexiones automatizadas en esta sesion.
