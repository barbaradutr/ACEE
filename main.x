#!/bin/bash
#
#default values for options
Prog=""
inpbasis=0
inpfunc=0
Geom=0
Mem=0
MaxCycles=0
MaxStep=0
Mod=0
N=0
Nproc=0
Rem=0
t=0
Type=0
Vc=0
#
# Define usage message
#
usage (){
	  echo
	  echo "Usage:     main.x [OPTIONS] <INPUT_FILE>"
	  echo
	  echo 'Options:'
	  echo ' -g or -s  Case use Gamess -g or -s case Gaussian (working gamess is the default)'
	  echo ' -t type   Write type calcul (Default is DFT)'
	  echo ' -o or -sp  Case use Optimize -o or -sp case Single Point (Default is Single Point)'
	  echo ' -b file   Write file basiset (Default is basiset.txt)'
	  echo ' -f file   Write file functionals (Default is functional.txt)'
	  echo ' -m number Write quantity of memory (Default is 10GB)'
	  echo ' -N number Write quantity of nodes (Default is 1)'
	  echo ' --n number Write quantity of process (Default is 4)'
	  echo ' -c number Write quantity of Maxcycles (Default is 50)'
	  echo ' -s number Write quantity of MaxStep (Default is 30)'
	  echo ' -T number Write quantity of Time for execution (Default is infinite)'
	   echo -e ' -G geometry, Write geometry the want use: \n           -O optimized calculed before (.chk) \n           Name of file, case use a file\n           -Z case use .zmat\n           (Default is the .xyz original)'
	  echo ' -r remove all files .inp and *~ OR .com and *~'
	  echo ' -vc ATTENTION, VERY CLEAN, remove ALL FILES .log,.inp,.tmp and *~ OR .log,.com,.tmp,.chk,.out and *~'    
	  echo ' -h HELP'
	 }

while [ -n "`echo $1 | grep '^-'`" ]; do

#echo "PRINTING WHILE LOOPING VERBAL $1"
    
   case $1 in
      -g ) Prog=Gamess;;
      -s ) Prog=Gaussian;;
      -o ) Mod=Opt;;
      -sp) Mod=Sp;;
      -r ) Rem=1;;
      -vc ) Vc=1;;
      -t ) Type=$2; shift;;
      -T ) t=$2; shift;;
      -G ) Geom=$2; shift;;
      -Z ) Geom=Z;;
      -b ) inpbasis=$2; shift;;
      -f ) inpfunc=$2; shift;;
      -N ) N=$2; shift;;
      -m ) Mem=$2; shift;;
      --n ) Nproc=$2; shift;;
      -c ) MaxCycles=$2; shift;;
      -s ) MaxStep=$2; shift;;
      -h ) usage; exit 1;;
       * ) usage; exit 1;;
   esac
   shift
done
#exit
#echo "Program=$Prog Type=$Type Inpbasis=$inpbasis Inpfunc=$inpfunc Memory=$Mem Nprocess=$Nproc MaxCycles=$MaxCycles MaxStep=$MaxStep"
if [ $Rem = 1 ]; then
   if [ "$Prog" = "Gamess" ]; then
       rm */*.inp */*.tmp */*~ 
       echo -e " \n Removed Files *.inp\n"
       exit
   elif [ "$Prog" = "Gaussian" ]; then
       rm */*.com */*.tmp */*~
       echo -e " \n Removed Files *.com \n"
       exit
   else
       echo -e "\nProgram $Prog is not found!!!"
       echo -e "Please use -g for Gamess or -s for Gaussian"
       exit
   fi
fi
if [ $Vc = 1 ]; then
   if [ "$Prog" = "Gamess" ]; then
       rm */*.inp */*.tmp */*~ */*.log 
       echo -e " \n Removed Files *.inp *.tmp *~ and *.log\n"
       exit
   elif [ "$Prog" = "Gaussian" ]; then
       rm */*.com */*.tmp */*~ */*.log */*.out */*.chk
       echo -e " \n Removed Files *.com *.tmp *~ and *.log\n"
       exit
   else
       echo -e "\nProgram $Prog is not found!!!"
       echo -e "Please use -g for Gamess or -s for Gaussian"
       exit
   fi
fi

if [ -z "$Prog" ]; then Prog=Gamess;
			echo -e "\n***** WARNING ***** \n Prog is not defined, will used $Prog \n"
fi
if [ $Mod = 0 ]; then Mod=Sp;
		       echo -e "\n***** WARNING ***** \n Calculate is not defined, will used $Mod \n"
fi
if [ $Nproc = 0 ]; then Nproc=4;
			echo -e "\n***** WARNING ***** \n Nproc is not defined, will used $Nproc \n"
fi
if [ $Mem = 0 ]; then Mem=10GB;
		      echo -e "\n***** WARNING ***** \n Memory is not defined, will used $Mem \n"
fi
if [ "$Mod" = "Opt" ]; then
    if [ $MaxCycles = 0 ]; then MaxCycles=50;
				echo -e "\n***** WARNING ***** \n MaxCycles is not defined, will used $MaxCycles \n"
    fi
    if [ $MaxStep = 0 ]; then MaxStep=30;
			      echo -e "\n***** WARNING ***** \n MaxStep is not defined, will used $MaxStep \n"
    fi
fi
if [ $Type = 0 ]; then Type=DFT;
		       echo -e "\n***** WARNING ***** \n Type is not defined, will used $Type\n"
fi
if [ $inpfunc = 0 ]; then inpfunc=functional.txt;
			  echo -e "\n***** WARNING ***** \n File Functional is not defined, will used $inpfunc\n"
fi
if [ $inpbasis = 0 ]; then inpbasis=basiset.txt;
			   echo -e "\n***** WARNING ***** \n File Basis is not defined, will used $inpbasis\n" 
fi
if [ $N = 0 ]; then N=1;
		    echo -e "\n***** WARNING ***** \n Node is not defined, will used $N \n"
fi
if [ $t = 0 ]; then t=infinite;
		    echo -e "\n***** WARNING ***** \n Time of execution is not defined, will used $t \n"
fi
echo -e "**In SCRIPT INPUT (Main)**\nProgram=$Prog Type=$Type Geom=$Geom Model=$Mod Inpbasis=$inpbasis Inpfunc=$inpfunc Memory=$Mem Nprocess=$Nproc MaxCycles=$MaxCycles MaxStep=$MaxStep Node=$N Time=$t\n"
export N
export t
export MaxCycles
export MaxStep
./scriptLEVEL.sh $Prog $Type $inpbasis $inpfunc $Mem $Nproc $Mod $Geom

