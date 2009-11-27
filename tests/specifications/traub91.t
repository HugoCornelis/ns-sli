#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/new_dim_calc.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script compute correct new diameter and length for apical_18 ?",
						   read => '
apical_18
original len*dia =  693.6
a =  693.6
b =  3.591911016
len =  120  new_len =  119.9999886
dia =  5.78  new_dia =  5.78000055
new_len*new_dia =  693.6
',
						  },
						  {
						   description => "Does the script compute correct new diameter and length for apical_10 ?",
						   read => '
apical_10
original len*dia =  693.6
a =  693.6
b =  2.66920691
len =  120  new_len =  108.6926392
dia =  5.78  new_dia =  6.381296883
new_len*new_dia =  693.6
',
						  },
						  {
						   description => "Does the script compute correct new diameter and length for soma ?",
						   read => '
soma
original len*dia =  1057.5
a =  1057.5
b =  3.221110154
len =  125  new_len =  153.2929163
dia =  8.46  new_dia =  6.898557518
new_len*new_dia =  1057.5
',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts, does not use the G2 generated file.',
				description => "a very small subset of the traub91 model (3)",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/traub91_asym_simple3.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation (3) ?",
						   read => 'time = 0.150000 ; step = 3000',
						  },
						  {
						   description => 'Quit the simulator (3).',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the application output file correct (3) ?",
						   read => {
							    application_output_file => "/tmp/traub91_asym",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple3.txt",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts, does not use the G2 generated file.',
				description => "a very small subset of the traub91 model (3)",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/traub91_asym_simple2.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation (2) ?",
						   read => 'time = 0.150000 ; step = 3000',
						  },
						  {
						   description => 'Quit the simulator (2).',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the application output file correct (2) ?",
						   read => {
							    application_output_file => "/tmp/traub91_asym",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple2.txt",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts, does not use the G2 generated file.',
				description => "a very small subset of the traub91 model (2)",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/traub91_asym_simple.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation (1) ?",
						   read => 'time = 0.150000 ; step = 3000',
						  },
						  {
						   description => 'Quit the simulator (1).',
						   wait => 1,
						   write => 'quit',
						  },
						  {
						   description => "Is the application output file correct (1) ?",
						   read => {
							    application_output_file => "/tmp/traub91_asym",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym_simple.txt",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts.  One error will be generated: ** Error - c_do_add_msg : cannot find element \'/cell/apical_18/Ca_conc/../Ca\'',
				description => "a very small subset of the traub91 model (1)",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-traub91-v0/traub91_asym.g",
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
						   numerical_compare => 'small differences on the tester machine.',
						   read => {
							    application_output_file => "/tmp/traub91_asym",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/traub91_asym.txt",
							   },
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts.',
				description => "the traub91 model, asymmetric compartment version.",
			       },
			      ],
       description => "the traub91 model",
       name => 'traub91.t',
      };


return $test;


