#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;

my $root_neutral = "hardcoded_neutral";

#t the substitution string should be 's/^.*iSmallTableSize.*3000.*\$/Heccer Options (iSmallTableSize) : (149)/g', with an additional backslash before the dollar sign that marks the end of string.

my $text_expected =  `cat  /usr/local/heccer/tests/specifications/strings/pool1-feedback1.txt | perl -pe 's/unnamed test/$root_neutral/g' | perl -pe 's/.*iSmallTableSize.*149.*/Heccer Options (iSmallTableSize) : (3000)/g'`;

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
						   description => "Is a pool integrated correctly, one compartment, one pool with a feedback loop ?",
						   read => (join '', $text_expected),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "pool integration, one compartment, one pool with a feedback loop.",
			
			       },












			      ],
       description => "pool integration, one compartment, one pool with a feedback loop",
       name => 'heccer/pool-feedback.t',
      };


return $test;


