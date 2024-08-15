#!/bin/bash
####
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### hg38_CNV_Calling_WES
####
#SBATCH --job-name=make_vcfs
#SBATCH --output=%j.make_vcfs.out
#SBATCH --error=%j.make_vcfs.err
#SBATCH --time=2-00:00:00
#SBATCH --ntasks=2
#SBATCH --mem=10000
#SBATCH --mail-type=END,FAIL
#SBATCH --array=0-277%5

## Input: CNV TSV file filtered for quality, sample VCF header with "SAMPLE_ID" where the sample name should be
## Output: VCF of quality filtered CNV calls

WORK_DIR=/path/to/directory/
VCF_HEADER=/path/to/sample_VCF_header

CNV_INPUT=(/path/to/OUTPUT_DIR/*_filter.txt)
FILE="${CNV_INPUT[$SLURM_ARRAY_TASK_ID]}"
###FILE is the one that prints each of the files from the directory

### Create string of sample name from the FILE name input
filename="${FILE}"
tmp=${filename#*OUTPUT_DIR/}
SAMPLE=${tmp%_filter*}

## Create header file - take header from another VCF or find template online, and change the sample name to SAMPLE_ID
cat $VCF_HEADER | grep '^#CHROM' >> $WORK_DIR/header.txt

## Create header file for each sample, then replace "SAMPLE_ID" with the sample name you want
cat $WORK_DIR/header.txt > $WORK_DIR/VCF_DIR/${SAMPLE}.vcf && \
sed -i "s/SAMPLE_ID/$SAMPLE/g" $WORK_DIR/VCF_DIR/${SAMPLE}.vcf && \

	grep -v "^#" < ${FILE} | while read LINE; do
			CNV_CHR=$(echo $LINE | awk '{ print $1; }')
			CNV_START=$(echo $LINE | awk '{ print $2; }')
			CNV_END=$(echo $LINE | awk '{ print $3; }')
			CNV_ID="CNV_${CNV_CHR}_${CNV_START}_${CNV_END}"
			COPY_NUM=$(echo $LINE | awk '{ print $4; }')
			LOG_LIKE=$(echo $LINE | awk '{ print $5; }')
			INFO_END="END=${CNV_END}"
			if [[ ${COPY_NUM} == 0 ]]; then
				ALT="<DEL>"
				GT="1/1"
			elif [[ ${COPY_NUM} == 1 ]]; then
				ALT="<DEL>"
				GT="0/1"
			elif [[ ${COPY_NUM} >= 2 ]]; then
	                       	ALT="<DUP>"
                       		GT="./."
			fi
		printf "${CNV_CHR}\t${CNV_START}\t${CNV_ID}\tN\t${ALT}\t${QUAL}\t.\t${INFO_END}\tGT:CN\t${GT}:${COPY_NUM}\n" >> $WORK_DIR/VCF_DIR/${SAMPLE}.vcf
	done