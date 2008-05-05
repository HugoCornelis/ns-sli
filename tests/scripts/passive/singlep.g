//genesis


create neutral /hardcoded_neutral

create compartment /hardcoded_neutral/c

le -t

setfield /hardcoded_neutral/c \ 
   Cm 4.57537e-11 \ 
   Rm 3.58441e+08 \ 
   Ra 360502 \ 
   len 1 \ 
   dia 1 \ 
   initVm -0.068 \ 
   Eleak -0.080 

setclock 0 2e-5

silent 1

reset

set_nsintegrator_verbose_level 2

echo Initiated

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 1

echo -------
echo Iteration 1

step 1

echo -------
echo Iteration 2

step 1

echo -------
echo Iteration 3

step 1

echo -------
echo Iteration 4

step 1

echo -------
echo Iteration 5

step 1

echo -------
echo Iteration 6

step 1

echo -------
echo Iteration 7

step 1

echo -------
echo Iteration 8

step 1

echo -------
echo Iteration 9

step 1

// showfield c Vm

// step 10

// showfield c Vm

// step 10

// showfield c Vm

// step 10

// showfield c Vm

// step 10

// showfield c Vm


