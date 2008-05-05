#!/usr/bin/perl -w
#

use strict;


my $previous_library;

my $printinfo_output = "Name, index (hardcoded_neutral,-1)
    Type (T_sym_cell)
    cell  Name, index (hardcoded_neutral,-1)
    cell  {-- begin HIER sections ---
        Name, index (c1,-1)
        Type (T_sym_segment)
        segmenName, index (c1,-1)
            PARA  Name (INJECT)
            PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                FUNC  Name (FIXED)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e-08)
            PARA  Name (RM)
            PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                FUNC  Name (FIXED)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.584410e+08)
            PARA  Name (RA)
            PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                FUNC  Name (FIXED)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.605020e+05)
            PARA  Name (Vm_init)
            PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                FUNC  Name (FIXED)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(-6.800000e-02)
            PARA  Name (ELEAK)
            PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                FUNC  Name (FIXED)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(-8.000000e-02)
            PARA  Name (CM)
            PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                FUNC  Name (FIXED)
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
            PARA  Name (RM)
            PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                FUNC  Name (FIXED)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(8.548598e+09)
            PARA  Name (RA)
            PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                FUNC  Name (FIXED)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(7.728134e+05)
            PARA  Name (CM)
            PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                FUNC  Name (FIXED)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(5.755329e-12)
        segmen{-- begin HIER sections ---
        segmen}--  end  HIER sections ---
            segmenName, index (c1,-1)
                PARA  Name (INJECT)
                PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                    FUNC  Name (FIXED)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e-08)
                PARA  Name (RM)
                PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                    FUNC  Name (FIXED)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(3.584410e+08)
                PARA  Name (RA)
                PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                    FUNC  Name (FIXED)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(3.605020e+05)
                PARA  Name (Vm_init)
                PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                    FUNC  Name (FIXED)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(-6.800000e-02)
                PARA  Name (ELEAK)
                PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                    FUNC  Name (FIXED)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(-8.000000e-02)
                PARA  Name (CM)
                PARA  Type (TYPE_PARA_FUNCTION), Value(FIXED)
                    FUNC  Name (FIXED)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(4.575370e-11)
            segmen{-- begin HIER sections ---
            segmen}--  end  HIER sections ---
    cell  }--  end  HIER sections ---";








my $test
    = {
       command_definitions => [
			       {
				arguments => [
					         "$::config->{core_directory}/tests/scripts/heccer/c1c2p2.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  {
						   description => "Can we add a message between compartments ?",
						   read => $printinfo_output,
						   write => 'printinfo /hardcoded_neutral',
						  },
						  

					


						 ],
				description => "script performs a reset on a compartment",


			       },
			      ],
       description => "create a neutral object with a compartment as a child, check if ",
       name => 'c1c2p2.t'
      };


return $test;


