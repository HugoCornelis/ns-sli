#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/traub91_asym_simple.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.150000 ; step = 3000',
						  },
						  {
						   description => 'Quit the simulator.',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the application output file correct ?",
						   read => {
							    application_output_file => "/tmp/traub91_asym",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple.txt",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "a very small subset of the traub91 model",
			       },
			      ],
       description => "the traub91 model",
       name => 'traub91.t',
      };


return $test;


