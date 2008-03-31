//genesis

create neutral hardcoded_neutral

create compartment /hardcoded_neutral/c

le -t

setfield /hardcoded_neutral/c \
   CM  4.57537e-11 \
   Eleak -0.08 \
   initVm  -0.068 \
   RA 360502 \
   RM 3.58441e+08 \
   dia 1 \
   len 1 


reset


step 1000.0 -time

