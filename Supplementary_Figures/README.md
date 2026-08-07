# Supplementary Figures

This directory contains processed input data and custom scripts used to reproduce the quantitative analyses and plots shown in Supplementary Figures 1–10.

## Contents

- Supplementary Figure 1: Genome synteny and orthologous-gene length comparisons.
- Supplementary Figure 2: Tetrad dissection, ancestry tracks and chromosome analysis.
- Supplementary Figure 3: Phenotypic segregation, growth and mitochondrial analysis.
- Supplementary Figure 4: Protein-complex composition and mutation counts.
- Supplementary Figure 5: Thermotolerance trajectories.
- Supplementary Figure 6: Mutation homozygosity and autodiploidization.
- Supplementary Figure 7: Population counts and mutation spectra.
- Supplementary Figure 8: Genome-wide mutation-enrichment analyses.
- Supplementary Figure 9: HSP104 and BSC1 mutational patterns.
- Supplementary Figure 10: Structural locations of evolved Ku70 and Ku80 mutations.

## Notes

Microscopy images, spot-assay images, flow-cytometry profiles and author-created schematics are documented separately when no custom plotting code was used. Final figure assembly was performed in Adobe Illustrator.

## Panels Supplementary Figure 2

- Figure S2a: Tetrad-dissection images; no custom plotting code was used.
- Figure S2b: Parental ancestry and recombination maps for Tetrads 2–5. These maps were generated using the same chromosome-ancestry workflow described for Figure 1d.
- Figure S2c: Relationship between chromosome size and the number of uniparental inheritance events. A quasi-Poisson generalized linear model with a log link was used to visualize the relationship.


## Panels Supplementary Figure 3

- Figure S3a: Microscopy images of recombinant segregants; no custom plotting code was used.
- Figures S3b-c: Growth curves at 30 °C and 37 °C generated from OD600 measurements collected over time. Mean OD600 values were calculated across replicate measurements, with variability among replicates summarized for plotting.
- Figure S3d: Growth parameters were estimated by fitting growth curves to a Gompertz model using `scipy.optimize.curve_fit` in Python. The resulting growth-rate estimates were compared with competitive-fitness measurements.
- Figure S3e: Spot-assay and mitochondrial-ancestry panel assembled from experimental images and processed genomic information.


## Panels Supplementary Figure 6

- Figure S6d: Representative flow-cytometry profiles used to validate
  inferred ploidy states. Cells were prepared for DNA-content analysis
  using Sytox Green staining following ethanol fixation, RNase A and
  proteinase K treatment. No custom plotting code was used for this panel.


## Panels Supplementary Figure 7

- Figure S7a: Number of evolved populations per genetic background and ploidy state.
- Figure S7b: Relative proportions of mutation classes across hybrid populations,
  parental controls, and previously published experimental-evolution datasets.
- Figure S7c: Distribution of missense mutation counts across evolved hybrid populations.
- Figure S7d: Distribution of mutation counts in a previously published
  S. cerevisiae experimental-evolution dataset used for comparison.

Previously published experimental-evolution datasets generated in the lab
were included as reference datasets to compare mutation spectra and
mutation-count distributions with the hybrid populations analyzed in this study.

The complete underlying values used for the figure are provided in the
Source Data file associated with the article. Previously published data are
also available from their original publications.

The base plots were generated in R and subsequently assembled and formatted
in Adobe Illustrator.

## Final panel assembly and graphical formatting were performed in Adobe Illustrator.



