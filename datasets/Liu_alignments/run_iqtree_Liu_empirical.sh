#!/bin/bash
#SBATCH --job-name="IQLiu"
#SBATCH --time=96:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=2   # number of nodes
#SBATCH --ntasks-per-node=24   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH --mail-user="molly.donnellan@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH --exclusive
#SBATCH --mem=250G

cd $SLURM_SUBMIT_DIR

date

module load mpich/4.2.1
module load uri/main
module load iq-tree/2.3.1

#Path to empirical dataset as phylip file. CHANGE to the path for the folder containing files ending in ".phy"
filesEmpirical="/PML/datasets/Liu_alignments/seq/seq/cds/*.phy"

#Concatenate input fasta files and prepare partitions ahead of IQTree run. CHANGE to the path for the folder containing the file "AMAS.py"
python3 /AMAS/amas/AMAS.py concat -f phylip -d dna --out-format fasta --part-format raxml -i ${filesEmpirical} -c 20 -t concatenatedTrain.fasta -p partitionsTrain.txt

#Run IQtree. Flags: -nt: use 20 CPU cores -spp: specifies partition file but allows partitions to have different evolutionary speeds -pre: specifies prefix for output files -m: determine best fit model immediately followed by tree reconstruction -bb: sets 1000 bootstrap replicates  -alrt: sets 1000 replicates to perform SH-like approximate likelihood test (SH-aLRT)
iqtree2-mpi -nt 20 -s concatenatedTrain.fasta -spp partitionsTrain.txt -pre inferenceEmpirical -m MFP -bb 1000 -alrt 1000

date
