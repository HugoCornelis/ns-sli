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





			      ],
       description => "create a compartment, set its fields and then copy it ",
       name => 'core/showfield.t',
      };


return $test;


