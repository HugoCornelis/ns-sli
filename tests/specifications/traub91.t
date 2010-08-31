#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/new_dim_calc.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script compute correct new diameter and length for apical_18 ?",
						   read => '
apical_18
original len*dia =  693.6
a =  693.6
b =  3.591911016
len =  120  new_len =  119.9999886
dia =  5.78  new_dia =  5.78000055
new_len*new_dia =  693.6
',
						  },
						  {
						   description => "Does the script compute correct new diameter and length for apical_10 ?",
						   read => '
apical_10
original len*dia =  693.6
a =  693.6
b =  2.66920691
len =  120  new_len =  108.6926392
dia =  5.78  new_dia =  6.381296883
new_len*new_dia =  693.6
',
						  },
						  {
						   description => "Does the script compute correct new diameter and length for soma ?",
						   read => '
soma
original len*dia =  1057.5
a =  1057.5
b =  3.221110154
len =  125  new_len =  153.2929163
dia =  8.46  new_dia =  6.898557518
new_len*new_dia =  1057.5
',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts.',
				description => "a very small subset of the traub91 model (3)",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/traub91_asym_simple3.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Do we see the dumped model from heccer, traub91_asym_simple3 ?",
						   read => (join '', `cat "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple3.dump"`),
						   timeout => 20,
						   mac_report => 'This test fails with a TIMEOUT. When run manaually it is confirmed to work. Problem occurs due to the prompt output of the ns-sli is caught by the testers seen output. All tests following the open prompt pass.',
						  },
						  {
						   description => "Does the script run a simulation (3) ?",
						   read => 'time = 0.150000 ; step = 3000',
						   timeout => 10,
						  },
						  {
						   description => "Can we save the model as an NDF file -- library ?",
						   read => 'genesis',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf /tmp/traub91_simple3.ndf /cell/**"',
						  },
						  {
						   description => "Can we set the options for the DUMP command ?",
						   read => 'genesis',
						   write => 'setfield /neurospaces_integrator heccer_dump_selection { HECCER_DUMP_VM_COMPARTMENT_MATRIX + HECCER_DUMP_VM_COMPARTMENT_DATA + HECCER_DUMP_VM_COMPARTMENT_OPERATIONS + HECCER_DUMP_VM_CHANNEL_POOL_FLUXES + HECCER_DUMP_VM_MECHANISM_DATA + HECCER_DUMP_VM_MECHANISM_OPERATIONS + HECCER_DUMP_VM_SUMMARY }',
						  },
						  {
						   description => "Can we dump the model from heccer (1)?",
						   read => 'Heccer (pcName) : (/cell)
Heccer (iStatus) : (20)
Heccer (iErrorCount) : (0)
Heccer Options (iOptions) : (0)
Heccer Options (dIntervalStart) : (-0.1)
Heccer Options (dIntervalEnd) : (0.05)
Heccer Options (dConcentrationGateStart) : (0)
Heccer Options (dConcentrationGateEnd) : (1000)
Heccer Options (iIntervalEntries) : (3000)
Heccer Options (iSmallTableSize) : (50)
Heccer (dTime) : (0.15)
Heccer (dStep) : (5e-05)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Tables (iTabulatedGateCount) : (3)
Compartment operations
-----
00000 :: FORWARD_ELIMINATION    0
00001 :: FINISH
00002 :: BACKWARD_SUBSTITUTION    2
00003 :: FINISH_ROW
00004 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -1.30741e-10 0 382437 1.08446
00001 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (5.97007e-10) (nil) (nil) (nil)							 45.8839
00002 :: INITIALIZECHANNEL 0.08 1.0895e-07
00003 :: LOADVOLTAGETABLE
00004 :: CONCEPTGATE 0 2 (nil)							 0.999994
00005 :: CONCEPTGATE 1 1 (nil)							 0.490367
00006 :: UPDATECOMPARTMENTCURRENT
00007 :: REGISTERCHANNELCURRENT
00008 :: FLUXPOOL							 5.97007e-10
00009 :: INITIALIZECHANNEL -0.075 1.74321e-08
00010 :: CONCEPTGATE 2 1 (45.8839)							 0.0984261
00011 :: UPDATECOMPARTMENTCURRENT
00012 :: COMPARTMENT							 -1.30741e-10 2e-10 382437 1.08446
00013 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.08446)
VM Diagonals (pdDiagonals[1]) : (1.08446)
VM Axial Resistances (pdAxres[0]) : (-0.0836227)
VM Axial Resistances (pdAxres[1]) : (-0.0836227)
VM Axial Resistances (pdAxres[2]) : (-0.0836227)
VM Axial Resistances (pdResults[0]) : (0.0688234)
VM Axial Resistances (pdResults[1]) : (1.10554)
VM Axial Resistances (pdResults[2]) : (0.0684811)
VM Axial Resistances (pdResults[3]) : (1.08446)
VM Membrane Potentials (pdVms[0]) : (0.0688214)
VM Membrane Potentials (pdVms[1]) : (0.0684792)
',
						   write => 'call /neurospaces_integrator NSINTEGRATOR_DUMP',
						  },
						  {
						   description => 'Quit the simulator (3).',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the application output file correct, traub91_asym_simple3.g (1) ?",
						   read => {
							    application_output_file => "/tmp/traub91_asym_simple3",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple3.txt",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts, does not use the G2 generated file.',
				description => "a very small subset of the traub91 model (3)",
			       },
			       {
				arguments => [
					      '--time',
					      '0.15',
					      '--time-step',
					      '5e-5',
					      '--cell',
					      '/tmp/traub91_simple3.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/apical_19->Vm",
					      '--output-fields',
					      "/cell/apical_18->Vm",
					      '--optimize',
					      '--verbose',
					      '--dump',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we compile the converted model description from SSP, traub91_asym_simple3.ndf ?',
						   read => 'Heccer (pcName) : (unnamed test)
Heccer (iStatus) : (20)
Heccer (iErrorCount) : (0)
Heccer Options (iOptions) : (0)
Heccer Options (dIntervalStart) : (-0.1)
Heccer Options (dIntervalEnd) : (0.05)
Heccer Options (dConcentrationGateStart) : (4e-05)
Heccer Options (dConcentrationGateEnd) : (0.3)
Heccer Options (iIntervalEntries) : (3000)
Heccer Options (iSmallTableSize) : (149)
Heccer (dTime) : (0)
Heccer (dStep) : (5e-05)
Intermediary (iCompartments) : (2)
Compartment (mc.iType) : (1)
Compartment (iParent) : (-1)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (2e-10)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (0)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
MinimumDegree (iEntries) : (2)
MinimumDegree (piChildren[0]) : (1)
MinimumDegree (piChildren[0][0]) : (1)
MinimumDegree (piChildren[1]) : (0)
MinimumDegree (piForward[0]) : (1)
MinimumDegree (piForward[1]) : (0)
MinimumDegree (piBackward[0]) : (1)
MinimumDegree (piBackward[1]) : (0)
Tables (iTabulatedGateCount) : (3)
Tabulated gate 0, interval (dStart) : (-0.1)
Tabulated gate 0, interval (dEnd) : (0.05)
Tabulated gate 0, interval (dStep) : (5e-05)
Tabulated gate 0, interpolation (iShape) : (0)
Tabulated gate 0, (iEntries) : (3000)
Tabulated gate 1, interval (dStart) : (-0.1)
Tabulated gate 1, interval (dEnd) : (0.05)
Tabulated gate 1, interval (dStep) : (5e-05)
Tabulated gate 1, interpolation (iShape) : (0)
Tabulated gate 1, (iEntries) : (3000)
Tabulated gate 2, interval (dStart) : (0)
Tabulated gate 2, interval (dEnd) : (1000)
Tabulated gate 2, interval (dStep) : (0.333333)
Tabulated gate 2, interpolation (iShape) : (0)
Tabulated gate 2, (iEntries) : (3000)
Compartment operations
-----
00000 :: FORWARD_ELIMINATION    0
00001 :: FINISH
00002 :: BACKWARD_SUBSTITUTION    2
00003 :: FINISH_ROW
00004 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -1.30741e-10 0 382437 1.08446
00001 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00002 :: INITIALIZECHANNEL 0.08 1.0895e-07
00003 :: LOADVOLTAGETABLE
00004 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00005 :: CONCEPTGATE 1 1 (nil)							 0.973086
00006 :: UPDATECOMPARTMENTCURRENT
00007 :: REGISTERCHANNELCURRENT
00008 :: FLUXPOOL							 0
00009 :: INITIALIZECHANNEL -0.075 1.74321e-08
00010 :: CONCEPTGATE 2 1 (0)							 0
00011 :: UPDATECOMPARTMENTCURRENT
00012 :: COMPARTMENT							 -1.30741e-10 2e-10 382437 1.08446
00013 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.08446)
VM Diagonals (pdDiagonals[1]) : (1.08446)
VM Axial Resistances (pdAxres[0]) : (-0.0836226)
VM Axial Resistances (pdAxres[1]) : (-0.0836226)
VM Axial Resistances (pdAxres[2]) : (-0.0836226)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Axial Resistances (pdResults[2]) : (0)
VM Axial Resistances (pdResults[3]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.06)
VM Membrane Potentials (pdVms[1]) : (-0.06)
',
						   timeout => 10,
						  },
						  {
						   description => 'Does the simulation produce the correct output, traub91_asym_simple3.ndf ?',
# 						   numerical_compare => 'arithmetic rounding differences',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple3.ssp",
# 							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-1-5e-10nA.txt",
							   },
						   wait => 1,
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "running the converted model with SSP to see if the conversion was done correctly",
				preparation => {
						description => "Create the output/ directory",
						preparer =>
						sub
						{
						    `mkdir output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the output/ directory",
					       reparer =>
					       sub
					       {
 						   `cp "$::config->{core_directory}/output/cell.out" "$::config->{core_directory}/output/traub91_asym_simple3.out"`;
#  						   `rm "$::config->{core_directory}/output/cell.out"`;
						   `rmdir output`;
					       },
					      },
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/traub91_asym_simple2.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Do we see the dumped model from heccer, traub91_asym_simple2 ?",
						   read => (join '', `cat "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple2.dump"`),
						   timeout => 20,
						   mac_report => 'This test fails with a TIMEOUT. When run manaually it is confirmed to work. Problem occurs due to the prompt output of the ns-sli is caught by the testers seen output as with the previous test.',						  },
						  {
						   description => "Does the script run a simulation (2) ?",
						   read => 'time = 0.150000 ; step = 3000',
						   timeout => 10,
						  },
						  {
						   description => "Can we save the model as an NDF file -- library ?",
						   read => 'genesis',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf /tmp/traub91_simple2.ndf /cell/**"',
						  },
						  {
						   description => 'Quit the simulator (2).',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the application output file correct (2) ?",
						   read => {
							    application_output_file => "/tmp/traub91_asym_simple2",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple2.txt",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts, does not use the G2 generated file.',
				description => "a very small subset of the traub91 model (2)",
			       },
			       {
				arguments => [
					      '--time',
					      '0.15',
					      '--time-step',
					      '5e-5',
					      '--cell',
					      '/tmp/traub91_simple2.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/apical_19->Vm",
					      '--output-fields',
					      "/cell/apical_18->Vm",
					      '--optimize',
					      '--verbose',
					      '--dump',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we compile the converted model description from SSP, traub91_asym_simple2.ndf ?',
						   read => 'Heccer (pcName) : (unnamed test)
Heccer (iStatus) : (20)
Heccer (iErrorCount) : (0)
Heccer Options (iOptions) : (0)
Heccer Options (dIntervalStart) : (-0.1)
Heccer Options (dIntervalEnd) : (0.05)
Heccer Options (dConcentrationGateStart) : (4e-05)
Heccer Options (dConcentrationGateEnd) : (0.3)
Heccer Options (iIntervalEntries) : (3000)
Heccer Options (iSmallTableSize) : (149)
Heccer (dTime) : (0)
Heccer (dStep) : (5e-05)
Intermediary (iCompartments) : (2)
Compartment (mc.iType) : (1)
Compartment (iParent) : (-1)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (2e-10)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (0)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
MinimumDegree (iEntries) : (2)
MinimumDegree (piChildren[0]) : (1)
MinimumDegree (piChildren[0][0]) : (1)
MinimumDegree (piChildren[1]) : (0)
MinimumDegree (piForward[0]) : (1)
MinimumDegree (piForward[1]) : (0)
MinimumDegree (piBackward[0]) : (1)
MinimumDegree (piBackward[1]) : (0)
Tables (iTabulatedGateCount) : (4)
Tabulated gate 0, interval (dStart) : (-0.1)
Tabulated gate 0, interval (dEnd) : (0.05)
Tabulated gate 0, interval (dStep) : (5e-05)
Tabulated gate 0, interpolation (iShape) : (0)
Tabulated gate 0, (iEntries) : (3000)
Tabulated gate 1, interval (dStart) : (-0.1)
Tabulated gate 1, interval (dEnd) : (0.05)
Tabulated gate 1, interval (dStep) : (5e-05)
Tabulated gate 1, interpolation (iShape) : (0)
Tabulated gate 1, (iEntries) : (3000)
Tabulated gate 2, interval (dStart) : (-0.1)
Tabulated gate 2, interval (dEnd) : (0.05)
Tabulated gate 2, interval (dStep) : (5e-05)
Tabulated gate 2, interpolation (iShape) : (0)
Tabulated gate 2, (iEntries) : (3000)
Tabulated gate 3, interval (dStart) : (0)
Tabulated gate 3, interval (dEnd) : (1000)
Tabulated gate 3, interval (dStep) : (0.333333)
Tabulated gate 3, interpolation (iShape) : (0)
Tabulated gate 3, (iEntries) : (3000)
Compartment operations
-----
00000 :: FORWARD_ELIMINATION    0
00001 :: FINISH
00002 :: BACKWARD_SUBSTITUTION    2
00003 :: FINISH_ROW
00004 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -1.30741e-10 0 382437 1.08446
00001 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00002 :: INITIALIZECHANNEL 0.08 1.0895e-07
00003 :: LOADVOLTAGETABLE
00004 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00005 :: CONCEPTGATE 1 1 (nil)							 0.973086
00006 :: UPDATECOMPARTMENTCURRENT
00007 :: REGISTERCHANNELCURRENT
00008 :: FLUXPOOL							 0
00009 :: INITIALIZECHANNEL -0.075 1.0895e-07
00010 :: CONCEPTGATE 2 1 (nil)							 0.0106418
00011 :: CONCEPTGATE 3 -1 (0)							 0
00012 :: UPDATECOMPARTMENTCURRENT
00013 :: COMPARTMENT							 -1.30741e-10 2e-10 382437 1.08446
00014 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.08446)
VM Diagonals (pdDiagonals[1]) : (1.08446)
VM Axial Resistances (pdAxres[0]) : (-0.0836226)
VM Axial Resistances (pdAxres[1]) : (-0.0836226)
VM Axial Resistances (pdAxres[2]) : (-0.0836226)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Axial Resistances (pdResults[2]) : (0)
VM Axial Resistances (pdResults[3]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.06)
VM Membrane Potentials (pdVms[1]) : (-0.06)
',
						   timeout => 10,
						  },
						  {
						   description => 'Does the simulation produce the correct output, traub91_asym_simple2.ndf ?',
						   numerical_compare => 'arithmetic rounding differences',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple2.ssp",
# 							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-1-5e-10nA.txt",
							   },
						   wait => 1,
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "running the converted model with SSP to see if the conversion was done correctly",
				preparation => {
						description => "Create the output/ directory",
						preparer =>
						sub
						{
						    `mkdir output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the output/ directory",
					       reparer =>
					       sub
					       {
 						   `cp "$::config->{core_directory}/output/cell.out" "$::config->{core_directory}/output/traub91_asym_simple2.out"`;
#  						   `rm "$::config->{core_directory}/output/cell.out"`;
						   `rmdir output`;
					       },
					      },
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/traub91_asym_simple.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation (1) ?",
						   read => 'time = 0.150000 ; step = 3000',
						   timeout => 10,
						  },
						  {
						   description => "Can we save the model as an NDF file -- library ?",
						   read => 'genesis',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf /tmp/traub91_simple.ndf /cell/**"',
						  },
						  {
						   description => 'Quit the simulator (1).',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the application output file correct (3) ?",
						   read => {
							    application_output_file => "/tmp/traub91_asym_simple",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple.txt",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts.  Because there is no Ca channel, the ns-sli generates one error: ** Error - c_do_add_msg : cannot find element \'/cell/apical_18/Ca_conc/../Ca\'',
				description => "a very small subset of the traub91 model (1)",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/traub91_asym.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.150000 ; step = 3000',
						   timeout => 10,
						  },
						  {
						   description => 'Quit the simulator.',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the application output file correct (4) ?",
						   numerical_compare => 'small differences on the tester machine.',
						   read => {
							    application_output_file => "/tmp/traub91_asym",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym.txt",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts.',
				description => "the traub91 model, asymmetric compartment version.",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/traub91.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.150000 ; step = 3000',
						   timeout => 10,
						  },
						  {
						   description => "Can we save the model as an NDF file -- library ?",
						   read => 'genesis',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf /tmp/traub91.ndf /cell/**"',
						  },
						  {
						   description => "Can we set the options for the DUMP command ?",
						   read => 'genesis',
						   write => 'setfield /neurospaces_integrator heccer_dump_selection { HECCER_DUMP_VM_COMPARTMENT_MATRIX + HECCER_DUMP_VM_COMPARTMENT_DATA + HECCER_DUMP_VM_COMPARTMENT_OPERATIONS + HECCER_DUMP_VM_CHANNEL_POOL_FLUXES + HECCER_DUMP_VM_MECHANISM_DATA + HECCER_DUMP_VM_MECHANISM_OPERATIONS + HECCER_DUMP_VM_SUMMARY }',
						  },
						  {
						   description => "Can we dump the model from heccer (2)?",
						   read => 'Heccer (pcName) : (/cell)
Heccer (iStatus) : (20)
Heccer (iErrorCount) : (0)
Heccer Options (iOptions) : (384)
Heccer Options (dIntervalStart) : (-0.1)
Heccer Options (dIntervalEnd) : (0.05)
Heccer Options (dConcentrationGateStart) : (0)
Heccer Options (dConcentrationGateEnd) : (1000)
Heccer Options (iIntervalEntries) : (3000)
Heccer Options (iSmallTableSize) : (50)
Heccer (dTime) : (0.15)
Heccer (dStep) : (5e-05)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Tables (iTabulatedGateCount) : (10)
Compartment operations
-----
00000 :: FORWARD_ELIMINATION    0
00001 :: SET_DIAGONAL
00002 :: FORWARD_ELIMINATION    2
00003 :: SET_DIAGONAL
00004 :: FORWARD_ELIMINATION    4
00005 :: SET_DIAGONAL
00006 :: FORWARD_ELIMINATION    6
00007 :: SET_DIAGONAL
00008 :: FORWARD_ELIMINATION    8
00009 :: SET_DIAGONAL
00010 :: FORWARD_ELIMINATION   10
00011 :: SET_DIAGONAL
00012 :: FORWARD_ELIMINATION   12
00013 :: SET_DIAGONAL
00014 :: FORWARD_ELIMINATION   14
00015 :: SET_DIAGONAL
00016 :: FORWARD_ELIMINATION   16
00017 :: SET_DIAGONAL
00018 :: FORWARD_ELIMINATION   18
00019 :: SET_DIAGONAL
00020 :: FORWARD_ELIMINATION   20
00021 :: SET_DIAGONAL
00022 :: FORWARD_ELIMINATION   22
00023 :: SET_DIAGONAL
00024 :: FORWARD_ELIMINATION   24
00025 :: SET_DIAGONAL
00026 :: FORWARD_ELIMINATION   26
00027 :: SET_DIAGONAL
00028 :: FORWARD_ELIMINATION   28
00029 :: SET_DIAGONAL
00030 :: FORWARD_ELIMINATION   30
00031 :: SET_DIAGONAL
00032 :: FORWARD_ELIMINATION   32
00033 :: SET_DIAGONAL
00034 :: FORWARD_ELIMINATION   34
00035 :: FINISH
00036 :: BACKWARD_SUBSTITUTION   36
00037 :: FINISH_ROW
00038 :: BACKWARD_SUBSTITUTION   34
00039 :: FINISH_ROW
00040 :: BACKWARD_SUBSTITUTION   32
00041 :: FINISH_ROW
00042 :: BACKWARD_SUBSTITUTION   30
00043 :: FINISH_ROW
00044 :: BACKWARD_SUBSTITUTION   28
00045 :: FINISH_ROW
00046 :: BACKWARD_SUBSTITUTION   26
00047 :: FINISH_ROW
00048 :: BACKWARD_SUBSTITUTION   24
00049 :: FINISH_ROW
00050 :: BACKWARD_SUBSTITUTION   22
00051 :: FINISH_ROW
00052 :: BACKWARD_SUBSTITUTION   20
00053 :: FINISH_ROW
00054 :: BACKWARD_SUBSTITUTION   18
00055 :: FINISH_ROW
00056 :: BACKWARD_SUBSTITUTION   16
00057 :: FINISH_ROW
00058 :: BACKWARD_SUBSTITUTION   14
00059 :: FINISH_ROW
00060 :: BACKWARD_SUBSTITUTION   12
00061 :: FINISH_ROW
00062 :: BACKWARD_SUBSTITUTION   10
00063 :: FINISH_ROW
00064 :: BACKWARD_SUBSTITUTION    8
00065 :: FINISH_ROW
00066 :: BACKWARD_SUBSTITUTION    6
00067 :: FINISH_ROW
00068 :: BACKWARD_SUBSTITUTION    4
00069 :: FINISH_ROW
00070 :: BACKWARD_SUBSTITUTION    2
00071 :: FINISH_ROW
00072 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -1.00355e-10 0 498231 1.08417
00001 :: COMPARTMENT							 -1.00355e-10 0 498231 1.1675
00002 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (7.81077e-13) (nil) (nil) (nil)							 0.270707
00003 :: INITIALIZECHANNEL 0.08 8.36292e-08
00004 :: LOADVOLTAGETABLE
00005 :: CONCEPTGATE 0 2 (nil)							 0.00849931
00006 :: CONCEPTGATE 1 1 (nil)							 0.887104
00007 :: UPDATECOMPARTMENTCURRENT
00008 :: REGISTERCHANNELCURRENT
00009 :: FLUXPOOL							 7.81077e-13
00010 :: INITIALIZECHANNEL -0.075 1.33807e-08
00011 :: CONCEPTGATE 2 1 (0.270707)							 0.155816
00012 :: UPDATECOMPARTMENTCURRENT
00013 :: INITIALIZECHANNEL -0.075 8.36292e-08
00014 :: CONCEPTGATE 3 1 (nil)							 0.00630886
00015 :: CONCEPTGATE 4 -1 (0.270707)							 0
00016 :: UPDATECOMPARTMENTCURRENT
00017 :: COMPARTMENT							 -1.00355e-10 0 498231 1.1675
00018 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (7.80392e-13) (nil) (nil) (nil)							 0.271915
00019 :: INITIALIZECHANNEL 0.08 8.36292e-08
00020 :: LOADVOLTAGETABLE
00021 :: CONCEPTGATE 0 2 (nil)							 0.00849617
00022 :: CONCEPTGATE 1 1 (nil)							 0.886975
00023 :: UPDATECOMPARTMENTCURRENT
00024 :: REGISTERCHANNELCURRENT
00025 :: FLUXPOOL							 7.80392e-13
00026 :: INITIALIZECHANNEL -0.075 1.33807e-08
00027 :: CONCEPTGATE 2 1 (0.271915)							 0.160729
00028 :: UPDATECOMPARTMENTCURRENT
00029 :: INITIALIZECHANNEL -0.075 8.36292e-08
00030 :: CONCEPTGATE 3 1 (nil)							 0.00630809
00031 :: CONCEPTGATE 4 -1 (0.271915)							 0
00032 :: UPDATECOMPARTMENTCURRENT
00033 :: COMPARTMENT							 -1.00355e-10 0 498231 1.1675
00034 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (1.89353e-12) (nil) (nil) (nil)							 0.66988
00035 :: INITIALIZECHANNEL 0.08 2.0071e-07
00036 :: LOADVOLTAGETABLE
00037 :: CONCEPTGATE 0 2 (nil)							 0.00854456
00038 :: CONCEPTGATE 1 1 (nil)							 0.886944
00039 :: UPDATECOMPARTMENTCURRENT
00040 :: REGISTERCHANNELCURRENT
00041 :: FLUXPOOL							 1.89353e-12
00042 :: INITIALIZECHANNEL -0.075 1.33807e-08
00043 :: CONCEPTGATE 2 1 (0.66988)							 0.298662
00044 :: UPDATECOMPARTMENTCURRENT
00045 :: INITIALIZECHANNEL -0.075 1.67258e-07
00046 :: CONCEPTGATE 3 1 (nil)							 0.00633824
00047 :: CONCEPTGATE 4 -1 (0.66988)							 0.00266667
00048 :: UPDATECOMPARTMENTCURRENT
00049 :: COMPARTMENT							 -1.00355e-10 0 498231 1.1675
00050 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (1.96492e-12) (nil) (nil) (nil)							 0.569194
00051 :: INITIALIZECHANNEL 0.08 2.0071e-07
00052 :: LOADVOLTAGETABLE
00053 :: CONCEPTGATE 0 2 (nil)							 0.0086989
00054 :: CONCEPTGATE 1 1 (nil)							 0.889312
00055 :: UPDATECOMPARTMENTCURRENT
00056 :: REGISTERCHANNELCURRENT
00057 :: FLUXPOOL							 1.96492e-12
00058 :: INITIALIZECHANNEL -0.075 1.33807e-08
00059 :: CONCEPTGATE 2 1 (0.569194)							 0.279915
00060 :: UPDATECOMPARTMENTCURRENT
00061 :: INITIALIZECHANNEL -0.075 1.67258e-07
00062 :: CONCEPTGATE 3 1 (nil)							 0.00645455
00063 :: CONCEPTGATE 4 -1 (0.569194)							 0.00133333
00064 :: UPDATECOMPARTMENTCURRENT
00065 :: COMPARTMENT							 -1.00355e-10 0 498231 1.1675
00066 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (2.1059e-12) (nil) (nil) (nil)							 0.296681
00067 :: INITIALIZECHANNEL 0.055 3.34517e-07
00068 :: LOADVOLTAGETABLE
00069 :: CONCEPTGATE 5 2 (nil)							 0.0048369
00070 :: CONCEPTGATE 6 1 (nil)							 0.998908
00071 :: UPDATECOMPARTMENTCURRENT
00072 :: INITIALIZECHANNEL 0.08 2.0071e-07
00073 :: CONCEPTGATE 0 2 (nil)							 0.00897253
00074 :: CONCEPTGATE 1 1 (nil)							 0.898102
00075 :: UPDATECOMPARTMENTCURRENT
00076 :: REGISTERCHANNELCURRENT
00077 :: FLUXPOOL							 2.1059e-12
00078 :: INITIALIZECHANNEL -0.075 3.34517e-07
00079 :: CONCEPTGATE 7 1 (nil)							 0.000438224
00080 :: UPDATECOMPARTMENTCURRENT
00081 :: INITIALIZECHANNEL -0.075 1.33807e-08
00082 :: CONCEPTGATE 2 1 (0.296681)							 0.0963384
00083 :: UPDATECOMPARTMENTCURRENT
00084 :: INITIALIZECHANNEL -0.075 1.67258e-07
00085 :: CONCEPTGATE 3 1 (nil)							 0.00666322
00086 :: CONCEPTGATE 4 -1 (0.296681)							 0
00087 :: UPDATECOMPARTMENTCURRENT
00088 :: COMPARTMENT							 -1.00355e-10 0 498231 1.1675
00089 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (9.41451e-13) (nil) (nil) (nil)							 0.122237
00090 :: INITIALIZECHANNEL 0.08 8.36292e-08
00091 :: LOADVOLTAGETABLE
00092 :: CONCEPTGATE 0 2 (nil)							 0.00929492
00093 :: CONCEPTGATE 1 1 (nil)							 0.900253
00094 :: UPDATECOMPARTMENTCURRENT
00095 :: REGISTERCHANNELCURRENT
00096 :: FLUXPOOL							 9.41451e-13
00097 :: INITIALIZECHANNEL -0.075 1.33807e-08
00098 :: CONCEPTGATE 2 1 (0.122237)							 0.0318535
00099 :: UPDATECOMPARTMENTCURRENT
00100 :: INITIALIZECHANNEL -0.075 8.36292e-08
00101 :: CONCEPTGATE 3 1 (nil)							 0.00690997
00102 :: CONCEPTGATE 4 -1 (0.122237)							 0
00103 :: UPDATECOMPARTMENTCURRENT
00104 :: COMPARTMENT							 -1.00355e-10 0 498231 1.1675
00105 :: EXPONENTIALDECAY 1.7265e+09 0 1.00188
			 (1.60977e-12) (nil) (nil) (nil)							 0.860188
00106 :: INITIALIZECHANNEL 0.055 2.50888e-07
00107 :: LOADVOLTAGETABLE
00108 :: CONCEPTGATE 5 2 (nil)							 0.0056963
00109 :: CONCEPTGATE 6 1 (nil)							 0.998681
00110 :: UPDATECOMPARTMENTCURRENT
00111 :: INITIALIZECHANNEL 0.08 1.33807e-07
00112 :: CONCEPTGATE 0 2 (nil)							 0.00958836
00113 :: CONCEPTGATE 1 1 (nil)							 0.906297
00114 :: UPDATECOMPARTMENTCURRENT
00115 :: REGISTERCHANNELCURRENT
00116 :: FLUXPOOL							 1.60977e-12
00117 :: INITIALIZECHANNEL -0.075 8.36292e-08
00118 :: CONCEPTGATE 7 1 (nil)							 0.000508319
00119 :: UPDATECOMPARTMENTCURRENT
00120 :: INITIALIZECHANNEL -0.075 1.33807e-08
00121 :: CONCEPTGATE 2 1 (0.860188)							 0.143322
00122 :: UPDATECOMPARTMENTCURRENT
00123 :: INITIALIZECHANNEL -0.075 3.34517e-07
00124 :: CONCEPTGATE 3 1 (nil)							 0.00713337
00125 :: CONCEPTGATE 4 -1 (0.860188)							 0.00266667
00126 :: UPDATECOMPARTMENTCURRENT
00127 :: COMPARTMENT							 -1.99334e-10 2e-10 250835 1.11779
00128 :: EXPONENTIALDECAY 8.701e+08 0 1.00188
			 (1.71869e-12) (nil) (nil) (nil)							 0.468743
00129 :: INITIALIZECHANNEL 0.055 9.9667e-07
00130 :: LOADVOLTAGETABLE
00131 :: CONCEPTGATE 5 2 (nil)							 0.00621233
00132 :: CONCEPTGATE 6 1 (nil)							 0.998536
00133 :: UPDATECOMPARTMENTCURRENT
00134 :: INITIALIZECHANNEL 0.08 1.32889e-07
00135 :: CONCEPTGATE 0 2 (nil)							 0.00993528
00136 :: CONCEPTGATE 1 1 (nil)							 0.910083
00137 :: UPDATECOMPARTMENTCURRENT
00138 :: REGISTERCHANNELCURRENT
00139 :: FLUXPOOL							 1.71869e-12
00140 :: INITIALIZECHANNEL -0.075 4.98335e-07
00141 :: CONCEPTGATE 7 1 (nil)							 0.000551424
00142 :: UPDATECOMPARTMENTCURRENT
00143 :: INITIALIZECHANNEL -0.075 2.65779e-08
00144 :: CONCEPTGATE 2 1 (0.468743)							 0.0780395
00145 :: UPDATECOMPARTMENTCURRENT
00146 :: INITIALIZECHANNEL -0.075 3.32223e-07
00147 :: CONCEPTGATE 3 1 (nil)							 0.00739755
00148 :: CONCEPTGATE 4 -1 (0.468743)							 0.00133333
00149 :: UPDATECOMPARTMENTCURRENT
00150 :: INITIALIZECHANNEL -0.075 1.66112e-07
00151 :: CONCEPTGATE 8 1 (nil)							 0.0881389
00152 :: CONCEPTGATE 9 1 (nil)							 0.0931134
00153 :: UPDATECOMPARTMENTCURRENT
00154 :: COMPARTMENT							 -1.30741e-10 0 382437 1.21711
00155 :: EXPONENTIALDECAY 1.3202e+09 0 1.00188
			 (2.12314e-12) (nil) (nil) (nil)							 0.852216
00156 :: INITIALIZECHANNEL 0.055 3.26851e-07
00157 :: LOADVOLTAGETABLE
00158 :: CONCEPTGATE 5 2 (nil)							 0.0057585
00159 :: CONCEPTGATE 6 1 (nil)							 0.998662
00160 :: UPDATECOMPARTMENTCURRENT
00161 :: INITIALIZECHANNEL 0.08 1.74321e-07
00162 :: CONCEPTGATE 0 2 (nil)							 0.00963147
00163 :: CONCEPTGATE 1 1 (nil)							 0.909678
00164 :: UPDATECOMPARTMENTCURRENT
00165 :: REGISTERCHANNELCURRENT
00166 :: FLUXPOOL							 2.12314e-12
00167 :: INITIALIZECHANNEL -0.075 1.0895e-07
00168 :: CONCEPTGATE 7 1 (nil)							 0.000513932
00169 :: UPDATECOMPARTMENTCURRENT
00170 :: INITIALIZECHANNEL -0.075 1.74321e-08
00171 :: CONCEPTGATE 2 1 (0.852216)							 0.138345
00172 :: UPDATECOMPARTMENTCURRENT
00173 :: INITIALIZECHANNEL -0.075 4.35802e-07
00174 :: CONCEPTGATE 3 1 (nil)							 0.00716587
00175 :: CONCEPTGATE 4 -1 (0.852216)							 0.00266667
00176 :: UPDATECOMPARTMENTCURRENT
00177 :: COMPARTMENT							 -1.30741e-10 0 382437 1.18638
00178 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (1.24707e-12) (nil) (nil) (nil)							 0.114881
00179 :: INITIALIZECHANNEL 0.08 1.0895e-07
00180 :: LOADVOLTAGETABLE
00181 :: CONCEPTGATE 0 2 (nil)							 0.00933698
00182 :: CONCEPTGATE 1 1 (nil)							 0.90746
00183 :: UPDATECOMPARTMENTCURRENT
00184 :: REGISTERCHANNELCURRENT
00185 :: FLUXPOOL							 1.24707e-12
00186 :: INITIALIZECHANNEL -0.075 1.74321e-08
00187 :: CONCEPTGATE 2 1 (0.114881)							 0.0264185
00188 :: UPDATECOMPARTMENTCURRENT
00189 :: INITIALIZECHANNEL -0.075 1.0895e-07
00190 :: CONCEPTGATE 3 1 (nil)							 0.00694146
00191 :: CONCEPTGATE 4 -1 (0.114881)							 0
00192 :: UPDATECOMPARTMENTCURRENT
00193 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00194 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (3.92275e-12) (nil) (nil) (nil)							 0.378782
00195 :: INITIALIZECHANNEL 0.055 4.35802e-07
00196 :: LOADVOLTAGETABLE
00197 :: CONCEPTGATE 5 2 (nil)							 0.0048369
00198 :: CONCEPTGATE 6 1 (nil)							 0.998916
00199 :: UPDATECOMPARTMENTCURRENT
00200 :: INITIALIZECHANNEL 0.08 3.70431e-07
00201 :: CONCEPTGATE 0 2 (nil)							 0.00896179
00202 :: CONCEPTGATE 1 1 (nil)							 0.908425
00203 :: UPDATECOMPARTMENTCURRENT
00204 :: REGISTERCHANNELCURRENT
00205 :: FLUXPOOL							 3.92275e-12
00206 :: INITIALIZECHANNEL -0.075 4.35802e-07
00207 :: CONCEPTGATE 7 1 (nil)							 0.00043574
00208 :: UPDATECOMPARTMENTCURRENT
00209 :: INITIALIZECHANNEL -0.075 1.74321e-08
00210 :: CONCEPTGATE 2 1 (0.378782)							 0.11186
00211 :: UPDATECOMPARTMENTCURRENT
00212 :: INITIALIZECHANNEL -0.075 3.26851e-07
00213 :: CONCEPTGATE 3 1 (nil)							 0.00666235
00214 :: CONCEPTGATE 4 -1 (0.378782)							 0.00133333
00215 :: UPDATECOMPARTMENTCURRENT
00216 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00217 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (3.62296e-12) (nil) (nil) (nil)							 0.579957
00218 :: INITIALIZECHANNEL 0.08 3.70431e-07
00219 :: LOADVOLTAGETABLE
00220 :: CONCEPTGATE 0 2 (nil)							 0.0086219
00221 :: CONCEPTGATE 1 1 (nil)							 0.903728
00222 :: UPDATECOMPARTMENTCURRENT
00223 :: REGISTERCHANNELCURRENT
00224 :: FLUXPOOL							 3.62296e-12
00225 :: INITIALIZECHANNEL -0.075 1.74321e-08
00226 :: CONCEPTGATE 2 1 (0.579957)							 0.290468
00227 :: UPDATECOMPARTMENTCURRENT
00228 :: INITIALIZECHANNEL -0.075 3.26851e-07
00229 :: CONCEPTGATE 3 1 (nil)							 0.00639613
00230 :: CONCEPTGATE 4 -1 (0.579957)							 0.00133333
00231 :: UPDATECOMPARTMENTCURRENT
00232 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00233 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (3.44748e-12) (nil) (nil) (nil)							 0.606986
00234 :: INITIALIZECHANNEL 0.08 3.70431e-07
00235 :: LOADVOLTAGETABLE
00236 :: CONCEPTGATE 0 2 (nil)							 0.0083967
00237 :: CONCEPTGATE 1 1 (nil)							 0.904891
00238 :: UPDATECOMPARTMENTCURRENT
00239 :: REGISTERCHANNELCURRENT
00240 :: FLUXPOOL							 3.44748e-12
00241 :: INITIALIZECHANNEL -0.075 1.74321e-08
00242 :: CONCEPTGATE 2 1 (0.606986)							 0.297468
00243 :: UPDATECOMPARTMENTCURRENT
00244 :: INITIALIZECHANNEL -0.075 3.26851e-07
00245 :: CONCEPTGATE 3 1 (nil)							 0.00622405
00246 :: CONCEPTGATE 4 -1 (0.606986)							 0.00133333
00247 :: UPDATECOMPARTMENTCURRENT
00248 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00249 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (1.9853e-12) (nil) (nil) (nil)							 0.299012
00250 :: INITIALIZECHANNEL 0.08 2.17901e-07
00251 :: LOADVOLTAGETABLE
00252 :: CONCEPTGATE 0 2 (nil)							 0.00828619
00253 :: CONCEPTGATE 1 1 (nil)							 0.908739
00254 :: UPDATECOMPARTMENTCURRENT
00255 :: REGISTERCHANNELCURRENT
00256 :: FLUXPOOL							 1.9853e-12
00257 :: INITIALIZECHANNEL -0.075 1.74321e-08
00258 :: CONCEPTGATE 2 1 (0.299012)							 0.203781
00259 :: UPDATECOMPARTMENTCURRENT
00260 :: INITIALIZECHANNEL -0.075 3.26851e-07
00261 :: CONCEPTGATE 3 1 (nil)							 0.00613976
00262 :: CONCEPTGATE 4 -1 (0.299012)							 0
00263 :: UPDATECOMPARTMENTCURRENT
00264 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00265 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (1.96872e-12) (nil) (nil) (nil)							 0.308346
00266 :: INITIALIZECHANNEL 0.08 2.17901e-07
00267 :: LOADVOLTAGETABLE
00268 :: CONCEPTGATE 0 2 (nil)							 0.00824587
00269 :: CONCEPTGATE 1 1 (nil)							 0.90955
00270 :: UPDATECOMPARTMENTCURRENT
00271 :: REGISTERCHANNELCURRENT
00272 :: FLUXPOOL							 1.96872e-12
00273 :: INITIALIZECHANNEL -0.075 1.74321e-08
00274 :: CONCEPTGATE 2 1 (0.308346)							 0.205262
00275 :: UPDATECOMPARTMENTCURRENT
00276 :: INITIALIZECHANNEL -0.075 3.26851e-07
00277 :: CONCEPTGATE 3 1 (nil)							 0.00611186
00278 :: CONCEPTGATE 4 -1 (0.308346)							 0
00279 :: UPDATECOMPARTMENTCURRENT
00280 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00281 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (9.8329e-13) (nil) (nil) (nil)							 0.179712
00282 :: INITIALIZECHANNEL 0.08 1.0895e-07
00283 :: LOADVOLTAGETABLE
00284 :: CONCEPTGATE 0 2 (nil)							 0.00824928
00285 :: CONCEPTGATE 1 1 (nil)							 0.907863
00286 :: UPDATECOMPARTMENTCURRENT
00287 :: REGISTERCHANNELCURRENT
00288 :: FLUXPOOL							 9.8329e-13
00289 :: INITIALIZECHANNEL -0.075 1.74321e-08
00290 :: CONCEPTGATE 2 1 (0.179712)							 0.124733
00291 :: UPDATECOMPARTMENTCURRENT
00292 :: INITIALIZECHANNEL -0.075 1.0895e-07
00293 :: CONCEPTGATE 3 1 (nil)							 0.00611191
00294 :: CONCEPTGATE 4 -1 (0.179712)							 0
00295 :: UPDATECOMPARTMENTCURRENT
00296 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00297 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (9.8273e-13) (nil) (nil) (nil)							 0.188291
00298 :: INITIALIZECHANNEL 0.08 1.0895e-07
00299 :: LOADVOLTAGETABLE
00300 :: CONCEPTGATE 0 2 (nil)							 0.0082497
00301 :: CONCEPTGATE 1 1 (nil)							 0.907456
00302 :: UPDATECOMPARTMENTCURRENT
00303 :: REGISTERCHANNELCURRENT
00304 :: FLUXPOOL							 9.8273e-13
00305 :: INITIALIZECHANNEL -0.075 1.74321e-08
00306 :: CONCEPTGATE 2 1 (0.188291)							 0.124706
00307 :: UPDATECOMPARTMENTCURRENT
00308 :: INITIALIZECHANNEL -0.075 1.0895e-07
00309 :: CONCEPTGATE 3 1 (nil)							 0.00611191
00310 :: CONCEPTGATE 4 -1 (0.188291)							 0
00311 :: UPDATECOMPARTMENTCURRENT
00312 :: COMPARTMENT							 -1.30741e-10 0 382437 1.08446
00313 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.08417)
VM Diagonals (pdDiagonals[1]) : (1.1675)
VM Diagonals (pdDiagonals[2]) : (1.1675)
VM Diagonals (pdDiagonals[3]) : (1.1675)
VM Diagonals (pdDiagonals[4]) : (1.1675)
VM Diagonals (pdDiagonals[5]) : (1.1675)
VM Diagonals (pdDiagonals[6]) : (1.1675)
VM Diagonals (pdDiagonals[7]) : (1.1675)
VM Diagonals (pdDiagonals[8]) : (1.11779)
VM Diagonals (pdDiagonals[9]) : (1.21711)
VM Diagonals (pdDiagonals[10]) : (1.18638)
VM Diagonals (pdDiagonals[11]) : (1.16808)
VM Diagonals (pdDiagonals[12]) : (1.16808)
VM Diagonals (pdDiagonals[13]) : (1.16808)
VM Diagonals (pdDiagonals[14]) : (1.16808)
VM Diagonals (pdDiagonals[15]) : (1.16808)
VM Diagonals (pdDiagonals[16]) : (1.16808)
VM Diagonals (pdDiagonals[17]) : (1.16808)
VM Diagonals (pdDiagonals[18]) : (1.08446)
VM Axial Resistances (pdAxres[0]) : (-0.0833333)
VM Axial Resistances (pdAxres[1]) : (-0.0833333)
VM Axial Resistances (pdAxres[2]) : (-0.0833333)
VM Axial Resistances (pdAxres[3]) : (-0.0833333)
VM Axial Resistances (pdAxres[4]) : (-0.0833333)
VM Axial Resistances (pdAxres[5]) : (-0.0833333)
VM Axial Resistances (pdAxres[6]) : (-0.0833333)
VM Axial Resistances (pdAxres[7]) : (-0.0833333)
VM Axial Resistances (pdAxres[8]) : (-0.0833333)
VM Axial Resistances (pdAxres[9]) : (-0.0833333)
VM Axial Resistances (pdAxres[10]) : (-0.0833333)
VM Axial Resistances (pdAxres[11]) : (-0.0833333)
VM Axial Resistances (pdAxres[12]) : (-0.0833333)
VM Axial Resistances (pdAxres[13]) : (-0.0833333)
VM Axial Resistances (pdAxres[14]) : (-0.0419543)
VM Axial Resistances (pdAxres[15]) : (-0.0833333)
VM Axial Resistances (pdAxres[16]) : (-0.114355)
VM Axial Resistances (pdAxres[17]) : (-0.0750041)
VM Axial Resistances (pdAxres[18]) : (-0.101926)
VM Axial Resistances (pdAxres[19]) : (-0.101926)
VM Axial Resistances (pdAxres[20]) : (-0.0836227)
VM Axial Resistances (pdAxres[21]) : (-0.0836227)
VM Axial Resistances (pdAxres[22]) : (-0.0836227)
VM Axial Resistances (pdAxres[23]) : (-0.0836227)
VM Axial Resistances (pdAxres[24]) : (-0.0836227)
VM Axial Resistances (pdAxres[25]) : (-0.0836227)
VM Axial Resistances (pdAxres[26]) : (-0.0836227)
VM Axial Resistances (pdAxres[27]) : (-0.0836227)
VM Axial Resistances (pdAxres[28]) : (-0.0836227)
VM Axial Resistances (pdAxres[29]) : (-0.0836227)
VM Axial Resistances (pdAxres[30]) : (-0.0836227)
VM Axial Resistances (pdAxres[31]) : (-0.0836227)
VM Axial Resistances (pdAxres[32]) : (-0.0836227)
VM Axial Resistances (pdAxres[33]) : (-0.0836227)
VM Axial Resistances (pdAxres[34]) : (-0.0836227)
VM Axial Resistances (pdAxres[35]) : (-0.0836227)
VM Axial Resistances (pdAxres[36]) : (-0.0836227)
VM Axial Resistances (pdAxres[37]) : (-0.0836227)
VM Axial Resistances (pdAxres[38]) : (-0.0836227)
VM Axial Resistances (pdAxres[39]) : (-0.0836227)
VM Axial Resistances (pdAxres[40]) : (-0.0836227)
VM Axial Resistances (pdAxres[41]) : (-0.0836227)
VM Axial Resistances (pdAxres[42]) : (-0.0836227)
VM Axial Resistances (pdAxres[43]) : (-0.0836227)
VM Axial Resistances (pdAxres[44]) : (-0.101926)
VM Axial Resistances (pdAxres[45]) : (-0.0750041)
VM Axial Resistances (pdAxres[46]) : (-0.0833333)
VM Axial Resistances (pdAxres[47]) : (-0.0833333)
VM Axial Resistances (pdAxres[48]) : (-0.0833333)
VM Axial Resistances (pdAxres[49]) : (-0.0833333)
VM Axial Resistances (pdAxres[50]) : (-0.0833333)
VM Axial Resistances (pdAxres[51]) : (-0.0833333)
VM Axial Resistances (pdAxres[52]) : (-0.0833333)
VM Axial Resistances (pdAxres[53]) : (-0.0833333)
VM Axial Resistances (pdResults[0]) : (-0.0656893)
VM Axial Resistances (pdResults[1]) : (1.08417)
VM Axial Resistances (pdResults[2]) : (-0.0657449)
VM Axial Resistances (pdResults[3]) : (1.16214)
VM Axial Resistances (pdResults[4]) : (-0.065746)
VM Axial Resistances (pdResults[5]) : (1.1626)
VM Axial Resistances (pdResults[6]) : (-0.065689)
VM Axial Resistances (pdResults[7]) : (1.16353)
VM Axial Resistances (pdResults[8]) : (-0.0654763)
VM Axial Resistances (pdResults[9]) : (1.16341)
VM Axial Resistances (pdResults[10]) : (-0.0651155)
VM Axial Resistances (pdResults[11]) : (1.16226)
VM Axial Resistances (pdResults[12]) : (-0.0647381)
VM Axial Resistances (pdResults[13]) : (1.16174)
VM Axial Resistances (pdResults[14]) : (-0.0643864)
VM Axial Resistances (pdResults[15]) : (1.16251)
VM Axial Resistances (pdResults[16]) : (-0.0639681)
VM Axial Resistances (pdResults[17]) : (1.11573)
VM Axial Resistances (pdResults[18]) : (-0.06433)
VM Axial Resistances (pdResults[19]) : (1.21038)
VM Axial Resistances (pdResults[20]) : (-0.0646841)
VM Axial Resistances (pdResults[21]) : (1.17798)
VM Axial Resistances (pdResults[22]) : (-0.0651453)
VM Axial Resistances (pdResults[23]) : (1.16298)
VM Axial Resistances (pdResults[24]) : (-0.0655836)
VM Axial Resistances (pdResults[25]) : (1.16401)
VM Axial Resistances (pdResults[26]) : (-0.0658745)
VM Axial Resistances (pdResults[27]) : (1.16406)
VM Axial Resistances (pdResults[28]) : (-0.066022)
VM Axial Resistances (pdResults[29]) : (1.16344)
VM Axial Resistances (pdResults[30]) : (-0.0660913)
VM Axial Resistances (pdResults[31]) : (1.16344)
VM Axial Resistances (pdResults[32]) : (-0.0660833)
VM Axial Resistances (pdResults[33]) : (1.1629)
VM Axial Resistances (pdResults[34]) : (-0.0660503)
VM Axial Resistances (pdResults[35]) : (1.1629)
VM Axial Resistances (pdResults[36]) : (-0.0659919)
VM Axial Resistances (pdResults[37]) : (1.08446)
VM Membrane Potentials (pdVms[0]) : (-0.0656892)
VM Membrane Potentials (pdVms[1]) : (-0.0657448)
VM Membrane Potentials (pdVms[2]) : (-0.0657459)
VM Membrane Potentials (pdVms[3]) : (-0.0656889)
VM Membrane Potentials (pdVms[4]) : (-0.0654762)
VM Membrane Potentials (pdVms[5]) : (-0.0651154)
VM Membrane Potentials (pdVms[6]) : (-0.064738)
VM Membrane Potentials (pdVms[7]) : (-0.0643863)
VM Membrane Potentials (pdVms[8]) : (-0.0639681)
VM Membrane Potentials (pdVms[9]) : (-0.0643299)
VM Membrane Potentials (pdVms[10]) : (-0.064684)
VM Membrane Potentials (pdVms[11]) : (-0.0651452)
VM Membrane Potentials (pdVms[12]) : (-0.0655835)
VM Membrane Potentials (pdVms[13]) : (-0.0658744)
VM Membrane Potentials (pdVms[14]) : (-0.0660219)
VM Membrane Potentials (pdVms[15]) : (-0.0660912)
VM Membrane Potentials (pdVms[16]) : (-0.0660832)
VM Membrane Potentials (pdVms[17]) : (-0.0660502)
VM Membrane Potentials (pdVms[18]) : (-0.0659918)
',
						   write => 'call /neurospaces_integrator NSINTEGRATOR_DUMP',
						  },
						  {
						   description => 'Quit the simulator.',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the application output file correct (5) ?",
						   numerical_compare => 'small differences on the tester machine.',
						   read => {
							    application_output_file => "/tmp/traub91_sym",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_sym.txt",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts.',
				description => "the traub91 model, symmetric compartment version.",
				numerical_compare => 'uses the same expected output as for the asymmetric test model',
			       },
			       {
				arguments => [
					      '--time',
					      '0.15',
					      '--time-step',
					      '5e-5',
					      '--cell',
					      '/tmp/traub91.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					      '--optimize',
					      '--verbose',
					      '--dump',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we compile the converted model description from SSP, traub91.ndf ?',
						   read => '
Heccer (pcName) : (unnamed test)
Heccer (iStatus) : (20)
Heccer (iErrorCount) : (0)
Heccer Options (iOptions) : (0)
Heccer Options (dIntervalStart) : (-0.1)
Heccer Options (dIntervalEnd) : (0.05)
Heccer Options (dConcentrationGateStart) : (4e-05)
Heccer Options (dConcentrationGateEnd) : (0.3)
Heccer Options (iIntervalEntries) : (3000)
Heccer Options (iSmallTableSize) : (149)
Heccer (dTime) : (0)
Heccer (dStep) : (5e-05)
Intermediary (iCompartments) : (19)
Compartment (mc.iType) : (1)
Compartment (iParent) : (-1)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (0)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (1)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (2)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (3)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (4)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (5)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (6)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (7)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (8)
Compartment (dCm) : (6.53703e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (4.57336e+06)
Compartment (dRm) : (4.58924e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (9)
Compartment (dCm) : (9.96669e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (2e-10)
Compartment (dRa) : (2.22372e+06)
Compartment (dRm) : (3.01003e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (10)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (11)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (12)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (13)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (14)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (15)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (16)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (17)
Compartment (dCm) : (5.01774e-11)
Compartment (dEm) : (-0.06)
Compartment (dInitVm) : (-0.06)
Compartment (dInject) : (0)
Compartment (dRa) : (5.97877e+06)
Compartment (dRm) : (5.97879e+08)
MinimumDegree (iEntries) : (19)
MinimumDegree (piChildren[0]) : (1)
MinimumDegree (piChildren[0][0]) : (1)
MinimumDegree (piChildren[1]) : (1)
MinimumDegree (piChildren[1][0]) : (2)
MinimumDegree (piChildren[2]) : (1)
MinimumDegree (piChildren[2][0]) : (3)
MinimumDegree (piChildren[3]) : (1)
MinimumDegree (piChildren[3][0]) : (4)
MinimumDegree (piChildren[4]) : (1)
MinimumDegree (piChildren[4][0]) : (5)
MinimumDegree (piChildren[5]) : (1)
MinimumDegree (piChildren[5][0]) : (6)
MinimumDegree (piChildren[6]) : (1)
MinimumDegree (piChildren[6][0]) : (7)
MinimumDegree (piChildren[7]) : (1)
MinimumDegree (piChildren[7][0]) : (8)
MinimumDegree (piChildren[8]) : (1)
MinimumDegree (piChildren[8][0]) : (9)
MinimumDegree (piChildren[9]) : (1)
MinimumDegree (piChildren[9][0]) : (10)
MinimumDegree (piChildren[10]) : (1)
MinimumDegree (piChildren[10][0]) : (11)
MinimumDegree (piChildren[11]) : (1)
MinimumDegree (piChildren[11][0]) : (12)
MinimumDegree (piChildren[12]) : (1)
MinimumDegree (piChildren[12][0]) : (13)
MinimumDegree (piChildren[13]) : (1)
MinimumDegree (piChildren[13][0]) : (14)
MinimumDegree (piChildren[14]) : (1)
MinimumDegree (piChildren[14][0]) : (15)
MinimumDegree (piChildren[15]) : (1)
MinimumDegree (piChildren[15][0]) : (16)
MinimumDegree (piChildren[16]) : (1)
MinimumDegree (piChildren[16][0]) : (17)
MinimumDegree (piChildren[17]) : (1)
MinimumDegree (piChildren[17][0]) : (18)
MinimumDegree (piChildren[18]) : (0)
MinimumDegree (piForward[0]) : (18)
MinimumDegree (piForward[1]) : (17)
MinimumDegree (piForward[2]) : (16)
MinimumDegree (piForward[3]) : (15)
MinimumDegree (piForward[4]) : (14)
MinimumDegree (piForward[5]) : (13)
MinimumDegree (piForward[6]) : (12)
MinimumDegree (piForward[7]) : (11)
MinimumDegree (piForward[8]) : (10)
MinimumDegree (piForward[9]) : (9)
MinimumDegree (piForward[10]) : (8)
MinimumDegree (piForward[11]) : (7)
MinimumDegree (piForward[12]) : (6)
MinimumDegree (piForward[13]) : (5)
MinimumDegree (piForward[14]) : (4)
MinimumDegree (piForward[15]) : (3)
MinimumDegree (piForward[16]) : (2)
MinimumDegree (piForward[17]) : (1)
MinimumDegree (piForward[18]) : (0)
MinimumDegree (piBackward[0]) : (18)
MinimumDegree (piBackward[1]) : (17)
MinimumDegree (piBackward[2]) : (16)
MinimumDegree (piBackward[3]) : (15)
MinimumDegree (piBackward[4]) : (14)
MinimumDegree (piBackward[5]) : (13)
MinimumDegree (piBackward[6]) : (12)
MinimumDegree (piBackward[7]) : (11)
MinimumDegree (piBackward[8]) : (10)
MinimumDegree (piBackward[9]) : (9)
MinimumDegree (piBackward[10]) : (8)
MinimumDegree (piBackward[11]) : (7)
MinimumDegree (piBackward[12]) : (6)
MinimumDegree (piBackward[13]) : (5)
MinimumDegree (piBackward[14]) : (4)
MinimumDegree (piBackward[15]) : (3)
MinimumDegree (piBackward[16]) : (2)
MinimumDegree (piBackward[17]) : (1)
MinimumDegree (piBackward[18]) : (0)
Tables (iTabulatedGateCount) : (10)
Tabulated gate 0, interval (dStart) : (-0.1)
Tabulated gate 0, interval (dEnd) : (0.05)
Tabulated gate 0, interval (dStep) : (5e-05)
Tabulated gate 0, interpolation (iShape) : (0)
Tabulated gate 0, (iEntries) : (3000)
Tabulated gate 1, interval (dStart) : (-0.1)
Tabulated gate 1, interval (dEnd) : (0.05)
Tabulated gate 1, interval (dStep) : (5e-05)
Tabulated gate 1, interpolation (iShape) : (0)
Tabulated gate 1, (iEntries) : (3000)
Tabulated gate 2, interval (dStart) : (0)
Tabulated gate 2, interval (dEnd) : (1000)
Tabulated gate 2, interval (dStep) : (0.333333)
Tabulated gate 2, interpolation (iShape) : (0)
Tabulated gate 2, (iEntries) : (3000)
Tabulated gate 3, interval (dStart) : (-0.1)
Tabulated gate 3, interval (dEnd) : (0.05)
Tabulated gate 3, interval (dStep) : (5e-05)
Tabulated gate 3, interpolation (iShape) : (0)
Tabulated gate 3, (iEntries) : (3000)
Tabulated gate 4, interval (dStart) : (0)
Tabulated gate 4, interval (dEnd) : (1000)
Tabulated gate 4, interval (dStep) : (0.333333)
Tabulated gate 4, interpolation (iShape) : (0)
Tabulated gate 4, (iEntries) : (3000)
Tabulated gate 5, interval (dStart) : (-0.1)
Tabulated gate 5, interval (dEnd) : (0.05)
Tabulated gate 5, interval (dStep) : (5e-05)
Tabulated gate 5, interpolation (iShape) : (0)
Tabulated gate 5, (iEntries) : (3000)
Tabulated gate 6, interval (dStart) : (-0.1)
Tabulated gate 6, interval (dEnd) : (0.05)
Tabulated gate 6, interval (dStep) : (5e-05)
Tabulated gate 6, interpolation (iShape) : (0)
Tabulated gate 6, (iEntries) : (3000)
Tabulated gate 7, interval (dStart) : (-0.1)
Tabulated gate 7, interval (dEnd) : (0.05)
Tabulated gate 7, interval (dStep) : (5e-05)
Tabulated gate 7, interpolation (iShape) : (0)
Tabulated gate 7, (iEntries) : (3000)
Tabulated gate 8, interval (dStart) : (-0.1)
Tabulated gate 8, interval (dEnd) : (0.05)
Tabulated gate 8, interval (dStep) : (5e-05)
Tabulated gate 8, interpolation (iShape) : (0)
Tabulated gate 8, (iEntries) : (3000)
Tabulated gate 9, interval (dStart) : (-0.1)
Tabulated gate 9, interval (dEnd) : (0.05)
Tabulated gate 9, interval (dStep) : (5e-05)
Tabulated gate 9, interpolation (iShape) : (0)
Tabulated gate 9, (iEntries) : (3000)
Compartment operations
-----
00000 :: FORWARD_ELIMINATION    0
00001 :: SET_DIAGONAL
00002 :: FORWARD_ELIMINATION    2
00003 :: SET_DIAGONAL
00004 :: FORWARD_ELIMINATION    4
00005 :: SET_DIAGONAL
00006 :: FORWARD_ELIMINATION    6
00007 :: SET_DIAGONAL
00008 :: FORWARD_ELIMINATION    8
00009 :: SET_DIAGONAL
00010 :: FORWARD_ELIMINATION   10
00011 :: SET_DIAGONAL
00012 :: FORWARD_ELIMINATION   12
00013 :: SET_DIAGONAL
00014 :: FORWARD_ELIMINATION   14
00015 :: SET_DIAGONAL
00016 :: FORWARD_ELIMINATION   16
00017 :: SET_DIAGONAL
00018 :: FORWARD_ELIMINATION   18
00019 :: SET_DIAGONAL
00020 :: FORWARD_ELIMINATION   20
00021 :: SET_DIAGONAL
00022 :: FORWARD_ELIMINATION   22
00023 :: SET_DIAGONAL
00024 :: FORWARD_ELIMINATION   24
00025 :: SET_DIAGONAL
00026 :: FORWARD_ELIMINATION   26
00027 :: SET_DIAGONAL
00028 :: FORWARD_ELIMINATION   28
00029 :: SET_DIAGONAL
00030 :: FORWARD_ELIMINATION   30
00031 :: SET_DIAGONAL
00032 :: FORWARD_ELIMINATION   32
00033 :: SET_DIAGONAL
00034 :: FORWARD_ELIMINATION   34
00035 :: FINISH
00036 :: BACKWARD_SUBSTITUTION   36
00037 :: FINISH_ROW
00038 :: BACKWARD_SUBSTITUTION   34
00039 :: FINISH_ROW
00040 :: BACKWARD_SUBSTITUTION   32
00041 :: FINISH_ROW
00042 :: BACKWARD_SUBSTITUTION   30
00043 :: FINISH_ROW
00044 :: BACKWARD_SUBSTITUTION   28
00045 :: FINISH_ROW
00046 :: BACKWARD_SUBSTITUTION   26
00047 :: FINISH_ROW
00048 :: BACKWARD_SUBSTITUTION   24
00049 :: FINISH_ROW
00050 :: BACKWARD_SUBSTITUTION   22
00051 :: FINISH_ROW
00052 :: BACKWARD_SUBSTITUTION   20
00053 :: FINISH_ROW
00054 :: BACKWARD_SUBSTITUTION   18
00055 :: FINISH_ROW
00056 :: BACKWARD_SUBSTITUTION   16
00057 :: FINISH_ROW
00058 :: BACKWARD_SUBSTITUTION   14
00059 :: FINISH_ROW
00060 :: BACKWARD_SUBSTITUTION   12
00061 :: FINISH_ROW
00062 :: BACKWARD_SUBSTITUTION   10
00063 :: FINISH_ROW
00064 :: BACKWARD_SUBSTITUTION    8
00065 :: FINISH_ROW
00066 :: BACKWARD_SUBSTITUTION    6
00067 :: FINISH_ROW
00068 :: BACKWARD_SUBSTITUTION    4
00069 :: FINISH_ROW
00070 :: BACKWARD_SUBSTITUTION    2
00071 :: FINISH_ROW
00072 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -1.00355e-10 0 498232 1.08417
00001 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00002 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00003 :: INITIALIZECHANNEL 0.08 8.36292e-08
00004 :: LOADVOLTAGETABLE
00005 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00006 :: CONCEPTGATE 1 1 (nil)							 0.973086
00007 :: UPDATECOMPARTMENTCURRENT
00008 :: REGISTERCHANNELCURRENT
00009 :: FLUXPOOL							 0
00010 :: INITIALIZECHANNEL -0.075 1.33807e-08
00011 :: CONCEPTGATE 2 1 (0)							 0
00012 :: UPDATECOMPARTMENTCURRENT
00013 :: INITIALIZECHANNEL -0.075 8.36292e-08
00014 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00015 :: CONCEPTGATE 4 -1 (0)							 0
00016 :: UPDATECOMPARTMENTCURRENT
00017 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00018 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00019 :: INITIALIZECHANNEL 0.08 8.36292e-08
00020 :: LOADVOLTAGETABLE
00021 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00022 :: CONCEPTGATE 1 1 (nil)							 0.973086
00023 :: UPDATECOMPARTMENTCURRENT
00024 :: REGISTERCHANNELCURRENT
00025 :: FLUXPOOL							 0
00026 :: INITIALIZECHANNEL -0.075 1.33807e-08
00027 :: CONCEPTGATE 2 1 (0)							 0
00028 :: UPDATECOMPARTMENTCURRENT
00029 :: INITIALIZECHANNEL -0.075 8.36292e-08
00030 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00031 :: CONCEPTGATE 4 -1 (0)							 0
00032 :: UPDATECOMPARTMENTCURRENT
00033 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00034 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00035 :: INITIALIZECHANNEL 0.08 2.0071e-07
00036 :: LOADVOLTAGETABLE
00037 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00038 :: CONCEPTGATE 1 1 (nil)							 0.973086
00039 :: UPDATECOMPARTMENTCURRENT
00040 :: REGISTERCHANNELCURRENT
00041 :: FLUXPOOL							 0
00042 :: INITIALIZECHANNEL -0.075 1.33807e-08
00043 :: CONCEPTGATE 2 1 (0)							 0
00044 :: UPDATECOMPARTMENTCURRENT
00045 :: INITIALIZECHANNEL -0.075 1.67258e-07
00046 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00047 :: CONCEPTGATE 4 -1 (0)							 0
00048 :: UPDATECOMPARTMENTCURRENT
00049 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00050 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00051 :: INITIALIZECHANNEL 0.08 2.0071e-07
00052 :: LOADVOLTAGETABLE
00053 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00054 :: CONCEPTGATE 1 1 (nil)							 0.973086
00055 :: UPDATECOMPARTMENTCURRENT
00056 :: REGISTERCHANNELCURRENT
00057 :: FLUXPOOL							 0
00058 :: INITIALIZECHANNEL -0.075 1.33807e-08
00059 :: CONCEPTGATE 2 1 (0)							 0
00060 :: UPDATECOMPARTMENTCURRENT
00061 :: INITIALIZECHANNEL -0.075 1.67258e-07
00062 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00063 :: CONCEPTGATE 4 -1 (0)							 0
00064 :: UPDATECOMPARTMENTCURRENT
00065 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00066 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00067 :: INITIALIZECHANNEL 0.055 3.34517e-07
00068 :: LOADVOLTAGETABLE
00069 :: CONCEPTGATE 5 2 (nil)							 0.014457
00070 :: CONCEPTGATE 6 1 (nil)							 0.995941
00071 :: UPDATECOMPARTMENTCURRENT
00072 :: INITIALIZECHANNEL 0.08 2.0071e-07
00073 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00074 :: CONCEPTGATE 1 1 (nil)							 0.973086
00075 :: UPDATECOMPARTMENTCURRENT
00076 :: REGISTERCHANNELCURRENT
00077 :: FLUXPOOL							 0
00078 :: INITIALIZECHANNEL -0.075 3.34517e-07
00079 :: CONCEPTGATE 7 1 (nil)							 0.00121745
00080 :: UPDATECOMPARTMENTCURRENT
00081 :: INITIALIZECHANNEL -0.075 1.33807e-08
00082 :: CONCEPTGATE 2 1 (0)							 0
00083 :: UPDATECOMPARTMENTCURRENT
00084 :: INITIALIZECHANNEL -0.075 1.67258e-07
00085 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00086 :: CONCEPTGATE 4 -1 (0)							 0
00087 :: UPDATECOMPARTMENTCURRENT
00088 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00089 :: EXPONENTIALDECAY 3.8845e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00090 :: INITIALIZECHANNEL 0.08 8.36292e-08
00091 :: LOADVOLTAGETABLE
00092 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00093 :: CONCEPTGATE 1 1 (nil)							 0.973086
00094 :: UPDATECOMPARTMENTCURRENT
00095 :: REGISTERCHANNELCURRENT
00096 :: FLUXPOOL							 0
00097 :: INITIALIZECHANNEL -0.075 1.33807e-08
00098 :: CONCEPTGATE 2 1 (0)							 0
00099 :: UPDATECOMPARTMENTCURRENT
00100 :: INITIALIZECHANNEL -0.075 8.36292e-08
00101 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00102 :: CONCEPTGATE 4 -1 (0)							 0
00103 :: UPDATECOMPARTMENTCURRENT
00104 :: COMPARTMENT							 -1.00355e-10 0 498232 1.1675
00105 :: EXPONENTIALDECAY 1.7265e+09 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00106 :: INITIALIZECHANNEL 0.055 2.50888e-07
00107 :: LOADVOLTAGETABLE
00108 :: CONCEPTGATE 5 2 (nil)							 0.014457
00109 :: CONCEPTGATE 6 1 (nil)							 0.995941
00110 :: UPDATECOMPARTMENTCURRENT
00111 :: INITIALIZECHANNEL 0.08 1.33807e-07
00112 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00113 :: CONCEPTGATE 1 1 (nil)							 0.973086
00114 :: UPDATECOMPARTMENTCURRENT
00115 :: REGISTERCHANNELCURRENT
00116 :: FLUXPOOL							 0
00117 :: INITIALIZECHANNEL -0.075 8.36292e-08
00118 :: CONCEPTGATE 7 1 (nil)							 0.00121745
00119 :: UPDATECOMPARTMENTCURRENT
00120 :: INITIALIZECHANNEL -0.075 1.33807e-08
00121 :: CONCEPTGATE 2 1 (0)							 0
00122 :: UPDATECOMPARTMENTCURRENT
00123 :: INITIALIZECHANNEL -0.075 3.34517e-07
00124 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00125 :: CONCEPTGATE 4 -1 (0)							 0
00126 :: UPDATECOMPARTMENTCURRENT
00127 :: COMPARTMENT							 -1.99334e-10 2e-10 250836 1.15559
00128 :: EXPONENTIALDECAY 8.701e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00129 :: INITIALIZECHANNEL 0.055 9.9667e-07
00130 :: LOADVOLTAGETABLE
00131 :: CONCEPTGATE 5 2 (nil)							 0.014457
00132 :: CONCEPTGATE 6 1 (nil)							 0.995941
00133 :: UPDATECOMPARTMENTCURRENT
00134 :: INITIALIZECHANNEL 0.08 1.32889e-07
00135 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00136 :: CONCEPTGATE 1 1 (nil)							 0.973086
00137 :: UPDATECOMPARTMENTCURRENT
00138 :: REGISTERCHANNELCURRENT
00139 :: FLUXPOOL							 0
00140 :: INITIALIZECHANNEL -0.075 4.98335e-07
00141 :: CONCEPTGATE 7 1 (nil)							 0.00121745
00142 :: UPDATECOMPARTMENTCURRENT
00143 :: INITIALIZECHANNEL -0.075 2.65779e-08
00144 :: CONCEPTGATE 2 1 (0)							 0
00145 :: UPDATECOMPARTMENTCURRENT
00146 :: INITIALIZECHANNEL -0.075 3.32223e-07
00147 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00148 :: CONCEPTGATE 4 -1 (0)							 0
00149 :: UPDATECOMPARTMENTCURRENT
00150 :: INITIALIZECHANNEL -0.075 1.66112e-07
00151 :: CONCEPTGATE 8 1 (nil)							 0.119301
00152 :: CONCEPTGATE 9 1 (nil)							 0.117152
00153 :: UPDATECOMPARTMENTCURRENT
00154 :: COMPARTMENT							 -1.30741e-10 0 382437 1.25644
00155 :: EXPONENTIALDECAY 1.3202e+09 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00156 :: INITIALIZECHANNEL 0.055 3.26851e-07
00157 :: LOADVOLTAGETABLE
00158 :: CONCEPTGATE 5 2 (nil)							 0.014457
00159 :: CONCEPTGATE 6 1 (nil)							 0.995941
00160 :: UPDATECOMPARTMENTCURRENT
00161 :: INITIALIZECHANNEL 0.08 1.74321e-07
00162 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00163 :: CONCEPTGATE 1 1 (nil)							 0.973086
00164 :: UPDATECOMPARTMENTCURRENT
00165 :: REGISTERCHANNELCURRENT
00166 :: FLUXPOOL							 0
00167 :: INITIALIZECHANNEL -0.075 1.0895e-07
00168 :: CONCEPTGATE 7 1 (nil)							 0.00121745
00169 :: UPDATECOMPARTMENTCURRENT
00170 :: INITIALIZECHANNEL -0.075 1.74321e-08
00171 :: CONCEPTGATE 2 1 (0)							 0
00172 :: UPDATECOMPARTMENTCURRENT
00173 :: INITIALIZECHANNEL -0.075 4.35802e-07
00174 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00175 :: CONCEPTGATE 4 -1 (0)							 0
00176 :: UPDATECOMPARTMENTCURRENT
00177 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00178 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00179 :: INITIALIZECHANNEL 0.08 1.0895e-07
00180 :: LOADVOLTAGETABLE
00181 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00182 :: CONCEPTGATE 1 1 (nil)							 0.973086
00183 :: UPDATECOMPARTMENTCURRENT
00184 :: REGISTERCHANNELCURRENT
00185 :: FLUXPOOL							 0
00186 :: INITIALIZECHANNEL -0.075 1.74321e-08
00187 :: CONCEPTGATE 2 1 (0)							 0
00188 :: UPDATECOMPARTMENTCURRENT
00189 :: INITIALIZECHANNEL -0.075 1.0895e-07
00190 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00191 :: CONCEPTGATE 4 -1 (0)							 0
00192 :: UPDATECOMPARTMENTCURRENT
00193 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00194 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00195 :: INITIALIZECHANNEL 0.055 4.35802e-07
00196 :: LOADVOLTAGETABLE
00197 :: CONCEPTGATE 5 2 (nil)							 0.014457
00198 :: CONCEPTGATE 6 1 (nil)							 0.995941
00199 :: UPDATECOMPARTMENTCURRENT
00200 :: INITIALIZECHANNEL 0.08 3.70431e-07
00201 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00202 :: CONCEPTGATE 1 1 (nil)							 0.973086
00203 :: UPDATECOMPARTMENTCURRENT
00204 :: REGISTERCHANNELCURRENT
00205 :: FLUXPOOL							 0
00206 :: INITIALIZECHANNEL -0.075 4.35802e-07
00207 :: CONCEPTGATE 7 1 (nil)							 0.00121745
00208 :: UPDATECOMPARTMENTCURRENT
00209 :: INITIALIZECHANNEL -0.075 1.74321e-08
00210 :: CONCEPTGATE 2 1 (0)							 0
00211 :: UPDATECOMPARTMENTCURRENT
00212 :: INITIALIZECHANNEL -0.075 3.26851e-07
00213 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00214 :: CONCEPTGATE 4 -1 (0)							 0
00215 :: UPDATECOMPARTMENTCURRENT
00216 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00217 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00218 :: INITIALIZECHANNEL 0.08 3.70431e-07
00219 :: LOADVOLTAGETABLE
00220 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00221 :: CONCEPTGATE 1 1 (nil)							 0.973086
00222 :: UPDATECOMPARTMENTCURRENT
00223 :: REGISTERCHANNELCURRENT
00224 :: FLUXPOOL							 0
00225 :: INITIALIZECHANNEL -0.075 1.74321e-08
00226 :: CONCEPTGATE 2 1 (0)							 0
00227 :: UPDATECOMPARTMENTCURRENT
00228 :: INITIALIZECHANNEL -0.075 3.26851e-07
00229 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00230 :: CONCEPTGATE 4 -1 (0)							 0
00231 :: UPDATECOMPARTMENTCURRENT
00232 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00233 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00234 :: INITIALIZECHANNEL 0.08 3.70431e-07
00235 :: LOADVOLTAGETABLE
00236 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00237 :: CONCEPTGATE 1 1 (nil)							 0.973086
00238 :: UPDATECOMPARTMENTCURRENT
00239 :: REGISTERCHANNELCURRENT
00240 :: FLUXPOOL							 0
00241 :: INITIALIZECHANNEL -0.075 1.74321e-08
00242 :: CONCEPTGATE 2 1 (0)							 0
00243 :: UPDATECOMPARTMENTCURRENT
00244 :: INITIALIZECHANNEL -0.075 3.26851e-07
00245 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00246 :: CONCEPTGATE 4 -1 (0)							 0
00247 :: UPDATECOMPARTMENTCURRENT
00248 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00249 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00250 :: INITIALIZECHANNEL 0.08 2.17901e-07
00251 :: LOADVOLTAGETABLE
00252 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00253 :: CONCEPTGATE 1 1 (nil)							 0.973086
00254 :: UPDATECOMPARTMENTCURRENT
00255 :: REGISTERCHANNELCURRENT
00256 :: FLUXPOOL							 0
00257 :: INITIALIZECHANNEL -0.075 1.74321e-08
00258 :: CONCEPTGATE 2 1 (0)							 0
00259 :: UPDATECOMPARTMENTCURRENT
00260 :: INITIALIZECHANNEL -0.075 3.26851e-07
00261 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00262 :: CONCEPTGATE 4 -1 (0)							 0
00263 :: UPDATECOMPARTMENTCURRENT
00264 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00265 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00266 :: INITIALIZECHANNEL 0.08 2.17901e-07
00267 :: LOADVOLTAGETABLE
00268 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00269 :: CONCEPTGATE 1 1 (nil)							 0.973086
00270 :: UPDATECOMPARTMENTCURRENT
00271 :: REGISTERCHANNELCURRENT
00272 :: FLUXPOOL							 0
00273 :: INITIALIZECHANNEL -0.075 1.74321e-08
00274 :: CONCEPTGATE 2 1 (0)							 0
00275 :: UPDATECOMPARTMENTCURRENT
00276 :: INITIALIZECHANNEL -0.075 3.26851e-07
00277 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00278 :: CONCEPTGATE 4 -1 (0)							 0
00279 :: UPDATECOMPARTMENTCURRENT
00280 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00281 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00282 :: INITIALIZECHANNEL 0.08 1.0895e-07
00283 :: LOADVOLTAGETABLE
00284 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00285 :: CONCEPTGATE 1 1 (nil)							 0.973086
00286 :: UPDATECOMPARTMENTCURRENT
00287 :: REGISTERCHANNELCURRENT
00288 :: FLUXPOOL							 0
00289 :: INITIALIZECHANNEL -0.075 1.74321e-08
00290 :: CONCEPTGATE 2 1 (0)							 0
00291 :: UPDATECOMPARTMENTCURRENT
00292 :: INITIALIZECHANNEL -0.075 1.0895e-07
00293 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00294 :: CONCEPTGATE 4 -1 (0)							 0
00295 :: UPDATECOMPARTMENTCURRENT
00296 :: COMPARTMENT							 -1.30741e-10 0 382437 1.16808
00297 :: EXPONENTIALDECAY 2.9705e+08 0 1.00188
			 (0) (nil) (nil) (nil)							 0
00298 :: INITIALIZECHANNEL 0.08 1.0895e-07
00299 :: LOADVOLTAGETABLE
00300 :: CONCEPTGATE 0 2 (nil)							 0.0141937
00301 :: CONCEPTGATE 1 1 (nil)							 0.973086
00302 :: UPDATECOMPARTMENTCURRENT
00303 :: REGISTERCHANNELCURRENT
00304 :: FLUXPOOL							 0
00305 :: INITIALIZECHANNEL -0.075 1.74321e-08
00306 :: CONCEPTGATE 2 1 (0)							 0
00307 :: UPDATECOMPARTMENTCURRENT
00308 :: INITIALIZECHANNEL -0.075 1.0895e-07
00309 :: CONCEPTGATE 3 1 (nil)							 0.0106418
00310 :: CONCEPTGATE 4 -1 (0)							 0
00311 :: UPDATECOMPARTMENTCURRENT
00312 :: COMPARTMENT							 -1.30741e-10 0 382437 1.08446
00313 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.08417)
VM Diagonals (pdDiagonals[1]) : (1.1675)
VM Diagonals (pdDiagonals[2]) : (1.1675)
VM Diagonals (pdDiagonals[3]) : (1.1675)
VM Diagonals (pdDiagonals[4]) : (1.1675)
VM Diagonals (pdDiagonals[5]) : (1.1675)
VM Diagonals (pdDiagonals[6]) : (1.1675)
VM Diagonals (pdDiagonals[7]) : (1.1675)
VM Diagonals (pdDiagonals[8]) : (1.15559)
VM Diagonals (pdDiagonals[9]) : (1.25644)
VM Diagonals (pdDiagonals[10]) : (1.16808)
VM Diagonals (pdDiagonals[11]) : (1.16808)
VM Diagonals (pdDiagonals[12]) : (1.16808)
VM Diagonals (pdDiagonals[13]) : (1.16808)
VM Diagonals (pdDiagonals[14]) : (1.16808)
VM Diagonals (pdDiagonals[15]) : (1.16808)
VM Diagonals (pdDiagonals[16]) : (1.16808)
VM Diagonals (pdDiagonals[17]) : (1.16808)
VM Diagonals (pdDiagonals[18]) : (1.08446)
VM Axial Resistances (pdAxres[0]) : (-0.0833335)
VM Axial Resistances (pdAxres[1]) : (-0.0833335)
VM Axial Resistances (pdAxres[2]) : (-0.0833335)
VM Axial Resistances (pdAxres[3]) : (-0.0833335)
VM Axial Resistances (pdAxres[4]) : (-0.0833335)
VM Axial Resistances (pdAxres[5]) : (-0.0833335)
VM Axial Resistances (pdAxres[6]) : (-0.0833335)
VM Axial Resistances (pdAxres[7]) : (-0.0833335)
VM Axial Resistances (pdAxres[8]) : (-0.0833335)
VM Axial Resistances (pdAxres[9]) : (-0.0833335)
VM Axial Resistances (pdAxres[10]) : (-0.0833335)
VM Axial Resistances (pdAxres[11]) : (-0.0833335)
VM Axial Resistances (pdAxres[12]) : (-0.0833335)
VM Axial Resistances (pdAxres[13]) : (-0.0833335)
VM Axial Resistances (pdAxres[14]) : (-0.0419543)
VM Axial Resistances (pdAxres[15]) : (-0.0833335)
VM Axial Resistances (pdAxres[16]) : (-0.171981)
VM Axial Resistances (pdAxres[17]) : (-0.1128)
VM Axial Resistances (pdAxres[18]) : (-0.0836226)
VM Axial Resistances (pdAxres[19]) : (-0.0836226)
VM Axial Resistances (pdAxres[20]) : (-0.0836226)
VM Axial Resistances (pdAxres[21]) : (-0.0836226)
VM Axial Resistances (pdAxres[22]) : (-0.0836226)
VM Axial Resistances (pdAxres[23]) : (-0.0836226)
VM Axial Resistances (pdAxres[24]) : (-0.0836226)
VM Axial Resistances (pdAxres[25]) : (-0.0836226)
VM Axial Resistances (pdAxres[26]) : (-0.0836226)
VM Axial Resistances (pdAxres[27]) : (-0.0836226)
VM Axial Resistances (pdAxres[28]) : (-0.0836226)
VM Axial Resistances (pdAxres[29]) : (-0.0836226)
VM Axial Resistances (pdAxres[30]) : (-0.0836226)
VM Axial Resistances (pdAxres[31]) : (-0.0836226)
VM Axial Resistances (pdAxres[32]) : (-0.0836226)
VM Axial Resistances (pdAxres[33]) : (-0.0836226)
VM Axial Resistances (pdAxres[34]) : (-0.0836226)
VM Axial Resistances (pdAxres[35]) : (-0.0836226)
VM Axial Resistances (pdAxres[36]) : (-0.0836226)
VM Axial Resistances (pdAxres[37]) : (-0.0836226)
VM Axial Resistances (pdAxres[38]) : (-0.0836226)
VM Axial Resistances (pdAxres[39]) : (-0.0836226)
VM Axial Resistances (pdAxres[40]) : (-0.0836226)
VM Axial Resistances (pdAxres[41]) : (-0.0836226)
VM Axial Resistances (pdAxres[42]) : (-0.0836226)
VM Axial Resistances (pdAxres[43]) : (-0.0836226)
VM Axial Resistances (pdAxres[44]) : (-0.0836226)
VM Axial Resistances (pdAxres[45]) : (-0.1128)
VM Axial Resistances (pdAxres[46]) : (-0.0833335)
VM Axial Resistances (pdAxres[47]) : (-0.0833335)
VM Axial Resistances (pdAxres[48]) : (-0.0833335)
VM Axial Resistances (pdAxres[49]) : (-0.0833335)
VM Axial Resistances (pdAxres[50]) : (-0.0833335)
VM Axial Resistances (pdAxres[51]) : (-0.0833335)
VM Axial Resistances (pdAxres[52]) : (-0.0833335)
VM Axial Resistances (pdAxres[53]) : (-0.0833335)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Axial Resistances (pdResults[2]) : (0)
VM Axial Resistances (pdResults[3]) : (0)
VM Axial Resistances (pdResults[4]) : (0)
VM Axial Resistances (pdResults[5]) : (0)
VM Axial Resistances (pdResults[6]) : (0)
VM Axial Resistances (pdResults[7]) : (0)
VM Axial Resistances (pdResults[8]) : (0)
VM Axial Resistances (pdResults[9]) : (0)
VM Axial Resistances (pdResults[10]) : (0)
VM Axial Resistances (pdResults[11]) : (0)
VM Axial Resistances (pdResults[12]) : (0)
VM Axial Resistances (pdResults[13]) : (0)
VM Axial Resistances (pdResults[14]) : (0)
VM Axial Resistances (pdResults[15]) : (0)
VM Axial Resistances (pdResults[16]) : (0)
VM Axial Resistances (pdResults[17]) : (0)
VM Axial Resistances (pdResults[18]) : (0)
VM Axial Resistances (pdResults[19]) : (0)
VM Axial Resistances (pdResults[20]) : (0)
VM Axial Resistances (pdResults[21]) : (0)
VM Axial Resistances (pdResults[22]) : (0)
VM Axial Resistances (pdResults[23]) : (0)
VM Axial Resistances (pdResults[24]) : (0)
VM Axial Resistances (pdResults[25]) : (0)
VM Axial Resistances (pdResults[26]) : (0)
VM Axial Resistances (pdResults[27]) : (0)
VM Axial Resistances (pdResults[28]) : (0)
VM Axial Resistances (pdResults[29]) : (0)
VM Axial Resistances (pdResults[30]) : (0)
VM Axial Resistances (pdResults[31]) : (0)
VM Axial Resistances (pdResults[32]) : (0)
VM Axial Resistances (pdResults[33]) : (0)
VM Axial Resistances (pdResults[34]) : (0)
VM Axial Resistances (pdResults[35]) : (0)
VM Axial Resistances (pdResults[36]) : (0)
VM Axial Resistances (pdResults[37]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.06)
VM Membrane Potentials (pdVms[1]) : (-0.06)
VM Membrane Potentials (pdVms[2]) : (-0.06)
VM Membrane Potentials (pdVms[3]) : (-0.06)
VM Membrane Potentials (pdVms[4]) : (-0.06)
VM Membrane Potentials (pdVms[5]) : (-0.06)
VM Membrane Potentials (pdVms[6]) : (-0.06)
VM Membrane Potentials (pdVms[7]) : (-0.06)
VM Membrane Potentials (pdVms[8]) : (-0.06)
VM Membrane Potentials (pdVms[9]) : (-0.06)
VM Membrane Potentials (pdVms[10]) : (-0.06)
VM Membrane Potentials (pdVms[11]) : (-0.06)
VM Membrane Potentials (pdVms[12]) : (-0.06)
VM Membrane Potentials (pdVms[13]) : (-0.06)
VM Membrane Potentials (pdVms[14]) : (-0.06)
VM Membrane Potentials (pdVms[15]) : (-0.06)
VM Membrane Potentials (pdVms[16]) : (-0.06)
VM Membrane Potentials (pdVms[17]) : (-0.06)
VM Membrane Potentials (pdVms[18]) : (-0.06)
',
						   timeout => 10,
						  },
						  {
						   description => 'Does the simulation produce the correct output ?',
						   numerical_compare => 'small arithmetic rounding differences on the automated tester machine',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym.ssp",
# 							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-1-5e-10nA.txt",
							   },
						   wait => 1,
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "running the converted model with SSP to see if the conversion was done correctly",
				preparation => {
						description => "Create the output/ directory",
						preparer =>
						sub
						{
						    `mkdir output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the output/ directory",
					       reparer =>
					       sub
					       {
# 						   `rm "$::config->{core_directory}/output/cell.out"`;
						   `rmdir output`;
					       },
					      },
			       },
			      ],
       description => "the traub91 model",
       name => 'traub91.t',
      };


return $test;


