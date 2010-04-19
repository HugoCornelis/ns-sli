// genesis - prototype definitions

/* file for 1994 Traub model channels */
include traub94chans.g

/* Make channel prototypes */

if (!{exists /library})     // But, only if it doesn't already exist
    create neutral /library
end

disable /library
pushe /library
create compartment compartment
create spikegen spike
setfield spike  thresh -0.03  abs_refract 2.0e-3  output_amp 1

make_Na
make_Ca
make_K_DR
make_K_AHP
make_K_AHP_soma
make_K_C
make_K_C_soma
make_K_A
make_Na_axon
make_K_DR_axon
make_Ca_conc
make_Ca_conc_soma

pope
