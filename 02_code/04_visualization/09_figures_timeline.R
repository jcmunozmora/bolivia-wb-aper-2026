# Figuras del timeline para el sitio web
# =============================================================================
# Genera 3 visualizaciones del timeline.csv y las guarda en www/figures/
# para que sean embebidas en timeline.qmd
# =============================================================================

suppressPackageStartupMessages({
  library(data.table)
  library(ggplot2)
  library(scales)
})

root <- "/Users/jcmunoz/Library/CloudStorage/OneDrive-UniversidadEAFIT/Projects/2026_WB_Bolivia"
fig_out <- file.path(root, "www/figures")
dir.create(fig_out, recursive = TRUE, showWarnings = FALSE)

tl <- fread(file.path(root, "01_data/timeline/timeline.csv"))
tl <- tl[Type != "title" & !is.na(Year)]

# Asignar época política
tl[, era := fcase(
  Year < 2006, "Pre-MAS\n(1990-2005)",
  Year < 2020, "Era Morales\n(2006-2019)",
  default     = "Áñez + Arce\n(2019-2025)"
)]
tl[, era := factor(era,
                    levels = c("Pre-MAS\n(1990-2005)",
                               "Era Morales\n(2006-2019)",
                               "Áñez + Arce\n(2019-2025)"))]

# Normalizar Group (eliminar vacíos)
tl[Group == "" | is.na(Group), Group := "Otros"]
tl[, Group := factor(Group, levels = c("Leyes", "Institucional", "Programas",
                                        "Eventos", "Externo", "Otros"))]

# Paleta navy + acentos
pal_groups <- c(
  "Leyes"         = "#14213D",
  "Institucional" = "#1F3057",
  "Programas"     = "#5B6F94",
  "Eventos"       = "#C2410C",
  "Externo"       = "#9A6E50",
  "Otros"         = "#9CA3AF"
)

# Tema base minimalista coherente con sitio
theme_site <- function() {
  theme_minimal(base_family = "Inter", base_size = 11) +
  theme(
    plot.background = element_rect(fill = "#FAFAF9", color = NA),
    panel.background = element_rect(fill = "#FAFAF9", color = NA),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "#E5E5E5", linewidth = 0.3),
    panel.grid.major.y = element_line(color = "#E5E5E5", linewidth = 0.3),
    axis.title = element_text(color = "#14213D", size = 10),
    axis.text = element_text(color = "#4A4A4A"),
    legend.position = "bottom",
    legend.title = element_text(color = "#14213D", size = 10, face = "bold"),
    legend.text = element_text(size = 10),
    plot.caption = element_text(color = "#6B7280", hjust = 0, size = 9, lineheight = 1.2),
    plot.title = element_text(color = "#14213D", size = 13, face = "bold"),
    plot.subtitle = element_text(color = "#6B7280", size = 10),
    strip.text = element_text(color = "#14213D", face = "bold", size = 11)
  )
}

# ── 1. DENSIDAD ANUAL APILADA POR GRUPO ──────────────────────────────────────
p1_data <- tl[, .N, by = .(Year, Group)]
# Asegurar todos los años en el rango aunque no tengan hitos
all_yr <- data.table(Year = 1990:2025)
all_groups <- unique(tl$Group)
grid <- CJ(Year = 1990:2025, Group = all_groups)
p1_data <- merge(grid, p1_data, by = c("Year","Group"), all.x = TRUE)
p1_data[is.na(N), N := 0]

p1 <- ggplot(p1_data, aes(x = Year, y = N, fill = Group)) +
  geom_col(width = 0.85, alpha = 0.95) +
  scale_fill_manual(values = pal_groups, drop = FALSE) +
  scale_x_continuous(breaks = seq(1990, 2025, 5), expand = c(0.01, 0.01)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05)),
                     breaks = scales::pretty_breaks(n = 5)) +
  geom_vline(xintercept = c(2005.5, 2019.5), linetype = "dashed",
              color = "#14213D", alpha = 0.45, linewidth = 0.4) +
  annotate("text", x = 1997.5, y = 5.4, label = "Pre-MAS",
            color = "#14213D", size = 3.2, fontface = "bold") +
  annotate("text", x = 2012.5, y = 5.4, label = "Era Morales",
            color = "#14213D", size = 3.2, fontface = "bold") +
  annotate("text", x = 2022, y = 5.4, label = "Áñez+Arce",
            color = "#14213D", size = 3.2, fontface = "bold") +
  labs(x = NULL, y = "Hitos documentados",
       fill = NULL,
       caption = "Fuente: 61 hitos de política agropecuaria 1990-2025 (Gaceta Oficial + Lexivox + medios + think tanks).\nLíneas verticales: cambio de gobierno.") +
  theme_site() +
  theme(legend.position = "top", legend.justification = "left")

ggsave(file.path(fig_out, "timeline_01_densidad_anual.png"),
       p1, width = 11, height = 5.2, dpi = 150, bg = "#FAFAF9")

# ── 2. HEATMAP AÑO × GRUPO ───────────────────────────────────────────────────
hm <- tl[, .N, by = .(Year, Group)]
grid_hm <- CJ(Year = 1990:2025, Group = unique(tl$Group))
hm <- merge(grid_hm, hm, by = c("Year","Group"), all.x = TRUE)
hm[is.na(N), N := 0]

p2 <- ggplot(hm, aes(x = Year, y = Group, fill = N)) +
  geom_tile(color = "#FAFAF9", linewidth = 0.6) +
  scale_fill_gradient(low = "#F0F0F0", high = "#14213D",
                      breaks = 0:5, name = "Hitos") +
  scale_x_continuous(breaks = seq(1990, 2025, 5), expand = c(0, 0)) +
  scale_y_discrete(limits = rev(levels(tl$Group))) +
  geom_vline(xintercept = c(2005.5, 2019.5), linetype = "dashed",
              color = "#C2410C", alpha = 0.55, linewidth = 0.5) +
  labs(x = NULL, y = NULL,
       caption = "Líneas verticales: transiciones de gobierno (dic 2005, nov 2019).") +
  theme_site() +
  theme(panel.grid = element_blank(),
        legend.position = "right",
        axis.text.y = element_text(size = 11, color = "#14213D",
                                    face = "bold"))

ggsave(file.path(fig_out, "timeline_02_heatmap.png"),
       p2, width = 11, height = 4, dpi = 150, bg = "#FAFAF9")

# ── 3. DISTRIBUCIÓN POR ÉPOCA POLÍTICA Y GRUPO ───────────────────────────────
era_g <- tl[, .N, by = .(era, Group)]
era_total <- tl[, .(total = .N, anios = uniqueN(Year)), by = era]
era_g <- merge(era_g, era_total, by = "era")
era_g[, pct := N / total * 100]

p3 <- ggplot(era_g, aes(x = era, y = N, fill = Group)) +
  geom_col(width = 0.7, alpha = 0.95) +
  scale_fill_manual(values = pal_groups, drop = FALSE) +
  geom_text(aes(label = N),
             position = position_stack(vjust = 0.5),
             color = "white", size = 3.4, fontface = "bold") +
  geom_text(data = era_total,
             aes(x = era, y = total + 1.3, label = sprintf("n=%d · %d años", total, anios)),
             color = "#14213D", size = 3.4, fontface = "bold",
             inherit.aes = FALSE) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(x = NULL, y = "Hitos por época",
       fill = NULL,
       caption = "Pre-MAS: 16 años (1990-2005). Era Morales: 14 años (2006-2019). Áñez+Arce: 7 años (2019-2025).") +
  theme_site() +
  theme(legend.position = "right",
        axis.text.x = element_text(size = 11, lineheight = 1.1))

ggsave(file.path(fig_out, "timeline_03_por_epoca.png"),
       p3, width = 10, height = 5, dpi = 150, bg = "#FAFAF9")

cat("✓ www/figures/timeline_01_densidad_anual.png\n")
cat("✓ www/figures/timeline_02_heatmap.png\n")
cat("✓ www/figures/timeline_03_por_epoca.png\n")
