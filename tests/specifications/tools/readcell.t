#!/usr/bin/perl -w
#

use strict;

# slurp mode

local $/;


my $test
    = {
       command_definitions => [


			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/readcell/readcell_simple.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Can we enter the querymachine ?",
						   wait => 1,
						   write => 'call model_container NEUROSPACES_QUERY',
						  },
						  {
						   description => "Are the soma coordinates correct ?",
						   read => 'cached coordinate x = 0
cached coordinate y = 0
cached coordinate z = 2.8e-05
',
						   write => 'printcoordinates c / /test/soma',
						  },
						  {
						   description => 'Is the soma DIA diameter correct ?',
						   read => "value = 1.9e-05
",
						   write => "printparameter /test/soma DIA",
						  },
						  {
						   description => 'Is the soma LENGTH correct ?',
						   read => "value = 2.8e-05
",
						   write => 'printparameter /test/soma LENGTH',
						  },
						  {
						   description => "Are the primary_dend coordinates correct ?",
						   read => 'cached coordinate x = 0
cached coordinate y = 0
cached coordinate z = 0.00066
',
						   write => 'printcoordinates c / /test/primary_dend',
						  },
						  {
						   description => "Are the glom1 coordinates correct ?",
						   read => 'cached coordinate x = 4e-05
cached coordinate y = 4e-05
cached coordinate z = 0.00072
',
						   write => 'printcoordinates c / /test/glom1',
						  },
						  {
						   description => "Are the glom2 coordinates correct ?",
						   read => 'cached coordinate x = -4e-05
cached coordinate y = 4e-05
cached coordinate z = 0.00072
',
						   write => 'printcoordinates c / /test/glom2',
						  },
						  {
						   description => "Are the glom3 coordinates correct ?",
						   read => 'cached coordinate x = -4e-05
cached coordinate y = -4e-05
cached coordinate z = 0.00072
',
						   write => 'printcoordinates c / /test/glom3',
						  },
						  {
						   description => "Are the glom4 coordinates correct ?",
						   read => 'cached coordinate x = 4e-05
cached coordinate y = -4e-05
cached coordinate z = 0.00072
',
						   write => 'printcoordinates c / /test/glom4',
						  },
						  {
						   description => "Are the second_dend1 coordinates correct ?",
						   read => 'cached coordinate x = 0
cached coordinate y = 0.0002
cached coordinate z = 6.8e-05
',
						   write => 'printcoordinates c / /test/second_dend1',
						  },
						  {
						   description => "Are the second_dend11 coordinates correct ?",
						   read => 'cached coordinate x = 0.0002
cached coordinate y = 0.0008
cached coordinate z = 0.000128
',
						   write => 'printcoordinates c / /test/second_dend11',
						  },
						  {
						   description => "Are the second_dend12 coordinates correct ?",
						   read => 'cached coordinate x = -0.0002
cached coordinate y = 0.0008
cached coordinate z = 0.000128
',
						   write => 'printcoordinates c / /test/second_dend12',
						  },
						  {
						   description => "Are the second_dend2 coordinates correct ?",
						   read => 'cached coordinate x = 0
cached coordinate y = -0.0002
cached coordinate z = 6.8e-05
',
						   write => 'printcoordinates c / /test/second_dend2',
						  },
						  {
						   description => "Are the second_dend21 coordinates correct ?",
						   read => 'cached coordinate x = 0.0002
cached coordinate y = -0.0008
cached coordinate z = 0.000128
',
						   write => 'printcoordinates c / /test/second_dend21',
						  },
						  {
						   description => "Are the second_dend22 coordinates correct ?",
						   read => 'cached coordinate x = -0.0002
cached coordinate y = -0.0008
cached coordinate z = 0.000128
',
						   write => 'printcoordinates c / /test/second_dend22',
						  },
						  {
						   description => "Are the second_dend3 coordinates correct ?",
						   read => 'cached coordinate x = 0.0002
cached coordinate y = 0
cached coordinate z = 6.8e-05
',
						   write => 'printcoordinates c / /test/second_dend3',
						  },
						  {
						   description => "Are the second_dend31 coordinates correct ?",
						   read => 'cached coordinate x = 0.0008
cached coordinate y = 0.0002
cached coordinate z = 0.000128
',
						   write => 'printcoordinates c / /test/second_dend31',
						  },
						  {
						   description => "Are the second_dend32 coordinates correct ?",
						   read => 'cached coordinate x = 0.0008
cached coordinate y = -0.0002
cached coordinate z = 0.000128
',
						   write => 'printcoordinates c / /test/second_dend32',
						  },
						  {
						   description => "Are the second_dend4 coordinates correct ?",
						   read => 'cached coordinate x = -0.0002
cached coordinate y = 0
cached coordinate z = 6.8e-05
',
						   write => 'printcoordinates c / /test/second_dend4',
						  },
						  {
						   description => "Are the second_dend41 coordinates correct ?",
						   read => 'cached coordinate x = -0.0008
cached coordinate y = 0.0002
cached coordinate z = 0.000128
',
						   write => 'printcoordinates c / /test/second_dend41',
						  },
						  {
						   description => "Are the second_dend42 coordinates correct ?",
						   read => 'cached coordinate x = -0.0008
cached coordinate y = -0.0002
cached coordinate z = 0.000128
',
						   write => 'printcoordinates c / /test/second_dend42',
						  },




						 ],
				description => "readcell coordinates",
			       },

			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/readcell/readcell_simple.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Is the soma CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/soma CM",
						  },
						  {
						   description => "Is the soma CM correct ?",
						   read => "scaled value = 1.67133e-11
",
						   write => "printparameterscaled /test/soma CM",
						  },
						  {
						   description => "Is the soma RM correct ?",
						   read => "value = 4
",
						   write => "printparameter /test/soma RM",
						  },
						  {
						   description => "Is the soma RM correct ?",
						   read => "scaled value = 2.39331e+09
",
						   write => "printparameterscaled /test/soma RM",
						  },
						  {
						   description => "Is the soma RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/soma RA",
						  },
						  {
						   description => "Is the soma RA correct ?",
						   read => "scaled value = 49377.7
",
						   write => "printparameterscaled /test/soma RA",
						  },
						  {
						   description => "Is the glom1 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/glom1 CM",
						  },
						  {
						   description => "Is the glom1 CM correct ?",
						   read => "scaled value = 2.59062e-12
",
						   write => "printparameterscaled /test/glom1 CM",
						  },
						  {
						   description => "Is the glom1 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/glom1 RM",
						  },
						  {
						   description => "Is the glom1 RM correct ?",
						   read => "scaled value = 7.72015e+09
",
						   write => "printparameterscaled /test/glom1 RM",
						  },
						  {
						   description => "Is the glom1 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/glom1 RA",
						  },
						  {
						   description => "Is the glom1 RA correct ?",
						   read => "scaled value = 5.2497e+07
",
						   write => "printparameterscaled /test/glom1 RA",
						  },
						  {
						   description => "Is the glom2 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/glom2 CM",
						  },
						  {
						   description => "Is the glom2 CM correct ?",
						   read => "scaled value = 2.59062e-12
",
						   write => "printparameterscaled /test/glom2 CM",
						  },
						  {
						   description => "Is the glom2 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/glom2 RM",
						  },
						  {
						   description => "Is the glom2 RM correct ?",
						   read => "scaled value = 7.72015e+09
",
						   write => "printparameterscaled /test/glom2 RM",
						  },
						  {
						   description => "Is the glom2 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/glom2 RA",
						  },
						  {
						   description => "Is the glom2 RA correct ?",
						   read => "scaled value = 5.2497e+07
",
						   write => "printparameterscaled /test/glom2 RA",
						  },
						  {
						   description => "Is the glom3 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/glom3 CM",
						  },
						  {
						   description => "Is the glom3 CM correct ?",
						   read => "scaled value = 2.59062e-12
",
						   write => "printparameterscaled /test/glom3 CM",
						  },
						  {
						   description => "Is the glom3 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/glom3 RM",
						  },
						  {
						   description => "Is the glom3 RM correct ?",
						   read => "scaled value = 7.72015e+09
",
						   write => "printparameterscaled /test/glom3 RM",
						  },
						  {
						   description => "Is the glom3 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/glom3 RA",
						  },
						  {
						   description => "Is the glom3 RA correct ?",
						   read => "scaled value = 5.2497e+07
",
						   write => "printparameterscaled /test/glom3 RA",
						  },
						  {
						   description => "Is the primary_dend CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/primary_dend CM",
						  },
						  {
						   description => "Is the primary_dend CM correct ?",
						   read => "scaled value = 1.38984e-10
",
						   write => "printparameterscaled /test/primary_dend CM",
						  },
						  {
						   description => "Is the primary_dend RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/primary_dend RM",
						  },
						  {
						   description => "Is the primary_dend RM correct ?",
						   read => "scaled value = 1.43901e+08
",
						   write => "printparameterscaled /test/primary_dend RM",
						  },
						  {
						   description => "Is the primary_dend RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/primary_dend RA",
						  },
						  {
						   description => "Is the primary_dend RA correct ?",
						   read => "scaled value = 8.2111e+06
",
						   write => "printparameterscaled /test/primary_dend RA",
						  },
						  {
						   description => "Is the second_dend1 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/second_dend1 CM",
						  },
						  {
						   description => "Is the second_dend1 CM correct ?",
						   read => "scaled value = 2.56305e-11
",
						   write => "printparameterscaled /test/second_dend1 CM",
						  },
						  {
						   description => "Is the second_dend1 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/second_dend1 RM",
						  },
						  {
						   description => "Is the second_dend1 RM correct ?",
						   read => "scaled value = 7.80321e+08
",
						   write => "printparameterscaled /test/second_dend1 RM",
						  },
						  {
						   description => "Is the second_dend1 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/second_dend1 RA",
						  },
						  {
						   description => "Is the second_dend1 RA correct ?",
						   read => "scaled value = 8.11534e+06
",
						   write => "printparameterscaled /test/second_dend1 RA",
						  },
						  {
						   description => "Is the second_dend11 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/second_dend11 CM",
						  },
						  {
						   description => "Is the second_dend11 CM correct ?",
						   read => "scaled value = 5.98752e-11
",
						   write => "printparameterscaled /test/second_dend11 CM",
						  },
						  {
						   description => "Is the second_dend11 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/second_dend11 RM",
						  },
						  {
						   description => "Is the second_dend11 RM correct ?",
						   read => "scaled value = 3.34028e+08
",
						   write => "printparameterscaled /test/second_dend11 RM",
						  },
						  {
						   description => "Is the second_dend11 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/second_dend11 RA",
						  },
						  {
						   description => "Is the second_dend11 RA correct ?",
						   read => "scaled value = 4.49379e+07
",
						   write => "printparameterscaled /test/second_dend11 RA",
						  },
						  {
						   description => "Is the second_dend12 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/second_dend12 CM",
						  },
						  {
						   description => "Is the second_dend12 CM correct ?",
						   read => "scaled value = 5.98752e-11
",
						   write => "printparameterscaled /test/second_dend12 CM",
						  },
						  {
						   description => "Is the second_dend12 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/second_dend12 RM",
						  },
						  {
						   description => "Is the second_dend12 RM correct ?",
						   read => "scaled value = 3.34028e+08
",
						   write => "printparameterscaled /test/second_dend12 RM",
						  },
						  {
						   description => "Is the second_dend12 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/second_dend12 RA",
						  },
						  {
						   description => "Is the second_dend12 RA correct ?",
						   read => "scaled value = 4.49379e+07
",
						   write => "printparameterscaled /test/second_dend12 RA",
						  },
						  {
						   description => "Is the second_dend2 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/second_dend2 CM",
						  },
						  {
						   description => "Is the second_dend2 CM correct ?",
						   read => "scaled value = 2.56305e-11
",
						   write => "printparameterscaled /test/second_dend2 CM",
						  },
						  {
						   description => "Is the second_dend2 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/second_dend2 RM",
						  },
						  {
						   description => "Is the second_dend2 RM correct ?",
						   read => "scaled value = 7.80321e+08
",
						   write => "printparameterscaled /test/second_dend2 RM",
						  },
						  {
						   description => "Is the second_dend2 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/second_dend2 RA",
						  },
						  {
						   description => "Is the second_dend2 RA correct ?",
						   read => "scaled value = 8.11534e+06
",
						   write => "printparameterscaled /test/second_dend2 RA",
						  },
						  {
						   description => "Is the second_dend3 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/second_dend3 CM",
						  },
						  {
						   description => "Is the second_dend3 CM correct ?",
						   read => "scaled value = 2.56305e-11
",
						   write => "printparameterscaled /test/second_dend3 CM",
						  },
						  {
						   description => "Is the second_dend3 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/second_dend3 RM",
						  },
						  {
						   description => "Is the second_dend3 RM correct ?",
						   read => "scaled value = 7.80321e+08
",
						   write => "printparameterscaled /test/second_dend3 RM",
						  },
						  {
						   description => "Is the second_dend3 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/second_dend3 RA",
						  },
						  {
						   description => "Is the second_dend3 RA correct ?",
						   read => "scaled value = 8.11534e+06
",
						   write => "printparameterscaled /test/second_dend3 RA",
						  },
						  {
						   description => "Is the second_dend31 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/second_dend31 CM",
						  },
						  {
						   description => "Is the second_dend31 CM correct ?",
						   read => "scaled value = 5.98752e-11
",
						   write => "printparameterscaled /test/second_dend31 CM",
						  },
						  {
						   description => "Is the second_dend31 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/second_dend31 RM",
						  },
						  {
						   description => "Is the second_dend31 RM correct ?",
						   read => "scaled value = 3.34028e+08
",
						   write => "printparameterscaled /test/second_dend31 RM",
						  },
						  {
						   description => "Is the second_dend31 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/second_dend31 RA",
						  },
						  {
						   description => "Is the second_dend31 RA correct ?",
						   read => "scaled value = 4.49379e+07
",
						   write => "printparameterscaled /test/second_dend31 RA",
						  },
						  {
						   description => "Is the second_dend32 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/second_dend32 CM",
						  },
						  {
						   description => "Is the second_dend32 CM correct ?",
						   read => "scaled value = 5.98752e-11
",
						   write => "printparameterscaled /test/second_dend32 CM",
						  },
						  {
						   description => "Is the second_dend32 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/second_dend32 RM",
						  },
						  {
						   description => "Is the second_dend32 RM correct ?",
						   read => "scaled value = 3.34028e+08
",
						   write => "printparameterscaled /test/second_dend32 RM",
						  },
						  {
						   description => "Is the second_dend32 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/second_dend32 RA",
						  },
						  {
						   description => "Is the second_dend32 RA correct ?",
						   read => "scaled value = 4.49379e+07
",
						   write => "printparameterscaled /test/second_dend32 RA",
						  },
						  {
						   description => "Is the second_dend4 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/second_dend4 CM",
						  },
						  {
						   description => "Is the second_dend4 CM correct ?",
						   read => "scaled value = 2.56305e-11
",
						   write => "printparameterscaled /test/second_dend4 CM",
						  },
						  {
						   description => "Is the second_dend4 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/second_dend4 RM",
						  },
						  {
						   description => "Is the second_dend4 RM correct ?",
						   read => "scaled value = 7.80321e+08
",
						   write => "printparameterscaled /test/second_dend4 RM",
						  },
						  {
						   description => "Is the second_dend4 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/second_dend4 RA",
						  },
						  {
						   description => "Is the second_dend4 RA correct ?",
						   read => "scaled value = 8.11534e+06
",
						   write => "printparameterscaled /test/second_dend4 RA",
						  },
						  {
						   description => "Is the second_dend41 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/second_dend41 CM",
						  },
						  {
						   description => "Is the second_dend41 CM correct ?",
						   read => "scaled value = 5.98752e-11
",
						   write => "printparameterscaled /test/second_dend41 CM",
						  },
						  {
						   description => "Is the second_dend41 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/second_dend41 RM",
						  },
						  {
						   description => "Is the second_dend41 RM correct ?",
						   read => "scaled value = 3.34028e+08
",
						   write => "printparameterscaled /test/second_dend41 RM",
						  },
						  {
						   description => "Is the second_dend41 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/second_dend41 RA",
						  },
						  {
						   description => "Is the second_dend41 RA correct ?",
						   read => "scaled value = 4.49379e+07
",
						   write => "printparameterscaled /test/second_dend41 RA",
						  },
						  {
						   description => "Is the second_dend42 CM correct ?",
						   read => "value = 0.01
",
						   write => "printparameter /test/second_dend42 CM",
						  },
						  {
						   description => "Is the second_dend42 CM correct ?",
						   read => "scaled value = 5.98752e-11
",
						   write => "printparameterscaled /test/second_dend42 CM",
						  },
						  {
						   description => "Is the second_dend42 RM correct ?",
						   read => "value = 2
",
						   write => "printparameter /test/second_dend42 RM",
						  },
						  {
						   description => "Is the second_dend42 RM correct ?",
						   read => "scaled value = 3.34028e+08
",
						   write => "printparameterscaled /test/second_dend42 RM",
						  },
						  {
						   description => "Is the second_dend42 RA correct ?",
						   read => "value = 0.5
",
						   write => "printparameter /test/second_dend42 RA",
						  },
						  {
						   description => "Is the second_dend42 RA correct ?",
						   read => "scaled value = 4.49379e+07
",
						   write => "printparameterscaled /test/second_dend42 RA",
						  },
						 ],
				description => "readcell parameters and parameter scaling",



			       },



			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/readcell/readcell_reset.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [


						  {
						   
						   description => 'Does the application report that it writes its output?',
						   read => 'output written',
						    timeout => 200,
						  },
						  {
						   description => "Can we perform a reset and step on a cell morphology loaded via readcell?",
						   read => {
							     
							    application_output_file => '/tmp/readcell_reset.txt',
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/readcell_reset.txt" },
						   timeout => 2,
						   write => undef,
						  },
						  ],
				description => "A test of the readfile function.",
			       },





			      ],
       description => "readcell parameters and coordinates",
       name => 'tools/readcell.t',
      };


return $test;


