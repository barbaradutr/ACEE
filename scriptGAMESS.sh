#!/bin/bash
#
Mod=$1
Geom=$2
Type=$3
Nproc=$4
OutputName=$5
Molecule=$6
Mem=$7
Name=$8



 if [ -z "Geom" ];then
		OutputName=$Name.inp 
		touch "$OutputName"
		#Attribute functional
		echo -e '$CONTRL SCFTYP='$Type' RUNTYP=OPTIMIZE COORD=XYZ NZVAR=0 $END \n$SYSTEM TIMLIM=10000 MWORDS=100 $END \n$STATPT OPTTOL=1.0E-6 $END \n$BASIS  GBASIS='$Basiset' $END \n$DATA' > $OutputName
		Moleculetemp=${Molecule%.xyz}.tmp
		cat $Molecule > $Moleculetemp
		sed -i '1,2d' $Moleculetemp
		../scriptMOLECULE.sh $Moleculetemp
		cat $Moleculetemp >> $OutputName
		echo -e '\n$END' >> $OutputName

	    elif [ "Geom" = "-O" ];then
		OutputName=$Name.inp 
		touch "$OutputName"
		#Attribute functional
		echo -e '$CONTRL SCFTYP='$Type' RUNTYP=OPTIMIZE COORD=XYZ NZVAR=0 $END \n$SYSTEM TIMLIM=10000 MWORDS=100 $END \n$STATPT OPTTOL=1.0E-6 $END \n$BASIS  GBASIS='$Basiset' $END \n$DATA' > $OutputName
        	Moleculetemp=`awk '/-- Stationary point found/,/Distance matrix/' amino_meta_Def2SV_M062X_DFT_Opt.log | awk '/Number     Number/,/Distance matrix/' | awk '/---------------------------------------------------------------------/,/Distance matrix/' | sed '1d' | sed '$d' | sed '$d' | awk '{printf " %d  \t  %3.6f    %3.6f    %3.6f\n",$2,$4,$5,$6}'`
		
		../simbolforz.sh $Moleculetemp
		cat $Moleculetemp >> $OutputName
		echo -e '\n$END' >> $OutputName	
	    else
		OutputName=$Name.inp 
		touch "$OutputName"
		#Attribute functional
		echo -e '$CONTRL SCFTYP='$Type' RUNTYP=OPTIMIZE COORD=XYZ NZVAR=0 $END \n$SYSTEM TIMLIM=10000 MWORDS=100 $END \n$STATPT OPTTOL=1.0E-6 $END \n$BASIS  GBASIS='$Basiset' $END \n$DATA' > $OutputName
		Moleculetemp=${Molecule%.xyz}.tmp
		cat $Molecule > $Moleculetemp
		sed -i '1,2d' $Moleculetemp
		../scriptMOLECULE.sh $Moleculetemp
		cat $Moleculetemp >> $OutputName
		echo -e '\n$END' >> $OutputName		
	    fi
