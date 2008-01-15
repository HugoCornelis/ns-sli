#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/basic-g/set_neurospaces_field.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Create a neurospaces object and add a field.",
						   read => '[ /n ]
new_field            = value
',
						   write => undef,
						  },
						 ],
				description => "Test neurospaces object creation",
			       },
			      ],
       name => 'set_neurospaces_field.t',
      };


return $test;


