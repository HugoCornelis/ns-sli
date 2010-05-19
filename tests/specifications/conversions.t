#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Can we set the main simulation clock?",
						   write => 'setclock 0 5e-5',
						  },
						  {
						   description => "Can we create a compartment container?",
						   write => 'create neutral /n',
						  },
						  {
						   description => "Can we create a compartment?",
						   write => 'create compartment /n/c',
						  },
						  {
						   description => "Can we set the fields of the compartment?",
						   write => 'setfield /n/c    Cm 4.57537e-11    Rm 3.58441e+08    Ra 360502    len 1    dia 1    initVm -0.068    Eleak -0.080',
						  },
						  {
						   description => "What model components do we find in the model container, including fixed libraries?",
						   read => '
- /proto
- /output
- /n
- /n/c
',
						   write => 'call model_container NEUROSPACES_COMMAND "expand /**"'
						  },
						  {
						   description => "What model components do we find in the model container, selected output?",
						   read => '
- /n
- /n/c
',
						   write => 'call model_container NEUROSPACES_COMMAND "expand /n/**"'
						  },
						  {
						   description => "What does this look like in NDF (1)?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
  GROUP "proto_3_3"
  END GROUP
  CHILD "proto_3_3" "proto_inserted_3"
  END CHILD
  GROUP "output_4_4"
  END GROUP
  CHILD "output_4_4" "output_inserted_4"
  END CHILD
  SEGMENT "c_6_6"
    PARAMETERS
      PARAMETER ( ELEAK = -0.08 ),
      PARAMETER ( Vm_init = -0.068 ),
      PARAMETER ( DIA = 1 ),
      PARAMETER ( LENGTH = 1 ),
      PARAMETER ( RA = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 360502 ),
          ), ),
      PARAMETER ( RM = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 3.58441e+08 ),
          ), ),
      PARAMETER ( CM = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 4.57537e-11 ),
          ), ),
    END PARAMETERS
  END SEGMENT
  CHILD "c_6_6" "c_inserted_6"
  END CHILD
  GROUP "n_5_5"
    CHILD "c_6_6" "c"
    END CHILD
  END GROUP
  CHILD "n_5_5" "n_inserted_5"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "proto_3_3" "proto"
  END CHILD
  CHILD "output_4_4" "output"
  END CHILD
  CHILD "n_5_5" "n"
  END CHILD
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf STDOUT /n/**"',
						  },
						  {
						   description => "Can we set the inject field?",
						   write => "setfield /n/c inject 1e-9",
						  },
						  {
						   description => "What does this look like in NDF (2), does it include the inject field?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
  GROUP "proto_3_3"
  END GROUP
  CHILD "proto_3_3" "proto_inserted_3"
  END CHILD
  GROUP "output_4_4"
  END GROUP
  CHILD "output_4_4" "output_inserted_4"
  END CHILD
  SEGMENT "c_6_6"
    PARAMETERS
      PARAMETER ( INJECT = 1e-09 ),
      PARAMETER ( ELEAK = -0.08 ),
      PARAMETER ( Vm_init = -0.068 ),
      PARAMETER ( DIA = 1 ),
      PARAMETER ( LENGTH = 1 ),
      PARAMETER ( RA = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 360502 ),
          ), ),
      PARAMETER ( RM = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 3.58441e+08 ),
          ), ),
      PARAMETER ( CM = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 4.57537e-11 ),
          ), ),
    END PARAMETERS
  END SEGMENT
  CHILD "c_6_6" "c_inserted_6"
  END CHILD
  GROUP "n_5_5"
    CHILD "c_6_6" "c"
    END CHILD
  END GROUP
  CHILD "n_5_5" "n_inserted_5"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "proto_3_3" "proto"
  END CHILD
  CHILD "output_4_4" "output"
  END CHILD
  CHILD "n_5_5" "n"
  END CHILD
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf STDOUT /n/**"',
						  },
						  {
						   description => "Can we save the NDF to a file?",
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf /tmp/conversion1.ndf /n/**"',
						  },
						  {
						   description => "Can we create an output element (1)?",
						   write => "create asc_file /out",
						  },
						  {
						   description => "Can we initialize the output element (1)?",
						   write => 'setfield /out    filename "/tmp/conversion1.txt" flush 1',
						  },
						  {
						   description => "Can we connect the output element with the model?",
						   write => "addmsg       /n/c     /out       SAVE Vm",
						  },
						  {
						   description => "Can we reset the simulation (1)?",
						   write => "reset",
						  },
						  {
						   description => "Can we set the options for the DUMP command (1)?",
						   read => 'genesis',
						   write => 'setfield /neurospaces_integrator heccer_dump_selection { HECCER_DUMP_INDEXERS_SUMMARY + HECCER_DUMP_INDEXERS_STRUCTURE + HECCER_DUMP_INTERMEDIARY_COMPARTMENT_SUMMARY + HECCER_DUMP_INTERMEDIARY_MECHANISM_SUMMARY + HECCER_DUMP_INTERMEDIARY_STRUCTURE + HECCER_DUMP_INTERMEDIARY_SUMMARY + HECCER_DUMP_INTERMEDIARY_COMPARTMENTS_PARAMETERS + HECCER_DUMP_VM_COMPARTMENT_MATRIX + HECCER_DUMP_VM_COMPARTMENT_DATA + HECCER_DUMP_VM_COMPARTMENT_OPERATIONS + HECCER_DUMP_VM_CHANNEL_POOL_FLUXES + HECCER_DUMP_VM_MECHANISM_DATA + HECCER_DUMP_VM_MECHANISM_OPERATIONS + HECCER_DUMP_VM_SUMMARY }',
						  },
						  {
						   description => "Can we dump the model from heccer (1)?",
						   read => 'Heccer (pcName) : (/n)
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
Intermediary (iCompartments) : (1)
Compartment (mc.iType) : (1)
Compartment (iParent) : (-1)
Compartment (dCm) : (4.57537e-11)
Compartment (dEm) : (-0.08)
Compartment (dInitVm) : (-0.068)
Compartment (dInject) : (1e-09)
Compartment (dRa) : (360502)
Compartment (dRm) : (3.58441e+08)
MinimumDegree (iEntries) : (1)
MinimumDegree (piChildren[0]) : (0)
MinimumDegree (piForward[0]) : (0)
MinimumDegree (piBackward[0]) : (0)
Tables (iTabulatedGateCount) : (0)
Compartment operations
-----
00000 :: FINISH
00001 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -2.23189e-10 1e-09 546404 1.00152
00001 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.00152)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.068)
',
						   write => 'call /neurospaces_integrator NSINTEGRATOR_DUMP',
						  },
						  {
						   description => "Synchronize the simulator with the test specification",
						   read => "ready to go",
						   write => 'echo "ready to go"',
						  },
						  {
						   description => "Can we run the simulation (1)?",
						   read => "completed",
						   write => "step 0.01 -time",
						  },
						  {
						   description => "Can we quit the simulator?",
						   wait => 1,
						   write => "quit",
						  },
						  {
						   description => "Can we find the output, no sodium channel?",
						   read => {
							    application_output_file => "/tmp/conversion1.txt",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/conversion1.txt",
							   },
						  },
						 ],
				description => "single compartment conversion",
			       },
			       {
				arguments => [
					      '--time',
					      '0.01',
					      '--time-step',
					      '5e-5',
					      '--cell',
					      '/tmp/conversion1.ndf',
					      '--model-name',
					      'n',
					      '--output-fields',
					      "/n/c->Vm",
					      '--optimize',
					      '--verbose',
					      '--dump',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we compile the converted model description from SSP ?',
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
Intermediary (iCompartments) : (1)
Compartment (mc.iType) : (1)
Compartment (iParent) : (-1)
Compartment (dCm) : (4.57537e-11)
Compartment (dEm) : (-0.08)
Compartment (dInitVm) : (-0.068)
Compartment (dInject) : (1e-09)
Compartment (dRa) : (360502)
Compartment (dRm) : (3.58441e+08)
MinimumDegree (iEntries) : (1)
MinimumDegree (piChildren[0]) : (0)
MinimumDegree (piForward[0]) : (0)
MinimumDegree (piBackward[0]) : (0)
Tables (iTabulatedGateCount) : (0)
Compartment operations
-----
00000 :: FINISH
00001 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -2.23189e-10 1e-09 546404 1.00152
00001 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.00152)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.068)
',
						  },
						  {
						   description => 'Does the simulation produce the correct output ?',
						   numerical_compare => "arithmetic rouding differences",
						   read => {
							    application_output_file => "$::config->{core_directory}/output/n.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/conversion1-ssp.txt",
							   },
						   wait => 1,
						  },
						 ],
				description => "converted single compartment run from ssp",
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
			       {
				arguments => [
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Can we set the main simulation clock?",
						   write => 'setclock 0 5e-5',
						  },
						  {
						   description => "Can we create a compartment container?",
						   write => 'create neutral /n',
						  },
						  {
						   description => "Can we create a compartment?",
						   write => 'create compartment /n/c',
						  },
						  {
						   description => "Can we set the fields of the compartment?",
						   write => 'setfield /n/c    Cm 4.57537e-11    Rm 3.58441e+08    Ra 360502    len 1    dia 1    initVm -0.068    Eleak -0.080',
						  },
						  {
						   description => "Can we create a sodium conductance?",
						   write => "create tabchannel /n/c/naf",
						  },
						  {
						   description => "Can we configure the sodium conductance (1)?",
						   write => "setfield /n/c/naf 	Ek 0.045 	Gbar 0.0002092393115 	Ik 0.0 	Gk 0.0 	Xpower 3.0 	Ypower 1.0 	Zpower 0.0
",
						  },
						  {
						   description => "Can we configure the sodium conductance (2)?",
						   write => "setupalpha /n/c/naf 	X 	35.0e3 	0.0 	0.0 	0.005 	-10.0e-3 	7.0e3 	0.0 	0.0 	0.065 	20.0e-3 	-size 3000 	-range -0.1 0.05
",
						  },
						  {
						   description => "Can we configure the sodium conductance (3)?",
						   write => "setupalpha /n/c/naf 	Y 	0.225e3 	0.0 	1.0 	0.08 	10.0e-3 	7.5e3 	0.0 	0.0 	-0.003 	-18.0e-3 	-size 3000 	-range -0.1 0.05
",
						  },
						  {
						   description => "Can we configure the sodium conductance (4)?",
						   write => "addmsg /n/c /n/c/naf VOLTAGE Vm
addmsg /n/c/naf /n/c CHANNEL Gk Ek
",
						  },
						  {
						   description => "What model components do we find in the model container, including fixed libraries?",
						   read => '
- /proto
- /output
- /n
- /n/c
- /n/c/naf
- /n/c/naf/HH_activation
- /n/c/naf/HH_activation/A
- /n/c/naf/HH_activation/B
- /n/c/naf/HH_inactivation
- /n/c/naf/HH_inactivation/A
- /n/c/naf/HH_inactivation/B
',
						   write => 'call model_container NEUROSPACES_COMMAND "expand /**"'
						  },
						  {
						   description => "What model components do we find in the model container, selected output?",
						   read => '
- /n
- /n/c
- /n/c/naf
- /n/c/naf/HH_activation
- /n/c/naf/HH_activation/A
- /n/c/naf/HH_activation/B
- /n/c/naf/HH_inactivation
- /n/c/naf/HH_inactivation/A
- /n/c/naf/HH_inactivation/B
',
						   write => 'call model_container NEUROSPACES_COMMAND "expand /n/**"'
						  },
						  {
						   description => "What does this look like in NDF (1)?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
  GROUP "proto_3_3"
  END GROUP
  CHILD "proto_3_3" "proto_inserted_3"
  END CHILD
  GROUP "output_4_4"
  END GROUP
  CHILD "output_4_4" "output_inserted_4"
  END CHILD
  GATE_KINETIC "A_9_9"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = -0.01 ),
      PARAMETER ( HH_AB_Offset_E = 0.005 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 35000 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_9_9" "A_inserted_9"
  END CHILD
  GATE_KINETIC "B_10_10"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = 0.02 ),
      PARAMETER ( HH_AB_Offset_E = 0.065 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 7000 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_10_10" "B_inserted_10"
  END CHILD
  HH_GATE "HH_activation_8_8"
    PARAMETERS
      PARAMETER ( POWER = 3 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_9_9" "A"
    END CHILD
    CHILD "B_10_10" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_activation_8_8" "HH_activation_inserted_8"
  END CHILD
  GATE_KINETIC "A_12_12"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = 0.01 ),
      PARAMETER ( HH_AB_Offset_E = 0.08 ),
      PARAMETER ( HH_AB_Add = 1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 225 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_12_12" "A_inserted_12"
  END CHILD
  GATE_KINETIC "B_13_13"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = -0.018 ),
      PARAMETER ( HH_AB_Offset_E = -0.003 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 7500 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_13_13" "B_inserted_13"
  END CHILD
  HH_GATE "HH_inactivation_11_11"
    PARAMETERS
      PARAMETER ( POWER = 1 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_12_12" "A"
    END CHILD
    CHILD "B_13_13" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_inactivation_11_11" "HH_inactivation_inserted_11"
  END CHILD
  CHANNEL "naf_7_7"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 0.000209239 ),
          ), ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "HH_activation_8_8" "HH_activation"
    END CHILD
    CHILD "HH_inactivation_11_11" "HH_inactivation"
    END CHILD
  END CHANNEL
  CHILD "naf_7_7" "naf_inserted_7"
  END CHILD
  SEGMENT "c_6_6"
    BINDINGS
      INPUT naf->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( ELEAK = -0.08 ),
      PARAMETER ( Vm_init = -0.068 ),
      PARAMETER ( DIA = 1 ),
      PARAMETER ( LENGTH = 1 ),
      PARAMETER ( RA = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 360502 ),
          ), ),
      PARAMETER ( RM = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 3.58441e+08 ),
          ), ),
      PARAMETER ( CM = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 4.57537e-11 ),
          ), ),
    END PARAMETERS
    CHILD "naf_7_7" "naf"
    END CHILD
  END SEGMENT
  CHILD "c_6_6" "c_inserted_6"
  END CHILD
  GROUP "n_5_5"
    CHILD "c_6_6" "c"
    END CHILD
  END GROUP
  CHILD "n_5_5" "n_inserted_5"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "proto_3_3" "proto"
  END CHILD
  CHILD "output_4_4" "output"
  END CHILD
  CHILD "n_5_5" "n"
  END CHILD
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf STDOUT /n/**"',
						  },
						  {
						   description => "Can we set the inject field?",
						   write => "setfield /n/c inject 1e-9",
						  },
						  {
						   description => "What does this look like in NDF (2), does it include the inject field?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
  GROUP "proto_3_3"
  END GROUP
  CHILD "proto_3_3" "proto_inserted_3"
  END CHILD
  GROUP "output_4_4"
  END GROUP
  CHILD "output_4_4" "output_inserted_4"
  END CHILD
  GATE_KINETIC "A_9_9"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = -0.01 ),
      PARAMETER ( HH_AB_Offset_E = 0.005 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 35000 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_9_9" "A_inserted_9"
  END CHILD
  GATE_KINETIC "B_10_10"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = 0.02 ),
      PARAMETER ( HH_AB_Offset_E = 0.065 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 7000 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_10_10" "B_inserted_10"
  END CHILD
  HH_GATE "HH_activation_8_8"
    PARAMETERS
      PARAMETER ( POWER = 3 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_9_9" "A"
    END CHILD
    CHILD "B_10_10" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_activation_8_8" "HH_activation_inserted_8"
  END CHILD
  GATE_KINETIC "A_12_12"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = 0.01 ),
      PARAMETER ( HH_AB_Offset_E = 0.08 ),
      PARAMETER ( HH_AB_Add = 1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 225 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_12_12" "A_inserted_12"
  END CHILD
  GATE_KINETIC "B_13_13"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = -0.018 ),
      PARAMETER ( HH_AB_Offset_E = -0.003 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 7500 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_13_13" "B_inserted_13"
  END CHILD
  HH_GATE "HH_inactivation_11_11"
    PARAMETERS
      PARAMETER ( POWER = 1 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_12_12" "A"
    END CHILD
    CHILD "B_13_13" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_inactivation_11_11" "HH_inactivation_inserted_11"
  END CHILD
  CHANNEL "naf_7_7"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    BINDINGS
      INPUT ..->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 0.000209239 ),
          ), ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "HH_activation_8_8" "HH_activation"
    END CHILD
    CHILD "HH_inactivation_11_11" "HH_inactivation"
    END CHILD
  END CHANNEL
  CHILD "naf_7_7" "naf_inserted_7"
  END CHILD
  SEGMENT "c_6_6"
    BINDINGS
      INPUT naf->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( INJECT = 1e-09 ),
      PARAMETER ( ELEAK = -0.08 ),
      PARAMETER ( Vm_init = -0.068 ),
      PARAMETER ( DIA = 1 ),
      PARAMETER ( LENGTH = 1 ),
      PARAMETER ( RA = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 360502 ),
          ), ),
      PARAMETER ( RM = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 3.58441e+08 ),
          ), ),
      PARAMETER ( CM = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 4.57537e-11 ),
          ), ),
    END PARAMETERS
    CHILD "naf_7_7" "naf"
    END CHILD
  END SEGMENT
  CHILD "c_6_6" "c_inserted_6"
  END CHILD
  GROUP "n_5_5"
    CHILD "c_6_6" "c"
    END CHILD
  END GROUP
  CHILD "n_5_5" "n_inserted_5"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "proto_3_3" "proto"
  END CHILD
  CHILD "output_4_4" "output"
  END CHILD
  CHILD "n_5_5" "n"
  END CHILD
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf STDOUT /n/**"',
						  },
						  {
						   description => "Can we save the NDF to a file?",
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf /tmp/conversion2.ndf /n/**"',
						  },
						  {
						   description => "Can we create an output element (1)?",
						   write => "create asc_file /out",
						  },
						  {
						   description => "Can we initialize the output element (1)?",
						   write => 'setfield /out    filename "/tmp/conversion2.txt" flush 1',
						  },
						  {
						   description => "Can we connect the output element with the model?",
						   write => "addmsg       /n/c     /out       SAVE Vm",
						  },
						  {
						   description => "Can we reset the simulation (1)?",
						   write => "reset",
						  },
						  {
						   description => "Can we set the options for the DUMP command (1)?",
						   read => 'genesis',
						   write => 'setfield /neurospaces_integrator heccer_dump_selection { HECCER_DUMP_INDEXERS_SUMMARY + HECCER_DUMP_INDEXERS_STRUCTURE + HECCER_DUMP_INTERMEDIARY_COMPARTMENT_SUMMARY + HECCER_DUMP_INTERMEDIARY_MECHANISM_SUMMARY + HECCER_DUMP_INTERMEDIARY_STRUCTURE + HECCER_DUMP_INTERMEDIARY_SUMMARY + HECCER_DUMP_INTERMEDIARY_COMPARTMENTS_PARAMETERS + HECCER_DUMP_VM_COMPARTMENT_MATRIX + HECCER_DUMP_VM_COMPARTMENT_DATA + HECCER_DUMP_VM_COMPARTMENT_OPERATIONS + HECCER_DUMP_VM_CHANNEL_POOL_FLUXES + HECCER_DUMP_VM_MECHANISM_DATA + HECCER_DUMP_VM_MECHANISM_OPERATIONS + HECCER_DUMP_VM_SUMMARY }',
						  },
						  {
						   description => "Can we dump the model from heccer (1)?",
						   read => 'Heccer (pcName) : (/n)
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
Intermediary (iCompartments) : (1)
Compartment (mc.iType) : (1)
Compartment (iParent) : (-1)
Compartment (dCm) : (4.57537e-11)
Compartment (dEm) : (-0.08)
Compartment (dInitVm) : (-0.068)
Compartment (dInject) : (1e-09)
Compartment (dRa) : (360502)
Compartment (dRm) : (3.58441e+08)
MinimumDegree (iEntries) : (1)
MinimumDegree (piChildren[0]) : (0)
MinimumDegree (piForward[0]) : (0)
MinimumDegree (piBackward[0]) : (0)
Tables (iTabulatedGateCount) : (2)
Compartment operations
-----
00000 :: FINISH
00001 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -2.23189e-10 1e-09 546404 1.00152
00001 :: INITIALIZECHANNEL 0.045 0.000209239
00002 :: LOADVOLTAGETABLE
00003 :: CONCEPTGATE 0 3 (nil)							 0.00778252
00004 :: CONCEPTGATE 1 1 (nil)							 0.265266
00005 :: UPDATECOMPARTMENTCURRENT
00006 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.00152)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.068)
',
						   write => 'call /neurospaces_integrator NSINTEGRATOR_DUMP',
						  },
						  {
						   description => "Synchronize the simulator with the test specification",
						   read => "ready to go",
						   write => 'echo "ready to go"',
						  },
						  {
						   description => "Can we run the simulation (1)?",
						   read => "completed",
						   write => "step 0.01 -time",
						  },
						  {
						   description => "Can we quit the simulator?",
						   wait => 1,
						   write => "quit",
						  },
						  {
						   description => "Can we find the output, with sodium channel?",
						   read => {
							    application_output_file => "/tmp/conversion2.txt",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/conversion2.txt",
							   },
						  },
						 ],
				description => "single compartment conversion, with sodium channel",
			       },
			       {
				arguments => [
					      '--time',
					      '0.01',
					      '--time-step',
					      '5e-5',
					      '--cell',
					      '/tmp/conversion2.ndf',
					      '--model-name',
					      'n',
					      '--output-fields',
					      "/n/c->Vm",
					      '--optimize',
					      '--verbose',
					      '--dump',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we compile the converted model description from SSP ?',
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
Intermediary (iCompartments) : (1)
Compartment (mc.iType) : (1)
Compartment (iParent) : (-1)
Compartment (dCm) : (4.57537e-11)
Compartment (dEm) : (-0.08)
Compartment (dInitVm) : (-0.068)
Compartment (dInject) : (1e-09)
Compartment (dRa) : (360502)
Compartment (dRm) : (3.58441e+08)
MinimumDegree (iEntries) : (1)
MinimumDegree (piChildren[0]) : (0)
MinimumDegree (piForward[0]) : (0)
MinimumDegree (piBackward[0]) : (0)
Tables (iTabulatedGateCount) : (2)
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
Compartment operations
-----
00000 :: FINISH
00001 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -2.23189e-10 1e-09 546404 1.00152
00001 :: INITIALIZECHANNEL 0.045 0.000209239
00002 :: LOADVOLTAGETABLE
00003 :: CONCEPTGATE 0 3 (nil)							 0.00778252
00004 :: CONCEPTGATE 1 1 (nil)							 0.265266
00005 :: UPDATECOMPARTMENTCURRENT
00006 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.00152)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.068)
',
						  },
						  {
						   description => 'Does the simulation produce the correct output ?',
# 						   error => "the output is different from what ns-sli generates",
						   numerical_compare => "arithmetic rouding differences",
						   read => {
							    application_output_file => "$::config->{core_directory}/output/n.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/conversion2-ssp.txt",
							   },
						   wait => 1,
						  },
						 ],
				description => "converted single compartment run from ssp",
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
       description => "G-2 to G-3 model conversion",
       name => 'conversions.t',
      };


return $test;


