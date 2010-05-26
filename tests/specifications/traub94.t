#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub94cell-v0/traub94cell1-soma.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation (1)?",
						   read => 'END:',
						   timeout => 25,
						  },
						  {
						   description => "Can we save the model as an NDF file -- library ?",
						   read => 'genesis',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf /tmp/traub94cell1-soma.ndf /cell/**"',
						  },
						  {
						   description => "Can we quit the simulator such that output is flushed ?",
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   comment => 'there are serious deviations from the G-2 generated output file, unclear why, but it maybe related to float and double precision number (in)accuracies.',
						   description => "Is the generated output correct (1)?",
						   numerical_compare => 'small differences on the automated tester machine',
						   read => {
							    application_output_file => "output/traub94_Vm.out.soma",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub94_Vm.out.soma.g3",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts, does not use the G2 generated file.',
				description => "a very small subset of the traub94 model",
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
 						   `rm "$::config->{core_directory}/output/traub94_Vm.out.soma"`;
						   `rmdir output`;
					       },
					      },
			       },
			       {
				arguments => [
					      '--time',
					      '0.5',
					      '--time-step',
					      '0.00002',
					      '--cell',
					      '/tmp/traub94cell1-soma.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					      '--optimize',
# 					      '--verbose',
# 					      '--dump',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we compile the converted model description from SSP, traub94cell1-soma.ndf ?',
						   disabled => "this test was not implemented",
						   read => 'not implemented',
						   timeout => 10,
						  },
						  {
						   description => 'Does the simulation produce the correct output (1)?',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub94_Vm.out.soma.ssp",
# 							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-1-5e-10nA.txt",
							   },
						   wait => 10,
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
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub94cell-v0/traub94cell1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation (2)?",
						   read => 'END:',
						   timeout => 35,
						  },
						  {
						   description => "Can we save the model as an NDF file -- library ?",
						   read => 'genesis',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf /tmp/traub94cell1.ndf /cell/**"',
						  },
						  {
						   description => "Can we quit the simulator such that output is flushed ?",
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   comment => 'small deviations from the G-2 generated output file',
						   description => "Is the generated output correct (2)?",
						   numerical_compare => 'small differences on the automated tester machine',
						   read => {
							    application_output_file => "output/traub94_Vm.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub94_Vm.out.g3",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts, does not use the G2 generated file.',
				description => "the traub94 model",
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
 						   `rm "$::config->{core_directory}/output/traub94_Vm.out"`;
# 						   `rmdir output`;
					       },
					      },
			       },
			       {
				arguments => [
					      '--time',
					      '0.5',
					      '--time-step',
					      '0.00002',
					      '--cell',
					      '/tmp/traub94cell1.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					      '--optimize',
# 					      '--verbose',
# 					      '--dump',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we compile the converted model description from SSP, traub94cell1.ndf ?',
						   disabled => "this test was not implemented",
						   read => 'Done',
						   timeout => 30,
						  },
						  {
						   description => 'Does the simulation produce the correct output (2)?',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub94_Vm.out.ssp",
# 							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-1-5e-10nA.txt",
							   },
						   wait => 20,
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
       description => "the traub94 model",
       name => 'traub94.t',
      };


return $test;


