# Supplementary Figure 9:
# Residue-level alignment divergence plots
#
# This script documents the R workflow used to visualize residue-level
# divergence from pairwise protein alignments processed in Python.
#
# Input files were generated from aligned FASTA files and contain one row
# per aligned position, with each position classified as:
#   Match
#   Mismatch
#   Gap
#
# The script can generate:
#   1) a simple residue-divergence plot
#   2) a residue-divergence plot with highlighted functional domains
#
# Final graphical formatting and panel assembly were performed in
# Adobe Illustrator.

library(ggplot2)

# ---------------------------------------------------------------
# Generic plotting function
# ---------------------------------------------------------------

plot_alignment_divergence <- function(
  input_file,
  output_file,
  title_text = "Residue alignment visualization",
  domain_data = NULL
) {

  # Load residue-level alignment table
  alignment_data <- read.csv(
    input_file,
    stringsAsFactors = FALSE
  )

  # Keep comparison label
  comparison_label <- unique(alignment_data$Comparison)

  if (length(comparison_label) == 0) {
    comparison_label <- ""
  }

  # Base plot
  p <- ggplot(
    alignment_data,
    aes(x = Position, y = 1)
  ) +

    # Residue-level state
    geom_segment(
      aes(
        x = Position,
        xend = Position,
        y = 0.9,
        yend = 1.1,
        color = Alignment_State
      ),
      linewidth = 5
    ) +

    # Alignment-state colors
    scale_color_manual(
      values = c(
        "Match" = "grey70",
        "Mismatch" = "#4c4582",
        "Gap" = "black"
      )
    ) +

    labs(
      title = title_text,
      subtitle = comparison_label,
      x = "Residue position",
      y = NULL,
      color = "Alignment state"
    ) +

    theme_minimal() +

    theme(
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.position = "right"
    )

  # Optional: add highlighted domains
  if (!is.null(domain_data)) {
    p <- p +
      geom_rect(
        data = domain_data,
        aes(
          xmin = start,
          xmax = end,
          ymin = 0.8,
          ymax = 1.2
        ),
        fill = "blue",
        alpha = 0.3,
        inherit.aes = FALSE
      )
  }

  # Export
  ggsave(
    output_file,
    plot = p,
    units = "in",
    width = 10,
    height = 5,
    dpi = 300
  )

  return(p)
}

# ---------------------------------------------------------------
# Panel a,b and c : HSP104 / BSC1
# ---------------------------------------------------------------

plot<- plot_alignment_divergence(
  input_file = "HSP104_alignment_plot_input.csv",  ### and BSC1
  output_file = "FigureS9_HSP104_alignment_divergence.pdf",
  title_text = "Residue alignment visualization"
)


# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
