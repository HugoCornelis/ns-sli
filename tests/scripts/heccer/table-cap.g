setclock 0 2e-5
create compartment c
setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.028 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel c/cap
setfield c/cap \
	Ek 0.1375262439 \
	Gbar 1.394928884e-08 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 1.0 \
	Zpower 0.0
setupalpha c/cap \
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
setupalpha c/cap \
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
addmsg c c/cap VOLTAGE Vm
addmsg c/cap c CHANNEL Gk Ek
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

	showfield c/cap *
end

