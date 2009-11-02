#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [


			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/genesis-2/getfield.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [

						  {
						   description => "Can we perform getfield on compartment parameters?",
						   read => 'Echoing each field via getfield
4.57537e-11
3.58441e+08
360502
1
1
-0.068
-0.08',
						   timeout => 5,
						   write => undef,
						  },

						 ],
				description => "Can we perform a getfield on each of the compartments parameters (fields)?",


			       },




			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/springmass1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Can we get the field for the voltage potential from compartment 1 in springmass1.?",
						   read => 'Vm = -0.0791698',
						   timeout => 5,
						   write => 'echo {"Vm = " @ {getfield /hardcoded_neutral/c1 Vm}}',
						  },
						  {
						   description => "Can we read voltage potential from compartment 2 in springmass1.g?",
						   read => 'Vm = -0.0791697',
						   timeout => 5,
						   write => 'echo {"Vm = " @ {getfield /hardcoded_neutral/c2 Vm}}',
						  },
						 ],
				description => "Can we perform a getfield from a heccer solved variable?",


			       },





			      ],
       description => "create a compartment, set its fields and then copy it ",
       name => 'core/getfield.t',
      };


return $test;


