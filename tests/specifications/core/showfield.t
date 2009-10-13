#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [


			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/genesis-2/showfield1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [

						  {
						   description => "Can we read fiels one at a time?",
						   read => 'Checking each field one at a time

[ /n/c ]
Cm	4.575370e-11


[ /n/c ]
Rm	3.584410e+08


[ /n/c ]
Ra	3.605020e+05


[ /n/c ]
len	1.000000e+00


[ /n/c ]
dia	1.000000e+00


[ /n/c ]
initVm	-6.800000e-02


[ /n/c ]
Eleak	-8.000000e-02',
						   timeout => 5,
						   write => undef,
						  },

						 ],
				description => "Can we read fields one command at a time?",


			       },




			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/genesis-2/showfield2.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [

						  {
						   description => "Can we read fields all at once?",
						   read => 'Checking each field on one line

[ /n/c ]
Cm	4.575370e-11

Rm	3.584410e+08

Ra	3.605020e+05

len	1.000000e+00

dia	1.000000e+00

initVm	-6.800000e-02

Eleak	-8.000000e-02',
						   timeout => 5,
						   write => undef,
						  },

						 ],
				description => "Can we read all fields from one command?",


			       },



			      ],
       description => "create a compartment, set its fields and then copy it ",
       name => 'core/showfield.t',
      };


return $test;


