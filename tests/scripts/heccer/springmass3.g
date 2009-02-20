float dt = 1e-5
setclock 0 {dt}
create compartment c1
setfield c1 \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.08 \
	Ra 360502 \
	Rm 3.58441e8
create compartment c2
setfield c2 \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.08 \
	Ra 772813.4375 \
	Rm 8.548598272e9
addmsg c1 c2 AXIAL Vm
addmsg c2 c1 RAXIAL Ra Vm
create synchan c2/s
setfield c2/s \
	Ek 0.0 \
	gmax 6.87071723162637e-10 \
	tau1 5e-4 \
	tau2 1.2e-3
addmsg c2 c2/s VOLTAGE Vm
addmsg c2/s c2 CHANNEL Gk Ek
addmsg c2/s c2/s ACTIVATION z 
create hsolve h
setmethod h 11
setfield h \
	calcmode 0 \
	chanmode 4 \
	path /c1,/c2
call h SETUP

create asc_file /a1
setfield ^ \
	append 0 \
	filename "/tmp/a1" \
	flush 1 \
	leave_open 1
addmsg /h a1 SAVE vm[0]
call a1 RESET
resched

reset

function showfields

	showfield h \
		vm[0] \
		vm[1]
end

// Firing 1270, 1e-05
// Firing 2348, 1e-05
// Firing 4537, 1e-05
// Firing 5376, 1e-05
// Firing 6646, 1e-05
// Firing 7421, 1e-05
// Firing 7440, 1e-05

step 1270

setfield c2/s z {1 / dt}

step

setfield c2/s z 0

step {1078 - 1}

setfield c2/s z {1 / dt}

step

setfield c2/s z 0

step {2189 - 1}

setfield c2/s z {1 / dt}

step

setfield c2/s z 0

step {839 - 1}

setfield c2/s z {1 / dt}

step

setfield c2/s z 0

step {1270 - 1}

setfield c2/s z {1 / dt}

step

setfield c2/s z 0

step {775 - 1}

setfield c2/s z {1 / dt}

step

setfield c2/s z 0

step {19 - 1}

setfield c2/s z {1 / dt}

step

setfield c2/s z 0

step {2560 - 1}

