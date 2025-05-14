#!usr/bin/env python

process PARSE_GTF {
    label 'process_single'
    conda 'envs/biopython'
    container 'ghcr.io/bf528/biopython:latest'
    
    publishDir params.outdir

    input:
    path gtf
     path script

    output:
    path 'id2name.txt', emit: id2name

    script:
    """
    python ${script} -i ${gtf} -o id2name.txt
    """
}