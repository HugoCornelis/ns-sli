//genesis  -  simplecell.g
/*======================================================================
  A sample script to create a neuron containing channels taken from
  hh_tchan.g in the neurokit prototypes library.  SI units are used.

  October 2009 - enhanced to run under GENESIS 3
  February 2011 - modified to present an experimental protocol

  ======================================================================*/

/* Some Booleans indicating the type of calculations or output */
int batch = 1        // if (batch) then run a default simulation
int file_out = 1     // write output to a file

str cellfile = "cell.p"
str cellpath = "/cell"
str outfile = "syn_Ik.out"

// Create a library of prototype elements to be used by the cell reader
include protodefs

float tmax = 0.5		// simulation time in sec
float dt = 0.00002		// 20 microsec time step
setclock  0  {dt}		// set the simulation clock
float out_dt = 0.0001   // 0.1 msec interval

// parameters for a pulsed spike train input
float spikeinterval = 0.01 // default interval in applied spike train
float pulse_delay = 0.05
float pulse_width = 0.40
float pulse_interval = {tmax}  // Provide a single pulse during the run


/* Auxillary Function definitions */

function make_cell
    readcell {cellfile} {cellpath}
end

function make_input
    setfield /cell/soma inject 0.0
    create spikegen /inputsource // generates spikes with interval abs_refract
    create pulsegen /inputsource/pulser // controls inputsource with pulses
    // Use these global variables as pulse parameters
/* Note: ns-sli cannot deal with this wildcard */
//    setfield /##[ISA=pulsegen] level1 1.0 width1 {pulse_width} delay1 \
    setfield /inputsource/pulser level1 1.0 width1 {pulse_width} delay1 \
        {pulse_delay} baselevel 0.0 trig_mode 0 \
        delay2 {pulse_interval - pulse_delay} width2 0
    setfield /inputsource thresh 0.5 abs_refract {spikeinterval}
    addmsg /inputsource/pulser /inputsource INPUT output
    addmsg /inputsource /cell/dend/Ex_channel SPIKE
//    setfield /cell/dend/Ex_channel  gmax {syn_gmax}
end


function make_output
    create asc_file /output/plot_out
    setclock 1 {out_dt}
    useclock /output/plot_out 1
    addmsg {cellpath}/dend/Ex_channel /output/plot_out SAVE Ik
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

if (file_out)
   make_output // provides output of the results to a file
end

check
reset

if (batch)
    step {tmax} -time
end
