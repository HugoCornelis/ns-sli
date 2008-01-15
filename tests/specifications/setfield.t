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
						   description => "Sets fields to an object in genesis.",
						   read => '[ /n ]
x                    = 444
y                    = 0
z                    = 0
',
						   write => undef,
						  },
						 ],
				description => "Tests genesis control structures",
			       },
			      ],
       name => 'setfield.t',
      };


return $test;


