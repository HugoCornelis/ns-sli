setclock 0 1e-6

create neutral hardcoded_neutral

create compartment /hardcoded_neutral/c

setfield /hardcoded_neutral/c \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813.4375 \
	Rm 8.548598272e9

// create tabchannel c/cap
// setfield /hardcoded_neutral/c/cap \
// 	Ek 0.1470214874 \
// 	Gbar 1.57921e-08 \
// 	Ik 0.0 \
// 	Gk 0.0 \
// 	Xpower 1.0 \
// 	Ypower 1.0 \
// 	Zpower 0.0
// setupalpha c/cap \
// 	X \
// 	8.50e3 \
// 	0.0 \
// 	1.0 \
// 	-0.0080 \
// 	-12.5e-3 \
// 	35.0e3 \
// 	0.0 \
// 	1.0 \
// 	0.074 \
// 	14.5e-3 \
// 	-size 3000 \
// 	-range -0.1 0.05
// setupalpha c/cap \
// 	Y \
// 	0.0015e3 \
// 	0.0 \
// 	1.0 \
// 	0.029 \
// 	8.0e-3 \
// 	0.0055e3 \
// 	0.0 \
// 	1.0 \
// 	0.023 \
// 	-8.0e-3 \
// 	-size 3000 \
// 	-range -0.1 0.05
// addmsg c c/cap VOLTAGE Vm
// addmsg c/cap c CHANNEL Gk Ek
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
	B 9412391936 \
	Ca_base 4e-05 \
	thick 2e-07
// addmsg c/cap c/p I_Ca Ik
addmsg /hardcoded_neutral/c/cat /hardcoded_neutral/c/p I_Ca Ik

float CCaO = 2.4000 		//external Ca as in normal slice Ringer
float CCaI = 0.000040		//internal Ca in mM
create nernst /hardcoded_neutral/c/n
setfield /hardcoded_neutral/c/n Cin {CCaI} Cout {CCaO} valency {2} \
     scale {1.0} T {37}
addmsg /hardcoded_neutral/c/p /hardcoded_neutral/c/n CIN Ca
