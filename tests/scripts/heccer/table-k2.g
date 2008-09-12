setclock 0 1e-6

create compartment hardcoded_neutral

create compartment /hardcoded_neutral/c2

setfield /hardcoded_neutral/c2 \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813.4375 \
	Rm 8.548598272e9

create tabchannel /hardcoded_neutral/c2/k2

setfield /hardcoded_neutral/c2/k2 \
	Ek 85 \
	Gbar 2.80747571e-07 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 0.0 \
	Zpower 2.0 \
	X_init 0.063531859768213905 \
	Z_init 0.0099009900989999993




//     make_chan Purk_K2 {EK} {GK} 1 25.0e3 0.0 0.0 0.0 1.0e12 0.075e3 0.0  \
//         0.0 0.025 6.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0 0.0 \
//          0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
setupalpha /hardcoded_neutral/c2/k2 \
	X \
	25.0e3 \
	0.0 \
	0.0 \
	0.0 \
	1.0e12 \
	0.075e3 \
	0.0 \
	0.0 \
	0.025 \
	6.0e-3 \
	-size 50 \
	-range -0.1 0.05
setupalpha /hardcoded_neutral/c2/k2 \
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
	-size 50 \
	-range 0.00004 0.3
// 	-range -0.1 0.05

float CCaI = 0.000040
float Ca_tab_max = 0.300
int tab_xfills = 49
    float cmin = ({CCaI}) // will create a z-range from 0.0021 to 0.9727
    float cmax = ({Ca_tab_max})
    float cdivs = tab_xfills+1
    float c = cmin
    float dc = cdivs
    float dc = (cmax - cmin)/cdivs
    float ztau = 0.010
    call /hardcoded_neutral/c2/k2 TABCREATE Z {cdivs} {cmin} {cmax}
    int i
    for (i = 0; i <= (cdivs); i = i + 1)
	    float zinf = 1/(1 + (0.2e-3/c))
	    setfield /hardcoded_neutral/c2/k2 Z_A->table[{i}] {zinf/ztau}
	    setfield /hardcoded_neutral/c2/k2 Z_B->table[{i}] {1/ztau}
	    c = c + dc
    end
    setfield /hardcoded_neutral/c2/k2 Zpower 2
    setfield /hardcoded_neutral/c2/k2 Z_A->calc_mode 0
    setfield /hardcoded_neutral/c2/k2 Z_B->calc_mode 0

addmsg /hardcoded_neutral/c2 /hardcoded_neutral/c2/k2 VOLTAGE Vm
addmsg /hardcoded_neutral/c2/k2 /hardcoded_neutral/c2 CHANNEL Gk Ek






silent 1

reset

set_nsintegrator_verbose_level 2

echo Initiated

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 1
