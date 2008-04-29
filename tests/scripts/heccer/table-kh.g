setclock 0 2e-5
create compartment c
setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel c/h1
setfield c/h1 \
	Ek -0.030 \
	Gbar 8.369573479e-09 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 0.0 \
	Zpower 0.0
create tabchannel c/h2
setfield c/h2 \
	Ek -0.030 \
	Gbar 8.369573479e-09 \
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

	    call c/h1 TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	    call c/h2 TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

	    x = {tab_xmin}
	    dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    //fast component
		    setfield c/h1 X_A->table[{i}] 0.0076
		    //slow component
		    setfield c/h2 X_A->table[{i}] 0.0368

		    y = 1.0/(1 + {exp {(x + 0.082)/0.007}})
		    float y1 = {0.8*y}
		    float y2 = {0.2*y}

echo {i} {dx} {y1}
echo {i} {dx} {y2}

		    setfield c/h1 X_B->table[{i}] {0.8*y}
		    setfield c/h2 X_B->table[{i}] {0.2*y}
		    x = x + dx
	    end
	    tweaktau c/h1 X
	    setfield c/h1 X_A->calc_mode 0 X_B->calc_mode 0
	    call c/h1 TABFILL X {tab_xfills + 1} 0
	    tweaktau c/h2 X
	    setfield c/h2 X_A->calc_mode 0 X_B->calc_mode 0
	    call c/h2 TABFILL X {tab_xfills + 1} 0

addmsg c c/h1 VOLTAGE Vm
addmsg c/h1 c CHANNEL Gk Ek
addmsg c c/h2 VOLTAGE Vm
addmsg c/h2 c CHANNEL Gk Ek
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

	showfield c/h1 *
	showfield c/h2 *
end

