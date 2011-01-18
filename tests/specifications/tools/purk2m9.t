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
				command => 'src/ns-sli',
				command_tests => [
						  {
						   comment => "Also tests the cell reader *add_spines option.",
						   description => 'Can we run an original GENESIS 2 script that loads a passive version of the purkinje cell (1) ?',
						   disabled => (
								$^O =~ /^darwin/i
								? "this test is disabled on darwin (aka MAC) based systems"
								: ""
							       ),
						   mac_report => 'Test fails on Mac OSX due to an IO lock. However when manually run this test case works fine.',
						   numerical_compare => 'tiny differences expected at the end of the file',
						   read => {
							    application_output_file => "$::config->{core_directory}/results/PurkM9_inject_1e-6_none_Hz_i_none_Hz",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/PurkM9_inject_1e-6_none_Hz_i_none_Hz-double",
							   },
						   wait => 10,
						  },
						 ],
				description => "passive version of the purkinje cell model (1).",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/PurkM9_model/PASSIVE9-current2.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   comment => "Also tests the cell reader *add_spines option.",
						   description => 'Can we run an original GENESIS 2 script that loads a passive version of the purkinje cell (2) ?',
						   disabled => (
								$^O =~ /^darwin/i
								? "this test is disabled on darwin (aka MAC) based systems"
								: ""
							       ),
						   mac_report => 'Test fails on Mac OSX due to an IO lock. However when manually run this test case works fine.',
						   numerical_compare => 'tiny differences expected at the end of the file',
						   read => {
							    application_output_file => "$::config->{core_directory}/results/PurkM9_inject_1e-6_none_Hz_i_none_Hz",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/PurkM9_inject_1e-6_none_Hz_i_none_Hz-double",
							   },
						   wait => 10,
						  },
						 ],
				description => "passive version of the purkinje cell model (2).",
			       },
			      ],
       description => "purkinje cell model",
       name => 'tools/purk2m9.t',
       preparation => {
		       description => "Create the results directory",
		       preparer =>
		       sub
		       {
			   `mkdir results`;
		       },
		      },
       reparation => {
		      description => "Remove the generated output files in the results directory",
		      reparer =>
		      sub
		      {
			  `rm "$::config->{core_directory}/results/PurkM9_inject_1e-6_none_Hz_i_none_Hz"`;
			  `rm "$::config->{core_directory}/results/PurkM9_inject_1e-6_none_Hz_i_none_Hz"`;
			  `rmdir results`;
		      },
		     },
      };


return $test;


