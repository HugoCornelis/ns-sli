#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				command => 'src/ns-sli',
				description => "prepare the check for version information",
				side_effects => 'force a restart of the application before checking version numbers, the version information is in the header printed during startup.',
			       },
			       {
				arguments => [
					     
					     ],
				command => 'src/ns-sli',
				command_tests => [
					
						  {
						   # $Format: "description => \"Does the version information match with ${package}-${label} ?\","$
description => "Does the version information match with ns-sli-python-2 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "ns-sli-python-2",
						   
						  },
						 ],
				description => "check version information",
			       },
			      ],
       description => "run-time versioning",
       name => 'version.t',
      };


return $test;


