setclock 0 2e-5
create compartment c
setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel c/kdr
setfield c/kdr \
	Ek -0.085 \
	Gbar 1.67391463e-05 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 2.0 \
	Ypower 1.0 \
	Zpower 0.0

float x
float dx
int i
float a
float b
float y
float tab_xmin = -0.10; float tab_xmax = 0.05
int tab_xdivs = 20; int tab_xfills = 50
	    float VKTAU_OFFSET = 0.000
	    float VKMINF_OFFSET = 0.020

	    call c/kdr TABCREATE X {tab_xdivs} {tab_xmin}  \
		{tab_xmax}
	    x = {tab_xmin}
	    dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    a = -23.5e3*(x + 0.012 - VKTAU_OFFSET)/({exp {(x + 0.012 - VKTAU_OFFSET)/-0.012}} - 1.0)
		    b = 5.0e3*{exp {-(x + 0.147 - VKTAU_OFFSET)/0.030}}

// echo {i} {a} {b}

		    setfield c/kdr X_A->table[{i}] {1.0/(a + b)}

		    a = -23.5e3*(x + 0.012 - VKMINF_OFFSET)/({exp {(x + 0.012 - VKMINF_OFFSET)/-0.012}} - 1.0)
		    b = 5.0e3*{exp {-(x + 0.147 - VKMINF_OFFSET)/0.030}}
		    setfield c/kdr X_B->table[{i}] {a/(a + b)}
		    x = x + dx
	    end
	    tweaktau c/kdr X
	    setfield c/kdr X_A->calc_mode 0 X_B->calc_mode 0
	    call c/kdr TABFILL X {tab_xfills + 1} 0


	    call c/kdr TABCREATE Y {tab_xdivs} {tab_xmin}  \
		{tab_xmax}
	    x = {tab_xmin}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    if (x < -0.025)
			    setfield c/kdr Y_A->table[{i}] 1.2
		    else
			    setfield c/kdr Y_A->table[{i}] 0.010
		    end

		    y = 1.0 + {exp {(x + 0.025)/0.004}}
		    setfield c/kdr Y_B->table[{i}] {1.0/y}
		    x = x + dx
	    end
	    tweaktau c/kdr Y
	    setfield c/kdr Y_A->calc_mode 0 Y_B->calc_mode 0
	    call c/kdr TABFILL Y {tab_xfills + 1} 0

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

	showfield c/kdr *
end

