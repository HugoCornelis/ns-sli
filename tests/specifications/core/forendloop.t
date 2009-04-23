#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/basic-g/forendloop.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Perform a simple genesis forend loop.",
						   read => '1
2
3
4
5
6
7
8
9
10
',
						   timeout => 2,
						   write => undef,
						  },
						 ],
				description => "simple script",
			       },
			      ],
       description => "simple startup, clock setting",
       name => 'core/forendloop.t',
      };


return $test;


