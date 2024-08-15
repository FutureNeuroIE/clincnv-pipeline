#!/bin/bash
####
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### hg38_CNV_Calling_WES
####
#SBATCH --job-name=sort_vcf
#SBATCH --output=%j.sort_vcfs.out
#SBATCH --error=%j.sort_vcfs.err
#SBATCH --time=2-00:00:00
#SBATCH --mem=10000
#SBATCH --mail-type=END,FAIL
#SBATCH --array=0-277%5

# Set SBATCH array to the number of samples you want to run, e.g. 10 samples would be --array=0-9

## Input: VCF of quality filtered CNV calls
## Output: VCF of CNV calls sorted by position

module load BCFtools/1.15.1-GCC-11.3.0

WORK_DIR=/path/to/directory/

CNV_INPUT=(/path/to/quality_VCFs/*)
FILE="${CNV_INPUT[$SLURM_ARRAY_TASK_ID]}"
###FILE is the one that prints each of the files from the directory 

### Create string of sample name from the FILE name input
filename="${FILE}"
tmp=${filename#*quality_VCFs/}
SAMPLE=${tmp%.vcf*}

bcftools sort $FILE -o $WORK_DIR/sort_quality_VCFs/${SAMPLE}.vcf