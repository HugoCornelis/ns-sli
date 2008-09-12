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

					      "$::config->{core_directory}/tests/scripts/heccer/table-kdr-nodump.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [



						  {
						  
						   description => "Is HH_Format set ?",
						   read => 'value = "steadystate-tau"',
						   timeout => 5,
						   write => 'printparameter /hardcoded_neutral/c/kdr/HH_activation HH_Format',
						  
						  },


						  {
						  
						   description => "Has the gate kinetic interpolated ?",
						   read => 'value = 50',
						   timeout => 5,
						   write => 'printparameter /hardcoded_neutral/c/kdr/HH_activation/A HH_NUMBER_OF_TABLE_ENTRIES',
						  
						  },


						  {
						  
						   description => "Has the gate kinetic interpolated ?",
						   read => 'value = 50',
						   timeout => 5,
						   write => 'printparameter /hardcoded_neutral/c/kdr/HH_activation/B HH_NUMBER_OF_TABLE_ENTRIES',
						  
						  },



						  {
						  
						   description => "Has the gate kinetic interpolated ?",
						   read => 'value = 50',
						   timeout => 5,
						   write => 'printparameter /hardcoded_neutral/c/kdr/HH_inactivation/B HH_NUMBER_OF_TABLE_ENTRIES',
						  
						  },

						  {
						  
						   description => "Has the gate kinetic interpolated ?",
						   read => 'value = 50',
						   timeout => 5,
						   write => 'printparameter /hardcoded_neutral/c/kdr/HH_inactivation/B HH_NUMBER_OF_TABLE_ENTRIES',
						  
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
						   numerical_compare => 1,
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


