#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/springmass1.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [

						  {
						   
						   description => 'Does the application report that it writes its output?',
						   read => 'output written',
						    timeout => 20,
						  },

						  {
						   description => "Is a synaptic (springmass) channel integrated correctly?",
						   numerical_compare => 'Enabled because the numbers will never exactly match.',
						   read => {
							  
							    application_output_file => '/tmp/a1',
							    expected_output_file => '/usr/local/heccer/tests/specifications/strings/springmass1-output.txt' },
						   timeout => 20,
						  
						  },



						 ],
				description => "synaptic channel integration.",
			       },
			      ],
       description => "synaptic equation test.",
       name => 'heccer/springmass.t',
      };


return $test;


