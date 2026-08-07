# Figure 6: Preparation of chromosome ancestry blocks
#
# This script documents the preprocessing step used to generate complete
# chromosome-segment tables for the ancestry visualization in Figure 6.
#
# The input annotation file contains one set of ancestry blocks. For each
# chromosome, this script retains those annotated intervals ("Extracted")
# and calculates the complementary intervals ("Remaining"), producing a
# complete chromosome-wide segmentation.
#
# The resulting table was used as input for downstream plotting.
#
# The complete ancestry coordinates underlying the figure are provided in
# the Source Data file associated with the article.

import pandas as pd

# Load chromosome lengths
chr_sizes_df = pd.read_csv(
    "Chr_LN-noCen.txt",
    sep="\t"
)

# Load annotated ancestry blocks
annotations_df = pd.read_csv(
    "1A_Sc_annotation_Rcircos.txt",
    sep="\t"
)

# Collect complete chromosome segments
data = []

for chromosome in chr_sizes_df["Chromosome"]:

    # Retrieve annotated blocks for the current chromosome
    extracted_blocks = annotations_df[
        annotations_df["Chromosome"] == chromosome
    ].copy()

    # Sort intervals by genomic position
    extracted_blocks.sort_values(
        by="chromStart",
        inplace=True
    )

    # Add annotated blocks
    for _, row in extracted_blocks.iterrows():
        data.append({
            "Chromosome": chromosome,
            "Start": row["chromStart"],
            "End": row["chromEnd"],
            "Type": "Extracted"
        })

    # Start at the beginning of the chromosome
    remaining_start = 1

    # Determine complementary intervals
    for _, row in extracted_blocks.iterrows():

        if remaining_start < row["chromStart"]:
            data.append({
                "Chromosome": chromosome,
                "Start": remaining_start,
                "End": row["chromStart"] - 1,
                "Type": "Remaining"
            })

        remaining_start = row["chromEnd"] + 1

    # Add final complementary interval, if present
    chr_end = chr_sizes_df.loc[
        chr_sizes_df["Chromosome"] == chromosome,
        "chromEnd"
    ].values[0]

    if remaining_start <= chr_end:
        data.append({
            "Chromosome": chromosome,
            "Start": remaining_start,
            "End": chr_end,
            "Type": "Remaining"
        })

# Convert to dataframe
plot_data = pd.DataFrame(data)

# Save table for downstream plotting
output_file_path = "1A_Sp_annotation_Rcircos.txt"

plot_data.to_csv(
    output_file_path,
    sep="\t",
    index=False
)

print(
    f"Processed chromosome blocks saved to: {output_file_path}"
)

# Code-development note:
# This script was developed by Artemiza A. Martinez 
# ChatGPT (OpenAI) for code drafting, organization, and documentation.
# The authors reviewed the code and are responsible for the scientific
# decisions, data interpretation, and final figure.
