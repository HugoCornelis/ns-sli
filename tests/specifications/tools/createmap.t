#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/createmap1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => 'Is application startup successful?',
						   read => 'genesis #0 > ',
						  },
						  {
						   description => "Can we enter the querymachine?",
						   read => ' neurospaces > ',
						   write => 'call /model_container NEUROSPACES_QUERY',
						  },
						  {
						   description => "Can we find the elements created by the createmap command?",
						   read => '
- /proto
- /output
- /hardcoded_neutral
- /hardcoded_neutral/c
- /m
- /m/0
- /m/1
- /m/2
- /m/3
- /m/4
- /m/5
',
						   write => 'expand /**',
						  },
						  {
						   description => "Are the coordinates correct of the element 0?",
						   read => 'cached coordinate x = 0
cached coordinate y = 0
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/0',
						  },
						  {
						   description => "Are the coordinates correct of the element 1?",
						   read => 'cached coordinate x = 1
cached coordinate y = 0
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/1',
						  },
						  {
						   description => "Are the coordinates correct of the element 2?",
						   read => 'cached coordinate x = 0
cached coordinate y = 1
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/2',
						  },
						  {
						   description => "Are the coordinates correct of the element 3?",
						   read => 'cached coordinate x = 1
cached coordinate y = 1
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/3',
						  },
						  {
						   description => "Are the coordinates correct of the element 4?",
						   read => 'cached coordinate x = 0
cached coordinate y = 2
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/4',
						  },
						  {
						   description => "Are the coordinates correct of the element 5?",
						   read => 'cached coordinate x = 1
cached coordinate y = 2
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/5',
						  },
						 ],
				description => "simple test of the createmap command",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/createmap2.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => 'Is application startup successful?',
						   read => 'genesis #0 > ',
						  },
						  {
						   description => "Can we enter the querymachine?",
						   read => ' neurospaces > ',
						   write => 'call /model_container NEUROSPACES_QUERY',
						  },
						  {
						   description => "Can we find the elements created by the createmap command?",
						   read => '
- /proto
- /output
- /hardcoded_neutral
- /hardcoded_neutral/c
- /m
- /m/0
- /m/1
- /m/2
- /m/3
- /m/4
- /m/5
',
						   write => 'expand /**',
						  },
						  {
						   description => "Are the coordinates correct of the element 0?",
						   read => 'cached coordinate x = 0
cached coordinate y = 0
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/0',
						  },
						  {
						   description => "Are the coordinates correct of the element 1?",
						   read => 'cached coordinate x = 1
cached coordinate y = 0
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/1',
						  },
						  {
						   description => "Are the coordinates correct of the element 2?",
						   read => 'cached coordinate x = 0
cached coordinate y = 1
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/2',
						  },
						  {
						   description => "Are the coordinates correct of the element 3?",
						   read => 'cached coordinate x = 1
cached coordinate y = 1
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/3',
						  },
						  {
						   description => "Are the coordinates correct of the element 4?",
						   read => 'cached coordinate x = 0
cached coordinate y = 2
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/4',
						  },
						  {
						   description => "Are the coordinates correct of the element 5?",
						   read => 'cached coordinate x = 1
cached coordinate y = 2
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/5',
						  },
						 ],
				description => "simple test of the createmap command",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/createmap3.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => 'Is application startup successful?',
						   read => 'genesis #0 > ',
						  },
						  {
						   description => "Can we enter the querymachine?",
						   read => ' neurospaces > ',
						   write => 'call /model_container NEUROSPACES_QUERY',
						  },
						  {
						   description => "Can we find the elements created by the createmap command?",
						   read => '
- /proto
- /output
- /hardcoded_neutral
- /hardcoded_neutral/c
- /m
- /m/0
- /m/1
- /m/2
- /m/3
- /m/4
- /m/5
',
						   write => 'expand /**',
						  },
						  {
						   description => "Are the coordinates correct of the element 0?",
						   read => 'cached coordinate x = 0
cached coordinate y = 0
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/0',
						  },
						  {
						   description => "Are the coordinates correct of the element 1?",
						   read => 'cached coordinate x = 1
cached coordinate y = 0
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/1',
						  },
						  {
						   description => "Are the coordinates correct of the element 2?",
						   read => 'cached coordinate x = 0
cached coordinate y = 1
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/2',
						  },
						  {
						   description => "Are the coordinates correct of the element 3?",
						   read => 'cached coordinate x = 1
cached coordinate y = 1
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/3',
						  },
						  {
						   description => "Are the coordinates correct of the element 4?",
						   read => 'cached coordinate x = 0
cached coordinate y = 2
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/4',
						  },
						  {
						   description => "Are the coordinates correct of the element 5?",
						   read => 'cached coordinate x = 1
cached coordinate y = 2
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/5',
						  },
						 ],
				description => "simple test of the createmap command",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/createmap4.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => 'Is application startup successful?',
						   read => 'genesis #0 > ',
						  },
						  {
						   description => "Can we enter the querymachine?",
						   read => ' neurospaces > ',
						   write => 'call /model_container NEUROSPACES_QUERY',
						  },
						  {
						   description => "Can we find the elements created by the createmap command?",
						   read => '
- /proto
- /output
- /hardcoded_neutral
- /hardcoded_neutral/c
- /m
- /m/0
- /m/1
- /m/2
- /m/3
- /m/4
- /m/5
',
						   write => 'expand /**',
						  },
						  {
						   description => "Are the coordinates correct of the element 0?",
						   read => 'cached coordinate x = 0
cached coordinate y = 0
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/0',
						  },
						  {
						   description => "Are the coordinates correct of the element 1?",
						   read => 'cached coordinate x = 1
cached coordinate y = 0
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/1',
						  },
						  {
						   description => "Are the coordinates correct of the element 2?",
						   read => 'cached coordinate x = 0
cached coordinate y = 1
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/2',
						  },
						  {
						   description => "Are the coordinates correct of the element 3?",
						   read => 'cached coordinate x = 1
cached coordinate y = 1
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/3',
						  },
						  {
						   description => "Are the coordinates correct of the element 4?",
						   read => 'cached coordinate x = 0
cached coordinate y = 2
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/4',
						  },
						  {
						   description => "Are the coordinates correct of the element 5?",
						   read => 'cached coordinate x = 1
cached coordinate y = 2
cached coordinate z = 0
',
						   write => 'printcoordinates c / /m/5',
						  },
						 ],
				description => "simple test of the createmap command",
			       },
			      ],
       description => "createmap command tests",
       name => 'tools/createmap.t',
      };


return $test;


