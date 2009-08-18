#!/usr/bin/perl -w
#

use strict;


my $previous_library;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
				  "$::config->{core_directory}/tests/scripts/basic-g/foreachloop.g",
					],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description =>  "Does the foreach loop work?",
						   read => 'one
two
three',
						   write => undef,
						  },
						

						 ],
				description => "Does a simple foreach loop work?",
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
       name => 'core/foreachloop.t',
      };


return $test;
