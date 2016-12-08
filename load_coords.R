library('scidb')
scidbconnect()

scidbremove("tmp", force=TRUE, error=invisible)
scidbremove("gene", force=TRUE, error=invisible)
scidbremove("chrom", force=TRUE, error=invisible)
scidbremove("variant", force=TRUE, error=invisible)
scidbremove("score", force=TRUE, error=invisible)

#This scidbeval with tmp=TRUE will create the array for me
scidbeval(scidb(
  "project(
     apply(
      aio_input('/home/scidb_bio/scidb-testing/Heart_Atrial_Appendage_Analysis.v6p.all_snpgene_pairs.txt', 'num_attributes=6', 'header=1'),
      gene_id, a0,
      variant_id, a1,
      tss_distance, int32(a2),
      pval_nominal, float(a3),
      slope, float(a4),
      slope_se, float(a5),
      chrom, string(nth_tdv(a1, 0, '_')),
      coord, int64(nth_tdv(a1, 1, '_')),
      ref, nth_tdv(a1, 2, '_'),
      alt, nth_tdv(a1, 3, '_')
    ),
    gene_id, variant_id, tss_distance, pval_nominal, slope, slope_se, chrom, coord, ref, alt
  )"
), name = "tmp", gc=0, temp=TRUE)

iquery("
store(
 cast(
  uniq(
    sort(
      project(
        tmp,
        gene_id
      ))),
   <gene_id:string>[gene_idx]
 ),
 gene
)")

iquery("store(cast(sort(project(grouped_aggregate(tmp, count(*), chrom), chrom)), <chrom:string>[chrom_idx]), chrom)")

iquery("
 store(
  redimension(
   index_lookup(
    index_lookup( tmp, chrom, tmp.chrom, chrom_idx) as a,
    -- assign identifiers in a manner sorted by chrom, coord - so that consecutive variants get the adjacent IDs
    project(sort(grouped_aggregate(tmp, count(*), variant_id, chrom, coord), chrom asc, coord asc), variant_id),
    a.variant_id,
    variant_idx
   ),
   <variant_id: string, ref:string, alt:string>
   [chrom_idx  = 0:*,1,0,
    coord      = 0:*,30000000,0,
    variant_idx = 0:*,100000,0],
   false
  ),
  variant
 )"
)
iquery("summarize(variant)", return=TRUE)

iquery("
  store(
   redimension(
    index_lookup(
     index_lookup(tmp, gene, tmp.gene_id, gene_idx),
     aggregate(variant, max(variant_id), variant_idx), 
     tmp.variant_id,
     variant_idx
    ), 
    <tss_distance:int32, pval_nominal:float, slope:float, slope_se:float>
    [gene_idx = 0:*,2000,0, variant_idx = 0:*,100000,0],
    false
   ),
   score
  )
")
iquery("summarize(score)", return=TRUE)



