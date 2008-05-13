#!/usr/bin/perl -w
#

use strict;


# slurp mode

#local $/;


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
						   description => "Are gates tabulated correctly, p type calcium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-cap.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "p type calcium gate tabulation",
			       },




			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-cat.g",
					     ],
				command => 'src/nsgenesis',			    
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, calcium t-type gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-cat.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "Calcium t-type gate tabulation",
			       },





			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-k2.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, K2 potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-k2.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "K2 potassium gate tabulation",
			       },





			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-ka.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, simple potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-ka.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "Simple potassium gate tabulation",
			       },





			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-kc.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are gates tabulated correctly, simple potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kc.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "Calcium dependent potassium gate tabulation",
			       },



			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-kdr.g",
					     ],
				command => 'src/nsgenesis',				command_tests => [
						  {
						   description => "Are gates tabulated correctly, delayed rectifier potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kdr.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "Delayed rectifier potassium gate tabulation",
			       },



			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-kdr2.g",
					     ],
				command => 'src/nsgenesis',				command_tests => [
						  {
						   description => "Are gates tabulated correctly, regular delayed rectifier potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kdr2.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "Delayed rectifier potassium gate tabulation",
			       },




			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-kh.g",
					     ],
				command => 'src/nsgenesis',				command_tests => [
						  {
						   description => "Are gates tabulated correctly, anomalous rectifier potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-kh.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "Anomalous rectifier potassium gate tabulation",
			       },





			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-km.g",
					     ],
				command => 'src/nsgenesis',				command_tests => [
						  {
						   description => "Are gates tabulated correctly, muscarinic potassium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-km.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "Muscarinic potassium gate tabulation",
			       },





			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-naf.g",
					     ],
				command => 'src/nsgenesis',				command_tests => [
						  {
						   description => "Are gates tabulated correctly, simple sodium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-naf.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "Simple sodium gate tabulation",
			       },



			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/table-nap.g",
					     ],
				command => 'src/nsgenesis',				command_tests => [
						  {
						   description => "Are gates tabulated correctly, persistent sodium gates ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/table-nap.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "Persistent sodium gate tabulation",
			       },
			      ],
       description => "Gate tabulation",
       name => 'tables.t',
      };


return $test;


