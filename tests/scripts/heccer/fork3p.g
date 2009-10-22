setclock 0 2e-5

create neutral /hardcoded_neutral
create compartment /hardcoded_neutral/c1

// note that Eleak does not exist in G2, but should really be Em

setfield /hardcoded_neutral/c1 \
	Cm 4.57537e-11 \
	Eleak -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8

copy /hardcoded_neutral/c1 /hardcoded_neutral/c2
copy /hardcoded_neutral/c2 /hardcoded_neutral/c3

addmsg /hardcoded_neutral/c1 /hardcoded_neutral/c2 AXIAL Vm
addmsg /hardcoded_neutral/c2 /hardcoded_neutral/c1 RAXIAL Ra Vm

addmsg /hardcoded_neutral/c1 /hardcoded_neutral/c3 AXIAL Vm
addmsg /hardcoded_neutral/c3 /hardcoded_neutral/c1 RAXIAL Ra Vm


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