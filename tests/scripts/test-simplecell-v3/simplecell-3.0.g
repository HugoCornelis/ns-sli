//genesis  -  simplecell.g
/*======================================================================
  A sample script to create a neuron containing channels taken from
  hh_tchan.g in the neurokit prototypes library.  SI units are used.

  October 2009 - enhanced to run under GENESIS 3

  ======================================================================*/

/* Some Booleans indicating the type of calculations or output */
int batch = 1        // if (batch) then run a default simulation
int graphics = 0     // display control panel, graphs
int file_out = 1     // write output to a file

// Create a library of prototype elements to be used by the cell reader
include protodefs

float tmax = 0.5		// simulation time in sec
float dt = 0.00005		// simulation time step in sec
setclock  0  {dt}		// set the simulation clock

//===============================
//         Main Script
//===============================

readcell cell3.p /cell

if (graphics)
   // include any graphics functions
   include graphics
   // make the control panel
   make_control
   // make the graph to display soma Vm and pass messages to the graph
   make_Vmgraph
   addmsg /cell/soma /data/voltage PLOT Vm *volts *red
   setfield /control/Injection value 0.5e-9
   set_inject /control/Injection  // set initial injection from Injection dialog
end

setfield /cell/soma inject 0.5e-9

if ({version} == 3)
	echo "Initializing gate states."

	setfield /cell/soma/Na_hh_tchan X_init 0.05293248341
	setfield /cell/soma/Na_hh_tchan Y_init 0.5961207634

	setfield /cell/soma/K_hh_tchan X_init 0.3176769097
end
reset

if (file_out)
// Output the results
    create asc_file /out
    setfield /out    flush 1    leave_open 1    append 1
    // G3 requires an explicit filename - won't use asc_file name as default
    setfield /out  filename "Vm.out"
    setclock 1 0.0001   // 100 msec interval
    useclock /out 1
    addmsg /cell/soma /out SAVE Vm
end

check
reset


if (batch)
   // Check to see if getfield returns computed field variables
   // echo "Initial Vm = " {getfield /cell/soma Vm}
   step 0.5 -time
   // echo "Final Vm = " {getfield /cell/soma Vm}
end
