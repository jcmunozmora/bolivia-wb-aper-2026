# Cómo publicar el timeline en Knight Lab TimelineJS

## Opción A — Google Sheets (recomendada, fácil de actualizar)

### Paso 1: Crear copia del template
1. Abrir el template oficial: https://docs.google.com/spreadsheets/d/1cWqR6WjGF9yCIjdZvNMbz_4C0625vOXYFNUaU1WvxRM/copy
2. Hacer "Archivo → Hacer una copia" → guardar en Drive del proyecto
3. Renombrar a: `WB_Bolivia_APER_Timeline_PoliticaAgropecuaria`

### Paso 2: Importar datos desde timeline.csv
1. Seleccionar A1 en la nueva hoja
2. Menú **Archivo → Importar → Subir → `01_data/timeline/timeline.csv`**
3. En el diálogo de importación:
   - Ubicación: "Reemplazar hoja actual"
   - Tipo de separador: "Coma"
   - Convertir texto a números: SÍ
4. Verificar que las 19 columnas se cargaron correctamente
5. ⚠️ NO borrar ni renombrar columnas — KnightLab las lee por posición

### Paso 3: Publicar la hoja
1. Menú **Archivo → Compartir → Publicar en web**
2. Documento completo → formato "Valores separados por comas (.csv)"
3. Copiar el enlace generado (termina en `?output=csv` o similar)

### Paso 4: Generar timeline en Knight Lab
1. Ir a https://timeline.knightlab.com/#make
2. Pegar el enlace publicado
3. Click "Generate Preview"
4. Si todo se ve bien, copiar el código `<iframe>` para embeber

### Paso 5: Embeber en reporte Quarto
En cualquier `.qmd`:
```html
<iframe src="https://cdn.knightlab.com/libs/timeline3/latest/embed/index.html?source=[TU_URL_PUBLICADA]&font=Default&lang=es&initial_zoom=2&height=650"
        width="100%" height="650" frameborder="0"></iframe>
```

## Opción B — JSON standalone (timeline offline)

Si no se quiere depender de Google Sheets, convertir `timeline.csv` a JSON:

```r
library(data.table); library(jsonlite)
tl <- fread("01_data/timeline/timeline.csv")
events <- lapply(seq_len(nrow(tl)), function(i) {
  x <- tl[i]
  list(
    start_date = list(year = x$Year, month = x$Month, day = x$Day),
    end_date   = if (!is.na(x$`End Year`)) list(year = x$`End Year`, month = x$`End Month`, day = x$`End Day`) else NULL,
    display_date = x$`Display Date`,
    text = list(headline = x$Headline, text = x$Text),
    media = list(url = x$Media, credit = x$`Media Credit`, caption = x$`Media Caption`),
    group = x$Group
  )
})
writeLines(toJSON(list(events = events), auto_unbox = TRUE, pretty = TRUE),
           "01_data/timeline/timeline.json")
```

Luego referenciar `timeline.json` en un HTML con el loader JS de TimelineJS.

## Opción C — Export a PowerPoint/PDF (para stakeholders sin internet)

Para entregables offline, usar el CSV en `timeline_preview.csv` (sin HTML) en herramientas como:
- `officer` en R → diapositivas con una fila por hito
- `ggplot2` → gráfico de gantt-like por año × grupo

## Verificación antes de publicar

- [ ] Todas las URLs de `Media` responden HTTP 200 (correr `R/check_media_urls.R`)
- [ ] Ningún hito tiene `Year` NA
- [ ] Todos los `Text` son ≤2000 caracteres (limite práctico TimelineJS)
- [ ] Grupos consistentes: solo `Leyes | Programas | Eventos | Institucional | Externo`
- [ ] Slide inicial (`Type=title`) está presente y es el primer registro
- [ ] Al menos 50% de hitos tienen imagen con licencia clara

## Mantenimiento

Para agregar un nuevo hito:
1. Añadir fila a `timeline.csv` (mantener orden cronológico)
2. Actualizar `sources.md` con las 2-4 URLs de soporte
3. Subir imagen nueva a `media/[epoca]/` si aplica
4. Re-importar a Google Sheets y refrescar el cache del timeline
