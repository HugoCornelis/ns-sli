setclock 0 2e-5
create neutral /hardcoded_neutral
create compartment /hardcoded_neutral/c
setfield /hardcoded_neutral/c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.028 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel /hardcoded_neutral/c/cat
setfield /hardcoded_neutral/c/cat \
	Ek 0.1375262439 \
	Gbar 1.394928884e-08 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 1.0 \
	Zpower 0.0
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
	-size 3000 \
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
	-size 3000 \
	-range -0.1 0.05
addmsg /hardcoded_neutral/c /hardcoded_neutral/c/cat VOLTAGE Vm
addmsg /hardcoded_neutral/c/cat /hardcoded_neutral/c CHANNEL Gk Ek
create Ca_concen /hardcoded_neutral/c/p
setfield /hardcoded_neutral/c/p \
	tau 0.00010 \
	B 9412391936 \
	Ca_base 4e-05 \
	thick 2e-07
addmsg /hardcoded_neutral/c/cat /hardcoded_neutral/c/p I_Ca Ik


silent 1

reset

set_nsintegrator_verbose_level 2

echo Initiated

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 1



call model_container NEUROSPACES_QUERY

