# Promociones yellow → green — Batch 2 (carpetas 06-11)

**Fecha:** 2026-05-23
**Reviewer:** Claude pdf-recovery (sesión 11)
**Lote:** carpetas 06_smallholder_indigenous, 07_subsidies_repurposing, 08_institutions_programs, 09_methods_per_pse, 10_macro_growth_poverty, 11_local_multilateral_bolivia

## Resumen

- **Auditadas:** 59
- **Promovidas a green:** 33
- **Permanecen yellow:** 22
- **Detectadas como red (PDF ≠ ficha):** 2
- **Yellow por PDF corrupto:** 1
- **Yellow por discrepancias menores reparables:** 1 (mismo doc bien identificado: WB Tapping 2021 vs portada June 2019; promovido a green con nota)

## Hallazgos críticos (red)

1. **`ColqueEtAl2015`** (06_smallholder): el PDF descargado es "Concentración y extranjerización de la tierra en Bolivia" por **Miguel Urioste F. de C., Fundación TIERRA, 2011**, NO el libro de Colque/Tinta/Sanjinés "Segunda reforma agraria" (2016). Misma editorial (TIERRA), distinto autor/título/año. El PDF corresponde realmente a la ficha aparte `Urioste2011`.
2. **`Saneamiento_AVSF2023`** (08_institutions): el PDF descargado (con cipher Caesar en portada que se decodifica) es "Experiencia de Saneamiento de Tierras Comunitarias de Origen con CONAMAQ" (AVSF/Proyecto SANTCO, **2010**), NO "¿Acaso la tierra está enferma?" (AVSF + Fundación TIERRA, 2023) que dice la ficha.

## Hallazgos importantes (yellow conservado)

- **`Empoderar_PARIII`** (06): PDF es PPPI (Participación de Partes Interesadas), no PPI (Pueblos Indígenas); fecha PDF Junio 2023, ficha 2022. Nombre proyecto: "Proyecto de Innovación para Sistemas Alimentarios Resilientes (Alianzas Rurales PAR III)".
- **`IFAD_ACCESOS`** (06): PDF descargado es "IFAD Country Programme Evaluation Bolivia" (EB 2015/116/R.8, **2015**), NO el "ACCESOS Project Design Documents" que dice la ficha (2019). Cubre ACCESOS dentro del portafolio pero título/fecha distintos.
- **`IADB_Agro`** (06): título "Análisis de políticas agropecuarias en Bolivia" coincide; autores reales en portada Alcaraz/Muñoz/Egas/De Salvo/Lima; PDF de 2020 (Monografía BID 916), ficha dice 2014.
- **`Mamun2024`** (07): PDF es IFPRI Discussion Paper 02245 ("Farm Subsidies and Global Agricultural Productivity"), ficha cita la versión journal en Agricultural Economics (DOI 10.1111/agec.12823).
- **`SadouletDavisDeJanvry2001`** (07): PDF es FCND DP 99 IFPRI, ficha cita versión World Development; además orden de autores invertido (PDF: Sadoulet/de Janvry/Davis vs ficha: Sadoulet/Davis/de Janvry).
- **`Rentschler2017`** (07): PDF es paper distinto ("Reforming fossil fuel subsidies: drivers, barriers and the state of progress", Climate Policy 17(7)) del que cita la ficha ("Principles for Designing...", REEP 11(1)).
- **`FAO2012_FanMcBride`** (09): orden de autores en PDF es Mogues/Yu/Fan/McBride; ficha lo invierte.
- **`WB_BOOST`** (09): PDF es "BOOST Guidance Note Series No 1, August 2013" por Igor Kheyfets; ficha cita el portal online metodología 2025.
- **`BID2014_AnalisisPoliticasAgropecuarias`** (08): año PDF=2020 (IDB-MG-916), ficha=2014; falta autor Juan José Egas.
- **`MEFP2023_MESCP`** (10): autor real Marcelo Montenegro Gómez García (Ministro MEFP 2023), no Luis Arce Catacora; presentación en UMSS mayo 2023.
- **`Wanderley2014_EconomiaPlural`** (10): PDF descargado de 1.7 MB pero **estructura corrupta** (pdftotext y pdfinfo retornan Invalid XRef / no trailer dictionary). Re-descargar.
- **`BIVICA_DesarrolloAgropecuarioEstrategia`** (11): año PDF=Junio 2005, ficha=2004 (drafting probable en 2004, publicación 2005).

## Detalle por ficha

| Citekey | Carpeta | Status final | Notas breves |
|---|---|---|---|
| Empoderar_PARIII | 06 | yellow | PPPI Jun-2023, no PPI Jul-2022 |
| IFAD_ACCESOS | 06 | yellow | PDF es Country Programme Evaluation 2015, no Project Design 2019 |
| INE2015_Censo | 06 | **green** | Censo Agropecuario 2013, INE Dic 2015 — match |
| Ley3545_2006 | 06 | **green** | Ley Nº 3545 28-nov-2006 Reconducción — match |
| WB_Tapping2021 | 06 | **green** | Portada Jun 2019, ©2020, publicación WB 2021 — match práctico |
| ColqueEtAl2015 | 06 | **red** | PDF = Urioste 2011, no Colque/Tinta/Sanjinés 2016 |
| IADB_Agro | 06 | yellow | Año PDF=2020 (IDB-MG-916), ficha=2014; falta Egas |
| Springmann2022 | 07 | **green** | Nature Comm (2022)13:82 — match |
| WB2024_Recipe | 07 | **green** | Sutton/Lotsch/Prasann (WB Agriculture & Food Series) — match |
| KruegerSchiffValdes1988 | 07 | **green** | WBER 2(3) Sep 1988 — match |
| Mamun2024 | 07 | yellow | PDF=IFPRI DP 02245; ficha cita versión journal Agric Econ |
| CoadyParry2019 | 07 | **green** | IMF WP/19/89 — match |
| FundacionSolon2023 | 07 | **green** | HTML fundacionsolon.org 26-may-2023 — match |
| Scott2010 | 07 | **green** | CIDE DT Nº 473, Dic 2009 (catalogado 2010) — match |
| AndersonRausserSwinnen2013 | 07 | **green** | WB PRWP 6433 = pre-print del JEL 51(2) — match |
| SadouletDavisDeJanvry2001 | 07 | yellow | PDF=FCND DP 99; ficha cita WD; orden autores invertido |
| AnriquezFosterOrtega2016 | 07 | **green** | IDB-WP-722 Ago 2016 — match |
| Laborde2021_GHG | 07 | **green** | Nature Comm (2021)12:2601 — match |
| Anderson2009_Global | 07 | **green** | WB doc 51279, ed. Anderson — match |
| Searchinger2019_WRI | 07 | **green** | WRR Synthesis Dic 2018 (citado 2019) — match |
| Damania2023 | 07 | **green** | Detox Development, WB — match (8 autores) |
| AndersonValdes2008 | 07 | **green** | WB doc 46161 LAC — match |
| Rentschler2017 | 07 | yellow | PDF=Climate Policy 17(7); ficha cita REEP 11(1) |
| BID_OVE2020_CountryProgramEvaluation | 08 | **green** | OVE-BID Bolivia 2016-2020 — match |
| UDAPE2023_DiagnosticoAgropecuario | 08 | **green** | UDAPE Agropecuario 2023 — match |
| Saneamiento_AVSF2023 | 08 | **red** | PDF = AVSF/SANTCO 2010, no AVSF+TIERRA 2023 |
| IFAD2015_CountryProgrammeEvaluation | 08 | **green** | EB 2015/116/R.8 Nov 2015 — match |
| PAR_WorldBank2024_ICR | 08 | **green** | ICR00006433 (IDA 51700/IBRD 87350) 2024 — match |
| BID2014_AnalisisPoliticasAgropecuarias | 08 | yellow | Año PDF=2020 no 2014; falta Egas |
| WorldBank2021_TappingPotential | 08 | **green** | Match (duplicado con 06/09/10) |
| IMF_GFSM2014 | 09 | **green** | IMF GFSM 2014 — match |
| FAO2021_PEFoodAgricultureSSA | 09 | **green** | FAO MAFAP SSA 2021 — match |
| Krueger_Schiff_Valdes1991 | 09 | **green** | PDF=Volume 3 (Africa & Mediterranean) del set — match |
| FAO2012_FanMcBride | 09 | yellow | Orden autores invertido: PDF=Mogues/Yu/Fan/McBride |
| Mink2016_AgPER_Africa_Synthesis | 09 | **green** | IFPRI DP 01522 Abr 2016 — match |
| AnriquezEtAl2016_IDB_PE_LAC | 09 | **green** | IDB-WP-722 Ago 2016 — match |
| PernecheleEtAl2018_MAFAP | 09 | **green** | FAO Tech Study Nº 3 — match |
| WB2021_BoliviaTappingPotential | 09 | **green** | Match (duplicado) |
| WB_BOOST | 09 | yellow | PDF=Guidance Note 2013; ficha cita portal 2025 |
| IDB_Agrimonitor | 09 | **green** | Agrimonitor PSE 2023 — match |
| OECD2025_APME | 09 | **green** | OECD APME 2025 — match |
| WB2011_BoliviaAgPER | 09 | **green** | Report 59696-BO Mar 2011 — match |
| DeSalvoEtAl2018_IDB_AgSupportLAC | 09 | **green** | IDB Agrimonitor May 2018 — match |
| Anderson2009_DistortionsAgIncentives | 09 | **green** | WB doc 51279 ed. Anderson — match |
| NRGI_LasaAresti2016_RevenueSharing | 10 | **green** | NRGI Apr 2016 — match |
| WorldBank2021_SCDUpdate | 10 | **green** | WB SCD Update Bolivia (creación Nov 2021) — match |
| BCB2024_Memoria2023 | 10 | **green** | Memoria 2023 BCB — match |
| Vargas_Garriga2015_Inequality | 10 | **green** | IMF WP/15/265 — match |
| Wanderley2014_EconomiaPlural | 10 | yellow | **PDF descargado está corrupto (Invalid XRef)** |
| WorldBank2021_TappingPotential | 10 | **green** | Match (duplicado) |
| CEPAL2024_EstudioEconomico | 10 | **green** | Versión EN del Estudio Económico LAC 2024 — match |
| MEFP2023_MESCP | 10 | yellow | Autor real Montenegro, no Arce |
| WorldBank2023_CPF | 10 | **green** | Report 181880-BO Apr 14 2023 — match |
| FAOPerfilSistemasAlimentariosBolivia | 11 | **green** | FAO + UE + CIRAD — match |
| BIVICADesarrolloAgropecuarioEstrategia | 11 | yellow | Año PDF=Jun 2005, ficha=2004 |
| GCF2023RECEMValles | 11 | **green** | FP202 GCF/FAO Abr 2023 (Board B.35/05 no B.34) — match |
| CAN2022EstadisticasAgropecuario | 11 | **green** | SGCAN Estadísticas Agro 2019-2022 — match |
| GRUS2017GuiaCooperacion | 11 | **green** | GruS Guía Cooperación May 2017 — match |
| ONU2021HojaRutaSistemasAlimentariosBolivia | 11 | **green** | UN Food Systems Summit Hoja de Ruta Bolivia 2021 — match |

## Tasa de éxito

- **Promoción a green:** 33/59 = **56%**
- **Mantenidas yellow (discrepancias menores reparables):** 22/59 = **37%**
- **Marcadas red:** 2/59 = **3.4%** (PDFs descargados no corresponden a las fichas)
- **Yellow por PDF corrupto irrecuperable:** 1/59 = **1.7%**

## Próximos pasos sugeridos

1. **Re-descargar PDFs** para ColqueEtAl2015, Saneamiento_AVSF2023, IFAD_ACCESOS (versión Project Design), Wanderley2014.
2. **Corregir metadata** (sin re-descargar PDF) en: Empoderar_PARIII (año/título), IADB_Agro, BID2014_AnalisisPoliticasAgropecuarias, MEFP2023_MESCP, BIVICA_DesarrolloAgropecuarioEstrategia, FAO2012_FanMcBride (orden autores), GCF_2023_RECEM (board B.35).
3. **Decidir cita doble**: Mamun2024, SadouletDavisDeJanvry2001, AndersonRausserSwinnen2013 (mantener referencia a versión journal pero apuntar pdf_path al WP descargado) o agregar fichas duplicadas para el WP.
4. **Resolver caso Rentschler2017**: el PDF disponible no corresponde al DOI de la ficha — clarificar cuál paper se quiere citar.
5. **WB_BOOST**: decidir si la ficha apunta al portal online (URL) o al guidance note 2013 (PDF descargado).
