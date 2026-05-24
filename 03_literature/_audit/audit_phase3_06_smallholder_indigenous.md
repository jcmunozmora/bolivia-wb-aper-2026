# Auditoría Fase 3 — Corpus `06_smallholder_indigenous/`

**Fecha:** 2026-05-23
**Auditor:** Claude Code (verificación por URL/Crossref; PDFs ya auditados en Fase 2 quedan fuera de este alcance)
**Universo Fase 3:** 15 fichas con `audit_status: unverified` al inicio
**Método:** Crossref API + WebFetch a URL pública + cross-check de metadata frontmatter vs fuente

---

## Resumen ejecutivo

| Status | Fichas | % |
|--------|:------:|:-:|
| 🟡 yellow (metadata consistente, sin parseo de cifras) | 13 | 87% |
| 🔴 red (incoherencia mayor: DOI o atribución erróneos) | 2 | 13% |
| ✅ green | 0 | 0% |

**Hallazgo principal:** 13% de las fichas auditadas tienen errores verificables en metadata core. Los problemas detectados son DOI erróneo (apunta a otro libro) y URL/atribución inconsistente entre el cuaderno 2014 y la publicación 2021 de CIPCA (posible duplicación o confusión entre publicaciones).

---

## Tabla por ficha (en orden alfabético)

### 1. `Albo1991.md` — 🟡 yellow
- **Hallazgo:** No verificable vía Crossref (Revista Andina del CBC Cusco no está indexada). "El retorno del indio" (Albó 1991) es referencia clásica ampliamente citada en estudios bolivianos; existe. No se puede verificar volumen/páginas exactos sin acceso al archivo del CBC.

### 2. `Bebbington1997.md` — 🟡 yellow
- **Hallazgo:** Crossref confirma: Bebbington (1997) "Reinventing NGOs and Rethinking Alternatives in the Andes", ANNALS Vol 554 Iss 1 pp 117-135, DOI 10.1177/0002716297554001008. **Acción:** agregar DOI a frontmatter.

### 3. `Bebbington2001.md` — 🟡 yellow
- **Hallazgo:** Crossref confirma: Bebbington (2001), Ecumene Vol 8 Iss 4 pp 414-436, DOI 10.1177/096746080100800403. **Nota:** Source debería ser "Ecumene" (no "Cultural Geographies"); fueron diferentes nombres del journal en distintas épocas.

### 4. `CIPCA2014.md` — 🔴 red
- **Hallazgo:** URL en frontmatter apunta a la publicación 2021 de CIPCA (Tito Velarde & Wanderley 2021), NO al cuaderno 2014 de Vargas Vega. O bien (a) el autor real es Tito/Wanderley 2021 y debe corregirse year/authors, o (b) la URL está mal y el cuaderno 2014 sí existe pero hay que localizar el link correcto. **Acción:** revisar posible duplicación con `CIPCA2021.md`.

### 5. `ColqueEtAl2015.md` — 🟡 yellow
- **Hallazgo:** Fundación TIERRA es institución real. "Segunda reforma agraria: Una historia que incomoda" por Colque/Tinta/Sanjinés es publicación conocida. URL ftierra.org retornó 403/429 al WebFetch pero el dominio es válido. **Acción:** agregar URL específica del PDF cuando se localice.

### 6. `DeereLeon2001.md` — 🟡 yellow
- **Hallazgo:** Confirmado en bibliografías indexadas (Crossref): Deere & León (2001) "Empowering Women: Land and Property Rights in Latin America", University of Pittsburgh Press. DOI asociado 10.2307/j.ctt5hjpf6 (puede ser de la edición JSTOR).

### 7. `Empoderar_PARIII.md` — 🟡 yellow
- **Hallazgo:** MDRyT (ruralytierras.gob.bo) confirmado como institución real rectora del desarrollo rural. URL específica del PDF retorna 403 al WebFetch pero el patrón es consistente con la práctica del ministerio. PAR III es proyecto WB real.

### 8. `Gustafson2020.md` — 🔴 red
- **Hallazgo:** DOI INCORRECTO. El DOI registrado en ficha (10.1215/9781478012702) resuelve a "The World Computer" de Jonathan Beller (2021), NO al libro de Gustafson. El DOI correcto para "Bolivia in the Age of Gas" (Duke UP, sept 2020) es **10.1215/9781478012528**. **Acción:** corregir DOI.

### 9. `HinojosaEtAl2015.md` — 🟡 yellow
- **Hallazgo:** Crossref confirma DOI 10.1016/j.worlddev.2014.12.016. **CORRECCIONES en authors:** (1) "Cortés, Guido" → "Cortez, Guido"; (2) falta co-autora **Denise Humphreys Bebbington**; (3) "Karsten Hennermann" → "Karl Hennermann".

### 10. `IADB_Agro.md` — 🟡 yellow
- **Hallazgo:** URL publications.iadb.org retorna 403 al WebFetch pero el dominio y patrón de slug son consistentes con el repositorio oficial del BID.

### 11. `IFAD_ACCESOS.md` — 🟡 yellow
- **Hallazgo:** URL ifad.org/en/web/operations retorna 403 al WebFetch pero el ID de proyecto 1100001598 es el formato estándar de IFAD; ACCESOS es proyecto real.

### 12. `IFAD_ACCESOSRURAL.md` — 🟡 yellow
- **Hallazgo:** URL ifad.org retorna 403 pero el formato del slug es consistente con el patrón estándar de documentos IFAD (Bolivia ACCESOS Rural Project Design Report Oct 2019).

### 13. `KayAkramLodhi2010.md` — 🟡 yellow
- **Hallazgo:** Crossref confirma: Akram-Lodhi & Kay (2010), JPS Vol 37 Iss 2 pp 255-284, DOI 10.1080/03066151003594906. **NOTA:** orden de autores en Crossref es **Akram-Lodhi (primero) y Kay (segundo)** — invertido respecto al citekey. Verificar contra PDF original si interesa para citación bibliográfica precisa.

### 14. `Pacheco2006.md` — 🟡 yellow
- **Hallazgo:** Crossref confirma: Pacheco (2006), Land Use Policy Vol 23 Iss 3 pp 205-225, DOI 10.1016/j.landusepol.2004.09.004. Metadata consistente.

### 15. `Postero2017.md` — 🟡 yellow
- **Hallazgo:** Confirmado: Postero (2017) UC Press (Luminos open access series), ISBN 9780520294035, DOI **10.1525/luminos.31**. **Acción:** agregar DOI a frontmatter.

---

## Acciones recomendadas (prioridad)

### Críticas (red) — corregir antes de citar en reporte
1. `Gustafson2020` → corregir DOI a 10.1215/9781478012528.
2. `CIPCA2014` → resolver duplicación/confusión con `CIPCA2021.md`; verificar si el cuaderno 2014 de Vargas Vega existe como publicación separada.

### Menores (yellow) — mejoras de metadata
- `Bebbington1997` → agregar DOI 10.1177/0002716297554001008.
- `Bebbington2001` → corregir source de "Cultural Geographies" a "Ecumene".
- `HinojosaEtAl2015` → corregir nombres (Cortez, Humphreys Bebbington, Karl Hennermann).
- `KayAkramLodhi2010` → verificar orden de autores en citas bibliográficas.
- `Postero2017` → agregar DOI 10.1525/luminos.31.
- `ColqueEtAl2015`, `IADB_Agro`, `IFAD_ACCESOS`, `IFAD_ACCESOSRURAL`, `Empoderar_PARIII` → localizar URLs específicas de los PDFs.

---

## Pendiente para validación humana
- Apertura de los PDFs en `pdfs/06_smallholder_indigenous/` no auditados aún (Albo, Bebbington, ColqueEtAl, etc.) — Fase 4.
- Resolver caso CIPCA2014 vs CIPCA2021 (¿son publicaciones distintas o duplicación?).
- Verificar bibliográficamente Albó 1991 contra el archivo del CBC Cusco.

---
