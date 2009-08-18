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
            PARA  Name (ELEAK)
            PARA  Type (TYPE_PARA_NUMBER), Value(-8.000000e-02)
            PARA  Name (Vm_init)
            PARA  Type (TYPE_PARA_NUMBER), Value(-6.800000e-02)
            PARA  Name (DIA)
            PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
            PARA  Name (LENGTH)
            PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
            PARA  Name (RA)
            PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                FUNC  Name (GENESIS2)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.605020e+05)
            PARA  Name (RM)
            PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                FUNC  Name (GENESIS2)
                    PARA  Name (scale)
                    PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                    PARA  Name (value)
                    PARA  Type (TYPE_PARA_NUMBER), Value(3.584410e+08)
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
                PARA  Name (ELEAK)
                PARA  Type (TYPE_PARA_NUMBER), Value(-8.000000e-02)
                PARA  Name (Vm_init)
                PARA  Type (TYPE_PARA_NUMBER), Value(-6.800000e-02)
                PARA  Name (DIA)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                PARA  Name (LENGTH)
                PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                PARA  Name (RA)
                PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                    FUNC  Name (GENESIS2)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(3.605020e+05)
                PARA  Name (RM)
                PARA  Type (TYPE_PARA_FUNCTION), Value(GENESIS2)
                    FUNC  Name (GENESIS2)
                        PARA  Name (scale)
                        PARA  Type (TYPE_PARA_NUMBER), Value(1.000000e+00)
                        PARA  Name (value)
                        PARA  Type (TYPE_PARA_NUMBER), Value(3.584410e+08)
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
					         "$::config->{core_directory}/tests/scripts/heccer/double.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Can we add a message between compartments ?",
						   disabled => 'This test uses the printinfo querymachine command and requires to much developer work to maintain, because of the inferences made between different parameters such as compartment surface and maximal conductance and the way the model-container implements those inferences.',
						   read => $printinfo_output,
						   write => 'printinfo /hardcoded_neutral',
						  },
						  

					


						 ],
				description => "script performs a reset on a compartment",
				disabled => "This test does not perform a reset, not sure what it is supposed to do.",

			       },
			      ],
       description => "create a neutral object with a compartment as a child, check if ",
       disabled => "Check if what??  This test seems to be overlapping with other tests, so disabled.",
       name => 'heccer/double.t',
      };


return $test;


