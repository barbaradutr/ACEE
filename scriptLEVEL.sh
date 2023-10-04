#!/bin/bash
#
Prog=$1
Type=$2
inpbasis=$3
inpfunc=$4
Mem=$5
Nproc=$6
Mod=$7
Geom=$8
#MaxCycles=$7
#MaxStep=$8
#N=$9
#t=${10}

echo -e "\n   **In SCRIPT LEVEL\n   Program=$Prog Type=$Type Geom=$Geom Inpbasis=$inpbasis Inpfunc=$inpfunc Memory=$Mem Model=$Mod Nprocess=$Nproc MaxCycles=$MaxCycles MaxStep=$MaxStep Node=$N Time=$t \n"
functional=`cat $inpfunc`
basiset=`cat $inpbasis`
#echo "Functional = $functional"
#echo "Basiset = $basiset"
i=0
for Functional in $functional
do
    for Basiset in $basiset
    do
	((i++))
#	echo "Functional = $Functional"
#	echo "Basiset = $Basiset"
	echo -e "\n   Performing calculation level is functional $Functional and basiset $Basiset"
#	export Functional
	#	export Basiset
	if [ "$Nproc" = "A" ]; then
	    if [ $i -le 8 ]; then
		Nprocaux=4
	    elif [ $i -le 17 ]; then	
		Nprocaux=6
	    elif [ $i -le 23 ]; then	
		Nprocaux=8
	    else
		i=1
		Nprocaux=4
	    fi
	else
	    Nprocaux=$Nproc
	fi
	#./scriptINP.sh $Basiset $Functional $Prog $Type $Mem $Nproc $MaxCycles $MaxStep $N $t
	./scriptINP.sh $Basiset $Functional $Prog $Type $Mem $Nprocaux $Mod $Geom
    done
done
