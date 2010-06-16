#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [


			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/genesis-2/pulsegen-freerun.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [

						  {
						   description => "Can we create a pulsegen in the genesis 2 namespace ?",
						   read => 'model_container {neurospaces}           neurospaces_integrator {nsintegrator}   
*proto {neutral}                        output {neutral}                        
pulse0 {pulsegen}                       pulse0_out {asc_file}',
						   timeout => 5,
						   write => 'le -t',
						  },


						  {

						   description => "Can we read fields all at once?",
						   read => '
[ /pulse0 ]
---
show_parameters:
\'parameter name\': TRIGMODE
type: number
value: 0

\'parameter name\': BASELEVEL
type: number
value: 10

\'parameter name\': DELAY2
type: number
value: 8

\'parameter name\': WIDTH2
type: number
value: 5

\'parameter name\': LEVEL2
type: number
value: -20

\'parameter name\': DELAY1
type: number
value: 5

\'parameter name\': WIDTH1
type: number
value: 3

\'parameter name\': LEVEL1
type: number
value: 50

\'parameter name\': output
type: number
value: 10
',
						   timeout => 5,
						   write => 'showfield /pulse0 *',
						  },

						 ],
				description => "Can we create a pulsegen in the genesis 2 namespace ?",


			       },





			      ],
       description => "Test functionality of the pulsegen in genesis 2 ",
       name => 'pulsegen.t',
      };


return $test;


