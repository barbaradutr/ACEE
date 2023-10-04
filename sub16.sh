#!/bin/bash
#
################################################################
#
# Slurm queue environment variables
#
#SBATCH -t infinite
#SBATCH -x methano-[21-23]
#SBATCH -p methano
#SBATCH -N 1
#SBATCH -n 6
#SBATCH --job-name=10GB_6_nitro_meta_Def2TZV_wB97XD_DFT_Opt.com
############################################
#
# Define the Gaussian environment variables
#
# Optimized gaussian 16 path on methano nodes AAAAAAA
node=`hostname`
if [[ "" == "methano-2" ]]; then
    # This path only on methano-[21-23]
    g16root=/usr/local/gaussian/G16_x86-64_AVX
else
    #
    # This path works on methano-[02-05,11-17,51-55]
    g16root=/usr/local/gaussian/G16_x86-64_SSE4
fi
# General gaussian 16 legacy path working on all methano nodes
g16root=/usr/local/gaussian/G16_x86-64_legacy
#
# Gaussicd an screath directory on methano cluster
GAUSS_SCRDIR=/scr/
#
export g16root GAUSS_SCRDIR
. $g16root/g16/bsd/g16.profile
#ulimit -H -c unlimited
############################################
#
# Run Gaussian 16
#
inputfile=nitro_meta_Def2TZV_wB97XD_DFT_Opt
#
echo Job: $inputfile.com
echo Starting date: Tue Mar 21 15:01:42 -03 2023
echo Running on machine: $node
echo Gaussina path: $g16root
echo
echo ---------------------------------------------------------
echo ---------------------------------------------------------
head $inputfile.com
echo ---------------------------------------------------------
time $g16root/g16/g16 $inputfile.com
#formchk $inputfile.chk $inputfile.fch
echo
echo Ending date: Tue Mar 21 15:01:42 -03 2023
