#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/basic-g/setfield.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Can we set a field on an object in ns-genesis?",
						   read => '[ /n ]
x                    = 444
y                    = 0
z                    = 0
',
						   timeout => 2,
						   write => undef,
						  },
						 ],
				description => "simple set field on a neutral",
			       },
			       {
				arguments => [
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Can we perform multiple set fields in ns-genesis?",
						   read => '[ /n ]
x                    = 1
y                    = 2
z                    = 3',
						   timeout => 2,
						   write => 'create neutral n
setfield n x 1 y 2 z 3
showfield n x y z
',
						  },
						 ],
				description => "multiple setfields",
			       },
			      ],
       description => "simple setfield operations",
       name => 'core/setfield.t',
      };


return $test;


