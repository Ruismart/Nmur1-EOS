## ref. check http://velocyto.org/velocyto.py/tutorial/index.html
# at first, better to manually sort cellranger output bam manually 
#     as this step often interrupts on out platform
#     could delete the large sorted bam file after this whole process is done

# code to submit
# cd ${output_10x}/outs
samtools sort \
-t "CB" \
-m 2000M \
-@ 6 \
-O BAM \
-o cellsorted_possorted_genome_bam.bam \
possorted_genome_bam.bam           

# next run velocyto
# code to submit
annt_gtf='path-of-gencode.annotation.gtf'
repeat_msk='path-of-mm10_rmsk.gtf'
output_10x='path-of-cellranger-output-folder'

velocyto run10x \
-m ${repeat_msk} \
${output_10x} \
${annt_gtf}




