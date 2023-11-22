#!/bin/bash
#
input=$1
output=$2
#echo -e "INSIDE ENERGY $input $output"
#echo Checking geometry convergency for diherals:
#awk '/Stationary point found/,/GradGradGradGradGrad/' $input | grep dih8 | awk '{printf " %f\n", $3 }'
#grep 'Excited State' $input | sed 's/f=//' | awk '{printf " %f \t 0.00000000 \n %f \t %f \n %f \t 0.00000000 \n", $7, $7, $9, $7}' > ${output}
echo "# Energies and oscilator streght from: $input" > ${output}
grep 'Excited State' $input | sed 's/f=//' | awk '{printf " %f  %f \n", $7, $9}' | tac >> ${output}
