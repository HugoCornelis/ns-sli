//genesis  -  tutorial4.g - GENESIS Version 2.0

/*======================================================================
  A sample script to create a multicompartmental neuron with synaptic
  input.  SI units are used.
  ======================================================================*/

//include hhchan		// functions to create Hodgkin-Huxley channels
include hh_tchan    // functions to create tabulated Hodgkin-Huxley channels

/* hhchan.g assigns values to the global variables EREST_ACT, ENA, EK,
   and SOMA_A.  These will be superseded by values defined below.      */

float   PI              =       3.14159

// soma parameters - chosen to be the same as in SQUID (but in SI units)
float RM = 0.33333		// specific membrane resistance (ohms m^2)
float CM = 0.01			// specific membrane capacitance (farads/m^2)
float RA = 0.3			// specific axial resistance (ohms m)
float EREST_ACT = -0.07		// resting membrane potential (volts)
float Eleak = EREST_ACT + 0.0106  // membrane leakage potential (volts)
float ENA   = 0.045               // sodium equilibrium potential
float EK    = -0.082              // potassium equilibrium potential

// cell dimensions (meters)
float soma_l = 30e-6            // cylinder equivalent to 30 micron sphere
float soma_d = 30e-6
float dend_l =100e-6		// we will add a 100 micron long dendrite
float dend_d =  2e-6		// give it a 2 micron diameter
float SOMA_A = soma_l*PI*soma_d // variable used by hhchan.g for soma area

float gmax = 5e-10		// maximum synaptic conductance (Siemen)

float tmax = 0.1                // simulation time in sec
float dt = 0.00005		// simulation time step in sec
setclock  0  {dt}		// set the simulation clock

//===============================
//      Function Definitions
//===============================

function makecompartment(path, length, dia, Erest)
    str path
    float length, dia, Erest
    float area = length*PI*dia
    float xarea = PI*dia*dia/4
    
    create      compartment     {path}
    setfield    {path}              \
		Em      { Erest }   \           // volts
		Rm 	{ RM/area } \		// Ohms
		Cm 	{ CM*area } \		// Farads
		Ra      { RA*length/xarea }	// Ohms
end

function makechannel(compartment,channel,Ek,tau1,tau2,gmax)
    str compartment
    str channel
    float Ek                            // Volts
    float tau1,tau2                     // sec
    float gmax                          // Siemens (1/ohms)
    float freq = 30.0                    // Hz?

    create      synchan               {compartment}/{channel}
    setfield    {compartment}/{channel} \
                Ek                      {Ek} \
                tau1                    {tau1} \
                tau2                    {tau2} \
                gmax                    {gmax} \
		frequency               {freq}
    addmsg   {compartment}/{channel}   {compartment} CHANNEL Gk Ek
    addmsg   {compartment}   {compartment}/{channel} VOLTAGE Vm
end

function makeneuron(path, soma_l, soma_d, dend_l, dend_d)
    str path
    float soma_l, soma_d, dend_l, dend_d

    create neutral {path}
    makecompartment {path}/soma {soma_l} {soma_d} {Eleak}
    setfield /cell/soma initVm {EREST_ACT}

    // Create two channels, "{path}/soma/Na_hh_tchan" and "{path}/soma/K_hh_tchan"
    make_Na_hh_tchan {path}/soma/Na_hh_tchan
    make_K_hh_tchan {path}/soma/K_hh_tchan      


    // The soma needs to know the value of the channel conductance
    // and equilibrium potential in order to calculate the current
    // through the channel.  The channel calculates its conductance
    // using the current value of the soma membrane potential.
    addmsg {path}/soma/Na_hh_tchan {path}/soma CHANNEL Gk Ek
    addmsg {path}/soma {path}/soma/Na_hh_tchan VOLTAGE Vm
    addmsg {path}/soma/K_hh_tchan {path}/soma CHANNEL Gk Ek
    addmsg {path}/soma {path}/soma/K_hh_tchan VOLTAGE Vm

    // make the dendrite compartment and link it to the soma
    makecompartment {path}/dend {dend_l} {dend_d} {EREST_ACT}
    makechannel {path}/dend Ex_channel {ENA} 0.003 0.003 {gmax}
    addmsg {path}/dend {path}/soma RAXIAL Ra previous_state
    addmsg {path}/soma {path}/dend AXIAL  previous_state

/*
    // add a spike generator to the soma
    create spikegen {path}/soma/spike
    setfield {path}/soma/spike  thresh 0  abs_refract 0.010  output_amp 1
    // use the soma membrane potential to drive the spike generator
    addmsg  {path}/soma  {path}/soma/spike  INPUT Vm
*/

end  // makeneuron

function makeinput(path)
    str path
    int msgnum = 0
    create randomspike /randomspike
    setfield /randomspike min_amp 1.0 max_amp 1.0 rate 200 reset 1 reset_value 0
    addmsg /randomspike {path} SPIKE
    msgnum = {getfield {path} nsynapses} - 1
    setfield {path} \
        synapse[{msgnum}].weight 1 synapse[{msgnum}].delay 0
end


function toggle_feedback
    int msgnum
    if ({getfield /control/feedback state} == 0)
	deletemsg  /cell/soma/spike 0 -out
	echo "Feedback connection deleted"
    else
        addmsg /cell/soma/spike /cell/dend/Ex_channel SPIKE
	msgnum = {getfield /cell/dend/Ex_channel nsynapses} - 1
        setfield /cell/dend/Ex_channel \
	    synapse[{msgnum}].weight 10 synapse[{msgnum}].delay 0.005
	echo "Feedback connection added"
    end
end

function output_data
    create asc_file /out
    // G3 requires an explicit filename - won't use asc_file name as default
    setfield /out  filename "Vm.out"  
    setclock 1 0.001  	// A rather large interval to keep the file small
    useclock /out 1
    addmsg /cell/soma /out SAVE Vm                      
end

//===============================
//         Main Script
//===============================

// create the neuron "/cell"
makeneuron /cell {soma_l} {soma_d} {dend_l} {dend_d}

setfield /cell/soma inject 0.0

//makeinput /cell/dend/Ex_channel

// finally, we add some feedback from the axon to the dendrite
//addmsg /cell/soma/spike /cell/dend/Ex_channel SPIKE
//setfield /cell/dend/Ex_channel \
//    synapse[1].weight 10 synapse[1].delay 0.005

// Output the results
output_data

check
reset

step 0.5 -time
