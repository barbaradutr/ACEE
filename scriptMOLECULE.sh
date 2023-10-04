#!/bin/bash
#
Moleculetemp=$1
sed -i 's/H/H   1.0  /g' $Moleculetemp  
sed -i 's/He/He   2.0  /g' $Moleculetemp
sed -i 's/Li/Li   3.0  /g' $Moleculetemp
sed -i 's/Be/Be   4.0  /g' $Moleculetemp
sed -i 's/B/B   5.0  /g' $Moleculetemp
sed -i 's/C/C   6.0  /g' $Moleculetemp
sed -i 's/N/N   7.0  /g' $Moleculetemp
sed -i 's/O/O   8.0  /g' $Moleculetemp  
sed -i 's/F/F   9.0  /g' $Moleculetemp 
sed -i 's/Ne/Ne   10.0  /g' $Moleculetemp
sed -i 's/Na/Na   11.0  /g' $Moleculetemp
sed -i 's/Mg/Mg   12.0  /g' $Moleculetemp
sed -i 's/Al/Al   13.0  /g' $Moleculetemp
sed -i 's/Si/Si   14.0  /g' $Moleculetemp
sed -i 's/P/P   15.0  /g' $Moleculetemp
sed -i 's/S/S   16.0  /g' $Moleculetemp
sed -i 's/Cl/Cl   17.0  /g' $Moleculetemp
sed -i 's/Ar/Ar   18.0  /g' $Moleculetemp
