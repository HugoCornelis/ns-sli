setclock 0 2e-5

create neutral hardcoded_neutral

create compartment /hardcoded_neutral/c

setfield /hardcoded_neutral/c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel /hardcoded_neutral/c/km
setfield /hardcoded_neutral/c/km \
	Ek -0.085 \
	Gbar 1.115943116e-09 \
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

	    call /hardcoded_neutral/c/km TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
		x = {tab_xmin}
		dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    y = 0.2/(3.3*({exp {(x + 0.035)/0.02}}) + {exp {-(x + 0.035)/0.02}})

//echo {i} {x} {y}

		    setfield /hardcoded_neutral/c/km X_A->table[{i}] {y}

		    y = 1.0/(1.0 + {exp {-(x + 0.035)/0.01}})

//echo {i} {x} {y}

		    setfield /hardcoded_neutral/c/km X_B->table[{i}] {y}
		    x = x + dx
	    end
	    tweaktau /hardcoded_neutral/c/km X
	    setfield /hardcoded_neutral/c/km X_A->calc_mode 0 X_B->calc_mode 0
	    call /hardcoded_neutral/c/km TABFILL X {tab_xfills} 0

addmsg /hardcoded_neutral/c /hardcoded_neutral/c/km VOLTAGE Vm
addmsg /hardcoded_neutral/c/km /hardcoded_neutral/c CHANNEL Gk Ek





silent 1

reset

set_nsintegrator_verbose_level 2

echo Initiated

call neurospaces_integrator NSINTEGRATOR_DUMP

echo -------
echo Iteration 0

step 1

