#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "What is the initial working element?",
						   read => "
/
",
						   write => 'pwe',
						  },
						  {
						   description => "Can we create a neutral element?",
						   write => 'create neutral /foo',
						  },
						  {
						   description => "Can we create a compartment element?",
						   write => 'create compartment /foo/compartment',
						  },
						  {
						   description => "Can we create a tabchannel element?",
						   write => 'create tabchannel /foo/compartment/K',
						  },
						  {
						   description => "Can we change the current element to the tabchannel element?",
						   write => 'ce /foo/compartment',
						  },
						  {
						   description => "Can we print the current element to the screen (1)?",
						   read => '/foo/compartment
',
						   write => 'pwe',
						  },
						  {
						   description => "Can we change to the parent element?",
						   write => 'ce ..',
						  },
						  {
						   description => "Can we print the current element to the screen (2)?",
						   disabled => "this one does not work yet, working on it",
						   read => '/foo
',
						   write => 'pwe',
						  },
						 ],
				description => "interactive commands that change the current element, then prints it to the screen",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/basic-g/ce-test4.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Can change the working element, then print it to the screen?",
						   read => '/foo/compartment
',
						  },
						 ],
				description => "a simple script that changes the current element, then prints it to the screen",
			       },
			      ],
       description => "changing and obtaining the current working element",
       name => 'core/change_elements.t',
      };


return $test;


