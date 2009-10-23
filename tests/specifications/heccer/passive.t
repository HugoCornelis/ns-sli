#!/usr/bin/perl -w
#

use strict;

# slurp mode

local $/;


my $root_neutral = "/hardcoded_neutral/";

my $test
    = {
       command_definitions => [


			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/passive/singlep.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Is a single passive compartment solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/singlep.txt | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "single passive compartment.",
			       },






			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/passive/double.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Are two passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/doublep.txt | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 5,
						   write => undef,
						  },
						 
						 ],
				description => "doublet passive compartment.",
			       },








			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/triple.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Are three passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/triplep.txt | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 18,
						   write => undef,
						  },

						 ],
				description => "triplet passive compartment.",
				
			       },






			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/fork3p.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Is a fork of three passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork3p.txt | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "fork of three passive compartments.",
			       },






			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/fork4p1.g",
					      ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, first alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p1.txt | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, first alternative.",
				
			       },







			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/fork4p2.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, second alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p2.txt  | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, second alternative.",
			     
			       },





			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/fork4p3.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, third alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p3.txt | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, third alternative.",
			
			       },







			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/c1c2p1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Are two passive compartments with injected current solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/c1c2p1.txt | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "two passive compartments with injected current",
		
				
			       },






			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/c1c2p2.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Are two passive compartments with asymetric properties and injected current solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/c1c2p2.txt  | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "two passive compartments with asymetric properties and injected current",
				
			       },







			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/tensizesp.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Are ten passive compartments with different properties and injected current solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/tensizesp.txt  | perl -pe 's(unnamed test)($root_neutral)g'`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "ten passive compartments with different properties and injected current",



			       },


			      ],
				
       comment => 'See comments in the tester scripts for todos related to parameter caches in the model container',
       description => "passive model testing",



       name => 'heccer/passive.t',
      };


return $test;


