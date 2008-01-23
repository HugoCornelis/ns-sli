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
						   description => "Add a field to an object in genesis.",
						   read => 'AVAILABLE OBJECTS:
neurospaces         neutral',
						   write => 'listobjects',
						  },
						 ],
				description => "Tests genesis control structures",
			       },
			      ],
       name => 'addfield.t',
      };


return $test;


