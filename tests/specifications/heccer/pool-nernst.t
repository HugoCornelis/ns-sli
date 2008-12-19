#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;


my $test
    = {
       command_definitions => [








			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/pool1-nernst.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
	
						   numerical_compare => 1,
						   description => "Is the concentration dependent nernst potential calculated correctly ?",,
						   read => (join '', `cat  /usr/local/heccer/tests/specifications/strings/pool1-nernst.txt | perl -pe 's/unnamed test/\\/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "Concentration dependent nernst potential calculation.",
			
			       },




			      ],
       description => "concentration dependent nernst potential calculation",
       name => 'pool-nernst.t',
      };


return $test;

