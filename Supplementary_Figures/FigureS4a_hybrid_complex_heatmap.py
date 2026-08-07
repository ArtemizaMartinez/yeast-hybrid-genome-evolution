# Supplementary Figure 4a:
# Hybrid versus uniparental protein-complex composition
#
# This script documents the Python workflow used to generate the base
# heatmap for Supplementary Figure 4a.
#
# Protein complexes were classified as hybrid or uniparental in each
# recombinant segregant. Hybrid status was converted to a binary matrix
# for visualization:
#
#   hybrid     = 1
#   non-hybrid = 0
#
# Complexes were grouped according to the number of genes/subunits per
# complex.
#
# The complete underlying values are provided in the Source Data
#
# The exported heatmap was subsequently edited in Adobe Illustrator to
# adjust colors, labels, typography, spacing, ordering annotations, and
# final panel layout.

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# ---------------------------------------------------------------
# Load processed protein-complex table
# ---------------------------------------------------------------

df = pd.read_csv(
    "hybrid_resultsJustOrthologs_with_counts.csv"
)

# ---------------------------------------------------------------
# Prepare heatmap matrix
# ---------------------------------------------------------------

# Use complex size as the row identifier
df["Genes per Complex"] = df["Genes per Complex"].astype(str)

df = df.set_index(
    "Genes per Complex"
)

# Remove columns not used in the heatmap
df = df.drop(
    columns=[
        "Complex_Name",
        "Unnamed: 22",
        "Expected",
        "Observed"
    ],
    errors="ignore"
)

# Convert hybrid status to binary values
heatmap_data = df.replace({
    "hybrid": 1,
    "non-hybrid": 0
})

# Ensure the matrix is numeric
heatmap_data = (
    heatmap_data
    .apply(pd.to_numeric, errors="coerce")
    .fillna(0)
    .astype(int)
)

# ---------------------------------------------------------------
# Generate heatmap
# ---------------------------------------------------------------

plt.figure(
    figsize=(8, 10)
)

# Purple color scale used for the base plot
cmap = sns.light_palette(
    "#4c4582",
    as_cmap=True
)

sns.heatmap(
    heatmap_data,
    cmap=cmap,
    cbar_kws={
        "label": "Hybrid status (1 = hybrid)"
    }
)

plt.xlabel("Segregant")
plt.ylabel("Genes per complex")

plt.tight_layout()

# ---------------------------------------------------------------
# Export base plot
# ---------------------------------------------------------------

plt.savefig(
    "FigureS4a_hybrid_complex_heatmap.pdf",
    format="pdf",
    bbox_inches="tight"
)

plt.show()

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
