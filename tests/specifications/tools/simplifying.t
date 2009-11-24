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
					      "$::config->{core_directory}/tests/scripts/reducing.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Can we enter the querymachine ?",
						   wait => 1,
						   write => 'call model_container NEUROSPACES_QUERY',
						  },
						  {
						   comment => 'It may be that the HH_AB_Mult parameter has a minus sign, even if its value is zero, this is due to the specific implementation details of NSSetupAlpha().',
						   description => 'What does the model look like ?',
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "hardcoded_neutral"
    SEGMENT "c"
      BINDINGS
        INPUT ka->I,
      END BINDINGS
      PARAMETERS
        PARAMETER ( LENGTH = 0 ),
        PARAMETER ( DIA = 2.98e-05 ),
        PARAMETER ( RM = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.58441e+08 ),
            ), ),
        PARAMETER ( RA = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 360502 ),
            ), ),
        PARAMETER ( Vm_init = -0.068 ),
        PARAMETER ( ELEAK = -0.08 ),
        PARAMETER ( CM = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 4.57537e-11 ),
            ), ),
      END PARAMETERS
      CHANNEL "ka"
        BINDABLES
          INPUT Vm,
          OUTPUT G,
          OUTPUT I,
        END BINDABLES
        BINDINGS
          INPUT ..->Vm,
        END BINDINGS
        PARAMETERS
          PARAMETER ( CHANNEL_TYPE = "ChannelActInact" ),
          PARAMETER ( G_MAX = 
            GENESIS2
              (
                  PARAMETER ( scale = 1 ),
                  PARAMETER ( value = 4.18479e-07 ),
              ), ),
          PARAMETER ( Erev = -0.085 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( HH_NUMBER_OF_TABLE_ENTRIES = 3.40282e+38 ),
            PARAMETER ( state_init = 0.0837136 ),
            PARAMETER ( POWER = 4 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          gate_kinetic "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.012 ),
              PARAMETER ( HH_AB_Offset_E = 0.027 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 1400 ),
            END PARAMETERS
          END gate_kinetic
          gate_kinetic "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.004 ),
              PARAMETER ( HH_AB_Offset_E = 0.03 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 490 ),
            END PARAMETERS
          END gate_kinetic
        END HH_GATE
        HH_GATE "HH_inactivation"
          PARAMETERS
            PARAMETER ( HH_NUMBER_OF_TABLE_ENTRIES = 3.40282e+38 ),
            PARAMETER ( state_init = 0.747485 ),
            PARAMETER ( POWER = 1 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          gate_kinetic "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.008 ),
              PARAMETER ( HH_AB_Offset_E = 0.05 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 17.5 ),
            END PARAMETERS
          END gate_kinetic
          gate_kinetic "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.013 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 1300 ),
            END PARAMETERS
          END gate_kinetic
        END HH_GATE
      END CHANNEL
    END SEGMENT
  END CELL
END PUBLIC_MODELS
',
						   write => 'export ndf STDOUT /hardcoded_neutral/**',
						  },
						  {
						   description => "Can we ask the model-container to reduce the model ?",
						   write => 'reduce',
						  },
						  {
						   comment => 'Note that for unknown reasons sometimes the HH_AB_Mult parameter has a minus sign, even if its value is zero',
						   description => "Have reducible items been removed ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  CELL "hardcoded_neutral"
    SEGMENT "c"
      BINDINGS
        INPUT ka->I,
      END BINDINGS
      PARAMETERS
        PARAMETER ( RA = 2.5 ),
        PARAMETER ( RM = 1 ),
        PARAMETER ( CM = 0.0164 ),
        PARAMETER ( DIA = 2.98e-05 ),
        PARAMETER ( Vm_init = -0.068 ),
        PARAMETER ( ELEAK = -0.08 ),
      END PARAMETERS
      CHANNEL "ka"
        BINDABLES
          INPUT Vm,
          OUTPUT G,
          OUTPUT I,
        END BINDABLES
        BINDINGS
          INPUT ..->Vm,
        END BINDINGS
        PARAMETERS
          PARAMETER ( G_MAX = 150 ),
          PARAMETER ( Erev = -0.085 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( state_init = 0.0837136 ),
            PARAMETER ( POWER = 4 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          gate_kinetic "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.012 ),
              PARAMETER ( HH_AB_Offset_E = 0.027 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 1400 ),
            END PARAMETERS
          END gate_kinetic
          gate_kinetic "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.004 ),
              PARAMETER ( HH_AB_Offset_E = 0.03 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 490 ),
            END PARAMETERS
          END gate_kinetic
        END HH_GATE
        HH_GATE "HH_inactivation"
          PARAMETERS
            PARAMETER ( state_init = 0.747485 ),
            PARAMETER ( POWER = 1 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          gate_kinetic "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.008 ),
              PARAMETER ( HH_AB_Offset_E = 0.05 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 17.5 ),
            END PARAMETERS
          END gate_kinetic
          gate_kinetic "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.013 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 1300 ),
            END PARAMETERS
          END gate_kinetic
        END HH_GATE
      END CHANNEL
    END SEGMENT
  END CELL
END PUBLIC_MODELS
',
						   write => 'export ndf STDOUT /hardcoded_neutral/**',
						  },
						 ],
				description => "simplifying model parameters of a small model",
			       },
			      ],
       description => "simplifying models using the model-container",
       name => 'tools/simplifying.t',
      };


return $test;


