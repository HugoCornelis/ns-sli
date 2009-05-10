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
					      "$::config->{core_directory}/tests/scripts/PurkM9_model/PASSIVE9-current1.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   comment => "Also tests the cell reader *add_spines option",
						   description => 'Can we run an original GENESIS 2 script that loads a passive version of the purkinje cell (1) ?',
						   read => {
							    application_output_file => "$::config->{core_directory}/results/PurkM9_inject_1e-6_none_Hz_i_none_Hz",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/PurkM9_inject_1e-6_none_Hz_i_none_Hz",
							   },
						   wait => 10,
						  },
						 ],
				description => "passive version of the purkinje cell model.",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/PurkM9_model/PASSIVE9-current2.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   comment => "Also tests the cell reader *add_spines option",
						   description => 'Can we run an original GENESIS 2 script that loads a passive version of the purkinje cell (2) ?',
						   read => {
							    application_output_file => "$::config->{core_directory}/results/PurkM9_inject_1e-6_none_Hz_i_none_Hz",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/PurkM9_inject_1e-6_none_Hz_i_none_Hz",
							   },
						   wait => 10,
						  },
						 ],
				description => "passive version of the purkinje cell model.",
			       },
			      ],
       description => "purkinje cell model",
       name => 'tools/purk2m9.t',
      };


return $test;


