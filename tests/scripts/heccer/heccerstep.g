//genesis

create neutral hardcoded_neutral

create compartment /hardcoded_neutral/c

le -t

// note that Eleak does not exist in G2, but should really be Em

setfield /hardcoded_neutral/c \
   Cm  4.57537e-11 \
   Eleak -0.08 \
   initVm  -0.068 \
   Ra 360502 \
   Rm 3.58441e+08 \
   dia 1 \
   len 1 


reset


step 1000.0 -time

