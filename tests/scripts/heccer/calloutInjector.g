setclock 0 2e-5


create compartment c


setfield c \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8



reset



step 1

showfields

step 1

showfields

setfield h {findsolvefield h c inject} 5e-10

step 1

showfields

step 1

showfields

step 1

showfields

step 1

showfields

step 1

showfields

step 1

showfields

setfield h {findsolvefield h c inject} 0

step 1

showfields

step 1

showfields


