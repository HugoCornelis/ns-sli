#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/copy.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  


	       

						  {
						   description => "Is parameter CM set correctly?",
						   read => 'value = 4.57537e-11',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/c CM',
						  },


						  {
						   description => "Is parameter CM set correctly in the copy?",
						   read => 'value = 4.57537e-11',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/o CM',
						  },


						  {
						   description => "Is parameter RM set correctly?",
						   read => 'value = 3.58441e+08',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/c RM',
						  },


						  {
						   description => "Is parameter RM set correctly in the copy?",
						   read => 'value = 3.58441e+08',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/o RM',
						  },




						  {
						   description => "Is parameter RA set correctly?",
						   read => 'value = 360502',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/c RA',
						  },


						  {
						   description => "Is parameter RA set correctly in the copy?",
						   read => 'value = 360502',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/o RA',
						  },







						  {
						   description => "Is parameter len set correctly?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/c LEN',
						  },


						  {
						   description => "Is parameter len set correctly in the copy?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/o LEN',
						  },





						  {
						   description => "Is parameter dia set correctly?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/c DIA',
						  },


						  {
						   description => "Is parameter dia set correctly in the copy?",
						   read => 'value = 1',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/o DIA',
						  },



						  {
						   description => "Is parameter initVm set correctly?",
						   read => 'value = -0.068',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/c Vm_init',
						  },


						  {
						   description => "Is parameter initVm set correctly in the copy?",
						   read => 'value = -0.068',
						   timeout => 5,
						   write => 'printparameterscaled /hardcoded_neutral/o Vm_init',
						  },




						  {
						   description => "Is parameter Eleak set correctly?",
						   read => 'value = -0.08',
						   timeout => 5,
						   write => 'printparameter /hardcoded_neutral/c ELEAK',
						  },


						  {
						   description => "Is parameter Eleak set correctly in the copy?",
						   read => 'value = -0.08',
						   timeout => 5,
						   write => 'printparameter /hardcoded_neutral/o ELEAK',
						  },

						 ],
				description => "Was a copy made and was its fields set?",


			       },
			      ],
       description => "create a compartment, set its fields and then copy it ",
       name => 'core/copy.t',
      };


return $test;


