setclock 0 1e-6

create neutral hardcoded_neutral

create compartment /hardcoded_neutral/c2

setfield /hardcoded_neutral/c2 \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813.4375 \
	Rm 8.548598272e9

create tabchannel /hardcoded_neutral/c2/kc


setfield /hardcoded_neutral/c2/kc \
	Ek 85 \
	Gbar 2.80747571e-07 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 0.0 \
	Zpower 2.0 \
	X_init 0.063531859768213905 \
	Z_init 0.0099009900989999993
// 1 7.5e3 0.0 0.0 0.0 1.0e12 0.110e3 0.0  \
//         0.0 -0.035 14.9e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 2  \
//         0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0


setupalpha /hardcoded_neutral/c2/kc \
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
	-size 50 \
	-range -0.1 0.05


setupalpha /hardcoded_neutral/c2/kc \
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
    dc = (cmax - cmin)/cdivs
    int i
    float ztau = 0.010
    call /hardcoded_neutral/c2/kc TABCREATE Z {cdivs} {cmin} {cmax}


    for (i = 0; i <= (cdivs); i = i + 1)
	    float zinf = 1/(1 + (4.0e-3/c))
	    setfield /hardcoded_neutral/c2/kc Z_A->table[{i}] {zinf/ztau}
	    setfield /hardcoded_neutral/c2/kc Z_B->table[{i}] {1/ztau}
	    c = c + dc
    end
 
    setfield /hardcoded_neutral/c2/kc Z_A->calc_mode 0
    setfield /hardcoded_neutral/c2/kc Z_B->calc_mode 0

addmsg /hardcoded_neutral/c2 /hardcoded_neutral/c2/kc VOLTAGE Vm
addmsg /hardcoded_neutral/c2/kc /hardcoded_neutral/c2 CHANNEL Gk Ek




silent 1

reset

//set_nsintegrator_verbose_level 2

//echo Initiated

//call neurospaces_integrator NSINTEGRATOR_DUMP

//echo -------
//echo Iteration 0

//step 1



call model_container NEUROSPACES_QUERY

