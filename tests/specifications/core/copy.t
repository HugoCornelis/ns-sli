#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/copy.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  


	       

						  {
						   description => "Is parameter CM set correctly?",
						   read => 'value = 4.57537e-11',
						   write => 'printparameter /hardcoded_neutral/c CM',
						  },


						  {
						   description => "Is parameter CM set correctly in the copy?",
						   read => 'value = 4.57537e-11',
						   write => 'printparameter /hardcoded_neutral/o CM',
						  },


						  {
						   description => "Is parameter RM set correctly?",
						   read => 'value = 3.58441e+08',
						   write => 'printparameter /hardcoded_neutral/c RM',
						  },


						  {
						   description => "Is parameter RM set correctly in the copy?",
						   read => 'value = 3.58441e+08',
						   write => 'printparameter /hardcoded_neutral/o RM',
						  },






						 ],
				description => "Was a copy made and was its fields set?",


			       },
			      ],
       description => "create a compartment, set its fields and then copy it ",
       name => 'core/copy.t',
      };


return $test;


