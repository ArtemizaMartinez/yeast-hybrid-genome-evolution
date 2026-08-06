# Load necessary libraries
library(ggplot2)
library(tidyverse)

# The plotting table contained the following columns:
#
# Sample  = recombinant segregant identifier
# Parent  = parental species
# Percent = genome proportion inherited from that parent
#
# Complete values are provided in the Figure 1c-d Source Data sheet.

mycolors5 <- c("#6FA8DC", "#D9A6B0")

Plot1 <- ggplot(
  data = BinomialHybData,
  aes(
    x = Sample,
    y = Percent * 100,
    fill = Parent
  )
) +
  geom_bar(stat = "identity") +
  labs(
    y = "Parent contribution (%)",
    x = "F1 hybrids"
  ) +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
  ) +
  scale_fill_manual(values = mycolors5)

Plot2 <- Plot1 + coord_flip()

# Example export before editing in Adobe Illustrator
# ggsave(
#   "ParentsContributionPercent.pdf",
#   plot = Plot2,
#   units = "in",
#   width = 4,
#   height = 7,
#   dpi = 300
# )

print(Plot2)

# Code-development note:
# The original plotting workflow and scientific content were developed
# by the authors. This public version was lightly reorganized and
# documented with assistance from ChatGPT (OpenAI), and reviewed by
# the authors.
