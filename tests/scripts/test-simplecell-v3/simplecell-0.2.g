//genesis  -  simplecell.g
/*======================================================================
  A sample script to create a neuron containing channels taken from
  hh_tchan.g in the neurokit prototypes library.  SI units are used.
  ======================================================================*/

// Create a library of prototype elements to be used by the cell reader
include protodefs0

float tmax = 0.5		// simulation time in sec
float dt = 0.00005		// simulation time step in sec
setclock  0  {dt}		// set the simulation clock

// include any graphics functions
// include graphics

//===============================
//         Main Script
//===============================

readcell cell0.p /cell // cell0.p has tabchannels in soma, nothing in dend

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


// Output the results
    create asc_file /out
    setfield /out    flush 1    leave_open 1    append 1
    // G3 requires an explicit filename - won't use asc_file name as default
    setfield /out  filename "Vm.out"
//    setclock 1 0.001  // A rather large interval to keep the file small
    setclock 1 0.0001   // 100 msec interval
    useclock /out 1
    addmsg /cell/soma /out SAVE Vm
check
reset

// Check to see if getfield returns computed field variables
echo "Initial Vm = " {getfield /cell/soma Vm}

step 0.5 -time

echo "Final Vm = " {getfield /cell/soma Vm}
