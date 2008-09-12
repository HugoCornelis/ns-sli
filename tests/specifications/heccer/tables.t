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









			       {
				arguments => [

					      "$::config->{core_directory}/tests/scripts/heccer/table-naf.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, simple sodium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-naf.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "Simple sodium gate tabulation",
			       },








			       {
				arguments => [

					      "$::config->{core_directory}/tests/scripts/heccer/table-cat.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						  description => "Are gates tabulated correctly, calcium t-type gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-cat.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "Calcium t-type gate tabulation",
			       },














			       {
				arguments => [

					      "$::config->{core_directory}/tests/scripts/heccer/table-cap.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						  description => "Are gates tabulated correctly, p type calcium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-cap.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   numerical_compare => 'small arithmetic due to double to float conversions and vice versa',
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "p type calcium gate tabulation",


			       },










			       {
				arguments => [

					      "$::config->{core_directory}/tests/scripts/heccer/table-ka.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, simple potassium gates ? (table-ka.g)",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-ka.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),

						   numerical_compare => 'small arithmetic due to double to float conversions and vice versa',
						   timeout => 5,
						   write => undef,
						  },
						 ],
					description => "Simple potassium gate tabulation",



			       },






{
				arguments => [

					       "$::config->{core_directory}/tests/scripts/heccer/table-km.g",

					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, muscarinic potassium gates (table-km.g) ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-km.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "Muscarinic potassium gate tabulation",
			       },






  {
				arguments => [

					        "$::config->{core_directory}/tests/scripts/heccer/table-kh.g",

					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, anomalous rectifier potassium gates (table-kh.g) ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kh.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "Anomalous rectifier potassium gate tabulation",
			       },


			      ],
       description => "Gate tabulation",
       name => 'tables.t',
      };


return $test;


