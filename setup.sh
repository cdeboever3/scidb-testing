#!/bin/bash

wget http://www.gtexportal.org/static/datasets/gtex_analysis_v6p/single_tissue_eqtl_data/all_snp_gene_associations/Heart_Atrial_Appendage_Analysis.v6p.all_snpgene_pairs.txt.gz

gunzip Heart_Atrial_Appendage_Analysis.v6p.all_snpgene_pairs.txt.gz

# for i in 10 100 1000 10000 100000 1000000 10000000 100000000 ;
# 	do head -n $i Heart_Atrial_Appendage_Analysis.v6p.all_snpgene_pairs.txt > ${i}.tsv ;
# done
