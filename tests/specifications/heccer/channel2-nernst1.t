#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;


my $root_neutral = "hardcoded_neutral";

my $test
    = {
       command_definitions => [

		       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/channel2-nernst1.g",
					
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   disabled => "It doesn't look like this test will have output that will line up with the heccer output without some hacky work. The script detects the two nernst instances, one in each compartment and produces output from it's function. This output is not present int he heccer expected output, so filtering of output must be done on the seen output rather than the expected. Even so, some of the numerical values are a bit off, most likely due to the presence of the nernst function calculations on the reversal potential.",
						   comment => "It doesn't look like this test will have output that will line up with the heccer output without some hacky work. The script detects the two nernst instances, one in each compartment and produces output from it's function. This output is not present int he heccer expected output, so filtering of output must be done on the seen output rather than the expected. Even so, some of the numerical values are a bit off, most likely due to the presence of the nernst function calculations on the reversal potential.",
						   numerical_compare => 1,
						    description => "Is the solved nernst potential applied for two channel reversal potentials ?",
						   read => (join '', `cat  /usr/local/heccer/tests/specifications/strings/pool1-nernst.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "solved nernst potential application for two channel reversal potentials",
			
			       },








			      ],
       description => "Channel and Nernst equation integration",
       name => 'heccer/channel2-nernst1.t',
      };


return $test;


