# Figure 1d: Chromosome ancestry and recombination blocks
#
# This script documents the chromoMap workflow used to generate
# chromosome ancestry maps for individual recombinant segregants.
#
# One annotation file was prepared for each segregant. Each file
# contained the chromosome coordinates of ancestry blocks inferred
# from the processed ancestry analysis provided in the Source Data
# file associated with the article.
#
# Individual chromosome maps were generated in R and subsequently
# assembled and edited in Adobe Illustrator. Colors, labels, spacing,
# and final panel layout were modified in Illustrator without changing
# the underlying chromosome coordinates.

# Install chromoMap if needed:
# install.packages("chromoMap")

# Load necessary package
library(chromoMap)

# Chromosome-coordinate file
# Expected columns:
# chromosome, start, end, centromere_position
chr_file <- "Chr_LN.txt"

# Segregant-specific ancestry annotation file
# Expected columns:
# segment_id, chromosome, start, end
#
# Replace this filename with the annotation file for the segregant
# being plotted.
anno_file <- "annotation_pos1A.txt"

# Inspect chromosome-coordinate input
head(
  read.table(
    chr_file,
    sep = "\t",
    stringsAsFactors = FALSE,
    header = FALSE
  )
)

# Generate chromosome ancestry map
chromoMap(
  chr_file,
  anno_file,
  segment_annotation = TRUE,
  export.options = TRUE
)

# The map was exported and subsequently edited and assembled
# with the other Tetrad 1 segregants in Adobe Illustrator.

# Code-development note:
# The original plotting workflow and scientific content were developed
# by the authors. This public version was lightly reorganized and
# documented with assistance from ChatGPT (OpenAI), and reviewed by
# the authors.
