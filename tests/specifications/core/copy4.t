#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/genesis-2/copy4.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  


	       

						  {
						   description => "Is parameter CM set correctly?",
						   read => 'value = 4.57537e-11',
						   write => 'printparameterscaled /c CM',
						  },


						  {
						   description => "Is parameter CM set correctly in the copy?",
						   read => 'value = 4.57537e-11',
						   write => 'printparameterscaled /o CM',
						  },


						  {
						   description => "Is parameter RM set correctly?",
						   read => 'value = 3.58441e+08',
						   write => 'printparameterscaled /c RM',
						  },


						  {
						   description => "Is parameter RM set correctly in the copy?",
						   read => 'value = 3.58441e+08',
						   write => 'printparameterscaled /o RM',
						  },




						  {
						   description => "Is parameter RA set correctly?",
						   read => 'value = 360502',
						   timeout => 5,
						   write => 'printparameterscaled /c RA',
						  },


						  {
						   description => "Is parameter RA set correctly in the copy?",
						   read => 'value = 360502',
						   timeout => 5,
						   write => 'printparameterscaled /o RA',
						  },







						  {
						   description => "Is parameter len set correctly?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /c LEN',
						  },


						  {
						   description => "Is parameter len set correctly in the copy?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /o LEN',
						  },





						  {
						   description => "Is parameter dia set correctly?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /c DIA',
						  },


						  {
						   description => "Is parameter dia set correctly in the copy?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /o DIA',
						  },



						  {
						   description => "Is parameter initVm set correctly?",
						   read => 'value = -0.068',
						   timeout => 5,
						   write => 'printparameterscaled /c Vm_init',
						  },


						  {
						   description => "Is parameter initVm set correctly in the copy?",
						   read => 'value = -0.068',
						   timeout => 5,
						   write => 'printparameterscaled /o Vm_init',
						  },




						  {
						   description => "Is parameter Eleak set correctly?",
						   read => 'value = -0.08',
						   timeout => 5,
						   write => 'printparameter /c ELEAK',
						  },


						  {
						   description => "Is parameter Eleak set correctly in the copy?",
						   read => 'value = -0.08',
						   timeout => 5,
						   write => 'printparameter /o ELEAK',
						  },






						 ],
				description => "Was a copy made and was its fields set?",


			       },
			      ],
       description => "Can we copy a compartment from a non anchored root to an anchored destination? ",
       name => 'core/copy4.t',
      };


return $test;


