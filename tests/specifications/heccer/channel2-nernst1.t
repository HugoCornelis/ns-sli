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
       name => 'channel2-nernst1.t',
      };


return $test;


