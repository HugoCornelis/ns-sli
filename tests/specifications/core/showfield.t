#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/showfield1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [

						  {
						   description => "Is parameter CM set correctly?",
						   read => 'value = 4.57537e-11',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/c CM',
						  },

						 ],
				description => "Was a copy made and was its fields set?",


			       },
			      ],
       description => "create a compartment, set its fields and then copy it ",
       name => 'core/showfield.t',
      };


return $test;


