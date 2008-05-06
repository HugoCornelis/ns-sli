#!/usr/bin/perl -w
#

use strict;


# slurp mode

local $/;


#t
#t Need a test with one passive compartment that has self as parent.
#t This is supposed to fail, but it just gives wrong results instead
#t of failing.
#t
#t This came out as an annoyance during implementation of the swig perl glue.
#t

my $previous_library;

my $printinfo_output = "    Name, index (hardcoded_neutral,-1)
    Type (T_sym_cell)
    cell  Name, index (hardcoded_neutral,-1)
    cell  {-- begin HIER sections ---
        Name, index (c1,-1)
        Type (T_sym_segment)
        segmenName, index (c1,-1)
            PARA  Name (RM)
            PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                FUNC  Name (GENESIS2)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.584410e+08)
            PARA  Name (RA)
            PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                FUNC  Name (GENESIS2)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.605020e+05)
            PARA  Name (Vm_init)
            PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                FUNC  Name (GENESIS2)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(-6.800000e-02)
            PARA  Name (ELEAK)
            PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                FUNC  Name (GENESIS2)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(-8.000000e-02)
            PARA  Name (CM)
            PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                FUNC  Name (GENESIS2)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(4.575370e-11)
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
        Name, index (c2,-1)
        Type (T_sym_segment)
        segmenName, index (c2,-1)
            PARA  Name (PARENT)
            PARA  Type (TYPE_PARA_SYMBOLIC), Value : ../c1
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (c1,-1)
                PARA  Name (RM)
                PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                    FUNC  Name (GENESIS2)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(3.584410e+08)
                PARA  Name (RA)
                PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                    FUNC  Name (GENESIS2)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(3.605020e+05)
                PARA  Name (Vm_init)
                PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                    FUNC  Name (GENESIS2)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(-6.800000e-02)
                PARA  Name (ELEAK)
                PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                    FUNC  Name (GENESIS2)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(-8.000000e-02)
                PARA  Name (CM)
                PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                    FUNC  Name (GENESIS2)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(4.575370e-11)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
    cell  }--  end  HIER sections ---
";

my $test
    = {
       command_definitions => [


			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/passive/singlep.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Is a single passive compartment solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/singlep.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "single passive compartment.",
			       },






			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/passive/double.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are two passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/doublep.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						  {
						   description => "Are AXIAL and RAXIAL messages between compartments mapped correctly ?",
						   read => $printinfo_output,
						   write => 'printinfo /hardcoded_neutral',
						  },
						 ],
				description => "doublet passive compartment.",
			       },








			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/triple.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are three passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/triplep.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 18,
						   write => undef,
						  },

						 ],
				description => "triplet passive compartment.",
				
			       },






			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/fork3p.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Is a fork of three passive compartments solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork3p.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "fork of three passive compartments.",
			       },






			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/fork4p1.g",
					      ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, first alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p1.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, first alternative.",
				
			       },







			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/fork4p2.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, second alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p2.txt  | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, second alternative.",
			     
			       },





			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/fork4p3.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Is a fork of four passive compartments solved correctly, third alternative ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/fork4p3.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 8,
						   write => undef,
						  },
						 ],
				description => "fork of four passive compartments, third alternative.",
			
			       },







			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/c1c2p1.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are two passive compartments with injected current solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/c1c2p1.txt | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "two passive compartments with injected current",
		
				
			       },






			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/c1c2p2.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are two passive compartments with asymetric properties and injected current solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/c1c2p2.txt  | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 5,
						   write => undef,
						  },
						 ],
				description => "two passive compartments with asymetric properties and injected current",
				
			     disabled => 0,
			       },







			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/heccer/tensizesp.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Are ten passive compartments with different properties and injected current solved correctly ?",
						   read => (join '', `cat /usr/local/heccer/tests/specifications/strings/tensizesp.txt  | perl -pe 's/unnamed test/hardcoded_neutral/g'`),
						   timeout => 18,
						   write => undef,
						  },
						 ],
				description => "ten passive compartments with different properties and injected current",
			   
		       disabled => 0,



			       },


			      ],
				
       comment => 'See comments in the tester scripts for todos related to parameter caches in the model container',
       description => "passive model testing",



       name => 'passive.t',
      };


return $test;


