#!/usr/bin/perl -w
#

use strict;


my $previous_library;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
				  "$::config->{core_directory}/tests/scripts/basic-g/listobjects.g",
					],

				command => 'src/ns-sli',
				command_tests => [
						  {
						   description =>  "Add a field to an object in genesis.",
						   read => '
---
known G-2 objects and their associated G-3 implementation:
  Ca_concen: maps to the NDF POOL token (internal values: NSINTEGRATOR_POOL, 40)
  asc_file: does not require NDF representation (internal values: NSINTEGRATOR_ASCFILE, 70)
  channelC2: maps to the NDF CHANNEL token with an exponential equation (internal values: NSINTEGRATOR_SYNCHAN, 60)
  channelC3: maps to the NDF CHANNEL token with an exponential equation (internal values: NSINTEGRATOR_SYNCHAN, 60)
  compartment: maps to the NDF SEGMENT token (internal values: NSINTEGRATOR_COMPARTMENT, 10)
  hsolve: does not require NDF representation (internal values: NSINTEGRATOR_NEUTRAL, 20)
  nernst: maps to an NDF GROUP with specific parameters (internal values: NSINTEGRATOR_NERNST, 50)
  projection: this mapping is currently incomplete (internal values: NSINTEGRATOR_NEUTRAL, 20)
  spikegen: maps to an NDF SPIKEGEN token (internal values: NSINTEGRATOR_SPIKEGEN, 90)
  symcompartment: maps to the NDF SEGMENT token (internal values: NSINTEGRATOR_COMPARTMENT, 10)
  synchan: maps to the NDF CHANNEL token with an exponential equation (internal values: NSINTEGRATOR_SYNCHAN, 60)
  tabchannel: maps to the NDF CHANNEL token (internal values: NSINTEGRATOR_TABCHANNEL, 30)
  leakage: maps to the NDF MEMBRANE_LEAKAGE token (internal values: NSINTEGRATOR_LEAKAGE, 110)
  -1: incomplete implementation (internal values: NSINTEGRATOR_NEUTRAL, 20)
  -1: incomplete implementation (internal values: NSINTEGRATOR_PULSEGEN, 100)
',
						   read_old => 'AVAILABLE OBJECTS:
asc_file            hsolve              neurospaces         neutral             
nsintegrator        pulsegen',
						   write => 'listobjects',
						  },
						

						 ],
				description => "Does the shell list available genesis objects?",
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
						   if (defined $previous_library)
						   {
						       $ENV{NEUROSPACES_MODELS} = $previous_library;
						   }
						   else
						   {
						       undef $previous_library;
						   }

						   '';
					       },
					      },
			       },
			      ],
       description => "List all available genesis objects.",
       name => 'core/0_listobjects.t',
      };


return $test;

