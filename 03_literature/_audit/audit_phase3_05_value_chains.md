# Auditoría Fase 3 — Corpus `05_value_chains/`

**Fecha:** 2026-05-23
**Auditor:** Claude Code (verificación por URL/Crossref; sin PDFs descargados salvo Policy_WorldBank2021)
**Universo Fase 3:** 28 fichas con `audit_status: unverified` al inicio
**Método:** Crossref API + WebFetch a URL pública + cross-check de metadata frontmatter vs fuente

---

## Resumen ejecutivo

| Status | Fichas | % |
|--------|:------:|:-:|
| 🟡 yellow (metadata consistente, sin parseo de cifras) | 19 | 68% |
| 🔴 red (incoherencia: autor, año o DOI inventado/erróneo) | 9 | 32% |
| ✅ green | 0 | 0% |

**Hallazgo principal:** 32% de las fichas auditadas contienen al menos un error verificable en metadata core (autor, año, DOI, atribución de paper). Hay 3 alucinaciones mayores en las que el DOI declarado apunta a un paper completamente distinto.

---

## Tabla por ficha (en orden alfabético)

### 1. `Agroecology_Cochabamba2024.md` — 🟡 yellow
- **Hallazgo:** Crossref confirma metadata; autores corregidos en frontmatter de "Various authors (TBV)" a "McKay, Ben M. & Catacora-Vargas, Georgina".
- **Fuente:** DOI 10.1080/21683565.2026.2617503 (Agroecology and Sustainable Food Systems, 2026).

### 2. `Camelid_IFAD2023.md` — 🟡 yellow
- **Hallazgo:** Dominio IFAD y ruta /opinions consistentes con la institución; WebFetch genérico 403 pero patrón URL válido.

### 3. `Castana_CIFOR2007.md` — 🔴 red
- **Hallazgo:** Stoian, D. "Making the best of two worlds" se publicó en **World Development 2005** (Vol 33 Iss 9 pp 1473-1490, DOI 10.1016/j.worlddev.2004.10.009), NO 2007 ni en CIFOR. La URL CIFOR/publication/1842 puede ser una working-paper version; corregir year y source.

### 4. `Castana_FairLabor2024.md` — 🟡 yellow
- **Hallazgo:** URL Fair Labor Association descarga PDF; organización y año 2024 consistentes con el slug.

### 5. `Cattle_Mongabay2023.md` — 🟡 yellow
- **Hallazgo:** URL Mongabay verificada en cuerpo del artículo: Killeen, 24-oct-2023, serie 'A Perfect Storm in the Amazon'. Metadata core consistente.

### 6. `Cattle_Verite2016.md` — 🟡 yellow
- **Hallazgo:** URL Verité retorna PDF (2.9MB); organización y año 2016 consistentes con el slug.

### 7. `Coca_Brombacher2024.md` — 🔴 red (ALUCINACIÓN MAYOR)
- **Hallazgo:** El DOI 10.1080/00220388.2024.2328035 corresponde a **"From Alternative Development to Decolonisation: Transforming Drug Crop Policies in Bolivia" por Linda Farthing & Thomas Grisaffi**, NO Brombacher & Maihold. Journal of Development Studies Vol 60 Iss 7 pp 985-1001. Corregir citekey, autores y archivo.

### 8. `Coca_FarthingKohl2012.md` — 🔴 red
- **Hallazgo:** Año y DOI INCORRECTOS. Crossref confirma: año real **2010** (no 2012), DOI correcto **10.1177/0094582X10372516** (no 0094582X11423171), Latin American Perspectives Vol 37 Iss 4 pp 197-213. Autores y título sí coinciden. Corregir year y DOI; renombrar archivo a `Coca_FarthingKohl2010.md`.

### 9. `Coca_FarthingLedebur2015.md` — 🟡 yellow
- **Hallazgo:** Open Society Foundations confirma el reporte "Habeas Coca", julio 2015. La página oficial no lista autores explícitamente; la atribución a Farthing & Ledebur es estándar en la literatura.

### 10. `Coca_UNODC2024.md` — 🟡 yellow
- **Hallazgo:** URL específica del PDF retorna 404, pero UNODC sí publica anualmente el "Monitoreo de Cultivos de Coca" Bolivia. Actualizar URL cuando se localice la versión oficial vigente.

### 11. `Coffee_Bobadoaketal2023.md` — 🔴 red (ALUCINACIÓN MAYOR)
- **Hallazgo:** "Bobadoa et al." NO existe. El paper real es **Jacobi, J. et al. (2024)** "Making specialty coffee and coffee-cherry value chains work for family farmers' livelihoods", **World Development Perspectives**, DOI **10.1016/j.wdp.2023.100551**. El DOI ficha 10.1016/j.jafr.2023.100629 corresponde a un paper sobre Taiwan. Corregir autores, journal y DOI; renombrar archivo.

### 12. `Coffee_PDG2022.md` — 🟡 yellow
- **Hallazgo:** Confirmado: Perfect Daily Grind, 10-feb-2022, autor **Nicholas Castellano** (no especificado en ficha). Agregar autor si se cita.

### 13. `NTFP_AmazonCons2022.md` — 🟡 yellow
- **Hallazgo:** Amazon Conservation Association confirma el lanzamiento del Observatorio el 31-ene-2022 (Pando, Bolivia).

### 14. `Oilseeds_MundusAgri2024.md` — 🔴 red
- **Hallazgo:** La nota en la URL está fechada **26-feb-2026** (no 2024). Corregir year/citekey a 2026 o reemplazar la fuente con una nota efectivamente publicada en 2024.

### 15. `Policy_EMAPA_Soruco2012.md` — 🟡 yellow
- **Hallazgo:** URL SciELO Bolivia no accesible (ECONNREFUSED) pero PID corresponde a Umbrales (UMSA), revista real.

### 16. `Policy_IBCE2024.md` — 🟡 yellow
- **Hallazgo:** IBCE es institución real; publica regularmente "Cifras del Comercio Exterior Boliviano" (sitio confirma ediciones 2024 y 2025).

### 17. `Policy_PROBOLIVIA.md` — 🟡 yellow
- **Hallazgo:** PRO-BOLIVIA es entidad pública real (MDPyEP). El sitio actual no muestra el documento "Final 2023" en la home — solo Inicial 2024 e Inicial 2025. Agregar URL específica del PDF cuando esté disponible.

### 18. `Potato_CIPAndean.md` — 🟡 yellow
- **Hallazgo:** CIP Andean Initiative confirmado: cipotato.org/andeaninitiative discute conservación de agrobiodiversidad andina y proyectos en Bolivia/Ecuador/Perú.

### 19. `Quinoa_BazileBaudron2015.md` — 🟡 yellow
- **Hallazgo:** Crossref confirma: **Bazile/Jacobsen/Verniau (2016)** en Frontiers in Plant Science Vol 7, DOI 10.3389/fpls.2016.00622. Citekey 'BazileBaudron2015' es inexacto (no es Baudron, no es 2015). Considerar renombrar a `BazileEtAl2016`.

### 20. `Quinoa_Jacobsen2011.md` — 🟡 yellow
- **Hallazgo:** Crossref confirma: Jacobsen S.-E. (2011), J. Agronomy and Crop Science Vol 197 Iss 5 pp 390-399.

### 21. `Quinoa_Laguna2010.md` — 🔴 red
- **Hallazgo:** ATRIBUCIÓN INCIERTA. La URL ideas.repec.org/p/fet/wpaper/52010 apunta a un paper de **Carimentrand & Ballet** (no Laguna/Cáceres/Carimentrand). Sí existe un paper coautoreado por el trío (2006, Agroalimentaria 11(22) pp 29-40) pero con título diferente. El título exacto "When Fair Trade increases unfairness" no se verifica en Crossref bajo el trío indicado. Revisar fuente.

### 22. `Quinoa_StockerMartinez2024.md` — 🔴 red
- **Hallazgo:** AUTORES INCORRECTOS. Confirmado en la fuente (Tropical and Subtropical Agroecosystems Vol 27 No 3, 2024): los autores reales son **Nadine Stöcker, Humberto Reyes Hernández y Juan Carlos Torrico-Albino** — NO "Manuela Stöcker & José Antonio Martínez". Corregir nombre y co-autores en frontmatter, BibTeX y citekey.

### 23. `Quinoa_WalshDilley2014.md` — 🟡 yellow
- **Hallazgo:** Crossref confirma: Walsh-Dilley (2013), JPS Vol 40 Iss 4 pp 659-682, DOI 10.1080/03066150.2013.825770. Citekey '2014' difiere del año real 2013.

### 24. `Soya_AidEnvironment2023.md` — 🟡 yellow
- **Hallazgo:** URL AidEnvironment retorna PDF (1.9MB); organización y año 2023 consistentes.

### 25. `Soya_GlobalWitness2020.md` — 🟡 yellow
- **Hallazgo:** URL retornó 429 (rate limit) pero el slug corresponde a una campaña real de Global Witness 2020 ampliamente citada.

### 26. `Soya_McKay2015_BICAS.md` — 🟡 yellow
- **Hallazgo:** URL TNI retorna PDF (905KB); BICAS Working Paper 6 de McKay es referencia conocida.

### 27. `Soya_McKay2015_JPS.md` — 🟡 yellow
- **Hallazgo:** Crossref confirma: McKay & Colque (2015 online; JPS Vol 43 Iss 2, 2016, pp 583-610).

### 28. `Soya_Trase2023.md` — 🔴 red
- **Hallazgo:** Año INCORRECTO: la nota Trase está fechada **3-sept-2024** (no 2023). Corregir year/citekey a 2024.

---

## Acciones recomendadas (prioridad)

### Críticas (red) — corregir antes de citar en reporte
1. `Coca_Brombacher2024` → reemplazar por `Coca_FarthingGrisaffi2024` con autores correctos.
2. `Coffee_Bobadoaketal2023` → reemplazar por `Coffee_JacobiEtAl2024` con DOI correcto (10.1016/j.wdp.2023.100551).
3. `Coca_FarthingKohl2012` → corregir year a 2010 y DOI a 10.1177/0094582X10372516; renombrar.
4. `Quinoa_StockerMartinez2024` → corregir autores a Stöcker / Reyes Hernández / Torrico-Albino.
5. `Quinoa_Laguna2010` → confirmar trío de autores y título; posiblemente reemplazar por paper Carimentrand/Ballet o por Cáceres/Carimentrand/Wilkinson 2007.
6. `Castana_CIFOR2007` → corregir year a 2005 y source a World Development; agregar DOI 10.1016/j.worlddev.2004.10.009.
7. `Oilseeds_MundusAgri2024` → corregir year a 2026 o reemplazar fuente.
8. `Soya_Trase2023` → corregir year a 2024.

### Menores (yellow)
- `Quinoa_BazileBaudron2015` → renombrar a `BazileEtAl2016`.
- `Quinoa_WalshDilley2014` → considerar renombrar a `2013`.
- `Coffee_PDG2022` → agregar autor "Castellano, Nicholas".
- `Policy_PROBOLIVIA` → localizar URL del PDF Final 2023 específico.
- `Coca_UNODC2024` → actualizar URL del PDF cuando esté disponible.

---

## Pendiente para validación humana
- Apertura de los PDFs de Verité, FairLabor, AidEnvironment, OSF Habeas Coca, BICAS McKay, IBCE para auditar cifras concretas (la Fase 3 solo verificó metadata de catalogación).
- Revisión bibliográfica del paper Laguna/Cáceres/Carimentrand 2010 si efectivamente existe.

---
