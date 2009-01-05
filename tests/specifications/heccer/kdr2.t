#!/usr/bin/perl -w
#

use strict;

my $root_neutral = "hardcoded_neutral";


# slurp mode

local $/;


my $test
    = {
       command_definitions => [

			       {
				arguments => [

					      "$::config->{core_directory}/tests/scripts/heccer/table-kc-nodump.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [




						  {
						  
						   description => "Is Z_A->table[1] set ?",
						   read => '60.1562',
						   write => 'printparameter /hardcoded_neutral/c2/kc/HH_concentration/A table[1]',
						  
						  },










						  {
						  
						   description => "Is Z_A->table[10] set ?",
						   read => '93.7531',
						   write => 'printparameter /hardcoded_neutral/c2/kc/HH_concentration/A table[10]',
						  
						  },







						  {
						  
						   description => "Is Z_A->table[20] set ?",
						   read => '96.7748',
						   write => 'printparameter /hardcoded_neutral/c2/kc/HH_concentration/A table[20]',
						  
						  },






						  {
						  
						   description => "Is Z_A->table[30] set ?",
						   read => '97.8263',
						   write => 'printparameter /hardcoded_neutral/c2/kc/HH_concentration/A table[30]',
						  
						  },





						  {
						  
						   description => "Is Z_A->table[40] set ?",
						   read => '98.3607',
						   write => 'printparameter /hardcoded_neutral/c2/kc/HH_concentration/A table[40]',
						  
						  },







						  {
						  
						   description => "Is Z_B->table[25] set ?",
						   read => '100',
						   write => 'printparameter /hardcoded_neutral/c2/kc/HH_concentration/B table[25]',
						  
						  },



						 ],
				description => "Are potassium concentration tables set up correctly ?",



			       },












			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-kc.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, simple potassium gates ?",,
						   read => (join '', `cat  /usr/local/heccer/tests/specifications/strings/table-kc.txt | perl -pe 's/unnamed test/$root_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "Calcium dependent potassium gate tabulation",
				#numerical_compare => 'small arithmetic due to double to float conversions and vice versa',
			       },






			      ],
       description => "Gate tabulation",
       name => 'kdr2.t',
      };


return $test;


