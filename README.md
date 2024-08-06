# ClinCNV Pipeline

## Overview
Bash scripts formatted for use with the SLURM job manager for calling CNVs from targeted sequencing data.

## Table of Contents
1. [Installation and Pre-requisites](#installation)
2. [Usage](#usage)
3. [Extra Documentation](#extra-documentation)

## Installation
### Prerequisites
- ClinCNV - please refer to the original ClinCNV github for installation: https://github.com/imgag/ClinCNV
- ngs-bits conda environment: https://anaconda.org/bioconda/ngs-bits
- bcftools: https://samtools.github.io/bcftools/

## Usage
### Quick Start
**1_annotate_gc_content_bed.sbatch**: Annotate your BED regions file with GC content.

Requires:
- BED file - formatted with chromosome, start, and end positions separated by tabs.
- Human reference FASTA

**2_calc_average_coverage.sbatch**: Calculate the average coverage in each region of your BED file.

Requires:
- Annotated BED file - output from step 1
- BAM file

**3_merge_coverage_files.sbatch**: Merge together all coverage files (output of step 2) into one file

Requires:
- Coverage files (all files within one directory)

**4_CNV_output.sbatch**: Use clinCNV.R script to call CNVs in samples

Requires:
- Merged coverage file - output from step 3
- Annotated BED file - output from step 1

**quality_filter.sbatch**: Filter ClinCNV calls for quality: qvalue < 0.05, loglikelihood:no_of_regions ratio > 5, and potential_AF < 0.1

Requires:
- ClinCNV TSV file

**make_vcf.sbatch**: Convert ClinCNV output to VCF for easy use

Requires:
- Filtered ClinCNV TSV file
- VCF header (header.txt)

**sort_vcf.sbatch**: Puts VCF in positional order, which is required for most annotators.

Requires:
- VCF file

**exclude_HLA_LRC_regions.sbatch**: *Optional*, exclude highly polymorphic regions on chromosome 6 (HLA region) and chromosome 19 (LRC region)

Requires:
- VCF file

### Detailed Instructions

**Annotate BED File**

The BED file annotated with GC content is used to account for variances in sequencing data; regions with high GC content do not sequence as well, and therefore may have a lower read depth in those regions. Providing ClinCNV with the GC content in each region allows it to account for this variance when estimating the locations of CNVs.

Use the 1_annotate_gc_content_bed.sbatch script to annotate your BED file with your sequencing targets with the GC content in those target regions.

**Create Coverage Files**

The coverage at each region in the BED files from the sequencing data is estimated. As ClinCNV is a read-depth based caller, it uses this to estimate significant drops and increases in read depth to estimate the location of deletions and duplications, respectively.

Use the 2_calc_average_coverage.sbatch script to calculate the coverage for each of the targets in your annotated BED file so these can be used to estimate CNV locations.

**Merge Coverage Files**

ClinCNV takes in all of the coverage information for the entire cohort you are running together. So, merging the coverage files together is required.

Use the 3_merge_coverage_files.sbatch script to give it the directory that contains all of the coverage files if your cohort, and output to a single tab-separated merged coverage file.

**ClinCNV Run**

The 4_CNV_output.sbatch script contains code for running ClinCNV on a cohort. Many options are available; some are explained here:

* --scoreG - this is for balancing between sensitivity and specificity. Larger number = higher specificity, lower sensitivity. In the script, scoreG 50 was chosen for balanced sensitivity and specificity.

* --minimumNumOfElemsInCluster - ClinCNV clusters together samples for running the CNV calling for accuracy and speed. Generally this number is recommended to be between 20 and 100, but when running smaller cohort (e.g. less than 60 samples), lowering this number will help.

* --hg38 - if your data has been aligned on the hg38 genome, this flag must be specified otherwise it will run on the hg19 genome!

* --noPlot - use this option when you have a very small sample size (i.e. less than 30 samples), as a umap error may occur when running ClinCNV on a small cohort without this option used. 

**Creating and Filtering VCF**

ClinCNV outputs a TSV file of all the CNV calls; this is difficult to annotate with tools that currently exist. 

The make_vcf.sbatch script takes the CNV TSV file created by ClinCNV and a VCF header file, and reformats the CNV calls to a VCF format. The loglikelihood value given by ClinCNV is reported in the QUAL column of the VCF.

ClinCNV also does not have the CNV calls sorted. This is remedied by using the sort_vcf.sbatch file, which uses bcftools sort to put the calls in positional order.

## Extra Documentation
Please see the ClinCNV Github for more information on extra parameters and cohort studies (e.g. trio studies) for ClinCNV: https://github.com/imgag/ClinCNV/tree/master/doc
