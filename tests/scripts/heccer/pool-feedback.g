setclock 0 1e-6
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

create tabchannel c2/kc
setfield c2/kc \
	Ek 85 \
	Gbar 2.80747571e-07 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 0.0 \
	Zpower 2.0
// 1 7.5e3 0.0 0.0 0.0 1.0e12 0.110e3 0.0  \
//         0.0 -0.035 14.9e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 2  \
//         0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
setupalpha c2/kc \
	X \
	7.5e3 \
	0.0 \
	0.0 \
	0.0 \
	1e12 \
	0.11e3 \
	0.0 \
	0.0 \
	-0.035 \
	14.9e-3 \
	-size 3000 \
	-range -0.1 0.05
setupalpha c2/kc \
	Z \
	0 \
	0 \
	0 \
	0 \
	0 \
	0 \
	0 \
	0 \
	0 \
	0 \
	-size 3000 \
	-range 0.00004 0.3
// 	-range -0.1 0.05

float CCaI = 0.000040
float Ca_tab_max = 0.300
int tab_xfills = 2999
    float cmin = ({CCaI}) // will create a z-range from 0.0021 to 0.9727
    float cmax = ({Ca_tab_max})
    float cdivs = tab_xfills+1
    float c = cmin
    float dc = cdivs
    dc = (cmax - cmin)/cdivs
    int i
    float ztau = 0.010
    call c2/kc TABCREATE Z {cdivs} {cmin} {cmax}
    for (i = 0; i <= (cdivs); i = i + 1)
	    float zinf = 1/(1 + (4.0e-3/c))
	    setfield c2/kc Z_A->table[{i}] {zinf/ztau}
	    setfield c2/kc Z_B->table[{i}] {1/ztau}
	    c = c + dc
    end
    setfield c2/kc Zpower 2
    setfield c2/kc Z_A->calc_mode 0
    setfield c2/kc Z_B->calc_mode 0

addmsg c2/p c2/kc CONCEN Ca

addmsg c2 c2/kc VOLTAGE Vm
addmsg c2/kc c2 CHANNEL Gk Ek

create hsolve h
setmethod h 11
setfield h \
	calcmode 0 \
	chanmode 4 \
	path /c2
call h SETUP
reset

function showfields

	showfield h \
		{findsolvefield /h c2 Vm} \
		{findsolvefield /h c2/p Ca} \
		{findsolvefield /h c2/kc X} \
		{findsolvefield /h c2/kc Z} \
		{findsolvefield /h c2/cat X} \
		{findsolvefield /h c2/cat Y} \
		{findsolvefield /h c2/kc Gk} \
		{findsolvefield /h c2/cat Gk}
end

echo {findsolvefield /h c2 Vm}
echo {findsolvefield /h c2/p Ca}
echo {findsolvefield /h c2/kc X}
echo {findsolvefield /h c2/kc Z}
echo {findsolvefield /h c2/cat X}
echo {findsolvefield /h c2/cat Y}
echo {findsolvefield /h c2/kc Gk}
echo {findsolvefield /h c2/cat Gk}

