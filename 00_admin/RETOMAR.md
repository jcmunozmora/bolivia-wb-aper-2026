# Cómo retomar el proyecto — APER Bolivia 2026

**Última sesión:** 2026-04-23 (sesión 8 cerrada)
**Estado global:** ✅ Datos listos · 🟡 Redacción pendiente · 📨 Carta MEFP lista

---

## 1. Estado al cierre

### Datos
- **Panel maestro v11** — `01_data/processed/spending_panel_v11.rds` (35 años × 179 vars)
- **124 datasets RDS** procesados (142 MB)
- **42 scripts** de recolección + **8** de análisis
- **7 fichas** de lectura MDRyT
- **61 hitos** timeline política agropecuaria 1990-2025 (con 61 imágenes Wikimedia locales)

### Documentos enviables
- **Carta MEFP** — `00_admin/Carta_MEFP_Solicitud_Datos_APER2026.docx`
  - Genérica, para firma del Representante Residente BM
  - 3 anexos: A (Portada APER 2011), B (Excel variables, 6 hojas), C (Acuerdo confidencialidad)
  - Completar 5 campos `⚠` antes de enviar (fecha, firmante, cargo, correo, teléfono)
- **Inventario consolidado** — `00_admin/Inventario_Datos_APER_Bolivia_2026.xlsx` (5 hojas: 63 datasets + 23 gaps + 7 capítulos + 42 scripts + metadatos)
- **ESTADO_DE_DATOS.md** — sección 9 "Auditoría final" con los 23 gaps clasificados A/B/C

---

## 2. Próximos pasos al retomar (orden sugerido)

### Esta semana
1. **Enviar carta MEFP** — completar 5 campos `⚠`; coordinar con oficina BM Bolivia
2. **Poblar Cap. 2 Quarto** (desempeño sector) — datos 100% listos, prioridad alta

### Siguientes
3. **Re-correr regresiones** del script `08_extended_regressions.R` sobre panel v11 (antes estaban sobre v10 de 143 vars; ahora 179 vars con MapBiomas + Hansen + WDI ext + BOOST)
4. **Poblar Cap. 3 Quarto** (gasto público) con lo disponible; actualizar cuando MEFP responda
5. **DEA bootstrap Simar-Wilson** sobre `dea_dataset.rds` (81 DMUs ya listo)
6. **Publicar timeline** KnightLab — instrucciones en `01_data/timeline/INSTRUCCIONES_KNIGHTLAB.md`
7. **Validar anomalía PP caña 2015** (doméstico 261 USD/t vs referencia 37 USD/t — verificar con INE)

---

## 3. Comandos rápidos para empezar

```bash
# Activar R del proyecto
/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript --no-init-file

# Cargar panel maestro
Rscript -e 'p <- readRDS("01_data/processed/spending_panel_v11.rds"); dim(p); names(p)'

# Ver estado git
git log --oneline -10

# Ver estado de los datos
cat 00_admin/ESTADO_DE_DATOS.md | head -100
```

---

## 4. Archivos clave para retomar contexto rápido

| Archivo | Contenido |
|---------|-----------|
| `00_admin/ESTADO_DE_DATOS.md` | Documento maestro con todo el inventario y gaps |
| `00_admin/Inventario_Datos_APER_Bolivia_2026.xlsx` | Excel 5 hojas con resumen ejecutivo |
| `03_literature/mdryt_fichas/README.md` | Índice de las 7 fichas MDRyT |
| `01_data/timeline/README.md` | Estado del timeline y cómo publicarlo |

---

## 5. Convenciones del proyecto (recordatorios)

- **Deflactor:** CPI base 2015 INE Bolivia; valores en BOB 2015 + USD WDI
- **Panel canónico actual:** v11 (no v10 ni anteriores)
- **Dummy estructural obligatorio en regresiones crédito:** `post_ley393` (Ley 393/2014)
- **CHIRPS:** usar variable `source` para distinguir original vs interpolado
- **MDRyT site:** Cloudflare bloqueado — usar Wayback con HTTP (no HTTPS)
- **R ejecutable:** `/Users/jcmunoz/miniforge3/envs/ds/bin/Rscript --no-init-file`

---

## 6. Hallazgos clave ya identificados (para el reporte)

1. Inversión 10× vs TFP estancada → problema eficiencia (fig12)
2. Bolivia más volátil de LAC en %PSE (-40% 2009 → +7% 2016)
3. Patrón dual: taxa exportables (soya −37%, arroz −33%), protege seguridad alimentaria (maíz +46%, trigo +28%)
4. GSSE creció 8× desde 2006
5. Bolivia nunca alcanzó meta Maputo 10% (máx 3.48% en 1990)
6. PSE 2023 = 5.8% (5to en LAC)
7. MDRyT 2024: ejec fin 74% / fís 54%; **PAR III (BM) solo 16% fin** 🔴
8. Crédito agropecuario 5.1% (2010) → 11.7% (2024) — sustitución gasto público por crédito subsidiado
9. Pobreza rural 55% → 40% → 45% (reversión post-2021)
10. FIES inseguridad alimentaria 41% (2019) → 65% (2024)
11. Soya +131% (2008-2015); bovinos SC +65%
12. Bolivia perdió 9.4M ha forestales en 40 años (64% en Santa Cruz)
