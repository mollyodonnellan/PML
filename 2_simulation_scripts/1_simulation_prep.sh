#!/bin/bash
#SBATCH --job-name="simulation_prep"
#SBATCH --time=72:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH --mail-user="molly.donnellan@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH -c 2
#SBATCH --mem-per-cpu=6G

##This script organizes data for simulations and generate folders with different
# species tree datasets.
#
# Each folder will have a simulated species tree
# and parameters needed to simulate loci
#
# Folders are generated in the working dir
# Be sure to adjust path to SimPhy.

#CHANGE "run_sptree_SimPhy.R" script to be relevant to your work

pwd
date

mkdir ../simulations/random
cd ../simulations/random

module load uri/main
module load R-bundle-Bioconductor/3.15-foss-2021b-R-4.2.0

Rscript ../../2_simulation_scripts/run_sptree_SimPhy.R #CHANGE path to be relevant to your work
