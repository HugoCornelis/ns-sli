setclock 0 2e-5
create compartment c
setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel c/ka
setfield c/ka \
	Ek -0.085 \
	Gbar 4.184786349e-07 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 4.0 \
	Ypower 1.0 \
	Zpower 0.0
setupalpha c/ka \
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
setupalpha c/ka \
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
addmsg c c/ka VOLTAGE Vm
addmsg c/ka c CHANNEL Gk Ek
create hsolve h
setmethod h 11
setfield h \
	calcmode 0 \
	chanmode 4 \
	path /c
call h SETUP
reset

function showfields

	showfield h \
		chip[4] \
		chip[5] \
		givals[3] \
		givals[4] \
		results[0] \
		results[1] \
		vm[0]
end

function showtables

	showfield c/ka *
end

