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

					      "$::config->{core_directory}/tests/scripts/heccer/table-kdr.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [







						  {
						  
						   description => "Is HH_Format set ?",
						   read => 'steadystate-tau',
						   write => 'printparameter /hardcoded_neutral/c/kdr/HH_activation HH_Format',
						  
						  },




						 ],
				description => "Is tabfill parameter set correctly ?",



			       },








			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-kdr.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, delayed rectifier potassium gates ?",,
						   read => (join '', `cat  /usr/local/heccer/tests/specifications/strings/table-kdr.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "Delayed rectifier potassium gate tabulation",

			       },






			      ],
       description => "Gate tabulation",
       name => 'table-kdr.t',
      };


return $test;


