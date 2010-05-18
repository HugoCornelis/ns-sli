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
						   description => "What does this look like in NDF?",
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
						   description => "What does this look like in NDF, does it include the inject field?",
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
						   description => "Can we create an output element?",
						   write => "create asc_file /out",
						  },
						  {
						   description => "Can we initialize the output element?",
						   write => 'setfield /out    filename "/tmp/conversion1.txt" flush 1  leave_open 1 append 1',
						  },
						  {
						   description => "Can we connect the output element with the model?",
						   write => "addmsg       /n/c     /out       SAVE Vm",
						  },
						  {
						   description => "Can we reset the simulation?",
						   write => "reset",
						  },
						  {
						   description => "Synchronize the simulator with the test specification",
						   read => "ready to go",
						   write => 'echo "ready to go"',
						  },
						  {
						   description => "Can we run the simulation?",
						   read => "completed",
						   write => "step 0.01 -time",
						  },
						  {
						   description => "Can we quit the simulator?",
						   wait => 1,
						   write => "quit",
						  },
						  {
						   description => "Can we find the output?",
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
			      ],
       description => "G-2 to G-3 model conversion",
       name => 'conversions.t',
      };


return $test;


