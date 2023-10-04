#!/bin/bash
#
Mod=$1
Geom=$2
Type=$3
Nproc=$4
Molecule=$5
Mem=$6
Name=$7
Basiset=$8
Functional=$9

##############################################################
#--------------------SINGLE POINTS AND DFT-------------------#
##############################################################
#echo "#######MOLECULE######### $Molecule"
echo "IN SCRIPT GAUSSIAN MOD = $Mod GEOM = $Geom TYPE = $Type NPROC = $Nproc MOLECULE = $Molecule MEMORY = $Mem NAME = $Name"

if [ "$Mod" = "Sp" ] && [ $Geom = 0 ] && [ "$Type" = "DFT" ]; then
    OutputName=$Name.com
    echo "OUTPUTNAME INSIDE GAUSSIAN $OutputName"
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Molecule%.xyz}.tmp
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule > $Moleculetemp
    sed -i '1,2d' $Moleculetemp
    cat $Moleculetemp >> $OutputName
    echo -e >> $OutputName

elif [ "$Mod" = "Sp" ] && [ "$Geom" = "-O" ]  && [ "$Type" = "DFT" ]; then
    OutputName=${Name}_${Geom}.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    chkname="${Molecule%.xyz}"_"$Basiset"_"$Functional"_"$Type"_"Opt".chk
    cat $chkname > ${Name}_${Geom}.chk
    echo -e %chk=${Name}_${Geom}.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Int=UltraFine Geom=Check Guess=Read GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName

elif [ "$Mod" = "Sp" ] && [ "$Geom" = "-Z" ] && [ "$Type" = "DFT" ]; then
    OutputName=$Name.com
    echo "OUTPUTNAME INSIDE GAUSSIAN $OutputName"
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Molecule%.zmat}.tmp
    charge=`grep "charge"  ${Molecule%.zmat}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.zmat}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule >> $OutputName
    echo -e >> $OutputName

 elif [ "$Mod" = "Sp" ] && [ $Geom != 0 ] && [ "$Geom" != "-O" ] && [ "$Geom" != "-Z" ] && [ "$Type" = "DFT" ]; then 
    OutputName=$Name.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Geom%.xyz}.tmp
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule > $Moleculetemp
    sed -i '1,2d' $Moleculetemp
    cat $Moleculetemp >> $OutputName
    echo -e >> $OutputName


    
    ##########################################################
    #--------------------OPTIMIZED AND DFT-------------------#
    ##########################################################
   
elif [ "$Mod" = "Opt" ] && [ $Geom = 0 ] && [ "$Type" = "DFT" ]; then
    OutputName=$Name.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq Opt=(Tight,MaxStep=$MaxStep,MaxCycles=$MaxCycles) Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Molecule%.xyz}.tmp
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule > $Moleculetemp
    sed -i '1,2d' $Moleculetemp
    cat $Moleculetemp >> $OutputName
    echo -e >> $OutputName

elif [ "$Mod" = "Opt" ] && [ $Geom = 0 ] && [ "$Type" = "DFT" ]; then
    OutputName=$Name.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq Opt=(Tight,MaxStep=$MaxStep,MaxCycles=$MaxCycles) Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Molecule%.xyz}.tmp
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule > $Moleculetemp
    sed -i '1,2d' $Moleculetemp
    cat $Moleculetemp >> $OutputName
    echo -e >> $OutputName
    
elif [ "$Mod" = "Opt" ] && [ "$Geom" = "-Z" ]  && [ "$Type" = "DFT" ]; then
    OutputName=$Name.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq Opt=(Tight,MaxStep=$MaxStep,MaxCycles=$MaxCycles) Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Molecule%.zmat}.tmp
    charge=`grep "charge"  ${Molecule%.zmat}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.zmat}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule >> $OutputName
    echo -e >> $OutputName

elif [ "$Mod" = "Opt" ] && [ $Geom != 0 ] && [ "$Geom" != "-O" ] && [ "$Geom" != "-Z" ] && [ "$Type" = "DFT" ]; then 
    OutputName=$Name.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq Opt=(Tight,MaxStep=$MaxStep,MaxCycles=$MaxCycles) Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Geom%.xyz}.tmp
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule > $Moleculetemp
    sed -i '1,2d' $Moleculetemp
    cat $Moleculetemp >> $OutputName
    echo -e >> $OutputName


    ################################################################
    #--------------------SINGLE POINTS AND TDDFT-------------------#
    ################################################################



elif [ "$Mod" = "Sp" ] && [ $Geom = 0 ] && [ "$Type" = "TDDFT" ]; then
    OutputName=$Name.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq TD=(singlets,nstates=50) Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Molecule%.xyz}.tmp
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule > $Moleculetemp
    sed -i '1,2d' $Moleculetemp
    cat $Moleculetemp >> $OutputName
    echo -e >> $OutputName

elif [ "$Mod" = "Sp" ] && [ "$Geom" = "-Z" ] && [ "$Type" = "TDDFT" ]; then
    OutputName=$Name.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq TD=(singlets,nstates=50) Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Molecule%.zmat}.tmp
    charge=`grep "charge"  ${Molecule%.zmat}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.zmat}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule >> $OutputName
    echo -e >> $OutputName
    
elif [ "$Mod" = "Sp" ] && [ "$Geom" = "-O" ]  && [ "$Type" = "TDDFT" ]; then
    OutputName=${Name}_${Geom}.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    #Moleculetemp=${Molecule%.xyz}.tmp
    # echo "INSIDE ROUTINE TDDFT ######## MOD = $Mod GEOM = $Geom TYPE = $Type NPROC = $Nproc MOLECULE = $Molecule MEMORY = $Mem NAME = $Name"
    chkname="${Molecule%.xyz}"_"$Basiset"_"$Functional"_"DFT"_"Opt".chk
    #echo "CHKNAME = $chkname"
    cat $chkname > ${Name}_${Geom}.chk
    echo -e %chk=${Name}_${Geom}.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq TD=(singlets,nstates=50) Int=UltraFine Geom=Check Guess=Read GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName

elif [ "$Mod" = "Sp" ] && [ $Geom != 0 ] && [ "$Geom" != "-O" ] && [ "$Geom" != "-Z" ] && [ "$Type" = "TDDFT" ];then 
    OutputName=$Name.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq TD=(singlets,nstates=50) Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Geom%.xyz}.tmp
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule > $Moleculetemp
    sed -i '1,2d' $Moleculetemp
    cat $Moleculetemp >> $OutputName
    echo -e >> $OutputName


    ############################################################
    #--------------------OPTIMIZED AND TDDFT-------------------#
    ############################################################
    #---------OPTIMIZED FOR TDDFT - EXCITED STATE--------------#

elif [ "$Mod" = "Opt" ] && [ $Geom = 0 ] && [ "$Type" = "TDDFT" ]; then
    OutputName=$Name.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq Opt=(Tight,MaxStep=$MaxStep,MaxCycles=$MaxCycles) TD=(singlets,nstates=50,root=1) Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Molecule%.xyz}.tmp
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule > $Moleculetemp
    sed -i '1,2d' $Moleculetemp
    cat $Moleculetemp >> $OutputName
    echo -e >> $OutputName

elif [ "$Mod" = "Opt" ] && [ "$Geom" = "-Z" ] && [ "$Type" = "TDDFT" ]; then
    OutputName=${Name}_${Geom}.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    chkname="${Molecule%.zmat}"_"$Basiset"_"$Functional"_"DFT"_"Opt".chk
    cat $chkname > ${Name}_${Geom}.chk
    echo -e %chk=${Name}_${Geom}.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq Opt=(Tight,MaxStep=$MaxStep,MaxCycles=$MaxCycles) TD=(singlets,nstates=50,root=1) Int=UltraFine Geom=Check Guess=Read GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    charge=`grep "charge"  ${Molecule%.zmat}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.zmat}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"`
    echo $charge $multiplicity >> $OutputName
    cat $Molecule >> $OutputName
    echo -e >> $OutputName
   

elif [ "$Mod" = "Opt" ] && [ $Geom != 0 ] && [ "$Geom" != "-O" ] && [ "$Geom" != "-Z" ] && [ "$Type" = "TDDFT" ]; then 
    OutputName=$Name.com
    touch "$OutputName"
    echo -e %nprocshared=$Nproc > $OutputName
    echo -e %chk=$Name.chk >> $OutputName
    echo -e %mem=$Mem >> $OutputName
    echo -e "# $Functional/$Basiset Freq Opt=(Tight,MaxStep=$MaxStep,MaxCycles=$MaxCycles) TD=(singlets,nstates=50,root=1) Int=UltraFine GFInput IOP(6/7=3)" >> $OutputName
    echo -e '\nCalculation '$Name'' >> $OutputName
    echo -e >> $OutputName
    Moleculetemp=${Geom%.xyz}.tmp
    charge=`grep "charge"  ${Molecule%.xyz}.dat`
    charge=`echo $charge | sed "s/charge=/ /g"`
    multiplicity=`grep "multiplicity"  ${Molecule%.xyz}.dat`
    multiplicity=`echo $multiplicity | sed "s/multiplicity=/ /g"` 
    echo $charge $multiplicity >> $OutputName
    cat $Molecule > $Moleculetemp
    sed -i '1,2d' $Moleculetemp
    cat $Moleculetemp >> $OutputName
    echo -e >> $OutputName
    
else
    echo -e "*****WARNING MISSING INFORMATIONS*****"
    
fi

../scriptSUB.sh $OutputName $Nproc $Mem
chmod u+x sub16.sh
sbatch sub16.sh
