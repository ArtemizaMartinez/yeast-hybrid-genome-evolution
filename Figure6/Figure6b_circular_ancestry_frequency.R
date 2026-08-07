# Figure 6b: Circular parental-ancestry frequency across the genome
#
# This script documents the R workflow used to generate the circular
# ancestry-frequency plot shown in Figure 6.
#
# For each genomic position, parental ancestry frequencies were calculated
# across ten selected recombinant backgrounds. The two ancestry states were
# plotted as complementary frequencies along each chromosome using the
# circlize package.
#
# The complete ancestry assignments and processed frequency values are
# provided in the Source Data file associated with the article.
#
# The exported plot was subsequently edited in Adobe Illustrator to adjust
# colors, labels, typography, spacing, and final panel layout. These
# graphical modifications did not alter the underlying frequency values.

library(tidyverse)
library(circlize)

# Load ancestry assignments
df <- read.delim(
  "combinationsPositions.txt",
  sep = "\t",
  header = TRUE
)

# Recombinant backgrounds included in this analysis
selected_backgrounds <- c(
  "X1A", "X1B",
  "X2C", "X2D",
  "X3A", "X3D",
  "X4A", "X4B",
  "X5A", "X5B"
)

# ---------------------------------------------------------------
# Define chromosome coordinates
# ---------------------------------------------------------------

chrom_layout <- df %>%
  group_by(rname) %>%
  summarise(
    start = min(POS),
    end = max(POS),
    .groups = "drop"
  ) %>%
  arrange(rname)

# ---------------------------------------------------------------
# Calculate ancestry frequency at each genomic position
# ---------------------------------------------------------------

freq_df <- df %>%
  pivot_longer(
    cols = all_of(selected_backgrounds),
    names_to = "background",
    values_to = "species"
  ) %>%
  filter(!is.na(species)) %>%
  group_by(
    rname,
    POS,
    species
  ) %>%
  summarise(
    n = n(),
    .groups = "drop"
  ) %>%
  pivot_wider(
    names_from = species,
    values_from = n,
    values_fill = 0
  ) %>%
  mutate(
    total = `0` + `1`,
    freq0 = `0` / total,
    freq1 = `1` / total
  ) %>%
  left_join(
    chrom_layout,
    by = "rname"
  ) %>%

  # Reverse positions within each chromosome to match
  # the orientation used in the final circular figure
  mutate(
    POS_rev = start + end - POS
  )

# ---------------------------------------------------------------
# Generate circular plot
# ---------------------------------------------------------------

pdf(
  "Figure6b_circular_ancestry_frequency.pdf",
  width = 10,
  height = 10
)

circos.clear()

circos.par(
  track.height = 0.15,
  start.degree = 90,
  clock.wise = FALSE,
  gap.after = rep(2, nrow(chrom_layout)),
  cell.padding = c(0, 0, 0, 0)
)

# Initialize chromosomes
circos.initialize(
  factors = chrom_layout$rname,
  xlim = chrom_layout[, c("start", "end")]
)

# Plot ancestry frequencies
circos.trackPlotRegion(
  ylim = c(0, 1),
  bg.border = NA,
  track.height = 0.25,

  panel.fun = function(region, value, ...) {

    chromosome <- CELL_META$sector.index

    df_chr <- freq_df %>%
      filter(rname == chromosome)

    # Horizontal reference lines
    grid_vals <- seq(
      0,
      1,
      by = 0.1
    )

    for (y in grid_vals) {
      circos.lines(
        CELL_META$xlim,
        c(y, y),
        col = "gray85",
        lwd = 0.5,
        lty = 2
      )
    }

    # Frequency axis
    circos.yaxis(
      side = "left",
      at = grid_vals,
      labels.cex = 0.3,
      col = "gray30",
      tick.length = 0.02
    )

    # Plot the two complementary ancestry frequencies
    if (nrow(df_chr) > 0) {

      circos.lines(
        df_chr$POS_rev,
        df_chr$freq1,
        col = "#336583",
        lwd = 1.5
      )

      circos.lines(
        df_chr$POS_rev,
        df_chr$freq0,
        col = "#b36c6c",
        lwd = 1.5
      )
    }
  }
)

dev.off()

circos.clear()

# Code-development note:
# This script was developed by Artemiza A. Martinez
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
