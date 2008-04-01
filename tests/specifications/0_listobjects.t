#!/usr/bin/perl -w
#

use strict;


my $previous_library;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
				  "$::config->{core_directory}/tests/scripts/0_listobjects.g",
					],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description =>  "Add a field to an object in genesis.",
						   read => 'AVAILABLE OBJECTS:
neurospaces         neutral             nsintegrator',
						   write => 'listobjects',
						  },
						

						 ],
				description => "Does the shell list available genesis objects?",
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
       description => "List all available genesis objects.",
       name => '0_listobjects.t'
      };


return $test;

