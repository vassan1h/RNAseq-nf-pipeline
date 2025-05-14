#!usr/bin/env nextflow

process VERSE_COUNT{
    label 'process_high'
    container 'ghcr.io/bf528/verse:latest'

    input:
    tuple val(meta), path (bam)  // BAM file from STAR
    path (gtf)  // GTF file for annotation
    

    output:
    tuple val(meta), path ("*exon.txt"), emit: counts

    script:  //verse -i $bam_file -g $gtf_file -S > ${bam_file.baseName}_gene_counts.txt
    """
    verse -S -a $gtf -o $meta $bam
    """
}