# scidb-testing

This repo contans code for exploring the SciDB AMI using GTEx data. After
launching the SciDB AMI, ssh in and clone this repository. Then execute
`setup.sh` to download the GTEx data and create some files.

## Files

### `load_template.afl`: This file is a template for loading the GTEx data into SciDB. Replace
`input.tsv` with the name of the file you want to load. For instance, you can make a copy of this
file, name it `load_10.afl`, and change `input.tsv` to `10.tsv`. Then you can execute

	iquery -n --afl --query-file load_10.afl

to load `10.tsv` into SciDB.
