# Audit Phase 3 — Folder 10 (Macro, Growth, Poverty)

**Fecha:** 2026-05-23
**Auditor:** Claude (asistente APER)
**Fichas auditadas en Fase 3:** 13 (todas las que estaban `unverified`)
**Total fichas en carpeta:** 23

## Resumen cuantitativo (todas las fichas, todos los phases)

| Status | # |
|---|---|
| green | 3 |
| yellow | 13 |
| red | 7 |
| **Total** | **23** |

## Fichas marcadas en Fase 3 (este audit)

### Verde (verificadas con PDF, sin errores sustantivos)

- **Andersen2002_RuralUrbanMigration** — el PDF en disco bajo el hermano-citekey (Andersen_Faris2002_NaturalGas) corresponde EN REALIDAD a este single-author Andersen Feb 2002 IISEC. Recomendación: mover archivo.

### Amarillo (sin PDF, o PDF con cifras que no pudieron verificarse en este audit)

12 fichas. Subgrupos:
- **Sin PDF / portales**: CEDLA2021, CEPAL2024, IBCE2024, INE2024_EH2023, MEFP2023_MESCP, Wanderley2014, WorldBank2023_CPF (3 prioridades sí verificadas via press release).
- **Con PDF pero cifras dudosas**: IDB2022_CountryStrategy (3 ejes textuales OK, pero cartera USD 90M/25M no coincide con PDF), NRGI_LasaAresti2016 (44%/67% IDH/regalías no aparecen literalmente; PDF dice 66.9% IDH a municipios, ~60% regalías a depts. productores), Vargas_Garriga2015 (pobreza 60→39% no coincide con PDF que reporta 87→61% en pobreza moderada 2000-2012).

### **Rojo (errores críticos para Cap 1 del APER)**

1. **ASTI2023_AgRandD_Factsheet** — **CIFRA CRÍTICA INCORRECTA**: la ficha dice "Bolivia invierte 0.3-0.4% del PIB agro en I+D". El PDF reporta textualmente que el ratio **CAYÓ DE 1.0% A 0.5% entre 2015-2020** ("halved from 1.0 to 0.5 percent during 2015–2020"). Es una métrica clave para Cap 1/Cap 3 del APER y debe corregirse antes de cualquier cita. Autores reales: Gert-Jan Stads & Luis de los Santos (no listados).
2. **Andersen_Faris2002_NaturalGas** — PDF DESCARGADO ES INCORRECTO. El archivo bajo este citekey corresponde a 'Rural-Urban Migration in Bolivia' (Andersen sola, no Andersen & Faris). Cifras "+2pp por 3 años" del resumen ficha no verificables. Buscar PDF correcto (CID Harvard / Andean Competitiveness) y mover el actual a Andersen2002_RuralUrbanMigration.pdf.
3. **Andersen2024_UnfinishedMigration** — ERRORES METADATA CRÍTICOS: (a) año real **2023** (no 2024); (b) primer autor es **Guzmán Prudencio**, NO Andersen (debería citarse Guzmán Prudencio et al. 2023); (c) faltan coautores Zeballos y Romecín Duarte; (d) título completo incluye subtítulo "An analysis based on household level electricity consumption data"; (e) serie correcta: SDSN Bolivia WP No 3/2023.

(Las fichas red previas de Fase 2 — IMF2025_ArticleIV2024, IMF2025_ArticleIV2025, UDAPE2025_BrechasSociales, WorldBank2024_PovertyEquityBrief — siguen en rojo desde antes.)

## Hallazgos sistemáticos críticos para Cap 1 del APER

1. **Cifras macro Bolivia con problemas detectados**:
   - Intensidad I+D agro: ficha dice 0.3-0.4% PIBA → real ASTI 2023 es **caída 1.0% (2015) a 0.5% (2020)** del PIBA.
   - Pobreza 60→39% (Vargas-Garriga): el PDF reporta 87→61% moderada; la línea/serie de la ficha debe re-citarse contra fuente correcta (WB$5.5/día u otra).
   - IDH/regalías subnacionales: 44%/67% no respaldados por PDF NRGI; usar % específicos de Ley 3058/2005 cuando se cite.

2. **Autoría incorrecta en al menos 2 fichas críticas** (Andersen_Faris2002, Andersen2024). Patrón Fase 2 replicado.

3. **PDFs descargados que no corresponden al citekey** (Andersen_Faris2002): hay confusión entre fichas. Aconseja auditoría rápida de coincidencia citekey ↔ PDF en todas las fichas con pdf_downloaded:true.

## Recomendaciones operativas

- **PRIORIDAD ALTA**: corregir ficha ASTI2023 antes de usarla en Cap 1 del APER. Es una de las cifras más visibles del diagnóstico de I+D agropecuario boliviano.
- **Mover** `pdfs/10_macro_growth_poverty/Andersen_Faris2002_NaturalGas.pdf` → `Andersen2002_RuralUrbanMigration.pdf` y descargar el verdadero WP de gas natural de inesad.edu.bo o CID Harvard.
- **Renombrar citekey y autoría** de Andersen2024_UnfinishedMigration → GuzmanPrudencioEtAl2023_UnfinishedMigration.
- **Verificar cifras Vargas-Garriga 2015** (Tabla A1) antes de citar.
- **Verificar fórmula IDH/regalías** en Ley 3058/2005 antes de citar el 44%/67%.
- **Descargar PDFs** prioritarios: WorldBank2023_CPF (cartera USD 993M), CEPAL2024 (1.7% Bolivia), IBCE2024 (exportaciones USD 9,000M), MEFP2023_MESCP (cifras oficiales del modelo).
