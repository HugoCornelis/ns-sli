#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/simplecells/simplecell-rand_act-g3.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500000 ; step = 25000',
						  },
						  {
						   description => "Wait for the application to finish.",
						   wait => 1,
						  },
						  {
						   comment => 'relatively large deviations from the G-2 generated output file on line 239, using the G-3 generating output file',
						   description => "Is the generated output file correct ?",
# 						   numerical_compare => 'small differences on the automated tester machine',
						   read => {
							    application_output_file => "output/simplecell_randact_Vm.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell_randact_Vm.out.g3",
							   },
						  },
						 ],
				description => "G-2 frequency field backward compatibility",
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
						   `rm "$::config->{core_directory}/output/simplecell_randact_Vm.out"`;
						   `rmdir output`;
					       },
					      },
			       },
			      ],
       description => "variations of one of the simplest tutorial scripts",
       name => 'simplecells.t',
      };


return $test;


