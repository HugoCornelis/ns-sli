//genesis

/* FILE INFORMATION
** tabulated implementation of bsg cell voltage and Ca-dependent
** channels.
** Implemented in Neurokit format by : Upinder S. Bhalla.
**
**	Source : Yamada, Koch, and Adams
**	Methods in Neuronal Modeling, MIT press, ed Koch and Segev.
**
** This file depends on functions and constants defined in library.g

  This contains only a modified make_KM_bsg_yka that avoids tweaktau

*/

// CONSTANTS

float V_OFFSET = 0.0
float VKTAU_OFFSET = 0.0
float VKMINF_OFFSET = 0.02
float ECA = 0.070
float ENa = 0.050
float EK = -0.07

/********************************************************************
**            Non-inactivating Muscarinic K current
********************************************************************/
function make_KM_bsg_yka_no_tweak
    if (({exists KM_bsg_yka}))
        return
    end

     int i
     float x, dx, tau, minf
     float A, B 
     create tabchannel KM_bsg_yka
     setfield KM_bsg_yka Ek {EK} Gbar {1200.0*{SOMA_A}} Ik 0 Gk 0  \
        Xpower 1 Ypower 0 Zpower 0

     call KM_bsg_yka TABCREATE X 49 -0.1 0.05
     x = -0.1
     dx = 0.15/49.0
     
     for (i = 0; i <= 49; i = i + 1)
        tau = 1.0/(3.3*({exp {(x + 0.035 - V_OFFSET)/0.04}}) + {exp {-(x + 0.035 - V_OFFSET)/0.02}})
        minf = 1.0/(1.0 + {exp {-(x + 0.035 - V_OFFSET)/0.01}})
        A = minf/tau
        B = 1.0/tau
        setfield KM_bsg_yka X_A->table[{i}] {A}
        setfield KM_bsg_yka X_B->table[{i}] {B}
        x = x + dx
     end
//	tweaktau KM_bsg_yka X
	setfield KM_bsg_yka X_A->calc_mode 0 X_B->calc_mode 0
	call KM_bsg_yka TABFILL X 3000 0
end
