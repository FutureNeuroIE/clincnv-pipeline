#!/bin/bash
####
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### hg38_CNV_Calling_WES
####
#SBATCH --job-name=clincnv
#SBATCH --time=10-00:00:00
#SBATCH --mem=50000
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sophiaheneghan22@rcsi.com
#SBATCH --output=%j.clincnv_job5.out
#SBATCH --error=%j.clincnv_job5.err

WORK_DIR=/path/to/directory
BAM=/path/to/BAM
BED_FILE=/path/to/hg38_targets.bed
ANNOT_BED=$WORK_DIR/gcAnnotated.targets_hg38.bed
REF_FILE=/path/to/reference/hg38_v0_Homo_sapiens_assembly38.fasta
NGSBITS_PATH=/path/to/.conda/envs/ngsbits/
COV_MERGE_FILE=$WORK_DIR/merged_cov_file

## Input: Merged coverage file, annotated BED file
## Output: Directory with all sample CNV information - TSV file with CNV info, and 2 files for IGV (CNV and coverage track)

module load ClinCNV/1.18.3-foss-2022b

Rscript ${EBROOTCLINCNV}/clinCNV.R \
        --normal $COV_MERGE_FILE \
        --bed $ANNOT_BED \
        --out $WORK_DIR/cnv_output_scoreG50_cluster15 \
        --scoreG 50 \
        --lengthG 0 \
        --maxNumGermCNVs 2000 \
        --maxNumIter 5 \
        --numberOfThreads 2 \
        --minimumNumOfElemsInCluster 15 \
        --hg38
#increase minimumNumOfElemsInCluster number if cohort is larger (>100 samples)        