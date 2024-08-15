#!/bin/bash
####
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### hg38_CNV_Calling_WES
####
#SBATCH --job-name=exclude_region_vcf
#SBATCH --output=%A_%a.exclude_regions_vcfs.out
#SBATCH --error=%A_%a.exclude_regions_vcfs.err
#SBATCH --time=2-00:00:00
#SBATCH --mem=10000
#SBATCH --mail-type=END,FAIL
#SBATCH --array=0-277%5

# Set SBATCH array to the number of samples you want to run, e.g. 10 samples would be --array=0-9

## Input: VCF of CNV calls sorted by position
## Output: VCF of CNV calls with hypervariable regions MHC and LRC filtered out

module load BCFtools/1.15.1-GCC-11.3.0

WORK_DIR=/path/to/directory/

CNV_INPUT=/path/to/directory/sort_quality_VCFs
for f in "$CNV_INPUT"/*; do
        CNV_VCF+=($f)
done

FILE="${CNV_VCF[$SLURM_ARRAY_TASK_ID]}"
###FILE is the one that prints each of the files from the directory 

### Create string of sample name from the FILE name input
filename="${FILE}"
tmp=${filename#*sort_quality_VCFs/}
SAMPLE=${tmp%.vcf*}

#echo $CNV_INPUT/${SAMPLE}_exclude.vcf
bcftools view -T ^$WORK_DIR/HLA_and_LRC_exclude.txt $FILE > $CNV_INPUT/${SAMPLE}/${SAMPLE}_exclude.vcf