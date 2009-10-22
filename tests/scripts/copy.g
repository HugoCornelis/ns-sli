//genesis


create neutral hardcoded_neutral

create compartment /hardcoded_neutral/c

le -t

// note that Eleak does not exist in G2, but should really be Em

setfield /hardcoded_neutral/c \ 
   Cm 4.57537e-11 \ 
   Rm 3.58441e+08 \ 
   Ra 360502 \ 
   len 1 \ 
   dia 1 \ 
   initVm -0.068 \ 
   Eleak -0.080 


copy /hardcoded_neutral/c /hardcoded_neutral/o



call model_container NEUROSPACES_QUERY










