# Estrategia de Búsqueda Sistemática de Literatura
## Protocolo PRISMA — Bolivia Agricultural Public Spending

**Fecha de registro**: 2026-04-21  
**Revisores**: Equipo World Bank Bolivia  
**Pregunta PICO**:

| Elemento | Especificación |
|----------|---------------|
| **P**oblación | Sector agropecuario boliviano / LAC (comparadores) |
| **I**ntervención | Gasto público agropecuario (inversión, subsidios, servicios) |
| **C**omparador | Ausencia de gasto / período anterior / países similares |
| **O**utcome | Productividad agropecuaria, seguridad alimentaria, pobreza rural |
| **S**tudy type | Cualquier diseño empírico (experimental, cuasi-experimental, observacional) |

---

## 1. Bases de Datos (en orden de prioridad)

| Base | URL | Tipo | Estrategia |
|------|-----|------|-----------|
| WB Open Knowledge | https://openknowledge.worldbank.org/ | Grey literature | Búsqueda directa por país + tema |
| IFPRI Publications | https://www.ifpri.org/publications/ | Research papers | Búsqueda full-text |
| ECLAC Digital | https://repositorio.cepal.org/ | Regional reports | Búsqueda por clasificación temática |
| IDEAS/RePEC | https://ideas.repec.org/ | Working papers | Búsqueda por keyword |
| Google Scholar | https://scholar.google.com/ | Grey + academic | Snowballing + keyword |
| FAO Publications | https://www.fao.org/publications | Technical reports | Búsqueda por país |
| SSRN | https://ssrn.com/ | Working papers | Búsqueda keyword |

---

## 2. Cadenas de Búsqueda

### Bloque 1: Bolivia + Gasto Agropecuario (ES)
```
"Bolivia" AND ("gasto público" OR "inversión pública" OR "presupuesto") AND
("agropecuario" OR "agrícola" OR "agricultura" OR "ganadería")
```

### Bloque 2: Bolivia + Gasto Agropecuario (EN)
```
"Bolivia" AND ("public spending" OR "public expenditure" OR "public investment") AND
("agriculture" OR "agricultural" OR "agropecuarian" OR "rural")
```

### Bloque 3: Metodología PSE en países en desarrollo
```
("producer support estimates" OR "PSE" OR "public expenditure review") AND
("Latin America" OR "developing countries") AND "agriculture"
```

### Bloque 4: DEA y eficiencia del gasto agropecuario
```
("data envelopment analysis" OR "DEA" OR "technical efficiency") AND
("agricultural spending" OR "agricultural public expenditure") AND
("Latin America" OR "Bolivia" OR "developing")
```

### Bloque 5: Seguridad alimentaria y gasto público Bolivia
```
("food security" OR "seguridad alimentaria") AND
("Bolivia" OR "Andes" OR "altiplano") AND
("public spending" OR "gasto público" OR "social programs")
```

### Bloque 6: Evaluaciones de impacto programas Bolivia
```
"Bolivia" AND ("EMAPA" OR "INIAF" OR "SENASAG" OR "Mi Agua" OR "BDP") AND
("impact evaluation" OR "evaluación de impacto" OR "efectividad")
```

---

## 3. Criterios de Inclusión/Exclusión (PRISMA)

### Criterios de INCLUSIÓN
- [ ] Período de publicación: 1995–2026
- [ ] Idiomas: español, inglés, portugués
- [ ] País: Bolivia como foco principal O LAC con resultados específicos para Bolivia
- [ ] Tema: gasto público agropecuario, evaluación de políticas, productividad agrícola, seguridad alimentaria
- [ ] Tipo: estudios empíricos, reportes técnicos con datos, policy reviews

### Criterios de EXCLUSIÓN
- [ ] Solo aspectos biofísicos/agrónomicos sin componente económico/político
- [ ] Proyectos privados sin componente de política pública
- [ ] Documentos de proyecto sin resultados (solo propuestas)
- [ ] Bolivia mencionado solo marginalmente (< 20% del contenido)

---

## 4. Proceso de Screening

### Fase 1: Título y Abstract (N estimado: 200-400)
- Dos revisores independientes
- Desacuerdo → discusión → tercer revisor
- Registrar en `screening_log.csv`: ID, título, decisión (incluir/excluir/dudoso), razón

### Fase 2: Texto completo (N estimado: 50-100)
- Aplicar criterios PICO completos
- Completar `extraction_template.csv`

### Fase 3: Síntesis
- Narrativa por capítulo del reporte
- Tabla resumen de estudios incluidos
- Mapa de evidencia (evidence gap map)

---

## 5. Plantilla de Extracción

Ver `extraction_template.csv` para la plantilla completa. Variables clave a extraer:

| Variable | Descripción |
|----------|-------------|
| `study_id` | ID único del estudio |
| `authors` | Autor(es) |
| `year` | Año de publicación |
| `title` | Título completo |
| `source` | Revista/institución |
| `country` | Países cubiertos |
| `period` | Período analizado |
| `methodology` | Tipo de análisis (RCT, diff-in-diff, IV, FE, DEA, etc.) |
| `intervention` | Tipo de gasto/programa analizado |
| `outcome` | Variable dependiente principal |
| `key_finding` | Hallazgo principal (≤ 100 palabras) |
| `effect_size` | Magnitud del efecto estimado (si aplica) |
| `data_source` | Fuentes de datos usadas |
| `chapter_relevance` | Capítulo(s) del reporte donde aplica |
| `quality_score` | 1-3 (1=bajo, 2=medio, 3=alto) |

---

## 6. Literatura Clave (ya identificada)

### Metodología General
- OECD (2023). *PSE Manual*. OECD Publishing, Paris.
- World Bank (2010). *Public Expenditure Reviews in the Agriculture Sector*. World Bank, Washington.
- Simar, L. & Wilson, P.W. (1998). Sensitivity analysis of efficiency scores. *Management Science*, 44(11), 49-61.
- Fan, S. (2000). Research investment and the economic returns to agricultural research. *EPTD Discussion Paper*.

### Bolivia Específico
- Banco Mundial (varios años). Bolivia Country Partnership Framework. WB, Washington.
- IFPRI/INESAD. Estudios sobre agricultura boliviana.
- MDRyT (varios años). Memorias Institucionales. La Paz.
- INE Bolivia. Encuesta Nacional Agropecuaria.
- ECLAC (varios). Panorama Social de América Latina (capítulos Bolivia).

### Regional LAC
- Mogues, T. et al. (2011). The bang for the birr. *IFPRI Discussion Paper*.
- Valdés, A. & Foster, W. (2010). Reflections on the role of agriculture in pro-poor growth. *World Development*.
- FAO/CEPAL/IICA (varios). *Perspectivas de la Agricultura y del Desarrollo Rural en las Américas*.
