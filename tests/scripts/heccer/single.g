setclock 0 2e-5
create compartment c
setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
create hsolve h
setmethod h 11
setfield h \
	chanmode 4 \
	path /c
call h SETUP
reset

function showfields

	showfield h \
		results[0] \
		results[1] \
		vm[0]
end
