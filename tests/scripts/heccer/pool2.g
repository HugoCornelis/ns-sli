setclock 0 1e-6

create neutral hardcoded_neutral
create compartment /hardcoded_neutral/c1
setfield /hardcoded_neutral/c1 \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.028 \
	Ra 360502 \
	Rm 3.58441e8 



create tabchannel /hardcoded_neutral/c1/cat
setfield /hardcoded_neutral/c1/cat \
	Ek 0.1375262439 \
	Gbar 1.394928884e-08 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 1.0 \
	Zpower 0.0


setupalpha /hardcoded_neutral/c1/cat \
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

setupalpha /hardcoded_neutral/c1/cat \
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
addmsg /hardcoded_neutral/c1 /hardcoded_neutral/c1/cat VOLTAGE Vm
addmsg /hardcoded_neutral/c1/cat /hardcoded_neutral/c1 CHANNEL Gk Ek


create Ca_concen /hardcoded_neutral/c1/p
setfield /hardcoded_neutral/c1/p \
	tau 0.00010 \
	B 7.579027046e+10 \
	Ca_base 4e-05 \
	thick 2e-07 \
	concen_init 0.000040



addmsg /hardcoded_neutral/c1/cat /hardcoded_neutral/c1/p I_Ca Ik

create compartment /hardcoded_neutral/c2
setfield /hardcoded_neutral/c2 \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813.4375 \
	Rm 8.548598272e9

create tabchannel /hardcoded_neutral/c2/cat

setfield /hardcoded_neutral/c2/cat \
	Ek 0.1470214874 \
	Gbar 1.754672296e-09 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 1.0 \
	Zpower 0.0 

setupalpha /hardcoded_neutral/c2/cat \
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
setupalpha /hardcoded_neutral/c2/cat \
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
addmsg /hardcoded_neutral/c2 /hardcoded_neutral/c2/cat VOLTAGE Vm
addmsg /hardcoded_neutral/c2/cat /hardcoded_neutral/c2 CHANNEL Gk Ek
create Ca_concen /hardcoded_neutral/c2/p
setfield /hardcoded_neutral/c2/p \
	tau 0.00020 \
	B 9412391936 \
	Ca_base 4e-05 \
	thick 2e-07 \
	concen_init 0.000040

addmsg /hardcoded_neutral/c2/cat /hardcoded_neutral/c2/p I_Ca Ik

addmsg /hardcoded_neutral/c1 /hardcoded_neutral/c2 AXIAL Vm
addmsg /hardcoded_neutral/c2 /hardcoded_neutral/c1 RAXIAL Ra Vm



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

setfield neurospaces_integrator heccer_reporting_granularity 100

echo Initiated

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 0


echo -------
echo Iteration 100

step 100



echo -------
echo Iteration 200

step 100


echo -------
echo Iteration 300

step 100


echo -------
echo Iteration 400

step 100


echo -------
echo Iteration 500

step 100


echo -------
echo Iteration 600

step 100


echo -------
echo Iteration 700

step 100


echo -------
echo Iteration 800

step 100


echo -------
echo Iteration 900

step 100


echo -------
echo Final Iteration

step 99

call neurospaces_integrator NSINTEGRATOR_DUMP



call model_container NEUROSPACES_QUERY

