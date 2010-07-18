//genesis - Purkinje cell version M9 genesis2.1 master script
/* Copyright E. De Schutter (Caltech and BBF-UIA) */

/* This script simulates a Purkinje cell in vivo, receving asynchronous
**  background inputs from parallel fibers (phertz sets mean frequency)
**  and stellate cells (ihertz) */

/* Reference:
** E. De Schutter and J.M. Bower: An active membrane model of the
** cerebellar Purkinje cell: II. Simulation of synaptic responses.
** Journal of Neurophysiology  71: 401-419 (1994).
** http://www.bbf.uia.ac.be/TNB/TNB_pub7.html
** Recreate part of Fig. 7.
** See http://www.bbf.uia.ac.be/models/PM9.shtml for general model info.
*/

randseed 999
float phertz = 28
float ihertz = 1

str filename = "results/PurkM9_p" @ (phertz) @ "Hz_i" @ (ihertz) @ "Hz"
echo file {filename}
int i
float t
include defaults
cellpath="/Purkinje"
str hstr

/*********************************************************************
** Active membrane lumped Purkinje cell model script  (#2M9)
** E. De Schutter, Caltech 1991-1993 
** Uses the scripts:	Purk_chan, Purk_icomp, Purk_const, Purk_syn
*********************************************************************/
/* Purkinje cell constants */
include Purk_const.g 
EREST_ACT = -0.055	/* dendrite is depolaized by synaptic inputs */

/* special scripts  to create the prototypes */
include Purk_chan 
include Purk_icomp
include Purk_syn 

/* To ensure that all subsequent elements are made in the library */
ce /library

/* These make the prototypes of channels and compartments that can be
**  invoked in .p files */
make_Purkinje_chans
make_Purkinje_syns

// set the synaptic firing frequencies at the library level
setfield /library/GABA frequency {ihertz}
setfield /library/non_NMDA frequency {phertz}

make_Purkinje_comps
make_Purkinje_spines

/* create the model and set up the run cell mode */
// read cell date from .p file and create hsolve element
readcell  tests/scripts/PurkM9_model/Purk2M9s.p {cellpath} -hsolve

/* Set the clocks */
echo "setting simulation clocks to " {dt}
for (i = 0; i <= 7; i = i + 1)
    setclock {i} {dt}
end
setclock 8 1.0e-4
setclock 9 1

// /* Create the output element */
// create asc_file /output/plot_out
// useclock /output/plot_out 9

// setup the hines solver
ce {cellpath}
/* chanmode 3 is most efficient, calcmode 0 is needed for backward 
** compatibility (this version M9 of the Purkinje cell model only!)
*/
setfield chanmode 4  calcmode 0
call . SETUP
setmethod 11

// /* Initialize output */
// /* Output voltage from soma */
// hstr={findsolvefield {cellpath} {cellpath}/soma Vm}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
// setfield /output/plot_out filename {filename} initialize 1 append 1 leave_open 1

reset
echo "START: "{getdate}
step 0.5 -time
echo "END: "{getdate}
quit
