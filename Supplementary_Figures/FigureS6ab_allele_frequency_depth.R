# Supplementary Figure 6a-b:
# Allele frequency and sequencing depth of evolved populations
#
# The same plotting workflow was applied to two datasets:
#
# Figure S6a:
#   populations founded from diploid/higher-ploidy ancestors
#   sequenced at generation 2400
#
# Figure S6b:
#   populations founded from haploid ancestors
#   sequenced at generation 5000
#
# Each point represents a called mutation. Allele frequency is plotted
# against sequencing depth, with marginal histograms showing the
# corresponding distributions.
#
# Final classification of mutations and the complete numerical values
# are provided in the Source Data file.
#
# Final panel assembly and graphical formatting were performed in
# Adobe Illustrator.

library(ggplot2)
library(cowplot)

# ---------------------------------------------------------------
# Function used for both datasets
# ---------------------------------------------------------------

make_frequency_depth_plot <- function(
  input_file,
  output_file,
  panel_label
) {

  # Load data
  dat <- read.delim(
    input_file,
    stringsAsFactors = FALSE
  )

  # Ensure plotting variables are numeric
  dat$Frequency <- as.numeric(dat$Frequency)
  dat$read.depth <- as.numeric(dat$read.depth)

  # Remove incomplete observations
  dat <- dat[
    complete.cases(
      dat$Frequency,
      dat$read.depth
    ),
  ]

  # -------------------------------------------------------------
  # Scatter plot
  # -------------------------------------------------------------

  p <- ggplot(
    dat,
    aes(
      x = Frequency,
      y = read.depth
    )
  ) +

    geom_point(
      color = "black",
      alpha = 0.25,
      size = 0.7
    ) +

    # Allele-frequency reference threshold
    geom_vline(
      xintercept = 0.9,
      linewidth = 0.5,
      color = "red",
      linetype = "dashed"
    ) +

    labs(
      title = panel_label,
      x = "Allele frequency",
      y = "Sequencing depth"
    ) +

    theme_bw() +

    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
    )

  # -------------------------------------------------------------
  # Marginal histograms
  # -------------------------------------------------------------

  hist_x <- axis_canvas(
    p,
    axis = "x"
  ) +
    geom_histogram(
      data = dat,
      aes(x = Frequency),
      color = "black",
      fill = "gray"
    )

  hist_y <- axis_canvas(
    p,
    axis = "y"
  ) +
    geom_histogram(
      data = dat,
      aes(y = read.depth),
      color = "black",
      fill = "gray"
    )

  # Combine scatter plot and marginal histograms
  final_plot <- p %>%
    insert_xaxis_grob(
      hist_x,
      grid::unit(0.2, "null"),
      position = "top"
    ) %>%
    insert_yaxis_grob(
      hist_y,
      grid::unit(0.2, "null"),
      position = "right"
    ) %>%
    ggdraw()

  # Export
  ggsave(
    output_file,
    plot = final_plot,
    width = 5,
    height = 3,
    units = "in",
    dpi = 300
  )

  return(final_plot)
}

# ---------------------------------------------------------------
# Figure S6a:
# diploid / higher-ploidy founders, generation 2400
# ---------------------------------------------------------------

plot_G2400 <- make_frequency_depth_plot(
  input_file = "MutationsZygosity2400.txt",
  output_file = "FigureS6a_G2400_frequency_depth.pdf",
  panel_label = "G2400 (diploid/polyploid ancestors)"
)

# ---------------------------------------------------------------
# Figure S6b:
# haploid founders, generation 5000
# ---------------------------------------------------------------

plot_G5000 <- make_frequency_depth_plot(
  input_file = "MutationsZygosity5000.txt",
  output_file = "FigureS6b_G5000_frequency_depth.pdf",
  panel_label = "G5000 (haploid ancestors)"
)

# Code-development note:
# This script was developed by Artemiza A. Martinez
# ChatGPT (OpenAI) for organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
