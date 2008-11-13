setclock 0 1e-11

create neutral hardcoded_neutral
create compartment /hardcoded_neutral/c
setfield /hardcoded_neutral/c \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813.4375 \
	Rm 8.548598272e9 \
	inject 1e-9

create tabchannel /hardcoded_neutral/c/cat

setfield /hardcoded_neutral/c/cat \
	Ek 0.1470214874 \
	Gbar 1.754672296e-09 \
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
	B 7.579027046e+10 \
	Ca_base 4e-05 \
	thick 2e-07 \
	concen_init 0.000040

//old B val 9412391936

addmsg /hardcoded_neutral/c/cat /hardcoded_neutral/c/p I_Ca Ik

float CCaO = 2.4000 		//external Ca as in normal slice Ringer
float CCaI = 0.000040		//internal Ca in mM

create nernst /hardcoded_neutral/c/n

setfield /hardcoded_neutral/c/n Cin {CCaI} Cout {CCaO} valency {2} \
     scale {1.0} T {37}

addmsg /hardcoded_neutral/c/p /hardcoded_neutral/c/n CIN Ca

addmsg /hardcoded_neutral/c/n /hardcoded_neutral/c/cat EK E






silent 1

reset

set_nsintegrator_verbose_level 2


setfield neurospaces_integrator heccer_dump_selection { HECCER_DUMP_VM_COMPARTMENT_MATRIX + \
				    			HECCER_DUMP_VM_COMPARTMENT_DATA + \
				     			HECCER_DUMP_VM_COMPARTMENT_OPERATIONS + \
				     			HECCER_DUMP_VM_CHANNEL_POOL_FLUXES + \
				     			HECCER_DUMP_VM_MECHANISM_DATA + \
				     			HECCER_DUMP_VM_MECHANISM_OPERATIONS + \
				     			HECCER_DUMP_VM_SUMMARY }

setfield neurospaces_integrator heccer_reporting_granularity 100000

echo Initiated

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 0


echo -------
echo Iteration 100000

step 100000



echo -------
echo Iteration 200000

step 100000


echo -------
echo Iteration 300000

step 100000


echo -------
echo Iteration 400000

step 100000


echo -------
echo Iteration 500000

step 100000


echo -------
echo Iteration 600000

step 100000


echo -------
echo Iteration 700000

step 100000


echo -------
echo Iteration 800000

step 100000


echo -------
echo Iteration 900000

step 100000


echo -------
echo Final Iteration

step 99999

call neurospaces_integrator NSINTEGRATOR_DUMP



call model_container NEUROSPACES_QUERY

