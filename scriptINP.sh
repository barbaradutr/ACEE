#!/bin/bash
#
Prog=$3
Type=$4
Basiset=$1
Functional=$2
Geom=$8
Mem=$5
Nproc=$6
Mod=$7
#MaxCycles=$7
#MaxStep=$8
#N=$9
#t=${10}
echo -e "\n      **In SCRIPT INP\n      Program=$Prog Type=$Type Model=$Mod Inpbasis=$Basiset Inpfunc=$Functional Memory=$Mem Nproc=$Nproc MaxCycles=$MaxCycles MaxStep=$MaxStep Node=$N Time=$t"

if [ -z "$Prog" ] || [ -z "$Basiset" ] || [ -z "$Functional" ] || [ -z "$Type" ]; then echo -e "***** ERROR ***** \n Variables essentials not defined";									       exit
fi
#echo "Nproc = $Nproc Mem = $Mem MaxCycles = $MaxCycles MaxStep = $MaxStep"
if [ -z "$Nproc" ]; then Nproc=6;
			 echo -e "      ***** WARNING ***** \n      Nproc is not defined, will used $Nproc"
fi
if [ -z "$Mem" ]; then Mem=10GB;
		       echo -e "      ***** WARNING ***** \n      Memory is not defined, will used $Mem"
fi
if [ "$Mod" = "Opt" ]; then
    if [ -z "$MaxCycles" ]; then MaxCycles=50;
				 echo -e "      ***** WARNING ***** \n      MaxCycles is not defined, will used $MaxCycles"
    fi
    if [ -z "$MaxStep" ]; then MaxStep=30;
			       echo -e "      ***** WARNING ***** \n      MaxStep is not defined, will used $MaxStep"
    fi
fi
dirs=`ls -d */` 
echo "      Directories are :
$dirs"	    		    

for i in $dirs
do
    #rm *[A,S-z,3-7]/*.inp
    #rm *.com
    cd $i
    #rm *.inp
    echo "      -------- In directory $i--------"
    if [ $Geom = 0 ]; then
	Molecule=`ls *.xyz`

    elif [ "$Geom" = "-Z" ]; then
	Molecule=`ls *.zmat`
    fi
    #Molecule1=${Molecule%.xyz}
    #echo "MOLECULE $Molecule1"
    if [ $Geom = 0 ]; then
	Name="${Molecule%.xyz}"_"$Basiset"_"$Functional"_"$Type"_"$Mod"
	echo "      INPUT FILE NAME: $Name"
    
    elif [ "$Geom" = "-Z" ]; then
	Name="${Molecule%.zmat}"_"$Basiset"_"$Functional"_"$Type"_"$Mod"
	echo "      INPUT FILE NAME: $Name"
    fi
    if [ -e "$Name.log" ]; then
	echo "      THERE IS ALREADY IN THE DIRECTORY THE OUTPUT $Name.log"
      	aux=`grep "Normal termination" $Name.log`
	if [ -z $aux ]; then
	    echo "       $Name.log ##ANORMAL## TERMINATION"
	else
	    echo "       $Name.log ##NORMAL## TERMINATION"
	fi
	
    else
    	
	if [ "$Prog" = "Gamess" ]; then
	    ../scriptGAMESS.sh $Mod $Geom $Type $Nproc $OutputName $Molecule $Mem $Name	
	elif [ "$Prog" = "Gaussian" ]; then
	    echo "IN SCRIPT INP INSIDE IF GAUSSIAN MOD = $Mod GEOM = $Geom TYPE = $Type NPROC = $Nproc MOLECULE = $Molecule MEMORY = $Mem NAME = $Name"
	    ../scriptGAUSSIAN.sh $Mod $Geom $Type $Nproc $Molecule $Mem $Name $Basiset $Functional
	else
	    echo "      WARNING NECESSARY PROGRAM"
	fi
    fi
    cd ../
done


