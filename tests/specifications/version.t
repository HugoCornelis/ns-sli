#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     
					     ],
				command => 'src/nsgenesis',
				command_tests => [
					
						  {
						   # $Format: "description => \"Does the version information match with ${package}-${label} ?\","$
description => "Does the version information match with ns-genesis-SLI-network-2 ?",
						   # $Format: "read => \"${package}-${label}\","$
read => "ns-genesis-SLI-network-2",
						   write=> 'exit',
						   
						  },
						 ],
				description => "check version information",
			       },
			      ],
       description => "run-time versioning",
       name => 'version.t',
      };


return $test;


