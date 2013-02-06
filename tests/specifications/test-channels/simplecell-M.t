#!/usr/bin/perl -w
#

use strict;


local $/;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-channels/simplecell-M/simplecell-M-g3.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500000 ; step = 25000',
						  },
						  {
						   description => "Quit the ns-sli and wait for output buffers to be written to disk.",
						   read => 'genesis #0 >',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the generated output file correct ?",
						   numerical_compare => 'small differences on the automated tester machine',
						   read => {
							    application_output_file => "output/simplecell-M_Vm.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell-M_Vm.out",
							   },
						  },
						 ],
				description => "addition of a muscarinic current to the 'simplecell' model -- benchmark base",
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
						   `rm "$::config->{core_directory}/output/simplecell-M_Vm.out"`;
						   `rmdir output`;
					       },
					      },
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-channels/simplecell-M/simplecell-M_no_tweak-g3.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500000 ; step = 25000',
						  },
						  {
						   description => "Quit the ns-sli and wait for output buffers to be written to disk.",
						   read => 'genesis #0 >',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the generated output file correct ?",
						   read => {
							    application_output_file => "output/simplecell-M_no-tweak_Vm.out",
							    expected_output_file => "$::config->{core_directory}/tests/scripts/test-channels/simplecell-M/simplecell-M_no_tweak-sli_run_Vm.out",
							   },
						  },
						 ],
				description => "addition of a muscarinic current to the 'simplecell' model -- does not use the tweaktau command",
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
						   `rm "$::config->{core_directory}/output/simplecell-M_no-tweak_Vm.out"`;
						   `rmdir output`;
					       },
					      },
			       },


			      ],
       description => "Addition of a muscarinic current to the 'simplecell' model, implementation of the solution to an exercise in the GENESIS Modeling Tutorial section \"Building a cell the easy way\"",
       overview => `cat "$::config->{core_directory}/tests/scripts/test-channels/simplecell-M/README.rst"`,
       name => 'simplecells.t',
      };


return $test;


