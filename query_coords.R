
#Returns a data.frame for all genes that fit in this range
get_scores_for_range = function(chrom = 1, start = 5000000, end = 5010000 )
{
  iquery(
   sprintf(
    "cross_join(
      gene,
      cross_join(
       project(score, pval_nominal, slope, slope_se),  --adjust based on which fields you need
       project(
        between(variant, %i, %i, null, %i, %i, null),
        ref,
        alt
       ),
       score.variant_idx,
       variant.variant_idx
     ) as A,
     gene.gene_idx,
     A.gene_idx
    )", chrom, start, chrom, end
   ),
   return=TRUE
  )
}

#Returns a data.frame for all variants that correspond to this gene
get_scores_for_gene = function(gene_id = "ENSG00000232807.2")
{
  iquery(
    sprintf(
    "cross_join(
      project(variant, ref, alt),
      cross_join(
       project(score, pval_nominal, slope, slope_se),
       filter(gene, gene_id='%s'),
       score.gene_idx,
       gene.gene_idx
      ) as A,
      variant.variant_idx,
      A.variant_idx
    )", gene_id
    ),
    return=TRUE
  )
}

#install stream from https://github.com/Paradigm4/stream
#cp examples/python_example.py /tmp
#chmod a+x /tmp/python_example.py
stream_through_python = function()
{
  iquery(
    "parse(
      stream(
       limit(score, 20),  --JUST take 50 values for demo purposes
       '/tmp/python_example.py',
       'format=tsv'
      ),
      'num_attributes=5'
     )",
    return=TRUE
  )
}
