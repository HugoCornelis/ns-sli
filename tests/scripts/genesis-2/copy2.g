//genesis


create neutral n1

create neutral n2

create compartment /n1/c

le -t

// note that Eleak does not exist in G2, but should really be Em

setfield /n1/c \ 
   Cm 4.57537e-11 \ 
   Rm 3.58441e+08 \ 
   Ra 360502 \ 
   len 1 \ 
   dia 1 \ 
   initVm -0.068 \ 
   Eleak -0.080 


copy /n1/c /n2/o



call model_container NEUROSPACES_QUERY










