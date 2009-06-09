setclock 0 2e-5

create neutral hardcoded_neutral 

create compartment /hardcoded_neutral/c


setfield /hardcoded_neutral/c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8 \
	dia 2.98e-5 \
	len 0.0

create tabchannel /hardcoded_neutral/c/ka


setfield /hardcoded_neutral/c/ka \
	Ek -0.085 \
	Gbar 4.184786349e-07 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 4.0 \
	Ypower 1.0 \
	Zpower 0.0 \
	Y_init 0.7474853827 \
	X_init 0.08371356085


setupalpha /hardcoded_neutral/c/ka \
	X \
	1.40e3 \
	0.0 \
	1.0 \
	0.027 \
	-12.0e-3 \
	0.490e3 \
        0.0 \
	1.0 \
	0.030 \
	4.0e-3 \
	-size 50 \
	-range -0.1 0.05


setupalpha /hardcoded_neutral/c/ka \
	Y \
	0.0175e3 \
	0.0 \
	1.0 \
	0.050 \
	8.0e-3 \
	1.30e3 \
	0.0 \
        1.0 \
	0.013 \
	-10.0e-3 \
	-size 50 \
	-range -0.1 0.05


addmsg /hardcoded_neutral/c /hardcoded_neutral/c/ka VOLTAGE Vm
addmsg /hardcoded_neutral/c/ka /hardcoded_neutral/c CHANNEL Gk Ek


reset

// call neurospaces_integrator NSINTEGRATOR_DUMP

call model_container NEUROSPACES_QUERY

