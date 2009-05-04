//genesis - Purkinje cell version M9 genesis2.1 master script
/* Copyright E. De Schutter (Caltech and BBF-UIA) */

/* This script simulates a Purkinje cell in vivo, receiving a climbing
**  fiber input combined with asynchronous background inputs from
**  parallel fibers (phertz sets mean frequency)and stellate cells
**  (ihertz) */

/* Reference:
** E. De Schutter and J.M. Bower: An active membrane model of the
** cerebellar Purkinje cell: II. Simulation of synaptic responses.
** Journal of Neurophysiology  71: 401-419 (1994).
** http://www.bbf.uia.ac.be/TNB/TNB_pub7.html
** We reconstruct parts of Fig. 11
** See http://www.bbf.uia.ac.be/models/PM9.shtml for general model info.
*/

randseed 
// float phertz = 25
// float ihertz = 1
// float delay = 0.00020	/* sets speed of climbing fiber volley */

str filename = "results/PurkM9_CSp" @ "_none_" @ "Hz_i" @ "_none_" @ "Hz"
echo file {filename}
int i
float t
include defaults
cellpath="/Purkinje"
str hstr

/*********************************************************************
** Active membrane lumped Purkinje cell model script  (#2M9)
** E. De Schutter, Caltech 1991-1993 
** Uses the scripts:	Purk_chan, Purk_cicomp, Purk_const, Purk_syn
*********************************************************************/
/* Purkinje cell constants */
include Purk_const.g 
EREST_ACT = -0.055	/* dendrite is depolarized by synaptic inputs */

// /* special scripts  to create the prototypes */
// include Purk_chan 
// include Purk_cicomp
include Purk_cicomp_passive
// include Purk_syn 

/* To ensure that all subsequent elements are made in the library */
ce /library

/* These make the prototypes of channels and compartments that can be
**  invoked in .p files */
// make_Purkinje_chans
// make_Purkinje_syns

// // set the firing frequencies at the library level
// setfield /library/GABA frequency {ihertz}
// setfield /library/non_NMDA frequency {phertz}

make_Purkinje_comps
make_Purkinje_spines

echo /model_container NEUROSPACES_QUERY
call /model_container NEUROSPACES_QUERY

/* create the model and set up the run cell mode */
// read cell date from .p file and make hsolve element
readcell tests/scripts/PurkM9_model/Purk2M9s.p {cellpath} -hsolve

// /* make climbing fiber presynaptic elements */
// create neutral {cellpath}/climb_presyn1
// disable {cellpath}/climb_presyn1
// setfield {cellpath}/climb_presyn1 z 0
// addmsg {cellpath}/climb_presyn1 {cellpath}/main[0-2]/climb ACTIVATION z
// create neutral {cellpath}/climb_presyn2
// disable {cellpath}/climb_presyn2
// setfield {cellpath}/climb_presyn2 z 0
// addmsg {cellpath}/climb_presyn2 {cellpath}/main[3-8]/climb ACTIVATION z
// create neutral {cellpath}/climb_presyn3
// disable {cellpath}/climb_presyn3
// setfield {cellpath}/climb_presyn3 z 0
// addmsg {cellpath}/climb_presyn3 {cellpath}/br1[0-6]/climb ACTIVATION z
// addmsg {cellpath}/climb_presyn3 {cellpath}/br2[0-6]/climb ACTIVATION z
// create neutral {cellpath}/climb_presyn4
// disable {cellpath}/climb_presyn4
// setfield {cellpath}/climb_presyn4 z 0
// addmsg {cellpath}/climb_presyn4 {cellpath}/br1[7-12]/climb ACTIVATION z
// addmsg {cellpath}/climb_presyn4 {cellpath}/br2[7-12]/climb ACTIVATION z
// addmsg {cellpath}/climb_presyn4 {cellpath}/br3[0-8]/climb ACTIVATION z
// create neutral {cellpath}/climb_presyn5
// disable {cellpath}/climb_presyn5
// setfield {cellpath}/climb_presyn5 z 0
// addmsg {cellpath}/climb_presyn5 {cellpath}/br1[13-20]/climb ACTIVATION z
// addmsg {cellpath}/climb_presyn5 {cellpath}/br2[13-21]/climb ACTIVATION z
// addmsg {cellpath}/climb_presyn5 {cellpath}/br3[9-16]/climb ACTIVATION z


/* Set the clocks */
for (i = 0; i <= 7; i = i + 1)
    setclock {i} {dt}
end
setclock 8 1.0e-4
setclock 9 1

/* Create the output element */
create asc_file /output/plot_out
useclock /output/plot_out 0

// setup the hines solver
ce {cellpath}
/* chanmode 3 is most efficient, calcmode 0 is needed for backward 
** compatibility (this version M9 of the Purkinje cell model only!)
*/
setfield comptmode 1 chanmode 3  calcmode 0
call . SETUP
setmethod 11

/* Initialize output */
/* Output voltage as from soma */
// hstr={findsolvefield {cellpath} {cellpath}/soma Vm}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
setfield /output/plot_out filename {filename} initialize 1 append 1 leave_open 1
addmsg {cellpath} /output/plot_out SAVE {findsolvefield {cellpath} {cellpath}/soma Vm}

//t this is currently a hack: the ascfile gets a RESET after the
//t nsintegrator, such that it does not have a backend yet.  The
//t nsintegrator needs the asc file backend for SetupIOMessages().
//t the temporary solution is a hardcoded RESET of the ascfile
//t overhere.

call /output/plot_out RESET

reset

setfield {cellpath} {findsolvefield {cellpath} {cellpath}/soma inject} 1e-6

// useclock /output/plot_out 9 /* disable output */
t = {rand 0.170 0.200}
step {t} -time		/* initial equilibration */
// useclock /output/plot_out 8 /* enable output */

// step 0.2 -time

// /* fire climbing fiber input as an ascending volley */
// setfield {cellpath}/climb_presyn1 z  1
// step 1
// setfield {cellpath}/climb_presyn1 z  0
// step {delay} -time
// setfield {cellpath}/climb_presyn2 z  1
// step 1
// setfield {cellpath}/climb_presyn2 z  0
// step {delay} -time
// setfield {cellpath}/climb_presyn3 z  1
// step 1
// setfield {cellpath}/climb_presyn3 z  0
// step {delay} -time
// setfield {cellpath}/climb_presyn4 z  1
// step 1
// setfield {cellpath}/climb_presyn4 z  0
// step {delay} -time
// setfield {cellpath}/climb_presyn5 z  1
// step 1
// setfield {cellpath}/climb_presyn5 z  0
// step {delay} -time

// step 0.1 -time

// quit

