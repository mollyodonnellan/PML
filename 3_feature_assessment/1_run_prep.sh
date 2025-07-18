#!/bin/bash
#SBATCH --job-name="prep"
#SBATCH --time=1:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH --mail-user="molly.donnellan@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH -c 1
#SBATCH --mem-per-cpu=6G
#SBATCH --array=[0-48]%49

date

SPP=(../simulations/*/*/1)
i=${SPP[$SLURM_ARRAY_TASK_ID]}

	cd ${i}
	pwd
	ls
	aligned_loci_path="../alignments2"

	mkdir alignmentGroups
	cd alignmentGroups
	ls ${aligned_loci_path} | rev | cut -f1 -d/ | rev | split -l 250 - aligned_loci_list_
	ls aligned_loci_list_* > array_list.txt
	cd ..
	mkdir alignments3
	mkdir iqtree_genetrees2
	mkdir iqtree_genetrees3
	mkdir phylomad_assessment
	mkdir rate_assessment
	mkdir iqtree_concattree
	mkdir astral_tree
	cd ../../../../2_simulation_scripts

date
