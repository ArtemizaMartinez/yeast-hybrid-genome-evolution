# Supplementary Figure 1: Gene-size comparison and Z-score analysis
#
# This script documents the Python workflow used to compare coding-sequence
# lengths between S. cerevisiae and S. paradoxus orthologs and to identify
# outlier genes based on absolute size differences.
#
# For each gene pair, the absolute CDS-length difference was calculated and
# converted to a Z-score. Genes with |Z| > 5 were highlighted as outliers
# in the correlation plot.
#
# The complete underlying values are provided in the supplementary
# data
#
# The exported plot was subsequently assembled and formatted in
# Adobe Illustrator.

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Load gene-size comparison table
file_path = "Annotated_genesComparison_names.txt"
data = pd.read_csv(file_path, delimiter="\t")

# Rename columns to match the expected structure
data.columns = [
    "Gene Name",
    "CDS Length (bp) in SACE",
    "CDS Length (bp) in SAPA"
]

# Remove rows with missing values
data = data.dropna()

# Calculate absolute difference in CDS length
data["Difference"] = abs(
    data["CDS Length (bp) in SACE"] -
    data["CDS Length (bp) in SAPA"]
)

# Calculate Z-scores
mean_diff = data["Difference"].mean()
std_diff = data["Difference"].std()

data["Z-Score"] = (
    data["Difference"] - mean_diff
) / std_diff

# Save processed table
output_excel_file = "gene_size_z_scores.xlsx"
data.to_excel(
    output_excel_file,
    index=False,
    sheet_name="Z-Scores"
)

# Define outlier threshold
z_threshold = 5
outliers = data[data["Z-Score"].abs() > z_threshold]

# Create scatter plot
plt.figure(figsize=(12, 8))

# All genes
plt.scatter(
    data["CDS Length (bp) in SACE"],
    data["CDS Length (bp) in SAPA"],
    alpha=0.6,
    label="Non-outlier genes"
)

# Outlier genes
plt.scatter(
    outliers["CDS Length (bp) in SACE"],
    outliers["CDS Length (bp) in SAPA"],
    color="red",
    label="Outliers (|Z| > 5)",
    edgecolor="black"
)

# Annotate outliers
for _, row in outliers.iterrows():
    plt.text(
        row["CDS Length (bp) in SACE"],
        row["CDS Length (bp) in SAPA"],
        row["Gene Name"],
        fontsize=8,
        color="darkred",
        alpha=0.7
    )

# Plot formatting
plt.title("Gene-size comparison between SACE and SAPA")
plt.xlabel("CDS length (bp) in SACE")
plt.ylabel("CDS length (bp) in SAPA")
plt.grid(True)
plt.legend()

# Save plot
output_pdf_file = "gene_size_correlation_outliers_annotated_genes.pdf"
plt.savefig(output_pdf_file, format="pdf")

plt.show()

print(f"Z-scores and processed data saved to {output_excel_file}.")
print(f"Annotated plot saved to {output_pdf_file}.")

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
