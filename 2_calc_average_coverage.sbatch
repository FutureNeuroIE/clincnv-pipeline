#!/bin/bash
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### ClinCNV WES CNV calling
####
#SBATCH --job-name=job3
#SBATCH --partition=ProdQ
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=2
#SBATCH --mem=12000
#SBATCH --mail-type=END,FAIL
#SBATCH --output=/home/data/human_genetics/SHeneghan/ClinCNV/slurmfiles/%j.read_cov_job3.out
#SBATCH --error=/home/data/human_genetics/SHeneghan/ClinCNV/slurmfiles/%j.read_cov_job3.err
#SBATCH --array=0-63%10

## Input: BAM files in one directory, BED file with annotated gc content 
## Output: File for each sample with coverage information at each exome target region

WORK_DIR=/home/data/human_genetics/SHeneghan/ClinCNV
BAM=/home/data/human_genetics/Renal/Exomes/CeGaT_PKD/BAM
BED_FILE=/home/data/human_genetics/reference/hg38/S000021_hg38_targets.bed
ANNOT_BED=$WORK_DIR/gcAnnotated.targets_hg38.bed
REF_FILE=/home/data/human_genetics/reference/hg38/hg38_v0_Homo_sapiens_assembly38.fasta
NGSBITS_PATH=/home/users/sophiaheneghan22/.conda/envs/ngsbits/

#To run COV files, for on target

for f in "$BAM"/*; do
    if [[ $f =~ ^${BAM}/S000021_S[0-9]+Nr[0-9]+.markdup.recal.bam$ ]]; then
        arrVar+=("$f")
    fi
done

FILE="${arrVar[$SLURM_ARRAY_TASK_ID]}"
###FILE is the one that prints each of the BAM files

## Get sample ID for printing new file name
tmp=${FILE#*S000021_}
SAMPLE=${tmp%.markdup*}


$NGSBITS_PATH/bin/BedCoverage -bam $FILE \
        -in $ANNOT_BED \
        -min_mapq 5 -decimals 4 > /home/data/human_genetics/SHeneghan/ClinCNV/3_coverage_files/output_ontarget_${SAMPLE}.cov