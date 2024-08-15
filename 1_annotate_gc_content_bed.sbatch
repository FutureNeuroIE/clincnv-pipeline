#!/bin/bash
####
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### hg38_CNV_Calling_WES
####
#SBATCH --job-name=annotate_gc_bed
#SBATCH --time=1-00:00:00
#SBATCH --mem=12000
#SBATCH --mail-type=END,FAIL
#SBATCH --output=%j.annotate_gc_job1.out
#SBATCH --error=%j.annotate_gc_job1.err

## Input: BED file with exome targets, human reference genome fasta
## Output: BED file with exome targets with annotated GC content

WORK_DIR=/path/to/directory
BED_FILE=/path/to/hg38_targets.bed
REF_FILE=/path/to/reference/hg38_v0_Homo_sapiens_assembly38.fasta
NGSBITS_PATH=/path/to/.conda/envs/ngsbits/


$NGSBITS_PATH/bin/BedAnnotateGC -in $BED_FILE -out gcAnnotated.targets_hg38.bed -ref $REF_FILE