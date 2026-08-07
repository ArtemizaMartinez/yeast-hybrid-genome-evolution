# Figure 4b-c: Fitness trajectories during experimental evolution
#
# This script documents the R workflow used to generate the base plots
# for Figures 4b and 4c.
#
# Figure 4b shows populations founded from haploid parental strains
# and recombinant segregants.
#
# Figure 4c shows populations founded from diploid or higher-ploidy
# derivatives.
#
# Generation-0 values are shown as points with error bars, whereas
# evolved populations are displayed as violin plots with individual
# population measurements.
#
# The complete numerical values and sample information are provided
# in the Source Data file associated with the article.
#
# The exported plots were subsequently edited in Adobe Illustrator
# to adjust colors, labels, typography, spacing,
# significance labels, and final panel layout.

library(ggplot2)
library(dplyr)
library(readxl)
library(stringr)

# Load processed fitness data
data <- read_excel("FitnessGen0_5k_10k.xlsx")

# Clean labels
data <- data %>%
  mutate(
    Mating = str_trim(Mating),
    Generation = str_trim(Generation)
  )

# Generations displayed in the final figure
evolved_generations <- c(
  "G1000",
  "G5000",
  "G10000"
)

# ---------------------------------------------------------------
# Color palettes
# ---------------------------------------------------------------

haploid_colors <- c(
  "#316484", "#b46c6c",
  "#26432FFF", "#26432FFF", "#26432FFF", "#26432FFF",
  "#4D6D93FF", "#4D6D93FF", "#4D6D93FF", "#4D6D93FF",
  "#6FB382FF", "#6FB382FF", "#6FB382FF", "#6FB382FF",
  "#DCCA2CFF", "#DCCA2CFF", "#DCCA2CFF", "#DCCA2CFF",
  "#92BBD9FF", "#92BBD9FF", "#92BBD9FF", "#92BBD9FF"
)

derived_colors <- c(
  "#316484", "#b46c6c", "darkmagenta",
  "#26432FFF", "#26432FFF", "#26432FFF", "#26432FFF",
  "#4D6D93FF", "#4D6D93FF", "#4D6D93FF", "#4D6D93FF",
  "#6FB382FF", "#6FB382FF", "#6FB382FF", "#6FB382FF",
  "#DCCA2CFF", "#DCCA2CFF", "#DCCA2CFF", "#DCCA2CFF",
  "#92BBD9FF", "#92BBD9FF", "#92BBD9FF", "#92BBD9FF"
)

# Transparency distinguishes evolved generations
alpha_vals <- c(
  "G1000" = 0.35,
  "G5000" = 0.55,
  "G10000" = 0.75
)

# ---------------------------------------------------------------
# Function used for both Figure 4b and Figure 4c
# ---------------------------------------------------------------

make_fitness_plot <- function(
  input_data,
  mating_group,
  colors,
  output_file
) {

  # Select the relevant founder group
  subset_data <- input_data %>%
    filter(Mating == mating_group)

  # Generation-0 grouped estimates
  G0 <- subset_data %>%
    filter(Generation == "G0") %>%
    mutate(
      mean_SC = selection_coefficient,
      Xgroup = paste0(Competition, "_G0")
    )

  # Independently evolved populations
  evolved <- subset_data %>%
    filter(Generation %in% evolved_generations) %>%
    mutate(
      Xgroup = paste0(Competition, "_", Generation)
    ) %>%
    group_by(Xgroup) %>%
    mutate(N = n()) %>%
    ungroup()

  # Vertical separators between genetic backgrounds
  divider_positions <- seq(
    4.5,
    length(unique(evolved$Xgroup)) + 0.5,
    by = 4
  )

  # Plot
  p <- ggplot(
    evolved,
    aes(
      x = Xgroup,
      y = selection_coefficient * 100,
      fill = Competition
    )
  ) +

    # Distribution of independently evolved populations
    geom_violin(
      data = filter(evolved, N > 1),
      aes(alpha = Generation),
      trim = FALSE,
      width = 4.5,
      color = NA
    ) +

    # Individual evolved populations
    geom_jitter(
      aes(color = Competition),
      position = position_jitter(width = 0.2),
      size = 0.5
    ) +

    # Fallback when only one evolved population is available
    geom_point(
      data = filter(evolved, N == 1),
      aes(color = Competition),
      position = position_jitter(width = 0.2),
      size = 1.5
    ) +

    # Generation-0 grouped fitness estimate
    geom_point(
      data = G0,
      aes(
        x = Xgroup,
        y = mean_SC * 100,
        fill = Competition
      ),
      shape = 21,
      color = "black",
      stroke = 0.4,
      size = 4.5,
      alpha = 0.8,
      inherit.aes = FALSE
    ) +

    # Generation-0 error bars
    geom_errorbar(
      data = G0,
      aes(
        x = Xgroup,
        ymin = (mean_SC - CI) * 100,
        ymax = (mean_SC + CI) * 100
      ),
      color = "black",
      width = 0.1,
      inherit.aes = FALSE
    ) +

    # Separators between backgrounds
    geom_vline(
      xintercept = divider_positions,
      color = "gray70",
      linetype = "dashed",
      linewidth = 0.3
    ) +

    # Reference fitness
    geom_hline(
      yintercept = 0,
      linewidth = 0.5,
      color = "#006666",
      linetype = "longdash"
    ) +

    scale_fill_manual(values = colors) +
    scale_color_manual(values = colors) +
    scale_alpha_manual(
      values = alpha_vals,
      guide = "none"
    ) +

    scale_y_continuous(
      limits = c(-20, 30),
      breaks = seq(-20, 30, 10)
    ) +

    labs(
      x = NULL,
      y = "Fitness effect (%)"
    ) +

    theme_bw() +

    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(
        angle = 90,
        hjust = 1,
        size = 6
      ),
      legend.position = "none"
    )

  print(p)

  ggsave(
    output_file,
    plot = p,
    width = 14,
    height = 4,
    dpi = 300
  )
}

# ---------------------------------------------------------------
# Figure 4b: haploid-founded populations
# ---------------------------------------------------------------

make_fitness_plot(
  input_data = data,
  mating_group = "Haploid",
  colors = haploid_colors,
  output_file = "Figure4b_haploid_fitness_trajectories.pdf"
)

# ---------------------------------------------------------------
# Figure 4c: diploid / higher-ploidy-founded populations
# ---------------------------------------------------------------

make_fitness_plot(
  input_data = data,
  mating_group = "Diploid",
  colors = derived_colors,
  output_file = "Figure4c_derived_fitness_trajectories.pdf"
)

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code organization and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
