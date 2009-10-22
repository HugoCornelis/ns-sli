setclock 0 2e-5

create neutral hardcoded_neutral


create compartment /hardcoded_neutral/c1


// note that Eleak does not exist in G2, but should really be Em

setfield /hardcoded_neutral/c1 \
   Cm 4.57537e-11 \ 
   Rm 3.58441e+08 \ 
   Ra 360502 \ 
   len 1 \ 
   dia 1 \ 
   initVm -0.068 \ 
   Eleak -0.080


copy /hardcoded_neutral/c1 /hardcoded_neutral/c2



addmsg /hardcoded_neutral/c1 /hardcoded_neutral/c2 AXIAL Vm



addmsg /hardcoded_neutral/c2 /hardcoded_neutral/c1 RAXIAL Ra Vm



call model_container NEUROSPACES_QUERY




