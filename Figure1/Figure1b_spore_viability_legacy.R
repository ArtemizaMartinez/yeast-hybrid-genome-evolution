# Figure 1b: Spore viability and fully viable tetrads
#
# This script documents the R workflow used to generate the base plot
# for Figure 1b. The complete underlying values are provided in the
# Source Data file associated with the article.
#
# The exported plot was subsequently edited in Adobe Illustrator to
# adjust colors, typography, labels, spacing, and final panel layout.
# These graphical edits did not alter the underlying numerical values.

library(ggplot2)

# The plotting table contained one row per cross and measurement,
# with the following columns:
#
# Cross
# Measurement
# Percentage
# Sample_size
#
# Example:
#
# plot_data <- data.frame(
#   Cross = ...,
#   Measurement = ...,
#   Percentage = ...,
#   Sample_size = ...
# )

crosses <- c(
  "S.c x S.c WT",
  "S.c x S.c pCLB2",
  "S.p x S.p WT",
  "S.p x S.p pCLB2",
  "S.c x S.p pCLB2",
  "S.c x S.p pCLB2 Sorted",
  "S.c x S.p Bozdag 2021"
)

# Percentages calculated from the Figure 1b Source Data
spore_viability <- c(
  91.477,
  64.535,
  97.826,
  83.333,
  0.625,
  23.505,
  32.6
)

fully_viable_tetrads <- c(
  77.273,
  34.884,
  95.652,
  66.667,
  0,
  2.717,
  5.3
)

# Total dissected spores for data generated in the current study.
# Published Bozdag et al. sample sizes were added to the final figure
# during figure assembly.
total_spores <- c(
  176,
  172,
  92,
  144,
  160,
  736,
  8148
)

# Create a data frame
data <- data.frame(
  Crosses = factor(crosses, levels = crosses),  # Maintain plotting order
  Measure = rep(c("Spore Viability", "Successful Meiosis"), each = length(crosses)),
  Percentage = c(spore_viability, successful_meiosis),
  Total_Tetrads = rep(total_tetrads, 2)
)

# Plot
plot1 <- ggplot(data, aes(x = Crosses, y = Percentage, fill = Measure)) +
  
  # Bar plot
  geom_bar(stat = "identity", position = position_dodge(width = 0.7), width = 0.6) +
  
  # Add sample size annotations above bars
  geom_text(
    aes(label = paste0("N=", Total_Tetrads)),
    position = position_dodge(width = 0.7),
    vjust = -0.8,
    size = 2,
    color = "black"
  ) +
  
  # Colors
  scale_fill_manual(values = c(
    "Spore Viability" = "darkmagenta",
    "Successful Meiosis" = "darkmagenta"
  )) +
  
  # Labels
  labs(
    title = "Spore Viability and Successful Meiosis Across Crosses",
    x = "Crosses",
    y = "Percentage",
    fill = "Measure"
  ) +
  
  # Theme
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
    axis.title = element_text(size = 10, face = "bold"),
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )

# Example export:
# ggsave("Figure1b_spore_viability_base.pdf", plot1, width = 10, height = 6)

# Display plot
print(plot1)


# Code-development note:
# The original analytical and plotting workflow was developed by the
# authors. This public version was reorganized and documented with
# assistance from ChatGPT (OpenAI) and reviewed by the authors.
