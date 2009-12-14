#!/usr/bin/perl -w
#

use strict;

# slurp mode

local $/;


my $root_neutral = "/hardcoded_neutral";

my $test
    = {
       command_definitions => [


			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/pool1-nernst.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   comment => "The expected output has the INTERNALNERNST opcode removed, which is different from the heccer stand-alone expected output.  Heccer does not detect the nernst element because it is not attached to a channel.",
						   description => "Is the concentration dependent nernst potential calculated correctly ?",,
						   numerical_compare => 1,

						   read => (join '', `cat  /usr/local/heccer/tests/specifications/strings/pool1-nernst.txt | perl -pe 's(unnamed test)($root_neutral)g' | perl -pe 's/^.*INTERNALNERNST.*\\\n//g' | perl -pe 's/^.*00010 :: FINISH/00009 :: FINISH/g'`),

						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "Concentration dependent nernst potential calculation.",
			
			       },




			      ],
       description => "concentration dependent nernst potential calculation",
       name => 'heccer/pool-nernst.t',
      };


return $test;


