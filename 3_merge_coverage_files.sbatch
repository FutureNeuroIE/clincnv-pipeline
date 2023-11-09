#!/bin/bash
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### ClinCNV WES CNV calling
####
#SBATCH --job-name=job4
#SBATCH --partition=ProdQ
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=2
#SBATCH --mem=12000
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/home/data/human_genetics/SHeneghan/ClinCNV/slurmfiles/%j.merge_cov_job4.out
#SBATCH --error=/home/data/human_genetics/SHeneghan/ClinCNV/slurmfiles/%j.merge_cov_job4.err

## Input: Directory of coverage files generated from 2_calc_average_coverage.sbatch 
## Output: One file of coverage information for all samples in input directory

WORK_DIR=/home/data/human_genetics/SHeneghan/ClinCNV
BAM=/home/data/human_genetics/Renal/Exomes/CeGaT_PKD/BAM
BED_FILE=/home/data/human_genetics/reference/hg38/S000021_hg38_targets.bed
ANNOT_BED=$WORK_DIR/gcAnnotated.targets_hg38.bed
REF_FILE=/home/data/human_genetics/reference/hg38/hg38_v0_Homo_sapiens_assembly38.fasta
NGSBITS_PATH=/home/users/sophiaheneghan22/.conda/envs/ngsbits/

module load ClinCNV/1.18.3

Rscript ${EBROOTCLINCNV}/mergeFilesFromFolder.R -i $WORK_DIR/3_coverage_files/ -o $WORK_DIR/4_merged_cov/merged_cov_file