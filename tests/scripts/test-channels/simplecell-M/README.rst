README file for simplecell-M
============================

Introduction
------------

This model implements the solution to an exercise in the
GENESIS Modeling Tutorial section "Building a cell the easy way"
(http://www.genesis-sim.org/GENESIS/UGTD/Tutorials/genprog/simplecell-tut.html)

The exercise suggests adding a muscarinic current to the 'simplecell'
model, by using the function 'make_KM_bsg_yka' that is defined in the
prototypes library ``neurokit/prototypes/yamadachan.g``.  

Instead of using 'setupalpha' or 'setuptau', this function uses a for loop
to fill the A and B tables with tau and minf values, then calls 'tweaktau
KM_bsg_yka X' to convert them to proper A and B values.  The original
tables have 50 entries, spanning a range -0.1 to 0.1 Volts, rather than the
usual -0.1 to 0.05 Volts.  The function then uses TABFILL to expand it to
3001 entries, using a B-spline fit under GENESIS 2.

The file yamadachan.g also contains a function for creating a transient
pottassium "A current" conductance that uses the 'setuptau' command.
This was not tested in this simulation.

The default simulation runs for 0.5 sec with a 0.5 nA current injection to
/cell/soma, producing the output file 'simplecell-M_Vm.out'.

Summary of results
------------------

The plotted results for the default simulation described above show that
the non-hsolved GENESIS 2 results have significant deviations from the G-3
sli_run results, with a 6 msec difference in position of the last spike.
The GENESIS 2 version with hsolve chanmode 3 causes errors due to a GENESIS
2 hsolve restriction that requires all gate tables to have the same size.
Neither 'sli_load' nor 'sli_run' give any errors associated with the
'tweaktau' command.

When 'ndf_load' and 'run' are used to run the saved NDF file, there is a
single initial peak and no further firing.  Further studies in the
'simplecells/' collection indicated that ndf_load is not properly
processing the values of ``HH_TABLE_START`` and ``HH_TABLE_END`` in
the NDF file.

Files
-----

Main simulation scripts::

  simplecell-M-g3.g - this adds a Muscarinic current KM_bsg_yka from
    yamadachan.g - output is to "simplecell-M_Vm.out"
  simplecell-M-g2.g - GENESIS 2 version with graphics, run from control panel
  simplecell-M-h3-g2.g - GENESIS 2 version using hsolve in chanmode 3

Accessory scripts::

  cell-M.p - the cell parameter file for the simplecell-M model

  graphics.g - the standard graphical interface for the GENESIS 2 scripts
  protodefs-M.g - creates library of protoype channels and cell components
      for simplecell-M-g3.g using hh_tchan.g and yamadachan.g.

Sample output::

  simplecell-M.ndf - NDF file created from simplecell-M-g3.g with sli_load
      and ndf_save

  simplecell-M-g2_Vm.out - output from GENESIS 2 for simplecell-M-g3.g
  simplecell-M-sli_run_Vm.out - output from gshell sli_run
  simplecell-M-ndf_load_Vm.out - output using 'ndf_load' plus 'run'

Testing Procedure and Results
-----------------------------

To run under GENESIS 2::

  $ genesis simplecell-M-g3.g
  ... usual startup messages
  Simulation Script:  simplecell-M-g3.g
  /library
  /
  changing clock [0] from 1 to 2e-05
  reading 'cell-M.p'.... 
  cell-M.p read: 2 compartments, 5 channels, 0 shells, 2 others
  time = 0.000000 ; step = 0          
  time = 0.500000 ; step = 25000          
  completed 25000 steps in 0.092986 cpu seconds
  genesis #0 > quit
  $ mv simplecell-M_Vm.out simplecell-M-g2_Vm.out


In principle, one would then use GENESIS 2 to run simplecell-M-h3-g2.g from
the GUI.  Click on 'RESET', 'RUN', and 'QUIT'.  However, this revealed
some problems with GENESIS 2 hsolve, producing the error::

  ** Error -  during SETUP of /cell/solver: all tables must have same size.
  hsolve invdx=15000.000000 is != ip invd=20000.000000

A variation on this script, described below, provides a workaround that
produced satisfactory results.

To run under gshell with sli_run::

  $ genesis-g3
  Welcome to the GENESIS 3 shell
  genesis > sli_run simplecell-M-g3.g
  ... some startup messages - No error msgs
  Simulation Script:  simplecell-M-g3.g
  /library
  /
  changing clock [0] from 1 to 2e-05
  reading 'cell-M.p'.... 
  cell-M.p read: 2 compartments
  time = 0.000000 ; step = 0	
  time = 0.500000 ; step = 25000
  completed 25000 steps in 0.022996 cpu seconds
  genesis > quit
  $ mv simplecell-M_Vm.out simplecell-M-sli_run_Vm.out

To test the results::

  $ plotVm simplecell-M-sli_run_Vm.out simplecell-M-g2_Vm.out

There is a 6 msec difference in position of the last spike from the
non-hsolved GENESIS 2 version,

To save as NDF::

  genesis > sli_load simplecell-M-g3.g
  ... some startup messages - No error msgs
  Simulation Script:  simplecell-M-g3.g
  /library
  /
  changing clock [0] from 1 to 2e-05
  reading 'cell-M.p'.... 
  cell-M.p read: 2 compartments
  genesis > ndf_save /cell/** simplecell-M.ndf
  genesis > quit

To load and run::

  $ genesis-g3
  Welcome to the GENESIS 3 shell
  genesis > ndf_load simplecell-M.ndf
  genesis > runtime_parameter_add /cell/soma INJECT 0.5e-9
  genesis > output_add /cell/soma Vm
  genesis > output_filename simplecell-M-ndf_load_Vm.out
  genesis > run /cell 0.5
  genesis > quit

To test the results::

  $ plotVm simplecell-M-sli_run_Vm.out simplecell-M-ndf_load_Vm.out simplecell-M-g2_Vm.out

The version loaded from simplecell-M.ndf fires a single initial spike
and then remains polarized at about -65.5 mV.  Zooming in on the first
action potential reveals that the ndf_load results agree with the other
two until about 4.3 msec, on the falling slope of the action potential
at about -30 mV.  An examination of the plot for non-solved GENESIS 2,
shows that there are "dips" in the membrane potential as it starts to
rise towards threshold, and then decreases again.  At this point the
G2 and sli_run results diverge.  This voltage of about -62.5 mV is
evidently one in which the depolarizing and hyperpolarizing currents
are nearly balanced, and small numerical inaccuracies can become amplified.
The cause of the divergence of the ndf_load result so early was explored
and determined for a simpler case in the 'simplecells/' series of tests.
Evidently, ndf_save produces a correct NDF representation, but ndf_load
is not using the values of ``HH_TABLE_START`` and ``HH_TABLE_END``.

Note that unlike the RScell simulation, which uses 'setupalpha' to
implement a different model of muscarinic current, this simulation uses the
'tweaktau' command.  This produces no error messages.  The table for
GATE_KINETIC "A_18_18" in the ndf file 'simplecell-M.ndf' looks correct
when compared with the results of commands such as ``showfield KM_bsg_yka
*`` or ``showfield KM_bsg_yka X_A->table[562]`` under GENESIS 2.
However, the tables in the NDF representation contain 3000 points instead
of 3001, and have slightly less precision than the results displayed with
'showfield' in GENESIS 2.

Additional scripts for debugging
--------------------------------

The muscarinic current defined by the function make_KM_bsg_yka in
yamadachan.g has three differences from a typical script that directly
creates the gate table with 'setupalpha'.

* the gate tables are created and filles with only 50 values,
  and then expanded to 3001 (xdivs = 3000) points with TABFILL

* the range (xmin and xmax) is set to -0.1 to 0.1 V, rather than the default
  -0.1 to 0.05 V

* initially they are filled with tau and minf values, and the 'teaktau'
  command is used to convert them to A and B values, before the TABFILL
  operation

These additional scripts were developed to aid debugging of the
scripts above with variations to narrow down the source of the problem:

*simplecell-M_no_tweak-g3.g* - a variation of simplecell-M-g3.g that
avoids the use of 'tweaktau' by calculating the A and B table
values from tau and minf, and filling the tables directly.
It also uses voltage values xmin and xmax of -0.1 to 0.05, rather
than range of -0.1 to 0.1 used in yamadachan.g.

*Mchan.g* - implements the function make_KM_bsg_yka_no_tweak, which
is substituted for yamadachan.g function make_KM_bsg_yka in
protodefs-M_no_tweak.g

*protodefs-M_no_tweak.g* - creates prototypes for simplecell-M_no_tweak-g3.g

*simplecell-M_no_tweak-h3-g2.g* - similar to simplecell-M-h3-g2.g, but
includes protodefs-M_no_tweak.g.  It works properly with hsolve chanmode 3.

When simplecell-M_no_tweak-g3.g is used with sli_load/ndf_save and
ndf_load/run, it generates results similar, but not identical, to
simplecell-M-sli_run_Vm.out instead of firing a single spike.
The results may be compared with::

  $ plotVm simplecell-M_no_tweak-h3_Vm.out \
  simplecell-M_no_tweak-sli_run_Vm.out \
  simplecell-M_no_tweak-ndf_load_Vm.out

With extreme zoom, the sli_run and ndf_load + run versions can be seen to
be not exactly the same, but nearly indistinguishable. The initial peaks
agree well, but by the last AP, the G2 hsolved version peak is delayed from
the G3 results by 1.2 msec.  This is satisfactory agreement, considering
the "amplification effect" that slow K currents can have on small numerical
differences.

Note that the original range of  -0.1 to 0.1 V spread over 49 divisions
means that each table entry is separated by about 4 mV.  Even with
interpolation to the larger table, this may be too coarse of a sampling
for this current.  By restricting the range to -0.1 to 0.05 V, each
of the initial 49 divisions corresponds to only 3 mV.  This may yield
slightly different results.

Another variation of Mchan.g and these scripts explored the effect
of using 100 rather than only 50 entries in the original unexpanded
table.	Running under GENESIS 2, it showed some differences in location
of the final action potentials.  This suggests that the manner in which
the table are filled and expanded may significantly affect the results.

In order to see if the non-standard range option or the 'tweaktau' command
was responsible for the failure of ndf_load to yield correct results,
another set of scripts was developed in 'simplecells' that found 'tweaktau'
to be working properly, and that the NDF file properly records the
table values and the range information.  However, ndf_load is not properly
processing the values of ``HH_TABLE_START`` and ``HH_TABLE_END`` in
the NDF file.
