#!/bin/bash
#SBATCH --job-name="post_simphy"
#SBATCH --time=72:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --array=[0-48]%49
#SBATCH -p uri-cpu
#SBATCH --mail-user="molly.donnellan@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH -c 2
#SBATCH --mem-per-cpu=6G

##This script generates simulation properties, runs SimPhy, and preps gene trees for INDELible

pwd
date

# create an array variable containing the folder names
SPP=(../simulations/*/*/)
i=${SPP[$SLURM_ARRAY_TASK_ID]}

echo "Processing: $i"

if [[ $(wc -l < ${i}1/gene_trees.tre) -lt 2000 ]]; then 
    while [[ $(ls ${i}1/loc_*/1/g_trees1.trees | wc -l) -lt 2000 ]]; do
        for j in $(seq 1 2000); do # go through all loc_ (2000)
            if [ -s ${i}1/loc_${j}/1/g_trees1.trees ]
                then echo "$i $j completed"
            else
                echo "$i loc_$j is not complete. Running"
                $(grep -w ${i}1/loc_${j} 3_run_simphy_command_list.txt)
            fi
        done
    done
   
    cat ${i}1/loc_*/1/g_trees1.trees > ${i}1/gene_trees.tre
    rm -rf ${i}1/loc_*
else echo "gene_trees.tre already exists - skipping."
fi


