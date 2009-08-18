#!/usr/bin/perl -w
#

use strict;


my $previous_library;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/heccerreset.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Can we create a root neutral compartment ?",
						   read => 'hardcoded_neutral {neutral}',
						   write => undef,
						  },
						  

						  {
						   description => "Is the number of compartments equal to 1?",
						   read => 'Intermediary (iCompartments) : (1)',
                                                   write => undef,
      						  },

						  {
						   description => "Is CM set correctly ?",
						   read => 'Compartment (dCm) : (4.57537e-11)',
                                                   write => undef,
      						  },

						  {
						   description => "Is EM set correctly ?",
						   read => 'Compartment (dEm) : (-0.08)',
                                                   write => undef,
      						  },


						  {
						   description => "Is initVm set correctly ?",
						   read => 'Compartment (dInitVm) : (-0.068)',
                                                   write => undef,
      						  },



						  {
						   description => "Is inject set correctly ?",
						   read => 'Compartment (dInject) : (0)',
                                                   write => undef,
      						  },


						  {
						   description => "Is RA set correctly ?",
						   read => 'Compartment (dRa) : (360502)',
                                                   write => undef,
      						  },


						  {
						   description => "Is RM set correctly ?",
						   read => 'Compartment (dRm) : (3.58441e+08)',
                                                   write => undef,
      						  },




						 ],
				description => "script performs a reset on a compartment",


			       },
			      ],
       description => "create a neutral object with a compartment as a child, check if ",
       name => 'heccer/heccerreset.t',
      };


return $test;


