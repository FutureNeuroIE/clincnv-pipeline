#!/bin/bash
####
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### hg38_CNV_Calling_WES
####
#SBATCH --job-name=merge_cov_files
#SBATCH --time=1-00:00:00
#SBATCH --mem=12000
#SBATCH --mail-type=END,FAIL
#SBATCH --output=%j.merge_cov_job4.out
#SBATCH --error=%j.merge_cov_job4.err

## Input: Directory of coverage files generated from 2_calc_average_coverage.sbatch 
## Output: One file of coverage information for all samples in input directory

WORK_DIR=/path/to/directory
BAM=/path/to/BAM
BED_FILE=/path/to/hg38_targets.bed
ANNOT_BED=$WORK_DIR/gcAnnotated.targets_hg38.bed
REF_FILE=/path/to/reference/hg38_v0_Homo_sapiens_assembly38.fasta
NGSBITS_PATH=/path/to/.conda/envs/ngsbits/

module load ClinCNV/1.18.3

Rscript ${EBROOTCLINCNV}/mergeFilesFromFolder.R -i $WORK_DIR/coverage_files/ -o $WORK_DIR/merged_cov_file