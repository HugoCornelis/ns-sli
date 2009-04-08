#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/basic-g/ifelse.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Perform a simple genesis script with control structures.",
						   read => 'hello 1
hello 2
goodbye
last else statement
',
						   write => undef,
						  },
						 ],
				description => "simple script",
			       },
			      ],
       description => "simple if else statements",
       name => 'ifelse.t',
      };


return $test;


