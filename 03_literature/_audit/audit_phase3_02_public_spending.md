# Auditoría Fase 3 — 02_public_spending

**Fecha:** 2026-05-23
**Auditor:** Claude Code (Auto Mode)
**Alcance:** Fichas con `audit_status: unverified` en `02_public_spending/`

## Resumen

- Fichas auditadas: **26**
- Con PDF disponible: 12
- Sin PDF (verificación vía Crossref/Web): 14
- Estados finales:
  - ✅ **green:** 2 (MoguesEtAl2012, WBPeru2017)
  - 🟡 **yellow:** 12
  - 🔴 **red:** 12

## Detalle por ficha

### CON PDF

#### `MoguesEtAl2012` — **GREEN**
- Metadata: ✅ Confirmada (FAO ESA Working Paper 12-07)
- Cifras §6: ✅ Retornos I+D mediana 30-50% confirmada (PDF: mediana 44%, modal 40%); IRR biofortification 66-133% literal
- Notas: Único green con PDF en muestra public_spending.

#### `WBPeru2017` — **GREEN**
- Metadata: ✅ World Bank 2017, June 23, 2017
- Cifras §6: ✅ Todas literales: 3.3% crecimiento, 0.3-0.7% PIB gasto, 7.3% PIB agrícola, dualidades Costa/Sierra/Selva
- Notas: Documento robusto.

#### `OECD2015_Colombia` — **YELLOW**
- Metadata: ✅ OECD 2015 Colombia
- Cifras §6: 🟡 Ficha dice "17%" pero PDF reporta %PSE 19% para 2011-13. El 17% en PDF es otra métrica (imports ratio)
- Notas: Corregir 17→19%.

#### `WBBoliviaInnoFood2022` — **YELLOW**
- Metadata: 🟡 PDF es PID Report No PIDA34222, no PAD4912 que cita ficha
- Cifras §6: 🟡 Total proyecto ~US$351M (componentes 16.5+309.2+25.4), no exactamente US$300M
- Notas: Actualizar Report No a PIDA34222.

#### `FAO_FiscalPolicies` — **RED**
- Metadata: 🔴 Título real "Fiscal policies in agriculture and PSE **in Latin America and the Caribbean**" (no "Towards a Common Framework"); autores Diaz-Bonilla/De Salvo/Egas, NO "FAO/MAFAP"; 24pp (no 62)
- Notas: Reescribir ficha por completo.

#### `FAOCEPALIICA2023` — **RED**
- Metadata: 🔴 PDF es "Incidencia de las reformas estructurales sobre la agricultura boliviana" por Fernando Crespo Valdivia (CEDLA Serie Desarrollo Productivo N°98, diciembre 2000) — documento completamente distinto
- Notas: Re-descargar o reescribir.

#### `Fuglie2024_USDA_TFP` — **RED**
- Metadata: ✅ Correcta
- Cifras §6: 🔴 "Bolivia con crecimiento TFP positivo pero rezagado" es INVENCIÓN — Bolivia NO aparece mencionada en el reporte; cifra -0.04% anual países bajo ingreso no se localiza
- Notas: Cifra 1.1% TFP global 2011-20 sí confirmada.

#### `Gautam2022` (02_public_spending) — **RED**
- Metadata: 🔴 PDF descargado es "The Effect of Agricultural Input Subsidies on Productivity: A Meta-Analysis" por Nguyen/Russ/Triyana (WB PRWP 10399, April 2023) — NO el libro Gautam2022 Repurposing
- Notas: Duplicado con 01_systematic_reviews/Gautam2022.md (que tiene PDF correcto).

#### `IDB_Anriquez_Foster_2017` — **RED**
- Metadata: 🔴 PDF (Anriquez2016_LAC.pdf) es de Ramón López (diciembre 2004, IDB RUR-04-01) — autor único; NO Anríquez & Foster 2018
- Cifras §6: 🔴 No verificables (PDF incorrecto)
- Notas: La cifra "10pp→5% ingreso agrícola" probablemente proviene de López 2004, atribuida erróneamente.

#### `Lopez2009_PublicSpending` — **RED**
- Metadata: 🔴 PDF (Lopez2009_PublicGoods.pdf) es "Review of Public Spending to Agriculture - A joint DFID/World Bank study" por Akroyd & Smith (Oxford Policy Management, January 2007) — NO López/Galinato/Islam 2009
- Notas: Re-descargar PDF correcto.

#### `ResakssTracking` — **RED**
- Metadata: 🔴 Autores reales: Fan & Saurkar (2 autores), NO "Benin, Fan, Diao, Nin Pratt"
- Cifras §6: 🔴 "~10 países cumplían 10% al 2007" — PDF dice solo 4 (Burkina Faso, Etiopía, Malawi, Mali) por 2005
- Notas: Corregir autores y cifra.

#### `WBToolkit2010` — **RED**
- Metadata: 🔴 PDF es "Strengthening National Comprehensive Ag Public Expenditure in SSA — Expenditure Component Impact Evaluation Template ToR" (Junio 2010, programa Gates/WB para SSA) — NO el Practitioner's Toolkit WB/DFID
- Notas: Re-descargar el Toolkit real.

### SIN PDF

#### `Alston2000` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref. DOI faltante: 10.2499/0896291162rr113
- Notas: Agregar DOI.

#### `Beintema2012_ASTIGlobal` — **YELLOW**
- Metadata: ✅ Confirmada. DOI faltante: 10.2499/9780896298026
- Notas: Agregar DOI.

#### `CEDLA_Bolivia` — **YELLOW**
- Metadata: 🟡 URL CEDLA política agraria responde; título específico no se localiza en catálogo público
- Notas: Posiblemente ficha paraguas de varias publicaciones CEDLA. Clarificar referencia.

#### `Cuesta2013` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref (Food Policy 40(C):1-13)
- Notas: Convendría descargar PDF (alta relevancia Bolivia).

#### `FanHazellThorat2000` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref (AJAE 82(4):1038-1051)
- Notas: Paper canónico. HTML quarantined.

#### `LopezGalinato2007` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref (J. Public Economics 91(5-6):1071-1094)
- Notas: Paper canónico LAC.

#### `MoguesIFPRI2008` — **YELLOW**
- Metadata: 🟡 Es la versión IFPRI Research Report 160; URL funcional
- Notas: Sin DOI; máximo yellow.

#### `OECD2023_APME` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref (DOI 10.1787/b14de474-en)
- Notas: Sin PDF.

#### `Schultz1964` — **YELLOW**
- Metadata: ✅ Libro clásico Yale 1964; metadata histórica establecida
- Notas: Sin DOI (libro pre-DOI).

#### `ValdesFoster2010` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref (World Development 38(10):1362-1374)
- Notas: Sin PDF.

#### `IDB2018_AgPolicies` — **RED**
- Metadata: 🔴 DOI 10.18235/0001242 corresponde a "Politically Exposed Persons in Central American Countries" por Guillermo Jorge — NO al Agricultural Support Policies LAC 2018
- Notas: Re-verificar DOI vía Agrimonitor.

#### `IDB2023_AgPoliciesLAC` — **RED**
- Metadata: 🔴 Autores reales (Crossref): Conroy, Rondinone, De Salvo, Muñoz — NO "De Salvo, Egas, Shik" como dice ficha. Año real publicación: 2024 (agosto). DOI real: 10.18235/0013100
- Notas: Corregir autores y agregar DOI.

#### `Mogues2011` — **RED**
- Metadata: 🔴 Autor real (Crossref) en JDS 47(5):735-752: **solo Tewodaj Mogues** (autor único) — NO "Mogues, Ayele, Paulos" como dice ficha (esos están en el IFPRI RR 160 de 2008)
- Notas: Corregir autores; o vincular a MoguesIFPRI2008.

#### `Salazar2016_CRIAR` — **RED**
- Metadata: 🔴 DOI 10.18235/0000548 corresponde a "Out of the Border Labyrinth" por Volpe Martincus (comercio) — NO al paper CRIAR Bolivia. DOI real: **10.18235/0012280**; año real 2015 (no 2016); autor "Mario González" (no "González-Flores")
- Notas: Corregir DOI y año.

## Alucinaciones críticas detectadas (subset rojo)

| Ficha | Problema |
|-------|----------|
| FAO_FiscalPolicies | Título/autor/serie alucinados (PDF es Diaz-Bonilla/De Salvo/Egas LAC 2019, no FAO/MAFAP framework) |
| FAOCEPALIICA2023 | PDF descargado es "Crespo Valdivia 2000 - Reformas estructurales Bolivia", documento totalmente distinto |
| Fuglie2024_USDA_TFP | Bolivia NO aparece mencionada en el reporte — afirmación inventada |
| Gautam2022 (02) | PDF descargado es WB PRWP 10399 (Nguyen/Russ/Triyana 2023), no el libro Gautam2022 |
| IDB_Anriquez_Foster_2017 | PDF es de Ramón López 2004 (autor único) — autores y año atribuidos a Anríquez & Foster |
| Lopez2009_PublicSpending | PDF es Akroyd & Smith 2007 DFID/WB — documento distinto |
| ResakssTracking | Autores incorrectos (Fan & Saurkar, no Benin et al.); cifra países Maputo incorrecta (4 vs 10) |
| WBToolkit2010 | PDF es ToR template Gates/WB SSA 2010 — no el Practitioner's Toolkit |
| IDB2018_AgPolicies | DOI 10.18235/0001242 corresponde a publicación distinta sobre PEPs |
| IDB2023_AgPoliciesLAC | Autores fabricados (reales: Conroy/Rondinone/De Salvo/Muñoz, no De Salvo/Egas/Shik) |
| Mogues2011 | Co-autores Ayele y Paulos atribuidos al paper JDS — solo aparecen en versión IFPRI |
| Salazar2016_CRIAR | DOI corresponde a libro de Volpe Martincus sobre comercio; año real 2015 (no 2016) |
| GFPR2024_IFPRI | DOI 10.2499/9780896294417 atribuido al 2024 corresponde realmente al GFPR 2023 |
| GFPR2025_IFPRI | DOI no existe en Crossref (404) |
| MAFAP_Synthesis2013 | PDF descargado es review FAO 2011, no Synthesis 2013 |
| Stewart2015 | N inflado 4-5× (89 vs 19 estudios reales); errores en autores |
