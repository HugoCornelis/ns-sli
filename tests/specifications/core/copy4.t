#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/genesis-2/copy4.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  


	       

						  {
						   description => "Is parameter CM set correctly?",
						   read => 'value = 4.57537e-11',
						   write => 'printparameter /c CM',
						  },


						  {
						   description => "Is parameter CM set correctly in the copy?",
						   read => 'value = 4.57537e-11',
						   write => 'printparameter /o CM',
						  },


						  {
						   description => "Is parameter RM set correctly?",
						   read => 'value = 3.58441e+08',
						   write => 'printparameter /c RM',
						  },


						  {
						   description => "Is parameter RM set correctly in the copy?",
						   read => 'value = 3.58441e+08',
						   write => 'printparameter /o RM',
						  },






						 ],
				description => "Was a copy made and was its fields set?",


			       },
			      ],
       description => "Can we copy a compartment from a non anchored root to an anchored destination? ",
       name => 'core/copy4.t',
      };


return $test;


