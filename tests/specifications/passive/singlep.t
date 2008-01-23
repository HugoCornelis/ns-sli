#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/passive/singlep.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Is nsgenesis startup ok, is the initial model container created ?",
						   read => 'neurospaces\t\t{neurospaces}',
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
			       },
			      ],
       description => "create a single compartment, check if the compartment in neurospaces is ok",
       name => 'singlep.t'
      };


return $test;


