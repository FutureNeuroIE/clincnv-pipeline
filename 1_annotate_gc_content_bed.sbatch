#!/bin/bash
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### ClinCNV WES CNV calling
####
#SBATCH --job-name=job1
#SBATCH --partition=ProdQ
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=2
#SBATCH --mem=12000
#SBATCH --mail-type=END,FAIL
#SBATCH --output=%j.annotate_gc_job1.out
#SBATCH --error=%j.annotate_gc_job1.err

## Input: BED file with exome targets, human reference genome fasta
## Output: BED file with exome targets with annotated GC content

WORK_DIR=/home/data/human_genetics/SHeneghan/ClinCNV
BED_FILE=/home/data/human_genetics/reference/hg38/S000021_hg38_targets.bed
REF_FILE=/home/data/human_genetics/reference/hg38/hg38_v0_Homo_sapiens_assembly38.fasta
NGSBITS_PATH=/home/users/sophiaheneghan22/.conda/envs/ngsbits/


$NGSBITS_PATH/bin/BedAnnotateGC -in $BED_FILE -out gcAnnotated.targets_hg38.bed -ref $REF_FILE