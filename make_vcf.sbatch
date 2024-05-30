#!/bin/bash
#### Sophia Heneghan <sophiaheneghan22@rcsi.ie>
#### 
####
#SBATCH --job-name=job7
#SBATCH --output=/home/data/human_genetics/SHeneghan/ClinCNV/VCFs/slurmfiles/%j.make_vcfs.out
#SBATCH --error=/home/data/human_genetics/SHeneghan/ClinCNV/VCFs/slurmfiles/%j.make_vcfs.err
#SBATCH --partition=ProdQ
#SBATCH --time=2-00:00:00
#SBATCH --ntasks=2
#SBATCH --mem=10000
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=sophiaheneghan22@rcsi.com
#SBATCH --array=0-63%10

WORK_DIR=/home/data/human_genetics/SHeneghan/ClinCNV/VCFs
VCF=/home/data/human_genetics/SHeneghan/PKD_CNV_calling/09_filtered_segment_VCF_files/ALS_controls

CNV_INPUT=(/home/data/human_genetics/SHeneghan/ClinCNV/cnv_output_S6716_scoreG50_cluster15/normal/S000021_S*Nr*/S000021_S*Nr*_cnvs.tsv)
FILE="${CNV_INPUT[$SLURM_ARRAY_TASK_ID]}"
###FILE is the one that prints each of the files in the scatter directory - will use this for creating the output names

filename="${FILE}"
tmp=${filename#*normal/}
SAMPLE=${tmp%/S000021*}

## Create header file - take header from another VCF or find template online, and change the sample name to SAMPLE_ID
cat $VCF/segments_ALS_0_filterbcftools.vcf | grep '^#CHROM' >> $WORK_DIR/header.txt

## Create header file for each sample, then replace "SAMPLE_ID" with the sample name you want
cat $WORK_DIR/header.txt > $WORK_DIR/CNV_VCFs_S6716_G50_cluster15/${SAMPLE}.vcf && \
sed -i "s/SAMPLE_ID/$SAMPLE/g" $WORK_DIR/CNV_VCFs_S6716_G50_cluster15/${SAMPLE}.vcf && \

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
		printf "${CNV_CHR}\t${CNV_START}\t${CNV_ID}\tN\t${ALT}\t${QUAL}\t.\t${INFO_END}\tGT:CN\t${GT}:${COPY_NUM}\n" >> $WORK_DIR/CNV_VCFs_S6716_G50_cluster15/${SAMPLE}.vcf
	done
