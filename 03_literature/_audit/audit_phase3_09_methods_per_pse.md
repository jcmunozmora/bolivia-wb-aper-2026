# Audit Phase 3 — Folder 09 (Methods PER & PSE)

**Fecha:** 2026-05-23
**Auditor:** Claude (asistente APER)
**Fichas auditadas en Fase 3:** 32 (todas las que estaban `unverified`)
**Total fichas en carpeta:** 37 (incluye 5 previas con audit_phase 2 ya asignado green/yellow/red)

## Resumen cuantitativo (todas las fichas, todos los phases)

| Status | # |
|---|---|
| green | 10 |
| yellow | 23 |
| red | 4 |
| **Total** | **37** |

## Fichas marcadas en Fase 3 (este audit)

### Verde (verificadas con PDF, sin errores sustantivos)

- **Anderson2008_DistortionsAfrica** — 21 países SSA confirmado, NRA/CTE coherentes.
- **Anderson2008_DistortionsLAC** — 8 países LAC verificados; Bolivia NO cubierta (confirma gap APER).
- **MAFAP2013_MethodGuideVolI** — Autoría Barreiro-Hurle & Witwer confirmada; marco NRP/MDG/NRA coherente.
- **PEFA2024_BoliviaCentralGov** — Datos verificados: 31 indicadores PEFA + 9 género + 14 clima; '6 de 31 (19%) B o superior' textual. (Solo nota: autoría institucional debería ser MEFP/BID, no PEFA Secretariat.)
- **WB2015_SouthAfricaAgPER** — Doc Jan 2015 (WB + Gates + DAFF + CAADP) verificado.
- **WB2018_PeruGainingMomentum** — Cifras 7.3% PBI agro y gasto público 0.3-0.7% PBI textualmente verificadas.
- **WB2024_LACEconomicReview** — April 2025 confirmado (citekey arrastra 2024 por convención).
- **WB2025_MalawiAgPER_Synthesis** — Feb 2025, WB+MwAPATA; Malabo ~10% confirmado.

### Amarillo (sin PDF, o PDF con discrepancias menores; metadata generalmente correcta)

23 fichas. Subgrupos:

- **Sin PDF**: AnriquezEtAl2016, AnriquezFosterOrtega2020 (Crossref OK), HayamiRuttan1985, IDB_Agrimonitor, IMF_GFSM2014, Krueger_Schiff_Valdes1991, Mink2016, MoguesOlofinbiyi2014, Mundlak_Cavallo_Domenech1989, Mundlak2000, OECD2025_APME, SimarWilson1998 (Crossref OK), SimarWilson2007 (Crossref OK), WB_BOOST, DeSalvoEtAl2018, Anderson2008_DistortionsAsia, Anderson2009_DistortionsAgIncentives.
- **Con PDF pero matiz**: FAO2012_FanMcBride (orden de autores invertido — primer autor real es Mogues, no Fan), WB2011_BoliviaAgPER (rango 0.5-1.5% citado por la ficha; PDF reporta promedio 1.4%), WB2021_BoliviaTappingPotential (año real 2019/2020, no 2021), PEFA2009_Bolivia (autoría real WB+BID, no PEFA Secretariat).

### Rojo (errores sustantivos que requieren corrección antes de citar)

1. **Cahill2005_PSE_RevisionConcept** — **ERROR DE AUTORÍA**: el OECD WP No. 1 (2005) lo escribió **Stefan Tangermann**, NO Cahill & Legg (estos solo aparecen en agradecimientos). Citekey conserva los nombres erróneos.
2. **WB2018_BrazilPERAdjustment** — Cifras del resumen (PRONAF R$ 8.3 mil millones 2015, subsidios 0.5% PIB) NO se localizaron en el PDF overview. Resumen ficha trata de agricultura específicamente, pero el documento es PER comprehensivo con foco en BNDES/educación/salud/pensiones; las cifras agro citadas parecen tomadas de otra parte (o fabricadas).

(Las fichas red previas de Fase 2 — MAFAP2014_PEMethodGuideVolII, OECD2024_APME — siguen en rojo desde antes.)

## Hallazgos sistemáticos

1. **Autoría institucional vs nombrada**: varias fichas confunden autores reales del documento con quienes lo solicitaron, supervisaron o agradecieron (Cahill2005, PEFA2009, PEFA2024, FAO2012). Patrón replicable de fabricación leve de Fase 2.

2. **Citekey arrastra año incorrecto** en al menos 3 casos (WB2018_BrazilPERAdjustment es 2017; WB2018_PeruGainingMomentum es 2017; WB2021_BoliviaTappingPotential es 2019; WB2024_LACEconomicReview es 2025). No es error grave pero conviene normalizar.

3. **Cifras macro citadas sin sostén verificable**: FAO2012 (rangos TIR), Anderson2009 (NRA OECD 40%→20%), WB2018_BrazilPERAdjustment (PRONAF R$ 8.3 mil M). Patrón Fase 2.

4. **Fichas sin PDF accesible** dominan (17 de 32). La gran mayoría tiene metadata bibliográfica correcta y deberían poder elevarse a green con descarga.

## Recomendaciones operativas

- **Renombrar citekey Cahill2005** → Tangermann2005 (o agregar nota explícita).
- **Descargar PDFs faltantes** prioritarios: OECD2025_APME (cifras Brasil), Anderson2009 (cita verbatim §6 a verificar), Krueger-Schiff-Valdés 1991 (cifras clásicas), DeSalvoEtAl2018 (PSE LAC), AnriquezEtAl2016 IDB.
- **Eliminar cita verbatim §6** de Anderson2009 (no fue purgada con §8 de cita-mass-deletion).
- **WB2018_BrazilPERAdjustment**: revisar si existe versión "Detailed Report" con cifras agro, o si las cifras son simplemente erróneas.
