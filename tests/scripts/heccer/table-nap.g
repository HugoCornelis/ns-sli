setclock 0 2e-5

create neutral hardcoded_neutral
create compartment /hardcoded_neutral/c

setfield /hardcoded_neutral/c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8


create tabchannel /hardcoded_neutral/c/nap


setfield /hardcoded_neutral/c/nap \
	Ek 0.045 \
	Gbar 2.78986e-08 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 3.0 \
	Ypower 0.0 \
	Zpower 0.0
//     /* Persistent Na current, eq#2b */
//     make_chan Purk_NaP {ENa} {GNa} 3 200.0e3 0.0 1.0 -0.018 -16.0e-3  \
//         25.00e3 0.0 1.0 0.058 8.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0  \
//         0.0 0.0 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0


setupalpha /hardcoded_neutral/c/nap \
	X \
	200.0e3 \
	0.0 \
	1.0 \
	-0.018 \
	-16.0e-3 \
	25.00e3 \
	0.0 \
	1.0 \
	0.058 \
	8.0e-3 \
	-size 50 \
	-range -0.1 0.05


addmsg /hardcoded_neutral/c /hardcoded_neutral/c/nap VOLTAGE Vm
addmsg /hardcoded_neutral/c/nap /hardcoded_neutral/c CHANNEL Gk Ek



silent 1

reset

set_nsintegrator_verbose_level 2

echo Initiated

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 1


//call model_container NEUROSPACES_QUERY

