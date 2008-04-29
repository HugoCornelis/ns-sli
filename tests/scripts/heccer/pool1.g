setclock 0 2e-5
create compartment c
setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.028 \
	Ra 360502 \
	Rm 3.58441e8
create tabchannel c/cat
setfield c/cat \
	Ek 0.1375262439 \
	Gbar 1.394928884e-08 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 1.0 \
	Ypower 1.0 \
	Zpower 0.0
setupalpha c/cat \
	X \
	2.6e3 \
	0.0 \
	1.0 \
	0.021 \
	-8e-3 \
	0.18e3 \
	0.0 \
	1.0 \
	0.04 \
	4e-3 \
	-size 3000 \
	-range -0.1 0.05
setupalpha c/cat \
	Y \
	0.0025e3 \
	0.0 \
	1.0 \
	0.04 \
	8e-3 \
	0.19e3 \
	0.0 \
	1.0 \
	0.05 \
	-10.0e-3 \
	-size 3000 \
	-range -0.1 0.05
addmsg c c/cat VOLTAGE Vm
addmsg c/cat c CHANNEL Gk Ek
create Ca_concen c/p
setfield c/p \
	tau 0.00010 \
	B 9412391936 \
	Ca_base 4e-05 \
	thick 2e-07
addmsg c/cat c/p I_Ca Ik
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
		conc[0] \
		results[0] \
		results[1] \
		vm[0]
end

function showtables

	int i

	for (i = 0 ; i < 3001 ; i = i + 1)

		echo {i} {getfield /c/cat X_A->table[{i}]}
	end

	for (i = 0 ; i < 3001 ; i = i + 1)

		echo {i} {getfield /c/cat X_B->table[{i}]}
	end

	for (i = 0 ; i < 3001 ; i = i + 1)

		echo {i} {getfield /c/cat Y_A->table[{i}]}
	end

	for (i = 0 ; i < 3001 ; i = i + 1)

		echo {i} {getfield /c/cat Y_B->table[{i}]}
	end

end

