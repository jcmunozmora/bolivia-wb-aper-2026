# 12_REPRODUCIBILIDAD.md — Manifiesto técnico de reproducibilidad

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/12_REPRODUCIBILIDAD.md`
**Marco de referencia:** ACM Artifact Review (Functional / Reusable / Available), FAIR data principles, The Turing Way.
**Lecturas relacionadas:** [`01_METODOLOGIA.md`](01_METODOLOGIA.md), [`02_INDICADORES.md`](02_INDICADORES.md), [`03_FUENTES.md`](03_FUENTES.md), [`08_CONTROL.md`](08_CONTROL.md), [`09_AUDITORIA.md`](09_AUDITORIA.md), [`15_SEGURIDAD.md`](15_SEGURIDAD.md).

> Una cifra que no se puede reconstruir desde cero en una máquina limpia, en cinco años, no es una cifra del APER 2026.

---

## 1. Principio rector

Cuatro afirmaciones operativas:

1. **End-to-end reproducible.** Un solo comando reconstruye todo: panel, figuras, tablas, book, web, slides.
2. **Snapshots inmutables.** Las fuentes crudas no se sobreescriben; cada descarga lleva fecha y checksum.
3. **Entorno declarado.** Versión de R, Quarto, Pandoc y dependencias de sistema están pinneadas; no se asume que "el último funciona".
4. **Archivo de larga duración.** En 5 años, otra persona puede reconstruir el reporte usando este archivo + el repo + Zenodo.

---

## 2. Stack técnico canónico

```text
SISTEMA OPERATIVO de desarrollo:
  - macOS 12+ / Linux Ubuntu 22.04+ (Windows vía WSL2 soportado pero
    no de primera clase para el equipo APER).

LENGUAJE PRINCIPAL:
  - R, versión 4.3.x   (pinned: ver renv.lock)
                       (target: 4.4 cuando el ecosistema se estabilice
                        post-2026)

PAQUETES R:
  - administrados con renv (lockfile en renv.lock)
  - todas las versiones pinneadas
  - mirror CRAN snapshot del MRAN o Posit Public Package Manager para
    estabilidad temporal

DOCUMENTACIÓN Y RENDER:
  - Quarto, versión 1.4.x         (pinned: ver _quarto.yml de cada projecto)
  - Pandoc (viene con Quarto)
  - LaTeX vía TinyTeX (vía R)

GEO Y MAPAS:
  - GDAL ≥ 3.6
  - PROJ ≥ 9.0
  - sf (R) sobre GEOS

INFRAESTRUCTURA OPCIONAL:
  - GitHub para versionamiento y CI
  - GitHub Pages para sitio público
  - Zenodo para deposit del release

PYTHON (opcional, solo si Quarto chunks lo invocan):
  - Python 3.11+
  - dependencias en `requirements.txt` o `environment.yml`

NO USADO en v1 del APER:
  - Jupyter notebooks (Quarto cubre la necesidad)
  - Docker (descrito como opción §10; no obligatorio en v1)
```

### 2.1. Versiones canónicas para release del APER 2026

```yaml
canonical_stack:
  R: "4.3.3"               # [TODO_TRACE: confirmar versión del equipo]
  quarto: "1.4.555"        # [TODO_TRACE]
  pandoc: "3.1.11"         # [TODO_TRACE — viene con Quarto]
  tinytex: "current"       # [TODO_TRACE: snapshot date]
  python: "3.11.7"         # [TODO_TRACE: si usado]
  os_dev_target: "macOS 14 / Ubuntu 22.04"
  renv_snapshot_date: "[TODO_TRACE: fecha del último renv::snapshot()]"
```

Estas versiones se congelan en cada release (A5) y se reportan en el README del repo + en el coloquio bibliográfico del book.

---

## 3. Comando único de rebuild

Objetivo: una persona con el repo clonado, en una máquina limpia con el stack canónico, ejecuta **un comando** y obtiene el book + web + slides + outputs idénticos al release.

### 3.1. Script propuesto `scripts/rebuild_everything.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

# === APER 2026 — End-to-end rebuild ===
# Reproduce panel v12, figuras, tablas, book, web y slides desde cero.
# Pre-requisitos: stack canónico §2.1 instalado; repo clonado.

# 1. Restore renv (paquetes R pinneados)
Rscript -e 'renv::restore(prompt = FALSE)'

# 2. Ingesta y construcción del panel
Rscript 02_code/01_ingest/RUN_ALL.R       # descarga / lee fuentes crudas
Rscript 02_code/02_clean/RUN_ALL.R        # limpieza
Rscript 02_code/03_construct/RUN_ALL.R    # produce 01_data/processed/spending_panel_v12.rds

# 3. Análisis derivado
Rscript 02_code/04_analysis/RUN_ALL.R     # PSE, brechas, scenarios

# 4. Figuras y tablas
Rscript 02_code/05_figures/RUN_ALL.R      # produce 05_outputs/figures/*
Rscript 02_code/06_tables/RUN_ALL.R       # produce 05_outputs/tables/*

# 5. Render del book
cd 04_report && quarto render
cd ..

# 6. Render del sitio público
cd www && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 quarto render
cd ..

# 7. Render de slides
cd slides && quarto render
cd ..

# 8. Verificación de outputs (checksum vs release de referencia)
Rscript scripts/audit_outputs_checksums.R

echo "✓ Rebuild completo. Outputs en 05_outputs/, 04_report/_book/, www/, slides/_site/"
```

### 3.2. Hooks `RUN_ALL.R` por subcarpeta

Cada subcarpeta de `02_code/` tiene un `RUN_ALL.R` que invoca los scripts numerados de esa subcarpeta en orden:

```r
# 02_code/03_construct/RUN_ALL.R
source(here::here("02_code/03_construct/01_normalize_boost.R"))
source(here::here("02_code/03_construct/02_classify_functional_economic.R"))
source(here::here("02_code/03_construct/03_compose_public_vs_private.R"))
source(here::here("02_code/03_construct/04_territorialize.R"))
source(here::here("02_code/03_construct/05_link_indicators.R"))
source(here::here("02_code/03_construct/06_build_panel_v12.R"))
```

### 3.3. Makefile alterno (para usuarios que prefieran make)

```makefile
.PHONY: all panel figures tables book web slides verify clean

all: panel figures tables book web slides verify

panel:
	Rscript -e 'renv::restore(prompt = FALSE)'
	Rscript 02_code/01_ingest/RUN_ALL.R
	Rscript 02_code/02_clean/RUN_ALL.R
	Rscript 02_code/03_construct/RUN_ALL.R
	Rscript 02_code/04_analysis/RUN_ALL.R

figures:
	Rscript 02_code/05_figures/RUN_ALL.R

tables:
	Rscript 02_code/06_tables/RUN_ALL.R

book:
	cd 04_report && quarto render

web:
	cd www && LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 quarto render

slides:
	cd slides && quarto render

verify:
	Rscript scripts/audit_outputs_checksums.R

clean:
	rm -rf 04_report/_book www/_site slides/_site 05_outputs/figures 05_outputs/tables
```

---

## 4. Snapshot policy

### 4.1. Fuentes crudas (`01_data/raw/`)

```text
- inmutables tras descarga
- versionadas por subcarpeta: 01_data/raw/<fuente>/YYYY_MM_DD/
  o por release con timestamp en el filename
- cada subcarpeta lleva CHECKSUMS.md con SHA-256 de todos los archivos
- nuevas descargas no sobreescriben: van a nueva subcarpeta con su fecha
```

Excepción: archivos de gran tamaño no versionables en git. Para esos:

- entran en `.gitignore`
- se documenta su path esperado en `03_FUENTES.md` por fuente
- backup en OneDrive o Zenodo (`15_SEGURIDAD.md`)

### 4.2. Panel procesado (`01_data/processed/spending_panel_v<n>.rds`)

```text
- una versión por release: panel_v12 (actual), panel_v13 (futura), ...
- versiones previas NO se borran
- diccionario sincronizado en spending_panel_v<n>_dictionary.csv
- cada versión declara su origen (panel_version + methodology_version)
  en metadato interno del RDS
```

### 4.3. Outputs publicados (`05_outputs/`)

```text
- versionados por release tag de git (v1.0.0, v1.1.0, ...)
- cada release tiene su DOI Zenodo (13_PUBLICACION.md §6)
- CHECKSUMS.md por release
```

### 4.4. Snapshots con `renv::snapshot()`

```text
- renv::snapshot() se ejecuta antes de cada A3 (capítulo cierra reviewed)
- el lockfile se commitea
- el lockfile se cita en el release (versión + fecha del snapshot)
```

---

## 5. Verificación de reproducibilidad

### 5.1. Checklist por release (A5)

```text
[ ] Repo clonado en máquina limpia (sin .Rprofile ni .Renviron del usuario)
[ ] renv::restore() exitoso sin warnings
[ ] scripts/rebuild_everything.sh termina sin error
[ ] panel_v12.rds reproducido = checksum del panel publicado
[ ] cada figura PNG reproducida = checksum del PNG publicado
    (o tolerancia razonable si hay variación de plotting backend)
[ ] cada tabla reproducida = idéntica al CSV/HTML publicado
[ ] book renderiza sin warnings
[ ] sitio web renderiza sin warnings
[ ] slides renderizan sin warnings
[ ] glosario y referencias bibliográficas se resuelven
[ ] versión de R, Quarto, Pandoc declaradas en el README del release
[ ] DOI Zenodo del release asignado y verificado
```

### 5.2. Test recurrente (no solo en release)

**Cada 4 semanas** durante el ciclo del reporte, un miembro del equipo distinto del desarrollador principal corre el rebuild en máquina limpia. Resultado se registra en `00_admin/repro_test_YYYY_MM_DD.md`.

### 5.3. Tolerancias

Tipos de diferencia entre rebuilds, con su tratamiento:

| Tipo de diferencia | Tratamiento |
|---|---|
| Cifra en RDS / CSV idéntica | OK |
| Cifra en RDS con diferencia < 0.01% (floating point) | OK con nota |
| Cifra con diferencia ≥ 0.01% | **FALLO** — investigar; bug del pipeline |
| PNG con diferencia visual a ojo desnudo | **FALLO** — investigar |
| PNG con diferencia binaria pero visual idéntica | OK (diferencia de backend) |
| PDF book con paginación cambiada | OK si contenido idéntico |
| HTML con cambio de orden de elementos | **FALLO** — investigar |

---

## 6. Larga duración (5+ años)

### 6.1. Riesgos a la reproducibilidad de largo plazo

```text
- paquetes R desaparecen de CRAN
- versiones de paquetes cambian comportamiento sin advertencia
- Quarto / Pandoc rompen compatibilidad
- versiones de R obsoletas no se instalan en sistemas modernos
- fuentes externas cambian o desaparecen
- repositorios upstream se mueven o cierran
```

### 6.2. Mitigaciones canónicas

```text
1. renv lockfile commiteado con todas las versiones
2. Tarballs de paquetes críticos archivados en .agent/legacy/r_packages/
   (si CRAN los retira)
3. Snapshot de fuentes crudas en Zenodo (DOI por release)
4. Imagen Docker opcional pero recomendada para releases mayores:
   .agent/docker/Dockerfile + tag por release
5. Documentación del entorno completo:
   sessionInfo() del rebuild final archivado en
   00_admin/release_<vX.Y.Z>/sessionInfo.txt
6. Trabajo bajo The Turing Way "Long-Term Reproducibility" guidelines.
```

### 6.3. Plan de archivo

Al cierre del APER 2026 (v1.0.0):

```text
Zenodo deposit  : repo completo (sin .agent/coi/ y otros restringidos)
                  + panel v12 RDS + CSV + diccionario
                  + outputs publicados (book PDF, briefs, slides)
                  + sessionInfo()
                  + Docker image (opcional)
                  + renv.lock
                  → DOI asignado

GitHub release  : tag v1.0.0
                  + release notes
                  + checksums de outputs

OneDrive backup : copia local del Zenodo deposit
                  + 01_data/raw/ completo
                  + COI y minutas (privadas)
```

---

## 7. Docker (opcional para release final)

```dockerfile
# .agent/docker/Dockerfile (esqueleto v0.1.0)
FROM rocker/r-ver:4.3.3

# system deps
RUN apt-get update && apt-get install -y \
    libgdal-dev libproj-dev libgeos-dev \
    libxml2-dev libssl-dev libcurl4-openssl-dev \
    pandoc git \
 && rm -rf /var/lib/apt/lists/*

# Quarto
RUN curl -fsSL https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.555/quarto-1.4.555-linux-amd64.deb \
    -o /tmp/quarto.deb \
 && dpkg -i /tmp/quarto.deb \
 && rm /tmp/quarto.deb

WORKDIR /aper
COPY renv.lock renv.lock
COPY .Rprofile .Rprofile
COPY renv/activate.R renv/activate.R

RUN R -e 'renv::restore()'

COPY . .

CMD ["bash", "scripts/rebuild_everything.sh"]
```

Uso:

```bash
docker build -t aper2026:v1.0.0 -f .agent/docker/Dockerfile .
docker run --rm -v $(pwd)/output:/aper/05_outputs aper2026:v1.0.0
```

> Decisión sobre Docker: **opcional en v0.x**, **recomendado en release final v1.0.0**.

---

## 8. CI/CD reproducibility gates

Cuando se implemente CI (`.github/workflows/`), gates obligatorios:

```text
on: pull_request

jobs:
  reproduce_panel:
    runs-on: ubuntu-22.04
    steps:
      - checkout
      - setup R 4.3.3
      - setup Quarto 1.4.x
      - renv::restore()
      - run RUN_ALL.R scripts
      - diff panel_v12 output vs panel_v12 commited
      - fail if differences exceed tolerance §5.3

  render_book:
    runs-on: ubuntu-22.04
    needs: reproduce_panel
    steps:
      - quarto render 04_report
      - fail if warnings

  render_web:
    needs: reproduce_panel
    steps:
      - LANG=en_US.UTF-8 quarto render www
      - fail if warnings

  bilingual_parity:
    needs: render_book
    steps:
      - Rscript scripts/audit_bilingual.R
      - fail if parity broken

  anti_ai_scan:
    needs: render_book
    steps:
      - Rscript scripts/audit_anti_ai.R
      - fail if AI-likelihood > thresholds (ESTILO §3.10)
```

Detalle de gates en [`08_CONTROL.md`](08_CONTROL.md) §9.

---

## 9. Datos abiertos del panel v12

Política propuesta (validar con MEFP — ver `13_PUBLICACION.md` §8):

```text
- Panel v12 se publica simultáneamente con el reporte.
- Formato: CSV + RDS + parquet (los 3 para máxima portabilidad).
- Diccionario incluido (spending_panel_v12_dictionary.csv).
- Scripts de construcción incluidos.
- Fuentes crudas: enlace a fuentes originales (no re-distribución salvo
  que la licencia lo permita y aporte valor — ver 03_FUENTES.md §9).
- Licencia del panel: CC-BY 4.0 (atribución a "WB Bolivia APER 2026").
- DOI Zenodo del panel separado del DOI del reporte.
```

Excepciones: subsets con datos sensibles del MEFP que solicitan no publicación. Se documenta en appendix del book + `14_CONFIDENCIALIDAD.md`.

---

## 10. Cómo escribir un script reproducible

Convenciones para todo script R nuevo en `02_code/`:

```r
#' Script: <nombre>.R
#' Propósito: <una frase>
#' Inputs: <RDS, CSV, paths>
#' Outputs: <RDS, CSV, paths>
#' Linked finding(s): F0X (si aplica)
#' Linked figure(s): fig_NN_MM_<slug> (si aplica)
#' Author: <nombre>
#' Last review: YYYY-MM-DD

# === setup ===
library(here)
library(tidyverse)
library(arrow)
# (NUNCA: setwd() — usar here::here() siempre)

# === inputs ===
panel <- readRDS(here("01_data/processed/spending_panel_v12.rds"))

# === procesamiento ===
# (idempotente — correr dos veces produce el mismo output)
out <- panel %>%
  filter(year >= 2015, year <= 2023) %>%
  ...

# === outputs ===
saveRDS(out, here("01_data/processed/<output_name>.rds"))

# === metadata ===
attr(out, "panel_version")       <- "v12"
attr(out, "methodology_version") <- "m0.1.0"
attr(out, "script_path")         <- "02_code/04_analysis/<nombre>.R"
attr(out, "generated_at")        <- Sys.time()

# === verification (opcional pero recomendado) ===
stopifnot(nrow(out) > 0)
stopifnot(!any(is.na(out$year)))
```

Reglas:

```text
- nunca setwd(); usar here::here()
- nunca install.packages() en el script; las versiones vienen de renv
- nunca leer / escribir fuera del repo
- nunca hardcodear rutas absolutas del usuario
- siempre declarar paquetes con library() explícito
- siempre escribir outputs con set.seed() si hay randomness
- siempre validar inputs con stopifnot() o assertthat
```

---

## 11. Cómo modificar este archivo

| Cambio | Color |
|---|---|
| Actualizar versiones canónicas §2.1 | ROJO + ADR (afecta reproducibilidad) |
| Cambiar el comando rebuild §3 | ROJO + ADR + verificar en máquina limpia |
| Agregar gate CI §8 | AMARILLO |
| Cambiar política de Docker | AMARILLO si activa Docker en v1; ROJO si lo retira tras adopción |
| Cambiar política de datos abiertos §9 | ROJO + ADR + consulta MEFP |
| Mejorar plantilla §10 | AMARILLO |

---

## 12. TODOs para alcanzar v1.0

- [ ] Confirmar versión exacta de R, Quarto, Pandoc en uso (`[TODO_TRACE]` de §2.1).
- [ ] Implementar `scripts/rebuild_everything.sh` y `Makefile`.
- [ ] Crear `RUN_ALL.R` por cada subcarpeta de `02_code/`.
- [ ] Implementar `scripts/audit_outputs_checksums.R`.
- [ ] Generar `01_data/raw/<fuente>/CHECKSUMS.md` por cada fuente (FUENTES §8).
- [ ] Primer test recurrente de reproducibilidad en máquina limpia (§5.2).
- [ ] Decidir adopción de Docker para v1.0.0 (sí/no).
- [ ] Plan de Zenodo deposit con la unidad de soporte WB.
- [ ] Política de datos abiertos consultada con MEFP.

---

## 13. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: stack canónico R 4.3.x + Quarto 1.4.x, comando único `rebuild_everything.sh` + Makefile alterno, snapshot policy (fuentes/panel/outputs/renv), checklist de reproducibilidad A5, plan de larga duración 5+ años con Zenodo, Docker opcional, CI gates, datos abiertos del panel v12 propuestos, plantilla de script reproducible |
