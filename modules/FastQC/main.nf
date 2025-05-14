#!usr/bin/env nextflow

process FASTQC{
    container "ghcr.io/bf528/fastqc:latest"
    label "process_single"
    publishDir params.outdir, mode: 'copy' 

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path('*.zip'), emit: zip
    tuple val(sample_id), path('*.html'), emit: html
    
    shell:
    """
    fastqc -t $task.cpus $reads
    """
}