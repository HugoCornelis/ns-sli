#!/usr/bin/perl -w
#

use strict;


my $previous_library;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/parameters.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Is nsgenesis startup ok, is the initial model container created ?",
						   read => 'model_container {neurospaces}',
						   write => undef,
						  },
						  {
						   description => "Is the compartment created inside the model container ?",
						   read => '/c',
						   write => 'expand /**',
						  },
						  {
						   description => "Is the capacitance ok ?",
						   read => '= 1',
						   write => 'printparameter /c CM',
						  },
						  {
						   description => "Is the capacitance ok, scaled value ?",
						   read => '= 1',
						   write => 'printparameterscaled /c CM',
						  },
						 ],
				description => "simple script",
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
       description => "create a single compartment, check if the compartment in neurospaces is ok",
       name => 'singlep.t'
      };


return $test;


