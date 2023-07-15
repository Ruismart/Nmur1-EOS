####
## As mentioned in AntoniaWallrapp et al. Nature2017 https://pubmed.ncbi.nlm.nih.gov/28902842/,
##   current gene annotations for mm10 Nmur1 gene are 3-prime truncated. 
## Already confirmed by IGV using local bulk RNAseq data.
##
## To fix that issue which prevents droplet-based sequencing(3' biased) having Nmur1 gene detected, 
##   we built a custom mm10 gtf file by extending the last exon of Nmur1 gene to chr1: 86,385,500 bp.
####


## directly edit on genes.gtf from 10x Genomics
#
cp genes.gtf genes.Nmur1_fixed.gtf
vi gene.Nmur1_fixed.gtf

# edit Nmur1
#   whole gene and whole transcript(only Nmur1-203 shold be fine)
#       left edge:  86386303  =>   86385500
#
#       final exon  left edge:  86386303  =>   86385500
#       final   CDS  left edge:  86386328  =>   86385525
#       final   UTR   86386303 : 86386327    =>   86385500 : 86385524
#       stop codon   86386325 : 86386327     =>   86385522 : 86385524
# save and exit



## code to submit for building index
#
/storage/xuhepingLab/0.share/pipelines/cellranger-6.1.1/bin/cellranger mkref \
--genome=refdata-gex-mm10-2020-A-Nmur1-fixed \
--fasta=/storage/xuhepingLab/0.share/genomics/mouse/10x/refdata-gex-mm10-2020-a/fasta/genome.fa \
--genes=/storage/xuhepingLab/0.share/genomics/mouse/10x/temp_building_Nmur1fix/genes.Nmur1_fixed.gtf \
--nthreads=12

## then use this output 'refdata-gex-mm10-2020-A-Nmur1-fixed' for 'cellranger count --transcriptome'


## IGV check output bam of 'cellranger count' 
# take out nearby signal 
cd ${output_dir}/outs

samtools view -h possorted_genome_bam.bam chr1:86385000-86390000 |\
gawk '$4>86385000 && $4<86390000' |\
cat <(samtools view -h possorted_genome_bam.bam chr1:86385500-86386000 |head -n 74) - |\
samtools view -bS |samtools sort - -o Nmur1.new.bam

samtools index Nmur1.new.bam

#### end
