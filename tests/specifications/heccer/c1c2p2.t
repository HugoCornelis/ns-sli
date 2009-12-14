#!/usr/bin/perl -w
#

use strict;


my $previous_library;


my $root_neutral = "/hardcoded_neutral";






my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/c1c2p2.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [

						  {
						   description => "Can we add a message between compartments ?",
						   read => (join '', `cat  /usr/local/heccer/tests/specifications/strings/c1c2p2.txt | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 5,
						  },
						  

					


						 ],
				description => "script performs a reset on a compartment",


			       },
			      ],
       description => "create a neutral object with a compartment as a child, check if ",
       name => 'heccer/c1c2p2.t',
      };


return $test;


