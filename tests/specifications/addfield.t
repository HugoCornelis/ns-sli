#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/basic-g/addfield.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Add a field to an object in genesis.",
						   read => '[ /n ]
new_field            = value
',
						   write => undef,
						  },
						 ],
				description => "Tests genesis control structures",
			       },
			      ],
       name => 'addfield.t',
      };


return $test;


