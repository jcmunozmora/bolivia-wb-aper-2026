# Tema visual World Bank para ggplot2
# Colores y tipografía siguiendo WB Visual Identity Guidelines

# ── Paleta de colores World Bank ──────────────────────────────────────────────
WB_BLUE    <- "#009FDA"   # Azul principal WB
WB_NAVY    <- "#002244"   # Azul oscuro
WB_TEAL    <- "#00B3A2"   # Teal
WB_GREEN   <- "#78BE20"   # Verde
WB_ORANGE  <- "#F05023"   # Naranja
WB_RED     <- "#EB1C2D"   # Rojo
WB_YELLOW  <- "#FDB714"   # Amarillo
WB_GREY    <- "#9EA4A8"   # Gris
WB_GREY_LT <- "#F5F5F5"  # Gris claro (fondos)

# Paleta secuencial para mapas y series
WB_PALETTE <- c(
  WB_BLUE, WB_TEAL, WB_GREEN, WB_YELLOW,
  WB_ORANGE, WB_RED, WB_GREY, WB_NAVY, "#8E44AD"
)

# Paleta divergente (para desvíos de benchmark)
WB_DIVERGE <- c(WB_RED, "#FFFFFF", WB_BLUE)

# ── Tema ggplot2 World Bank ───────────────────────────────────────────────────
theme_wb <- function(base_size = 11, base_family = "sans") {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # Fondo
      plot.background  = ggplot2::element_rect(fill = "white", color = NA),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.grid.major = ggplot2::element_line(color = "#E5E5E5", linewidth = 0.4),
      panel.grid.minor = ggplot2::element_blank(),
      panel.border     = ggplot2::element_blank(),

      # Títulos
      plot.title    = ggplot2::element_text(
        color = WB_NAVY, size = base_size + 2,
        face = "bold", margin = ggplot2::margin(b = 4)
      ),
      plot.subtitle = ggplot2::element_text(
        color = WB_GREY, size = base_size,
        margin = ggplot2::margin(b = 8)
      ),
      plot.caption  = ggplot2::element_text(
        color = WB_GREY, size = base_size - 2,
        hjust = 0, margin = ggplot2::margin(t = 8)
      ),

      # Ejes
      axis.title   = ggplot2::element_text(color = WB_NAVY, size = base_size - 1),
      axis.text    = ggplot2::element_text(color = "#555555", size = base_size - 1),
      axis.ticks   = ggplot2::element_blank(),
      axis.line.x  = ggplot2::element_line(color = WB_NAVY, linewidth = 0.5),
      axis.line.y  = ggplot2::element_blank(),

      # Leyenda
      legend.title    = ggplot2::element_text(color = WB_NAVY, size = base_size - 1,
                                               face = "bold"),
      legend.text     = ggplot2::element_text(color = "#555555", size = base_size - 1),
      legend.key      = ggplot2::element_rect(fill = "white", color = NA),
      legend.position = "right",

      # Facets
      strip.text       = ggplot2::element_text(color = WB_NAVY, face = "bold",
                                                size = base_size - 1),
      strip.background = ggplot2::element_rect(fill = WB_GREY_LT, color = NA),

      # Márgenes del gráfico
      plot.margin = ggplot2::margin(12, 12, 12, 12)
    )
}

# ── Escalas de color predefinidas ─────────────────────────────────────────────
scale_fill_wb <- function(...) {
  ggplot2::scale_fill_manual(values = WB_PALETTE, ...)
}

scale_color_wb <- function(...) {
  ggplot2::scale_color_manual(values = WB_PALETTE, ...)
}

scale_fill_wb_gradient <- function(low = WB_GREY_LT, high = WB_BLUE, ...) {
  ggplot2::scale_fill_gradient(low = low, high = high, ...)
}

# Registrar tema como default del proyecto
ggplot2::theme_set(theme_wb())
