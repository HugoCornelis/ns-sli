setclock 0 2e-5
create compartment c
setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel c/km
setfield c/km \
	Ek -0.085 \
	Gbar 1.115943116e-09 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 0.0 \
	Zpower 0.0

float x
float dx
int i
float y
float tab_xmin = -0.10; float tab_xmax = 0.05
int tab_xdivs = 20; int tab_xfills = 50

	    call c/km TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
		x = {tab_xmin}
		dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    y = 0.2/(3.3*({exp {(x + 0.035)/0.02}}) + {exp {-(x + 0.035)/0.02}})

echo {i} {x} {y}

		    setfield c/km X_A->table[{i}] {y}

		    y = 1.0/(1.0 + {exp {-(x + 0.035)/0.01}})

echo {i} {x} {y}

		    setfield c/km X_B->table[{i}] {y}
		    x = x + dx
	    end
	    tweaktau c/km X
	    setfield c/km X_A->calc_mode 0 X_B->calc_mode 0
	    call c/km TABFILL X {tab_xfills + 1} 0

addmsg c c/km VOLTAGE Vm
addmsg c/km c CHANNEL Gk Ek
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

	showfield c/km *
end

