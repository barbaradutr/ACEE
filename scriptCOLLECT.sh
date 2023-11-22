#!/bin/bash
#
echo -e "\n Checking that the calculations ended normally \n"
#default values for options
fileINP=""
fileOUT=""
norb=""
con=0
nor=0
opt=0
sta=0
geo=0
osc=0
orbi=0
espc=0
usage (){
    echo
    echo "Usage:     scriptOUT.sh [OPTIONS] <INPUT_FILE>"
    echo
    echo 'Options:'
    echo ' -c  Case check "Initial convergence"'
    echo ' -N  Case check "Normal termination of Gaussian"'
    echo ' -s  Case check "--Stationaty point found"'
    echo ' -opt  Case check "Optimization completed"'
    echo ' -g  Case collect geometry for optimization completed'
    echo ' -osc  Case collect energies and oscilator stregh'
    echo ' -esp  Case collect spectra convoluted'
    echo ' -orb  Case collect orbitals  Write size of line x1 and x2 and numbers of Vit. (Default is x1=1, x2=3, Vit.=10)'
    echo ' -f  File where to collect the data (Default is all .log)'
    echo ' -F  File Write name of file for store the data (Default is done.txt)'
    echo ' -h HELP'
}
while [ -n "`echo $1 | grep '^-'`" ]; do
    case $1 in
	-c ) con=1;;
	-N ) nor=1;;
	-s ) sta=1;;
	-opt ) opt=1;;
	-g ) geo=1;;
	-osc ) osc=1;;
	-orb ) orbi=1; x1=$2; x2=$3; shift;;
	-esp ) espc=1;;
	-f ) fileINP=$2; shift;;
	-F ) fileOUT=$2; shift;;
	-h ) usage; exit 1;;
	* ) usade; exit 1;;
    esac
    shift
done
#if [ -z "$fileOUT" ]; then fileOUT=done.txt;
#			   echo -e "\n***** WARNING ***** \n File for storage is not defined, will used $fileOUT \n"
#fi
if [ -z "$fileINP" ]; then
    echo -e "\n***** WARNING ***** \n File for collect is not defined, will collect in all files .log \n"
    
    dirs=`ls -d */`
    for i in $dirs
    do
	cd $i
	echo "      -------- In directory $i--------"
	echo "$con $nor $sta $opt $osc $orbi $geo $espc"
	if [ $con = 1 ]; then
	    touch ${fileOUT}
	    echo -e "" > ${fileOUT}
	    echo -e "\n CONVERGED" >> ${fileOUT}
	    grep -l "Initial convergence" *.log >> ${fileOUT}
	fi
	if [ $nor = 1 ]; then
	    touch ${fileOUT}
	    echo -e "" > ${fileOUT}
	    echo -e "\n NORMAL TERMINATION" >> ${fileOUT}
	    grep -l "Normal termination of Gaussian" *.log >> ${fileOUT}
	fi
	if [ $sta = 1 ]; then
	    touch ${fileOUT}
	    echo -e "" > ${fileOUT}
	    echo -e "\n STATIONARY POINT FOUND " >> ${fileOUT}
	    grep -l "Stationary point found." *.log >> ${fileOUT}
	fi
	if [ $opt = 1 ]; then
	    touch ${fileOUT}
	    echo -e "" > ${fileOUT}
	    echo -e "\n OPTIMIZATION COMPLETED " >> ${fileOUT}
	    grep -l "Optimization completed" *.log >> ${fileOUT}
	fi
	if [ $osc = 1 ]; then
	    echo -e "Inside OSCILATOR"
	    fileINP=`ls | grep TDDFT | grep .log`
	    #echo -e "$fileINP"
	    #fileINP=`ls *.log`
       	    for j in $fileINP
	    do
		aux=`grep "Normal termination" $j`
		if [ -z "$aux" ]; then
		    echo -e "$j Not Terminated"  
		else
		    i=${j%.log}.dat
		    ../scriptENERGY.sh ${j} ${i}
		fi
	    done
	fi
	if [ $orbi = 1 ]; then
	    echo -e "Inside ORBITAL"
	    fileINP=`ls | grep -i opt | grep .log`
	    echo -e "$fileINP"
	    for j in $fileINP
	    do
	       	aux=`grep "Normal termination" $j`
		if [ -z "$aux" ]; then
		    echo -e "$j Not Terminated"
		else
		    fileOUT=orbital_${j%.log}.txt
		    mo=`awk '/alpha electrons/,/beta electrons/' $j | awk 'END{print $1}'`
		    echo -e "#Orbitals of $j\n #HOMO = $mo " > $fileOUT
		fi
		awk '/Optimization completed/,/Molecular Orbital Coefficients/' $j | awk '/The electronic state is /,/Molecular Orbital Coefficients/'| sed '1d' | sed '$d' | awk '{printf "%9.6f\n%9.6f\n%9.6f\n%9.6f\n%9.6f\n",$5,$6,$7,$8,$9}' | sed '/0.000000/d' > arquivo
		orb=`echo "$mo+10" | bc`
		head -$orb arquivo > arq
		for i in $(seq $orb);
		do
		    touch b
		    if [ -z "$x1" ]; then 
			echo -e " 1\n 3 " >> b
		    else
			echo -e " $x1\n $x2 " >> b
		    fi
		done
		sed -i 'p' arq
		touch d
		paste b arq > d
		if [ -z "$x2" ]; then
		    sed -i '/ 3 /G' d
		else
		    sed -i '/ '$x2' /G' d
		fi
		cat d >> $fileOUT
		rm arquivo arq b d
	    done
	    fileINP=`ls | grep -i TDDFT | grep .log`
	    echo "$fileINP"
	    for j in $fileINP
	    do
		aux=`grep "Normal termination" $j`
		if [ -z "$aux" ]; then
		    echo -e "$j Not Terminated"
		else
		    fileOUT=orbital_${j%.log}.txt
		    mo=`awk '/alpha electrons/,/beta electrons/' $j | awk 'END{print $1}'`   
		    echo -e "#Orbitals of $j\n #HOMO = $mo " > $fileOUT
		fi
		awk '/The electronic state is /,/Molecular Orbital Coefficients/' $j | sed '1d' | sed '$d' | awk '{printf "%9.6f\n%9.6f\n%9.6f\n%9.6f\n%9.6f\n",$5,$6,$7,$8,$9}' | sed '/0.000000/d' > arquivo
		orb=`echo "$mo+10" | bc`
		head -$orb arquivo > arq
		
		for i in $(seq $orb);
		do
		    touch b
		    if [ -z "$x1" ]; then 
			echo -e " 1\n 3 " >> b
		    else
			echo -e " $x1\n $x2 " >> b
		    fi
		done
		sed -i 'p' arq
		touch d
		paste b arq > d
		if [ -z "$x2" ]; then
		    sed -i '/ 3 /G' d
		else
		    sed -i '/ '$x2' /G' d
		fi
		cat d >> $fileOUT
		rm arquivo arq b d
	    done
        fi
	
	if [ $espc = 1 ]; then
	    fileINP=`ls | grep -i TDDFT | grep .log`
	    for j in $fileINP
	    do
		echo -e "FILE $j"
		aux=`grep "Normal termination" $j`
		if [ -z "$aux" ]; then
		    echo -e "$j Not Terminated"  
		else
		    fileOUT=${j%.log}_espectra.dat
		    echo
		    ../espectra.sh ${j} ${fileOUT}
	 	fi
	    done
	fi

	if [ $geo = 1 ]; then
	    fileINP=`ls | grep -i opt | grep .log`
	    #fileINP=`ls *.log`
       	    for j in $fileINP
	    do
		aux=`grep "Normal termination" $j`
		if [ -z "$aux" ]; then
		    echo -e "$j Not Terminated"  
		else
		    a=moleculetemp
		    i=${j%.log}.xyz
		    grep "SCF Done" $j > c
		    d=`tail -1 c |awk '{print$3$4$5}'`
		    awk '/-- Stationary point found/,/Distance matrix/' $j | awk '/Number     Number/,/Distance matrix/' | awk '/---------------------------------------------------------------------/,/Distance matrix/' | sed '1d' | sed '$d' | sed '$d' | awk '{printf " %d    %9.6f    %9.6f    %9.6f\n",$2,$4,$5,$6}' > ${a}
		    ../atomic2simbol.sh ${a}
		    wc -l ${a} > b
		    awk '{$2=""; print}' b > ${i}
		    echo -e	"Geometry for $j $d" >> ${i}
		    cat ${a} >> ${i}
		    #mv ${i} Geometries
		    rm b c
		fi
	    done
	fi
       	cd ../	
    done
    
else
    echo "File is $fileINP" 
    dirs=`ls -d */`
    for i in $dirs
    do
	cd $i
	echo "      -------- In directory $i--------"
	touch ${fileOUT}
	echo -e "" > ${fileOUT}
	
	if [ -e "$fileINP" ];then
	   echo "FOUND THE FILE $fileINP"
	   
	   if [ $con = 1 ]; then
	       echo -e "\n CONVERGED" >> ${fileOUT}
	       grep -l "Initial convergence" *.log >> ${fileOUT}
	   fi
	   if [ $nor = 1 ]; then
	       echo -e "\n NORMAL TERMINATION" >> ${fileOUT}
	       grep -l "Normal termination of Gaussian" *.log >> ${fileOUT}
	   fi
	   if [ $sta = 1 ]; then
	       echo -e "\n STATIONARY POINT FOUND" >> ${fileOUT}
	       grep -l "Stationary point found." *.log >> ${fileOUT}
	   fi
	   if [ $opt = 1 ]; then
	       echo -e "\n OPTIMIZATION COMPLETED" >> ${fileOUT}
	       grep -l "Optimization completed" *.log >> ${fileOUT}
	   fi          
	   if [ $geo = 1 ]; then
	       aux=`grep "Normal termination" $fileINP`
	       a=moleculetemp
	       i=${fileINP%.log}.xyz
	       if [ -z "$aux" ]; then
		   echo -e "$fileINP ERROR"
	       else
		   echo -e "Geometry for $fileINP" >> ${fileOUT}
		   grep "SCF Done" $fileINP > c
		   d=`tail -1 c |awk '{print$3$4$5}'`
		   awk '/-- Stationary point found/,/Distance matrix/' $fileINP | awk '/Number     Number/,/Distance matrix/' | awk '/---------------------------------------------------------------------/,/Distance matrix/' | sed '1d' | sed '$d' | sed '$d' | awk '{printf " %d    %9.6f    %9.6f    %9.6f\n",$2,$4,$5,$6}' > ${a}
		   ../atomic2simbol.sh ${a}
		   wc -l ${a} > b
		   awk '{$2=""; print}' b > ${i}
		   echo -e "Geometry for $fileINP $d" >> ${i}
		   cat ${a} >> ${i}
		   mv ${i} Geometries
		   rm b c
	       fi
	   fi
	   else
	       echo "FILE $fileINP ISN'T FOUND IN THIS DIRECTORY"
	fi
	   cd ../	
    done
fi
