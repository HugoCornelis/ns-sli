//genesis


create neutral n

create compartment /n/c

le -t

// note that Eleak does not exist in G2, but should really be Em

setfield /n/c \ 
   Cm 4.57537e-11 \ 
   Rm 3.58441e+08 \ 
   Ra 360502 \ 
   len 1 \ 
   dia 1 \ 
   initVm -0.068 \ 
   Eleak -0.080 


echo "Checking each field one at a time"

showfield /n/c Cm


showfield /n/c Rm


showfield /n/c Ra


showfield /n/c len


showfield /n/c dia


showfield /n/c initVm


showfield /n/c Eleak













