#!/bin/bash
#
np=$1
exb=$2
#np = number of points exb = experimental broadening 
input=`ls | grep -i TDDFT | grep .log`
for j in $input
do
    aux=`grep "Normal termination" $j`
    if [ -z "$aux" ]; then
	echo -e "$j Not Terminated"  
    else
	i=${j%.log}.dat
	fileOUT=espectro_${j%.log}.dat
#	echo -e "$fileOUT"
	./scriptENERGY.sh ${j} ${i}
	#a=input.cnv
	echo -e "$np\n$exb\n$i 2" > input.cnv
	./conv2.x > ${fileOUT}
	#awk '/Convoluted spectra:/,/Done!/' b > $fileOUT
    fi
done

