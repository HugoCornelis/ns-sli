//genesis


create neutral hardcoded_neutral

create compartment /hardcoded_neutral/c

le -t

setfield /hardcoded_neutral/c \ 
   Cm 4.57537e-11 \ 
   Rm 3.58441e+08 \ 
   Ra 360502 \ 
   len 1 \ 
   dia 1 \ 
   initVm -0.068 \ 
   Em -0.080 

create neutral /m

createmap /hardcoded_neutral/c /m 2 3


