# Estrategia Integral para Obtener Datos SIIF/SIGEP — Bolivia WB PER

**Objetivo:** Conseguir gasto público agropecuario ejecutado 2009-2023, desagregado por institución, programa y departamento.

**Contexto crítico:** El APER 2011 del Banco Mundial cubre 1996-2008. Necesitamos cerrar la brecha 2009-2023 para poder correr las regresiones panel, el DEA con bootstrap, y la metodología PSE/PER completa del proyecto.

**Marco legal clave:** Decreto Supremo 28168 de 2005 garantiza acceso a información pública con respuesta obligatoria en **15 días hábiles**.

---

## Mapa del ecosistema fiscal boliviano

```
MEFP (Ministerio de Economía y Finanzas Públicas)
├── SIGMA (legacy 2000-2018) → SIGEP (2009+, oficial por Ley 1135/2018)
│   └── DGSGIF (Dirección General de Sistemas de Gestión de Información Fiscal)
├── Viceministerio de Presupuesto y Contabilidad Fiscal
│   └── Publica: Boletín Económico de Estadísticas Fiscales (anual)
├── VIPFE (Viceministerio Inversión Pública y Financiamiento Externo)
│   └── SISIN (Sistema de Información de Inversiones)
├── UDAPE (Unidad de Análisis de Políticas Sociales y Económicas)
│   └── Dossier anual + Diagnóstico Agropecuario
└── Contraloría General del Estado
    └── Informes de auditoría por sector
```

---

## TIER 1 — Acciones inmediatas (0-7 días, alta probabilidad de éxito)

### 1.1 WB "Tapping the Potential" (2021) — ✅ descargado
**Archivo:** `01_data/raw/wb_reports/WB_Tapping_Potential_2021.pdf` (2.1 MB)
**Acción:** Revisar anexos metodológicos y tablas de gasto — reporte WB Bolivia 2021 que extiende análisis hasta 2018.
**Output esperado:** Datos de gasto agrop 2009-2018 posiblemente citados/tabulados.

### 1.2 Boletín de Estadísticas Fiscales ETA y UP 2022 — ✅ descargado
**Archivo:** `01_data/raw/mefp/boletin_eef_eta_2022.pdf` (4.4 MB, 218 pág)
**Hallazgo crítico:** Contiene series 2009-2022 de deudas y ejecución por sector, incluyendo AGROPECUARIO, desagregado por gobiernos autónomos departamentales.
**Acción inmediata:** Extraer los Cuadros N° 34, 41, 41a y tablas afines a ejecución agropecuaria.

### 1.3 Descargar boletines anuales previos (2017-2021, 2023-2024)
**URLs a probar** (patrón MEFP):
```
https://www.economiayfinanzas.gob.bo/sites/default/files/{YEAR}-{MM}/BOLETIN*ESTADISTICAS*FISCALES*{YEAR-1}.pdf
```
**Acción:** Script de búsqueda sistemática en dominio MEFP con `curl -k` (SSL bypass requerido).

### 1.4 Datos Abiertos Bolivia (datos.gob.bo)
**Acción:** Buscar dataset "ejecución presupuestaria" y "gasto público" — algunos datasets pueden tener formato Excel/CSV descargable.
```bash
# Búsqueda API
curl -k "https://datos.gob.bo/api/3/action/package_search?q=presupuesto"
```

### 1.5 SIGEP portal público (portal.sigep.gob.bo)
**Acción:** Explorar si existe consulta pública sin login. Documentación disponible sin auth: clasificadores, manuales, directrices.

### 1.6 UDAPE Diagnóstico Agropecuario 2023 — ✅ descargado
**Archivo:** `01_data/raw/mefp/udape_agropecuario_2023.pdf` (1.1 MB)
**Acción:** Revisar tablas de gasto público citadas en el documento (fuente de datos + años).

### 1.7 IFPRI ASTI Bolivia 2023 — ✅ descargado
**Archivo:** `01_data/raw/ifpri_speed/ASTI_Bolivia_Factsheet_2023.pdf` (757 KB)
**Cobertura:** Gasto I+D agrícola 2009-2013 (detallado), tendencias hasta 2020.
**Output:** Datos de gasto en investigación agrícola por institución (INIAF, universidades, CIAT, etc.).

### 1.8 BCB Boletín Económico (dossier)
**URL:** https://www.bcb.gob.bo/?q=pub_boletin-estadistico
**Acción:** Descargar últimos 5 boletines anuales con sección "Sector Público No Financiero" — tienen series de gasto consolidado.

---

## TIER 2 — Paralelo, medio plazo (1-3 semanas, alta probabilidad)

### 2.1 Solicitud formal de información al MEFP (DS 28168)
**Plantilla:** Ver `10_siif_request_letter.md` (generado abajo).
**Destinatario:** Unidad de Transparencia del MEFP, con copia a DGSGIF y Viceministerio de Presupuesto.
**Plazo legal:** 15 días hábiles.
**Canal:** Correo electrónico formal con acuse de recibo + formulario físico si posible.

### 2.2 World Bank BOOST Data Lab
**URL:** https://www.worldbank.org/en/programs/boost-portal/boost-data-lab
**Acción:**
1. Registrarse en el portal
2. Verificar si Bolivia tiene BOOST actualizado post-2008 (algunos países WB tienen BOOST 2020+)
3. Si existe, descargar Excel con ejecución por clasificación funcional/económica
**Contacto:** boost@worldbank.org

### 2.3 Contacto directo con equipo WB Bolivia
**Contactos prioritarios identificados:**
- **Svetlana Edmeades** — Senior Agricultural Economist, WB LCSAR (autora de "Tapping the Potential" 2021)
- **Camille Nuamah** — WB Bolivia Country Manager (nombrada julio 2024)
- **Equipo Global Agriculture Practice LAC** — worldbank.org/en/country/bolivia
**Pregunta clave:** ¿Existe extensión del APER 2011 internamente? ¿Datos SIGMA/SIGEP a los que tienen acceso?

### 2.4 Fundación Jubileo Bolivia
**URL:** https://jubileobolivia.com/
**Antecedente:** Ha publicado análisis detallados de presupuesto 2009-2023 usando datos SIGMA/SIGEP.
**Acción:** Correo formal solicitando colaboración técnica / acceso a base de datos compilada.
**Publicación referencia:** "Serie Control Social al Presupuesto" (anual).
**Contacto:** info@jubileobolivia.com

### 2.5 CEDLA Bolivia (Centro de Estudios para el Desarrollo Laboral y Agrario)
**URL:** https://cedla.org/
**Especialización:** Política pública agraria, inversión estatal.
**Valor agregado:** Pueden tener dataset compilado de gasto agropecuario 2009-2023 usado en sus estudios.

### 2.6 PEFA Bolivia 2025 — ✅ descargado
**Archivo:** `01_data/raw/mefp/PEFA_Bolivia_2025.pdf` (5.2 MB)
**Acción:** Extraer indicadores PI-4 (clasificación presupuestaria), PI-5 (documentación), PI-7 (transparencia) que describen qué datos SIGEP están públicamente accesibles.

### 2.7 IDB Bolivia Country Office
**Contacto:** https://www.iadb.org/en/who-we-are/country-offices/bolivia
**Antecedente:** Programa 2024 de US$62M con MEFP para sostenibilidad fiscal — tienen acceso directo a SIGEP.
**Acción:** Contactar al líder del programa; pueden compartir datos agregados del sector agropecuario.

---

## TIER 3 — Fuentes complementarias (datos paralelos, no reemplazan SIIF)

### 3.1 IFPRI SPEED Database 2019
**URL:** https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/F7IOM7
**Cobertura:** Gasto público por sector, 147 países, 1980-2017
**Bolivia:** Incluida con categoría "Agriculture"
**Formato:** CSV descargable sin registro.

### 3.2 IDB Agrimonitor
**URL:** https://agrimonitor.iadb.org/
**Cobertura:** Bolivia SÍ incluida, estimaciones PSE y gasto gubernamental en apoyo a productores.
**Formato:** Base de datos interactiva con descarga.
**Uso:** Validación del nivel agregado de gasto + benchmarking LAC.

### 3.3 IMF Government Finance Statistics
**URL:** https://data.imf.org/en?sk=a0867067-d23c-4ebc-ad23-d3b015045405
**Cobertura:** Bolivia, clasificación COFOG (incluye "Agriculture, forestry, fishing and hunting" código 04.2)
**Formato:** Base de datos con API.
**Limitación:** Datos agregados, no desglose por institución.

### 3.4 IMF Article IV Consultations Bolivia (2018-2025)
**URLs:** https://www.imf.org/en/Countries/BOL
**Contenido:** Tablas fiscales con % gasto por sector; menciones explícitas a SIGMA/SIGEP y calidad de datos.

### 3.5 CEPALSTAT
**URL:** https://statistics.cepal.org/portal/cepalstat/
**Dataset relevante:** "Gasto público en agricultura como % del PIB"
**Cobertura:** LAC incluyendo Bolivia, series 2000-2022.

### 3.6 Leyes de Presupuesto General del Estado (PGE) 2009-2023
**URL maestra:** http://www.gacetaoficialdebolivia.gob.bo/normas/buscar_comp/PGE
**Contenido:** Presupuesto **aprobado** (no ejecutado) por cada entidad del Estado, anual.
**Estrategia:** Descargar los 15 PGE, extraer asignación a MDRyT, INIAF, SENASAG, EMAPA, SEDAG, INRA, etc.
**Ventaja:** Da el techo presupuestario; combinado con tasas de ejecución genera aproximación de gasto ejecutado.

### 3.7 Papers académicos que citan SIGMA/SIGEP
**Búsqueda:** Google Scholar: `Bolivia "SIGMA" OR "SIGEP" OR "SIIF" 2015..2024`
**Objetivo:** Identificar investigadores que obtuvieron la base y contactarlos (muchos comparten datos por transparencia académica).
**Repositorios a revisar:** Harvard Dataverse, ICPSR, journal supplementary materials.

---

## TIER 4 — Extracción automatizada (recurso último)

### 4.1 Scraping de Gaceta Oficial
**Metodología:**
1. Descargar los 15 PDFs del PGE (2009-2023)
2. Aplicar OCR si son escaneados (tesseract + pdftools en R)
3. Parsear tablas de "Entidades del Sector Público" filtrando por sector agropecuario
4. Reconstruir panel de presupuesto aprobado + modificado

### 4.2 Reportes anuales institucionales (MDRyT, INIAF, SENASAG)
**URLs:**
- https://www.ruralytierras.gob.bo
- https://www.iniaf.gob.bo
- https://www.senasag.gob.bo
**Contenido:** Memorias institucionales con estados financieros.

### 4.3 Portal de transparencia de cada institución
**Obligación legal:** Todas las instituciones públicas deben publicar su POA (Programa Operativo Anual) y estados financieros.
**Acción:** Scraping sistemático de las páginas de transparencia de 8-10 instituciones agro.

---

## Matriz de decisión

| Vía | Tiempo esperado | Probabilidad | Costo | Cobertura temporal |
|-----|----------------|--------------|-------|-------------------|
| 1.2 Boletines MEFP (descargados) | Inmediato | Confirmado | $0 | 2009-2022 (agregado) |
| 1.7 IFPRI ASTI | Inmediato | Confirmado | $0 | 2009-2020 (solo I+D) |
| 2.1 Solicitud formal MEFP | 15 días hábiles | Media-alta | $0 | 2009-2023 (completo) |
| 2.2 BOOST Data Lab | 1-3 días | Incierta | $0 | 2009-2020 posible |
| 2.3 Equipo WB Bolivia | 1-2 semanas | Alta (cliente) | $0 | 2009-2023 (interno) |
| 2.4 Fundación Jubileo | 1-2 semanas | Media-alta | $0 | 2009-2023 (compilado) |
| 3.6 PGE + OCR | 1-2 semanas trabajo | Alta | $0 | 2009-2023 (aprobado) |
| 4.1 Scraping | 2-4 semanas | Media | $0 | Variable |

---

## Plan de acción recomendado (secuencia óptima)

### Semana 1
- [ ] **Hoy**: Extraer tablas agropecuarias del Boletín ETA 2022 ya descargado (acción 1.2)
- [ ] **Hoy**: Descargar los 15 PGE 2009-2023 de Gaceta Oficial (acción 3.6)
- [ ] **Día 2**: Enviar solicitud formal DS 28168 al MEFP (acción 2.1) → reloj de 15 días arranca
- [ ] **Día 2**: Contactar por email a Svetlana Edmeades y al WB Bolivia Country Office (acción 2.3)
- [ ] **Día 3**: Descargar IDB Agrimonitor, IFPRI SPEED, IMF GFS (acciones 3.1-3.4)
- [ ] **Día 3**: Registrar en BOOST Data Lab y explorar (acción 2.2)
- [ ] **Día 4**: Email a Fundación Jubileo y CEDLA (acciones 2.4-2.5)
- [ ] **Día 5**: Scraping de boletines MEFP históricos con `curl -k`

### Semana 2
- [ ] Procesar PGE con pdftools (tablas de entidades sector agropecuario)
- [ ] Consolidar datos de fuentes Tier 1 y 3 en panel paralelo al APER
- [ ] Seguimiento a contactos WB/Jubileo/CEDLA

### Semana 3
- [ ] Fecha límite respuesta MEFP (día 15 hábil)
- [ ] Si no responde → escalar con Viceministerio de Transparencia + réplica formal
- [ ] Triangulación entre fuentes: Tier 1 (boletines) + Tier 2 (MEFP oficial) + Tier 3 (secundarias)

---

## Contactos identificados para follow-up

| Contacto | Institución | Rol | Acción |
|----------|-------------|-----|--------|
| Svetlana Edmeades | WB LCSAR | Sr. Agricultural Economist, autora Tapping Potential | Email directo |
| Camille Nuamah | WB Bolivia | Country Manager desde jul 2024 | Via oficina Bolivia |
| Unidad Transparencia MEFP | MEFP | Responsable DS 28168 | Carta formal |
| DGSGIF MEFP | MEFP | Sistema SIGEP | Correo institucional |
| Fundación Jubileo | Sociedad civil | Analistas presupuestales | info@jubileobolivia.com |
| CEDLA | Sociedad civil | Política agraria | Via web |
| IDB Bolivia | Oficina país | Programa fiscal US$62M con MEFP | Via country office |

---

## Argumentos para la solicitud formal

1. **Legitimidad institucional:** Estudio financiado por el Banco Mundial, contraparte histórica de Bolivia en política fiscal y agropecuaria.
2. **Continuidad con trabajo previo:** Actualización del APER 2011 publicado originalmente con datos del propio MEFP.
3. **Marco legal:** Artículo 21.6 de la Constitución Política del Estado (derecho a información) + DS 28168.
4. **Datos solicitados son rutinariamente publicados:** Información ya disponible en múltiples boletines y reportes oficiales; no es información reservada.
5. **Contribución al interés público:** Análisis que servirá para mejorar asignación de recursos en sector rural prioritario del Modelo Económico Social Comunitario Productivo.

---

**Siguiente archivo:** `10_siif_request_letter.md` (carta formal lista para enviar)
