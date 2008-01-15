#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/basic-g/foreachloop.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Perform a simple genesis foreach loop with three elements.",
						   read => 'one
two
three
',
						   write => undef,
						  },
						 ],
				description => "simple script",
			       },
			      ],
       description => "for each loop, three elements",
       name => 'foreachloop.t',
      };


return $test;


