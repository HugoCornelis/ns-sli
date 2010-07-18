//genesis - Purkinje cell version M9 genesis2.1 master script
/* Copyright E. De Schutter (Caltech and BBF-UIA) */

/* This script simulates a Purkinje cell in vivo, receving a synchronous
**  parallel fiber input ({numbr} spines and {amp} amplitude), distributed
**  over the complete dendrite, combined  with asynchronous background 
**  inputs from parallel fibers (phertz sets mean frequency) and stellate 
**  cells (ihertz) */

/* References:
** E. De Schutter and J.M. Bower: An active membrane model of the
** cerebellar Purkinje cell: II. Simulation of synaptic responses.
** Journal of Neurophysiology  71: 401-419 (1994).
** http://www.bbf.uia.ac.be/TNB/TNB_pub7.html
** E. De Schutter and J.M. Bower: Simulated responses of cerebellar
** Purkinje cells are independent of the dendritic location of granule 
** cell synaptic inputs. Proceedings of the National Academy of Sciences 
** USA 91: 4736-4740 (1994).
** http://www.bbf.uia.ac.be/TNB/TNB_pub6.html
** E. De Schutter: Modelling the cerebellar Purkinje cell: experiments 
** in computo. Progress in Brain Research, van Pelt J., Corner M.A., 
** Uylings H.B.M. and Lopes da Silva F.H.  editors, 102: 417-431 (1994).
** http://www.bbf.uia.ac.be/TNB/TNB_pub9.html
** We recreate the data used to generate Fig. 5.
** See http://www.bbf.uia.ac.be/models/PM9.shtml for general model info.
*/

randseed 
int numbr = 200	/* at present this parameter must be set in .p file also */
int amp = 1
float phertz = 28
float ihertz = 1
int offset

str filename = "results/P9_" @ (phertz) @ "_" @ (numbr) @ "I_"
int i, k, l
float t
str name,hstr
include defaults
cellpath = "/Purkinje"

/*********************************************************************
** Active membrane lumped Purkinje cell model script  (#2M9)
** E. De Schutter, Caltech 1991-1993 
** Uses the scripts:	Purk_chan, Purk_icomp, Purk_const  Purk_syn
*********************************************************************/
/* Purkinje cell constants */
include Purk_const
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

// set the firing frequencies at the library level
setfield /library/GABA frequency {ihertz}
setfield /library/non_NMDA frequency {phertz}

make_Purkinje_comps
make_Purkinje_spines

/* Set the clocks */
for (i = 0; i <= 7; i = i + 1)
    setclock {i} {dt}
end
setclock 8 1.0e-4
setclock 9 1

/* create the model and set up the run cell mode */
// read cell date from .p file and create hsolve element
readcell  tests/scripts/PurkM9_model/Purk2M9sA.p {cellpath} -hsolve

//make synchronous input
create neutral {cellpath}/par_presyn
disable {cellpath}/par_presyn
setfield {cellpath}/par_presyn z 0
foreach name ({el {cellpath}/##[][TYPE=channelC2]})
	addmsg {cellpath}/par_presyn {name} ACTIVATION z
end

/* Create the output element */
create asc_file /output/plot_out
useclock /output/plot_out 8

// setup the hines solver
ce {cellpath}
/* chanmode 3 is most efficient, calcmode 0 is needed for backward 
** compatibility (this version M9 of the Purkinje cell model only!)
*/
setfield comptmode 1 chanmode 3  calcmode 0
call . SETUP
setmethod 11

/* output voltage in soma */
hstr={findsolvefield {cellpath} {cellpath}/soma Vm}
addmsg {cellpath} /output/plot_out SAVE {hstr}

/* generate 200 data samples */
for (k = 0; k >= 0; k = k + 1)	/* infinite loop */
    l = offset + k
    if (l < 200)		/* break out of loop */
	name = (filename) @ (l)
	echo output to {name}
	setfield /output/plot_out filename {name} initialize 1 append 1 leave_open 1

	reset

	useclock /output/plot_out 9 /* disable output */
	/* randomize time of synchronous input to get good randomization
	**  of spiking times before the input */
	t = {rand 0.170 0.200}
	step {t} -time		/* initial equilibration */
	useclock /output/plot_out 8 /* enable output */

	step 0.050 -time
	setfield {cellpath}/par_presyn z {amp}	/* fire synchronous input */
	step 1
	setfield {cellpath}/par_presyn z 0
	step 0.050 -time
    else
	break
    end
end
quit

