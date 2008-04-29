// channel parameters changed, slightly more 'realistic', but better
// never to use them in a real model.

setclock 0 1e-6
create compartment c
setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.065 \
	Ra 360502 \
	Rm 3.58441e8 \
	inject 2e-9
create tabchannel c/naf
setfield c/naf \
	Ek 0.045 \
	Gbar 0.00001 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 3.0 \
	Ypower 1.0 \
	Zpower 0.0
setupalpha c/naf \
	Y \
	0.225e3 \
	0.0 \
	1.0 \
	0.08 \
	10.0e-3 \
	7.5e3 \
	0.0 \
	0.0 \
	-0.003 \
	-18.0e-3 \
	-size 3000 \
	-range -0.1 0.05
setupalpha c/naf \
	X \
	35.0e3 \
	0.0 \
	0.0 \
	0.005 \
	-10.0e-3 \
	7.0e3 \
	0.0 \
	0.0 \
	0.065 \
	20.0e-3 \
	-size 3000 \
	-range -0.1 0.05
addmsg c c/naf VOLTAGE Vm
addmsg c/naf c CHANNEL Gk Ek

create tabchannel c/kdr

setfield c/kdr \
	Ek -0.085 \
	Gbar {360.0 * 2.78985994009388e-09} \
	Ik 0 \
	Gk 0 \
	Xpower 4 \
	Ypower 0 \
	Zpower 0
setupalpha c/kdr \
	X \
	{10e3 * (0.01 + -0.065)} \
	-10.0e3 \
        -1.0 \
	{-1.0 * (0.01 + -0.065)} \
	-0.01 \
	125.0 \
	0.0 \
	0.0 \
        {-1.0 * -0.065} \
	80.0e-3 \
	-size 3000 \
	-range -0.1 0.05


// create tabchannel c/kdr
// setfield c/kdr \
// 	Ek -0.085 \
// 	Gbar 1e-05 \
// 	Ik 0.0 \
// 	Gk 0.0 \
// 	Xpower 2.0 \
// 	Ypower 1.0 \
// 	Zpower 0.0

// float x
// float dx
// int i
// float a
// float b
// float y
// float tab_xmin = -0.10; float tab_xmax = 0.05
// int tab_xdivs = 150; int tab_xfills = 2999
// 	    float VKTAU_OFFSET = 0.000
// 	    float VKMINF_OFFSET = 0.020

// 	    call c/kdr TABCREATE X {tab_xdivs} {tab_xmin}  \
// 		{tab_xmax}
// 	    x = {tab_xmin}
// 	    dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

// 	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
// 		    a = -23.5e3*(x + 0.012 - VKTAU_OFFSET)/({exp {(x + 0.012 - VKTAU_OFFSET)/-0.012}} - 1.0)
// 		    b = 5.0e3*{exp {-(x + 0.147 - VKTAU_OFFSET)/0.030}}

// // echo {i} {a} {b}

// 		    setfield c/kdr X_A->table[{i}] {1.0/(a + b)}

// 		    a = -23.5e3*(x + 0.012 - VKMINF_OFFSET)/({exp {(x + 0.012 - VKMINF_OFFSET)/-0.012}} - 1.0)
// 		    b = 5.0e3*{exp {-(x + 0.147 - VKMINF_OFFSET)/0.030}}
// 		    setfield c/kdr X_B->table[{i}] {a/(a + b)}
// 		    x = x + dx
// 	    end
// 	    tweaktau c/kdr X
// 	    setfield c/kdr X_A->calc_mode 0 X_B->calc_mode 0
// 	    call c/kdr TABFILL X {tab_xfills + 1} 0


// 	    call c/kdr TABCREATE Y {tab_xdivs} {tab_xmin}  \
// 		{tab_xmax}
// 	    x = {tab_xmin}

// 	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
// 		    if (x < -0.025)
// 			    setfield c/kdr Y_A->table[{i}] 1.2
// 		    else
// 			    setfield c/kdr Y_A->table[{i}] 0.010
// 		    end

// 		    y = 1.0 + {exp {(x + 0.025)/0.004}}
// 		    setfield c/kdr Y_B->table[{i}] {1.0/y}
// 		    x = x + dx
// 	    end
// 	    tweaktau c/kdr Y
// 	    setfield c/kdr Y_A->calc_mode 0 Y_B->calc_mode 0
// 	    call c/kdr TABFILL Y {tab_xfills + 1} 0

addmsg c c/kdr VOLTAGE Vm
addmsg c/kdr c CHANNEL Gk Ek

create hsolve h
setmethod h 11
setfield h \
	calcmode 0 \
	chanmode 4 \
	path /c
call h SETUP
reset

function plot

	create xform /form
	create xgraph /form/graph
	addmsg /h /form/graph PLOT vm[0] *voltage *red
	xshow /form
end

function showfields

	showfield h \
		chip[4] \
		chip[7] \
		chip[8] \
		givals[3] \
		givals[4] \
		givals[7] \
		givals[8] \
		results[0] \
		results[1] \
		vm[0]
end

plot

reset

step 10000

