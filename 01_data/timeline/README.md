# Timeline — Política Agropecuaria en Bolivia (1990-2025)

Línea de tiempo de la política agropecuaria boliviana construida para informar la narrativa del Agricultural Public Expenditure Review (APER) 2026 del Banco Mundial.

## Propósito

Documentar año por año los **hitos más importantes de política agropecuaria** (leyes, decretos, programas, eventos externos) que permitan interpretar los datos cuantitativos del panel nacional (`spending_panel_v10.rds` 1990-2024) y triangular los cambios estructurales observados.

## Herramienta de visualización

**Knight Lab Timeline JS** — https://timeline.knightlab.com/#make

Input: Google Sheets con estructura específica. Template: https://docs.google.com/spreadsheets/d/1ZbLp1CygYR5PyvWWAYIZSpI-mJd0KQdO_s2G_Gl8i-o/edit

## Estructura de carpeta

```
01_data/timeline/
├── README.md                     — este documento
├── timeline.csv                  — ARCHIVO PRINCIPAL (KnightLab format)
├── timeline_simple.csv           — versión simplificada (sin HTML) para copiar a Google Sheets
├── sources.md                    — bibliografía completa por hito
├── media/                        — imágenes (una carpeta por época)
│   ├── pre_2006/
│   ├── morales_2006_2019/
│   └── anez_arce_2019_2025/
└── research/                     — notas de investigación por agente/época
```

## Esquema del CSV (Knight Lab Timeline JS)

| Columna | Descripción | Ejemplo |
|---------|-------------|---------|
| `Year` | Año inicio (obligatorio) | 2006 |
| `Month` | Mes inicio (1-12) | 3 |
| `Day` | Día inicio (1-31) | 7 |
| `Time` | Hora inicio | 08:00 |
| `End Year` | Año fin (para rangos) | 2019 |
| `End Month` | Mes fin | 11 |
| `End Day` | Día fin | 10 |
| `End Time` | Hora fin | |
| `Display Date` | Etiqueta personalizada | "2006-2019 Era Morales" |
| `Headline` | Título del hito (máx. ~80 chars) | "Creación del MDRyT" |
| `Text` | Descripción detallada (HTML permitido) | "El Ministerio de Desarrollo Rural...<br/>Fuente: DS XXX" |
| `Media` | URL de imagen/video | https://... o media/morales_2006_2019/foto.jpg |
| `Media Credit` | Crédito de la imagen | "ABI" |
| `Media Caption` | Pie de foto | "Evo Morales en..." |
| `Media Thumbnail` | URL thumbnail (opcional) | |
| `Type` | `title` (slide inicial) o `era` (span) | título / era / vacío |
| `Group` | Agrupación temática | "Leyes" / "Programas" / "Eventos" |
| `Background` | URL/color fondo | #1E4D8A |
| `Tag` | Etiquetas (separadas por coma) | "reforma_agraria,INRA" |

## Criterios de inclusión de hitos

Cada hito debe cumplir AL MENOS UNO:
1. **Instrumento legal**: Ley, Decreto Supremo, reglamento sectorial
2. **Programa emblemático**: Presupuesto ≥ USD 10M o impacto ≥ 10,000 beneficiarios
3. **Evento externo**: sequía, incendio, crisis política/económica con impacto ≥ 1% del PIB agropecuario
4. **Acuerdo/cumbre**: que produjo decisiones vinculantes (ej. Cumbre Agropecuaria 2015)

## Criterios de calidad por hito

Cada hito debe tener:
- ✅ **Fecha exacta** (año mínimo; preferible mes/día)
- ✅ **Fuente primaria** (ley publicada en Gaceta Oficial, DS, plan sectorial oficial)
- ✅ **≥ 1 fuente de noticias** (medio boliviano: La Razón, Página Siete, El Deber, ERBOL)
- ✅ **Descripción 150-300 palabras** con contexto político y dato cuantitativo si existe
- ✅ **Foto ilustrativa** con crédito apropiado
- ✅ **Vínculo con datos del panel** (qué variable del panel se ve afectada)

## Agrupación por épocas

- **Antes de MAS (1990-2005)**: Reforma agraria 1996, neoliberalismo, crisis 2003
- **Era Morales (2006-2019)**: Nacionalizaciones, Agenda Patriótica, soberanía alimentaria
- **Transición Áñez (2019-2020)**: Crisis política, GMOs emergencia, COVID
- **Era Arce (2020-2025)**: Retorno MAS, crisis divisas, incendios 2024

## Estado de construcción — sesión 8 ✅

### Archivos generados
- ✅ `timeline.csv` — **61 hitos** cronológicamente ordenados, formato KnightLab (19 cols)
- ✅ `timeline_preview.csv` — vista abreviada sin HTML para QA rápido
- ✅ `sources.md` — 412 líneas con fuentes por hito + transversales
- ✅ `INSTRUCCIONES_KNIGHTLAB.md` — cómo publicar el timeline (Google Sheets + JSON alternativo)
- ✅ `research/pre_2006.md` — 15 hitos 1990-2005 investigados
- ✅ `research/morales_2006_2019.md` — 25 hitos 2006-2019 investigados
- ✅ `research/anez_arce_2019_2025.md` — 21 hitos 2019-2025 investigados

### Distribución de hitos

| Período | # hitos | Grupos dominantes |
|---------|:------:|-------------------|
| **1990-2005** (Pre-MAS) | 15 | Leyes (SAFCO, INRA, Forestal, Hidrocarburos), Eventos (Guerra Agua, Guerra Gas) |
| **2006-2019** (Morales) | 25 | Leyes (CPE, Madre Tierra, 144, 300, 337, 393), Programas (EMAPA, BDP, INIAF, PSDA) |
| **2019-2025** (Áñez+Arce) | 21 | Crisis políticas, GMOs DS 4232, PAR III, incendios 2024, elecciones 2025 |
| **Total** | **61** | |

### Hitos por Group
- Leyes: 24
- Eventos: 14
- Leyes: 13 (Institucional)
- Programas: 5
- Externo: 4
- Title slide: 1

### Próximos pasos pendientes
1. **Verificar URLs de imágenes** (50-60% usan Wikimedia — confirmar que responden 200)
2. **Descargar imágenes localmente** a `media/pre_2006/`, `media/morales_2006_2019/`, `media/anez_arce_2019_2025/` para independencia de URLs externas
3. **Publicar timeline en Knight Lab** vía Google Sheets del proyecto (ver `INSTRUCCIONES_KNIGHTLAB.md`)
4. **Embeber en capítulo 3 del reporte** como narrativa política contextual
5. **Verificar balotaje 2025** (1 hito con `needs_review`)

Ver `sources.md` para inventario detallado por hito y `research/*.md` para notas de contexto y candidatos a imágenes.
