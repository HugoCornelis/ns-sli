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


echo "Echoing each field via getfield"

echo {getfield /n/c Cm}


echo {getfield /n/c Rm}


echo {getfield /n/c Ra}


echo {getfield /n/c len}


echo {getfield /n/c dia}


echo {getfield /n/c initVm}


echo {getfield /n/c Eleak}














