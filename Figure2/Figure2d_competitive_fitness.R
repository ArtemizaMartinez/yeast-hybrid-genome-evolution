#Figure 2d: Competitive fitness of parental strains,
# the F1 hybrid, and recombinant segregants
#
# February 2023
# Artemiza Martinez
#
# This script documents the R workflow used to generate the base
# competitive-fitness plot for Figure 2d.
#
# The complete underlying fitness measurements and grouped estimates
# are provided in the Source Data file associated with the article.
#
# The plot was subsequently edited in Adobe Illustrator to adjust
# typography, labels, spacing, significance annotations, and final
# panel layout. These graphical edits did not alter the numerical values.

library(ggplot2)
library(dplyr)
library(forcats)

# Read processed competitive-fitness data
#
# Expected columns include:
# Mating
# Competition
# Position
# selection_coefficient
# selection_coefficient_g
# CI_g
G0_data <- read.delim(
  "Data_plotting_G0.txt",
  na.strings = c("NA", ""),
  stringsAsFactors = FALSE
)

# Retain haploid parental strains and recombinant segregants
Haploids <- G0_data %>%
  filter(Mating %in% c("MATa", "MATalpha"))

# Colors used for parental strains, the F1 hybrid, and tetrad groups
mycolors6 <- c(
  "#316484",  # S. cerevisiae
  "#b46c6c",  # S. paradoxus
  "darkmagenta", #F1 diploid
  "#26432FFF", "#26432FFF", "#26432FFF", "#26432FFF",
  "#4D6D93FF", "#4D6D93FF", "#4D6D93FF", "#4D6D93FF",
  "#6FB382FF", "#6FB382FF", "#6FB382FF", "#6FB382FF",
  "#DCCA2CFF", "#DCCA2CFF", "#DCCA2CFF", "#DCCA2CFF",
  "#92BBD9FF", "#92BBD9FF", "#92BBD9FF", "#92BBD9FF"
)

# Preserve the plotting order defined by Position
Haploids <- Haploids %>%
  mutate(
    Competition = fct_reorder(Competition, Position)
  )

# Generate competitive-fitness plot
plot_2d <- ggplot(
  Haploids,
  aes(
    x = Competition,
    y = selection_coefficient * 100
  )
) +
  
  # Individual biological competition measurements
  geom_point(
    aes(colour = Competition),
    size = 4.5,
    alpha = 0.6,
    shape = 19
  ) +
  
  scale_color_manual(
    values = mycolors6
  ) +
  
  # Grouped selection-coefficient estimate
  geom_point(
    aes(y = selection_coefficient_g * 100),
    size = 1.5,
    colour = "black"
  ) +
  
  # Error around the grouped estimate
  geom_errorbar(
    aes(
      ymin = (selection_coefficient_g - CI_g) * 100,
      ymax = (selection_coefficient_g + CI_g) * 100
    ),
    width = 0.1
  ) +
  
  # Reference line corresponding to the S. cerevisiae reference
  geom_hline(
    yintercept = 0,
    linewidth = 0.5,
    colour = "#006666",
    linetype = "longdash"
  ) +
  
  # Separators between parental strains and tetrads
  geom_vline(
    xintercept = c(3.5, 7.5, 11.5, 15.5, 19.5),
    linewidth = 0.5,
    colour = "darkgray",
    linetype = "dashed"
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
      vjust = 0.5
    ),
    legend.position = "none"
  )

print(plot_2d)

# Export the base plot before Adobe Illustrator editing
ggsave(
  filename = "Figure2d_competitive_fitness_haploids.pdf",
  plot = plot_2d,
  units = "in",
  width = 10,
  height = 3,
  dpi = 300
)

# Code-development note:
# This script was developed by Artemiza A. Martinez
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
