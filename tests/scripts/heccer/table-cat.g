setclock 0 2e-5

create neutral hardcoded_neutral 

create compartment /hardcoded_neutral/c

setfield /hardcoded_neutral/c \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813.4375 \
	Rm 8.548598272e9

create tabchannel /hardcoded_neutral/c/cat


setfield /hardcoded_neutral/c/cat \
	Ek 0.14702148735523224 \
	Gbar 1.7546722963501793e-09 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 1.0 \
	Zpower 0.0 \
	Y_init 0.082602128127539254 \
	X_init 0.038918706451336625


setupalpha /hardcoded_neutral/c/cat \
	X \
	2.6e3 \
	0.0 \
	1.0 \
	0.021 \
	-8e-3 \
	0.18e3 \
	0.0 \
	1.0 \
	0.04 \
	4e-3 \
	-size 50 \
	-range -0.1 0.05


setupalpha /hardcoded_neutral/c/cat \
	Y \
	0.0025e3 \
	0.0 \
	1.0 \
	0.04 \
	8e-3 \
	0.19e3 \
	0.0 \
	1.0 \
	0.05 \
	-10.0e-3 \
	-size 50 \
	-range -0.1 0.05

addmsg /hardcoded_neutral/c /hardcoded_neutral/c VOLTAGE Vm
addmsg /hardcoded_neutral/c/cat /hardcoded_neutral/c CHANNEL Gk Ek



silent 1

reset

set_nsintegrator_verbose_level 2

echo Initiated

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 1




