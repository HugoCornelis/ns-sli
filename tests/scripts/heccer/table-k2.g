setclock 0 1e-6
create compartment c2
setfield c2 \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.068 \
	Ra 772813.4375 \
	Rm 8.548598272e9

create tabchannel c2/k2
setfield c2/k2 \
	Ek 85 \
	Gbar 2.80747571e-07 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 0.0 \
	Zpower 2.0
//     make_chan Purk_K2 {EK} {GK} 1 25.0e3 0.0 0.0 0.0 1.0e12 0.075e3 0.0  \
//         0.0 0.025 6.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0 0.0 \
//          0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
setupalpha c2/k2 \
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
setupalpha c2/k2 \
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
    call c2/k2 TABCREATE Z {cdivs} {cmin} {cmax}
    int i
    for (i = 0; i <= (cdivs); i = i + 1)
	    float zinf = 1/(1 + (0.2e-3/c))
	    setfield c2/k2 Z_A->table[{i}] {zinf/ztau}
	    setfield c2/k2 Z_B->table[{i}] {1/ztau}
	    c = c + dc
    end
    setfield c2/k2 Zpower 2
    setfield c2/k2 Z_A->calc_mode 0
    setfield c2/k2 Z_B->calc_mode 0

addmsg c2 c2/k2 VOLTAGE Vm
addmsg c2/k2 c2 CHANNEL Gk Ek

reset

function showfields

	showfield c2 Vm
	showfield c2/k2 X
	showfield c2/k2 Z
	showfield c2/k2 Gk
end

function showtables

	showfield c2/k2 *
end

