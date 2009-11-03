//genesis 2 -  based on simplecell.g
/*======================================================================
  A sample script to create a neuron containing channels taken from
  hh_tchan.g in the neurokit prototypes library.  SI units are used.

  October 2009 - Illustrates "hand-tuning" a cell for a manual
  paramater search

  ======================================================================*/

/* Some Booleans indicating the type of calculations or output */
int batch = 1        // if (batch) then run a default simulation
int graphics = 1     // display control panel, graphs
int file_out = 1     // write output to a file
int calc_ISIs = 1    // Record spike times in a table and calc ISIs
int tune_params = 1  // Adjust cell and/or channel parameters

/* some strings to generalize names of cell and channels */
str Na_chan = "Na_hh_tchan"
str K_chan = "K_hh_tchan"
str cellpath = "/cell"

float injcurr = 0.5e-9  // default 0.5 nA injection current
float gdens_Na, gdens_K, SOMA_A // channel densities and soma area

// Create a library of prototype elements to be used by the cell reader
include protodefs

float tmax = 0.5		// simulation time in sec
float dt = 0.00005		// simulation time step in sec
setclock  0  {dt}		// set the simulation clock

/* Function Definitions */

// Calculate the spike frequencies from the table of spike times
function echo_spike_freqs
  float injdelay = 0.0 // In case of delayed injection pulse
  int imax = {getfield /intertab output}  // index of last spike time
  float time1 = {getfield /intertab table->table[0]}
  float time2 = {getfield /intertab table->table[1]}
  float time3 = {getfield /intertab table->table[2]}
  float time4 = {getfield /intertab table->table[3]}
  echo "Injection: " {injcurr} " with " {imax} " spikes in " {tmax} "sec"
  if ({imax} > 0)
    float lastinterval = {getfield /intertab table->table[{imax-1}]} \
    - {getfield /intertab table->table[{imax-2}]}
    echo "Spike intervals:  latency "{time1 - injdelay} " ; 1st "{time2 - time1} \
       " ; 2nd " {time3-time2} \
       " ; 3rd " {time4-time3} " ; last interval " {lastinterval}
    echo "1/latency = " {1/(time1 - injdelay)} " Hz."
    echo "Spike frequencies : 1st "{1/(time2 - time1)} " ; 2nd " \
      {1/(time3 - time2)} " ; 3rd " {1/(time4-time3)} \
      " ; last " {1/lastinterval}
  end
end
 
function step_tmax
    // Add any other commands here that you want to execute for each run
    step {tmax} -time
    if (calc_ISIs)
        echo_spike_freqs
    end
end

// Functions for adjusting channel gate parameters

/* shift activation curves for minf and tau on both Na and K channels */
float Na_K_offset = 0.0
function adjust_Na_K(offset)
    float offset
    scaletabchan {cellpath}/soma/{Na_chan} X minf 1.0 1.0 {offset} 0.0
    scaletabchan {cellpath}/soma/{Na_chan} Y minf 1.0 1.0 {offset} 0.0
    scaletabchan {cellpath}/soma/{K_chan} X minf 1.0 1.0 {offset} 0.0

    scaletabchan {cellpath}/soma/{Na_chan} X tau 1.0 1.0 {offset} 0.0
    scaletabchan {cellpath}/soma/{Na_chan} Y tau 1.0 1.0 {offset} 0.0
    scaletabchan {cellpath}/soma/{K_chan} X tau 1.0 1.0 {offset} 0.0
end
float Na_K_tau_scale = 1.0

function tau_scale(scale)
    float scale
    scaletabchan {cellpath}/soma/{Na_chan} X tau 1.0 {scale}  0.0 0.0
    scaletabchan {cellpath}/soma/{Na_chan} Y tau 1.0 {scale}  0.0 0.0
    scaletabchan {cellpath}/soma/{K_chan} X tau 1.0 {scale} 0.0 0.0
end

//===============================
//         Main Script
//===============================

readcell cell3.p {cellpath}
setfield {cellpath}/soma inject {injcurr}

// Initialize the channel conductance density variables by looking at the cell
SOMA_A = 3.14159*{getfield {cellpath}/soma len}*{getfield {cellpath}/soma dia}
gdens_Na = {getfield {cellpath}/soma/{Na_chan} Gbar}/SOMA_A
gdens_K = {getfield {cellpath}/soma/{K_chan} Gbar}/SOMA_A


if (calc_ISIs)
    /* set up table object to record spike times */
    create table /intertab	// table of spike times
    call /intertab TABCREATE 151 0 150
    setfield /intertab step_mode 4 stepsize 0 // tab_spike, thresh = 0
    addmsg {cellpath}/soma /intertab INPUT Vm
end

if (graphics)
    // include any graphics functions
    include graphics4.g
    // make the control panel
    make_control
    // make the graph to display soma Vm and pass messages to the graph
    make_Vmgraph
    addmsg {cellpath}/soma /data/voltage PLOT Vm *volts *red
    setfield /control/Injection value {injcurr}
    set_inject /control/Injection  // set initial injection from Injection dialog
    // make menu for changing soma parameters (channel densities, etc)
    if (tune_params)
        make_soma_params
    end
    colorize    // give the widgets some color
end

if ({version} == 3)
	echo "Initializing gate states."

	setfield {cellpath}/soma/{Na_chan} X_init 0.05293248341
	setfield {cellpath}/soma/{Na_chan} Y_init 0.5961207634

	setfield {cellpath}/soma/{K_chan} X_init 0.3176769097
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
    addmsg {cellpath}/soma /out SAVE Vm
end

check
reset


if (batch)
   // Check to see if getfield returns computed field variables
   echo "Initial Vm = " {getfield {cellpath}/soma Vm}
   step_tmax
   echo "Final Vm = " {getfield {cellpath}/soma Vm}
   if (tune_params)
       tau_scale 2 // double the time constant of all gates
       sleep 5
       reset
       step_tmax
   end
end
