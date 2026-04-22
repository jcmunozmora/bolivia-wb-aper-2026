# Integra datos municipales Jubileo (Bolivia nacional agregado) al panel v4
# =============================================================================
# Los datos de Jubileo cubren el GASTO MUNICIPAL AGREGADO 2012-2021 por programa
# Complementan VIPFE (que incluye principalmente nivel nacional/departamental)
# y APER (que terminaba en 2008)

library(data.table)

# Helper: coalesce
`%||%` <- function(a, b) if (!is.null(a) && length(a) > 0 && !is.na(a)) a else b

root     <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
proc_dir <- file.path(root, "01_data/processed")

# ─── Panel v3 (actual) ────────────────────────────────────────────────────────
panel_v3 <- readRDS(file.path(proc_dir, "spending_panel_v3.rds"))
setDT(panel_v3)

# ─── Jubileo data ────────────────────────────────────────────────────────────
jubileo <- readRDS(file.path(proc_dir, "jubileo_municipal_nacional_2012_2021.rds"))
setDT(jubileo)

# ─── Categorías agropecuarias y rurales ───────────────────────────────────────
# Categorización explícita según Anexo A del reporte:
#   DIRECTO AGROPECUARIO: 10, 12, 32
#   INFRAESTRUCTURA RURAL: 14, 15, 17, 18, 19
#   DESARROLLO RURAL AMPLIO: 13, 35

jubileo_agro_strict <- jubileo[program_code %in% c("10","12","32"),
  .(mun_agro_strict_bob_mm = sum(total_bob, na.rm = TRUE) / 1e6),
  by = year]

jubileo_rural_infra <- jubileo[program_code %in% c("14","15","17","18","19"),
  .(mun_rural_infra_bob_mm = sum(total_bob, na.rm = TRUE) / 1e6),
  by = year]

jubileo_rural_ampl <- jubileo[program_code %in% c("10","12","13","14","15","17","18","19","32","35"),
  .(mun_rural_total_bob_mm = sum(total_bob, na.rm = TRUE) / 1e6),
  by = year]

# Programa 10 específico (Agropecuario core)
jubileo_p10 <- jubileo[program_code == "10",
  .(mun_p10_agropecuario_bob_mm = sum(total_bob, na.rm = TRUE) / 1e6,
    mun_p10_corriente_bob_mm    = sum(corriente_bob, na.rm = TRUE) / 1e6,
    mun_p10_inversion_bob_mm    = sum(inversion_bob, na.rm = TRUE) / 1e6,
    mun_p10_pct_presup_total    = mean(total_pct, na.rm = TRUE)),
  by = year]

# Merge
j_wide <- Reduce(function(a, b) merge(a, b, by = "year", all = TRUE),
                 list(jubileo_p10, jubileo_agro_strict,
                      jubileo_rural_infra, jubileo_rural_ampl))

cat("=== Jubileo data integrada (2012-2021) ===\n")
print(j_wide)

# ─── Panel v4: agregar columnas Jubileo ──────────────────────────────────────
panel_v4 <- merge(panel_v3, j_wide, by = "year", all.x = TRUE)

# Convertir a BOB 2015 constantes
if ("cpi_2015base" %in% names(panel_v4)) {
  for (v in c("mun_p10_agropecuario_bob_mm", "mun_agro_strict_bob_mm",
              "mun_rural_infra_bob_mm", "mun_rural_total_bob_mm")) {
    if (v %in% names(panel_v4)) {
      v_2015 <- paste0(v, "_2015")
      panel_v4[, (v_2015) := get(v) / (cpi_2015base / 100)]
    }
  }
}

# Verificar consistencia
cat("\n=== Panel v4 — nuevas variables Jubileo ===\n")
new_vars <- grep("^mun_", names(panel_v4), value = TRUE)
for (v in new_vars) {
  n <- sum(!is.na(panel_v4[[v]]))
  yrs <- if (n > 0) paste(range(panel_v4[!is.na(get(v)), year]), collapse = "-") else "—"
  cat(sprintf("  %-40s %2d obs  %s\n", v, n, yrs))
}

cat("\n=== Comparación: gasto agropecuario por fuente (2015) ===\n")
if (nrow(panel_v4[year == 2015]) > 0) {
  row_2015 <- panel_v4[year == 2015]
  cat(sprintf("  VIPFE inversión agrop sector económico:  %8.1f mm USD (=%.0f mm BOB)\n",
              row_2015$inv_agro_usd_mm[1],
              row_2015$inv_agro_bob_mm_2015[1] %||% NA))
  cat(sprintf("  Jubileo Programa 10 municipal:           %8.1f mm BOB\n",
              row_2015$mun_p10_agropecuario_bob_mm[1]))
  cat(sprintf("  Jubileo agro estricto (10+12+32):        %8.1f mm BOB\n",
              row_2015$mun_agro_strict_bob_mm[1]))
  cat(sprintf("  Jubileo rural total (10+12+...+35):      %8.1f mm BOB\n",
              row_2015$mun_rural_total_bob_mm[1]))
}

# ─── Guardar panel v4 ──────────────────────────────────────────────────────────
saveRDS(panel_v4, file.path(proc_dir, "spending_panel_v4.rds"))
fwrite(panel_v4, file.path(proc_dir, "spending_panel_v4.csv"))
cat("\n✓ Panel v4 guardado:", nrow(panel_v4), "años ×", ncol(panel_v4), "variables\n")
