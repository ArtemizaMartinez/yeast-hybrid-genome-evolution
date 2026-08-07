# Supplementary Figure 7:
# Evolved population counts and mutation spectra
#
# This script documents the R workflow used to generate the base plots
# for Supplementary Figure 7 from processed mutation-summary tables.
#
# Figure S7 includes:
#   a) number of evolved populations per genetic background
#   b) proportions of mutation classes across datasets
#   c) distribution of missense mutations per evolved hybrid population
#   d) comparison with a published S. cerevisiae evolution dataset
#
# The complete underlying values are provided in the Source Data file
# associated with the article.
#
# Final graphical formatting and panel assembly were performed in
# Adobe Illustrator.

library(tidyverse)
library(readxl)

# ===============================================================
# Panel a: evolved population counts by background
# ===============================================================

# Expected columns:
# Background
# Population
# Ploidy
# Total_mutations

populations <- read_excel(
  "Source_Data_Evolved_Mutations.xlsx",
  sheet = "Supplementary Figure 7a"
)

population_counts <- populations %>%
  group_by(Background, Ploidy) %>%
  summarise(
    n_populations = n_distinct(Population),
    .groups = "drop"
  )

plot_S7a <- ggplot(
  population_counts,
  aes(
    x = Background,
    y = n_populations,
    fill = Ploidy
  )
) +
  geom_col() +
  labs(
    x = "Background",
    y = "Population count"
  ) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(
      angle = 90,
      hjust = 1
    )
  )

# ===============================================================
# Panel b: mutation-class proportions
# ===============================================================

# Expected columns:
# Dataset
# Mutation_class
# Count

mutation_classes <- read_excel(
  "Source_Data.xlsx",
  sheet = "Supplementary Figure 7b"
)

mutation_classes <- mutation_classes %>%
  group_by(Dataset) %>%
  mutate(
    proportion = Count / sum(Count)
  ) %>%
  ungroup()

plot_S7b <- ggplot(
  mutation_classes,
  aes(
    x = Dataset,
    y = proportion,
    fill = Mutation_class
  )
) +
  geom_col(
    position = "fill"
  ) +
  scale_y_continuous(
    labels = scales::percent
  ) +
  labs(
    x = NULL,
    y = "Mutation proportion"
  ) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(
      angle = 45,
      hjust = 1
    )
  )

# ===============================================================
# Panel c: missense mutations per hybrid population
# ===============================================================

# Expected columns:
# Background
# Population
# Missense_count

missense_hybrids <- read_excel(
  "Source_Data.xlsx",
  sheet = "Supplementary Figure 7c"
)

plot_S7c <- ggplot(
  missense_hybrids,
  aes(x = Missense_count)
) +
  geom_histogram(
    bins = 30,
    color = "black",
    fill = "gray70"
  ) +
  labs(
    x = "Number of missense mutations",
    y = "Frequency"
  ) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

# ===============================================================
# Panel d: comparison dataset
# ===============================================================

# Expected column:
# Mutation_count

comparison_data <- read_excel(
  "Source_Data.xlsx",
  sheet = "Supplementary Figure 7d"
)

plot_S7d <- ggplot(
  comparison_data,
  aes(x = Mutation_count)
) +
  geom_histogram(
    bins = 30,
    color = "black",
    fill = "gray70"
  ) +
  labs(
    x = "Number of mutations",
    y = "Frequency"
  ) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  )

# ===============================================================
# Export base plots
# ===============================================================

ggsave(
  "FigureS7a_population_counts.pdf",
  plot_S7a,
  width = 7,
  height = 3
)

ggsave(
  "FigureS7b_mutation_classes.pdf",
  plot_S7b,
  width = 6,
  height = 4
)

ggsave(
  "FigureS7c_missense_distribution.pdf",
  plot_S7c,
  width = 4,
  height = 3
)

ggsave(
  "FigureS7d_reference_distribution.pdf",
  plot_S7d,
  width = 4,
  height = 3
)

# Code-development note:
# This script reconstructs the plotting workflow used for Supplementary
# Figure 7 from the processed Source Data tables.
#
# It was prepared by Artemiza A. Martinez with assistance from
# ChatGPT (OpenAI) for code reconstruction, organization, and
# documentation.
#
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
