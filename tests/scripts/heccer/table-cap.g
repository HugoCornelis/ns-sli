setclock 0 2e-5

create neutral hardcoded_neutral

create compartment /hardcoded_neutral/c

setfield /hardcoded_neutral/c \
	Cm 5.75533e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813 \
	Rm 8.5486e+09



create tabchannel /hardcoded_neutral/c/cap

//	Ek 0.1375262439 \
//	Gbar 1.394928884e-08 \

setfield /hardcoded_neutral/c/cap \
	Ek 0.147021  \
	Gbar 1.57921e-08 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 1.0 \
	Zpower 0.0 \
	X_init 0.001391094927 \
	Y_init 0.9868968318


setupalpha /hardcoded_neutral/c/cap \
	X \
	8.50e3 \
	0.0 \
	1.0 \
	-0.0080 \
	-12.5e-3 \
	35.0e3 \
	0.0 \
	1.0 \
	0.074 \
	14.5e-3 \
	-size 50 \
	-range -0.1 0.05


setupalpha /hardcoded_neutral/c/cap \
	Y \
	0.0015e3 \
	0.0 \
	1.0 \
	0.029 \
	8.0e-3 \
	0.0055e3 \
	0.0 \
	1.0 \
	0.023 \
	-8.0e-3 \
	-size 50 \
	-range -0.1 0.05


addmsg /hardcoded_neutral/c c/cap VOLTAGE Vm
addmsg /hardcoded_neutral/c/cap c CHANNEL Gk Ek





silent 1

reset

set_nsintegrator_verbose_level 2

echo Initiated

setfield /neurospaces_integrator heccer_dump_selection { HECCER_DUMP_ALL_EXTENDED }

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 1
