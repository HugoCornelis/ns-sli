#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/basic-g/function_iftest.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Creates a simple genesis function",
						   read => 'zero
negative
positive
',
						   write => undef,
						  },
						 ],
				description => "simple script",
			       },
			      ],
       description => "simple function with ifelse control structures in it",
       name => 'core/function_iftest.t',
      };


return $test;


