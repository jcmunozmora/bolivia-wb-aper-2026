# Figuras basadas en Hansen Global Forest Change
# =============================================================================
# Fig 41: Deforestación anual nacional 2001-2023 (línea + bar chart)
# Fig 42: Top 10 departamentos — deforestación acumulada
# Fig 43: Mapa ADM3 deforestación acumulada
# Fig 44: Scatter gasto agrop × deforestación municipal 2012-2021
#
# Ejecutar después de 16_integrate_hansen.R
# =============================================================================

library(data.table); library(ggplot2); library(scales)
library(sf); library(dplyr); library(stringr)

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
source(file.path(root, "02_code/04_visualization/00_wb_theme.R"))
fig_dir <- file.path(root, "05_outputs/figures")

# ── Fig 41: Serie anual nacional ─────────────────────────────────────────────
h_nat <- readRDS(file.path(root, "01_data/processed/hansen_dept_annual_deforestation.rds"))
setDT(h_nat)
nat_ts <- h_nat[, .(defor_kha = sum(defor_ha, na.rm = TRUE) / 1e3), by = year]

p41 <- ggplot(nat_ts, aes(x = year, y = defor_kha)) +
  geom_col(fill = WB_RED, alpha = 0.85) +
  geom_text(aes(label = sprintf("%.0f", defor_kha)),
            vjust = -0.4, size = 2.8, color = WB_NAVY) +
  scale_y_continuous(labels = label_number(suffix = "k"),
                     expand = expansion(mult = c(0, 0.12))) +
  scale_x_continuous(breaks = seq(2001, 2023, 2)) +
  labs(title    = "Deforestación anual Bolivia 2001-2023",
       subtitle = "Hectáreas de bosque perdidas por año (umbral ≥30% cobertura 2000)",
       x = NULL, y = "Deforestación (miles ha/año)",
       caption  = "Fuente: Hansen Global Forest Change v1.11 · 30m agregado a 300m") +
  theme_wb()
ggsave(file.path(fig_dir, "fig41_hansen_nacional_anual.png"),
       p41, width = 11, height = 6, dpi = 150)
cat("Fig 41 guardado\n")

# ── Fig 42: Top departamentos ────────────────────────────────────────────────
h_cum <- readRDS(file.path(root, "01_data/processed/hansen_dept_cumulative.rds"))
setDT(h_cum)
h_cum[, label := paste0(dept, sprintf(" (%.1f%%)", defor_pct_forest_2000))]
h_cum[, label := factor(label, levels = rev(label[order(defor_total_ha)]))]

p42 <- ggplot(h_cum[order(-defor_total_ha)],
              aes(x = reorder(dept, defor_total_ha), y = defor_total_ha / 1e6)) +
  geom_col(fill = WB_ORANGE, alpha = 0.85) +
  geom_text(aes(label = sprintf("%.2fM ha\n(%.1f%% bosque 2000)",
                                defor_total_ha/1e6, defor_pct_forest_2000)),
            hjust = -0.05, size = 2.9, color = WB_NAVY, lineheight = 0.9) +
  coord_flip() +
  scale_y_continuous(labels = label_number(suffix = "M"),
                     expand = expansion(mult = c(0, 0.35))) +
  labs(title    = "Deforestación acumulada 2001-2023 por departamento",
       subtitle = "Santa Cruz y Beni concentran el grueso de la pérdida forestal",
       x = NULL, y = "Deforestación acumulada (millones ha)",
       caption  = "Fuente: Hansen Global Forest Change v1.11") +
  theme_wb()
ggsave(file.path(fig_dir, "fig42_hansen_top_depts.png"),
       p42, width = 11, height = 6, dpi = 150)
cat("Fig 42 guardado\n")

# ── Fig 43: Mapa ADM3 deforestación acumulada ────────────────────────────────
h_mun <- readRDS(file.path(root, "01_data/processed/hansen_muni_annual_deforestation.rds"))
setDT(h_mun)
mun_cum <- h_mun[, .(defor_total_ha = sum(defor_ha, na.rm = TRUE),
                     forest_2000 = first(forest_area_2000_ha)),
                 by = municipio][, defor_pct := 100 * defor_total_ha /
                                                pmax(1, forest_2000)]

adm3 <- st_read(file.path(root, "01_data/external/bolivia_adm3_municipalities.gpkg"),
                quiet = TRUE)
normalize_name <- function(x) {
  y <- iconv(x, from = "UTF-8", to = "ASCII//TRANSLIT")
  y <- toupper(y); y <- gsub("[[:punct:]]", " ", y)
  y <- gsub("\\s+", " ", y); str_trim(y)
}
adm3$key <- normalize_name(adm3$shapeName)
mun_cum[, key := normalize_name(municipio)]
adm3_m <- adm3 %>% left_join(mun_cum, by = "key")

p43 <- ggplot(adm3_m) +
  geom_sf(aes(fill = defor_total_ha / 1e3),
          color = "white", linewidth = 0.1) +
  scale_fill_gradient(
    low = WB_GREY_LT, high = WB_RED,
    name = "Deforestación\n(miles ha)",
    na.value = "#E5E5E5",
    labels = label_number(suffix = "k"),
    trans = "log10") +
  labs(title    = "Deforestación acumulada municipal 2001-2023",
       subtitle = "Hansen v1.11 · 30m agregado a resolución ADM3",
       caption  = "Fuente: Hansen Global Forest Change + geoBoundaries ADM3") +
  theme_wb() +
  theme(axis.text = element_blank(), axis.ticks = element_blank(),
        panel.grid = element_blank(), axis.line = element_blank(),
        legend.position = "right")
ggsave(file.path(fig_dir, "fig43_hansen_mapa_muni.png"),
       p43, width = 10, height = 9, dpi = 150)
cat("Fig 43 guardado\n")

# ── Fig 44: Scatter gasto agrop × deforestación (muni 2012-2021) ─────────────
panel <- readRDS(file.path(root, "01_data/processed/municipal_panel_v3.rds"))
setDT(panel)

agg <- panel[year %in% 2012:2021 & !is.na(agro_strict_bob_mm) & !is.na(defor_ha_year),
             .(gasto_total_mm = sum(agro_strict_bob_mm, na.rm = TRUE),
               defor_total_ha = sum(defor_ha_year, na.rm = TRUE)),
             by = .(muni_name, dept)]
agg <- agg[gasto_total_mm > 0 & defor_total_ha > 0]

r <- cor(log(agg$gasto_total_mm), log(agg$defor_total_ha))

p44 <- ggplot(agg, aes(x = gasto_total_mm, y = defor_total_ha / 1e3)) +
  geom_point(aes(color = dept), alpha = 0.7, size = 2.2) +
  geom_smooth(method = "lm", se = TRUE, color = WB_NAVY, fill = WB_GREY_LT,
              linewidth = 0.8) +
  scale_x_log10(labels = label_number(suffix = "M")) +
  scale_y_log10(labels = label_number(suffix = "k")) +
  scale_color_manual(values = c(WB_PALETTE, "#8E44AD", "#16A085", "#D35400")) +
  labs(title    = "Gasto agropecuario municipal vs. deforestación 2012-2021",
       subtitle = sprintf("r(log-log) = %.3f · 339 municipios", r),
       x = "Gasto agropecuario acumulado (BOB millones, log)",
       y = "Deforestación acumulada (miles ha, log)",
       color = "Depto",
       caption  = "Fuente: Jubileo + Hansen GFC v1.11") +
  theme_wb() +
  theme(legend.position = "right")
ggsave(file.path(fig_dir, "fig44_scatter_gasto_deforestacion.png"),
       p44, width = 11, height = 7, dpi = 150)
cat("Fig 44 guardado\n")
cat("\n✓ 4 figuras generadas (fig41-fig44)\n")
