#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/springmass3.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [

						  {
						   
						   description => 'Does the application report that it writes its output?',
						   read => 'output written',
						    timeout => 200,
						  },

						  {
						   description => "Can we ",
						   read => {
							     
							    application_output_file => '/tmp/a1',
							    expected_output_file => '/usr/local/heccer/tests/specifications/strings/springmass3-output.txt' },
						   timeout => 2,
						   write => undef,
						  },
						 ],
				description => "springmass equation test.",
			       },
			      ],
       description => "springmass equation test.",
       name => 'ascfile1.t',
      };


return $test;


