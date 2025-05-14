process CONCAT_COUNTS{
    label 'process_low'
    container 'ghcr.io/bf528/pandas:latest'

    input:
    path df_list  

    output:
    path "verse_concat.csv" 

    script:
    """
    concatenate_counts.py $df_list -o "verse_concat.csv"
    """
}
