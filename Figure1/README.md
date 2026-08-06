# Figure 1

This directory contains the processed input data and custom scripts used to reproduce the quantitative analyses and plots shown in Figure 1.

## Panels

- Figure 1a: Author-created schematic assembled in Adobe Illustrator; no custom analysis code was used.
- Figure 1b: Spore viability and fully viable tetrad analysis.
- Figure 1c: Summary of recombinant segregants
- Figure 1d: Ancestry blocks and recombination patterns across recombinant segregants.

## Figure 1d: Chromosome ancestry and recombination blocks

Chromosome ancestry maps were generated in R using the `chromoMap`
package. A chromosome-coordinate file defined chromosome lengths and
centromere positions, and a separate annotation file for each segregant
defined the coordinates of ancestry segments.
Individual maps were generated separately for the four segregants of
Tetrad 1. The exported maps were assembled in Adobe Illustrator, where
colors, labels, spacing, and final panel design were modified. These
graphical edits did not alter the underlying chromosome coordinates.
