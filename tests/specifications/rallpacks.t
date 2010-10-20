#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/rallpack3-simple.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run the simulation ?",
						   read => 'time = 0.250050 ; step = 5001',
						   timeout => 10,
						  },
						  {
						   description => "Can we quit the simulator ?",
						   wait => 1,
						   write => "quit",
						  },
						  {
						   description => "Can we find the output of the first compartment ?",
						   read => {
							    application_output_file => "/tmp/axon3.out0",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/rallpacks/axon3.out0",
							   },
						  },
						  {
						   description => "Can we find the output of the last compartment ?",
						   read => {
							    application_output_file => "/tmp/axon3.outx",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/rallpacks/axon3.outx",
							   },
						  },
						 ],
				comment => 'rallpack3-simple.g modified Wed Jul 14 16:02:20 MDT 2010 by dbeeman to use a simpler axon setup for GENESIS 3',
				description => "rallpack3, squid axon benchmark",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/rallpack3/axon.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run the simulation ?",
						   read => 'time = 0.250050 ; step = 5001',
						   timeout => 10,
						  },
						  {
						   description => "Can we quit the simulator ?",
						   write => "quit",
						  },
						  {
						   description => "Can we find the output of the first compartment ?",
						   read => {
							    application_output_file => "/tmp/axon.out0",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/rallpacks/axon.out0.g2",
							   },
						  },
						  {
						   description => "Can we find the output of the last compartment ?",
						   read => {
							    application_output_file => "/tmp/axon.outx",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/rallpacks/axon.outx.g2",
							   },
						  },
						 ],
				comment => 'Note that all the pseudo optimization in the original G2 script make performance under G3 worse',
				description => "rallpack3, squid axon benchmark",
				disabled => 'not working yet',
			       },
			      ],
       description => "the rallpacks benchmarks",
       name => 'rallpacks.t',
      };


return $test;


