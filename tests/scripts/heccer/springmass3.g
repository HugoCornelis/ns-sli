float dt = 1e-5
setclock 0 {dt}
create neutral hardcoded_neutral
create compartment /hardcoded_neutral/c1
setfield /hardcoded_neutral/c1 \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.08 \
	Ra 360502 \
	Rm 3.58441e8
create compartment /hardcoded_neutral/c2
setfield /hardcoded_neutral/c2 \
	Cm 5.755329373e-12 \
	Em -0.08 \
	initVm -0.08 \
	Ra 772813.4375 \
	Rm 8.548598272e9
addmsg /hardcoded_neutral/c1 /hardcoded_neutral/c2 AXIAL Vm
addmsg /hardcoded_neutral/c2 /hardcoded_neutral/c1 RAXIAL Ra Vm
create synchan /hardcoded_neutral/c2/s
setfield /hardcoded_neutral/c2/s \
	Ek 0.0 \
	gmax 6.87071723162637e-10 \
	tau1 5e-4 \
	tau2 1.2e-3
addmsg /hardcoded_neutral/c2 /hardcoded_neutral/c2/s VOLTAGE Vm
addmsg /hardcoded_neutral/c2/s /hardcoded_neutral/c2/s CHANNEL Gk Ek
addmsg /hardcoded_neutral/c2/s /hardcoded_neutral/c2/s ACTIVATION z 

//create hsolve h

//setmethod h 11
//setfield h \
//	calcmode 0 \
//	chanmode 4 \
//	path /c1,/c2
//call h SETUP

create asc_file /a1
setfield ^ \
	append 0 \
	filename "/tmp/a1" \
	flush 1 \
	leave_open 1
addmsg /hardcoded_neutral/c1 a1 SAVE Vm
call a1 RESET




resched

reset

setfield /hardcoded_neutral/c2/s z 0

step 1271

setfield /hardcoded_neutral/c2/s z {1 / dt}

step {10000}




echo output written





