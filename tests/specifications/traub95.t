#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
# 			       {
# 				arguments => [
# 					      "$::config->{core_directory}/tests/scripts/test-traub95cell-v0/traub95cell1-soma.g",
# 					     ],
# 				command => 'src/ns-sli',
# 				command_tests => [
# 						  {
# 						   description => "Does the script run a simulation ?",
# 						   read => 'END:',
# 						   timeout => 15,
# 						  },
# 						  {
# 						   description => "Can we quit the simulator such that output is flushed ?",
# 						   wait => 1,
# 						   write => 'quit',
# 						  },
# 						  {
# 						   comment => 'small deviations from the G-2 generated output file',
# 						   description => "Is the generated output file correct ?",
# 						   read => {
# 							    application_output_file => "output/traub95_Vm.out.soma",
# 							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub95_Vm.out.soma.g3",
# 							   },
# 						  },
# 						 ],
# 				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts, does not use the G2 generated file.',
# 				description => "a very small subset of the traub95 model",
# 				preparation => {
# 						description => "Create the output/ directory",
# 						preparer =>
# 						sub
# 						{
# 						    `mkdir output`;
# 						},
# 					       },
# 				reparation => {
# 					       description => "Remove the generated output files in the output/ directory",
# 					       reparer =>
# 					       sub
# 					       {
#  						   `rm "$::config->{core_directory}/output/traub95_Vm.out.soma"`;
# 						   `rmdir output`;
# 					       },
# 					      },
# 			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub95cell-v0/traub95cell1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'END:',
						   timeout => 15,
						  },
						  {
						   description => "Can we quit the simulator such that output is flushed ?",
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   comment => 'small deviations from the G-2 generated output file',
						   description => "Is the generated output file correct ?",
						   numerical_compare => 'small differences on the automated tester machine',
						   read => {
							    application_output_file => "output/traub95_Vm.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub95_Vm.out.g3",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts, does not use the G2 generated file.',
				description => "the traub95 model",
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
 						   `rm "$::config->{core_directory}/output/traub95_Vm.out"`;
# 						   `rmdir output`;
					       },
					      },
			       },
			      ],
       description => "the traub95 model",
       name => 'traub95.t',
      };


return $test;


