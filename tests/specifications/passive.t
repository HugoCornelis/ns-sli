#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;


#t
#t Need a test with one passive compartment that has self as parent.
#t This is supposed to fail, but it just gives wrong results instead
#t of failing.
#t
#t This came out as an annoyance during implementation of the swig perl glue.
#t

my $previous_library;

my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/passive/singlep.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Is a single passive compartment solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/singlep.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "single passive compartment.",
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/doublep',
				command_tests => [
						  {
						   description => "Are two passive compartments solved correctly ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/doublep.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "doublet passive compartment.",
				disabled => 1,
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/triplep',
				command_tests => [
						  {
						   description => "Are three passive compartments solved correctly ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/triplep.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "triplet passive compartment.",
				disabled => 1,
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/fork3p',
				command_tests => [
						  {
						   description => "Is a fork of three passive compartments solved correctly ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/fork3p.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "fork of three passive compartments.",
				disabled => 1,
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/fork4p1',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, first alternative ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/fork4p1.txt`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, first alternative.",
				disabled => 1,
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/fork4p2',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, second alternative ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/fork4p2.txt`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, second alternative.",
				disabled => 1,
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/fork4p3',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, third alternative ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/fork4p3.txt`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, third alternative.",
				disabled => 1,
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/c1c2p1',
				command_tests => [
						  {
						   description => "Are two passive compartments with injected current solved correctly ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/c1c2p1.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "two passive compartments with injected current",
				disabled => 1,
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/c1c2p2',
				command_tests => [
						  {
						   description => "Are two passive compartments with asymetric properties and injected current solved correctly ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/c1c2p2.txt`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "two passive compartments with asymetric properties and injected current",
				disabled => 1,
			       },
			       {
				arguments => [
					     ],
				command => 'tests/code/tensizesp',
				command_tests => [
						  {
						   description => "Are ten passive compartments with different properties and injected current solved correctly ?",
						   read => (join '', `cat $::config->{core_directory}/tests/specifications/strings/tensizesp.txt`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "ten passive compartments with different properties and injected current",
				disabled => 1,




			       },


			      ],
				
				preparation => {
						description => "Setting the environment entry to point to a model library",
						preparer =>
						sub
						{
						  $previous_library = $ENV{NEUROSPACES_MODELS};

						  $ENV{NEUROSPACES_MODELS} = $::config->{core_directory} . '/src';
						},
					       },
				reparation => {
					       description => "Removing the environment entry to point to a model library",
					       reparer =>
					       sub
					       {
						 $ENV{NEUROSPACES_MODELS} = $previous_library;

						 '';
					       },
					      },



       description => "passive model testing",



       name => 'passive.t',
      };


return $test;


