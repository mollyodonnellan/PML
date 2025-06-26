#!/bin/bash
#SBATCH --job-name="IQarr"
#SBATCH --time=72:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -c 20
#SBATCH --array=1-7
#SBATCH --mem-per-cpu=6G


date

module load mpich/4.2.1
module load uri/main
module load iq-tree/2.3.1

amas="/home/aknyshov/alex_data/andromeda_tools/AMAS/amas/AMAS.py" #CHANGE to be relevant to your own work

for i in ../simulations/*/*/1/subsets
do
	cd ${i}
	pwd
	aligned_loci_path="../alignments3"
	fileline=$(sed -n ${SLURM_ARRAY_TASK_ID}p array_list.txt)
	echo ${fileline}
	infiles=$(cat $fileline | while read line; do newline=$(echo $line | sed 's/train\.txt_//g'); echo ${aligned_loci_path}/${newline}; done | paste -sd" ")
	echo $infiles	
	python ${amas} concat -f fasta -d dna --out-format fasta --part-format raxml -i $infiles -t concatenated_${fileline}.fasta -p partitions_${fileline}.txt

	iqtree2-mpi -nt 20 -s concatenated_${fileline}.fasta -spp partitions_${fileline}.txt -pre inference_${fileline} -m MFP -bb 1000 -alrt 1000

	cd ../../../../../5_locus_utility_prediction
done
date
