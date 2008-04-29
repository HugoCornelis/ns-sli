// channel parameters changed, slightly more 'realistic', but better
// never to use them in a real model.

setclock 0 1e-6
create compartment source
setfield source \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.065 \
	Ra 360502 \
	Rm 3.58441e8 \
	inject 2e-9
create tabchannel source/naf
setfield source/naf \
	Ek 0.045 \
	Gbar 0.00001 \
	Ik 0.0 \
	Gk 0.0 \
	Xpower 3.0 \
	Ypower 1.0 \
	Zpower 0.0
setupalpha source/naf \
	Y \
	0.225e3 \
	0.0 \
	1.0 \
	0.08 \
	10.0e-3 \
	7.5e3 \
	0.0 \
	0.0 \
	-0.003 \
	-18.0e-3 \
	-size 3000 \
	-range -0.1 0.05
setupalpha source/naf \
	X \
	35.0e3 \
	0.0 \
	0.0 \
	0.005 \
	-10.0e-3 \
	7.0e3 \
	0.0 \
	0.0 \
	0.065 \
	20.0e-3 \
	-size 3000 \
	-range -0.1 0.05
addmsg source source/naf VOLTAGE Vm
addmsg source/naf source CHANNEL Gk Ek

create tabchannel source/kdr

setfield source/kdr \
	Ek -0.085 \
	Gbar {360.0 * 2.78985994009388e-09} \
	Ik 0 \
	Gk 0 \
	Xpower 4 \
	Ypower 0 \
	Zpower 0
setupalpha source/kdr \
	X \
	{10e3 * (0.01 + -0.065)} \
	-10.0e3 \
        -1.0 \
	{-1.0 * (0.01 + -0.065)} \
	-0.01 \
	125.0 \
	0.0 \
	0.0 \
        {-1.0 * -0.065} \
	80.0e-3 \
	-size 3000 \
	-range -0.1 0.05

addmsg source source/kdr VOLTAGE Vm
addmsg source/kdr source CHANNEL Gk Ek

create spikegen source/spike
setfield source/spike \
	thresh 0.0 \
	abs_refract 0.001
addmsg source source/spike INPUT Vm

create compartment target1
setfield target1 \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.065 \
	Ra 360502 \
	Rm 3.58441e8
create synchan target1/s
setfield target1/s \
	Ek 0.0 \
	gmax 6.87071723162637e-10 \
	tau1 5e-4 \
	tau2 1.2e-3
addmsg target1 target1/s VOLTAGE Vm
addmsg target1/s target1 CHANNEL Gk Ek


create compartment target2
setfield target2 \
	Cm 4.57537e-11 \
	Em -0.08 \
	initVm -0.065 \
	Ra 360502 \
	Rm 3.58441e8
create synchan target2/s
setfield target2/s \
	Ek 0.0 \
	gmax 6.87071723162637e-10 \
	tau1 5e-4 \
	tau2 1.2e-3
addmsg target2 target2/s VOLTAGE Vm
addmsg target2/s target2 CHANNEL Gk Ek


addmsg source/spike target1/s SPIKE 
addmsg source/spike target2/s SPIKE 

setfield target1/s \
	synapse[0].delay 0.001 \
	synapse[0].weight 1.0

setfield target2/s \
	synapse[0].delay 0.002 \
	synapse[0].weight 2.0

create hsolve hs
setmethod hs 11
setfield hs \
	calcmode 0 \
	chanmode 4 \
	path /source
call hs SETUP

create hsolve ht1
setmethod ht1 11
setfield ht1 \
	calcmode 0 \
	chanmode 4 \
	path /target1
call ht1 SETUP

create hsolve ht2
setmethod ht2 11
setfield ht2 \
	calcmode 0 \
	chanmode 4 \
	path /target2
call ht2 SETUP
reset

function plot

	create xform /form
	create xgraph /form/graph
	addmsg /hs /form/graph PLOT vm[0] *voltage *red
	addmsg /ht1 /form/graph PLOT vm[0] *voltage *blue
	addmsg /ht2 /form/graph PLOT vm[0] *voltage *green
	xshow /form
end

function showfields

	showfield hs \
		chip[4] \
		chip[7] \
		chip[8] \
		givals[3] \
		givals[4] \
		givals[7] \
		givals[8] \
		results[0] \
		results[1] \
		vm[0]

	showfield ht1 \
		results[0] \
		results[1] \
		vm[0]

	showfield ht2 \
		results[0] \
		results[1] \
		vm[0]
end

plot

reset

step 10000

