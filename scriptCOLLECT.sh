#!/bin/bash
#
echo -e "\n Checking that the calculations ended normally \n"
#default values for options
fileINP=""
fileOUT=""
con=0
nor=0
opt=0
sta=0
geo=0
usage (){
	  echo
	  echo "Usage:     scriptOUT.sh [OPTIONS] <INPUT_FILE>"
	  echo
	  echo 'Options:'
	  echo ' -c  Case check "Initial convergence"'
	  echo ' -N  Case check "Normal termination of Gaussian"'
	  echo ' -s  Case check "--Stationaty point found"'
	  echo ' -o  Case check "Optimization completed"'
	  echo ' -g  Case collect geometry for optimization completed'
	  echo ' -f  File where to collect the data (Default is all .log)'
	  echo ' -F  File Write name of file for store the data (Default is done.txt)'
	  echo ' -h HELP'
}
while [ -n "`echo $1 | grep '^-'`" ]; do
    case $1 in
	-c ) con=1;;
	-N ) nor=1;;
	-s ) sta=1;;
	-o ) opt=1;;
	-g ) geo=1;;
	-f ) fileINP=$2; shift;;
	-F ) fileOUT=$2; shift;;
	-h ) usage; exit 1;;
	 * ) usade; exit 1;;
    esac
    shift
done
if [ -z "$fileOUT" ]; then fileOUT=done.txt;
			echo -e "\n***** WARNING ***** \n File for storage is not defined, will used $fileOUT \n"
fi
if [ -z "$fileINP" ]; then
    echo -e "\n***** WARNING ***** \n File for collect is not defined, will collect in all files .log \n"
    
    dirs=`ls -d */`
    for i in $dirs
    do
	cd $i
	echo "      -------- In directory $i--------"
	touch ${fileOUT}
	echo -e "" > ${fileOUT}
	if [ $con = 1 ]; then
	    echo -e "\n CONVERGED" >> ${fileOUT}
	    grep -l "Initial convergence" *.log >> ${fileOUT}
	fi
	if [ $nor = 1 ]; then
	    echo -e "\n NORMAL TERMINATION" >> ${fileOUT}
	    grep -l "Normal termination of Gaussian" *.log >> ${fileOUT}
	fi
	if [ $sta = 1 ]; then
	    echo -e "\n STATIONARY POINT FOUND " >> ${fileOUT}
	    grep -l "Stationary point found." *.log >> ${fileOUT}
	fi
	if [ $opt = 1 ]; then
	    echo -e "\n OPTIMIZATION COMPLETED " >> ${fileOUT}
	    grep -l "Optimization completed" *.log >> ${fileOUT}
	fi
	if [ $geo = 1 ]; then
	    fileINP=`ls | grep Opt | grep .log`
	    #fileINP=`ls *.log`
       	    for j in $fileINP
	    do
		aux=`grep "Normal termination" $j`
		if [ -z "$aux" ]; then
		    echo -e "$j Not Terminated"  
		else
		    #echo -e "file is $fileINP"
		    #echo -e "J is $j"
		    a=moleculetemp
		    i=${j%.log}.xyz
		    #echo -e "TESTING $i"
		    grep "SCF Done" $j > c
		    d=`tail -1 c |awk '{print$3$4$5}'`
		    awk '/-- Stationary point found/,/Distance matrix/' $j | awk '/Number     Number/,/Distance matrix/' | awk '/---------------------------------------------------------------------/,/Distance matrix/' | sed '1d' | sed '$d' | sed '$d' | awk '{printf " %d    %9.6f    %9.6f    %9.6f\n",$2,$4,$5,$6}' > ${a}
		    ../atomic2simbol.sh ${a}
		    
		    wc -l ${a} > b
		    awk '{$2=""; print}' b > ${i}
		    echo -e	"Geometry for $j $d" >> ${i}
		    cat ${a} >> ${i}
		    mv ${i} Geometries
		    rm c
		    rm b
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
		   rm c
		   rm b
	       fi
	   fi
	   else
	       echo "FILE $fileINP ISN'T FOUND IN THIS DIRECTORY"
	fi
	   cd ../	
    done
fi






    




