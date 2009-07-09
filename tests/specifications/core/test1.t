#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/basic-g/test1.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Can we load a simple file into nsgenesis?",
						   read => 'changing clock [0] from 1 to 1e-05

ACTIVE CLOCKS
-------------
[0] : 1e-05
[1] : 0.0001
',
						   timeout => 2,
						   write => undef,
						  },
						 ],
				description => "simple script",
			       },
			       {
				arguments => [
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Can we load a simple file into nsgenesis?",
						   read => 'changing clock [0] from 1 to 1e-05',
						   timeout => 2,
						   write => 'setclock 0 1e-5
',
						  },
						 ],
				description => "simple script",
			       },
			      ],
       description => "simple startup, clock setting",
       name => 'core/test1.t',
      };


return $test;


