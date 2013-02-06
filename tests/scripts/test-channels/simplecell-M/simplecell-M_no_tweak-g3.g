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

str cellfile = "tests/scripts/test-channels/simplecell-M/cell-M.p"
str cellpath = "/cell"
str injectpath = "/cell/soma"
str outfile = "output/simplecell-M_no-tweak_Vm.out"

float injcurrent = 0.5e-9

// Create a library of prototype elements to be used by the cell reader
include protodefs-M_no_tweak.g

float tmax = 0.5		// simulation time in sec
float dt = 0.00002		// 20 microsec time step
setclock  0  {dt}		// set the simulation clock
float out_dt = 0.0001   // 0.1 msec interval

/* Auxillary Function definitions */

function set_inject(value)
    str value
    setfield {injectpath} inject {value}
    injcurrent = {value}
end

function make_cell
    readcell {cellfile} {cellpath}
end

function make_input
    setfield {injectpath} inject {injcurrent}
end

function make_output
    create asc_file /output/plot_out
    setclock 1 {out_dt}
    useclock /output/plot_out 1
    addmsg {cellpath}/soma /output/plot_out SAVE Vm
    setfield /output/plot_out filename {outfile}
end

function step_tmax
    // Add any other commands here that you want to execute for each run
    echo "START: "{getdate}
    step {tmax} -time
    echo "END: "{getdate}
end

//===============================
//         Main Script
//===============================

make_cell // creates a cell with a soma and a dend compartment
make_input // provides input to the cell


if (graphics)
   // include any graphics functions
   include graphics
   // make the control panel
   make_control
   // make the graph to display soma Vm and pass messages to the graph
   make_Vmgraph
   addmsg /cell/soma /data/voltage PLOT Vm *volts *red
   setfield /control/Injection value {injcurrent}
   colorize
end

if (file_out)
   make_output // provides output of the results to a file
end

check
reset

if (batch)
    step {tmax} -time
end
