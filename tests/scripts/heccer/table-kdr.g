setclock 0 2e-5

create neutral hardcoded_neutral

create compartment /hardcoded_neutral/c

setfield /hardcoded_neutral/c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel /hardcoded_neutral/c/kdr
setfield /hardcoded_neutral/c/kdr \
	Ek -0.085 \
	Gbar 1.67391463e-05 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 2.0 \
	Ypower 1.0 \
	Zpower 0.0 \
	X_init  0.00359944 \
	Y_init 0.99997858779733162

//	X_init 0.0045016011008226975 \

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

	    call /hardcoded_neutral/c/kdr TABCREATE X {tab_xdivs} {tab_xmin}  \
		{tab_xmax}
	    x = {tab_xmin}
	    dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    a = -23.5e3*(x + 0.012 - VKTAU_OFFSET)/({exp {(x + 0.012 - VKTAU_OFFSET)/-0.012}} - 1.0)
		    b = 5.0e3*{exp {-(x + 0.147 - VKTAU_OFFSET)/0.030}}

// echo {i} {a} {b}

		    setfield /hardcoded_neutral/c/kdr X_A->table[{i}] {1.0/(a + b)}

		    a = -23.5e3*(x + 0.012 - VKMINF_OFFSET)/({exp {(x + 0.012 - VKMINF_OFFSET)/-0.012}} - 1.0)
		    b = 5.0e3*{exp {-(x + 0.147 - VKMINF_OFFSET)/0.030}}
		    setfield /hardcoded_neutral/c/kdr X_B->table[{i}] {a/(a + b)}
		    x = x + dx
	    end
	    tweaktau /hardcoded_neutral/c/kdr X
	    setfield /hardcoded_neutral/c/kdr X_A->calc_mode 0 X_B->calc_mode 0
	    call /hardcoded_neutral/c/kdr TABFILL X {tab_xfills} 0


	    call /hardcoded_neutral/c/kdr TABCREATE Y {tab_xdivs} {tab_xmin}  \
		{tab_xmax}
	    x = {tab_xmin}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    if (x < -0.025)
			    setfield /hardcoded_neutral/c/kdr Y_A->table[{i}] 1.2
		    else
			    setfield /hardcoded_neutral/c/kdr Y_A->table[{i}] 0.010
		    end

		    y = 1.0 + {exp {(x + 0.025)/0.004}}
		    setfield /hardcoded_neutral/c/kdr Y_B->table[{i}] {1.0/y}
		    x = x + dx
	    end
	    tweaktau /hardcoded_neutral/c/kdr Y
	    setfield /hardcoded_neutral/c/kdr Y_A->calc_mode 0 Y_B->calc_mode 0
	    //call /hardcoded_neutral/c/kdr TABFILL Y {tab_xfills + 1} 0

	    call /hardcoded_neutral/c/kdr TABFILL Y {tab_xfills} 0


addmsg /hardcoded_neutral/c /hardcoded_neutral/c/kdr VOLTAGE Vm
addmsg /hardcoded_neutral/c/kdr /hardcoded_neutral/c CHANNEL Gk Ek




silent 1

reset

set_nsintegrator_verbose_level 2

echo Initiated

setfield /neurospaces_integrator heccer_dump_selection { HECCER_DUMP_ALL_EXTENDED }

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------

echo Iteration 0

step 1
 


//call model_container NEUROSPACES_QUERY
