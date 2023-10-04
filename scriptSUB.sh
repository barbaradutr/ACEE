#!/bin/bash
#
OutputName=$1
Nproc=$2
Mem=$3
#N=$4
#t=$5
p=methano
if [ $Nproc -eq 4 ]; then x="NULL";
elif [ $Nproc -eq 6 ]; then x="methano-[21-23]";
elif [ $Nproc -eq 2 -o $Nproc -eq 8 ]; then x="NULL";
else
    echo "Number of core is not defined: $Nproc"
    exit 1
fi
#echo "printing nnn x = $x $Nproc"
cat > sub16.sh<<EOF
#!/bin/bash
#
################################################################
#
# Slurm queue environment variables
#
#SBATCH -t $t
#SBATCH -x $x
#SBATCH -p $p
#SBATCH -N $N
#SBATCH -n $Nproc
#SBATCH --job-name=${Mem}_${Nproc}_${OutputName}
############################################
#
# Define the Gaussian environment variables
#
# Optimized gaussian 16 path on methano nodes 
node=\`hostname\`
if [[ "${node:0:9}" == "methano-2" ]]; then
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
. \$g16root/g16/bsd/g16.profile
#ulimit -H -c unlimited
############################################
#
# Run Gaussian 16
#
inputfile=${OutputName%.com}
#
echo Job: \$inputfile.com
echo Starting date: `date`
echo Running on machine: \$node
echo Gaussina path: \$g16root
echo
echo ---------------------------------------------------------
echo ---------------------------------------------------------
head \$inputfile.com
echo ---------------------------------------------------------
time \$g16root/g16/g16 \$inputfile.com
#formchk \$inputfile.chk \$inputfile.fch
echo
echo Ending date: `date`
EOF

#if [ $Nproc -eq 2 -o $Nproc -eq 8 ];then
   a=archive.tmp
   sed '8d' sub16.sh > ${a}
   cat ${a} > sub16.sh
   rm ${a}
#fi
