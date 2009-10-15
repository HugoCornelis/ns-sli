//genesis


create neutral n

create compartment /n/c

le -t

setfield /n/c \ 
   Cm 4.57537e-11 \ 
   Rm 3.58441e+08 \ 
   Ra 360502 \ 
   len 1 \ 
   dia 1 \ 
   initVm -0.068 \ 
   Eleak -0.080 


echo "Checking each field one at a time and printing out all parameter info."

showfield /n/c Cm -all


showfield /n/c Rm -all


showfield /n/c Ra -all


showfield /n/c len -all


showfield /n/c dia -all


showfield /n/c initVm -all


showfield /n/c Eleak -all













