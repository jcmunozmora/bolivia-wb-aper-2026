# Guía de Descarga Manual de Fuentes de Datos

Esta guía describe los pasos para descargar las fuentes que **no tienen API disponible**.
Guardar todos los archivos en la carpeta indicada antes de ejecutar los scripts de cleaning.

---

## 1. WB BOOST Bolivia
**Carpeta**: `01_data/raw/boost/`

1. Ir a: https://boost.worldbank.org/country/bolivia
2. Click en "Download data" → formato Excel o CSV
3. Seleccionar todos los años disponibles (~2004-2020)
4. Guardar como `boost_bolivia_raw.xlsx`

**Alternativa**: Contactar al equipo del Banco Mundial Bolivia para acceso al dataset completo de microdatos.

**Variables clave**: entidad ejecutora, código funcional (COFOG), clasificador económico, monto aprobado y ejecutado.

---

## 2. SIIF Bolivia — Presupuesto Nacional
**Carpeta**: `01_data/raw/siif/`

### Presupuesto nacional (MDRyT y entidades adscritas)
1. Ir a: https://www.mefp.gob.bo/ → Estadísticas Fiscales → Ejecución Presupuestaria
2. Descargar por año: Ejecución Presupuestaria del PGE (2000-2023)
3. Formato Excel, un archivo por año
4. Guardar como `siif_national_{year}.xlsx`

### Entidades clave a descargar:
- MDRyT (Ministerio de Desarrollo Rural y Tierras)
- INIAF (Instituto Nacional de Innovación Agropecuaria y Forestal)
- SENASAG (Servicio Nacional de Sanidad Agropecuaria e Inocuidad Alimentaria)
- EMAPA (Empresa de Apoyo a la Producción de Alimentos)
- BDP (Banco de Desarrollo Productivo)
- MMAyA (Ministerio de Medio Ambiente y Agua) — riego y recursos hídricos
- INRA (Instituto Nacional de Reforma Agraria)
- Fondo Nacional de Desarrollo Alternativo

### Presupuesto subnacional (departamental)
1. Ir a: https://www.minedu.gob.bo/ o https://www.contraloria.gob.bo/
2. Solicitar formalmente datos de presupuesto municipal/departamental en agricultura
3. Alternativa: Contactar Ministerio de Autonomías para datos SIIF subnacional

---

## 3. Bolivia INE — Estadísticas Agropecuarias
**Carpeta**: `01_data/raw/ine_bolivia/`

### Encuesta Nacional Agropecuaria (ENA)
1. Ir a: https://www.ine.gob.bo/ → Estadísticas Económicas → Encuestas Sectoriales
2. Descargar ENA disponibles (2012, 2015, 2019, 2022 si existe)
3. Guardar microdatos en `01_data/raw/ine_bolivia/ena/`

### Censo Agropecuario 2013
1. Ir a: https://www.ine.gob.bo/ → Censos → Censo Agropecuario
2. Descargar resultados definitivos y microdatos
3. Guardar en `01_data/raw/ine_bolivia/censo_agropecuario_2013/`

### Encuesta de Hogares (para ingreso rural y pobreza)
1. Ir a: https://www.ine.gob.bo/ → Estadísticas Sociales → Encuesta de Hogares
2. Descargar EH 2005-2022
3. Guardar en `01_data/raw/ine_bolivia/encuesta_hogares/`

### PIB agropecuario a precios de mercado
1. Ir a: https://www.ine.gob.bo/ → Cuentas Nacionales
2. Descargar "PIB por actividad económica" (serie histórica)
3. Guardar como `cuentas_nacionales_pib.xlsx`

---

## 4. MDRyT — Memorias y Planes
**Carpeta**: `01_data/raw/mdryt/`

1. Ir a: https://www.mdryt.gob.bo/ → Publicaciones → Memorias Institucionales
2. Descargar Memorias anuales (2005-2023)
3. Guardar PDFs en `01_data/raw/mdryt/memorias/`
4. Buscar específicamente: programas, metas, beneficiarios, presupuesto ejecutado

**Documentos adicionales**:
- Plan del Sector Agropecuario 2016-2020 y 2021-2025
- Informes INIAF (investigación, extensión, material genético)
- Informes SENASAG (inspecciones, registros, presupuesto)

---

## 5. IFPRI SPEED Database
**Carpeta**: `01_data/raw/ifpri_speed/`

1. Ir a: https://www.ifpri.org/publication/speed-statistics-public-expenditures-economic-development
2. Descargar dataset Excel completo
3. Guardar como `ifpri_speed_database.xlsx`

**Variables clave**: Gasto público total en agricultura por país (1980-2012+), desagregado por función.

---

## 6. Deflactores e Índice de Precios
**Carpeta**: `01_data/external/`

### CPI Bolivia (INE)
1. Ir a: https://www.ine.gob.bo/ → Estadísticas Económicas → Precios
2. Descargar IPC histórico (Índice de Precios al Consumidor)
3. Completar el archivo `inflation_deflators.csv` ya creado

### Tipo de cambio BOB/USD
1. Fuente: Banco Central de Bolivia → https://www.bcb.gob.bo/
2. Sección: Estadísticas → Tipo de Cambio
3. Descargar tipo de cambio promedio anual (2000-2023)
4. Completar el archivo `exchange_rates.csv`

---

## Checklist de Descarga

| Fuente | Estado | Fecha | Responsable |
|--------|--------|-------|-------------|
| BOOST Bolivia | ☐ Pendiente | | |
| SIIF Nacional | ☐ Pendiente | | |
| SIIF Subnacional | ☐ Pendiente | | |
| INE - ENA | ☐ Pendiente | | |
| INE - Censo 2013 | ☐ Pendiente | | |
| INE - Encuesta Hogares | ☐ Pendiente | | |
| INE - Cuentas Nacionales | ☐ Pendiente | | |
| MDRyT - Memorias | ☐ Pendiente | | |
| IFPRI SPEED | ☐ Pendiente | | |
| BCB - Tipo de Cambio | ☐ Pendiente | | |
| INE - CPI | ☐ Pendiente | | |
