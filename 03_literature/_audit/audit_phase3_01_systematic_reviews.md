# Auditoría Fase 3 — 01_systematic_reviews

**Fecha:** 2026-05-23
**Auditor:** Claude Code (Auto Mode)
**Alcance:** Fichas con `audit_status: unverified` en `01_systematic_reviews/`

## Resumen

- Fichas auditadas: **14**
- Con PDF disponible: 7
- Sin PDF (verificación vía Crossref/Web): 7
- Estados finales:
  - ✅ **green:** 1 (IPCC2022_AR6_Chapter5)
  - 🟡 **yellow:** 9
  - 🔴 **red:** 4

## Detalle por ficha

### `IPCC2022_AR6_Chapter5` — **GREEN**
- Metadata: ✅ Confirmada en portada PDF
- Cifras §6: ✅ Verificadas (-21% TFP global, 10% pérdida área apta para 2050, 31-34% para 2100, citando Ortiz-Bobea et al. 2021)
- Notas: Único caso con todo verificado en muestra de Fase 3.

### `Alston2011` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref (DOI 10.1093/ajae/aar044)
- Cifras §6: 🟡 No verificables sin PDF
- Notas: Sin PDF disponible; metadata 100% correcta.

### `Challinor2014` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref (issue 4 faltante en ficha)
- Cifras §6: 🟡 No verificables sin PDF (PDF previo era HTML)
- Notas: Minor — añadir issue 4.

### `FosterRosenzweig2010` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref
- Cifras §6: 🟡 No verificables sin PDF
- Notas: Annual Review article 2(1):395-424.

### `Hurley2014` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref (AJAE 96(5):1492-1504)
- Cifras §6: 🟡 No verificables sin PDF
- Notas: Sin PDF.

### `JayneMason2018` — **YELLOW**
- Metadata: ✅ Confirmada vía Crossref (Food Policy 75:1-14)
- Cifras §6: 🟡 No verificables (HTML quarantined)
- Notas: Sin PDF.

### `MasonDCroz2022` — **YELLOW**
- Metadata: 🟡 Año real publicación online es 2025 (no 2024 ni 2022 del citekey)
- Cifras §6: 🟡 Cifras específicas '<5% subsidios FVL', '3× más caros', 'cientos de miles' no rastreables literalmente al PDF
- Notas: Contenido conceptual sí coincide. Corregir año a 2025.

### `SuriUdry2022` — **YELLOW**
- Metadata: ✅ JEP 36(1):33-56
- Cifras §6: 🟡 Cifra '5-10× heterogeneidad fertilizante' no literal en PDF (sí el concepto)
- Notas: Suavizar la cifra del rango sin valor numérico.

### `WaddingtonSnilstveit2014` — **YELLOW**
- Metadata: 🟡 PDF descargado es el **Summary** 3ie por Waddington & White (2 autores), no el SR Campbell completo (7 autores, 335 pp) que cita la ficha
- Cifras §6: 🟡 13% yield y 19% income confirmados; SMDs 0.20-0.30 y 0.50 no aparecen en el resumen
- Notas: Descargar SR completo Campbell o ajustar al Summary.

### `WorldBank2024_RepurposingSupport` — **YELLOW**
- Metadata: ✅ WB 2024 Toolkit confirmado
- Cifras §6: 🟡 USD 600B confirmada; '<20% bien dirigido' y '1-3% PIB ahorro' no rastreables literalmente
- Notas: Cifras derivativas de Gautam2022, no del propio WB2024.

### `GFPR2024_IFPRI` — **RED**
- Metadata: 🔴 DOI 10.2499/9780896294417 corresponde a GFPR 2023 (no 2024)
- Notas: DOI incorrecto. PDF era HTML (quarantined).

### `GFPR2025_IFPRI` — **RED**
- Metadata: 🔴 DOI 10.2499/9780896294943 retorna 404 en Crossref — DOI inexistente
- Notas: PDF era HTML (quarantined). GFPR 2025 puede aún no estar en Crossref o DOI es invención.

### `MAFAP_Synthesis2013` — **RED**
- Metadata: 🔴 PDF descargado NO es Synthesis 2013. Es "A review of relevant policy analysis work in Africa" por Balié & Maetz (FAO Draft January 2011)
- Notas: PDF mismatch crítico.

### `Stewart2015` — **RED**
- Metadata: 🔴 Título PDF es "wealth and food security" (no "economic outcomes"); co-autora real es Nicola (no Nicholas) Randall; falta Shannon Rafferty
- Cifras §6: 🔴 **N real es 19 estudios** (32 papers, 4,493 participantes), NO 89 como dice ficha (error 4-5×)
- Notas: Snippet ES/EN repite el 89 falso.

## Alucinaciones críticas detectadas (subset rojo)

| Ficha | Problema |
|-------|----------|
| GFPR2024_IFPRI | DOI 10.2499/9780896294417 atribuido a 2024 corresponde realmente a GFPR 2023 |
| GFPR2025_IFPRI | DOI 10.2499/9780896294943 no existe en Crossref (404) |
| MAFAP_Synthesis2013 | PDF descargado es review FAO 2011 de Balié & Maetz, no el Synthesis 2013 |
| Stewart2015 | N inflado 4-5× (89 vs 19 estudios reales); título y autora con errores |
