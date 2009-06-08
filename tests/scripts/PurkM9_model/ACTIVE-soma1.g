//genesis - Purkinje cell version M9 genesis2.1 master script
/* Copyright E. De Schutter (Caltech and BBF-UIA) */

/* This script simulates a somatic current injection in slice */

/* Reference:
** E. De Schutter and J.M. Bower: An active membrane model of the
** cerebellar Purkinje cell. I. Simulation of current clamps in slice.
** Journal of Neurophysiology  71: 375-400 (1994).
** http://www.bbf.uia.ac.be/TNB/TNB_pub8.html
** We reconstruct parts of Fig 3 and of Fig. 11.
** See http://www.bbf.uia.ac.be/models/PM9.shtml for general model info.
*/

float inject = 0.03
str filename = "results/PurkM9_soma_only_" @ {inject} @"nA"
echo {filename}
int i
include defaults
cellpath =  "/Purkinje"
str hstr

/*********************************************************************
** Active membrane Purkinje cell model script  (#2M9)
** E. De Schutter, Caltech 1991-1992 
** Uses the scripts:	Purk_chan, Purk_comp, Purk_const, Purk_syn
*********************************************************************/

/* Purkinje cell constants */
include Purk_const 

/* special scripts  to create the prototypes */
include Purk_chan 
include Purk_comp 
include Purk_syn 

/* To ensure that all subsequent elements are made in the library */
ce /library

/* These make the prototypes of channels and compartments that can be
**  invoked in .p files */
make_Purkinje_chans
make_Purkinje_comps

/* create the model and set up the run cell mode */
// read cell data from .p file and create hsolve element
readcell tests/scripts/PurkM9_model/Purk2M9_soma.p {cellpath} -hsolve

call /model_container NEUROSPACES_QUERY

/* Set the clocks */
for (i = 0; i <= 8; i = i + 1)
    setclock {i} {dt}
end
setclock 9 1.0e-4

/* Create the output element */
create asc_file /output/plot_out
useclock /output/plot_out 9

// setup the hines solver
ce {cellpath}
/* we need chanmode 4 for output of Ik and calcmode 0 for backward 
** compatibility (this version M9 of the Purkinje cell model only!)
*/
setfield comptmode 1 chanmode 4 calcmode 0
call . SETUP
setmethod 11

/* Initialize output */
/* Output voltage as in Fig. 11 */
hstr={findsolvefield {cellpath} {cellpath}/soma Vm}
addmsg {cellpath} /output/plot_out SAVE {hstr}
// hstr={findsolvefield {cellpath} {cellpath}/main[4] Vm}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
// hstr={findsolvefield {cellpath} {cellpath}/br1[10] Vm}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
// hstr={findsolvefield {cellpath} {cellpath}/b3s44[20] Vm}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
/* Output [Ca] as in Fig. 4D */
// hstr={findsolvefield {cellpath} {cellpath}/b3s44[20]/Ca_pool Ca}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
/* Output currents as in Fig. 4D: requires chanmode 4 */
// hstr={findsolvefield {cellpath} {cellpath}/b3s44[20]/CaP Ik}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
// hstr={findsolvefield {cellpath} {cellpath}/b3s44[20]/CaT Ik}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
// hstr={findsolvefield {cellpath} {cellpath}/b3s44[20]/KC Ik}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
// hstr={findsolvefield {cellpath} {cellpath}/b3s44[20]/K2 Ik}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
// hstr={findsolvefield {cellpath} {cellpath}/b3s44[20]/KM Ik}
// addmsg {cellpath} /output/plot_out SAVE {hstr}
// setfield /output/plot_out filename {filename} initialize 1 append 1 leave_open 1
// setfield /output/plot_out filename {filename} append 1 leave_open 1
setfield /output/plot_out filename {filename} leave_open 1

reset

setfield /neurospaces_integrator heccer_dump_selection { HECCER_DUMP_VM_COMPARTMENT_MATRIX + \
				    			HECCER_DUMP_VM_COMPARTMENT_DATA + \
				     			HECCER_DUMP_VM_COMPARTMENT_OPERATIONS + \
				     			HECCER_DUMP_VM_CHANNEL_POOL_FLUXES + \
				     			HECCER_DUMP_VM_MECHANISM_DATA + \
				     			HECCER_DUMP_VM_MECHANISM_OPERATIONS + \
				     			HECCER_DUMP_VM_SUMMARY }

call /neurospaces_integrator NSINTEGRATOR_DUMP

step 0.10 -time
hstr={findsolvefield {cellpath} {cellpath}/soma inject}
setfield {cellpath} {hstr} {inject*1.e-9}
step 1.0 -time
setfield {cellpath} {hstr} 0.0
step 0.2 -time
// quit

