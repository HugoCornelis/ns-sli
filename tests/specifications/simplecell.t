#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-simplecell/simplecell-0.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500005 ; step = 100001',
						  },
						  {
						   description => "Is the final somatic membrane potential correct (1)?",
						   read => 'Final Vm =  -0.07105',
						  },
						  {
						   description => "Can we convert the model to NDF (1) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
  END GROUP
  GROUP "cell"
    CHILD "compartment" "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( SURFACE = 2.82743e-09 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
    END CHILD
    CHILD "compartment" "dend"
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( SURFACE = 6.28319e-10 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
    END CHILD
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export no ndf STDOUT /**"',
						  },
						  {
						   description => "Can we reduce the model (1) ?",
						   write => 'call model_container NEUROSPACES_COMMAND "reduce"',
						  },
						  {
						   description => "Can we convert the reduced model to NDF (1) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
  END GROUP
  GROUP "cell"
    CHILD "compartment" "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
    END CHILD
    CHILD "compartment" "dend"
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
    END CHILD
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export no ndf STDOUT /**"',
						  },
						  {
						   description => "Can we convert the reduced model to NDF, all model components (1) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
  END GROUP
  GROUP "cell"
    SEGMENT "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
      CHANNEL "Na_hh_tchan"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = 0.045 ),
          PARAMETER ( G_MAX = 1200 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( POWER = 3 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.045 ),
              PARAMETER ( HH_AB_Add = -1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 100000 ),
              PARAMETER ( HH_AB_Scale = -4500 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.018 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 4000 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
        HH_GATE "HH_inactivation"
          PARAMETERS
            PARAMETER ( POWER = 1 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.02 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 70 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.04 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 1000 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
      END CHANNEL
      CHANNEL "K_hh_tchan"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = -0.082 ),
          PARAMETER ( G_MAX = 360 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( POWER = 4 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.06 ),
              PARAMETER ( HH_AB_Add = -1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 10000 ),
              PARAMETER ( HH_AB_Scale = -600 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.08 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 125 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
      END CHANNEL
    END SEGMENT
    SEGMENT "dend"
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
    END SEGMENT
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export all ndf STDOUT /**"',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts, version without hsolve, without synchans and spikegens",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-simplecell/simplecell-1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500005 ; step = 100001',
						  },
						  {
						   description => "Is the final somatic membrane potential correct (2)?",
						   read => 'Final Vm =  -0.07105',
						  },
						  {
						   description => "Can we convert the model to NDF (2) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "Ex_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.003 ),
        PARAMETER ( TAU1 = 0.003 ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU1 = ..->TAU1 ),
          PARAMETER ( TAU2 = ..->TAU2 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    CHANNEL "Inh_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.02 ),
        PARAMETER ( TAU1 = 0.02 ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU1 = ..->TAU1 ),
          PARAMETER ( TAU2 = ..->TAU2 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    ATTACHMENT "spike"
      PARAMETERS
        PARAMETER ( output_amp = "1" ),
        PARAMETER ( REFRACTORY = 0.01 ),
        PARAMETER ( THRESHOLD = 0 ),
      END PARAMETERS
    END ATTACHMENT
  END GROUP
  GROUP "cell"
    CHILD "compartment" "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( SURFACE = 2.82743e-09 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
    END CHILD
    CHILD "compartment" "dend"
      BINDINGS
        INPUT Ex_channel->Vm,
        INPUT Inh_channel->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( SURFACE = 6.28319e-10 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
    END CHILD
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export no ndf STDOUT /**"',
						  },
						  {
						   description => "Can we reduce the model (2) ?",
						   write => 'call model_container NEUROSPACES_COMMAND "reduce"',
						  },
						  {
						   description => "Can we convert the reduced model to NDF (2) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "Ex_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.003 ),
        PARAMETER ( TAU1 = 0.003 ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU1 = ..->TAU1 ),
          PARAMETER ( TAU2 = ..->TAU2 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    CHANNEL "Inh_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.02 ),
        PARAMETER ( TAU1 = 0.02 ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU1 = ..->TAU1 ),
          PARAMETER ( TAU2 = ..->TAU2 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    ATTACHMENT "spike"
      PARAMETERS
        PARAMETER ( output_amp = "1" ),
        PARAMETER ( REFRACTORY = 0.01 ),
        PARAMETER ( THRESHOLD = 0 ),
      END PARAMETERS
    END ATTACHMENT
  END GROUP
  GROUP "cell"
    CHILD "compartment" "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
    END CHILD
    CHILD "compartment" "dend"
      BINDINGS
        INPUT Ex_channel->Vm,
        INPUT Inh_channel->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
    END CHILD
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export no ndf STDOUT /**"',
						  },
						  {
						   description => "Can we convert the reduced model to NDF, all model components (2) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "Ex_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.003 ),
        PARAMETER ( TAU1 = 0.003 ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU2 = 0.003 ),
          PARAMETER ( TAU1 = 0.003 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    CHANNEL "Inh_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.02 ),
        PARAMETER ( TAU1 = 0.02 ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU2 = 0.02 ),
          PARAMETER ( TAU1 = 0.02 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    ATTACHMENT "spike"
      PARAMETERS
        PARAMETER ( output_amp = "1" ),
        PARAMETER ( REFRACTORY = 0.01 ),
        PARAMETER ( THRESHOLD = 0 ),
      END PARAMETERS
    END ATTACHMENT
  END GROUP
  GROUP "cell"
    SEGMENT "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
      CHANNEL "Na_hh_tchan"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = 0.045 ),
          PARAMETER ( G_MAX = 1200 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( POWER = 3 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.045 ),
              PARAMETER ( HH_AB_Add = -1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 100000 ),
              PARAMETER ( HH_AB_Scale = -4500 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.018 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 4000 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
        HH_GATE "HH_inactivation"
          PARAMETERS
            PARAMETER ( POWER = 1 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.02 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 70 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.04 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 1000 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
      END CHANNEL
      CHANNEL "K_hh_tchan"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = -0.082 ),
          PARAMETER ( G_MAX = 360 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( POWER = 4 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.06 ),
              PARAMETER ( HH_AB_Add = -1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 10000 ),
              PARAMETER ( HH_AB_Scale = -600 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.08 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 125 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
      END CHANNEL
      ATTACHMENT "spike"
        PARAMETERS
          PARAMETER ( THRESHOLD = 0 ),
          PARAMETER ( REFRACTORY = 0.01 ),
        END PARAMETERS
      END ATTACHMENT
    END SEGMENT
    SEGMENT "dend"
      BINDINGS
        INPUT Ex_channel->Vm,
        INPUT Inh_channel->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
      CHANNEL "Ex_channel"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = 0.045 ),
          PARAMETER ( G_MAX = 50 ),
        END PARAMETERS
        EQUATION_EXPONENTIAL "eq2"
          PARAMETERS
            PARAMETER ( TAU2 = 0.003 ),
            PARAMETER ( TAU1 = 0.003 ),
          END PARAMETERS
        END EQUATION_EXPONENTIAL
        ATTACHMENT "synapse"
        END ATTACHMENT
      END CHANNEL
      CHANNEL "Inh_channel"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = -0.082 ),
          PARAMETER ( G_MAX = 50 ),
        END PARAMETERS
        EQUATION_EXPONENTIAL "eq2"
          PARAMETERS
            PARAMETER ( TAU2 = 0.02 ),
            PARAMETER ( TAU1 = 0.02 ),
          END PARAMETERS
        END EQUATION_EXPONENTIAL
        ATTACHMENT "synapse"
        END ATTACHMENT
      END CHANNEL
    END SEGMENT
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export all ndf STDOUT /**"',
						  },
						  {
						   description => "Can we set the options for the DUMP command ?",
						   read => 'genesis',
						   write => 'setfield /neurospaces_integrator heccer_dump_selection { HECCER_DUMP_VM_COMPARTMENT_MATRIX + HECCER_DUMP_VM_COMPARTMENT_DATA + HECCER_DUMP_VM_COMPARTMENT_OPERATIONS + HECCER_DUMP_VM_CHANNEL_POOL_FLUXES + HECCER_DUMP_VM_MECHANISM_DATA + HECCER_DUMP_VM_MECHANISM_OPERATIONS + HECCER_DUMP_VM_SUMMARY }',
						  },
						  {
						   description => "Can we dump the model from heccer (1)?",
						   read => 'Heccer (pcName) : (/cell)
Heccer (iStatus) : (20)
Heccer (iErrorCount) : (0)
Heccer Options (iOptions) : (0)
Heccer Options (dIntervalStart) : (-0.1)
Heccer Options (dIntervalEnd) : (0.05)
Heccer Options (dConcentrationGateStart) : (4e-05)
Heccer Options (dConcentrationGateEnd) : (0.3)
Heccer Options (iIntervalEntries) : (3000)
Heccer Options (iSmallTableSize) : (149)
Heccer (dTime) : (0.500005)
Heccer (dStep) : (5e-06)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Tables (iTabulatedGateCount) : (3)
Compartment operations
-----
00000 :: FORWARD_ELIMINATION    0
00001 :: FINISH
00002 :: BACKWARD_SUBSTITUTION    2
00003 :: FINISH_ROW
00004 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -1.31948e-10 0 397887 1.04242
00001 :: INITIALIZECHANNEL 0.045 4.53047e-07
00002 :: SPRINGMASS -1 (nil) -1 0 0							 -1 0 0
00003 :: UPDATECOMPARTMENTCURRENT
00004 :: INITIALIZECHANNEL -0.082 3.39786e-08
00005 :: SPRINGMASS -1 (nil) -1 1 0							 -1 0 0
00006 :: UPDATECOMPARTMENTCURRENT
00007 :: COMPARTMENT							 -5.03854e-10 5e-10 88419.4 1.01001
00008 :: INITIALIZECHANNEL 0.045 3.39292e-06
00009 :: LOADVOLTAGETABLE
00010 :: CONCEPTGATE 0 3 (nil)							 0.0436651
00011 :: CONCEPTGATE 1 1 (nil)							 0.356333
00012 :: UPDATECOMPARTMENTCURRENT
00013 :: INITIALIZECHANNEL -0.082 1.01788e-06
00014 :: CONCEPTGATE 2 4 (nil)							 0.466239
00015 :: UPDATECOMPARTMENTCURRENT
00016 :: EVENTGENERATE (dVm) 0 0.01 0							 0.003515 0
00017 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.04242)
VM Diagonals (pdDiagonals[1]) : (1.01001)
VM Axial Resistances (pdAxres[0]) : (-0.00925926)
VM Axial Resistances (pdAxres[1]) : (-0.0416667)
VM Axial Resistances (pdAxres[2]) : (-0.0416667)
VM Axial Resistances (pdResults[0]) : (-0.0711828)
VM Axial Resistances (pdResults[1]) : (1.04242)
VM Axial Resistances (pdResults[2]) : (-0.0710563)
VM Axial Resistances (pdResults[3]) : (1.01427)
VM Membrane Potentials (pdVms[0]) : (-0.0711767)
VM Membrane Potentials (pdVms[1]) : (-0.07105)
',
						   write => 'call /neurospaces_integrator NSINTEGRATOR_DUMP',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts, version without hsolve, with synchans and spikegens",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-simplecell/simplecell-2.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500005 ; step = 100001',
						  },
						  {
						   description => "Is the final somatic membrane potential correct (3)?",
						   read => 'Final Vm =  -0.07105',
						  },
						  {
						   description => "Can we convert the model to NDF (3) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
  END GROUP
  GROUP "cell"
    CHILD "compartment" "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( SURFACE = 2.82743e-09 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
    END CHILD
    CHILD "compartment" "dend"
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( SURFACE = 6.28319e-10 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
    END CHILD
    CELL "h"
      PARAMETERS
        PARAMETER ( path = "../##[TYPE=compartment]" ),
      END PARAMETERS
    END CELL
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export no ndf STDOUT /**"',
						  },
						  {
						   description => "Can we reduce the model (3) ?",
						   write => 'call model_container NEUROSPACES_COMMAND "reduce"',
						  },
						  {
						   description => "Can we convert the reduced model to NDF (3) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
  END GROUP
  GROUP "cell"
    CHILD "compartment" "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
    END CHILD
    CHILD "compartment" "dend"
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
    END CHILD
    CELL "h"
      PARAMETERS
        PARAMETER ( path = "../##[TYPE=compartment]" ),
      END PARAMETERS
    END CELL
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export no ndf STDOUT /**"',
						  },
						  {
						   description => "Can we convert the reduced model to NDF, all model components (3) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
  END GROUP
  GROUP "cell"
    SEGMENT "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
      CHANNEL "Na_hh_tchan"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = 0.045 ),
          PARAMETER ( G_MAX = 1200 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( POWER = 3 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.045 ),
              PARAMETER ( HH_AB_Add = -1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 100000 ),
              PARAMETER ( HH_AB_Scale = -4500 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.018 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 4000 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
        HH_GATE "HH_inactivation"
          PARAMETERS
            PARAMETER ( POWER = 1 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.02 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 70 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.04 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 1000 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
      END CHANNEL
      CHANNEL "K_hh_tchan"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = -0.082 ),
          PARAMETER ( G_MAX = 360 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( POWER = 4 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.06 ),
              PARAMETER ( HH_AB_Add = -1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 10000 ),
              PARAMETER ( HH_AB_Scale = -600 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.08 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 125 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
      END CHANNEL
    END SEGMENT
    SEGMENT "dend"
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
    END SEGMENT
    CELL "h"
      PARAMETERS
        PARAMETER ( path = "../##[TYPE=compartment]" ),
      END PARAMETERS
    END CELL
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export all ndf STDOUT /**"',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts, version with hsolve, without synchans and spikegens",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-simplecell/simplecell-3.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500005 ; step = 100001',
						  },
						  {
						   description => "Is the final somatic membrane potential correct (4)?",
						   read => 'Final Vm =  -0.07105',
						  },
						  {
						   description => "Can we convert the model to NDF (4) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "Ex_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.003 ),
        PARAMETER ( TAU1 = 0.003 ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU1 = ..->TAU1 ),
          PARAMETER ( TAU2 = ..->TAU2 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    CHANNEL "Inh_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.02 ),
        PARAMETER ( TAU1 = 0.02 ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU1 = ..->TAU1 ),
          PARAMETER ( TAU2 = ..->TAU2 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    ATTACHMENT "spike"
      PARAMETERS
        PARAMETER ( output_amp = "1" ),
        PARAMETER ( REFRACTORY = 0.01 ),
        PARAMETER ( THRESHOLD = 0 ),
      END PARAMETERS
    END ATTACHMENT
  END GROUP
  GROUP "cell"
    CHILD "compartment" "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( SURFACE = 2.82743e-09 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
    END CHILD
    CHILD "compartment" "dend"
      BINDINGS
        INPUT Ex_channel->Vm,
        INPUT Inh_channel->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( SURFACE = 6.28319e-10 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
    END CHILD
    CELL "h"
      PARAMETERS
        PARAMETER ( path = "../##[TYPE=compartment]" ),
      END PARAMETERS
    END CELL
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export no ndf STDOUT /**"',
						  },
						  {
						   description => "Can we reduce the model (4) ?",
						   write => 'call model_container NEUROSPACES_COMMAND "reduce"',
						  },
						  {
						   description => "Can we convert the reduced model to NDF (4) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "Ex_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.003 ),
        PARAMETER ( TAU1 = 0.003 ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU1 = ..->TAU1 ),
          PARAMETER ( TAU2 = ..->TAU2 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    CHANNEL "Inh_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.02 ),
        PARAMETER ( TAU1 = 0.02 ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU1 = ..->TAU1 ),
          PARAMETER ( TAU2 = ..->TAU2 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    ATTACHMENT "spike"
      PARAMETERS
        PARAMETER ( output_amp = "1" ),
        PARAMETER ( REFRACTORY = 0.01 ),
        PARAMETER ( THRESHOLD = 0 ),
      END PARAMETERS
    END ATTACHMENT
  END GROUP
  GROUP "cell"
    CHILD "compartment" "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
    END CHILD
    CHILD "compartment" "dend"
      BINDINGS
        INPUT Ex_channel->Vm,
        INPUT Inh_channel->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
    END CHILD
    CELL "h"
      PARAMETERS
        PARAMETER ( path = "../##[TYPE=compartment]" ),
      END PARAMETERS
    END CELL
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export no ndf STDOUT /**"',
						  },
						  {
						   description => "Can we convert the reduced model to NDF, all model components (4) ?",
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

IMPORT
END IMPORT

PRIVATE_MODELS
END PRIVATE_MODELS

PUBLIC_MODELS
  GROUP "proto"
  END GROUP
  GROUP "output"
  END GROUP
  GROUP "library"
    SEGMENT "compartment"
      PARAMETERS
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.00999999 ),
        PARAMETER ( INJECT = 0 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( ELEAK = -0.07 ),
      END PARAMETERS
    END SEGMENT
    CHANNEL "Na_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 1.2e-06 ),
            ), ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 3 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.045 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 100000 ),
            PARAMETER ( HH_AB_Scale = -4500 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.018 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 4000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
      HH_GATE "HH_inactivation"
        PARAMETERS
          PARAMETER ( POWER = 1 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.02 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 70 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.04 ),
            PARAMETER ( HH_AB_Add = 1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 1000 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "K_hh_tchan"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 3.6e-07 ),
            ), ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      HH_GATE "HH_activation"
        PARAMETERS
          PARAMETER ( POWER = 4 ),
          PARAMETER ( state_init = -1 ),
        END PARAMETERS
        GATE_KINETIC "A"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = -0.01 ),
            PARAMETER ( HH_AB_Offset_E = 0.06 ),
            PARAMETER ( HH_AB_Add = -1 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = 10000 ),
            PARAMETER ( HH_AB_Scale = -600 ),
          END PARAMETERS
        END GATE_KINETIC
        GATE_KINETIC "B"
          PARAMETERS
            PARAMETER ( HH_AB_Tau = 0.08 ),
            PARAMETER ( HH_AB_Offset_E = 0.07 ),
            PARAMETER ( HH_AB_Add = 0 ),
            PARAMETER ( HH_AB_Factor_Flag = -1 ),
            PARAMETER ( HH_AB_Mult = -0 ),
            PARAMETER ( HH_AB_Scale = 125 ),
          END PARAMETERS
        END GATE_KINETIC
      END HH_GATE
    END CHANNEL
    CHANNEL "Ex_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.003 ),
        PARAMETER ( TAU1 = 0.003 ),
        PARAMETER ( Erev = 0.045 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU2 = 0.003 ),
          PARAMETER ( TAU1 = 0.003 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    CHANNEL "Inh_channel"
      BINDABLES
        INPUT Vm,
        OUTPUT G,
        OUTPUT I,
      END BINDABLES
      PARAMETERS
        PARAMETER ( G_MAX = 
          GENESIS2
            (
                PARAMETER ( scale = 1 ),
                PARAMETER ( value = 5e-08 ),
            ), ),
        PARAMETER ( TAU2 = 0.02 ),
        PARAMETER ( TAU1 = 0.02 ),
        PARAMETER ( Erev = -0.082 ),
      END PARAMETERS
      EQUATION_EXPONENTIAL "eq2"
        PARAMETERS
          PARAMETER ( TAU2 = 0.02 ),
          PARAMETER ( TAU1 = 0.02 ),
        END PARAMETERS
      END EQUATION_EXPONENTIAL
      ATTACHMENT "synapse"
      END ATTACHMENT
    END CHANNEL
    ATTACHMENT "spike"
      PARAMETERS
        PARAMETER ( output_amp = "1" ),
        PARAMETER ( REFRACTORY = 0.01 ),
        PARAMETER ( THRESHOLD = 0 ),
      END PARAMETERS
    END ATTACHMENT
  END GROUP
  GROUP "cell"
    SEGMENT "soma"
      BINDINGS
        INPUT Na_hh_tchan->Vm,
        INPUT K_hh_tchan->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( INJECT = 5e-10 ),
        PARAMETER ( ELEAK = -0.0594 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 3e-05 ),
        PARAMETER ( LENGTH = 3e-05 ),
        PARAMETER ( DIA = 3e-05 ),
        PARAMETER ( RA = 0.3 ),
      END PARAMETERS
      CHANNEL "Na_hh_tchan"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = 0.045 ),
          PARAMETER ( G_MAX = 1200 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( POWER = 3 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.045 ),
              PARAMETER ( HH_AB_Add = -1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 100000 ),
              PARAMETER ( HH_AB_Scale = -4500 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.018 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 4000 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
        HH_GATE "HH_inactivation"
          PARAMETERS
            PARAMETER ( POWER = 1 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.02 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 70 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.04 ),
              PARAMETER ( HH_AB_Add = 1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 1000 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
      END CHANNEL
      CHANNEL "K_hh_tchan"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = -0.082 ),
          PARAMETER ( G_MAX = 360 ),
        END PARAMETERS
        HH_GATE "HH_activation"
          PARAMETERS
            PARAMETER ( POWER = 4 ),
            PARAMETER ( state_init = -1 ),
          END PARAMETERS
          GATE_KINETIC "A"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = -0.01 ),
              PARAMETER ( HH_AB_Offset_E = 0.06 ),
              PARAMETER ( HH_AB_Add = -1 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = 10000 ),
              PARAMETER ( HH_AB_Scale = -600 ),
            END PARAMETERS
          END GATE_KINETIC
          GATE_KINETIC "B"
            PARAMETERS
              PARAMETER ( HH_AB_Tau = 0.08 ),
              PARAMETER ( HH_AB_Offset_E = 0.07 ),
              PARAMETER ( HH_AB_Add = 0 ),
              PARAMETER ( HH_AB_Factor_Flag = -1 ),
              PARAMETER ( HH_AB_Mult = -0 ),
              PARAMETER ( HH_AB_Scale = 125 ),
            END PARAMETERS
          END GATE_KINETIC
        END HH_GATE
      END CHANNEL
      ATTACHMENT "spike"
        PARAMETERS
          PARAMETER ( THRESHOLD = 0 ),
          PARAMETER ( REFRACTORY = 0.01 ),
        END PARAMETERS
      END ATTACHMENT
    END SEGMENT
    SEGMENT "dend"
      BINDINGS
        INPUT Ex_channel->Vm,
        INPUT Inh_channel->Vm,
      END BINDINGS
      PARAMETERS
        PARAMETER ( ELEAK = -0.07 ),
        PARAMETER ( Vm_init = -0.07 ),
        PARAMETER ( RM = 0.33333 ),
        PARAMETER ( CM = 0.01 ),
        PARAMETER ( rel_Z = 0 ),
        PARAMETER ( rel_Y = 0 ),
        PARAMETER ( rel_X = 0.0001 ),
        PARAMETER ( LENGTH = 0.0001 ),
        PARAMETER ( DIA = 2e-06 ),
        PARAMETER ( RA = 0.3 ),
        PARAMETER ( PARENT = ../soma ),
      END PARAMETERS
      CHANNEL "Ex_channel"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = 0.045 ),
          PARAMETER ( G_MAX = 50 ),
        END PARAMETERS
        EQUATION_EXPONENTIAL "eq2"
          PARAMETERS
            PARAMETER ( TAU2 = 0.003 ),
            PARAMETER ( TAU1 = 0.003 ),
          END PARAMETERS
        END EQUATION_EXPONENTIAL
        ATTACHMENT "synapse"
        END ATTACHMENT
      END CHANNEL
      CHANNEL "Inh_channel"
        BINDINGS
          INPUT ..->I,
        END BINDINGS
        PARAMETERS
          PARAMETER ( Erev = -0.082 ),
          PARAMETER ( G_MAX = 50 ),
        END PARAMETERS
        EQUATION_EXPONENTIAL "eq2"
          PARAMETERS
            PARAMETER ( TAU2 = 0.02 ),
            PARAMETER ( TAU1 = 0.02 ),
          END PARAMETERS
        END EQUATION_EXPONENTIAL
        ATTACHMENT "synapse"
        END ATTACHMENT
      END CHANNEL
    END SEGMENT
    CELL "h"
      PARAMETERS
        PARAMETER ( path = "../##[TYPE=compartment]" ),
      END PARAMETERS
    END CELL
  END GROUP
END PUBLIC_MODELS
',
						   write => 'call model_container NEUROSPACES_COMMAND "export all ndf STDOUT /**"',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "one of the simplest tutorial scripts, version with hsolve, with synchans and spikegens",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/test-simplecell/simplecell-1.g",
					     ],
				command => 'src/ns-sli',
				command_tests => [
						  {
						   description => "Does the script run a simulation ?",
						   read => 'time = 0.500005 ; step = 100001',
						  },
						  {
						   description => "Is the final somatic membrane potential correct (5)?",
						   read => 'Final Vm =  -0.07105',
						  },
						  {
						   description => "Can we wait for the genesis prompt ?",
						   read => 'genesis',
						  },
						  {
						   description => "Can we save the model as an NDF file -- all ?",
						   read => 'genesis',
						   write => 'call model_container NEUROSPACES_COMMAND "export all ndf /tmp/simplecell-all.ndf /cell/**"',
						  },
# 						  {
# 						   description => "Can we reduce the model ?",
# 						   read => 'genesis',
# 						   write => 'call model_container NEUROSPACES_COMMAND "reduce"',
# 						  },
						  {
						   description => "Can we save the model as an NDF file -- library ?",
						   read => 'genesis',
						   write => 'call model_container NEUROSPACES_COMMAND "export library ndf /tmp/simplecell-library.ndf /cell/**"',
						  },
						  {
						   description => "Can we set the options for the DUMP command ?",
						   read => 'genesis',
						   write => 'setfield /neurospaces_integrator heccer_dump_selection { HECCER_DUMP_VM_COMPARTMENT_MATRIX + HECCER_DUMP_VM_COMPARTMENT_DATA + HECCER_DUMP_VM_COMPARTMENT_OPERATIONS + HECCER_DUMP_VM_CHANNEL_POOL_FLUXES + HECCER_DUMP_VM_MECHANISM_DATA + HECCER_DUMP_VM_MECHANISM_OPERATIONS + HECCER_DUMP_VM_SUMMARY }',
						  },
						  {
						   description => "Can we compile the model ?",
						   read => 'genesis',
						   write => 'reset',
						  },
						  {
						   description => "Can we compile the model ?",
						   read => 'genesis',
						   write => 'set_nsintegrator_verbose_level 2',
						  },
						  {
						   description => "Can we dump the model from heccer (2)?",
						   read => 'Heccer (pcName) : (/cell)
Heccer (iStatus) : (20)
Heccer (iErrorCount) : (0)
Heccer Options (iOptions) : (0)
Heccer Options (dIntervalStart) : (-0.1)
Heccer Options (dIntervalEnd) : (0.05)
Heccer Options (dConcentrationGateStart) : (4e-05)
Heccer Options (dConcentrationGateEnd) : (0.3)
Heccer Options (iIntervalEntries) : (3000)
Heccer Options (iSmallTableSize) : (149)
Heccer (dTime) : (0)
Heccer (dStep) : (5e-06)
Compartment (mc.iType) : (1)
Compartment (mc.iType) : (1)
Tables (iTabulatedGateCount) : (3)
Compartment operations
-----
00000 :: FORWARD_ELIMINATION    0
00001 :: FINISH
00002 :: BACKWARD_SUBSTITUTION    2
00003 :: FINISH_ROW
00004 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -1.31948e-10 0 397887 1.04242
00001 :: INITIALIZECHANNEL 0.045 4.53047e-07
00002 :: SPRINGMASS -1 (nil) -1 0 0							 -1 0 0
00003 :: UPDATECOMPARTMENTCURRENT
00004 :: INITIALIZECHANNEL -0.082 3.39786e-08
00005 :: SPRINGMASS -1 (nil) -1 1 0							 -1 0 0
00006 :: UPDATECOMPARTMENTCURRENT
00007 :: COMPARTMENT							 -5.03854e-10 5e-10 88419.4 1.01001
00008 :: INITIALIZECHANNEL 0.045 3.39292e-06
00009 :: LOADVOLTAGETABLE
00010 :: CONCEPTGATE 0 3 (nil)							 0.0436651
00011 :: CONCEPTGATE 1 1 (nil)							 0.356333
00012 :: UPDATECOMPARTMENTCURRENT
00013 :: INITIALIZECHANNEL -0.082 1.01788e-06
00014 :: CONCEPTGATE 2 4 (nil)							 0.466239
00015 :: UPDATECOMPARTMENTCURRENT
00016 :: EVENTGENERATE (dVm) 0 0.01 0							 0.003515 0
00017 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.04242)
VM Diagonals (pdDiagonals[1]) : (1.01001)
VM Axial Resistances (pdAxres[0]) : (-0.00925926)
VM Axial Resistances (pdAxres[1]) : (-0.0416667)
VM Axial Resistances (pdAxres[2]) : (-0.0416667)
VM Axial Resistances (pdResults[0]) : (-0.0711828)
VM Axial Resistances (pdResults[1]) : (1.04242)
VM Axial Resistances (pdResults[2]) : (-0.0710563)
VM Axial Resistances (pdResults[3]) : (1.01427)
VM Membrane Potentials (pdVms[0]) : (-0.0711767)
VM Membrane Potentials (pdVms[1]) : (-0.07105)
',
						   write => 'call /neurospaces_integrator NSINTEGRATOR_DUMP',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "preparing to run the converted model with SSP",
			       },
			       {
				arguments => [
					      '/tmp/simplecell-library.ndf',
					     ],
				command => '/bin/cat',
				command_tests => [
						  {
						   description => 'What does the converted model look like -- library?',
						   read => '#!neurospacesparse
// -*- NEUROSPACES -*-

NEUROSPACES NDF

PRIVATE_MODELS
  GROUP "proto_3_3"
  END GROUP
  CHILD "proto_3_3" "proto_inserted_3"
  END CHILD
  GROUP "output_4_4"
  END GROUP
  CHILD "output_4_4" "output_inserted_4"
  END CHILD
  SEGMENT "compartment_6_6"
    PARAMETERS
      PARAMETER ( RA = 0.3 ),
      PARAMETER ( RM = 0.33333 ),
      PARAMETER ( CM = 0.00999999 ),
      PARAMETER ( INJECT = 0 ),
      PARAMETER ( LENGTH = 0.0001 ),
      PARAMETER ( DIA = 2e-06 ),
      PARAMETER ( ELEAK = -0.07 ),
    END PARAMETERS
  END SEGMENT
  CHILD "compartment_6_6" "compartment_inserted_6"
  END CHILD
  GATE_KINETIC "A_9_9"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = -0.01 ),
      PARAMETER ( HH_AB_Offset_E = 0.045 ),
      PARAMETER ( HH_AB_Add = -1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = 100000 ),
      PARAMETER ( HH_AB_Scale = -4500 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_9_9" "A_inserted_9"
  END CHILD
  GATE_KINETIC "B_10_10"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = 0.018 ),
      PARAMETER ( HH_AB_Offset_E = 0.07 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 4000 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_10_10" "B_inserted_10"
  END CHILD
  HH_GATE "HH_activation_8_8"
    PARAMETERS
      PARAMETER ( POWER = 3 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_9_9" "A"
    END CHILD
    CHILD "B_10_10" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_activation_8_8" "HH_activation_inserted_8"
  END CHILD
  GATE_KINETIC "A_12_12"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = 0.02 ),
      PARAMETER ( HH_AB_Offset_E = 0.07 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 70 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_12_12" "A_inserted_12"
  END CHILD
  GATE_KINETIC "B_13_13"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = -0.01 ),
      PARAMETER ( HH_AB_Offset_E = 0.04 ),
      PARAMETER ( HH_AB_Add = 1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 1000 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_13_13" "B_inserted_13"
  END CHILD
  HH_GATE "HH_inactivation_11_11"
    PARAMETERS
      PARAMETER ( POWER = 1 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_12_12" "A"
    END CHILD
    CHILD "B_13_13" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_inactivation_11_11" "HH_inactivation_inserted_11"
  END CHILD
  CHANNEL "Na_hh_tchan_7_7"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 1.2e-06 ),
          ), ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "HH_activation_8_8" "HH_activation"
    END CHILD
    CHILD "HH_inactivation_11_11" "HH_inactivation"
    END CHILD
  END CHANNEL
  CHILD "Na_hh_tchan_7_7" "Na_hh_tchan_inserted_7"
  END CHILD
  GATE_KINETIC "A_16_16"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = -0.01 ),
      PARAMETER ( HH_AB_Offset_E = 0.06 ),
      PARAMETER ( HH_AB_Add = -1 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = 10000 ),
      PARAMETER ( HH_AB_Scale = -600 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "A_16_16" "A_inserted_16"
  END CHILD
  GATE_KINETIC "B_17_17"
    PARAMETERS
      PARAMETER ( HH_AB_Tau = 0.08 ),
      PARAMETER ( HH_AB_Offset_E = 0.07 ),
      PARAMETER ( HH_AB_Add = 0 ),
      PARAMETER ( HH_AB_Factor_Flag = -1 ),
      PARAMETER ( HH_AB_Mult = -0 ),
      PARAMETER ( HH_AB_Scale = 125 ),
    END PARAMETERS
  END GATE_KINETIC
  CHILD "B_17_17" "B_inserted_17"
  END CHILD
  HH_GATE "HH_activation_15_15"
    PARAMETERS
      PARAMETER ( POWER = 4 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_16_16" "A"
    END CHILD
    CHILD "B_17_17" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_activation_15_15" "HH_activation_inserted_15"
  END CHILD
  CHANNEL "K_hh_tchan_14_14"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 3.6e-07 ),
          ), ),
      PARAMETER ( Erev = -0.082 ),
    END PARAMETERS
    CHILD "HH_activation_15_15" "HH_activation"
    END CHILD
  END CHANNEL
  CHILD "K_hh_tchan_14_14" "K_hh_tchan_inserted_14"
  END CHILD
  EQUATION_EXPONENTIAL "eq2_19_19"
    PARAMETERS
      PARAMETER ( TAU2 = 0.003 ),
      PARAMETER ( TAU1 = 0.003 ),
    END PARAMETERS
  END EQUATION_EXPONENTIAL
  CHILD "eq2_19_19" "eq2_inserted_19"
  END CHILD
  ATTACHMENT "synapse_20_20"
  END ATTACHMENT
  CHILD "synapse_20_20" "synapse_inserted_20"
  END CHILD
  CHANNEL "Ex_channel_18_18"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 5e-08 ),
          ), ),
      PARAMETER ( TAU2 = 0.003 ),
      PARAMETER ( TAU1 = 0.003 ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "eq2_19_19" "eq2"
    END CHILD
    CHILD "synapse_20_20" "synapse"
    END CHILD
  END CHANNEL
  CHILD "Ex_channel_18_18" "Ex_channel_inserted_18"
  END CHILD
  EQUATION_EXPONENTIAL "eq2_22_22"
    PARAMETERS
      PARAMETER ( TAU2 = 0.02 ),
      PARAMETER ( TAU1 = 0.02 ),
    END PARAMETERS
  END EQUATION_EXPONENTIAL
  CHILD "eq2_22_22" "eq2_inserted_22"
  END CHILD
  ATTACHMENT "synapse_23_23"
  END ATTACHMENT
  CHILD "synapse_23_23" "synapse_inserted_23"
  END CHILD
  CHANNEL "Inh_channel_21_21"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 5e-08 ),
          ), ),
      PARAMETER ( TAU2 = 0.02 ),
      PARAMETER ( TAU1 = 0.02 ),
      PARAMETER ( Erev = -0.082 ),
    END PARAMETERS
    CHILD "eq2_22_22" "eq2"
    END CHILD
    CHILD "synapse_23_23" "synapse"
    END CHILD
  END CHANNEL
  CHILD "Inh_channel_21_21" "Inh_channel_inserted_21"
  END CHILD
  ATTACHMENT "spike_24_24"
    PARAMETERS
      PARAMETER ( output_amp = "1" ),
      PARAMETER ( REFRACTORY = 0.01 ),
      PARAMETER ( THRESHOLD = 0 ),
    END PARAMETERS
  END ATTACHMENT
  CHILD "spike_24_24" "spike_inserted_24"
  END CHILD
  GROUP "library_5_5"
    CHILD "compartment_6_6" "compartment"
    END CHILD
    CHILD "Na_hh_tchan_7_7" "Na_hh_tchan"
    END CHILD
    CHILD "K_hh_tchan_14_14" "K_hh_tchan"
    END CHILD
    CHILD "Ex_channel_18_18" "Ex_channel"
    END CHILD
    CHILD "Inh_channel_21_21" "Inh_channel"
    END CHILD
    CHILD "spike_24_24" "spike"
    END CHILD
  END GROUP
  CHILD "library_5_5" "library_inserted_5"
  END CHILD
  HH_GATE "HH_activation_8_8"
    PARAMETERS
      PARAMETER ( POWER = 3 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_9_9" "A"
    END CHILD
    CHILD "B_10_10" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_activation_8_8" "HH_activation_inserted_8"
  END CHILD
  HH_GATE "HH_inactivation_11_11"
    PARAMETERS
      PARAMETER ( POWER = 1 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_12_12" "A"
    END CHILD
    CHILD "B_13_13" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_inactivation_11_11" "HH_inactivation_inserted_11"
  END CHILD
  CHANNEL "Na_hh_tchan_7_7"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 1.2e-06 ),
          ), ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "HH_activation_8_8" "HH_activation"
    END CHILD
    CHILD "HH_inactivation_11_11" "HH_inactivation"
    END CHILD
  END CHANNEL
  CHILD "Na_hh_tchan_7_7" "Na_hh_tchan_7_27"
    BINDINGS
      INPUT ..->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( Erev = 0.045 ),
      PARAMETER ( CHANNEL_TYPE = "ChannelActInact" ),
      PARAMETER ( G_MAX = 1200 ),
    END PARAMETERS
  END CHILD
  CHILD "Na_hh_tchan_7_27" "Na_hh_tchan_inserted_27"
  END CHILD
  HH_GATE "HH_activation_15_15"
    PARAMETERS
      PARAMETER ( POWER = 4 ),
      PARAMETER ( state_init = -1 ),
    END PARAMETERS
    CHILD "A_16_16" "A"
    END CHILD
    CHILD "B_17_17" "B"
    END CHILD
  END HH_GATE
  CHILD "HH_activation_15_15" "HH_activation_inserted_15"
  END CHILD
  CHANNEL "K_hh_tchan_14_14"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 3.6e-07 ),
          ), ),
      PARAMETER ( Erev = -0.082 ),
    END PARAMETERS
    CHILD "HH_activation_15_15" "HH_activation"
    END CHILD
  END CHANNEL
  CHILD "K_hh_tchan_14_14" "K_hh_tchan_14_28"
    BINDINGS
      INPUT ..->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( Erev = -0.082 ),
      PARAMETER ( CHANNEL_TYPE = "ChannelAct" ),
      PARAMETER ( G_MAX = 360 ),
    END PARAMETERS
  END CHILD
  CHILD "K_hh_tchan_14_28" "K_hh_tchan_inserted_28"
  END CHILD
  ATTACHMENT "spike_24_24"
    PARAMETERS
      PARAMETER ( output_amp = "1" ),
      PARAMETER ( REFRACTORY = 0.01 ),
      PARAMETER ( THRESHOLD = 0 ),
    END PARAMETERS
  END ATTACHMENT
  CHILD "spike_24_24" "spike_24_29"
    PARAMETERS
      PARAMETER ( THRESHOLD = 0 ),
      PARAMETER ( REFRACTORY = 0.01 ),
    END PARAMETERS
  END CHILD
  CHILD "spike_24_29" "spike_inserted_29"
  END CHILD
  SEGMENT "compartment_6_6"
    PARAMETERS
      PARAMETER ( RA = 0.3 ),
      PARAMETER ( RM = 0.33333 ),
      PARAMETER ( CM = 0.00999999 ),
      PARAMETER ( INJECT = 0 ),
      PARAMETER ( LENGTH = 0.0001 ),
      PARAMETER ( DIA = 2e-06 ),
      PARAMETER ( ELEAK = -0.07 ),
    END PARAMETERS
  END SEGMENT
  CHILD "compartment_6_6" "soma_6_26"
    BINDINGS
      INPUT Na_hh_tchan->Vm,
      INPUT K_hh_tchan->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( INJECT = 5e-10 ),
      PARAMETER ( ELEAK = -0.0594 ),
      PARAMETER ( Vm_init = -0.07 ),
      PARAMETER ( RM = 0.33333 ),
      PARAMETER ( CM = 0.01 ),
      PARAMETER ( SURFACE = 2.82743e-09 ),
      PARAMETER ( rel_Z = 0 ),
      PARAMETER ( rel_Y = 0 ),
      PARAMETER ( rel_X = 3e-05 ),
      PARAMETER ( LENGTH = 3e-05 ),
      PARAMETER ( DIA = 3e-05 ),
      PARAMETER ( RA = 0.3 ),
    END PARAMETERS
    CHILD "Na_hh_tchan_inserted_27" "Na_hh_tchan"
    END CHILD
    CHILD "K_hh_tchan_inserted_28" "K_hh_tchan"
    END CHILD
    CHILD "spike_inserted_29" "spike"
    END CHILD
  END CHILD
  CHILD "soma_6_26" "soma_inserted_26"
  END CHILD
  EQUATION_EXPONENTIAL "eq2_19_19"
    PARAMETERS
      PARAMETER ( TAU2 = 0.003 ),
      PARAMETER ( TAU1 = 0.003 ),
    END PARAMETERS
  END EQUATION_EXPONENTIAL
  CHILD "eq2_19_19" "eq2_inserted_19"
  END CHILD
  ATTACHMENT "synapse_20_20"
  END ATTACHMENT
  CHILD "synapse_20_20" "synapse_inserted_20"
  END CHILD
  CHANNEL "Ex_channel_18_18"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 5e-08 ),
          ), ),
      PARAMETER ( TAU2 = 0.003 ),
      PARAMETER ( TAU1 = 0.003 ),
      PARAMETER ( Erev = 0.045 ),
    END PARAMETERS
    CHILD "eq2_19_19" "eq2"
    END CHILD
    CHILD "synapse_20_20" "synapse"
    END CHILD
  END CHANNEL
  CHILD "Ex_channel_18_18" "Ex_channel_18_31"
    BINDINGS
      INPUT ..->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( Erev = 0.045 ),
      PARAMETER ( CHANNEL_TYPE = "ChannelSynchan" ),
      PARAMETER ( G_MAX = 50 ),
    END PARAMETERS
  END CHILD
  CHILD "Ex_channel_18_31" "Ex_channel_inserted_31"
  END CHILD
  EQUATION_EXPONENTIAL "eq2_22_22"
    PARAMETERS
      PARAMETER ( TAU2 = 0.02 ),
      PARAMETER ( TAU1 = 0.02 ),
    END PARAMETERS
  END EQUATION_EXPONENTIAL
  CHILD "eq2_22_22" "eq2_inserted_22"
  END CHILD
  ATTACHMENT "synapse_23_23"
  END ATTACHMENT
  CHILD "synapse_23_23" "synapse_inserted_23"
  END CHILD
  CHANNEL "Inh_channel_21_21"
    BINDABLES
      INPUT Vm,
      OUTPUT G,
      OUTPUT I,
    END BINDABLES
    PARAMETERS
      PARAMETER ( G_MAX = 
        GENESIS2
          (
              PARAMETER ( scale = 1 ),
              PARAMETER ( value = 5e-08 ),
          ), ),
      PARAMETER ( TAU2 = 0.02 ),
      PARAMETER ( TAU1 = 0.02 ),
      PARAMETER ( Erev = -0.082 ),
    END PARAMETERS
    CHILD "eq2_22_22" "eq2"
    END CHILD
    CHILD "synapse_23_23" "synapse"
    END CHILD
  END CHANNEL
  CHILD "Inh_channel_21_21" "Inh_channel_21_32"
    BINDINGS
      INPUT ..->I,
    END BINDINGS
    PARAMETERS
      PARAMETER ( Erev = -0.082 ),
      PARAMETER ( CHANNEL_TYPE = "ChannelSynchan" ),
      PARAMETER ( G_MAX = 50 ),
    END PARAMETERS
  END CHILD
  CHILD "Inh_channel_21_32" "Inh_channel_inserted_32"
  END CHILD
  SEGMENT "compartment_6_6"
    PARAMETERS
      PARAMETER ( RA = 0.3 ),
      PARAMETER ( RM = 0.33333 ),
      PARAMETER ( CM = 0.00999999 ),
      PARAMETER ( INJECT = 0 ),
      PARAMETER ( LENGTH = 0.0001 ),
      PARAMETER ( DIA = 2e-06 ),
      PARAMETER ( ELEAK = -0.07 ),
    END PARAMETERS
  END SEGMENT
  CHILD "compartment_6_6" "dend_6_30"
    BINDINGS
      INPUT Ex_channel->Vm,
      INPUT Inh_channel->Vm,
    END BINDINGS
    PARAMETERS
      PARAMETER ( ELEAK = -0.07 ),
      PARAMETER ( Vm_init = -0.07 ),
      PARAMETER ( RM = 0.33333 ),
      PARAMETER ( CM = 0.01 ),
      PARAMETER ( SURFACE = 6.28319e-10 ),
      PARAMETER ( rel_Z = 0 ),
      PARAMETER ( rel_Y = 0 ),
      PARAMETER ( rel_X = 0.0001 ),
      PARAMETER ( LENGTH = 0.0001 ),
      PARAMETER ( DIA = 2e-06 ),
      PARAMETER ( RA = 0.3 ),
      PARAMETER ( PARENT = ../soma ),
    END PARAMETERS
    CHILD "Ex_channel_inserted_31" "Ex_channel"
    END CHILD
    CHILD "Inh_channel_inserted_32" "Inh_channel"
    END CHILD
  END CHILD
  CHILD "dend_6_30" "dend_inserted_30"
  END CHILD
  GROUP "cell_25_25"
    FORWARDPARAMETERS
      PARAMETER ( NAME_0 = "/cell/dend/Inh_channel->G_MAX" ),
      PARAMETER ( VALUE_0 = 0.397888 ),
      PARAMETER ( NAME_1 = "/cell/dend/Ex_channel->G_MAX" ),
      PARAMETER ( VALUE_1 = 0.795775 ),
      PARAMETER ( NAME_2 = "/cell/soma/K_hh_tchan->G_MAX" ),
      PARAMETER ( VALUE_2 = 360 ),
      PARAMETER ( NAME_3 = "/cell/soma/Na_hh_tchan->G_MAX" ),
      PARAMETER ( VALUE_3 = 1200 ),
    END FORWARDPARAMETERS
    CHILD "soma_inserted_26" "soma"
    END CHILD
    CHILD "dend_inserted_30" "dend"
    END CHILD
  END GROUP
  CHILD "cell_25_25" "cell_inserted_25"
  END CHILD
END PRIVATE_MODELS
PUBLIC_MODELS
  CHILD "proto_3_3" "proto"
  END CHILD
  CHILD "output_4_4" "output"
  END CHILD
  CHILD "library_5_5" "library"
  END CHILD
  CHILD "cell_25_25" "cell"
  END CHILD
END PUBLIC_MODELS
',
						   wait => 3,
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "looking at the converted model -- library",
			       },
			       {
				arguments => [
# 					      '--time',
# 					      '0.5',
# 					      '--time-step',
# 					      '5e-6',
					      '--cell',
					      '/tmp/simplecell-all.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					      '--optimize',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we run the converted file from SSP -- all ?',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-ssp.txt",
# 							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-1-5e-10nA.txt",
							   },
						   wait => 3,
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "running the converted model with SSP to see if the conversion was done correctly",
				preparation => {
						description => "Create the output/ directory",
						preparer =>
						sub
						{
						    `mkdir output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the output/ directory",
					       reparer =>
					       sub
					       {
 						   `rm "$::config->{core_directory}/output/cell.out"`;
						   `rmdir output`;
					       },
					      },
			       },
			       {
				arguments => [
					      '--time-step',
					      '5e-6',
					      '--cell',
					      '/tmp/simplecell-library.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					      '--dump',
					      '--time',
					      '0',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we run the converted file from SSP -- library ?',
						   read => 'Heccer (pcName) : (unnamed test)
Heccer (iStatus) : (20)
Heccer (iErrorCount) : (0)
Heccer Options (iOptions) : (0)
Heccer Options (dIntervalStart) : (-0.1)
Heccer Options (dIntervalEnd) : (0.05)
Heccer Options (dConcentrationGateStart) : (4e-05)
Heccer Options (dConcentrationGateEnd) : (0.3)
Heccer Options (iIntervalEntries) : (3000)
Heccer Options (iSmallTableSize) : (149)
Heccer (dTime) : (0)
Heccer (dStep) : (5e-06)
Intermediary (iCompartments) : (2)
Compartment (mc.iType) : (1)
Compartment (iParent) : (-1)
Compartment (dCm) : (2.82743e-11)
Compartment (dEm) : (-0.0594)
Compartment (dInitVm) : (-0.07)
Compartment (dInject) : (5e-10)
Compartment (dRa) : (12732.4)
Compartment (dRm) : (1.17892e+08)
Compartment (mc.iType) : (1)
Compartment (iParent) : (0)
Compartment (dCm) : (6.28319e-12)
Compartment (dEm) : (-0.07)
Compartment (dInitVm) : (-0.07)
Compartment (dInject) : (0)
Compartment (dRa) : (9.5493e+06)
Compartment (dRm) : (5.30511e+08)
MinimumDegree (iEntries) : (2)
MinimumDegree (piChildren[0]) : (1)
MinimumDegree (piChildren[0][0]) : (1)
MinimumDegree (piChildren[1]) : (0)
MinimumDegree (piForward[0]) : (1)
MinimumDegree (piForward[1]) : (0)
MinimumDegree (piBackward[0]) : (1)
MinimumDegree (piBackward[1]) : (0)
Tables (iTabulatedGateCount) : (3)
Tabulated gate 0, interval (dStart) : (-0.1)
Tabulated gate 0, interval (dEnd) : (0.05)
Tabulated gate 0, interval (dStep) : (5e-05)
Tabulated gate 0, interpolation (iShape) : (0)
Tabulated gate 0, (iEntries) : (3000)
Tabulated gate 1, interval (dStart) : (-0.1)
Tabulated gate 1, interval (dEnd) : (0.05)
Tabulated gate 1, interval (dStep) : (5e-05)
Tabulated gate 1, interpolation (iShape) : (0)
Tabulated gate 1, (iEntries) : (3000)
Tabulated gate 2, interval (dStart) : (-0.1)
Tabulated gate 2, interval (dEnd) : (0.05)
Tabulated gate 2, interval (dStep) : (5e-05)
Tabulated gate 2, interpolation (iShape) : (0)
Tabulated gate 2, (iEntries) : (3000)
Compartment operations
-----
00000 :: FORWARD_ELIMINATION    0
00001 :: FINISH
00002 :: BACKWARD_SUBSTITUTION    2
00003 :: FINISH_ROW
00004 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -1.31948e-10 0 397887 1.04242
00001 :: INITIALIZECHANNEL 0.045 4.53047e-07
00002 :: SPRINGMASS -1 (nil) -1 0 0							 -1 0 0
00003 :: UPDATECOMPARTMENTCURRENT
00004 :: INITIALIZECHANNEL -0.082 3.39786e-08
00005 :: SPRINGMASS -1 (nil) -1 1 0							 -1 0 0
00006 :: UPDATECOMPARTMENTCURRENT
00007 :: COMPARTMENT							 -5.03853e-10 5e-10 88419.5 1.01001
00008 :: INITIALIZECHANNEL 0.045 3.39292e-06
00009 :: LOADVOLTAGETABLE
00010 :: CONCEPTGATE 0 3 (nil)							 0.0526213
00011 :: CONCEPTGATE 1 1 (nil)							 0.597868
00012 :: UPDATECOMPARTMENTCURRENT
00013 :: INITIALIZECHANNEL -0.082 1.01788e-06
00014 :: CONCEPTGATE 2 4 (nil)							 0.316911
00015 :: UPDATECOMPARTMENTCURRENT
00016 :: EVENTGENERATE (dVm) 0 0.01 0							 -1 0
00017 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.04242)
VM Diagonals (pdDiagonals[1]) : (1.01001)
VM Axial Resistances (pdAxres[0]) : (-0.00925927)
VM Axial Resistances (pdAxres[1]) : (-0.0416666)
VM Axial Resistances (pdAxres[2]) : (-0.0416666)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Axial Resistances (pdResults[2]) : (0)
VM Axial Resistances (pdResults[3]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.07)
VM Membrane Potentials (pdVms[1]) : (-0.07)
',
						   wait => 3,
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "compiling the converted model with SSP to see if the conversion was done correctly",
			       },
			       {
				arguments => [
# 					      '--time',
# 					      '0.5',
# 					      '--time-step',
# 					      '5e-6',
					      '--cell',
					      '/tmp/simplecell-library.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					      '--optimize',
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we run the converted file from SSP -- library ?',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-ssp.txt",
# 							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-1-5e-10nA.txt",
							   },
						   wait => 3,
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "running the converted model with SSP to see if the conversion was done correctly",
				preparation => {
						description => "Create the output/ directory",
						preparer =>
						sub
						{
						    `mkdir output`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the output/ directory",
					       reparer =>
					       sub
					       {
						   `rm "$::config->{core_directory}/output/cell.out"`;
						   `rmdir output`;
					       },
					      },
			       },
			      ],
       description => "one of the simplest tutorial scripts",
       name => 'simplecell.t',
      };


return $test;


