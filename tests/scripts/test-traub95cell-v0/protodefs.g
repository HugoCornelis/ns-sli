// genesis - prototype definitions

/* file for 1995 Traub model channels */
include tests/scripts/test-traub95cell-v0/traub95chans.g

/* Make channel prototypes */

if (!{exists /library})     // But, only if it doesn't already exist
    create neutral /library
end

disable /library
pushe /library
create compartment compartment
create spikegen spike
setfield spike  thresh -0.03  abs_refract 2.0e-3  output_amp 1

make_Ca_int
make_Ca_conc_int
make_K_AHP_int
make_K_C_int
make_Na_int
make_K_DR_int
make_K_A_int
make_Na_int_axon
make_K_DR_int_axon

pope
