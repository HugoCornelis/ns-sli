#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/library/test1.g",
					     ],
				command => 'src/genesis',
				command_tests => [
						  {
						   description => "Testing the set clock function.",
						   read => 'ACTIVE CLOCKS',
						   timeout => 15,
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


