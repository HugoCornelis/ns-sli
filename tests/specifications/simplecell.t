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
						   description => "Is the final somatic membrane potential correct ?",
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
						   description => "Is the final somatic membrane potential correct ?",
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
						   description => "Is the final somatic membrane potential correct ?",
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
						   description => "Is the final somatic membrane potential correct ?",
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
						   description => "Is the final somatic membrane potential correct ?",
						   read => 'Final Vm =  -0.07105',
						  },
						  {
						   description => "Can we save the model as an NDF file -- all ?",
						   wait => 1,
						   write => 'call model_container NEUROSPACES_COMMAND "export all ndf /tmp/all0.ndf /cell/**"',
						  },
						  {
						   description => "Can we save the model as an NDF file -- library ?",
						   wait => 1,
						   write => 'call model_container NEUROSPACES_COMMAND "export all ndf /tmp/all1.ndf /cell/**"',
						  },
						 ],
				comment => 'This test was derived from one of Dave Beeman\'s tutorial scripts',
				description => "preparing to run the converted model with SSP",
			       },
			       {
				arguments => [
					      '--cell',
					      '/tmp/all0.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we run the converted file from SSP -- all ?',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-ssp.txt",
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
					      '--cell',
					      '/tmp/all1.ndf',
					      '--model-name',
					      'cell',
					      '--output-fields',
					      "/cell/soma->Vm",
					     ],
				command => '/usr/local/bin/ssp',
				command_tests => [
						  {
						   description => 'Can we run the converted file from SSP -- library ?',
						   read => {
							    application_output_file => "$::config->{core_directory}/output/cell.out",
							    expected_output_file => "$::config->{core_directory}/tests/specifications/strings/simplecell1-ssp.txt",
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


