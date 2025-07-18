#!/bin/bash
#SBATCH --job-name="Astr"
#SBATCH --time=2:00:00  # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=1   # processor core(s) per node
#SBATCH -p uri-cpu
#SBATCH --mail-user="molly.donnellan@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH -c 1
#SBATCH --mem-per-cpu=6G

module load uri/main
module load R/4.2.1-foss-2022a
date

for i in ../simulations/*/*/1
do
	cd $i
	pwd
	mkdir astral_tree
	cd astral_tree
	pwd
	gene_tree_path="../inferred_gene_trees_Test.tre"
	astral_path="/Astral.5.7.8/Astral/astral.5.7.8.jar" #CHANGE Path to be relevant to your work
	collapser_path="../../../../../3_feature_assessment/collapse_by.R"
	grep "/" ${gene_tree_path} > filtered.tre
	Rscript ${collapser_path} filtered.tre sh-alrt 0 collapsed_trees.tre
	rm filtered.tre
	java -Xmx5000M -jar ${astral_path} -i collapsed_trees.tre -o astral.tre -t 4 2>astral.log
	rm collapsed_trees.tre
cd ../../../../../3_feature_assessment
done

date
