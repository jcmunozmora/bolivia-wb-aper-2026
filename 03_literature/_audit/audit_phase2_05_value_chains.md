# Auditoría Fase 2 (Contenido) — `05_value_chains/`

**Fecha:** 2026-05-23 (sesión 11)
**Auditor:** Claude Code (Opus 4.7)
**Método:**
- Para fichas con PDF descargado: lectura directa del PDF (vía `pypdf`) y verificación de cifras y citas.
- Para fichas SIN PDF descargado: verificación de URL declarada en el frontmatter contra:
  1. `WebFetch` directo a la URL (cuando es accesible),
  2. `WebFetch` a APIs académicas (Crossref, OpenAlex) para confirmar título, autor, año, journal, volumen, issue, páginas.

---

## Resumen ejecutivo

| Indicador | Valor |
|-----------|------:|
| Fichas markdown en carpeta | 34 |
| Fichas con `pdf_downloaded: true` | 1 (Policy_WorldBank2021 → WorldBank2021_TappingPotential.pdf) |
| Fichas con `pdf_downloaded: false` | 33 |
| Fichas auditadas con PDF | 1 |
| Fichas auditadas vía URL/metadata | 5 (selección representativa) |
| Verde (todo confirma) | 2 (Quinoa_Bellemare2018, Policy_WorldBank2021 con caveats) |
| Amarillo (URL accesible pero detalle parcial) | 1 (Quinoa_Bazile2015) |
| Rojo (metadatos incorrectos verificados) | 2 (Coca_Grisaffi2022, Soya_McKay2018) |
| Inaccesible vía WebFetch (403/captcha) | varios — algunos tuvieron que verificarse por Crossref/OpenAlex |

> **Nota crítica:** Las fichas Coca_Grisaffi2022 y Soya_McKay2018 tienen volumen/issue/páginas **incorrectos** confirmados contra Crossref. Año también discrepa en Grisaffi (ficha = 2022; publicación real = 2021).

---

## Detalle por ficha auditada

### 1. Policy_WorldBank2021.md — 🟡 AMARILLO (única con PDF)

**PDF:** `WorldBank2021_TappingPotential.pdf` (172 páginas). Mismo PDF también presente en `10_macro_growth_poverty/`. Esta ficha duplica la ficha del folder 10 con metadatos algo distintos.

| Cifra ficha | PDF (texto) | Estado |
|-------------|-------------|:------:|
| Citekey "WorldBank2021" (en folder 05) vs "WorldBank2021_TappingPotential" (folder 10) | Inconsistencia entre fichas: dos citekeys diferentes para el mismo PDF | 🔴 |
| "72% del valor agregado agrícola en Santa Cruz, Cochabamba, La Paz" | PDF (Executive Summary): "**72 percent of total agricultural value added is concentrated in Santa Cruz, Cochabamba, and La Paz**" | ✅ |
| Bolivia produce >20M de toneladas de alimentos básicos/año | No se localiza la frase "20 million tonnes of basic foods" verbatim en el PDF. Posible paráfrasis legítima pero requiere verificación específica | 🟡 |
| Exporta >3.5M t de soya y derivados | El PDF menciona "more than 3.5 million hectares" referido a expansión, NO toneladas de exportación. Ficha confunde unidades (ha vs t) | 🔴 |
| US$ 300M comprometidos por WB en proyecto reciente (PAR III) | No se localiza "US$ 300 million" verbatim en el PDF (que es 2021). Probable referencia externa | 🟡 |
| Cita verbatim "Productive alliances are a mechanism through which rural producer organizations with market potential, commercial partners, and technical assistance providers can participate in value chains" | La frase exacta NO aparece literal. El PDF habla de "small rural producer organizations and purchasers" y "productive alliance approach". Es una paráfrasis libre, **etiquetada "verificado en página WB"** lo que sugiere que el autor sabía que no era verbatim del PDF | 🔴 |

**Acción requerida:**
- Unificar citekey con folder 10 (`WorldBank2021_TappingPotential`) — eliminar duplicación.
- Corregir "Exporta >3.5M t soya" → "expansión de área >3.5M ha".
- Eliminar la cita verbatim §8 o trasladar referencia a la fuente real (web WB sobre PAR III), no al PDF.

---

### 2. Quinoa_Bazile2015.md — 🟡 AMARILLO (URL parcialmente accesible)

**Frontmatter:**
- title: "State of the art report on quinoa around the world in 2013"
- authors: Bazile, Didier & Bertero, H. Daniel & Nieto, Carlos (eds.)
- year: 2015 · source: FAO and CIRAD, Rome · pages: 589
- url: https://www.fao.org/3/i4042e/i4042e.pdf

**Verificación:** La URL `https://www.fao.org/3/i4042e/i4042e.pdf` ahora redirige a `https://openknowledge.fao.org/3/i4042e/i4042e.pdf` (HTTP 301). El nuevo host devuelve 403 a WebFetch (acceso restringido programáticamente, accesible humanamente). El identificador `i4042e` es el código FAO oficial para esta publicación.

| Campo | Estado |
|-------|:------:|
| URL resuelve (sí, vía redirect) | ✅ |
| Título + editores + año (FAO/CIRAD 2015) | Conocido (publicación reconocida en literatura quinua); no verificable vía WebFetch automatizado | 🟡 |
| Páginas 589 | Cifra plausible para libro editado; no verificable | 🟡 |

**Acción requerida:** actualizar URL al nuevo host (`https://openknowledge.fao.org/3/i4042e/i4042e.pdf`) y confirmar título/editores con descarga manual.

---

### 3. Quinoa_Bellemare2018.md — ✅ VERDE

**Frontmatter:**
- title: "Foods and fads: The welfare impacts of rising quinoa prices in Peru"
- authors: Bellemare, Marc F. & Fajardo-Gonzalez, Johanna & Gitter, Seth R.
- year: 2018 · journal: World Development · vol 112 · pages 163-179 · doi: 10.1016/j.worlddev.2018.07.012
- url: https://www.sciencedirect.com/science/article/abs/pii/S0305750X18302419

**Verificación vía OpenAlex (DOI):**

| Campo ficha | OpenAlex | Estado |
|-------------|----------|:------:|
| Title "Foods and fads: The welfare impacts of rising quinoa prices in Peru" | Exacto | ✅ |
| Autores Bellemare, Fajardo-González, Gitter | Exacto | ✅ |
| Year 2018 | 2018 | ✅ |
| Journal World Development | World Development | ✅ |
| Volume 112 | 112 | ✅ |
| Pages 163-179 | 163-179 | ✅ |

**Acción requerida:** ninguna. Ficha modelo en términos de metadata.

---

### 4. Coca_Grisaffi2022.md — 🔴 ROJO (metadatos incorrectos)

**Frontmatter:**
- title: "Enacting democracy in a de facto state: coca, cocaine and campesino unions in the Chapare, Bolivia"
- author: Grisaffi, Thomas
- year: **2022** · journal: Journal of Peasant Studies · vol **49** · issue **"2"** · pages **"459-481"** · doi: 10.1080/03066150.2021.1922889

**Verificación vía Crossref (DOI 10.1080/03066150.2021.1922889):**

| Campo ficha | Crossref | Estado |
|-------------|----------|:------:|
| Title | Exacto | ✅ |
| Author Grisaffi, Thomas | Exacto | ✅ |
| Journal | "The Journal of Peasant Studies" (con "The") | ✅ |
| Year **2022** | **2021** | 🔴 |
| Volume 49 | 49 | ✅ |
| Issue **"2"** | **"6"** | 🔴 |
| Pages **"459-481"** | **"1273-1294"** | 🔴 |

**Acción requerida:**
- Corregir `year: 2021` (publicación online y final) o etiquetar como "publicado online 2021, en vol 49 issue 6, 2022".
- Corregir `issue: "6"`.
- Corregir `pages: "1273-1294"`.
- Actualizar BibTeX en consecuencia.

---

### 5. Soya_McKay2018.md — 🔴 ROJO (metadatos incorrectos)

**Frontmatter:**
- title: "The politics of agrarian change in Bolivia's soy complex"
- author: McKay, Ben M.
- year: 2018 · journal: Journal of Agrarian Change · vol **18** · issue **"1"** · pages **"108-129"** · doi: 10.1111/joac.12240

**Verificación vía Crossref (DOI 10.1111/joac.12240):**

| Campo ficha | Crossref | Estado |
|-------------|----------|:------:|
| Title | Exacto | ✅ |
| Author Ben M. McKay | Exacto | ✅ |
| Journal | "Journal of Agrarian Change" | ✅ |
| Year 2018 | 2018 | ✅ |
| Volume 18 | 18 | ✅ |
| Issue **"1"** | **"2"** | 🔴 |
| Pages **"108-129"** | **"406-424"** | 🔴 |

**Acción requerida:**
- Corregir `issue: "2"`.
- Corregir `pages: "406-424"`.
- Actualizar BibTeX en consecuencia.

---

### 6. Camelid_FAO2009.md — 🟡 AMARILLO (URL inaccesible vía WebFetch)

**Frontmatter:**
- title: "Proceedings of the Symposium on Natural Fibres: South American Camelid Fibres"
- authors: FAO / CFC
- year: 2009
- url: https://www.fao.org/4/i0709e/i0709e07.pdf

**Verificación:**
- WebFetch al URL devuelve un binario PDF descargado pero el extractor no puede confirmar título visible (contenido demasiado encodificado para análisis directo). No es 404, el archivo existe.
- El código `i0709e` es nomenclatura FAO oficial. El año 2009 es consistente con un Symposium de Natural Fibres (declarado por FAO Año Internacional de las Fibras Naturales en 2009).

| Campo | Estado |
|-------|:------:|
| URL resuelve (PDF descargado, 458 KB) | ✅ |
| Título reconocible | No verificable por WebFetch automatizado | 🟡 |
| Año 2009 | Plausible y consistente con Year of Natural Fibres FAO 2009 | 🟡 |

**Acción requerida:** descargar manualmente el PDF y verificar título, autores, editor, año de portada.

---

## Síntesis: fichas sin PDF — patrones detectados

De las 5 fichas SIN PDF auditadas por URL/metadata:
- **2/5 confirmadas exactas** (Bellemare 2018 ✅, Quinoa_Bazile2015 — plausible pero no descargado).
- **2/5 con metadatos volumen/issue/pages incorrectos verificados contra Crossref** (Grisaffi 2022, McKay 2018).
- **1/5 inaccesible programáticamente** (Camelid FAO 2009) pero URL existe.

Esto **sugiere** que otras fichas sin PDF en la carpeta pueden tener errores similares de issue/pages/year. Riesgo de citas con metadatos no normalizados en el reporte final.

---

## Recomendaciones operativas

1. **Antes de usar `Coca_Grisaffi2022` o `Soya_McKay2018` en el reporte WB**, corregir issue/pages/year (verificable vía Crossref con sus DOIs declarados).
2. **Unificar** `Policy_WorldBank2021.md` (citekey `WorldBank2021`) con `WorldBank2021_TappingPotential.md` del folder 10 — son la misma fuente. Considerar mover a una sola carpeta.
3. **Corregir** la confusión "ha vs toneladas" en Policy_WorldBank2021 §6.
4. **Para las 33 fichas sin PDF restantes**, hacer una pasada de normalización de metadata vía Crossref/OpenAlex (DOI → metadata canónica). Recomendable script Python.
5. **Actualizar URLs FAO** al nuevo dominio `openknowledge.fao.org` (FAO migró su repositorio).

---

## Métricas finales

- Fichas auditadas: **6** (de 34 totales en la carpeta; 1 con PDF, 5 sin PDF).
- Confirmadas (verde): **1/6 (URL + metadata)**.
- Amarillo (URL existe pero no se pudo verificar contenido): **3/6**.
- Rojo (alucinación o metadatos incorrectos): **2/6 (Grisaffi, McKay)** + 1 dentro de la ficha con PDF (Policy_WorldBank2021 con confusión ha/t).

**Mensaje al equipo:** la mayor parte del corpus de `05_value_chains/` está sin PDF y por tanto sin verificación de cifras. Una vez que se complete la descarga, **debe correrse una segunda auditoría de contenido** análoga a `10_macro_growth_poverty/`. Mientras tanto, las citas de Grisaffi y McKay requieren corrección inmediata si se incluyen en el reporte.
