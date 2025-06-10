#!/bin/bash
#SBATCH --job-name="IQWickett"
#SBATCH --time=96:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH --mail-user="molly.donnellan@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH -c 20
#SBATCH --mem=120G

cd $SLURM_SUBMIT_DIR

date

module load mpich/4.2.1
module load uri/main
module load iq-tree/2.3.1

#Path to empirical dataset as fasta file. CHANGE to the path for the folder containing files ending in ".c1c2.f25".
filesEmpirical="../PML/datasets/Wickett_alignments/FNA2AA_Filtered/*.c1c2.f25"

#Concatenate input fasta files and prepare partitions ahead of IQTree run. CHANGE to the path for the folder containing the file "AMAS.py"
python3 ../AMAS/amas/AMAS.py concat -f fasta -d dna --out-format fasta --part-format raxml -i *f25 -c 20 -t concatenatedTrain.fasta -p partitionsTrain.txt

#Run IQtree. Flags: -nt: use 20 CPU cores -spp: specifies partition file but allows partitions to have different evolutionary speeds -pre: specifies prefix for output files -m: determine best fit model immediately followed by tree reconstruction -bb: sets 1000 bootstrap replicates  -alrt: sets 1000 replicates to perform SH-like approximate likelihood test (SH-aLRT)
iqtree2-mpi -nt 20 -s concatenatedTrain.fasta -spp partitionsTrain.txt -pre inferenceEmpirical -m MFP -bb 1000 -alrt 1000

date
