#!/bin/bash
#SBATCH --job-name="post_simphy"
#SBATCH --time=72:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH --mail-user="molly.donnellan@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH -c 2
#SBATCH --mem-per-cpu=6G

##This script prepares directories and control files for INDELible, runs INDELible for all four empirical datasets, and modifies INDELible alignments to introduce crosscontamination and missing data 

#Adjust paths to R (version 4.2.2) and INDELible (version 1.03)i


pwd
date

module load uri/main
module load R-bundle-Bioconductor/3.15-foss-2021b-R-4.2.0

for i in ../simulations/*/*/1/
	do
	cd $i
	pwd
	Rscript ../../../../simulation_scripts/prep_INDELible.R gene_trees.tre df.csv #CHANGE to own path to the script
	cd alignments1
	cp ../control.txt .
	/data/schwartzlab/awalling/tools/INDELibleV1.03/src/indelible #CHANGE to own path to INDELible
	cp ../controlCDS.txt ./control.txt
	/data/schwartzlab/awalling/tools/INDELibleV1.03/src/indelible #CHANGE to own path to INDELible
	cd ../
	Rscript ../../../../simulation_scripts/post_INDELible.R alignments1 df.csv #CHANGE to own path to the script
	cd ../../../../simulation_scripts/
	pwd
done

