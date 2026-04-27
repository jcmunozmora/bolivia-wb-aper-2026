# Slides — APER Bolivia 2026

Cada presentación vive en su propia subcarpeta `YYYY-MM-DD_evento/` para facilitar
versionado y trazabilidad de qué se mostró, cuándo y a quién.

## Estructura

```
slides/
├── README.md                       ← este archivo
├── render.sh                       ← helper: produce HTML + PDF
├── wb_slides.scss                  ← tema World Bank compartido
└── YYYY-MM-DD_evento/
    ├── NN_titulo.qmd               ← fuente
    ├── NN_titulo.html              ← render autocontenido (~4 MB)
    ├── NN_titulo.pdf               ← versión paginada para envío/impresión
    └── (figuras propias si las hay)
```

## Inventario

| Fecha | Evento | Audiencia | Carpeta | HTML | PDF |
|-------|--------|-----------|---------|:----:|:---:|
| 2026-04-27 | Kickoff BM | Banco Mundial Bolivia | [`2026-04-27_kickoff/`](2026-04-27_kickoff) | ✅ | ✅ |

## Convenciones

- **Tema visual:** referenciar `../wb_slides.scss` desde el `.qmd` — paleta WB
  (`#009FDA`, `#002244`).
- **Figuras del pipeline:** reutilizar `../../05_outputs/figures/figNN_*.png` en
  lugar de regenerarlas en el deck.
- **Datos frescos:** leer `../../01_data/processed/*.rds` en chunks
  con `echo: false`.
- **Naming dentro de la carpeta:** `NN_titulo.qmd` (numeración para el orden si
  hay varios decks por evento — kickoff, follow-up, etc.).

## Renderizar (siempre HTML + PDF)

Toda presentación se publica en **dos formatos**: HTML (autocontenido,
interactivo) y PDF (paginado, para envío e impresión). Usar el helper:

```bash
slides/render.sh slides/2026-04-27_kickoff/01_kickoff_BM_avances.qmd
```

El script (1) corre `quarto render --to revealjs` para producir el HTML y
(2) usa Chrome headless con `?print-pdf` para producir el PDF paginado
(reveal.js maneja el tamaño de página). Ambos archivos quedan junto al `.qmd`.

## Crear una presentación nueva

```bash
# 1. Crear la carpeta del evento
mkdir slides/2026-05-15_taller_recomendaciones

# 2. Partir de un deck existente como plantilla
cp slides/2026-04-27_kickoff/01_kickoff_BM_avances.qmd \
   slides/2026-05-15_taller_recomendaciones/01_taller.qmd

# 3. Editar y renderizar (HTML + PDF en una sola corrida)
slides/render.sh slides/2026-05-15_taller_recomendaciones/01_taller.qmd
```
