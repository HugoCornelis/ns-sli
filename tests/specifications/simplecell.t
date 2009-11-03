#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-simplecell/simplecell-0.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500005 ; step = 100001',
						  },
						  {
						   description => "Is the final somatic membrane potential correct ?",
						   read => 'Final Vm =  -0.07105',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts, version without hsolve, without synchans and spikegens",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-simplecell/simplecell-1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500005 ; step = 100001',
						  },
						  {
						   description => "Is the final somatic membrane potential correct ?",
						   read => 'Final Vm =  -0.07105',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts, version without hsolve, with synchans and spikegens",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-simplecell/simplecell-2.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500005 ; step = 100001',
						  },
						  {
						   description => "Is the final somatic membrane potential correct ?",
						   read => 'Final Vm =  -0.07105',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts, version with hsolve, without synchans and spikegens",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-simplecell/simplecell-3.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500005 ; step = 100001',
						  },
						  {
						   description => "Is the final somatic membrane potential correct ?",
						   read => 'Final Vm =  -0.07105',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts, version with hsolve, with synchans and spikegens",
			       },
			      ],
       description => "one of the simplest tutorial scripts",
       name => 'simplecell.t',
      };


return $test;


