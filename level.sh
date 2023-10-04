#!/bin/bash
#
Prog=$1
Type=$2
inpbasis=$3
inpfunc=$4
Mem=$5
Nproc=$6
MaxCycles=$7
MaxStep=$8
echo -e "\n   **In SCRIPT LEVEL\n   Program=$Prog Type=$Type Inpbasis=$inpbasis Inpfunc=$inpfunc Memory=$Mem Nprocess=$Nproc MaxCycles=$MaxCycles MaxStep=$MaxStep\n"
#if [ -z $inpfunc ]; then inpfunc=functional.txt; fi
#if [ -z $inpbasis ]; then inpbasis=basiset.txt; fi
functional=`cat $inpfunc`
basiset=`cat $inpbasis`
#echo "Functional = $functional"
#echo "Basiset = $basiset"
for Functional in $functional
do
    for Basiset in $basiset
    do
#	echo "Functional = $Functional"
#	echo "Basiset = $Basiset"
	echo -e "\n   Performing calculation level is functional $Functional and basiset $Basiset"
#	export Functional
#	export Basiset
	./scriptINP.sh $Basiset $Functional $Prog $Type $Mem $Nproc $MaxCycles $MaxStep
	#./subg16.sh
    done
done
