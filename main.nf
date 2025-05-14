#!/usr/bin/env nextflow

include {FASTQC} from './modules/FastQC'
include {STAR_INDEX} from './modules/star_index'
include {STAR_ALIGN} from './modules/star_align'
include {PARSE_GTF} from './modules/parse_gtf'
include {VERSE_COUNT} from './modules/verse'
include {MULTIQC} from './modules/multiqc'
include {CONCAT_COUNTS} from './modules/run_concat'

workflow {
    // Get paired-end FASTQ files and set channels
    fastqc_ch = Channel.fromFilePairs(params.reads).transpose()
    align_ch = Channel.fromFilePairs(params.reads)
    
    // Run FASTQC
    FASTQC(fastqc_ch)
    
    genome_ch = Channel.value(params.genome)  // Single file path
    gtf_ch = Channel.value(params.gtf)

    // Run STAR index (fix output reference)
    star_index_ch = STAR_INDEX(genome_ch, gtf_ch).index

    // STAR_ALIGN should receive the directory from STAR_INDEX
    STAR_ALIGN(align_ch, star_index_ch)

    // Collect FASTQC and STAR log outputs
    fastqc_out = FASTQC.out.zip.map { it[1] }.collect()
    star_log = STAR_ALIGN.out.log.map { it[1] }.collect()

    // Combine FASTQC and STAR log files for MultiQC
    multiqc_ch = fastqc_out.mix(star_log).flatten().collect()
    MULTIQC(multiqc_ch)

    // Run VERSE for gene quantification
    VERSE_COUNT(STAR_ALIGN.out.bam, params.gtf)

    // Collect and merge gene counts
    concat_ch = VERSE_COUNT.out.counts.map{it[1]}.collect()
    
    CONCAT_COUNTS(concat_ch)

}