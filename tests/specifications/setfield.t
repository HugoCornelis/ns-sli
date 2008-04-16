#!/usr/bin/perl -w
#

use strict;


my $previous_library;


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
                                                   description => "Sets fields of an element in genesis.",
                                                   read => '[ /n ]
x                    = 444
y                    = 0
z                    = 0
',
                                                   write => undef,
                                                  },

						

						 ],
				description => "set fields of an element",
				preparation => {
						description => "Setting the environment entry to point to a model library",
						preparer =>
						sub
						{
						  $previous_library = $ENV{NEUROSPACES_MODELS};

						  $ENV{NEUROSPACES_MODELS} = $::config->{core_directory} . '/src';
						},
					       },
				reparation => {
					       description => "Removing the environment entry to point to a model library",
					       reparer =>
					       sub
					       {
						 $ENV{NEUROSPACES_MODELS} = $previous_library;

						 '';
					       },
					      },
			       },
			      ],
       description => "setfield testing",
       name => 'setfield.t'
      };


return $test;


