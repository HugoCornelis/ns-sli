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
	B 9412391936 \
	Ca_base 4e-05 \
	thick 2e-07

addmsg /hardcoded_neutral/c/cat /hardcoded_neutral/c/p I_Ca Ik

float CCaO = 2.4000 		//external Ca as in normal slice Ringer
float CCaI = 0.000040		//internal Ca in mM

create nernst /hardcoded_neutral/c/n

setfield /hardcoded_neutral/c/n Cin {CCaI} Cout {CCaO} valency {2} \
     scale {1.0} T {37}

addmsg /hardcoded_neutral/c/p /hardcoded_neutral/c/n CIN Ca

addmsg /hardcoded_neutral/c/n /hardcoded_neutral/c/cat EK E


reset

function showfields

	showfield h \
		chip[4] \
		chip[5] \
		givals[5] \
		givals[4] \
		givals[3] \
		conc[0] \
		flux[0] \
		results[0] \
		results[1] \
		vm[0]

// 	showfield c/cap X
// 	showfield c/cap Y
// 	showfield c/cap Ek

// 	showfield c/cap Ik
// 	showfield c/cap Gk

// 	showfield c/cat X Y Ek

// 	showfield c/cat Ik Gk

// 	showfield c/n Cin E

// 	showfield c Vm
end

// echo {findsolvefield /h c/cap X}
// echo {findsolvefield /h c/cap Y}
// echo {findsolvefield /h c/cap Ek}

// echo {findsolvefield /h c/cap Ik}
// echo {findsolvefield /h c/cap Gk}

echo {findsolvefield /h c/cat X}
echo {findsolvefield /h c/cat Y}

echo {findsolvefield /h c/cat Ik}
echo {findsolvefield /h c/cat Gk}
echo {findsolvefield /h c/cat Ek}

echo {findsolvefield /h c Vm}
