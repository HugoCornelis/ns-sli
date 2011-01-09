// genesis - Requires GENESIS 2.3

/* Adapted from the GENESIS 2 script replay_netview.g, which reads binary
   disk_out files produced by the ACnet2 auditory cortex simulations.  It
   uses the G2/XODUS xview widget to display network activity of cells on a
   two-dimensional grid with the soma Vm represented by color.  It also
   makes Vm plots of the middle cell of specified rows of cells.  The
   simulation parameters are obtained from a "run summary" text file
   "run_summary_<RUNID>.txt, for a given run ID string.

   By including analysis_funcs-RSnet2.g (a variant of analysis_funcs.g),
   it performs analysis of network spiking activity, producing spike
   frequency distribution histograms, and output files suitable for
   the G3 Python tools rasterplot.py and rowrateplot.py.

   This version, replay_RSnet2.g, for files produced by the demonstration
   script RSnet2.g and variants, examines only the excitatory cells.  It
   does not calculate frequency spectra of summed EPS synaptic currents.

  This script will be used as a prototype for python-based G3 graphical
  and analysis tools, and will eventually be replaced by python code.
*/   

str RUNID = "0000"        // default ID string for data file names
int debug = 1             // flag to print addtional info to console


/* These defaults will be changed by function load_params to values in
    {sum_file}_{RUNID}.txt.  The value of {dt} for clock 0 will be set to
    that used in the simulation, but most of the work in this script is
    done by clock 1 with step {out_dt} (for the summed EPS current file),
    and clock 2 with step {netview_dt}, which is used for the disk_in
    objects and the netview display.  It is the clock for any analysis
    that uses soma Vm data vs. time for the network Ex_cells and Inh_cells.
    The frequency_monitor, rasterplot, and the functions used for
    calculating average spike frequencies for groups of neurons use
    clock 3 to set the width of the bins for frequency(time)
    {freq_binwidth}.  Clock 4 is a very long clock used to prevent
    calculator objects from reseting at the end of a clock step.
*/

float dt = 50e-6          // simulation time step for clock 0
float netview_dt = 0.0002 // slowest clock for netview display
float out_dt = 0.0001     // clock used for the summed EPS current file
float tmax = 0.5          // max simulation run time (sec)
int EPSC_output = 0       // did simulation output summed EPS current?
int netview_output = 1    // did simulation output Vm for all network cells?

// These are NOT set by load_params
int plot_spikedist = 1 // make a histogram of spike frequency distribution
int plot_spikefreq = 1 // hack until I get consistent
int write_spikefreqs = 1 // write file of average freq(t) for each targ_row
int netview_output = 1
int binary_file = 1 // output file is binary FMT1

// Additional definitions for calculating spike times for raster plots
// used in analysis_funcs.g

// Added delay between time steps to slow down the  netview display
float frame_delay = 2.5*netview_dt/tmax

str net_efile = "Ex_net_Vm" // filename prefix for Ex_netview data
str sum_file = "run_summary" // text file prefix for summary of run params

// Default values may be changed by load_params, but views will not be resized!
int Ex_NX = 32; int Ex_NY = 32
float Ex_SEP_X = 0.001
float Ex_SEP_Y = 0.001

/* These are definitions for compatibility with functions that are used in
   the auditory cortex simulation, and are NOT read with load_params
*/

// originally number of input channels, now = number of rows
int Ninputs = {Ex_NY} 

// Used to give integer rows/octave in the auditory cortex simulation
// The value is arbitrary here.
float octave_distance = 0.96e-3 // approx 1 mm/octave

int rows_per_octave = 0  // hack to allow use of ACnet code

int n_per_row = 1 // number of cells per row to use in raster plot
str spikedata ="/spike_data"  // name of the array of spike time tables

/* ==================================================================
              Function Definitions
   ==================================================================
*/

/* Get network simulation  parameters from run_summary file */
function load_params  // This should be called early on to set parameters
    str filename
    str linelist // Will hold a line read from {filename}
    filename = {"run_summary_" @ {RUNID} @ ".txt"}
    if ({fileexists {filename}})
        openfile {filename} r
        readfile {filename} // skip line 1 with script_name, RUNID, seed, date
        // This is a trick to separately get multiple values on one line
        // without doing another read
        linelist = {readfile {filename} -l} // Line 2 has tmax and clocks
        tmax = {getarg {arglist {linelist}} -arg 2}
        dt = {getarg {arglist {linelist}} -arg 4}
        out_dt = {getarg {arglist {linelist}} -arg 6}
        netview_dt = {getarg {arglist {linelist}} -arg 8}
        linelist = {readfile {filename} -l}  // Line 3 has output flags
        EPSC_output = {getarg {arglist {linelist}} -arg 2}
        netview_output = {getarg {arglist {linelist}} -arg 4}
        linelist = {readfile {filename} -l}  // Line 4 has number of cells
        Ex_NX = {getarg {arglist {linelist}} -arg 2}
        Ex_NY = {getarg {arglist {linelist}} -arg 4}
        linelist = {readfile {filename} -l}  // Line 5 has cell separations
        Ex_SEP_X = {getarg {arglist {linelist}} -arg 2}        
        Ex_SEP_Y = {getarg {arglist {linelist}} -arg 4}        
        closefile {filename}
        frame_delay = 2.5*netview_dt/tmax // set appropriate display delay
    else
        echo "File " {filename} " does not exist!"
    end
end // function load_params

function step_tmax
    echo "dt = "{getclock 0}"   tmax = "{tmax}
    echo "START: " {getdate}
    step {tmax} -time
    echo "END  : " {getdate}
end

/*  Utility functions used by the GUI */

extern load_summary
extern open_files
extern make_netview
extern make_graph_messages
extern make_time_data_table
function change_stepsize(dialog)
   str dialog
   dt =  {getfield {dialog} value}
   setclock 0 {dt}
   echo "Changing step size to "{dt}
end

function change_runtime(dialog)
   str dialog
   tmax =  {getfield {dialog} value}
end

/* This does most of the setup and opens the data files to be used */
function change_RUNID(dialog)
    str dialog, filename
    RUNID =  {getfield {dialog} value}
    filename =  {{sum_file} @ "_" @ {RUNID} @ ".txt"}
    if ({fileexists {filename}})  // Only check for the summary file
        load_params
        // this should be generalized
        setfield /control/runtime value {tmax}
        setfield /control/stepsize value {dt}
        setfield /control/frame_delay value {frame_delay}
        load_summary
        setfield /control/spike_filename value spike_times_{RUNID}.txt
        open_files
        make_graph_messages
        setfield /data/##[ISA=xgraph] xmax {tmax}
        if (plot_spikefreq)
            setfield /freq_form/frequency xmax {tmax}
        end
    else // file doesn't exist
         setfield {dialog} value "0000"
    end
end

function change_frame_delay(dialog)
   str dialog
   frame_delay =  {getfield {dialog} value}
   setfield /frame_delay command "sleep "{frame_delay}
end

/* ==================================================================
   Graphics tools used in many "graphics.g" scripts
   ==================================================================
*/
/*  A subset of the functions defined in genesis/startup/xtools.g
    These are used to provide a "scale" button to graphs.
    "makegraphscale path_to_graph" creates the button and the popup
     menu to change the graph scale.
*/

function setgraphscale(graph)
    str graph
    str form = graph @ "_scaleform"
    str xmin = {getfield {form}/xmin value}
    str xmax = {getfield {form}/xmax value}
    str ymin = {getfield {form}/ymin value}
    str ymax = {getfield {form}/ymax value}
    setfield {graph} xmin {xmin} xmax {xmax} ymin {ymin} ymax {ymax}
    xhide {form}
end

function showgraphscale(form)
    str form
    str x, y
    // find the parent form
    str parent = {el {form}/..}
    while (!{isa xform {parent}})
        parent = {el {parent}/..}
    end
    x = {getfield {parent} xgeom}
    y = {getfield {parent} ygeom}
    setfield {form} xgeom {x} ygeom {y}
    xshow {form}
end

function makegraphscale(graph)
    if ({argc} < 1)
        echo usage: makegraphscale graph
        return
    end
    str graph
    str graphName = {getpath {graph} -tail}
    float x, y
    str form = graph @ "_scaleform"
    str parent = {el {graph}/..}
    while (!{isa xform {parent}})
        parent = {el {parent}/..}
    end

    x = {getfield {graph} x}
    y = {getfield {graph} y}

    create xbutton {graph}_scalebutton  \
        [{getfield {graph} xgeom},{getfield {graph} ygeom},50,25] \
           -title scale -script "showgraphscale "{form}
    create xform {form} [{x},{y},180,170] -nolabel

    disable {form}
    pushe {form}
    create xbutton DONE [10,5,55,25] -script "setgraphscale "{graph}
    create xbutton CANCEL [70,5,55,25] -script "xhide "{form}
    create xdialog xmin [10,35,160,25] -value {getfield {graph} xmin}
    create xdialog xmax [10,65,160,25] -value {getfield {graph} xmax}
    create xdialog ymin [10,95,160,25] -value {getfield {graph} ymin}
    create xdialog ymax [10,125,160,25] -value {getfield {graph} ymax}
    pope
end

/* Add some interesting colors to any widgets that have been created */
function colorize
    setfield /##[ISA=xlabel] fg white bg blue3
    setfield /##[ISA=xbutton] offbg rosybrown1 onbg rosybrown1
    setfield /##[ISA=xtoggle] onfg red offbg cadetblue1 onbg cadetblue1
    setfield /##[ISA=xdialog] bg palegoldenrod
    setfield /##[ISA=xgraph] bg ivory
end

// function to return a color name from an index into the colorlist
// Usage example: str color = {colors 3}
function colors(col_num)
    int col_num
    str colorlist = "black blue cyan green magenta red orange"
    str color
    // convert col_num to range 1 though 7
    col_num = col_num - {trunc {col_num/7.0}}*7 + 1
    color = {getarg {arglist {colorlist}} -arg {col_num}}
    return {color}
end


/*
The function "sumwindow" (adapted from "textwindow" creates a form 600 pixels wide 
and 336 pixels high at x,y to display the specified text file with scrolling and
paging.  Using the default font (7x13bold), this provides room for 24 lines with
78 characters per line and a one character right and left margin.  (The left
margin is provided automatically.)
*/

//=====================================================================
// sumwindow formpath,x,y
// creates a form 600 pixels wide and 336 pixels high at x,y to display
// the specified text file with scrolling and paging
//=====================================================================
function sumwindow(formpath, x, y)
   str formpath, textfile
   int x, y, width, height
   height = 336
   width = 600
   create xform {formpath} [{x},{y},{width},{height}] -nolabel
   pushe {formpath}
   create xlabel textbar [40,0,{100*(width - 40)/width}%,20] -label  \
     "Click and drag the left mouse button on the scroll bar to scroll the text"
   create xbutton DONE [0,0,40,20] -script "xhide "{formpath}
   create xtext run_summary [0%,20,100%,94%] -bg white
   pope
   xshow {formpath}
end

//==================================
//    Functions to set up the GUI
//==================================

function make_control
    create xform /control [0,0,270,315]
    pushe /control
    create xlabel label -hgeom 25 -bg cyan -label "CONTROL PANEL"
    create xbutton RESET -wgeom 25%       -script reset
    create xbutton RUN  -xgeom 0:RESET -ygeom 0:label -wgeom 25% \
         -script step_tmax
    create xbutton STOP  -xgeom 0:RUN -ygeom 0:label -wgeom 25% \
         -script stop
    create xbutton QUIT -xgeom 0:STOP -ygeom 0:label -wgeom 25% -script quit
    create xdialog RUNID -title "RUNID string:" -value {RUNID} \
                -script "change_RUNID <widget>"
    create xdialog stepsize -title "dt (sec)" -value {netview_dt} \
                -script "change_stepsize <widget>"
    create xdialog runtime -title "runtime (sec)" -value {tmax} \
                -script "change_runtime <widget>"
    create xdialog frame_delay -title "frame delay (sec)" -value {frame_delay} \
                -script "change_frame_delay <widget>"
    create xbutton show_spectrum  -wgeom 50% -title "Show spectrum" \
        -script "echo Not implemented"
    create xbutton show_spikefreq -wgeom 50% -ygeom 0:frame_delay \
        -xgeom 0:show_spectrum -title "Show spike rate" \
        -script "xshow /freq_form"
    create xbutton show_ratedist -ygeom 0:show_spectrum \
	-title "Show avg spike rate distribution" -script "xshow /histform"
    create xbutton write_rasterfile -title "Write spike times to file" \
        -script do_write_rasterfile
    create xdialog spike_filename -title Filename \
        -value spike_times_{RUNID}.txt
    create xdialog n_per_row -title "cells/row to record" -value {n_per_row} \
        -script "change_n_per_row <widget>"
    pope
    xshow /control

end

function load_summary
    str filename
    filename = {"run_summary_" @ {RUNID} @ ".txt"}
    if ({fileexists {filename}})
        setfield /summary_form/run_summary filename {filename}
    else
        echo "File " {filename} " does not exist!"
    end
end

function make_Vmgraph
    str graph_form = "/data"
    str graphlabel = "Vm of center cell in row"
    float vmin = -0.07
    float vmax = 0.65
    create xform {graph_form} [275,0,400,600]
    pushe {graph_form}
    create xlabel label -label {graphlabel}
    create xgraph voltage -hgeom 100% -title "Ex_cell Membrane Potential" !
    setfield ^ XUnits sec YUnits V
    setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
    makegraphscale {graph_form}/voltage
    useclock voltage 2 // the clock used to write the netview file
    pope
    xshow {graph_form}
end

function make_netview  // sets up xview widget to display Vm of each cell
    // Adjust the aspect ratio for rectangular networks of width around 400
    // Make view for Ex_cell[]
    int npixels = 2*{round {180/Ex_NX}}
    int Ex_view_width = npixels*Ex_NX + 20
    int Ex_view_height = npixels*Ex_NY + 17
    if ({exists /Ex_netview})  // make a new one of the right size
        delete /Ex_netview
    end
    create xform /Ex_netview [680,0,{Ex_view_width},{Ex_view_height}]
    create xdraw /Ex_netview/draw [0%,0%,100%, 100%]
    // Make the display region a little larger than the cell array
    setfield /Ex_netview/draw xmin {-Ex_SEP_X} xmax {Ex_NX*Ex_SEP_X} \
        ymin {-Ex_SEP_Y} ymax {Ex_NY*Ex_SEP_Y}
    create xview /Ex_netview/draw/view
    setfield /Ex_netview/draw/view value_min -0.08 value_max 0.04 \
        viewmode colorview morph_val 0 sizescale {Ex_SEP_X}
    useclock /Ex_netview/draw/view 2 // clock used to write netview file
    xshow /Ex_netview
end

/* NOTE: The option "binary_file = 0" does not work properly under
   GENESIS 2, because the ascii mode of disk_in (fileformat 1) reads
   one line per time step, and does not permit more than 16 Vm values
   per line.
*/

function open_files
    str filename
    if ({exists /Ex_diskin})
        delete /Ex_diskin
    end
    if (binary_file)  // FMT1 disk_out file
        filename = {{net_efile} @ "_" @ {RUNID} @ ".dat"}
    else // text file produced by asc_file
        filename = {{net_efile} @ "_" @ {RUNID} @ ".txt"}
    end

    if ({fileexists {filename}})
        create disk_in /Ex_diskin
        setfield /Ex_diskin  filename {filename}  leave_open 1
        if (binary_file)  // FMT1 disk_out file
            setfield /Ex_diskin fileformat 1
        else // ascii file
            setfield /Ex_diskin fileformat 0
            setfield /Ex_diskin nx {Ex_NX} ny {Ex_NY}
        end
        setclock 2 {netview_dt}
        useclock /Ex_diskin 2
        call /Ex_diskin RESET
    else
        echo {filename} " does not exist!"
    end
end // function open_files

/* Functions to drop and add plots of Vm for middle cell of input target row */

function drop_Vmplot(input_num)
    int input_num, del_num, n, count
    str label, msglabel
    label = "row_" @ {input_num}
    if ((input_num < 1) || (input_num > Ninputs))
        echo "Input number must be in the range 1 to " {Ninputs}
        return
    end
    count = {getmsg /data/voltage -in -count}
    del_num = -1 // set to < 0 initially, then look for message to delete
    for (n = 0; n < count; n = n +1)
        msglabel = {getmsg /data/voltage -in -slot {n} 1 }
        if ({msglabel} == {label})
            del_num = n
            echo "Dropping plot " {n} "    " {msglabel}
        end
    end
    if (del_num >= 0)
            deletemsg /data/voltage {del_num} -in
    else
        echo "A plot for input" {input_num} " does not exist."
    end
end

function add_Vmplot(input_num)
    int input_num, cell_num, dup_num, n, count, i, j
    if ((input_num < 1) || (input_num > Ninputs))
        echo "Input number must be in the range 1 to " {Ninputs}
        return
    end
    str label, msglabel
    float offset
    float delta_y = 0.02 // vertical displacement of subsequent plots
    // target is middle cell in row targeted by input_num
    // rows_per_octave is non-zero only for the auditory cortex simulation
    cell_num = ({round {rows_per_octave/3.0}} + input_num -1)*Ex_NX \
        + {round {(Ex_NX -1)/2.0}}
    // generate PLOTSCALE options  {value} *{label} *{color} scale offset
    label = "row_" @ {input_num}
    offset = (input_num - 1)*delta_y

    count = {getmsg /data/voltage -in -count}
    dup_num = -1  // default is that the message doesn't already exist
    for (n = 0; n < count; n = n +1)
        msglabel = {getmsg /data/voltage -in -slot {n} 1 }
        if ({msglabel} == {label})
            dup_num = n
            echo "Plot " {n} "  " {msglabel} " already exists"
        end
    end
    if (dup_num < 0)
        if(binary_file)
            addmsg /Ex_diskin /data/voltage PLOTSCALE val[0][{cell_num}] \
              *{label} *{colors {input_num}} 1 {offset}
        else // ascii text
            j = {trunc {cell_num/Ex_NX}}
            i = cell_num - Ex_NX*j
            addmsg /Ex_diskin /data/voltage PLOTSCALE val[{i}][{j}] \
                *{label} *{colors {input_num}} 1 {offset}
        end
    end
end

extern make_freqmon // defined below analysis_funcs
extern make_freqmon_messages 

/*****		   include analysis_funcs.g		  ******/
include analysis_funcs-RSnet2.g  // functions for spike analysis

/* Function used in control panel to output spike time data to a file for
   raster plots.
*/
function do_write_rasterfile
    str form = "/control"
    str spike_time_file = {getfield {form}/spike_filename value}
    int Nplots = n_per_row*Ninputs  // these are both globals
    make_spike_time_file {Nplots} {spike_time_file} {spikedata}
    if (debug)
        echo "Wrote spike time data file "{spike_time_file}
    end
end

// Warning - This will reset the run and allocate new spike_data tables
function change_n_per_row(dialog)
    str dialog
    n_per_row =	 {getfield {dialog} value}
    change_RUNID /control/RUNID
end

/* Set up plotting messages to the graphs and netviews from disk_in objects */
function make_graph_messages
    int i, j
    int nx = {getfield /Ex_diskin nx}
    int ny = {getfield /Ex_diskin ny}
    // Set up messages to the views
    // For FMT1 files, nx = 1 and x index is 0
    if (binary_file)
        for (j = 0; j < ny; j = j + 1)
            addmsg /Ex_diskin /Ex_netview/draw/view VAL1 val[0][{j}]
        end
        // call /Ex_diskin RESET
        reset // It is evidently not sufficient to reset just the diskins here
        // After a reset, this properly initializes position of shapes in view
        // However the following lines sometimes cause an error 
        // "src table /Ex_diskin/ xpts not allocated"
        setfield /Ex_netview/draw/view xpts /Ex_diskin/xpts
        setfield /Ex_netview/draw/view ypts /Ex_diskin/ypts
        setfield /Ex_netview/draw/view zpts /Ex_diskin/zpts
    else // ascii file
        for (i=0;i < Ex_NX; i = i + 1)
            for (j=0;j < Ex_NY; j = j + 1)
                addmsg /Ex_diskin /Ex_netview/draw/view VAL1  val[{i}][{j}]
            end
         end
    end

    // Set up messages to the Vm graphs
    add_Vmplot  1
    add_Vmplot  6
    add_Vmplot  13
    add_Vmplot  20
    add_Vmplot  25
    add_Vmplot  32

    // make tables and messages for spike times - from analysis_funcs
    setup_rasterplot {n_per_row}  // n_per_row is globally defined

    if (plot_spikefreq)
        make_freqmon
        make_freqmon_messages 0 // default row 0 means calc for all rows
        change_binwidth {getclock 3}
        setfield /freq_form/#[ISA=xgraph] xmax {tmax}
        make_rate_dist // make spike rate distribution histogram with controls
    end

    if (write_spikefreqs)
        make_freq_file
    end

end // function make_graph_messages

/* ========================== Main program =========================== */


// load_params // Override many of the defaults
if (debug)
    echo "out_dt = " {out_dt} "    netview_dt = " {netview_dt}
end
setclock 0 {dt} // default clock - most of the work is done by 1 and 2

open_files
make_control
make_Vmgraph
make_netview
sumwindow /summary_form 1048 0
load_summary

make_freq_graph 1048 368

make_graph_messages

xshow /freq_form

if (plot_spikedist)
    make_hist
    xshow /histform
    make_rate_dist
end

// Slow down the display
create script_out /frame_delay
useclock /frame_delay 2
setfield /frame_delay command "sleep "{frame_delay}

colorize
reset
