#!/bin/bash
####
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### hg38_CNV_Calling_WES
####
#SBATCH --job-name=calc_average_coverage
#SBATCH --partition=ProdQ
#SBATCH --time=1-00:00:00
#SBATCH --mem=12000
#SBATCH --mail-type=END,FAIL
#SBATCH --output=%j.read_cov_job3.out
#SBATCH --error=%j.read_cov_job3.err
#SBATCH --array=0-277%5

# Set SBATCH array to the number of samples you want to run, e.g. 10 samples would be --array=0-9

## Input: BAM files in one directory, BED file with annotated gc content 
## Output: File for each sample with coverage information at each exome target region

WORK_DIR=/path/to/directory
BAM=/path/to/BAM
BED_FILE=/path/to/hg38_targets.bed
ANNOT_BED=$WORK_DIR/gcAnnotated.targets_hg38.bed
REF_FILE=/path/to/reference/hg38_v0_Homo_sapiens_assembly38.fasta
NGSBITS_PATH=/path/to/.conda/envs/ngsbits/

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
        -min_mapq 5 -decimals 4 > /path/to/coverage_files/output_ontarget_${SAMPLE}.cov