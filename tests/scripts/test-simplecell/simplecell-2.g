//genesis  -  simplecell.g
/*======================================================================
  A sample script to create a neuron containing channels taken from
  hh_tchan.g in the neurokit prototypes library.  SI units are used.
  ======================================================================*/

// Create a library of prototype elements to be used by the cell reader
include protodefs0

float tmax = 0.5		// simulation time in sec
float dt = 0.000005		// simulation time step in sec
setclock  0  {dt}		// set the simulation clock

// include any graphics functions
// include graphics

//===============================
//         Main Script
//===============================

readcell tests/scripts/test-simplecell/cell0.p /cell

// make the control panel
// make_control

// make the graph to display soma Vm and pass messages to the graph
// make_Vmgraph
//  addmsg /cell/soma /data/voltage PLOT Vm *volts *red

// setfield /control/Injection value 0.5e-9
// set_inject /control/Injection  // set initial injection from Injection dialog

setfield /cell/soma inject 0.5e-9

if ({version} == 3)
	echo "Initializing gate states."

	setfield /cell/soma/Na_hh_tchan X_init 0.05293248341
	setfield /cell/soma/Na_hh_tchan Y_init 0.5961207634

	setfield /cell/soma/K_hh_tchan X_init 0.3176769097
end

check

create hsolve /cell/h

setfield /cell/h \
	path "../##[TYPE=compartment]" \
	chanmode 4

call /cell/h SETUP
setmethod /cell/h 11

reset
echo "Initial Vm = " {getfield /cell/soma Vm}
echo "Initial Na X = " {getfield /cell/soma/Na_hh_tchan X}
echo "Initial Na Y = " {getfield /cell/soma/Na_hh_tchan Y}
echo "Initial Na Z = " {getfield /cell/soma/Na_hh_tchan Z}
echo "Initial K X = " {getfield /cell/soma/K_hh_tchan X}
echo "Initial K Y = " {getfield /cell/soma/K_hh_tchan Y}
echo "Initial K Z = " {getfield /cell/soma/K_hh_tchan Z}
step 0.5 -time
echo "Final Vm = " {getfield /cell/h {findsolvefield /cell/h /cell/soma Vm}}

echo "Type quit to exit"
