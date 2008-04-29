setclock 0 2e-5
create compartment c1
setfield c1 \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
copy c1 c2
copy c2 c3
copy c3 c4

addmsg c1 c2 AXIAL Vm
addmsg c2 c1 RAXIAL Ra Vm

addmsg c1 c3 AXIAL Vm
addmsg c3 c1 RAXIAL Ra Vm

addmsg c1 c4 AXIAL Vm
addmsg c3 c1 RAXIAL Ra Vm

create hsolve h
setmethod h 11
setfield h \
	chanmode 4 \
	path /c1,/c2,/c3,/c4
call h SETUP
reset

function showfields

	showfield h \
		results[0] \
		results[1] \
		results[2] \
		results[3] \
		results[4] \
		results[5] \
		results[6] \
		results[7] \
		vm[0] \
		vm[1] \
		vm[2] \
		vm[3]
end
