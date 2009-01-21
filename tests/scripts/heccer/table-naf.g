setclock 0 2e-5

create neutral hardcoded_neutral
create compartment /hardcoded_neutral/c

setfield /hardcoded_neutral/c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8

create tabchannel /hardcoded_neutral/c/naf


setfield /hardcoded_neutral/c/naf \
	Ek 0.045 \
	Gbar 0.0002092393115 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 3.0 \
	Ypower 1.0 \
	Zpower 0.0 \
	Y_init 0.26397776926502026 \
	X_init 0.007840644937141521



setupalpha /hardcoded_neutral/c/naf \
	X \
	35.0e3 \
	0.0 \
	0.0 \
	0.005 \
	-10.0e-3 \
	7.0e3 \
	0.0 \
	0.0 \
	0.065 \
	20.0e-3 \
	-size 50 \
	-range -0.1 0.05


setupalpha /hardcoded_neutral/c/naf \
	Y \
	0.225e3 \
	0.0 \
	1.0 \
	0.08 \
	10.0e-3 \
	7.5e3 \
	0.0 \
	0.0 \
	-0.003 \
	-18.0e-3 \
	-size 50 \
	-range -0.1 0.05

addmsg /hardcoded_neutral/c /hardcoded_neutral/c/naf VOLTAGE Vm
addmsg /hardcoded_neutral/c/naf /hardcoded_neutral/c CHANNEL Gk Ek



silent 1

reset

set_nsintegrator_verbose_level 2

echo Initiated

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 1

