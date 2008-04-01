#!/usr/bin/perl -w
#

use strict;


my $previous_library;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
				  "$::config->{core_directory}/tests/scripts/basic-g/set_neurospaces_field.g",					],
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
       description => "",
       name => 'set_neurospaces_field.t'
      };


return $test;




