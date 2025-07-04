#!/bin/bash
#SBATCH --job-name="run_simphy"
#SBATCH --time=72:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --mail-user="molly.donnellan@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH -p uri-cpu
#SBATCH -c 2
#SBATCH --mem-per-cpu=6G

##This script generates simulation properties, runs SimPhy, and preps gene trees for INDELible
#CHANGE scripts "run_SimPhy.R" and "generate_sim_properties.R" to be relevant to your work

pwd
date

module load uri/main
module load R-bundle-Bioconductor/3.15-foss-2021b-R-4.2.0

for l in ../simulations/*/*

do
	echo $l
	cd $l/1/
	pwd
	Rscript ../../../../2_simulation_scripts/generate_sim_properties.R #CHANGE to own path to file
	cd ../../../../2_simulation_scripts #CHANGE to own path to file
	pwd
	Rscript run_SimPhy.R $l/1/sptree.nex $l/1/df.csv 3_run_simphy_command_list.txt $l/1/gene_trees.tre $l/1/
	grep "ds_" 3_run_simphy_command_list.txt | split -l 2000 - 3_run_simphy_list_
	ls 3_run_simphy_list_* >> array_list.txt

	
done
	
