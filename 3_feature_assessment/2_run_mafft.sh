#!/bin/bash
#SBATCH --job-name="align2"
#SBATCH --time=196:00:00  # walltime limit (HH:MM:SS)
#SBATCH -c 4
#SBATCH -p uri-cpu
#SBATCH --mail-user="molly.donnellan@uri.edu" #CHANGE TO user email address
#SBATCH --mail-type=ALL
#SBATCH --array=[0-48]%49

### adjust/add sbatch flags as needed

module load uri/main
module load MAFFT/7.505-GCC-11.3.0-with-extensions 

SPP=(../simulations/*/*/1/alignmentGroups)
i=${SPP[$SLURM_ARRAY_TASK_ID]}

	cd ${i}
	pwd
	fileline=$(sed -n '1,8'p array_list.txt)
	echo "Processing $fileline"	
	
	cat ${fileline} | while read line
	do
		mafft --auto --thread 4 ../alignments2/${line} > ../alignments3/${line}
	done
	cd ../../../../../3_feature_assessment
