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



echo "Testing wildcard: display extended listing of objects"

showfield /n/c **















