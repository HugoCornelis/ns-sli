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


