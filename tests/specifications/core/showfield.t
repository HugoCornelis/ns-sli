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
						   description => "Can we read fields one at a time?",
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








			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/genesis-2/showfield5.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [

						  {
						   description => "Can we print extended information for each field?",
						   read => '[ /n/c ]
\'parameter name\': CM
type: function
\'function name\': GENESIS2
\'function parameters\':

  -
    \'parameter name\': scale
    type: number
    value: 1
  -
    \'parameter name\': value
    type: number
    value: 4.57537e-11

[ /n/c ]
\'parameter name\': RM
type: function
\'function name\': GENESIS2
\'function parameters\':

  -
    \'parameter name\': scale
    type: number
    value: 1
  -
    \'parameter name\': value
    type: number
    value: 3.58441e+08

[ /n/c ]
\'parameter name\': RA
type: function
\'function name\': GENESIS2
\'function parameters\':

  -
    \'parameter name\': scale
    type: number
    value: 1
  -
    \'parameter name\': value
    type: number
    value: 360502

[ /n/c ]
\'parameter name\': LENGTH
type: number
value: 1

[ /n/c ]
\'parameter name\': DIA
type: number
value: 1

[ /n/c ]
\'parameter name\': Vm_init
type: number
value: -0.068

[ /n/c ]
\'parameter name\': ELEAK
type: number
value: -0.08',
						   timeout => 5,
						   write => undef,
						  },

						 ],
				description => "Can we print extended info for each field one at a time?",


			       },






			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/genesis-2/showfield3.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [

						  {
						   description => "Can we print out using a wildcard for the element field?",
						   read => 'Testing wildcard: display all fields

[ /n/c ]
---
show_parameters:
\'parameter name\': ELEAK
type: number
value: -0.08

\'parameter name\': Vm_init
type: number
value: -0.068

\'parameter name\': DIA
type: number
value: 1

\'parameter name\': LENGTH
type: number
value: 1

\'parameter name\': RA
type: function
\'function name\': GENESIS2
\'function parameters\':

  -
    \'parameter name\': scale
    type: number
    value: 1
  -
    \'parameter name\': value
    type: number
    value: 360502

\'parameter name\': RM
type: function
\'function name\': GENESIS2
\'function parameters\':

  -
    \'parameter name\': scale
    type: number
    value: 1
  -
    \'parameter name\': value
    type: number
    value: 3.58441e+08

\'parameter name\': CM
type: function
\'function name\': GENESIS2
\'function parameters\':

  -
    \'parameter name\': scale
    type: number
    value: 1
  -
    \'parameter name\': value
    type: number
    value: 4.57537e-11',
						   timeout => 5,
						   write => undef,
						  },

						 ],
				description => "Can we print from a wildcard?",


			       },





			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/springmass1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [

						  {
						   description => "Can we read voltage potential from compartment 1 in springmass1.g?",
						   read => '[ /hardcoded_neutral/c1 ]
Vm	-7.916984e-02',
						   timeout => 5,
						   write => 'showfield /hardcoded_neutral/c1 Vm',
						  },

						  {
						   description => "Can we read voltage potential from compartment 2 in springmass1.g?",
						   read => '[ /hardcoded_neutral/c2 ]
Vm	-7.916970e-02',
						   timeout => 5,
						   write => 'showfield /hardcoded_neutral/c2 Vm',
						  },

						 ],
				description => "Can we show a field from a heccer solved variable?",


			       },




			      ],
       description => "create a compartment, set its fields and then copy it ",
       name => 'core/showfield.t',
      };


return $test;


