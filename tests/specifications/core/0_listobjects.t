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
						   read => 'known G-2 objects and their associated G-3 implementation:
  Ca_concen: NSINTEGRATOR_POOL (40)
  asc_file: NSINTEGRATOR_ASCFILE (70)
  channelC2: NSINTEGRATOR_SYNCHAN (60)
  channelC3: NSINTEGRATOR_SYNCHAN (60)
  compartment: NSINTEGRATOR_COMPARTMENT (10)
  hsolve: NSINTEGRATOR_NEUTRAL (20)
  nernst: NSINTEGRATOR_NERNST (50)
  projection: NSINTEGRATOR_NEUTRAL (20)
  spikegen: NSINTEGRATOR_SPIKEGEN (90)
  symcompartment: NSINTEGRATOR_COMPARTMENT (10)
  synchan: NSINTEGRATOR_SYNCHAN (60)
  tabchannel: NSINTEGRATOR_TABCHANNEL (30)
  leakage: NSINTEGRATOR_LEAKAGE (110)
  -1: NSINTEGRATOR_NEUTRAL (20)
  -1: NSINTEGRATOR_PULSEGEN (100)
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

