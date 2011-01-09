//genesis - RSnet.g
/*======================================================================

  RSnet.g is a customizeable script for creating a network of simplified
  Regular Spiking neocortical neurons with local excitatory connections.
  The simulation script is analyzed and explained in the GENESIS Neural
  Modeling Tutorials (http://www.genesis-sim.org/GENESIS/Tutorials/)

  This version RSnet2.g has been reorganized and modularized for
  eventual use under GENESIS 3.

  ======================================================================*/

str script_name = "RSnet2.g"
str RUNID = "0000"	    // default ID string for output file names

// Booleans indicating the type of output
int graphics = 0       // display control panel, graphs, optionally net view
int batch = 1           // if (batch)run with default parameters
int netview_output = 1  // Record network output (soma Vm) to a file
int binary_file = 0     // if 0, use asc_file to produce ascii output
                        // else use disk_out to produce binary FMT1 file
int EPSC_output = 0 // output summed EPS currents to file (not implemented)
int connect_network = 1	 // Set to 0 for debugging with unconnected cells

int netview = 0 // show network activity view (slower, but pretty)
int hflag = 1    // use hsolve if hflag = 1
int hsolve_chanmode = 0 // Only applies if hflag = 1
int G3_hacks = 1 // Special treatment for things that G3 can't yet do
                 // Also needed for G2 and hsolve
// At present, this is the only stimulus option
str input_model = "pulsed_inject" // pulsed current injection to soma

/* Customize these strings and parameters to modify this simulation for
   another cell.
*/

str cellfile = "tests/scripts/test-RSnet2/RScell.p"  // name of the cell parameter file
str cellname = "/cell"     // name of the root element of the cell
str synpath = "soma/Ex_channel" // compartment-name/synchan-name

// Label to appear on the graph
str graphlabel = "Network of simplified cortical pyramidal cells"

str net_efile = "Ex_net_Vm"  // filename prefix for netview data
str sum_file = "run_summary" // text file prefix for summary of run params

float tmax = 0.5		// simulation time

float dt = 50e-6		// simulation time step
float out_dt = 0.0001	  // output ascii data every 0.1 msec
float netview_dt = 0.0002 // slowest clock for netview display and disk_out
setclock 0 {dt}           // Main simulation clock
setclock 1 {out_dt}       // ascii file output clock
setclock 2 {netview_dt}   // clock for netview display and disk_out

int NX = 32  // number of cells = NX*NY
int NY = 32

/* Neurons will be placed on a two dimensional NX by NY grid, with points
   SEP_X and SEP_Y apart in the x and y directions.

   Cortical networks typically have pyramidal cell separations on the order
   of 10 micrometers, and can have local pyramidal cell axonal projections
   of up to a millimeter or more.  For small network models, one sometimes
   uses a larger separation, so that the model represents a larger cortical
   area.  In this case, the neurons in the model are a sparse sample of the
   those in the actual network, and each one of them represents many in the
   biological network.  To compensate for this, the conductance of each
   synapse is scaled by a synaptic weight factor, to represent the
   increased number of neurons that would be providing input in the actual
   network.  Here, we use a very large separation of 1 mm that would be
   appropriate for a piriform cortex model with long range connections
   between cells.
*/

float SEP_X = 0.001 // 1 mm
float SEP_Y = 0.001


/* parameters for synaptic connections */

float syn_weight = 10 // synaptic weight, effectively multiplies gmax

// Typical conduction velocity for myelinated pyramidal cell axon
float cond_vel = 0.5 // m/sec
// With these separations, there is 2 msec delay between nearest neighbors
float prop_delay = SEP_X/cond_vel

float gmax = 1.5e-9 // 1.5 nS - possibly a little small for this cell

// index of middle cell (or approximately, if NX, NY are even)
int Middle_cell = {round {(NY-1)/2}}*NX + {round {(NX -1)/2}}
int Redge_cell = {{round {(NY-1)/2}}*NX} + NX -1 // middle right edge
int Ledge_cell = {{round {(NY-1)/2}}*NX}  // middle left edge
int LLcorner_cell = 0                    // index of lower left corner

int InjCell = LLcorner_cell  // default current injection point

// default (initial) parameters for current injection
float pulse_width = 0.05 // 50 msec
// for constant stimulation, use pulse_width >= tmax
float pulse_delay = 0
float pulse_interval = 1

float injcurrent = 1.0e-9
float frequency = 0 // Random background input to all Ex_channel

/* for debugging and exploring - see comments in file for details
   Usage:   synapse_info path_to_synchan
   Example: synapse_info /network/cell[5]/Ex_channel

   Uncomment the following include to use this with GENESIS 2
*/

// include synapseinfo.g

// =============================
//   Function definitions
// =============================

function set_gmax(value)
    float value
    gmax = value
    setfield /network/cell[]/{synpath} gmax {gmax}
end

function set_weights(weight)
    float weight
    syn_weight = weight
    if(G3_hacks)
      int i,j
      for (i=0; i < {NX*NY} ; i = i + 1)
        for (j=0; j < {getfield /network/cell[{i}]/{synpath} nsynapses} ; j=j+1)
            setfield /network/cell[{i}]/{synpath} synapse[{j}].weight {weight}
        end
      end
    else
      volumeweight /network/cell[]/soma/spike -fixed {weight}
    end
end

function set_delays(delay)
   float delay
   prop_delay = delay
    if(G3_hacks)
      int i,j
      for (i=0; i < {NX*NY} ; i = i + 1)
        for (j=0; j < {getfield /network/cell[{i}]/{synpath} nsynapses} ; j=j+1)
            setfield /network/cell[{i}]/{synpath} synapse[{j}].delay {delay}
        end
      end
    else
      volumedelay /network/cell[]/soma/spike -fixed {delay}
//   volumedelay /network/cell[]/soma/spike -radial {cond_vel}
    end
end

function set_pulse_timing(delay, width, interval)
    float delay, width, interval
    setfield /inputsource width1 {width} delay1 {delay}  \
        baselevel 0.0 trig_mode 0 delay2 {interval - delay} width2 0
    // free run mode with very long delay for 2nd pulse (non-repetitive)
    // level1 is set by make_pulsed_inject or the inj_toggle function
end

/* Set up the circuitry to provide injection pulses to the network */
function make_pulsed_inject
    create pulsegen /inputsource // Make a periodic injection current step
    set_pulse_timing {pulse_delay} {pulse_width} {pulse_interval}
    setfield /inputsource level1 {injcurrent}
    addmsg /inputsource /network/cell[{InjCell}]/soma INJECT output
end

function make_input
    // First, remove any injection or other input
    setfield /network{cellname}[{InjCell}]/soma inject 0.0
    if ({exists /inputsource})
	delete /inputsource
    end
    if (input_model == "pulsed_inject")
        make_pulsed_inject // later add other options
    end
end

function set_frequency(frequency)
    float frequency
    setfield /network/cell[]/{synpath} frequency {frequency}
end

function make_output(rootname) // asc_file to {rootname}_{RUNID}.txt
    str rootname, filename
    if ({exists {rootname}})
        call {rootname} RESET // this closes and reopens the file
        delete {rootname}
    end
    filename = {rootname} @ "_" @ {RUNID} @ ".txt"
    create asc_file {rootname}
    setfield ^    flush 1    leave_open 1 filename {filename}
    setclock 1 {out_dt}
    useclock {rootname} 1
end

/* Create element to write netview data to a file
   See Scripts/orient_tut/V1_output.g
*/

function do_disk_out(diskpath,srcpath,field)
    str name, diskpath, srcpath, field, filename
    if ({exists /output/{diskpath}})
      	    delete /output/{diskpath}
    end
    if(binary_file==0) // use asc_file
        filename = {diskpath}  @ "_" @ {RUNID} @ ".txt"
	create asc_file /output/{diskpath}
        setfield /output/{diskpath} leave_open 1 flush 0 filename {filename}
        setfield /output/{diskpath} float_format %.3g notime 1
    else  // use disk_out to make FMT1 binary file
        filename = {diskpath}  @ "_" @ {RUNID} @ ".dat"
        create disk_out /output/{diskpath}
        setfield /output/{diskpath} leave_open 1 flush 0 filename {filename}
    end //if(binary_file==0)
    if({hflag} && {hsolve_chanmode > 1})  // hsolve with higher chanmodes
	foreach name ({getelementlist {srcpath}})
            addmsg {name}/../solver /output/{diskpath} SAVE \
                {findsolvefield {name}/../solver {name} Vm}
   	end
    else
        foreach name ({getelementlist {srcpath}})
            addmsg {name} /output/{diskpath} SAVE {field}
        end
    end
end

function do_network_out
   if(netview_output)
      do_disk_out {net_efile} /network/{cellname}[]/soma Vm
      useclock /output/{net_efile} 2
   end
end


function change_RUNID(value)
    str value
    RUNID =  value
    do_network_out
end

function do_run_summary
    str filename = {sum_file} @ "_" @ {RUNID} @ ".txt"
    openfile {filename} w
    writefile {filename} "Script:" {script_name} " RUNID:" {RUNID} " date:" {getdate}
    writefile {filename} "tmax:" {tmax} " dt:" {dt} " out_dt:" {out_dt} \
	" netview_dt:" {netview_dt}
    writefile {filename} "EPSC_output:" {EPSC_output} " netview_output:" \
         {netview_output}
    writefile {filename} "NX:" {NX} " NY:" {NY}
    writefile {filename} "SEP_X:" {SEP_X} " SEP_Y:" {SEP_Y}
    writefile {filename}  "bg Ex freq:" {frequency} " gmax:" {gmax}
    writefile {filename} "Injection:" {injcurrent} " Delay:" {pulse_delay} \
        " Width:" {pulse_width} " Interval:" {pulse_interval} \
        " To cell:" {InjCell}
    writefile {filename} "hflag:" {hflag} " hsolve chanmode:" {hsolve_chanmode} \
        " binary output file:" {binary_file} " use G3 hacks:" {G3_hacks}
    writefile {filename} "initial syn_weight:" {syn_weight} " gmax:" {gmax}
    writefile {filename} "---------------------------------------------------------------"
    writefile {filename} "Notes:"
    closefile {filename}
end

// Fake a pulsegen for G3 - this is also needed with G2 hsolve
function pulse_hack
    if(G3_hacks)
	step {pulse_delay} -time
	if({hsolve_chanmode > 1})
            setfield /network/cell[{InjCell}]/solver {findsolvefield \
                /network/cell[{InjCell}]/solver soma inject} {injcurrent}
            step {pulse_width} -time
            setfield /network/cell[{InjCell}]/solver {findsolvefield \
                /network/cell[{InjCell}]/solver soma inject} 0.0
        else
            setfield /network/cell[{InjCell}]/soma inject {injcurrent}
            step {pulse_width} -time
            setfield /network/cell[{InjCell}]/soma inject 0.0
        end
        step {tmax - pulse_width - pulse_delay} -time
    else
        step {tmax} -time
    end
end

function step_tmax
    echo {NX*NY}" cells    dt = "{getclock 0}"   tmax = "{tmax}
    echo "RUNID = " {RUNID}
    echo "START: " {getdate}
    pulse_hack
    echo "END  : " {getdate}
    do_run_summary
end

//=============================================================
//    Functions to set up the network
//=============================================================

function make_prototypes

  /* Step 1: Assemble the components to build the prototype cell under the
     neutral element /library.	This is done by including "prododefs.g"
     before using the function make_prototypes.
  */

// Now /library contains prototype channels, compartments, spikegen

  /* Step 2: Create the prototype cell specified in 'cellfile', using readcell.
     This should set up the apropriate synchans in specified compartments,
     with a spikegen element "spike" attached to the soma.  This will be
     done in /library, where it will be available to be copied into a network
  */

  readcell {cellfile} /library/cell
  setfield /library/cell/{synpath} gmax {gmax}
  setfield /library/cell/{synpath} Ek 0 // more realistic reversal potential
  setfield /library/cell/soma/spike thresh 0  abs_refract 0.004  output_amp 1
end

function make_network

  /* Step 3 - make a 2D array of cells with copies of /library/cell */
  // usage: createmap source dest Nx Ny -delta dx dy [-origin x y]

  /* There will be NX cells along the x-direction, separated by SEP_X,
     and  NY cells along the y-direction, separated by SEP_Y.
     The default origin is (0, 0).  This will be the coordinates of cell[0].
     The last cell, cell[{NX*NY-1}], will be at (NX*SEP_X -1, NY*SEP_Y-1).
  */

  createmap /library/cell /network {NX} {NY} -delta {SEP_X} {SEP_Y}
end // function make_network

function connect_cells
  /* Step 4: Now connect each cell to the four nearest neighbors.  Although
     the network is two-dimensional, the more general volumeconnect command
     is used here instead of planarconnect.
     Usage:
   
     volumeconnect source-path destination-path
         [-relative]
         [-sourcemask {box,ellipse} xmin ymin zmin xmax ymax zmax]
         [-sourcehole {box,ellipse} xmin ymin zmin xmax ymax zmax]
         [-destmask   {box,ellipse} xmin ymin zmin xmax ymax zmax]
         [-desthole   {box,ellipse} xmin ymin zmin xmax ymax zmax]
         [-probability p]
   */

  /* Connect each source spike generator to target synchans within the
     specified range.  Set the ellipse axes or box size just higher than the
     cell spacing, to be sure cells are included.  To connect to nearest
     neighbors and the 4 diagonal neighbors, use a box:
       -destmask box {-SEP_X*1.01} {-SEP_Y*1.01} {SEP_X*1.01} {SEP_Y*1.01}
     For all-to-all connections with a 10% probability, set both the sourcemask
     and the destmask to have a range much greater than NX*SEP_X using options
       -destmask box -1 -1  1  1 \
       -probability 0.1
     Set desthole to exclude the source cell, to prevent self-connections.
  */

  float SEP_Z = 1.0e-6 // give it a tiny z range in case of round off errors
  volumeconnect /network/cell[]/soma/spike /network/cell[]/{synpath} \
    -relative \	    // Destination coordinates are measured relative to source
    -sourcemask box -1 -1 -1 1 1 1 \   // Larger than source area ==> all cells
    -destmask ellipsoid 0 0 0 {SEP_X*1.2}  {SEP_Y*1.2} {SEP_Z*0.5} \
    -probability 1.1	// set probability > 1 to connect to all in destmask

  /* Step 5: Set the axonal propagation delay and weight fields of the target
     synchan synapses for all spikegens.  To scale the delays according to
     distance instead of using a fixed delay, use
       volumedelay /network/cell[]/soma/spike -radial {cond_vel}
     and change dialogs in graphics.g to set cond_vel.  This would be
     appropriate when connections are made to more distant cells.  Other
     options of planardelay and planarweight allow some randomized variations
     in the delay and weight.
  */

  set_delays {prop_delay}
  set_weights {syn_weight}
end // function connect_cells


//===============================
//    Main Simulation Section
//===============================

setclock  0  {dt}		// set the simulation clock


// create prototype definitions used by the cell parameter file 'cellfile'
include protodefs_rsnet.g  // This creates /library with the cell components

make_prototypes // This adds the prototype cells to /library

make_network    // Copy cells into network layers

// If hsolve is used, make a solver for cell[0] and duplicate for others
if(hflag)
    pushe /network/cell[0]
    create hsolve solver
    setmethod solver 11 
    setfield solver chanmode {hsolve_chanmode} path "../[][TYPE=compartment]"
    call solver SETUP
    int i
    for (i = 1 ; i < {NX*NY} ; i = i + 1)
        call solver DUPLICATE \
            /network/cell[{i}]/solver  ../##[][TYPE=compartment]
	setfield /network/cell[{i}]/solver \
            x {getfield /network/cell[{i}]/soma x} \
            y {getfield /network/cell[{i}]/soma y} \
            z {getfield /network/cell[{i}]/soma z}
    end
    pope
end

if (G3_hacks)
	call model_container NEUROSPACES_COMMAND "expand /network/cell[1023]/**"

// ---
// - /network/cell[1023]
// - /network/cell[1023]/soma
// - /network/cell[1023]/soma/Na_pyr_dp
// - /network/cell[1023]/soma/Na_pyr_dp/HH_activation
// - /network/cell[1023]/soma/Na_pyr_dp/HH_activation/A
// - /network/cell[1023]/soma/Na_pyr_dp/HH_activation/B
// - /network/cell[1023]/soma/Na_pyr_dp/HH_inactivation
// - /network/cell[1023]/soma/Na_pyr_dp/HH_inactivation/A
// - /network/cell[1023]/soma/Na_pyr_dp/HH_inactivation/B
// - /network/cell[1023]/soma/Kdr_pyr_dp
// - /network/cell[1023]/soma/Kdr_pyr_dp/HH_activation
// - /network/cell[1023]/soma/Kdr_pyr_dp/HH_activation/A
// - /network/cell[1023]/soma/Kdr_pyr_dp/HH_activation/B
// - /network/cell[1023]/soma/KM_pyr_dp
// - /network/cell[1023]/soma/KM_pyr_dp/HH_activation
// - /network/cell[1023]/soma/KM_pyr_dp/HH_activation/A
// - /network/cell[1023]/soma/KM_pyr_dp/HH_activation/B
// - /network/cell[1023]/soma/Ex_channel
// - /network/cell[1023]/soma/Ex_channel/eq2
// - /network/cell[1023]/soma/Ex_channel/synapse
// - /network/cell[1023]/soma/spike

end

if (G3_hacks)
	call model_container NEUROSPACES_COMMAND "algorithminstance CreateMap"
end

if (connect_network)
    connect_cells   // Make the network connections
end

if (G3_hacks)
	call model_container NEUROSPACES_COMMAND "algorithminstance Volume"
end

make_input

// Create disk_out element /output/{net_efile}
if (netview_output)
    do_network_out
end


// include the graphics functions
if(graphics)
    include RSnet2-graphics.g
    // make the control panel
    make_control
    // make the graph to display soma Vm and pass messages to the graph
    make_Vmgraph

    /* To eliminate net view and run faster set netview = 0 */
    if(netview)
            make_netview
    end
    colorize
end // if(graphics)

reset
if (!{hflag})
    check
end

reset
echo "Network of "{NX}" by "{NY}" cells with separations "{SEP_X}" by "{SEP_Y}

if(batch)
    change_RUNID "0000b"
    step_tmax
end
