//genesis

/* FILE INFORMATION
** 
** Tabchannel implementation of Hodgkin-Huxley squid Na and K channels
** This version uses SI (MKS) units and is equivalent to (but faster than)
** hh_chan.g, except for the function and channel names.
*/

// this version gives Na_hh_tchan a longer range of -0.1 to 0.1

// CONSTANTS
float EREST_ACT = -0.060
float ENA = 0.045
float EK = -0.090 // value will be overridden
/* Square meters */
float SOMA_A = 1e-9

//========================================================================
//			Tabchan Na channel 
//========================================================================

function make_Na_hh_tchan
	str chanpath = "Na_hh_tchan"
        if ({argc} == 1)
           chanpath = {argv 1}
        end
	if ({exists {chanpath}})
		return
	end

	create tabchannel {chanpath}
		setfield ^ Ek {ENA} Gbar {1.2e3*SOMA_A} Ik 0 Gk 0  \
		    Xpower 3 Ypower 1 Zpower 0

	setupalpha {chanpath} X {0.1e6*(0.025 + EREST_ACT)} -0.1e6  \
	    -1.0 {-1.0*(0.025 + EREST_ACT)} -0.01  \
	    4e3 0.0 0.0 {-1.0*EREST_ACT} 18e-3 \
            -range -0.1 0.1

	setupalpha {chanpath} Y 70.0 0.0 0.0  \
	    {-1.0*EREST_ACT} 0.02 1.0e3 0.0 1.0  \
	    {-1.0*(0.030 + EREST_ACT)} -10.0e-3 \
            -range -0.1 0.1
end
