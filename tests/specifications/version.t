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
description => "Does the version information match with ns-sli-userdocs-6 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "ns-sli-userdocs-6",
						  },
						  {
						   description => "Is the interactive major run-time version information correct?",
						   read => "3
",
						   write => "echo {version}",
						  },
						  {
						   description => "Is the interactive minor run-time version information correct?",
						   # $Format: "read => \"${package}-${label}\","$
read => "ns-sli-userdocs-6",
						   write => "echo {version minor}",
						  },
						 ],
				description => "check version information",
			       },
			      ],
       description => "run-time versioning",
       name => 'version.t',
      };


return $test;


