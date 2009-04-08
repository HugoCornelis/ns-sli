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
				command => 'src/nsgenesis',
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
						   read => "value = 0
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
				description => "readcell coordinates.",
			       },
			      ],
				
       description => "readcell testing",



       name => 'readcell.t',
      };


return $test;


