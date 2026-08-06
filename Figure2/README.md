# Figure 2

This directory contains the scripts and workflow descriptions used to
generate the quantitative plots and experimental-image panels shown in
Figure 2.

## Panels

- Figure 2a: Clumping phenotype and AMN1 allele-swap experiments.
- Figure 2b: Spot-dilution assays across temperatures.
- Figure 2c: Quantification of thermotolerance from spot assays.
- Figure 2d: Competitive fitness of parental strains, the F1 hybrid, and recombinant segregants.
- Figure 2e: Spore viability and meiotic competence of segregant-derived diploids.

The complete underlying numerical values are provided in the Source Data
file associated with the article. Final panel assembly, color adjustments,
typography, labels, and graphical layout were prepared in Adobe Illustrator.


## Figure 2a: Clumping phenotype and AMN1 allele swaps

Figure 2a contains microscopy images illustrating the clumping phenotype
of parental strains, recombinant segregants, and AMN1 allele-swap strains.

The microscopy images were generated experimentally and assembled in
Adobe Illustrator. Labels, strain names, allele identities, spacing, and
final panel layout were added during figure assembly.

No custom analysis or plotting code was used for this panel. The strain
identities and associated genotype information are provided in the Source
Data and Supplementary Information associated with the article.

## Figure 2b: Spot-dilution assays across temperatures

Figure 2b shows spot-dilution assays of parental strains, the F1 hybrid,
and recombinant segregants grown at 30 °C, 37 °C, and 16 °C.

Five-fold serial dilutions were plated and incubated for 2 days at
30 °C and 37 °C and for 3 days at 16 °C.

The original plate images were cropped, aligned, labeled, and assembled
in Adobe Illustrator. Image adjustments were limited to figure layout,
spacing, labels, and graphical presentation and did not alter the
experimental results.

No custom analysis or plotting code was used to generate this panel.
The strain identities, experimental conditions, and corresponding
quantitative data are provided in the Methods section associated with the article.

## Figure 2c: Quantification of thermotolerance from spot assays

Spot-assay images acquired at 30 °C and 37 °C were quantified in
Fiji/ImageJ. Integrated spot intensities were measured for four serial
dilutions from each biological culture using consistent image-processing
and measurement settings.

Several approaches for summarizing growth across the dilution series were
evaluated. The final analysis used the equal-average method. For each
biological culture, spot intensities were averaged equally across the four
dilutions at each temperature:

- `S30_equal`: mean spot intensity across four dilutions at 30 °C
- `S37_equal`: mean spot intensity across four dilutions at 37 °C
- `R_equal`: `S37_equal / S30_equal`

The Figure 2c plot shows individual generation-0 `R_equal` measurements,
together with the mean and 95% confidence interval for each background.

The plot was generated in R using `ggplot2` and subsequently edited in
Adobe Illustrator to adjust colors, typography, labels, spacing, and final
panel layout. These graphical modifications did not alter the underlying
numerical values.

The complete Fiji/ImageJ measurements and processed thermotolerance values
are provided in the Source Data file associated with the article. 
