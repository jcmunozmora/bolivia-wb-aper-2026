# FIGURAS.md — Estándar de figuras y representación gráfica

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/07_FIGURAS.md`
**Audiencia:** equipo APER, agentes constructores de figuras (humano + LLM-asistido), revisores A3/A4 ([AUDITORIA.md](09_AUDITORIA.md)).
**Lecturas relacionadas:** [ESTILO_NARRATIVO.md](05_ESTILO_NARRATIVO.md) (TEEL de figura §8.2), [NEUTRALIDAD.md](06_NEUTRALIDAD.md), [INDICADORES.md](02_INDICADORES.md), [HALLAZGOS.md](04_HALLAZGOS.md) (contrato JSON figura §7.2 master), [CONTROL.md](08_CONTROL.md), [AUDITORIA.md](09_AUDITORIA.md).

> NEUTRALIDAD rige las **palabras**. ESTILO_NARRATIVO rige los **párrafos**. FIGURAS rige los **gráficos**: cómo se construyen, cómo se titulan, cómo se anotan, qué resolución tienen, cómo se firman.

---

## 1. Principio rector

> Una figura policy-quality cuenta **una sola historia** en **menos de tres segundos**. El título trae el hallazgo; la cifra trae el respaldo; el caption trae la trazabilidad. Si una figura necesita explicación en el texto para entenderse, **falla**.

Cinco afirmaciones operativas:

1. **Finding-first title.** El título es el claim, no la descripción del gráfico.
2. **Una figura, un mensaje.** Si la figura comunica dos hallazgos, son dos figuras.
3. **Cero ruido visual.** Cada elemento gráfico tiene función comunicativa o se borra.
4. **Reproducibilidad total.** Toda figura sale de un script versionado que lee del panel v12.
5. **Trazabilidad como metadato.** Cada figura tiene su contrato JSON con `figure_id`, `script_path`, `data_rds`, `variables_used`, `panel_version`, `linked_finding`.

---

## 2. Anatomía canónica de una figura

Componentes obligatorios y su orden visual:

```text
┌─────────────────────────────────────────────────────────────────┐
│ [1] Título — finding-first, una oración con magnitud + período  │
│                                                                 │
│ [2] Subtítulo (opcional) — unidad, alcance, aclaración          │
│                                                                 │
│ ┌───────────────────────────────────────────────────────────┐   │
│ │                                                           │   │
│ │ [3] Plot area — datos + ejes + leyenda + anotación        │   │
│ │                                                           │   │
│ │  [4] Anotación directa de la lectura clave                │   │
│ │  (preferida sobre la leyenda separada cuando es posible)  │   │
│ │                                                           │   │
│ └───────────────────────────────────────────────────────────┘   │
│                                                                 │
│ [5] Eje X label + unidad                                        │
│ [6] Eje Y label + unidad                                        │
│ [7] Leyenda (solo cuando direct labeling no alcanza)            │
│                                                                 │
│ Fuente: [8] estructura canónica                                 │
│ Nota:   [9] caveats metodológicos                               │
│                                                                 │
│ [10] figure_id en pie discreto (solo en versión draft / book)   │
└─────────────────────────────────────────────────────────────────┘
```

Componentes obligatorios: **[1] título, [3] plot, [5][6] ejes, [8] fuente**.
Componentes recomendados: [2] subtítulo, [4] anotación directa, [9] nota.
Componente técnico (no visible en final): [10] `figure_id`.

---

## 3. Título — finding-first

### 3.1. Regla

El título es **una oración declarativa con el hallazgo**, no una descripción del tipo de gráfico.

| Mala | Buena |
|---|---|
| "Figura 5.2: Composición del gasto agrícola, 2015–2023" | "Los bienes públicos representan menos del 20% del gasto agrícola, 2015–2023" |
| "Evolución del PSE en Bolivia" | "El PSE de Bolivia se duplicó entre 2010 y 2020, alcanzando 12% del ingreso agrícola" |
| "Comparación regional de inversión agropecuaria" | "Bolivia invierte 0,4% del PIB en agricultura, por debajo del promedio andino (0,7%)" |
| "Distribución territorial del gasto" | "El gasto agropecuario per cápita rural varía 5× entre departamentos, 2020" |

### 3.2. Reglas duras

- **Una oración**, ≤ 18 palabras EN / ≤ 20 palabras ES.
- **Trae magnitud** y **período** explícitos.
- **Sin "Figura X.Y"** en el título visible (el numerador va en la referencia Quarto, no en el chart).
- **Sin signos de pregunta retórica** (ESTILO §3.13).
- **Sin advocacy** (NEUTRALIDAD §2.3, §2.4).
- **Sin adjetivos morales** (NEUTRALIDAD §2.6) ni adverbios filler (§2.7).
- **Sin "Evolución de"** / **"Comparación de"** / **"Análisis de"** — son descripciones del gráfico, no hallazgos.
- **Sin tropos** ESTILO §3.17 ("Bolivia at a crossroads", "the journey of…").

### 3.3. Subtítulo (opcional)

Una línea adicional que aclara unidad, alcance geográfico o sub-período cuando el título no lo cubre:

```text
TÍTULO:    Los bienes públicos representan menos del 20% del gasto agrícola
SUBTÍTULO: % del gasto agropecuario público total, Bolivia, 2015–2023
```

Si el subtítulo se siente forzado o redundante, **se borra**.

---

## 4. Selección del tipo de gráfico (decision tree)

Cuatro preguntas, en orden:

```text
1. ¿Qué pregunta responde la figura?

   ├── magnitud / comparación entre categorías  → barra horizontal (preferida) o vertical
   ├── evolución temporal de una serie         → línea
   ├── evolución temporal de varias series     → líneas múltiples (≤ 5) + direct labeling
   ├── composición de un total                 → barra apilada horizontal (NUNCA torta salvo
   │                                             excepción justificada y siempre ≤ 4 categorías)
   ├── composición a lo largo del tiempo       → área apilada o barras apiladas en serie
   ├── distribución                            → histograma / densidad / boxplot / violín
   ├── relación entre dos variables            → scatter (+ rug + smoother si aporta)
   ├── relación entre tres variables           → scatter + tamaño O scatter + color
   ├── ranking                                  → barra horizontal ordenada
   ├── geografía                               → mapa coroplético O mapa de símbolos
   ├── flujo / transformación                  → sankey / waterfall / alluvial
   ├── matriz de comparaciones                 → heatmap (cuidado con paleta divergente)
   └── small multiples                         → facet con 4–12 paneles idénticos en estructura

2. ¿Cuántas series / categorías?
   - 1            → línea o barra única
   - 2–5          → líneas múltiples con direct labeling, paleta categórica
   - 6–10         → considerar facet o destacar 2–3 y agrupar el resto en "otros"
   - > 10         → small multiples obligatorio, o ranking horizontal con top-N + "otros"

3. ¿Cuál es la audiencia primaria?
   - Quarto book (PDF, impresión)       → estática, vector, leyenda compacta
   - Sitio web (responsive)             → estática + alt-text bilingüe; sin interactividad
                                           en v1 (ver §13)
   - Slides ejecutivos                  → máximo simplificación, un solo hallazgo, fuente al pie
   - Brief MEFP                         → idéntica al book, sin diferenciación de formato

4. ¿La figura tiene direct labeling o necesita leyenda?
   - direct labeling siempre que sea legible (preferencia FT / Economist)
   - leyenda solo si > 4 categorías o si el orden de la leyenda es interpretativo
```

### 4.1. Tipos prohibidos por defecto

| Tipo | Por qué se prohíbe |
|---|---|
| **Gráfico de torta / pie chart** | Difícil leer proporciones; reemplazar con barra horizontal apilada o stacked bar |
| **Doughnut chart** | Mismo problema + ruido extra |
| **3D de cualquier tipo** | Distorsiona magnitudes; chartjunk (Tufte) |
| **Barras con efectos de sombra / gradiente** | Ruido visual sin valor |
| **Eje Y truncado en barras** | Mentira visual; siempre desde 0 |
| **Eje doble Y** | Salvo excepción documentada con caveat explícito en la nota |
| **Word cloud** | No es policy reporting |
| **Radar / spider chart** | Difícil interpretar; usar small multiples de barras |
| **Mapas de calor sin paleta colorblind-safe** | Inaccesibilidad |
| **Animaciones / GIFs** | El reporte se imprime; las animaciones no sobreviven al PDF |

Excepción al pie chart: composición de exactamente **2 categorías** con magnitudes muy distintas y narrativa de "esto vs. todo lo demás". Aún así, preferir barra horizontal apilada.

### 4.2. Tipos preferidos para el APER

| Hallazgo / capítulo | Tipos típicos |
|---|---|
| F01 magnitud y evolución del GAP | línea simple (evolución) + barra horizontal (comparación entre instrumentos) |
| F02 brechas sectoriales | small multiples (un panel por indicador) + scatter con benchmark |
| F03 composición transferencias vs bienes públicos | barra horizontal apilada (composición) + área apilada (evolución composición) |
| F04 distribución territorial | mapa coroplético + barra horizontal ordenada por departamento |
| F05 eficiencia y focalización | scatter (gasto vs. necesidad) + barra de residuales |
| F06 PSE / CSE nivel y composición | barra apilada horizontal por commodity + línea (evolución %PSE) |
| F07 arquitectura institucional | sankey / alluvial (flujos de financiamiento) + barra apilada por ejecutor |
| F08 escenarios de repurposing | waterfall (composición ex-ante → ex-post) + barra con banda de incertidumbre |

---

## 5. Tipografía

```text
Familia principal:    Inter / Roboto / Source Sans Pro
                      (san-serif geométrico, alta legibilidad pantalla + print).
                      Decisión del proyecto: Inter por consistencia con el sitio público.

Fallback:             Arial (siempre disponible, alineado con WB Editorial).

Tamaños mínimos en figura final (a la resolución de impresión):
  - título de figura          : 12–14 pt
  - subtítulo                 : 10–11 pt
  - etiqueta de ejes          : 9–10 pt
  - tick labels               : 8–9 pt
  - leyenda                   : 9 pt
  - anotación directa         : 9–10 pt
  - fuente / nota             : 7–8 pt

Pesos:
  - título                    : bold (600) o semibold
  - subtítulo                 : regular
  - todo lo demás             : regular
  - resaltado puntual         : medium (500), nunca bold dentro del plot
```

**Italic** solo para términos en latín, nombres científicos, títulos de obras citadas.
**Bold** solo para el título o para un valor numérico crítico anotado.

---

## 6. Paleta de colores institucional

### 6.1. Decisión del proyecto

```text
Paleta categórica (5 colores principales + 3 secundarios):

CATEGÓRICA APER 2026 (decisión del proyecto, v0.1.0):

  primario_1     #1F4E79     azul WB profundo       — bienes públicos / I+D / educación
  primario_2     #C00000     rojo terracota tenue   — transferencias / subsidios
  primario_3     #548235     verde oliva            — infraestructura productiva
  primario_4     #BF8F00     dorado mate            — crédito y financiamiento
  primario_5     #7030A0     morado tenue           — sanidad e inocuidad

  secundario_1   #4472C4     azul medio             — referencia secundaria 1
  secundario_2   #A6A6A6     gris medio             — "otros" / contexto / gray-out
  secundario_3   #D9D9D9     gris claro             — gridlines, background

Paleta secuencial (mapas de calor, gradientes):

  base azul         #DCE6F1 → #1F4E79
  base verde        #E2EFDA → #375623
  base ocre         #FBE5D6 → #843C0C

Paleta divergente (cambio relativo a benchmark):

  rojo–blanco–azul  #C00000 ← #FFFFFF → #1F4E79
  ocre–blanco–verde #843C0C ← #FFFFFF → #375623
```

> **Pendiente.** Validar la paleta con la identidad visual definitiva del WB y el proyecto. Si la WB tiene paleta canónica para APER 2026, sustituir. Cambiar la paleta categórica es **ROJO + ADR** una vez consolidada.

### 6.2. Reglas duras de uso

- **Máximo 5 colores categóricos** en una figura. Si necesitás más, agrupá en "otros" o usá small multiples.
- **Highlight + gray-out:** cuando una serie es la protagonista, coloreala con primario; el resto va en `secundario_2` (gris medio). El ojo va al color.
- **Color + forma/textura redundantes** en figuras impresas en blanco y negro (caveat: los lectores del MEFP frecuentemente imprimen).
- **Paletas colorblind-safe verificadas:** la paleta categórica propuesta pasa ColorBrewer + simulator de deuteranopia. Confirmar con cada nueva paleta.
- **Sin colores semafóricos (rojo / amarillo / verde) cuando hay riesgo de implicación moral.** Para clima, podés usarlos; para "buen / mal gasto", **no**.
- **Sin escala de grises para datos categóricos** con > 3 niveles (poca discriminación).

### 6.3. Mapeo semántico recomendado

Asignaciones de color con significado consistente a lo largo del book:

```text
gasto en bienes públicos       primario_1 (azul WB)
transferencias a productores   primario_2 (rojo terracota)
infraestructura rural          primario_3 (verde oliva)
crédito subsidiado             primario_4 (dorado)
sanidad / inocuidad            primario_5 (morado tenue)
Bolivia (en comparaciones)     primario_1
benchmark regional / promedio  secundario_2 (gris medio)
escenario contrafactual        primario_3 con transparencia 70%
banda de incertidumbre         color del escenario al 30% alpha
```

---

## 7. Resolución y formatos de salida

### 7.1. Resolución por destino

| Destino | Formato primario | Resolución | Formato fallback |
|---|---|---|---|
| **Quarto book PDF (impresión / print-ready)** | **PDF vector** desde script | vector — DPI no aplica | PNG 600 DPI |
| **Quarto book HTML (preview / accesibilidad)** | **SVG vector** | vector | PNG 192 DPI |
| **Sitio público GitHub Pages** | **SVG** + PNG fallback | vector + 144 DPI retina | PNG 144 DPI |
| **Slides ejecutivos (reveal.js / Beamer / PPT)** | **SVG** + PNG | vector preferido; PNG 1920×1080 mínimo | PNG 300 DPI |
| **Brief MEFP (PDF dedicado)** | **PDF vector** | vector | PNG 600 DPI |
| **Carta / memo MEFP** | PNG embed | 300 DPI mínimo | n/a |
| **Redes / preview social** | PNG | 1200×630 (OG image) | n/a |
| **Print briefs distribuidos** | PDF vector | vector — 300 DPI raster mínimo | n/a |

### 7.2. Reglas duras de resolución

- **Vector siempre primero** (SVG / PDF). Raster solo cuando el destino no acepta vector.
- **PNG mínimo 300 DPI** para impresión; **600 DPI** para detalle fino (mapas con etiquetas pequeñas, scatter denso).
- **Nunca JPG** para figuras del reporte. JPG es lossy y produce halos en bordes vectoriales.
- **Sin pixelación visible** al zoom 200% en PDF.
- **Tamaño objetivo en book**: ancho 6,3 pulgadas (160 mm) por defecto; ancho página completa 7,5 pulgadas si la figura lo requiere.
- **Tamaño objetivo en slide**: 16:9 a 1920×1080 mínimo; si la figura va edge-to-edge, exportar a 2560×1440.
- **Tamaño objetivo en web**: rendered ≤ 1200 px de ancho en CSS; SVG escala libre.

### 7.3. Dimensiones canónicas

```text
Figura para book (Quarto/LaTeX):
  ancho  : 160 mm (6,3 in) — default; 190 mm (7,5 in) ancho completo
  alto   : 100 mm (4 in)   — default; ajustar al aspect ratio del dato
  margin : 0 (el script controla; Quarto inserta margen estándar)

Figura para slide:
  16:9 (1920×1080 mínimo, 2560×1440 para edge-to-edge)
  título de slide aparte del título de figura
  fuente al pie en 9 pt mínimo

Figura para web:
  responsive vía SVG; aspect ratio fijo para evitar layout shifts
  alt-text obligatorio (ver §10)
```

### 7.4. Aspect ratios sugeridos por tipo

| Tipo | Aspect ratio | Razón |
|---|---|---|
| Línea temporal corta (≤ 10 puntos) | 4:3 | x densa, y compactada |
| Línea temporal larga (> 10 puntos) | 16:9 | x amplia |
| Barra horizontal ordenada | 3:4 (más alto que ancho) | etiquetas legibles |
| Barra vertical apilada | 4:3 | composición clara |
| Scatter | 1:1 cuando interesa simetría; 4:3 default | |
| Mapa de Bolivia | ~1:1 (Bolivia es casi cuadrado en su BBox) | ajustar a UTM 20S |
| Small multiples | depende del nº de paneles | mantener cada panel cuadrado o 4:3 |

---

## 8. Naming y organización de archivos

### 8.1. Convención de `figure_id`

```text
fig_<NN_capítulo>_<MM_secuencia>_<slug_corto>

ejemplos:
  fig_05_02_pse_composition          composición del PSE, capítulo 5, fig 2
  fig_06_01_repurposing_waterfall    waterfall del escenario S02, capítulo 6
  fig_es_03_andean_benchmark         benchmark andino, executive summary
  fig_04_07_map_dept_per_capita      mapa departamental per cápita, capítulo 4
```

Reglas:

- **Solo minúsculas, snake_case.**
- **Sin tildes ni ñ** en `figure_id`.
- **Capítulo con dos dígitos** (01–06; `es` para executive summary; `ax` para appendix).
- **Secuencia con dos dígitos.**
- **Slug en inglés** (técnico, ≤ 4 palabras); preferible al español por reproducibilidad en archivos.

### 8.2. Organización de archivos

```text
02_code/05_figures/
  fig_05_02_pse_composition.R         ← script único que genera la figura
  fig_06_01_repurposing_waterfall.R
  ...
  _helpers/
    theme_aper2026.R                  ← tema ggplot canónico
    palette_aper2026.R                ← paletas categórica / secuencial / divergente
    save_figure.R                     ← función que exporta a SVG + PNG + PDF
    text_helpers.R                    ← formateo de números bilingüe (coma vs punto)

05_outputs/figures/
  svg/
    fig_05_02_pse_composition_es.svg
    fig_05_02_pse_composition_en.svg
  png/
    fig_05_02_pse_composition_es.png  (600 DPI)
    fig_05_02_pse_composition_en.png
  pdf/
    fig_05_02_pse_composition_es.pdf  (vector)
    fig_05_02_pse_composition_en.pdf
  meta/
    fig_05_02_pse_composition.json    ← contrato JSON (§16)
```

Regla: **cada figura genera al menos SVG + PNG + JSON**. PDF si va al book; segunda variante de idioma si es bilingüe.

### 8.3. Función canónica `save_figure()`

Para uniformidad, el helper `save_figure(p, "fig_05_02_pse_composition", lang = "es")` debe:

```text
- exportar SVG, PNG (600 DPI), PDF
- aplicar tema theme_aper2026() si el plot no lo tiene
- inyectar `figure_id` y `panel_version` como metadatos del archivo
- escribir el JSON de contrato (§16) junto con el archivo
- nombrar con la convención §8.1
```

---

## 9. Caption — Fuente y Nota

### 9.1. Formato canónico bilingüe

```text
ES:
  Fuente: <fuente cruda + año + ajuste>; cálculo propio sobre panel v12.
  Nota:   <caveats metodológicos; lo que la figura NO dice; sensibilidad>.

EN:
  Source: <raw source + year + adjustment>; authors' calculation based on panel v12.
  Note:   <methodological caveats; what the figure does NOT say; sensitivity>.
```

Reglas:

- **Una línea para Fuente, una línea para Nota.** Si la Nota se extiende, dividir.
- **Fuente en cursiva** del prefijo (`Source:` / `Fuente:`), nombre de la fuente en redonda.
- **Nota empieza con verbo o sustantivo concreto**, no con "Esta figura muestra…".
- **Sin marketing**: no "Datos curados por…", no "Análisis exclusivo de…".

### 9.2. Plantillas

```text
Fuente: BOOST 2024 release; clasificación funcional MEFP; cálculo propio
        sobre panel v12 [m0.1.0].
Nota:   La composición es sensible al tratamiento de subsidios indirectos
        (combustible, fertilizantes); ver apéndice A.3.

Fuente: IDB AgriMonitor 2024 (metodología OECD-PSE adaptada a LATAM);
        WB Pink Sheet (precios de referencia internacional, FOB Chicago/
        Rotterdam ajustados por flete a frontera boliviana).
Nota:   PSE central; bandas alto/medio/bajo corresponden a supuestos de
        precio de referencia detallados en METODOLOGIA §4.4. n=18 años.

Fuente: MapBiomas Bolivia Colección 3 (CC-BY); cálculo propio.
Nota:   "Antrópico" agrupa agricultura + pasto manejado + área urbana.
        La definición de "natural" excluye bosques degradados con
        cobertura < 25%.
```

### 9.3. Citas estándar de fuentes recurrentes

| Fuente | Cita canónica corta | Atribución exigida |
|---|---|---|
| BOOST | `BOOST 2024 release; cálculo propio` | no |
| VIPFE | `VIPFE — MEFP` | no |
| IDB AgriMonitor | `IDB AgriMonitor 2024` | no |
| WDI | `World Development Indicators (WB)` | no |
| FAOSTAT | `FAOSTAT (FAO, CC-BY)` | **sí** — atribución obligatoria |
| MapBiomas Bolivia | `MapBiomas Bolivia Col. 3 (CC-BY)` | **sí** |
| Hansen GFC | `Hansen Global Forest Change v1.11` | no |
| CHIRPS | `CHIRPS (Climate Hazards Group)` | no |
| USDA-ERS TFP | `USDA-ERS International Agricultural Productivity` | no |
| INE Bolivia | `INE Bolivia` (especificar encuesta o serie) | no |
| OECD PSE | `OECD PSE database` | no |
| APER 2011 | `APER Bolivia 2011 (WB N° 59696-BO)` | no |

---

## 10. Alt-text bilingüe (accesibilidad)

Heredado de NEUTRALIDAD §7. Para cada figura del sitio público y del book HTML:

```text
ALT-TEXT (ES):
  Gráfico de [tipo] que muestra [variable] entre [período]. La lectura
  principal es [hallazgo en una oración]. Fuente: [fuente corta].

ALT-TEXT (EN):
  [Type] chart showing [variable] over [period]. The main reading is
  [finding in one sentence]. Source: [short source].
```

Reglas:

- **No es traducción literal del caption** — es **equivalente comunicativo** para alguien que no ve.
- **Una lectura principal**, no exhaustiva.
- **Sin descripción de colores** salvo que sean semánticamente relevantes (e.g. "rojo destaca el componente de transferencias").
- **Cierra con fuente corta.**

Ejemplo completo:

```text
TÍTULO:    Los bienes públicos representan menos del 20% del gasto agrícola, 2015–2023
ALT (ES):  Gráfico de barras apiladas horizontales que muestra la composición del gasto
           agrícola público entre 2015 y 2023; las transferencias concentran 55–68% del
           total, los bienes públicos quedan entre 14% y 19%, e infraestructura entre
           12% y 18%. Fuente: BOOST 2024.
ALT (EN):  Horizontal stacked bar chart showing the composition of public agricultural
           spending between 2015 and 2023; transfers account for 55–68% of the total,
           public goods range between 14% and 19%, and infrastructure ranges between
           12% and 18%. Source: BOOST 2024.
```

---

## 11. Anotaciones dentro del gráfico

### 11.1. Direct labeling preferido

Cuando hay ≤ 5 series, etiquetar cada línea / barra directamente al lado de su valor más a la derecha (o en su extremo).

```text
ventajas:
  - el ojo no salta entre leyenda y plot
  - permite leer "en orden" (FT, Economist usan esto sistemáticamente)
```

### 11.2. Anotaciones de lectura

Una sola anotación dentro del plot que **destaca la lectura principal**:

```text
flecha + texto corto:
  "62% en transferencias (2018–2023)"

texto sin flecha (cuando la posición ya es obvia):
  "Mínimo: 14% en 2019"
```

Reglas:

- **Una anotación principal** por figura. Más de una crea ruido.
- **Texto en color del primario al que apunta**, no negro estridente.
- **Sin emojis ni iconos** salvo casos justificados (mapa con escala visual).

### 11.3. Eventos de política / breaks estructurales

Marcar líneas verticales suaves (color `secundario_2` con alpha 50%) para eventos relevantes:

```text
- Ley 393 (Servicios Financieros), 2013
- Censo Agropecuario 2013
- COVID-19, 2020 (sombreado vertical fino)
- (otros eventos que afecten la serie, documentados en METODOLOGIA)
```

Etiquetar el evento al pie de la línea vertical con un texto corto.

### 11.4. Bandas de incertidumbre

Para escenarios e intervalos:

- **Banda sombreada** del color de la serie principal al **30% de alpha**.
- **Etiquetar en la primera aparición**: "Banda alto / medio / bajo".
- **No usar barras de error** en líneas de evolución (genera ruido); usar banda.

---

## 12. Reglas de ejes

### 12.1. Eje Y

- **Empieza en 0** para barras y áreas, **sin excepciones**.
- Para líneas temporales con poca variación relativa, puede no empezar en 0; declarar en la nota.
- **Etiqueta con unidad explícita**: "% del PIB agropecuario", no solo "%".
- **Número de ticks**: 4–7 ticks principales. No más.
- **Formato de números**: separador de miles consistente (coma EN, punto ES); decimales solo si aportan.
- **Sin signos % redundantes** en cada tick si el eje ya dice "%".

### 12.2. Eje X temporal

- **Ticks cada 2 o 5 años** según ventana.
- **Año completo** ("2015"), no "'15".
- **Punto inicial y final etiquetados** siempre.
- **Eventos marcados** según §11.3 cuando aportan.

### 12.3. Eje X categórico

- **Orden lógico**: por magnitud (descendente para ranking), no alfabético salvo razón explícita.
- **Etiquetas en horizontal cuando caben**; rotación 0–45° si necesario; **nunca 90°** salvo último recurso.
- **Truncamiento**: si nombres muy largos, abreviar con leyenda al pie.

### 12.4. Gridlines

- **Solo horizontales** (sobre eje Y) en gráficos verticales.
- **Solo verticales** (sobre eje X) en gráficos horizontales.
- **Color**: `secundario_3` (gris claro), no negro.
- **Sin gridlines minor** salvo cuadrícula técnica donde aporten.

---

## 13. Mapas

### 13.1. Reglas duras

- **Proyección**: UTM 20S (EPSG:5356) o equivalente para Bolivia continental.
- **Componentes obligatorios**: norte, escala, leyenda, fuente, nota.
- **Bordes departamentales**: INE shapefile oficial.
- **Datos faltantes**: hatch pattern (rayado) + nota explicando el gap.
- **Etiquetas de departamentos**: solo capitales y/o nombres cuando aportan; no sobrepoblar.
- **Paleta secuencial** para magnitudes continuas; **paleta divergente** para residuales o cambios; **paleta categórica** para tipologías discretas.

### 13.2. Mapas departamentales (los más frecuentes)

```text
audiencia book / web:
  - 9 departamentos
  - paleta secuencial azul (default) o verde
  - 5 clases (cuantiles o intervalos fijos según contexto)
  - leyenda al pie o derecha
  - capitales como puntos discretos solo si aportan
```

### 13.3. Small multiples de mapas

Cuando se quieren comparar varias variables o años, usar facet de mapas pequeños idénticos en escala y proyección, no mapas individuales separados.

---

## 14. Anti-IA específico de figuras

Heredado del Standard 0 de [ESTILO_NARRATIVO §3](05_ESTILO_NARRATIVO.md), adaptado al medio gráfico.

### 14.1. Reglas absolutas

1. **Cero figuras generadas por modelos de imagen** (DALL·E, Midjourney, Stable Diffusion, Nano Banana, etc.). Las figuras del APER 2026 vienen **exclusivamente** de scripts deterministas sobre el panel v12.
2. **Cero mockups visuales como output final.** Un LLM puede producir un ASCII sketch o una descripción de figura como **discusión**, pero la figura entregada se construye con código.
3. **Captions y anotaciones generados por LLM pasan por el loop anti-IA** ([ESTILO §3.4](05_ESTILO_NARRATIVO.md)). Las listas NEVER WRITE y banderas §3.2–§3.24 aplican.
4. **Las figuras NO se "estilizan" con IA generativa post-script** (no se le pide a un LLM que "mejore" un SVG ya producido).
5. **Sin emoji-generated o ASCII art** dentro del plot.
6. **Sin fuentes/typography "AI-generated"** (e.g. fuentes inventadas que aparecen en exports vectoriales algunos plotters); revisar el SVG antes de commit.

### 14.2. Captions y títulos: filtro adicional

| Bandera (heredada ESTILO §3) | Aplica a captions de figura |
|---|---|
| §3.2 flag 7 — vocabulario IA ("foster", "leverage", "robust") | Sí |
| §3.2 flag 11 — abstracción rimbombante | Sí (especialmente "at a crossroads", "tells a story of") |
| §3.16 — teatralidad cuantitativa ("significant rise", "sharp drop") | **Crítico** — siempre con magnitud |
| §3.22 — tone calibration ("encouraging trend", "promising") | Sí — no califica, reporta |
| §3.24.1 — fórmulas académicas ES ("Cabe destacar que…") | **Crítico** en notas en español |
| §3.24.5 — conectores ornamentales | Sí (compactar) |

### 14.3. Verificación de figura humana

Al cerrar una sesión de figura, declarar:

```text
[A1-figura] figure_id: <id> | tipo: <bar/line/...> | script: <path>
| data_rds: <path> | panel_version: v12 | language: ES/EN
| AI-likelihood del caption: N/10 | banderas activadas: <lista o ninguna>
| generado por modelo de imagen: NO | mockup IA usado en diseño: NO
```

---

## 15. Checklist por figura

Antes de marcar una figura como `ready_for_book`:

```text
TÍTULO
[ ] una oración declarativa con magnitud y período
[ ] ≤ 18 palabras EN / ≤ 20 ES
[ ] sin "Figura X" en el texto visible
[ ] sin advocacy, sin tropos, sin adverbios filler
[ ] pasa filtro anti-IA §3.2 y §3.24

DATOS Y TRAZABILIDAD
[ ] script reproducible en 02_code/05_figures/<figure_id>.R
[ ] lee del panel v12 (o derivado documentado)
[ ] variables_used declaradas en el contrato JSON
[ ] filter aplicado documentado
[ ] period y geographic_scope explícitos

DISEÑO
[ ] tipo de gráfico seleccionado según §4 (no es tipo prohibido)
[ ] paleta APER 2026 aplicada (§6)
[ ] highlight + gray-out si hay protagonista
[ ] ≤ 5 colores categóricos
[ ] direct labeling cuando aplica; leyenda solo cuando necesaria

EJES
[ ] eje Y desde 0 (barras / áreas) o caveat declarado
[ ] etiquetas con unidad explícita
[ ] ticks: 4–7 principales
[ ] formato de números según idioma (coma/punto)
[ ] gridlines solo en eje relevante, color gris claro

ANOTACIONES
[ ] una anotación principal de la lectura
[ ] eventos de política marcados si aportan
[ ] bandas de incertidumbre cuando escenarios

CAPTION
[ ] Fuente: completa, con año y ajuste si aplica
[ ] Nota: caveats metodológicos + sensibilidad
[ ] atribución CC-BY si aplica (§9.3)
[ ] cita de panel v12 + methodology_version

ALT-TEXT
[ ] alt-text ES y EN (si bilingüe)
[ ] equivalente comunicativo, no traducción literal
[ ] lectura principal incluida

RESOLUCIÓN Y FORMATO
[ ] SVG generado
[ ] PNG 600 DPI generado
[ ] PDF vector generado (si va al book)
[ ] dimensiones según destino (§7.3)
[ ] sin pixelación al zoom 200%

METADATA
[ ] contrato JSON en 05_outputs/figures/meta/<figure_id>.json
[ ] figure_id consistente con HALLAZGOS y capítulos vinculados
[ ] linked_finding declarado

ANTI-IA
[ ] no generada por modelo de imagen
[ ] caption pasa filtro anti-IA §3
[ ] AI-likelihood del caption ≤ 3 (EN) / ≤ 2 (ES)

ACCESIBILIDAD
[ ] color + redundancia (forma / textura / direct label)
[ ] contraste suficiente para impresión b/n
[ ] colorblind-safe verificado (al menos para deuteranopia)
```

---

## 16. Contrato JSON de figura

Heredado del master §7.2, con campos adicionales para versionamiento y accesibilidad:

```json
{
  "figure_id": "fig_05_02_pse_composition",
  "chapter": "04_report/05_spending_analysis",
  "type": "stacked_horizontal_bar",
  "title_es": "Los bienes públicos representan menos del 20% del gasto agrícola, 2015–2023",
  "title_en": "Public goods account for less than 20% of agricultural spending, 2015–2023",
  "subtitle_es": "% del gasto agropecuario público total, Bolivia, 2015–2023",
  "subtitle_en": "% of total public agricultural spending, Bolivia, 2015–2023",
  "caption_es": {
    "source": "BOOST 2024 release; clasificación funcional MEFP; cálculo propio sobre panel v12 [m0.1.0].",
    "note": "La composición es sensible al tratamiento de subsidios indirectos; ver apéndice A.3."
  },
  "caption_en": {
    "source": "BOOST 2024 release; MEFP functional classification; authors' calculation based on panel v12 [m0.1.0].",
    "note": "Composition is sensitive to the treatment of indirect subsidies; see Annex A.3."
  },
  "alt_text_es": "Gráfico de barras apiladas horizontales que muestra la composición del gasto agrícola público entre 2015 y 2023. Las transferencias concentran entre 55% y 68% del total; los bienes públicos quedan entre 14% y 19%; infraestructura entre 12% y 18%. Fuente: BOOST 2024.",
  "alt_text_en": "Horizontal stacked bar chart showing the composition of public agricultural spending between 2015 and 2023. Transfers account for 55–68% of the total; public goods range between 14% and 19%; infrastructure ranges between 12% and 18%. Source: BOOST 2024.",
  "script": "02_code/05_figures/fig_05_02_pse_composition.R",
  "data_rds": "01_data/processed/spending_panel_v12.rds",
  "variables_used": ["share_transfers", "share_public_goods", "share_infrastructure", "year"],
  "filter": "year >= 2015 & year <= 2023",
  "period": "2015-2023",
  "geographic_scope": "nacional",
  "panel_version": "v12",
  "methodology_version": "m0.1.0",
  "linked_finding": "F03",
  "linked_scenario": null,
  "outputs": {
    "svg_es": "05_outputs/figures/svg/fig_05_02_pse_composition_es.svg",
    "svg_en": "05_outputs/figures/svg/fig_05_02_pse_composition_en.svg",
    "png_es": "05_outputs/figures/png/fig_05_02_pse_composition_es.png",
    "png_en": "05_outputs/figures/png/fig_05_02_pse_composition_en.png",
    "pdf_es": "05_outputs/figures/pdf/fig_05_02_pse_composition_es.pdf",
    "pdf_en": "05_outputs/figures/pdf/fig_05_02_pse_composition_en.pdf"
  },
  "license": "CC-BY-4.0",
  "ai_check": {
    "generated_by_image_model": false,
    "ai_mockup_used_in_design": false,
    "caption_ai_likelihood_es": 1,
    "caption_ai_likelihood_en": 1,
    "flags_triggered": []
  },
  "review_log": [
    {
      "date": "2026-05-23",
      "auditor": "Juan Carlos Muñoz",
      "audit_id": "A1-2026-0001",
      "status": "draft"
    }
  ],
  "status": "draft",
  "last_updated": "2026-05-23"
}
```

Reglas:

- **Cada figura tiene su JSON.**
- **El JSON se actualiza con cada cambio** que afecte cifras, título, caption, alt-text.
- **`status`**: `draft` → `reviewed` → `book_ready` → `published`.
- **Schema canónico** vive en `.agent/schemas/figure.schema.json` (a generar).

---

## 17. Tablas como figura (cuando aplica)

Cuando la información se comunica mejor como tabla (e.g. PSE por commodity con valores absolutos y %), tratar la tabla con los mismos estándares editoriales:

- **Título finding-first** equivalente al de figura.
- **Encabezados claros** con unidad.
- **Alineación**: texto a la izquierda; números a la derecha; decimales alineados al punto/coma decimal.
- **Sin líneas verticales internas** (Tufte); líneas horizontales superior + inferior + bajo encabezado.
- **Fuente y Nota** al pie con misma estructura §9.
- **Sombreado alterno de filas** solo si la tabla excede 10 filas (legibilidad).
- **Exportar con `gt` o `kableExtra`** en R; cada tabla tiene `table_id` análogo a `figure_id`.

---

## 18. Pipeline reproducible — workflow canónico

```text
1. Definir el hallazgo o sub-claim que la figura va a soportar.
2. Identificar variables del panel v12 que se necesitan
   (consultar INDICADORES.md por grupo).
3. Crear 02_code/05_figures/<figure_id>.R con plantilla:

   #' Figure <figure_id>: <título corto técnico>
   #' Linked finding: F<NN>
   #' Panel version: v12, methodology: m0.1.0

   library(tidyverse); library(here)
   source(here("02_code/05_figures/_helpers/theme_aper2026.R"))
   source(here("02_code/05_figures/_helpers/palette_aper2026.R"))
   source(here("02_code/05_figures/_helpers/save_figure.R"))

   panel <- readRDS(here("01_data/processed/spending_panel_v12.rds"))

   df <- panel %>%
     filter(year >= 2015, year <= 2023) %>%
     transmute(year, share_transfers, share_public_goods, share_infrastructure) %>%
     pivot_longer(-year, names_to = "component", values_to = "share")

   p_es <- ggplot(df, aes(x = year, y = share, fill = component)) +
     geom_col(position = "stack") +
     scale_fill_aper_categorical() +
     theme_aper2026() +
     labs(
       title    = "Los bienes públicos representan menos del 20% del gasto agrícola, 2015–2023",
       subtitle = "% del gasto agropecuario público total, Bolivia, 2015–2023",
       x        = NULL,
       y        = "% del total",
       caption  = "Fuente: BOOST 2024; cálculo propio sobre panel v12 [m0.1.0].\nNota: ..."
     )

   save_figure(p_es, "fig_05_02_pse_composition", lang = "es")

   # versión EN
   p_en <- p_es + labs(
     title    = "Public goods account for less than 20% of agricultural spending, 2015–2023",
     subtitle = "% of total public agricultural spending, Bolivia, 2015–2023",
     y        = "% of total",
     caption  = "Source: BOOST 2024; authors' calculation based on panel v12 [m0.1.0].\nNote: ..."
   )
   save_figure(p_en, "fig_05_02_pse_composition", lang = "en")

4. Verificar checklist §15.
5. Generar el contrato JSON (auto por save_figure() o manual).
6. Commit con mensaje "figure: fig_05_02_pse_composition (draft)".
7. A2 — revisión par.
8. A3 — revisión capítulo cuando se incorpora al book.
```

---

## 19. Casos especiales

### 19.1. Figura compuesta (multi-panel)

Cuando una figura tiene varios paneles (e.g. composición + evolución), usar `patchwork` o `cowplot`:

- Numerar paneles con `(a)`, `(b)`, `(c)` en mayúscula bold superior izquierda.
- Compartir leyenda si los paneles comparten escala.
- Título único arriba; subtítulo común; caption común al pie.

### 19.2. Small multiples

- Mismo tipo de gráfico repetido para múltiples categorías.
- Escala de ejes idéntica entre paneles salvo razón explícita.
- Facets ordenados por magnitud o por jerarquía lógica.

### 19.3. Figura interactiva

**v1 del reporte: NO se usan figuras interactivas** (Plotly, Highcharts, Observable). Razón: el reporte se imprime, se distribuye en PDF, y se cita en cartas MEFP. Interactividad rompe paridad entre book y web.

**v2+ (post-publicación)**: se puede agregar versión interactiva en el sitio público, **siempre acompañada de la versión estática** como fallback y como fuente canónica.

### 19.4. Figura de escenario de repurposing

Componente fijo:

- composición ex-ante vs. ex-post (waterfall preferido, stacked bar alterno);
- banda de incertidumbre obligatoria;
- etiqueta "opción técnica para consideración del MEFP" visible en el caption o subtítulo;
- escenario marcado con `S0X` en `figure_id` y en `linked_scenario`.

---

## 20. Referencias canónicas externas

| Autoridad | Uso |
|---|---|
| **WB Visual Identity Guidelines** | autoridad institucional; paleta, tipografía, layout |
| **WB Editorial Style Guide** | citas, atribuciones, formato de captions |
| **OECD Editorial Style Guide** | para PSE, GSSE, TSE y figuras de soporte estimate |
| **The Economist Style Guide / Graphic Detail** | finding-first titles; minimalismo; direct labeling |
| **Financial Times Visual Vocabulary** (Alan Smith) | guía de selección de tipo de gráfico — basis del decision tree §4 |
| **Edward Tufte,** *The Visual Display of Quantitative Information* | data-ink ratio, chartjunk, no 3D, mínimo necesario |
| **Edward Tufte,** *Envisioning Information* | small multiples, layering, density |
| **Alberto Cairo,** *The Truthful Art* | cinco cualidades: truthful, functional, beautiful, insightful, enlightening |
| **Claus O. Wilke,** *Fundamentals of Data Visualization* (free online) | mejores prácticas técnicas específicas a ggplot2 |
| **Kieran Healy,** *Data Visualization: A Practical Introduction* | implementación en R/ggplot2 |
| **Cynthia Brewer,** ColorBrewer 2.0 | paletas colorblind-safe + impresión b/n |
| **WCAG 2.1** | accesibilidad — contraste mínimo, alt-text |
| **ggplot2 grammar of graphics** | implementación técnica en R |

> Cuando una recomendación de estos textos contradice una regla de este archivo, **prevalece este archivo** (más estricto para policy reporting WB).

---

## 21. Cómo modificar este archivo

`FIGURAS.md` es zona crítica ([CONTROL §3](08_CONTROL.md)).

| Tipo de cambio | Color | Requisitos |
|---|---|---|
| Corrección de typo, ejemplo adicional, mejor wording | VERDE | commit directo |
| Agregar tipo de gráfico permitido / variante | AMARILLO | A2 + nota en este archivo |
| Cambiar paleta institucional (§6.1) | ROJO | ADR + regeneración de todas las figuras + bump |
| Cambiar tipografía principal | ROJO | ADR + regeneración |
| Cambiar resolución mínima / formato de salida | ROJO | ADR + verificar todas las figuras existentes |
| Agregar/quitar reglas duras §15 | ROJO | ADR + A3 sobre figuras existentes |
| Cambiar contrato JSON (§16) | ROJO | ADR + actualización de schemas en `.agent/schemas/` |
| Cambiar invocación a /quijote-writer u otra skill | AMARILLO | A2 |

---

## 22. TODOs para alcanzar v1.0

- [ ] Implementar `02_code/05_figures/_helpers/theme_aper2026.R` (tema ggplot canónico).
- [ ] Implementar `02_code/05_figures/_helpers/palette_aper2026.R` (paletas categórica, secuencial, divergente).
- [ ] Implementar `02_code/05_figures/_helpers/save_figure.R` (export SVG + PNG + PDF + JSON).
- [ ] Implementar `02_code/05_figures/_helpers/text_helpers.R` (formateo de números bilingüe coma/punto).
- [ ] Generar `.agent/schemas/figure.schema.json` para validación de contratos.
- [ ] Validar paleta categórica con WB Visual Identity Guidelines (si el WB tiene paleta canónica para APER, sustituir).
- [ ] Construir 1 figura piloto siguiendo todo el estándar (sugerencia: `fig_05_02_pse_composition`) como referencia visual del estándar.
- [ ] Decidir convención de em dash en figures (alineado con [ESTILO §3.20](05_ESTILO_NARRATIVO.md): con espacios).
- [ ] Decidir si los mapas del APER usan paleta secuencial azul o verde por defecto.
- [ ] Agregar checklist específico A3 sobre figuras al protocolo de revisión por capítulo en [AUDITORIA §5](09_AUDITORIA.md).

---

## 23. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: principio rector, anatomía canónica, finding-first title, decision tree de tipos, tipografía, paleta APER 2026 propuesta, resolución por destino, naming, captions, alt-text bilingüe, anotaciones, reglas de ejes, mapas, anti-IA gráfico, checklist por figura, contrato JSON, tablas, pipeline reproducible, casos especiales, 13 referencias canónicas externas, TODOs para v1.0 |
