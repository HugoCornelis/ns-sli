setclock 0 2e-5
create compartment c
setfield c \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813.4375 \
	Rm 8.548598272e9
create tabchannel c/cat
setfield c/cat \
	Ek 0.14702148735523224 \
	Gbar 1.7546722963501793e-09 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 1.0 \
	Zpower 0.0
setupalpha c/cat \
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
setupalpha c/cat \
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
addmsg c c/cat VOLTAGE Vm
addmsg c/cat c CHANNEL Gk Ek
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

	showfield c/cat *
end

