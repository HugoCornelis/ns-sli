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
					         "$::config->{core_directory}/tests/scripts/heccer/pool1.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   numerical_compare => 1,
						   description => "Is a pool integrated correctly, one compartment, single pool case ?",,
						   read => (join '', `cat  /usr/local/heccer/tests/specifications/strings/pool1.txt | perl -pe 's/unnamed test/$root_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "pool integration, one compartment, single pool",
			
			       },







			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/pool2.g",
					    
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						    numerical_compare => 1,
						   description => "Is a pool integrated correctly, two compartments, two pools case ?",,
						   read => (join '', `cat  /usr/local/heccer/tests/specifications/strings/pool2.txt | perl -pe 's/unnamed test/$root_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "pool integration, two compartments, two pools",
			       },





			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/pool-feedback.g",
					    
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Is a pool integrated correctly, one compartment, one pool with a feedback loop ?",,
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/pool1-feedback1.txt | perl -pe 's/unnamed test/$root_neutral/g' | perl -pe 's/149/3000/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "pool integration, one compartment, one pool with a feedback loop",
			       },








			      ],
       description => "Pool integration & related",
       name => 'pools.t',
      };


return $test;


