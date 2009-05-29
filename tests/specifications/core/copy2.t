#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/genesis-2/copy2.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  


	       

						  {
						   description => "Is parameter CM set correctly?",
						   read => 'value = 4.57537e-11',
						   write => 'printparameterscaled /n1/c CM',
						  },


						  {
						   description => "Is parameter CM set correctly in the copy?",
						   read => 'value = 4.57537e-11',
						   write => 'printparameterscaled /n2/o CM',
						  },


						  {
						   description => "Is parameter RM set correctly?",
						   read => 'value = 3.58441e+08',
						   write => 'printparameterscaled /n1/c RM',
						  },


						  {
						   description => "Is parameter RM set correctly in the copy?",
						   read => 'value = 3.58441e+08',
						   write => 'printparameterscaled /n2/o RM',
						  },






						 ],
				description => "Was a copy made and was its fields set?",


			       },
			      ],
       description => "Can we copy a compartment from one independent neutral root to another? ",
       name => 'core/copy2.t',
      };


return $test;


