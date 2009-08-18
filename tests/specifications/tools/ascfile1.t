#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/springmass.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   
						   description => 'Does the application report that it writes its output?',
						   read => 'output written',
						    timeout => 200,
						  },

						  {
						   description => "Can we perform a test using asc_file objects to write application output?",
						   read => {
							     
							    application_output_file => '/tmp/a1',
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/a1.txt" },
						   timeout => 2,
						   write => undef,
						  },
						 ],
				description => "simple test of the asc_file object.",
			       },
			      ],
       description => "asc_file object test.",
       name => 'tools/ascfile1.t',
      };


return $test;


