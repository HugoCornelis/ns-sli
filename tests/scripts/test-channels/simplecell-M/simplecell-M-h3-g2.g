//genesis  -  simplecell.g
/*======================================================================
  A sample script to create a neuron containing channels taken from
  hh_tchan.g in the neurokit prototypes library.  SI units are used.

  October 2009 - enhanced to run under GENESIS 3

  ======================================================================*/

/* Some Booleans indicating the type of calculations or output */
int batch = 0        // if (batch) then run a default simulation
int graphics = 1     // display control panel, graphs
int file_out = 1     // write output to a file

int hflag = 1       // GENESIS 2 - use hsolve if hflag = 1
int hsolve_chanmode = 3    // hsolve mode for GENESIS 2

str cellfile = "cell-M.p"
str cellpath = "/cell"
str injectpath = "/cell/soma"
str outfile = "simplecell-M-h3_Vm.out"

float injcurrent = 0.5e-9

// Create a library of prototype elements to be used by the cell reader
include protodefs-M.g

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

if (hflag)
    create hsolve {cellpath}/solver
    setfield {cellpath}/solver path "/cell/##[][TYPE=compartment]"
    setmethod 11
    setfield {cellpath}/solver chanmode {hsolve_chanmode}
    call {cellpath}/solver SETUP
    reset
    echo "Using hsolve"
end

//check
reset

if (batch)
    step {tmax} -time
end
