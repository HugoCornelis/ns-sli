#!/usr/bin/perl -w
#

use strict;

# slurp mode

local $/;


my $test
    = {
       command_definitions => [


			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/readcell/purk2m9.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [


						  {
						   
						   description => 'Does the application load a passive model of the purkinje cell?',
						   read => 'output written',
						    timeout => 200,
						  },
						  {
						   description => "?",
						   read => {
							     
							    application_output_file => '/tmp/purk2m9.txt',
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/purk2m9.txt" },
						   timeout => 2,
						   write => undef,
						  },
						  ],
				description => "A test of the readfile function.",
			       },





			      ],
       description => "readcell parameters and coordinates",
       name => 'readcell.t',
      };


return $test;


