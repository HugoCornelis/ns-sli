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
						   read => 'Final Vm =  -0.0740676',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts",
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
						   read => 'Final Vm =  -0.0740676',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts",
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
						   read => 'Final Vm =  -0.0740676',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts",
			       },
			      ],
       description => "one of the simplest tutorial scripts",
       name => 'simplecell.t',
      };


return $test;


