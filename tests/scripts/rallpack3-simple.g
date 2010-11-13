//genesis
/* Axon.g : description file for unbranched axon, using standard
** Hodkin-Huxley channels and kinetics.
** By Upinder S. Bhalla       May 1992         Caltech.
** All units are in SI (Meter Kilogram Second Amp)

** rallpack3-simple.g modified Wed Jul 14 16:02:20 MDT 2010
** by dbeeman to use a simpler axon setup for GENESIS 3

*/

/********************************************************************
**                                                                 **
**                       Model parameters                          **
**                                                                 **
********************************************************************/

/* Setting up the parameters for the model */
float entire_len = 0.001 // 1 mm
float dia = 1.0e-6 // 1 microns
float len = 1.0e-6 // 1 microns
float RM = 4
float RA = 1.0
float CM = 0.01
float EM = -0.065 // -65 mV
float EREST_ACT = EM
// 0.1 nA injection
float inj = 1.0e-10

/* Channel parameters */
float ENA = 0.050
float EK = -0.077
// Siemens/m^2
float GNA = 1200
// Siemens/m^2
float GK = 360

// 0.05 msec
float dt = 50e-6
// 0.05 msec 
float iodt = 50e-6
// 0.25 sec
// float runtime = 0.25
float runtime = 0.25
float PI = 3.1415926535
float ncompts = entire_len/len
int incompts = ncompts
float area = PI*len*dia
float Xarea = PI*dia*dia/4.0

int X_flag = 0

/********************************************************************
**                                                                 **
**                       Model construction                        **
**                                                                 **
********************************************************************/

/* Setting up a prototype compartment */
/* The axon compartments could be directly created, but that
** would mean iterating over and setting all the values */
create compartment /proto/compartment
setfield /proto/compartment Ra {RA*len/Xarea} Rm {RM/area} Cm {CM*area}  \
    Em {EM}

pushe /proto/compartment

/* Setting up the prototype channels. Note that these are all
** accessible from the standard Genesis channel library, and the
** creation routines are put here only for completeness.
** A standard form is used for the rate functions :
** alpha = (A+B*V)/(C+exp((V+D)/F))
** which can express all the forms used by H and H.
*/
create tabchannel /proto/compartment/Na
        setfield Na Ek {ENA} Gbar {GNA*area} Ik 0 Gk 0 Xpower 3 Ypower 1 \
             Zpower 0
    setupalpha Na X {0.1e6*(0.025 + EREST_ACT)} -0.1e6 -1.0  \
        {-0.025 - EREST_ACT} -0.010 4e3 0.0 0.0 {-(0.0 + EREST_ACT)}  \
        18.0e-3
    setupalpha Na Y 70.0 0.0 0.0 {-(0.0 + EREST_ACT)} 0.020 1.0e3 0.0  \
        1.0 {-(0.030 + EREST_ACT)} -10.0e-3

create tabchannel /proto/compartment/K
        setfield K Ek {EK} Gbar {GK*area} Ik 0 Gk 0 Xpower 4 Ypower 0  \
            Zpower 0

    setupalpha K X {10e3*(0.010 + EREST_ACT)} -10e3 -1.0  \
        {-(0.010 + EREST_ACT)} -0.010 125.0 0.0 0.0 {-(0.0 + EREST_ACT)} \
         80.0e-3


addmsg Na . CHANNEL Gk Ek
addmsg . Na VOLTAGE Vm
addmsg K . CHANNEL Gk Ek
addmsg . K VOLTAGE Vm

pope

/******************************************************************/

function make_axon
    int i

    createmap /proto/compartment /axon {incompts} 1
    pushe /axon
    /* Setting up the inter-compartment communications */
    for (i = 1; i < incompts; i = i + 1)
        addmsg compartment[{i - 1}] compartment[{i}] RAXIAL Ra Vm
        addmsg compartment[{i}] compartment[{i - 1}] AXIAL Vm
    end
    pope
end

/*************************************************************** \
**                                                                 **
**                    graphical and file I/0                       **
**                                                                 **
********************************************************************/

if (X_flag)
	xstartup
	create x1form /form
	create x1graph /form/graph
	setfield /form/graph xmax {runtime} ymax 0.1 ymin -0.1
	addmsg /axon/low[0]/compartment[0] /form/graph PLOT Vm *comp_0  \
	    *red
	addmsg /axon/low[{n1 - 1}]/compartment[{n2 - 1}] /form/graph  \
	    PLOT Vm *comp_{incompts - 1} *green
	useclock /form/# 1
	xshow /form
end

function make_output
    create asc_file /output/out0
    create asc_file /output/outx
    setfield /output/out0 filename /tmp/axon3.out0 leave_open 1 flush 0
    setfield /output/outx filename /tmp/axon3.outx leave_open 1 flush 0
    addmsg /axon/compartment[0] /output/out0 SAVE Vm
    addmsg /axon/compartment[{incompts - 1}] /output/outx SAVE Vm
    useclock /output/out0 1
    useclock /output/outx 1
end

/********************************************************************
**                                                                 **
**                       Simulation control                        **
**                                                                 **
********************************************************************/

/* Set up the clocks that we are going to use */
setclock 0 {dt}
setclock 1 {iodt}

make_axon

make_output

/* Set the stimulus conditions */
setfield /axon/compartment[0] inject {inj}

/* Setting up the hines solver element */
create hsolve /axon/solve
setfield /axon/solve path /axon/compartment[] comptmode 1  \
    chanmode 3

/* using the crank-nicolson method */
setmethod 11
call /axon/solve SETUP

/* run the simulation */

reset
reset
// call /axon/#/# RESET

echo "START: "{getdate}
step {runtime} -time
echo "END: "{getdate}

setfield /output/out0 flush 1 leave_open 0
setfield /output/outx flush 1 leave_open 0
call /output/out0 PROCESS
call /output/outx PROCESS