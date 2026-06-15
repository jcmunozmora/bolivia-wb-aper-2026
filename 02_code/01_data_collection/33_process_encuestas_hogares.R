# Procesa Encuesta de Hogares Bolivia 2012-2024 (8 años)
# =============================================================================
# Input:  01_data/raw/ine_bolivia/Encuesta_Hogares_YYYY/ (SAV ya extraídos)
#         EH2022/BD_EH2022.rar y EH2023/BD_EH2023.rar deben estar extraídos
# Output:
#   - eh_YYYY.rds              (persona-nivel, vars estandarizadas)
#   - eh_nacional_anual.rds    (panel: indicadores anuales nacionales)
#   - eh_dept_anual.rds        (panel: indicadores por depto × área × año)
#
# Variables estandarizadas clave:
#   caeb_op == 0 → Agricultura/Ganadería/Caza/Pesca/Silvicultura
#   p0=1 → hogar pobre; pext0=1 → hogar extremo pobre
#   fies_score → 0-8 (8 FIES questions, 1=sí inseguro alimentario)
# =============================================================================

library(haven)
library(data.table)

# Reproducibilidad (invariante 7 / ADR-0018): rutas vía here::here(), no paths absolutos.
# NOTA (invariante 14): los microdatos crudos EH (.sav) son insumo EXTERNO y
# CONFIDENCIAL — no se commitean al repo. Colócalos en 01_data/raw/ine_bolivia/.
# La pobreza departamental del reporte se toma de tablas INE ya calculadas
# (34_ine_poverty_departamental.R), no de este reprocesamiento de microdatos.
source(here::here("02_code", "00_setup", "01_constants.R"))
eh_root <- file.path(DIR_DATA_RAW, "ine_bolivia")
proc    <- DIR_DATA_PRO

# ── Configuración por año ─────────────────────────────────────────────────────
# sa_prefix: prefijo de las 8 preguntas FIES en el módulo SeguridadAlimentaria
# wt: variable de ponderación en el archivo Persona
YEARS_CONFIG <- list(
  list(year=2012, enc="latin1", wt="factor_2014",
       persona_f = "Encuesta_Hogares_2012/BOLIVIA_PERSONAS_2012.sav",
       sa_f      = NULL, sa_prefix = NULL),

  list(year=2015, enc="latin1", wt="factor",
       persona_f = "Encuesta_Hogares_2015/EH2015_PERSONA.sav",
       sa_f      = NULL, sa_prefix = NULL),

  list(year=2019, enc="latin1", wt="factor",
       persona_f = "Encuesta_Hogares_2019/BD_EH19_spss/EH2019_Persona.sav",
       sa_f      = "Encuesta_Hogares_2019/BD_EH19_spss/EH2019_SeguridadAlimentaria.sav",
       sa_prefix = "s09a_"),

  list(year=2020, enc="latin1", wt="factor",
       persona_f = "Encuesta_Hogares_2020/EH2020_Persona.sav",
       sa_f      = NULL, sa_prefix = NULL),  # módulo SA no levantado (COVID)

  list(year=2021, enc="utf-8", wt="factor",
       persona_f = "Encuesta_Hogares_2021/EH2021_Persona.sav",
       sa_f      = "Encuesta_Hogares_2021/EH2021_Seguridad Alimentaria.sav",
       sa_prefix = "s08a_"),

  list(year=2022, enc="utf-8", wt="factor",
       persona_f = "Encuesta_Hogares_2022/BD/EH2022_Persona.sav",
       sa_f      = "Encuesta_Hogares_2022/BD/EH2022_Seguridad Alimentaria.sav",
       sa_prefix = "s07a_"),

  list(year=2023, enc="latin1", wt="factor",
       persona_f = "Encuesta_Hogares_2023/EH2023_Persona.sav",
       sa_f      = "Encuesta_Hogares_2023/EH2023_Seguridad_Alimentaria.sav",
       sa_prefix = "s07a_"),

  list(year=2024, enc="latin1", wt="factor",
       persona_f = "Encuesta_Hogares_2024/EH2024_Persona.sav",
       sa_f      = "Encuesta_Hogares_2024/EH2024_Seguridad_Alimentaria.sav",
       sa_prefix = "s07a_")
)

# ── Función de procesamiento por año ─────────────────────────────────────────
process_eh_year <- function(cfg) {
  yr       <- cfg$year
  enc      <- cfg$enc
  wt_var   <- cfg$wt
  p_path   <- file.path(eh_root, cfg$persona_f)
  sa_path  <- if (!is.null(cfg$sa_f)) file.path(eh_root, cfg$sa_f) else NULL
  sa_pfx   <- cfg$sa_prefix

  cat(sprintf("\n══ EH%d ══\n", yr))

  # -- Persona --
  persona <- tryCatch(
    as.data.table(read_sav(p_path, encoding=enc)),
    error = function(e) {
      cat("  Reintentando con encoding alternativo...\n")
      enc2 <- if (enc == "utf-8") "latin1" else "utf-8"
      as.data.table(read_sav(p_path, encoding=enc2))
    }
  )
  cat(sprintf("  Persona: %d obs × %d vars\n", nrow(persona), ncol(persona)))

  # Normalizar nombres a minúsculas
  setnames(persona, tolower(names(persona)))
  setnames(persona, wt_var, "wt")

  # folio es character en 2015+ ("111-04160908813-A-0011"), numeric en 2012
  # Siempre mantener como character para consistencia
  set(persona, j="folio", value=as.character(persona[["folio"]]))

  # Convertir labelled → numeric para variables cuantitativas
  num_vars <- c("depto","area","nro","wt",
                "yhogpc","z","zext","p0","p1","p2","pext0","pext1","pext2",
                "caeb_op","pea","condact","ylab","ynolab","yper","yhog","ocupado")
  for (v in num_vars) {
    if (v %in% names(persona))
      set(persona, j=v, value=suppressWarnings(as.numeric(persona[[v]])))
  }

  # Variable agro_worker: empleado en agropecuaria
  persona[, agro_worker := as.integer(!is.na(caeb_op) & caeb_op == 0 &
                                        !is.na(pea) & pea == 1)]

  # Tamaño de hogar
  hogsize <- persona[, .(nhog_size = .N), by = folio]
  persona <- merge(persona, hogsize, by="folio", all.x=TRUE)

  # Columnas estándar de salida
  keep_vars <- intersect(
    c("folio","depto","area","nro","wt","nhog_size",
      "yhogpc","z","zext","p0","pext0","p1","p2","pext1","pext2",
      "caeb_op","agro_worker","pea","condact","ylab","ynolab","yper","yhog"),
    names(persona)
  )
  dt <- persona[, ..keep_vars]
  dt[, year := yr]

  # Tamaño de fila efectivo sin duplicados por variable
  cat(sprintf("  Personas: %d | Hogares: %d | Rural%%: %.1f\n",
              nrow(dt), uniqueN(dt$folio),
              100 * sum(dt$area == 2, na.rm=TRUE) / nrow(dt)))

  # -- Seguridad Alimentaria (FIES 8 preguntas) --
  if (!is.null(sa_path) && file.exists(sa_path)) {
    sa <- tryCatch(
      as.data.table(read_sav(sa_path, encoding=enc)),
      error = function(e) as.data.table(read_sav(sa_path, encoding="latin1"))
    )
    setnames(sa, tolower(names(sa)))
    set(sa, j="folio", value=as.character(sa[["folio"]]))
    cat(sprintf("  SA: %d hogares\n", nrow(sa)))

    # Las 8 preguntas FIES (1=Sí inseguro, 2=No, 3=NS/NR → tratar como NA)
    fies_vars <- paste0(sa_pfx, sprintf("%02d", 1:8))
    fies_vars <- intersect(fies_vars, names(sa))

    for (v in fies_vars)
      set(sa, j=v, value=suppressWarnings(as.numeric(sa[[v]])))

    # Convertir: 1→1, 2→0, resto→NA
    for (v in fies_vars) {
      sa[, (v) := ifelse(get(v) == 1L, 1L, ifelse(get(v) == 2L, 0L, NA_integer_))]
    }

    # Score FIES: número de preguntas "Sí" (0-8)
    if (length(fies_vars) > 0) {
      sa[, fies_score    := rowSums(.SD, na.rm=FALSE), .SDcols=fies_vars]
      sa[, fies_insecure := as.integer(fies_score >= 1)]
      sa[, fies_moderate := as.integer(fies_score >= 3)]
      sa[, fies_severe   := as.integer(fies_score >= 6)]
    }

    sa_keep <- c("folio", "fies_score", "fies_insecure", "fies_moderate", "fies_severe")
    sa_keep <- intersect(sa_keep, names(sa))
    dt <- merge(dt, sa[, ..sa_keep], by="folio", all.x=TRUE)
    cat(sprintf("  FIES: %.1f%% inseguros alimentarios\n",
                100 * mean(dt$fies_insecure, na.rm=TRUE)))
  } else {
    dt[, fies_score    := NA_real_]
    dt[, fies_insecure := NA_integer_]
    dt[, fies_moderate := NA_integer_]
    dt[, fies_severe   := NA_integer_]
  }

  setorder(dt, folio, nro)
  cat(sprintf("  → eh_%d.rds (%d obs × %d vars)\n", yr, nrow(dt), ncol(dt)))
  dt
}

# ── Procesar todos los años ───────────────────────────────────────────────────
eh_list <- list()
for (cfg in YEARS_CONFIG) {
  yr  <- cfg$year
  out <- file.path(proc, sprintf("eh_%d.rds", yr))
  dt  <- process_eh_year(cfg)
  saveRDS(dt, out)
  fwrite(dt, sub("\\.rds$", ".csv", out))
  eh_list[[as.character(yr)]] <- dt
}

# ── Panel completo persona-nivel ──────────────────────────────────────────────
eh_panel <- rbindlist(eh_list, use.names=TRUE, fill=TRUE)
setorder(eh_panel, year, folio, nro)
cat(sprintf("\nPanel completo: %d obs × %d vars | Años: %s\n",
            nrow(eh_panel), ncol(eh_panel),
            paste(sort(unique(eh_panel$year)), collapse=",")))

saveRDS(eh_panel, file.path(proc, "eh_panel_2012_2024.rds"))
fwrite(eh_panel,  file.path(proc, "eh_panel_2012_2024.csv"))

# ── Función de agregación ponderada ──────────────────────────────────────────
wmean_safe <- function(x, w) {
  ok <- !is.na(x) & !is.na(w) & w > 0
  if (sum(ok) == 0) return(NA_real_)
  sum(x[ok] * w[ok]) / sum(w[ok])
}

# ── Resumen anual nacional y por área ────────────────────────────────────────
# Usar una obs por hogar para estadísticas de pobreza (evitar doble conteo)
hog_panel <- eh_panel[, .SD[1], by=.(year, folio)]  # primer miembro = referencia hogar

# Indicadores nacionales
nac_list <- list()
for (yr in unique(eh_panel$year)) {
  h  <- hog_panel[year == yr]
  pe <- eh_panel[year == yr]  # para empleo agrícola (persona-nivel)

  # Pobreza por área
  for (ar in 0:2) {  # 0=total, 1=urbano, 2=rural
    hh <- if (ar == 0) h else h[area == ar]
    pp <- if (ar == 0) pe else pe[area == ar]
    area_lbl <- c("total","urban","rural")[ar+1]

    if (nrow(hh) == 0) next

    row <- data.table(
      year = yr,
      area = area_lbl,
      n_hogares  = nrow(hh),
      n_personas = nrow(pp),
      pov_rate   = wmean_safe(hh$p0,     hh$wt) * 100,
      extpov_rate= wmean_safe(hh$pext0,  hh$wt) * 100,
      yhogpc_mean= wmean_safe(hh$yhogpc, hh$wt),
      # Empleo agro: % PEA en agropecuaria
      agro_emp_pct = if (sum(pp$pea==1, na.rm=TRUE) > 0)
        wmean_safe(pp[pea==1]$agro_worker, pp[pea==1]$wt) * 100 else NA_real_,
      # FIES
      fies_insecure_pct = wmean_safe(hh$fies_insecure, hh$wt) * 100,
      fies_severe_pct   = wmean_safe(hh$fies_severe,   hh$wt) * 100
    )
    nac_list[[paste(yr, area_lbl)]] <- row
  }
}

nac_panel <- rbindlist(nac_list, use.names=TRUE, fill=TRUE)
setorder(nac_panel, year, area)

cat("\n=== Indicadores nacionales EH Bolivia ===\n")
print(nac_panel[area == "rural",
                .(year, pov_rate=round(pov_rate,1), extpov_rate=round(extpov_rate,1),
                  agro_emp_pct=round(agro_emp_pct,1), fies_insecure_pct=round(fies_insecure_pct,1))])

saveRDS(nac_panel, file.path(proc, "eh_nacional_anual.rds"))
fwrite(nac_panel,  file.path(proc, "eh_nacional_anual.csv"))

# ── Resumen por departamento × área ──────────────────────────────────────────
dept_list <- list()
for (yr in unique(eh_panel$year)) {
  h  <- hog_panel[year == yr]
  pe <- eh_panel[year == yr]

  for (dpt in 1:9) {
    for (ar in 1:2) {
      hh <- h[depto == dpt & area == ar]
      pp <- pe[depto == dpt & area == ar]
      if (nrow(hh) < 5) next

      dept_list[[paste(yr, dpt, ar)]] <- data.table(
        year       = yr,
        depto      = dpt,
        area       = ifelse(ar==1, "urban", "rural"),
        n_hogares  = nrow(hh),
        pov_rate   = wmean_safe(hh$p0,     hh$wt) * 100,
        extpov_rate= wmean_safe(hh$pext0,  hh$wt) * 100,
        yhogpc_mean= wmean_safe(hh$yhogpc, hh$wt),
        agro_emp_pct = if (sum(pp$pea==1, na.rm=TRUE) > 0)
          wmean_safe(pp[pea==1]$agro_worker, pp[pea==1]$wt) * 100 else NA_real_,
        fies_insecure_pct = wmean_safe(hh$fies_insecure, hh$wt) * 100
      )
    }
  }
}

dept_panel <- rbindlist(dept_list, use.names=TRUE, fill=TRUE)
setorder(dept_panel, year, depto, area)

cat("\nPobreza rural por departamento (último año disponible):\n")
last_yr <- max(dept_panel$year)
print(dept_panel[year == last_yr & area == "rural",
                 .(depto, pov_rate=round(pov_rate,1),
                   extpov_rate=round(extpov_rate,1),
                   agro_emp_pct=round(agro_emp_pct,1))][order(depto)])

saveRDS(dept_panel, file.path(proc, "eh_dept_anual.rds"))
fwrite(dept_panel,  file.path(proc, "eh_dept_anual.csv"))

# ── Guardar resumen de cobertura ──────────────────────────────────────────────
cob <- eh_panel[, .(
  n_personas  = .N,
  n_hogares   = uniqueN(folio),
  pct_rural   = round(mean(area==2, na.rm=TRUE)*100, 1),
  has_fies    = any(!is.na(fies_score)),
  pov_obs     = sum(!is.na(p0)),
  agro_obs    = sum(!is.na(agro_worker))
), by=year][order(year)]
cat("\n=== Cobertura por año ===\n")
print(cob)

# ── Outputs ───────────────────────────────────────────────────────────────────
cat("\n✓ Archivos individuales:\n")
for (yr in sort(unique(eh_panel$year)))
  cat(sprintf("  eh_%d.rds\n", yr))
cat("✓ eh_panel_2012_2024.rds  (", nrow(eh_panel), "obs)\n")
cat("✓ eh_nacional_anual.rds   (", nrow(nac_panel), "filas)\n")
cat("✓ eh_dept_anual.rds       (", nrow(dept_panel), "filas)\n")
