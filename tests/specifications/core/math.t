#!/usr/bin/perl -w
#

use strict;


my $previous_library;



my $test
    = {
       command_definitions => [
			       {
				#t a bug in data_comparator() forces a single empty argument

				arguments => [
					      "",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  


	       

						  {
						   description => "Does absolute value work correctly?",
						   read => '22',
						   write => 'echo { abs -22 }',
						  },


						  {
						   description => "Does arc cosine work correctly?",
						   read => '45.0086',
						   write => 'echo {{ acos 0.707} * (360 / (2 * 3.1415926))}',
						  },



						  {
						   description => "Can we compute the arc cosine of 1?",
						   read => '0',
						   write => 'echo { acos 1 }',
						  },



						  {
						   description => "Can we compute the cosine of pi/4?",
						   read => '0.707107',
						   write => 'echo {cos {3.14159/4}}',
						  },



						  {
						   description => "Can we compute the arc sin of 0.5?",
						   read => '0.5235987902',
						   write => 'echo {asin 0.5}',
						  },

						  {
						   description => "Can we convert 0.5 to degrees?",
						   read => '30.00000135',
						   write => 'echo {{ asin 0.5 }*(180/3.1415926)}',
						  },


						  {
						   description => "Can we compute the tangent of pi/4?",
						   read => '0.9999987',
						   write => 'echo {tan {3.14159/4}}',
						  },

						  {
						   description => "Can we compute the arc tangent of 0.876?",
						   read => '0.719396',
						   write => 'echo { atan 0.876 }',
						  },

						  {
						   description => "Can we compute the log of 1?",
						   read => '0',
						   write => 'echo { log 1 }',
						  },

						  {
						   description => "Can we compute the log of e?",
						   read => '0',
						   write => 'echo {log {exp 1}}',
						  },

						  {
						   description => "Can we compute the log of 0?",
						   disabled => 'Seems to give the same error in genesis 2.3, returns the word infinity with a dash in front of it, th dash is mistaken for a comand line option.',
						   read => 'Ininity',
						   write => 'echo {log 0}',
						  },


						  {
						   description => "Can we get the max of two numbers?",
						   read => '2',
						   write => 'echo {max 1 2}',
						  },


						  {
						   description => "Can we get the max of tan 0.1 and 0.1?",
						   read => '0.1003346741',
						   write => 'echo {max {tan 0.1} 0.1}',
						  },

						  {
						   description => "Can we get the min of two numbers?",
						   read => '1',
						   write => 'echo {min 1 2}',
						  },


						  {
						   description => "Can we get the min of two numbers that are the same (33.33)?",
						   read => '33',
						   write => 'echo {min 33.33 33.33}',
						  },


						  {
						   description => "Can we get sqrt of 2?",
						   read => '1.414213',
						   write => 'echo {sqrt 2}',
						  },

						  {
						   description => "Can we get sqrt of 1?",
						   read => '1',
						   write => 'echo {sqrt 1}',
						  },

						  {
						   description => "Can we round down 3.33?",
						   read => '3',
						   write => 'echo {round 3.33}',
						  },

						  {
						   description => "Can we round down 3.66?",
						   read => '4',
						   write => 'echo {round 3.66}',
						  },


						  {
						   description => "Can we exponentiate e to the 1st power?",
						   read => '2.718281746',
						   write => 'echo {exp 1}',
						  },


						  {
						   description => "Can we raise 10 to the 3rd power?",
						   read => '1000',
						   write => 'echo {pow 10 3}',
						  },



						  {
						   description => "Can we return a value from a gaussian distribution (0-1)?",
						   disabled => 'Returns a random value so can\'t test.',
						   read => '0.5069125295',
						   write => 'echo {gaussian 0 1 }',
						  },



						  {
						   description => "Can we truncate a number?",
						   read => '5',
						   write => 'echo { trunc 5.999 }',
						  },

						 ],
				description => "Do the GENESIS 2 math functions work correctly?",

				numerical_compare => 'small arithmetic due to double to float conversions and vice versa',


			       },
			      ],
       description => "create a compartment, set its fields and then copy it ",
       name => 'core/math.t',
      };


return $test;


