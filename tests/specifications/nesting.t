#!/usr/bin/perl -w
#

use strict;


my $previous_library;

my $printinfo_output = "/hardcoded_neutral
/hardcoded_neutral/c1
/hardcoded_neutral/c1/c2
/hardcoded_neutral/c1/c2/c3
/hardcoded_neutral/c1/c2/c3/c4
/hardcoded_neutral/c1/c2/c3/c4/c5
/hardcoded_neutral/c1/c2/c3/c4/c5/c6
/hardcoded_neutral/c1/c2/c3/nap3
/hardcoded_neutral/c1/c2/nap2
/hardcoded_neutral/c1/nap";








my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/nesting.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Can we add a message between compartments ?",
						   read => $printinfo_output,
						   write => 'expand /hardcoded_neutral/**',
						  },
						  

					


						 ],
				description => "Can we create nested compartments?",


			       },
			      ],
       description => "create a nesting of several compartments.",
       name => 'nesting.t'
      };


return $test;


