#!/usr/bin/env python
import argparse
import pandas as pd
import os

def concatenate_counts(count_files, output_file):
    # Initialize an empty list to hold dataframes
    dfs = []

    # Read each VERSE output file and append to the list
    for count_file in count_files:
        sample_name = os.path.basename(count_file).split('.')[0]  # Using . instead of _ as separator
        df = pd.read_csv(count_file, sep='\t', index_col=0)
        df.columns = [sample_name]
        dfs.append(df)

    # Concatenate all dataframes along columns (axis=1)
    final_df = pd.concat(dfs, axis=1)

    # Output the final counts matrix
    final_df.to_csv(output_file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Concatenate VERSE gene count files into a single matrix.")
    parser.add_argument("count_files", nargs='+', help="List of VERSE output files.")
    parser.add_argument("-o", "--output", help="Output file name", default="gene_counts_matrix.csv")
    args = parser.parse_args()

    concatenate_counts(args.count_files, args.output)