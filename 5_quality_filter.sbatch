#!/bin/bash
####
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### hg38_CNV_Calling_WES
####
#SBATCH --job-name=quality_filter
#SBATCH --output=%A_%a.quality_filter.out
#SBATCH --error=%A_%a.quality_filter.err
#SBATCH --time=2-00:00:00
#SBATCH --ntasks=2
#SBATCH --mem=10000
#SBATCH --mail-type=END,FAIL
#SBATCH --array=0-277%5

# Set SBATCH array to the number of samples you want to run, e.g. 10 samples would be --array=0-9

## Input: CNV TSV file output from ClinCNV, with each directory inside the "normal" directory being the sample name
## Output: CNV TSV file filtered for quality, i.e. loglikelihood:no_of_regions ratio > 5, potential_AF < 0.1, and qvalue < 0.05

WORK_DIR=/path/to/directory/

CNV_INPUT=(/INPUT_DIR/cnv_output_scoreG50_cluster15/normal/*/*_cnvs.tsv)
FILE="${CNV_INPUT[$SLURM_ARRAY_TASK_ID]}"
###FILE is the one that prints each of the files from the directory 

### Create string of sample name from the FILE name input
filename="${FILE}"
tmp=${filename#*normal/}
SAMPLE=${tmp%/*}

cat $FILE | grep '^#' >> $WORK_DIR/OUTPUT_DIR/${SAMPLE}_filter.txt && \
grep -v "^#" < $FILE | while read LINE; do
	LOG=$(echo $LINE | awk '{ print $5 }')
	NO_OF_REGIONS=$(echo $LINE | awk '{ print $6 }')
	POTENTIAL_AF=$(echo $LINE | awk '{ print $8 }')
	QVALUE=$(echo $LINE | awk '{ print $9 }')
	RATIO=$(awk "BEGIN {print $LOG / $NO_OF_REGIONS}")
	if (( $(echo "${RATIO} >= 5" | bc -l) )) && (( $(echo "${QVALUE} < 0.05" | bc -l) )) && (( $(echo "${POTENTIAL_AF} < 0.1" | bc -l) )); then
		printf "${LINE}\n" >> $WORK_DIR/OUTPUT_DIR/${SAMPLE}_filter.txt
	fi
done