setclock 0 1e-6
create compartment c1
setfield c1 \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.028 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel c1/cat
setfield c1/cat \
	Ek 0.1375262439 \
	Gbar 1.394928884e-08 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 1.0 \
	Zpower 0.0
setupalpha c1/cat \
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
setupalpha c1/cat \
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
addmsg c1 c1/cat VOLTAGE Vm
addmsg c1/cat c1 CHANNEL Gk Ek
create Ca_concen c1/p
setfield c1/p \
	tau 0.00020 \
	B 9412391936 \
	Ca_base 4e-05 \
	thick 2e-07
addmsg c1/cat c1/p I_Ca Ik

create compartment c2
setfield c2 \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813.4375 \
	Rm 8.548598272e9
create tabchannel c2/cat
setfield c2/cat \
	Ek 0.1470214874 \
	Gbar 1.754672296e-09 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 1.0 \
	Zpower 0.0
setupalpha c2/cat \
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
setupalpha c2/cat \
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
addmsg c2 c2/cat VOLTAGE Vm
addmsg c2/cat c2 CHANNEL Gk Ek
create Ca_concen c2/p
setfield c2/p \
	tau 0.00010 \
	B 7.579027046e+10 \
	Ca_base 4e-05 \
	thick 2e-07
addmsg c2/cat c2/p I_Ca Ik

addmsg c1 c2 AXIAL Vm
addmsg c2 c1 RAXIAL Ra Vm

create hsolve h
setmethod h 11
setfield h \
	calcmode 0 \
	chanmode 4 \
	path /c1,/c2
call h SETUP
reset

function showfields

	showfield h \
		vm[1] \
		chip[12] \
		chip[13] \
		givals[9] \
		conc[1] \
		vm[0] \
		chip[4] \
		chip[5] \
		givals[3] \
		conc[0]
end

echo {findsolvefield /h c1 Vm}
echo {findsolvefield /h c1/cat X}
echo {findsolvefield /h c1/cat Y}
echo {findsolvefield /h c1/cat Gk}
echo {findsolvefield /h c1/p Ca}

echo {findsolvefield /h c2 Vm}
echo {findsolvefield /h c2/cat X}
echo {findsolvefield /h c2/cat Y}
echo {findsolvefield /h c2/cat Gk}
echo {findsolvefield /h c2/p Ca}

