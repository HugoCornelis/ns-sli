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
					         "$::config->{core_directory}/tests/scripts/heccer/channel1-nernst1.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   numerical_compare => 1,
						   description => "Ca we set up a Nernst equation for a channel ?",,
						   read => (join '', `cat  /usr/local/heccer/tests/specifications/strings/channel1-nernst1.txt | perl -pe 's/unnamed test/\/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "nernst function on a channel.",
			
			       },












			      ],
       description => "Channel and Nernst equation integration",
       name => 'channel1-nernst1.t',
      };


return $test;

