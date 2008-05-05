setclock 0 2e-5

create neutral hardcoded_neutral

create compartment /hardcoded_neutral/c1

setfield /hardcoded_neutral/c1 \
        Cm 4.57537e-11 \
        Eleak -0.08 \
        initVm -0.068 \
        Ra 360502 \
        Rm 3.58441e8


copy /hardcoded_neutral/c1 /hardcoded_neutral/c2

setfield /hardcoded_neutral/c1 \
	inject 1e-8

setfield /hardcoded_neutral/c2 \
	Cm 5.755329373e-12 \
	Ra 772813.4375 \
	Rm 8.548598272e9

addmsg /hardcoded_neutral/c1 /hardcoded_neutral/c2 AXIAL Vm
addmsg /hardcoded_neutral/c2 /hardcoded_neutral/c1 RAXIAL Ra Vm


reset

call model_container NEUROSPACES_QUERY


