#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test1.g",
					     ],
				command => 'src/genesis',
				command_tests => [
						  {
						   description => "Can we load a simple file into ns-genesis?",
						   read => 'ACTIVE CLOCKS',
						   timeout => 2,
						   write => undef,
						  },
						 ],
				description => "simple script",
			       },
			      ],
       description => "simple startup, clock setting",
       name => 'test1.t',
      };


return $test;


