# 15_SEGURIDAD.md — Secrets, credenciales, accesos, backups

**Versión:** v0.1.0 · **Última actualización:** 2026-05-23
**Path canónico:** `.agent/15_SEGURIDAD.md`
**Marco de referencia:** OWASP Top 10 (web), CIS Controls v8 (esenciales), 12-factor app (config), WB Information Security policies.
**Lecturas relacionadas:** [`14_CONFIDENCIALIDAD.md`](14_CONFIDENCIALIDAD.md), [`16_INCIDENTES.md`](16_INCIDENTES.md), [`12_REPRODUCIBILIDAD.md`](12_REPRODUCIBILIDAD.md).

> Un credential filtrado nunca vuelve atrás. El daño no se mide en horas: se mide en cuántas semanas tarda rotar todo.

---

## 1. Principio rector

Cuatro afirmaciones:

1. **Nada de secrets en git.** Ni en repo público, ni en repo privado, ni en commits "que después se borran".
2. **Mínimo privilegio.** Cada credencial da el menor acceso suficiente para la tarea.
3. **Rotación periódica.** Las credenciales caducan. No existen credenciales "permanentes".
4. **Backup que se prueba.** Un backup que nunca se restaura no es un backup.

---

## 2. Inventario de secretos posibles del APER

```text
API keys (potenciales — pueden no aplicar todas al APER actual):
  - BCB API token (si se usa para descargas automatizadas)
  - FAOSTAT API (si se automatiza)
  - WB API token (BOOST / WDI)
  - IDB AgriMonitor API (si existe)
  - MapBiomas / Google Earth Engine (para descarga programática)

Credenciales de servicios:
  - GitHub PAT (Personal Access Token) si se hace push automatizado
  - Zenodo API token (para deposit automatizado del release)
  - OneDrive / SharePoint accesos (vía cuenta WB / EAFIT)

Accesos a sistemas:
  - SSH keys a servidores (si hay servidor compartido)
  - Cuentas con MFA al portal WB internal
  - Acceso al sistema SIIF (si MEFP lo provee)

Datos restringidos:
  - micro-datos INE con licencia restringida (si aplica)
  - bases MDRyT recibidas vía MEFP (si aplica tras R-001)
```

> A 2026-05-23: el APER **no opera con muchos secretos**. La mayoría de fuentes son descargas manuales públicas. Este archivo es **preventivo**: si en algún momento se incorporan integraciones automatizadas, las reglas están listas.

---

## 3. `.env` y plantilla canónica

### 3.1. Convención

Variables sensibles viven en **`.env`** en la raíz del proyecto. Nunca commiteadas. Una plantilla pública `.env.template` documenta qué variables se necesitan.

```text
# .env.template (commiteado, sin valores)

# Si se automatiza descarga de fuentes:
BCB_API_TOKEN=
FAO_API_KEY=
WB_API_KEY=

# Si se usa GitHub Actions / Releases:
GITHUB_PAT=

# Si se automatiza Zenodo deposit:
ZENODO_TOKEN=

# Si se conecta a Google Earth Engine:
GEE_SERVICE_ACCOUNT_JSON_PATH=

# Si se incorpora al panel un dataset restringido:
RESTRICTED_DATA_PATH=
```

```text
# .env (NUNCA commiteado, con valores reales)

BCB_API_TOKEN=<valor real>
...
```

### 3.2. Carga en R

```r
# 02_code/00_setup/load_env.R
if (file.exists(here::here(".env"))) {
  readRenviron(here::here(".env"))
}
# Acceso: Sys.getenv("BCB_API_TOKEN")
```

### 3.3. Carga en shell

```bash
# scripts/source_env.sh
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi
```

---

## 4. `.gitignore` obligatorio

Bloque que **siempre** debe estar en `.gitignore` del proyecto:

```text
# === Secrets / Credentials ===
.env
.env.local
.env.production
.env.*.local

# API keys, tokens
*.key
*.pem
*.p12
*.crt
*_secret.*
*_token.*
**/CREDENCIALES.md
**/credentials.json
**/service_account.json

# SSH
id_rsa
id_ed25519
*.ppk

# === Confidencialidad ===
00_admin/restricted/
00_admin/coi/
00_admin/handoff/
00_admin/cartas/*.docx
00_admin/mesas_tecnicas/*_restringida.md

# === Backups / temporales ===
*.bak
*~
.DS_Store
Thumbs.db

# === R local ===
.Rhistory
.RData
.Rproj.user/
.Renviron        # contiene secrets si se usó este mecanismo

# === System ===
__pycache__/
.ipynb_checkpoints/
```

### 4.1. Verificación previa al commit

Hook recomendado (a implementar en `15_SEGURIDAD.md` §11):

```bash
# .git/hooks/pre-commit (extracto)
if git diff --cached --name-only | grep -qE '\.env$|_secret|_token|\.key$'; then
  echo "🚫 Intento de commit de secretos. Aborted."
  exit 1
fi
```

---

## 5. Detección y respuesta a filtración

### 5.1. Si un secreto se filtró al repo

```text
Severidad: P0 — incidente categoría T-06 (16_INCIDENTES.md)

Acciones (en este orden, sin saltarse pasos):

1. ROTAR EL SECRETO INMEDIATAMENTE
   - revocar el token / key / credential afectado
   - generar uno nuevo
   - actualizar .env local del equipo

2. REMOVER DEL HISTORIAL DE GIT
   - usar git-filter-repo o BFG Repo-Cleaner
   - NO basta con git rm; el commit histórico mantiene el secreto
   - force-push tras coordinar con el equipo

3. NOTIFICAR
   - TTL en < 1 h
   - WB Information Security (si aplica)
   - equipo APER

4. AUDITAR USO
   - revisar logs del servicio (e.g. token usage logs) buscando uso
     anómalo durante el periodo de exposición
   - si hubo uso anómalo: tratar como brecha (escalar)

5. POST-MORTEM
   - blameless según protocolo 16_INCIDENTES §7
   - identificar gap del proceso
   - actualizar .gitignore, hooks, este archivo si aplica
```

### 5.2. Herramientas de detección

```text
manual:
  - git log -p | grep -iE 'password|secret|token|api_key'  (antes de push)

automatizadas (a implementar):
  - gitleaks (open source)
  - GitHub secret scanning (activado en repos GitHub)
  - pre-commit hook con regex de secretos comunes
```

---

## 6. Backup policy

### 6.1. Qué se respalda

| Artefacto | Frecuencia | Destino | Quién |
|---|---|---|---|
| Panel v12 (`spending_panel_v12.rds`) | semanal | OneDrive APER + Zenodo (en release) | equipo APER técnico |
| Fuentes crudas (`01_data/raw/`) | mensual o tras descarga nueva | OneDrive APER | equipo APER técnico |
| Repo completo | continuo (git remoto) | GitHub | quien commitea |
| Outputs publicados | en cada release | Zenodo deposit | TTL + equipo técnico |
| `00_admin/restricted/` (COI, minutas) | semanal | OneDrive personal con 2FA del TTL | TTL |
| Audit log | semanal | OneDrive equipo + ZIP mensual en `00_admin/audit_archive/` | quien audita |

### 6.2. Verificación de restauración

```text
- cada 8 semanas: el equipo técnico restaura el último backup del panel
  en una carpeta temporal y verifica que renv::restore() + rebuild produce
  outputs equivalentes (12_REPRODUCIBILIDAD §5)
- el resultado se registra en 00_admin/repro_test_YYYY_MM_DD.md
```

### 6.3. Retención

```text
backups OneDrive:    rolling, mínimo 12 meses
backups Zenodo:      permanente (Zenodo garantiza ≥ 20 años)
backups locales:     n/a — no se confía en backups locales únicos
```

---

## 7. Control de accesos

### 7.1. Repo GitHub

```text
- repo público: cualquiera ve, solo colaboradores commitean
  → lista de colaboradores explícita; revisión cuando rota personal
- repo privado (si aplica): permisos por equipo / por persona
- branch protection en main:
    - requires PR review (para cambios ROJOS)
    - requires CI gates pass (cuando CI esté implementado)
    - no force push directo a main
```

### 7.2. Servidores (si aplica)

```text
- SSH keys nombradas por persona (no compartidas)
- accesos revocados al instante cuando la persona sale del equipo
- log de accesos activado y revisado mensualmente
```

### 7.3. OneDrive / SharePoint

```text
- carpetas INTERNAS: permisos a todo el equipo APER
- carpetas RESTRINGIDAS: permisos individuales con 2FA obligatorio
- compartir externamente: SOLO vía link con expiración (≤ 14 días)
- nunca compartir RESTRINGIDO con audiencia externa salvo necesidad
  documentada + aprobación TTL
```

### 7.4. Servicios externos (Zenodo, GitHub, etc.)

```text
- cada servicio con MFA / 2FA activado obligatoriamente
- contraseñas únicas en gestor de contraseñas (1Password, Bitwarden, etc.)
- tokens con scope mínimo (e.g. Zenodo PAT con permiso de deposit, no admin)
- rotación anual de tokens
```

---

## 8. Web pública del proyecto

```text
sitio público (www/):
  - sin formularios que recolecten datos personales en v1
  - sin tracking analytics que no respete privacy (descartar Google Analytics
    sin consent; preferir Plausible / Fathom / self-hosted Matomo si se
    requiere analítica)
  - no se sirven datos restringidos
  - SSL/TLS vía GitHub Pages (default)

futuro (no en v1):
  - si se agrega formulario de contacto: respetar GDPR / LGPD; declarar
    política de privacidad
```

---

## 9. Política de actualización de dependencias

```text
- mensualmente: revisar renv lockfile vs CRAN para detectar paquetes con
  vulnerabilidades conocidas (vía R-CVE o equivalent)
- antes de release: snapshot fresco de renv + audit
- si una vulnerabilidad alta aparece en un paquete usado:
    - evaluar impacto
    - actualizar paquete + bump renv lockfile
    - ADR si afecta cifras del panel
- proyectos R suelen tener riesgo de vulnerabilidad bajo (offline analytics),
  pero scripts que descargan vía API son superficie de ataque potencial
```

---

## 10. Mínima superficie de exposición

Principios de defensa:

```text
- no expongas lo que no necesitas:
    * el panel publicado va en CSV / RDS / parquet; no via API
    * no se monta servicio backend; el sitio público es estático
- preferir descargas manuales documentadas a integraciones automáticas
  con APIs externas (reduce superficie de secrets + dependencias)
- si se debe integrar API: token con scope mínimo + rate limit local
```

---

## 11. Git hooks recomendados (a implementar)

```bash
# .git/hooks/pre-commit (NO commiteado; se instala vía script setup)
#!/usr/bin/env bash

# 1. Detección de secrets
if git diff --cached --name-only | grep -qE '\.env$|_secret|_token|\.key$|\.pem$'; then
  echo "🚫 Intento de commit de archivo con patrón de secreto. Aborted."
  exit 1
fi

# 2. Detección de strings que parecen tokens
if git diff --cached -U0 | grep -qE '(AKIA|ghp_|sk-|xox[bp]-|AIza)[A-Za-z0-9]{20,}'; then
  echo "🚫 Patrón de token detectado en el diff. Aborted."
  exit 1
fi

# 3. Detección de unicode no permitido (ESTILO §3.20)
if git diff --cached | grep -qP '[\x{200B}\x{00AD}\x{FEFF}]'; then
  echo "⚠ Caracteres unicode invisibles detectados. Revisar antes de commit."
  exit 1
fi
```

Script de instalación: `scripts/install_git_hooks.sh` (a implementar).

---

## 12. Disaster recovery (escenarios)

| Escenario | Acción inmediata | Tiempo objetivo |
|---|---|---|
| Laptop con repo perdida o robada | revocar accesos del usuario; verificar que .env no estaba sincronizado a la nube sin protección | < 4 h |
| Cuenta GitHub comprometida | rotar PAT + 2FA + auditar commits recientes; reset password | < 2 h |
| OneDrive del TTL comprometida | rotar credenciales WB; reset 2FA; verificar acceso a 00_admin/coi/ | < 2 h |
| Servidor de hosting (si aplica) caído | mirror Zenodo + GitHub Pages | < 24 h |
| Panel v12 corrupto en repo | restaurar desde Zenodo deposit o OneDrive backup | < 8 h |
| Borrado accidental de carpeta crítica | restaurar desde último backup; auditar lineage | < 24 h |
| Filtración pública de RESTRINGIDO | protocolo 16_INCIDENTES T-06 + 5.1 de este archivo | inmediato |

---

## 13. Integración con otros archivos

| Archivo | Cómo conecta |
|---|---|
| `14_CONFIDENCIALIDAD.md` | Lista qué es RESTRINGIDO; este archivo dice cómo protegerlo |
| `16_INCIDENTES.md` | Brecha de credenciales es T-06; filtración secrets es subcategoría |
| `12_REPRODUCIBILIDAD.md` | Backup del panel + verificación de restauración |
| `08_CONTROL.md` | Cambios a este archivo son ROJOS si tocan policy core |
| `00_admin/restricted/` | Carpeta a la que aplica la política RESTRINGIDA + 2FA |
| `.gitignore` raíz | Implementa §4 |

---

## 14. Cómo modificar este archivo

| Cambio | Color |
|---|---|
| Agregar herramienta de detección §5.2 | AMARILLO |
| Agregar entrada a `.gitignore` §4 | VERDE (cosmético) o AMARILLO si protege RESTRINGIDO no cubierto |
| Cambiar política de backup §6 | ROJO + ADR |
| Cambiar control de accesos GitHub branch protection | ROJO + ADR |
| Cambiar política de rotación de credenciales | ROJO + ADR |
| Agregar disaster recovery scenario | AMARILLO |

---

## 15. TODOs para alcanzar v1.0

- [ ] Crear `.env.template` en root del repo con variables anticipadas.
- [ ] Auditar `.gitignore` actual y completar con bloque §4.
- [ ] Implementar `scripts/install_git_hooks.sh` con el hook §11.
- [ ] Evaluar `gitleaks` o equivalent para escaneo automatizado.
- [ ] Inventariar secretos en uso (si los hay) y migrarlos a `.env`.
- [ ] Primer test de restauración de backup del panel.
- [ ] Activar 2FA en cuentas críticas (GitHub, OneDrive, Zenodo del TTL).
- [ ] Documentar el procedimiento de rotación de Zenodo PAT.
- [ ] Revisar branch protection rules en repo GitHub.

---

## 16. Bitácora

| Versión | Fecha | Cambio |
|---|---|---|
| v0.1.0 | 2026-05-23 | Versión inicial: inventario de secretos posibles, política `.env` + `.gitignore`, detección y respuesta a filtración, backup con verificación periódica, control de accesos por servicio, hooks pre-commit, disaster recovery con tiempos objetivo, integración con CONFIDENCIALIDAD/INCIDENTES |
