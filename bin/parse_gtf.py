#!/usr/bin/env python

# argparse is a library that allows you to make user-friendly command line interfaces
import argparse
import re

# here we are initializing the argparse object that we will modify
parser = argparse.ArgumentParser()

# we are asking argparse to require a -i or --input flag on the command line when this
# script is invoked. It will store it in the "filenames" attribute of the object
# we will be passing it via snakemake, a list of all the outputs of verse so we can
# concatenate them into a single matrix using pandas 

parser.add_argument("-i", "--input", help='a GFF file', dest="input", required=True)
parser.add_argument("-o", "--output", help='Output file with region', dest="output", required=True)

# this method will run the parser and input the data into the namespace object
args = parser.parse_args()


with open(args.input, 'r') as infile, open(args.output, 'w') as outfile:
    outfile.write("Ensembl_ID\tGene_Name\n")  # Header for output file

    for line in infile:
        if line.startswith("#"):  # Skip header lines
            continue
        
        fields = line.strip().split("\t")
        if fields[2] == "gene":  # Look for gene entries
            attributes = fields[8]

            # Extract Ensembl Gene ID and Gene Name using regex
            gene_id_match = re.search(r'gene_id "([^"]+)"', attributes)
            gene_name_match = re.search(r'gene_name "([^"]+)"', attributes)

            if gene_id_match:
                gene_id = gene_id_match.group(1)
                gene_name = gene_name_match.group(1) if gene_name_match else "NA"

                # Write to output file
                outfile.write(f"{gene_id}\t{gene_name}\n")

print(f"Extraction complete. Output saved to {args.output}")
import csv
