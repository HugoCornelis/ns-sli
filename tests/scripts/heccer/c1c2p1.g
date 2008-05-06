setclock 0 2e-5
create neutral hardcoded_neutral
create compartment /hardcoded_neutral/c1
setfield /hardcoded_neutral/c1 \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8

copy /hardcoded_neutral/c1 /hardcoded_neutral/c2

setfield /hardcoded_neutral/c1 \
	inject 1e-8

//t
//t changing the inject of c1 propogates to c2 due to aliasing
//t furture work: implement use parameter caches. 
//t
setfield /hardcoded_neutral/c2 \
	inject 0

addmsg /hardcoded_neutral/c1 /hardcoded_neutral/c2 AXIAL Vm
addmsg /hardcoded_neutral/c2 /hardcoded_neutral/c1 RAXIAL Ra Vm


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


exit





