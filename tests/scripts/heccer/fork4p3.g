setclock 0 2e-5
create compartment /hardcoded_netural/c1
setfield /hardcoded_netural/c1 \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.068 \
	Ra 360502 \
	Rm 3.58441e8
copy /hardcoded_netural/c1 /hardcoded_netural/c2
copy /hardcoded_netural/c2 /hardcoded_netural/c3
copy /hardcoded_netural/c3 /hardcoded_netural/c4

addmsg /hardcoded_netural/c1 /hardcoded_netural/c2 AXIAL Vm
addmsg /hardcoded_netural/c2 /hardcoded_netural/c1 RAXIAL Ra Vm

addmsg /hardcoded_netural/c1 /hardcoded_netural/c3 AXIAL Vm
addmsg /hardcoded_netural/c3 /hardcoded_netural/c1 RAXIAL Ra Vm

addmsg /hardcoded_netural/c1 /hardcoded_netural/c4 AXIAL Vm
addmsg /hardcoded_netural/c3 /hardcoded_netural/c1 RAXIAL Ra Vm


reset

call model_container NEUROSPACES_QUERY


