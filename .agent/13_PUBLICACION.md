# 13_PUBLICACION.md — Estrategia de publicación, licencias y citación

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/13_PUBLICACION.md`
**Marco de referencia:** WB Open Knowledge Repository, FAIR principles, Creative Commons, Zenodo deposit best practices, ICMJE/Vancouver authorship.
**Lecturas relacionadas:** [`11_EQUIPO.md`](11_EQUIPO.md), [`12_REPRODUCIBILIDAD.md`](12_REPRODUCIBILIDAD.md), [`14_CONFIDENCIALIDAD.md`](14_CONFIDENCIALIDAD.md), [`16_INCIDENTES.md`](16_INCIDENTES.md), [`09_AUDITORIA.md`](09_AUDITORIA.md) A5.

> El reporte se publica una sola vez. Cómo se publica define cómo se usa los próximos 10 años.

---

## 1. Principio rector

Cuatro afirmaciones:

1. **Publicación es un acto técnico, no comercial.** No se "lanza" — se libera con todo su aparato de trazabilidad.
2. **Cita única, formato canónico.** Cualquier persona que cite el APER 2026 lo hace de la misma forma.
3. **Datos y código se publican con el reporte.** Sin reproducibilidad, la publicación no califica para release.
4. **MEFP recibe antes que el público.** Embargo y mesa técnica final son obligatorios pre-publicación.

---

## 2. Productos publicables

El APER 2026 produce un **paquete de release**, no un único documento.

### 2.1. Tabla de productos

| # | Producto | Formato | Audiencia | Versionado | Path |
|---|---|---|---|---|---|
| P1 | **Quarto book técnico** | PDF + HTML | Técnica + MEFP + WB internal | `vX.Y.Z` | `04_report/_book/` |
| P2 | **Sitio público** | HTML responsive | Pública general + medios | mismo tag que P1 | `www/_site/` → GitHub Pages |
| P3 | **Slides ejecutivas** | PDF + reveal.js | MEFP, eventos, prensa | mismo tag | `slides/_site/` |
| P4 | **Executive summary bilingüe** | PDF 8–12 p | MEFP + WB management + medios | mismo tag | `05_outputs/exec_summary_es.pdf` + `_en.pdf` |
| P5 | **Briefs temáticos** (opcional, hasta 8) | PDF 4–6 p | audiencias específicas (un brief por hallazgo) | mismo tag o subversión | `05_outputs/briefs/F0X.pdf` |
| P6 | **Panel v12 dataset** | CSV + RDS + parquet | comunidad académica + analistas | DOI propio | `05_outputs/data/panel_v12_release_<tag>/` |
| P7 | **Diccionario del panel** | CSV + MD legible | acompaña P6 | mismo DOI que P6 | `05_outputs/data/panel_v12_dictionary.csv` |
| P8 | **Scripts reproducibles** | Repo git público | reviewers + replicators | tag git | `02_code/` + Zenodo deposit |
| P9 | **Notas metodológicas** (apéndice) | parte del book | técnica | parte de P1 | `04_report/appendix/` |
| P10 | **Cartas / comunicaciones a MEFP** | PDF | MEFP + archivo interno | n/a (no público) | `00_admin/cartas/` (privado) |

### 2.2. Productos NO publicables (privados)

```text
- borradores intermedios (RETOMAR.md, mesas técnicas pre-A4)
- declaraciones de COI (14_CONFIDENCIALIDAD.md)
- minutas de mesa técnica MEFP
- comentarios MEFP no anonimizados
- datos crudos con restricciones de licencia
- comunicaciones internas WB
```

---

## 3. Cronograma típico de release

Calendario relativo al evento `T-0 = publicación pública`.

```text
T-16 semanas  preparación de A5 release audit
              cierre conjunto de fuentes (no se incorporan fuentes nuevas)
              consolidación de los 8 hallazgos en estado `reviewed`

T-12 semanas  A4 pre-handoff MEFP del executive summary y capítulos clave
              mesa técnica MEFP — primera ronda

T-8 semanas   incorporación de comentarios MEFP
              ajuste de hallazgos según mesa
              segunda ronda mesa técnica si necesaria

T-6 semanas   bloqueo de cifras (data freeze)
              foco en redacción y revisión cruzada book ↔ web ↔ slides

T-4 semanas   handoff final al MEFP (versión que se publicará)
              periodo de embargo MEFP comienza
              EMBARGO: el MEFP recibe el producto final; equipo APER NO
              comunica públicamente

T-2 semanas   A5 release audit completa
              último diff reproducibilidad en máquina limpia
              Zenodo deposit preparado (no publicado todavía)

T-1 semana    coordinación final con WB Communications
              Q&A canónico para medios (19_COMUNICACION.md)
              tag git y release de prueba

T-0           PUBLICACIÓN
              - GitHub release con tag vX.Y.Z
              - sitio público live
              - Zenodo deposit activado (DOI asignado)
              - notificación pública MEFP-WB
              - distribución de briefs

T+1 semana    monitoreo de recepción
              respuesta a preguntas vía canal canónico
              tracking de citas y descargas

T+4 semanas   primera evaluación post-publicación
              identificación de errata si aplica (16_INCIDENTES)

T+12 semanas  cierre formal del ciclo del APER 2026
              archivo en .agent/legacy/ del estado pre-release
              kick-off planificación próximo ciclo (si aplica)
```

---

## 4. Embargo MEFP

### 4.1. Definición

**Embargo** es el periodo entre el handoff final al MEFP (versión que se publicará) y la publicación pública. Durante el embargo:

- el MEFP tiene acceso exclusivo a la versión final;
- el equipo APER **NO** comunica públicamente sobre los hallazgos del reporte;
- el MEFP puede revisar sin presión mediática.

### 4.2. Duración

```text
estándar: 4 semanas
mínimo:   2 semanas (solo si el MEFP lo aprueba explícitamente)
máximo:   8 semanas (si el MEFP solicita extensión justificada)
```

### 4.3. Qué pasa durante el embargo

```text
- el MEFP puede solicitar última revisión técnica de cifras (no de
  interpretación — esa ventana cerró en A4)
- el equipo APER puede ajustar typos, formato, alt-text, sin cambiar claims
- cambios sustantivos durante el embargo disparan ROJO + ADR + extensión
  del embargo automáticamente
- comunicaciones públicas suspendidas; sí pueden continuar coordinaciones
  internas WB y técnicas
```

### 4.4. Fin del embargo

```text
- en la fecha T-0 acordada
- O cuando el MEFP da liberación temprana por escrito
- O por decisión TTL + WB Country Manager si el MEFP no responde y se
  cumplen 8 semanas
```

---

## 5. Licencias

### 5.1. Decisión del proyecto (v0.1.0)

| Producto | Licencia | Notas |
|---|---|---|
| Reporte (book P1, web P2, slides P3, exec summary P4, briefs P5) | **CC-BY 4.0** | Atribución "World Bank — APER Bolivia 2026" |
| Panel v12 dataset (P6) + diccionario (P7) | **CC-BY 4.0** | Atribución idéntica + cita al DOI del panel |
| Scripts (P8) | **MIT** | Compatible con CC-BY del contenido |
| Notas metodológicas (P9, parte del book) | **CC-BY 4.0** | hereda del book |

### 5.2. Atribución requerida

```text
Texto canónico para reuso del REPORTE:

  "Source: World Bank. 2026. Bolivia: Agricultural Public Expenditure
   Review 2026. Washington, DC: World Bank. CC-BY 4.0."

Texto canónico para reuso del PANEL DATASET:

  "Data source: WB Bolivia APER 2026 panel v12, 2026. CC-BY 4.0.
   doi:10.5281/zenodo.<panel_DOI>"

Texto canónico para reuso del CÓDIGO:

  "Code: WB Bolivia APER 2026 scripts, 2026. MIT License.
   https://github.com/<org>/<repo>"
```

### 5.3. Fuentes crudas — limitaciones heredadas

Algunas fuentes crudas usan licencias que **no permiten** redistribución (ver `03_FUENTES.md` §9). Para esas:

- el panel **no incluye los datos crudos**, solo los derivados que la licencia permite;
- los scripts incluyen instrucciones de descarga de la fuente original;
- la atribución de la fuente cruda figura en figuras / tablas / appendix.

Atribuciones obligatorias **dentro** de productos del APER:

```text
MapBiomas Bolivia Col. 3       → "MapBiomas Bolivia (CC-BY)" en caption
FAOSTAT                        → "FAOSTAT (FAO, CC-BY)" en caption
ESA WorldCover                 → "© ESA WorldCover" si imagen incluida
otras fuentes públicas         → según 03_FUENTES.md §9
```

---

## 6. DOI y Zenodo deposit

### 6.1. Estrategia DOI

```text
DOI del REPORTE          → asignado por WB Open Knowledge Repository
                           (formato: 10.1596/<...>)
                           se publica simultáneamente con el book

DOI del PANEL + SCRIPTS  → asignado por Zenodo
                           (formato: 10.5281/zenodo.<NNNNNN>)
                           uno por release del paquete reproducible

DOI por release (futuro) → cada vX.Y.Z tiene su DOI Zenodo
                           el "DOI conceptual" (parent) apunta a la última
                           versión; el "DOI versionado" apunta a una versión
                           específica
```

### 6.2. Zenodo deposit checklist

```text
[ ] Tag git vX.Y.Z creado
[ ] Repo limpiado de archivos no publicables (00_admin/coi/, etc.)
[ ] CITATION.cff actualizado con autores, fecha, versión
[ ] README.md del repo refleja el release
[ ] CHECKSUMS.md generados para outputs publicados
[ ] sessionInfo() archivado en 00_admin/release_<tag>/sessionInfo.txt
[ ] Lockfile renv archivado
[ ] Zenodo metadata completa (título, autores, descripción, palabras clave)
[ ] Zenodo concepts (parent DOI) configurado para versionamiento
[ ] DOI Zenodo recibido y archivado en CITATION.cff
[ ] Citación canónica §7 actualizada con DOI real
```

### 6.3. Política de Zenodo concepts

```text
- Concept DOI (parent): 10.5281/zenodo.<C>  → apunta siempre a la última versión
- Version DOI v1.0.0:   10.5281/zenodo.<V1>
- Version DOI v1.1.0:   10.5281/zenodo.<V2>  (correcciones menores)
- Version DOI v2.0.0:   próximo ciclo APER (si la línea continúa)

Reglas:
- versiones menores (errata, ajustes cosméticos) bumpan patch o minor
- versión mayor (próximo APER) bumpa major y abre concept DOI distinto
```

---

## 7. Citación canónica del reporte

### 7.1. Cita completa (ISO 690 / WB Style)

```text
World Bank. 2026. Bolivia: Agricultural Public Expenditure Review 2026.
Washington, DC: World Bank. License: CC-BY 4.0.
doi:10.1596/<XXXXX>   |   github.com/<org>/<repo>   |   zenodo: 10.5281/zenodo.<XXXXXX>
```

### 7.2. Cita corta (en otros documentos)

```text
World Bank (2026), Bolivia APER 2026.
```

### 7.3. BibTeX

```bibtex
@techreport{wb_aper_bolivia_2026,
  title       = {Bolivia: Agricultural Public Expenditure Review 2026},
  author      = {{World Bank}},
  year        = {2026},
  institution = {World Bank},
  address     = {Washington, DC},
  doi         = {10.1596/XXXXX},
  url         = {https://github.com/<org>/<repo>},
  note        = {CC-BY 4.0}
}
```

### 7.4. Si el equipo decide visibilidad de autores

Alternativa con autores listados (decisión §5.2 de `11_EQUIPO.md`):

```text
[Author 1 (TTL), Author 2 (co-TTL), ...]. 2026. Bolivia: Agricultural Public
Expenditure Review 2026. Washington, DC: World Bank. License: CC-BY 4.0.
doi:10.1596/<XXXXX>.
```

---

## 8. Política de datos abiertos del panel

### 8.1. Decisión propuesta (v0.1.0 — validar con MEFP)

```text
- Panel v12 se publica como dataset abierto simultáneamente con el reporte.
- Formato: CSV (universal) + RDS (R nativo) + parquet (eficiente).
- Diccionario en CSV + Markdown.
- Scripts de construcción en el repo.
- DOI Zenodo independiente del reporte.
- Licencia: CC-BY 4.0.
- Cobertura: 1990–2024 (35 años), 176 variables, nivel nacional.
```

### 8.2. Excepciones (qué NO se publica abierto)

- subsets con restricción de licencia heredada de fuentes que no permiten redistribución;
- variables que MEFP solicite explícitamente no publicar **con justificación trazable**;
- atributos individuales o sub-nacionales que crucen umbrales de identificabilidad (no aplica al panel actual: todo es agregado nacional o departamental con n > 30).

Decisiones de exclusión se documentan en `appendix/data_release_decisions.md` con motivo y fecha.

### 8.3. Plan de actualización del panel publicado

```text
- v12 (release inicial)
- v13 si hay actualización metodológica o nueva fuente sustantiva
  → ADR + nuevo DOI Zenodo + nota visible en sitio público
- versiones previas NO se borran de Zenodo (concepts permite acceso histórico)
```

---

## 9. Voces oficiales y canales de comunicación

Detalle en `19_COMUNICACION.md`. Resumen para publicación:

```text
Vocero oficial:           TTL del APER (primer respondedor a preguntas técnicas)
Vocero alterno:           co-TTL
Comunicaciones WB:        canal institucional (WB Communications - Bolivia)
Mesa técnica MEFP:        única vía para discusión post-publicación con MEFP
Prensa general:           vía WB Communications, NO directo desde equipo
Académica:                TTL + Líder EAFIT pueden responder consultas técnicas
```

---

## 10. Comunicación pública del release

### 10.1. Canales

```text
- página de release en sitio público (www/)
- nota en sitio del WB Bolivia office
- distribución a stakeholders del Círculo 2 y 3 (ver 11_EQUIPO §2)
- redes sociales WB (si Communications lo decide)
- press release coordinado con WB Communications
```

### 10.2. Q&A canónico

Antes del release, preparar `19_COMUNICACION.md` con:

- 10–15 preguntas anticipadas de medios
- respuestas alineadas con NEUTRALIDAD §11 (frase de cierre obligatoria)
- responsable de cada respuesta (vocero oficial vs. alterno)

### 10.3. Lo que NO se comunica

```text
- contenidos pre-embargo
- comentarios MEFP no incorporados al reporte
- juicio sobre actores políticos
- comparaciones implícitas con gobiernos previos / actuales
- predicciones sobre adopción de los escenarios
```

---

## 11. Versionamiento del reporte (post-publicación)

| Versión | Cuándo |
|---|---|
| `v1.0.0` | Release inicial |
| `v1.0.1` | Patch — errata tipográfica, fix de link, ajuste cosmético |
| `v1.1.0` | Minor — incorporación de comentario MEFP post-publicación que no cambia hallazgos; adición de brief temático |
| `v2.0.0` | Major — próximo ciclo APER (típicamente 3–5 años después) |

Cada bump:

- nuevo tag git + nuevo Zenodo deposit
- changelog en repo + en sitio público
- errata visible (si aplica) según `16_INCIDENTES.md`

---

## 12. Integración con otros archivos

| Archivo | Cómo conecta |
|---|---|
| `08_CONTROL.md` | Decide si un cambio post-release es ROJO (necesita ADR) o AMARILLO (errata simple) |
| `09_AUDITORIA.md` | A5 release audit es prerrequisito de publicación |
| `11_EQUIPO.md` | Authorship §5 determina la cubierta del reporte |
| `12_REPRODUCIBILIDAD.md` | Zenodo deposit y CHECKSUMS están en §4, §6 de ese archivo |
| `14_CONFIDENCIALIDAD.md` | Define qué entra al deposit público y qué queda privado |
| `15_SEGURIDAD.md` | Política de backup pre-release |
| `16_INCIDENTES.md` | Errata post-publicación sigue protocolo de incidentes |
| `19_COMUNICACION.md` | Q&A canónico, voceros, crisis comm |

---

## 13. Cómo modificar este archivo

| Cambio | Color |
|---|---|
| Actualizar productos publicables §2 (nuevo brief, nueva pieza) | AMARILLO |
| Cambiar cronograma típico §3 | AMARILLO |
| Cambiar licencia §5 | ROJO + ADR + consulta legal WB |
| Cambiar política de embargo §4 | ROJO + ADR + acuerdo MEFP |
| Cambiar política de datos abiertos §8 | ROJO + ADR + consulta MEFP |
| Cambiar formato de citación canónica §7 | ROJO + ADR |
| Bump del reporte v1.0.0 → v1.0.1 | ROJO si afecta cifra; AMARILLO si solo cosmético |

---

## 14. TODOs para alcanzar v1.0

- [ ] Confirmar con WB Open Knowledge Repository el DOI del reporte (formato `10.1596/...`).
- [ ] Solicitar Zenodo deposit con `WB Bolivia APER` como community.
- [ ] Definir si los autores van en la cubierta (decisión § 11_EQUIPO §5.2).
- [ ] Coordinar con WB Communications Bolivia el press release.
- [ ] Preparar Q&A canónico para medios (alineado con `19_COMUNICACION.md`).
- [ ] Validar política de datos abiertos del panel con MEFP en mesa técnica.
- [ ] Definir fecha tentativa T-0 de release (sujeta a calendario MEFP y elecciones).
- [ ] Confirmar duración del embargo en mesa técnica MEFP.
- [ ] Diseñar página del release en sitio público (www/release/).
- [ ] Verificar `CITATION.cff` actualizado y válido.

---

## 15. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: 10 productos del paquete release, cronograma T-16 → T+12, embargo MEFP 4 semanas estándar, licencias CC-BY 4.0 (reporte+panel) + MIT (código), estrategia DOI dual (WB OKR + Zenodo concepts), citación canónica completa, política de datos abiertos propuesta, voceros, comunicación pública, versionamiento post-publicación |
