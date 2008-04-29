setclock 0 1e-6
create compartment c
setfield c \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813.4375 \
	Rm 8.548598272e9

create tabchannel c/cap
setfield c/cap \
	Ek 0.1470214874 \
	Gbar 1.57921e-08 \
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
	-size 3000 \
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
	-size 3000 \
	-range -0.1 0.05
addmsg c c/cap VOLTAGE Vm
addmsg c/cap c CHANNEL Gk Ek
create tabchannel c/cat
setfield c/cat \
	Ek 0.1470214874 \
	Gbar 1.754672296e-09 \
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
	-size 3000 \
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
	-size 3000 \
	-range -0.1 0.05
addmsg c c/cat VOLTAGE Vm
addmsg c/cat c CHANNEL Gk Ek
create Ca_concen c/p
setfield c/p \
	tau 0.00010 \
	B 9412391936 \
	Ca_base 4e-05 \
	thick 2e-07
addmsg c/cap c/p I_Ca Ik
addmsg c/cat c/p I_Ca Ik
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
		chip[7] \
		chip[8] \
		givals[7] \
		givals[6] \
		chip[4] \
		chip[5] \
		givals[4] \
		givals[3] \
		conc[0] \
		flux[0] \
		results[0] \
		results[1] \
		vm[0]
end

echo {findsolvefield /h c/cap X}
echo {findsolvefield /h c/cap Y}

echo {findsolvefield /h c/cap Ik}
echo {findsolvefield /h c/cap Gk}

echo {findsolvefield /h c/cat X}
echo {findsolvefield /h c/cat Y}

echo {findsolvefield /h c/cat Ik}
echo {findsolvefield /h c/cat Gk}

