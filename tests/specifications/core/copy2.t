#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/genesis-2/copy2.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  


	       

						  {
						   description => "Is parameter CM set correctly?",
						   read => 'value = 4.57537e-11',
						   write => 'printparameterscaled /n1/c CM',
						  },


						  {
						   description => "Is parameter CM set correctly in the copy?",
						   read => 'value = 4.57537e-11',
						   write => 'printparameterscaled /n2/o CM',
						  },


						  {
						   description => "Is parameter RM set correctly?",
						   read => 'value = 3.58441e+08',
						   write => 'printparameterscaled /n1/c RM',
						  },


						  {
						   description => "Is parameter RM set correctly in the copy?",
						   read => 'value = 3.58441e+08',
						   write => 'printparameterscaled /n2/o RM',
						  },





						  {
						   description => "Is parameter RA set correctly?",
						   read => 'value = 360502',
						   timeout => 5,
						   write => 'printparameterscaled /n1/c RA',
						  },


						  {
						   description => "Is parameter RA set correctly in the copy?",
						   read => 'value = 360502',
						   timeout => 5,
						   write => 'printparameterscaled /n2/o RA',
						  },







						  {
						   description => "Is parameter len set correctly?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /n1/c LEN',
						  },


						  {
						   description => "Is parameter len set correctly in the copy?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /n2/o LEN',
						  },





						  {
						   description => "Is parameter dia set correctly?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /n1/c DIA',
						  },


						  {
						   description => "Is parameter dia set correctly in the copy?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /n2/o DIA',
						  },



						  {
						   description => "Is parameter initVm set correctly?",
						   read => 'value = -0.068',
						   timeout => 5,
						   write => 'printparameterscaled /n1/c Vm_init',
						  },


						  {
						   description => "Is parameter initVm set correctly in the copy?",
						   read => 'value = -0.068',
						   timeout => 5,
						   write => 'printparameterscaled /n2/o Vm_init',
						  },




						  {
						   description => "Is parameter Eleak set correctly?",
						   read => 'value = -0.08',
						   timeout => 5,
						   write => 'printparameter /n1/c ELEAK',
						  },


						  {
						   description => "Is parameter Eleak set correctly in the copy?",
						   read => 'value = -0.08',
						   timeout => 5,
						   write => 'printparameter /n2/o ELEAK',
						  },







						 ],
				description => "Was a copy made and was its fields set?",


			       },
			      ],
       description => "Can we copy a compartment from one independent neutral root to another? ",
       name => 'core/copy2.t',
      };


return $test;


