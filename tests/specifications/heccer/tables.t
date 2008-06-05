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
					         "$::config->{core_directory}/tests/scripts/heccer/table-nap.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, persistent sodium gates ?",
						   read => (join '', `cat  /usr/local/heccer/tests/specifications/strings/table-nap.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "Persistent sodium gate tabulation",
				#numerical_compare => 'small arithmetic due to double to float conversions and vice versa',
			       },
			      ],
       description => "Gate tabulation",
       name => 'tables.t',
      };


return $test;


