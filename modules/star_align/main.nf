#!/usr/bin/env nextflow

process STAR_ALIGN {
    label 'process_high'
    container 'ghcr.io/bf528/star:latest'
    publishDir params.outdir, mode: 'copy' 

    input:
    tuple val(sample_id), path(reads)
    path genomeDir

    output:
    tuple val(sample_id), path("${sample_id}.Aligned.out.bam"), emit: bam
    tuple val(sample_id), path("${sample_id}.Log.final.out"), emit: log

    script:
    """
    STAR \
        --runThreadN 8 \
        --genomeDir ${genomeDir} \
        --readFilesIn ${reads[0]} ${reads[1]} \
        --readFilesCommand gunzip -c \
        --outFileNamePrefix ${sample_id}. \
        --outSAMtype BAM Unsorted
    """
}
