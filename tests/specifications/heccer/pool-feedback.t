#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;

my $text_expected =  `cat  /usr/local/heccer/tests/specifications/strings/pool1-feedback1.txt | perl -pe 's/unnamed test/\/hardcoded_neutral/g' | perl -pe 's/^.*iSmallTableSize.*3000.*$/Heccer Options (iSmallTableSize) : (149)/g'`;

my $test
    = {
       command_definitions => [








			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/pool-feedback.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   numerical_compare => 1,
						   description => "Is ota pool integrated correctly, one compartment, one pool with a feedback loop ?",,
						   read => (join '', $text_expected),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "pool integration, one compartment, one pool with a feedback loop.",
			
			       },












			      ],
       description => "pool integration, one compartment, one pool with a feedback loop",
       name => 'pool-feedback.t',
      };


return $test;


