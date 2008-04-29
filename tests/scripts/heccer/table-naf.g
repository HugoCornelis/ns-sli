setclock 0 2e-5
create compartment c
setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel c/naf
setfield c/naf \
	Ek 0.045 \
	Gbar 0.0002092393115 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 3.0 \
	Ypower 1.0 \
	Zpower 0.0
setupalpha c/naf \
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
setupalpha c/naf \
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
addmsg c c/naf VOLTAGE Vm
addmsg c/naf c CHANNEL Gk Ek
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

	showfield c/naf *
end

