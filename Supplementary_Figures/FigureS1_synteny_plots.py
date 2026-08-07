# Supplementary Figure 1: Chromosome-level synteny plots
#
# This script documents the Python workflow used to generate the base plots
# for Supplementary Figure 1.
#
# Orthologous reciprocal best-hit gene pairs between S. cerevisiae and
# S. paradoxus were identified using SynChro. The resulting RBH table was
# then plotted as chromosome-specific synteny scatter plots.
#

# The exported plots were subsequently assembled and formatted in
# Adobe Illustrator.

import pandas as pd
import matplotlib.pyplot as plt

# Load reciprocal best-hit pairs
file_path = "SACE.SAPA.rbh.pairs"

# Define columns
columns = [
    "Gene_ID_S_cerevisiae",
    "Region_S_cerevisiae",
    "Start_S_cerevisiae",
    "End_S_cerevisiae",
    "Length_S_cerevisiae",
    "Gene_ID_S_paradoxus",
    "Region_S_paradoxus",
    "Start_S_paradoxus",
    "End_S_paradoxus",
    "Length_S_paradoxus",
    "Percentage_Similarity",
    "Orientation"
]

# Read file
with open(file_path, "r") as file:
    file_contents = file.readlines()

data = [line.strip().split() for line in file_contents]
df = pd.DataFrame(data, columns=columns)

# Convert positions to numeric
df["Start_S_cerevisiae"] = pd.to_numeric(df["Start_S_cerevisiae"])
df["Start_S_paradoxus"] = pd.to_numeric(df["Start_S_paradoxus"])

# Chromosome name mapping
chromosome_mapping = {
    "001": "Chr I",
    "002": "Chr II",
    "003": "Chr III",
    "004": "Chr IV",
    "005": "Chr V",
    "006": "Chr VI",
    "007": "Chr VII",
    "008": "Chr VIII",
    "009": "Chr IX",
    "010": "Chr X",
    "011": "Chr XI",
    "012": "Chr XII",
    "013": "Chr XIII",
    "014": "Chr XIV",
    "015": "Chr XV",
    "016": "Chr XVI",
    "018": "Mito"
}

# Apply chromosome labels
df["Region_S_cerevisiae"] = df["Region_S_cerevisiae"].replace(chromosome_mapping)
df["Region_S_paradoxus"] = df["Region_S_paradoxus"].replace(chromosome_mapping)

# Plot one synteny plot per chromosome
def plot_chromosome_synteny(chromosome):
    chrom_data = df[df["Region_S_cerevisiae"] == chromosome]

    plt.figure(figsize=(8, 8))

    plt.scatter(
        chrom_data["Start_S_cerevisiae"],
        chrom_data["Start_S_paradoxus"],
        color="blue",
        alpha=0.6,
        s=20,
        label="Gene pairs"
    )

    min_start = min(
        chrom_data["Start_S_cerevisiae"].min(),
        chrom_data["Start_S_paradoxus"].min()
    )
    max_start = max(
        chrom_data["Start_S_cerevisiae"].max(),
        chrom_data["Start_S_paradoxus"].max()
    )

    plt.plot(
        [min_start, max_start],
        [min_start, max_start],
        color="black",
        linestyle="--",
        linewidth=1,
        label="Expected synteny"
    )

    plt.grid(True)

    plt.title(
        f"Synteny plot for {chromosome}: S. cerevisiae vs S. paradoxus",
        fontsize=14
    )
    plt.xlabel(
        f"{chromosome} gene start position (S. cerevisiae)",
        fontsize=12
    )
    plt.ylabel(
        f"{chromosome} gene start position (S. paradoxus)",
        fontsize=12
    )

    plt.legend()

    pdf_filename = f"synteny_plot_{chromosome}.pdf"
    plt.savefig(pdf_filename, format="pdf")
    plt.close()

# Generate plots for all chromosomes
for chromosome in chromosome_mapping.values():
    plot_chromosome_synteny(chromosome)

# Code-development note:
# This script was developed by Artemiza A. Martinez
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure. 
