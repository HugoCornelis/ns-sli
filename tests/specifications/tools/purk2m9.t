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
				description => "readcell and a passive version of the purkinje cell model.",
			       },





			      ],
       description => "readcell and the purkinje cell model",
       name => 'tools/purk2m9.t',
      };


return $test;


