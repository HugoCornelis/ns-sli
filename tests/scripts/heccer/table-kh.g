setclock 0 2e-5

create neutral hardcoded_neutral
create compartment /hardcoded_neutral/c



setfield /hardcoded_neutral/c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8



create tabchannel /hardcoded_neutral/c/h1
setfield /hardcoded_neutral/c/h1 \
	Ek -0.030 \
	Gbar 8.369573479e-09 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 0.0 \
	Zpower 0.0 \
	X_init 0.03540844397


create tabchannel /hardcoded_neutral/c/h2
setfield /hardcoded_neutral/c/h2 \
	Ek -0.030 \
	Gbar 8.369573479e-09 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 0.0 \
	Zpower 0.0 \
	X_init 0.03540844397


float x
float dx
int i
float y
float tab_xmin = -0.10; float tab_xmax = 0.05
int tab_xdivs = 20; int tab_xfills = 50

	    call /hardcoded_neutral/c/h1 TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	    call /hardcoded_neutral/c/h2 TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

	    x = {tab_xmin}
	    dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    //fast component
		    setfield /hardcoded_neutral/c/h1 X_A->table[{i}] 0.0076
		    //slow component
		    setfield /hardcoded_neutral/c/h2 X_A->table[{i}] 0.0368

		    y = 1.0/(1 + {exp {(x + 0.082)/0.007}})
		    float y1 = {0.8*y}
		    float y2 = {0.2*y}

echo {i} {dx} {y1}
echo {i} {dx} {y2}

		    setfield /hardcoded_neutral/c/h1 X_B->table[{i}] {0.8*y}
		    setfield /hardcoded_neutral/c/h2 X_B->table[{i}] {0.2*y}
		    x = x + dx
	    end

	    tweaktau /hardcoded_neutral/c/h1 X
	    setfield /hardcoded_neutral/c/h1 X_A->calc_mode 0 X_B->calc_mode 0
	    call /hardcoded_neutral/c/h1 TABFILL X {tab_xfills + 1} 0

	    tweaktau /hardcoded_neutral/c/h2 X
	    setfield /hardcoded_neutral/c/h2 X_A->calc_mode 0 X_B->calc_mode 0
	    call /hardcoded_neutral/c/h2 TABFILL X {tab_xfills + 1} 0

addmsg /hardcoded_neutral/c /hardcoded_neutral/c/h1 VOLTAGE Vm
addmsg /hardcoded_neutral/c/h1 /hardcoded_neutral/c CHANNEL Gk Ek
addmsg /hardcoded_neutral/c /hardcoded_neutral/c/h2 VOLTAGE Vm
addmsg /hardcoded_neutral/c/h2 /hardcoded_neutral/c CHANNEL Gk Ek




silent 1

reset

set_nsintegrator_verbose_level 2

echo Initiated

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 1



