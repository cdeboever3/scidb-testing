# scidb-testing

This repo contans code for exploring the SciDB AMI using GTEx data. First,
launch the SciDB AMI (see the PDF for info on how to do this). You may want to
wait for about 30 minutes to let it load the various example databases. After
30 minutes, ssh in and follow these steps:

* Clone this repository

	git clone https://github.com/rivas-lab/scidb-testing.git
	cd scidb-testing

* Download GTEx data

	bash setup.sh

* Update accelerated_io_tools:

	git clone https://github.com/Paradigm4/accelerated_io_tools/
	cd accelerated_io_tools/
	git checkout "v15.12"
	make  #a few warnings 
	#as root
	cp libaccelerated_io_tools.so /opt/scidb/15.12/lib/scidb/plugins/
	scidb.py stopall mydb; scidb.py startall mydb

* Open RStudio at [ip address]:8787
* Open `load_coords.R` in RStudio and source it. This will load the GTEx data.
* Open `query_coords.R` and source it. This provides two functions that can
retrieve results by gene ID or chromosomal position:

	get_scores_for_range = function(chrom = 1, start = 5000000, end = 5010000 )
	get_scores_for_gene = function(gene_id = "ENSG00000232807.2")
