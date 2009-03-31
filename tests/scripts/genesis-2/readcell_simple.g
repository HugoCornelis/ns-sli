//genesis

/* This is an example of the use of hsolve elements for doing the
** hines numbering scheme for solution of a compartmental model of
** a neuron */

float RA = 0.5
float RM = 10
float CM = 0.01
float EREST_ACT = -0.065

float dt = 50e-6

function setup
  str name

  create neutral /library
  create compartment /library/compartment
 
  readcell ../tests/scripts/genesis-2/hinescell.p /test

  setfield /test/soma inject 3.0e-9

  setclock 0 {dt}
  disable /library


end //setup


function run_sim
 
    reset 
    silent -1
    step 0.1 -time
    silent 0
end //run_sim




setup
run_sim