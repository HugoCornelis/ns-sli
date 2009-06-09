#!/usr/bin/perl -w
#

use strict;


my $test
    = {
       command_definitions => [
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/PurkM9_model/purkinje_simplifying.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  (
						   {
						    description => "Can the morphology be read ?",
						    read => 'tests/scripts/PurkM9_model/Purk2M9.p read: 1600 compartments',
						    timeout => 10,
						   },

						   (
						    {
						     description => "What is the capacitance of the soma ?",
						     read => 'value = 0.0164
',
						     write => "printparameter /Purkinje/soma CM",
						    },
						    {
						     description => "What is the capacitance of the first main segment ?",
						     read => 'value = 0.0164
',
						     write => "printparameter /Purkinje/main[0] CM",
						    },

						    {
						     description => "What is the membrane resistance of the soma ?",
						     read => 'value = 1
',
						     write => "printparameter /Purkinje/soma RM",
						    },
						    {
						     description => "What is the membrane resistance of the first main segment ?",
						     read => 'value = 3
',
						     write => "printparameter /Purkinje/main[0] RM",
						    },

						    {
						     description => "What is the axial resistance of the soma ?",
						     read => 'value = 2.5
',
						     write => "printparameter /Purkinje/soma RA",
						    },
						    {
						     description => "What is the axial resistance of the first main segment ?",
						     read => 'value = 2.5
',
						     write => "printparameter /Purkinje/main[0] RA",
						    },
						   ),

						   {
						    description => "What is the length of the first main segment ?",
						    read => '= 1.44697e-05',
						    write => "printparameter /Purkinje/main[0] LENGTH",
						   },
						   {
						    description => "What is the length of the second main segment ?",
						    read => '= 2.35003e-05',
						    write => "printparameter /Purkinje/main[1] LENGTH",
						   },
						   {
						    description => "What is the length of the first spiny dendrite ?",
						    read => '= 6.16021e-06',
						    write => "printparameter /Purkinje/b0s01[0] LENGTH",
						   },
						   {
						    description => "What is the length of the second spiny dendrite ?",
						    read => '= 2.22e-06',
						    write => "printparameter /Purkinje/b0s01[1] LENGTH",
						   },
						   {
						    description => "What is the length of one of the spinyd dendrites (the longest one) ?",
						    read => '= 3.09897e-05',
						    write => "printparameter /Purkinje/b3s37[17] LENGTH",
						   },
# 						  {
# 						   description => "What is the length of the first spine neck ?",
# 						   read => '= 6.6e-07',
# 						   write => "printparameter /Purkinje/b0s01[1]/Purkinje_spine_0/neck LENGTH",
# 						  },
# 						  {
# 						   description => "What is the length of the first spine head ?",
# 						   read => '= 6.8036e-07',
# 						   write => "printparameter /Purkinje/b0s01[1]/Purkinje_spine_0/head LENGTH",
# 						  },
						  {
						   description => "What is the somatopetal distance of the soma ?",
						   read => '= 0',
						   write => "printparameter /Purkinje/soma SOMATOPETAL_DISTANCE",
						  },
						   {
						    description => "What is the somatopetal distance of the first main segment ?",
						    read => '= 1.44697e-05',
						    write => "printparameter /Purkinje/main[0] SOMATOPETAL_DISTANCE",
						   },
						   {
						    description => "What is the somatopetal distance of the second main segment ?",
						    read => '= 3.797e-05',
						    write => "printparameter /Purkinje/main[1] SOMATOPETAL_DISTANCE",
						   },
						   {
						    description => "What is the somatopetal distance of a spiny dendrite ?",
						    read => '= 4.41302e-05',
						    write => "printparameter /Purkinje/b0s01[0] SOMATOPETAL_DISTANCE",
						   },
						   {
						    description => "What is the somatopetal distance of a spiny dendrite ?",
						    read => '= 4.63502e-05',
						    write => "printparameter /Purkinje/b0s01[1] SOMATOPETAL_DISTANCE",
						   },
# 						  {
# 						   description => "What is the somatopetal distance of the spine neck for the previous dendritic segment ?",
# 						   read => '= 4.70102e-05',
# 						   write => "printparameter /Purkinje/b0s01[1]/Purkinje_spine_0/neck SOMATOPETAL_DISTANCE",
# 						  },
# 						  {
# 						   description => "What is the somatopetal distance of the spine head for the previous dendritic segment ?",
# 						   read => '= 4.76906e-05',
# 						   write => "printparameter /Purkinje/b0s01[1]/Purkinje_spine_0/head SOMATOPETAL_DISTANCE",
# 						  },
						   {
						    comment => "the spines algorithm was not used, this values is without spines",
						    description => "What is the total surface of the purkinje cell ?",
						    read => 'value = 0.0120441
',
						    write => "printparameter /Purkinje TOTALLENGTH",
						   },
# 						  {
# 						   comment => "the spines algorithm was not used, this values is without spines",
# 						   description => "What is the total surface of all the segments the purkinje cell ?",
# 						   read => '= 0.0140198',
# 						   write => "printparameter /Purkinje/segments TOTALLENGTH",
# 						  },
						   {
						    comment => "even without spines, this value is very different from the value in table 2 of the Rapp paper, this is due to shrinkage correction, yet there is an unexplained anomaly in the difference for surface and volume.",
						    description => "What is the total surface of the purkinje cell ?",
						    # 						   disabled => "the value by the model container is value = 6.89649e-08, the difference may be due to the soma, to be sorted out",
						    numerical_compare => 'small arithmetic differences between G3 (reports 2.61206e-07) and G2 because GENESIS 2 use of float values',
						    read => 'value = 2.61092e-07',
						    write => "printparameter /Purkinje TOTALSURFACE",
						   },
# 						  {
# 						   comment => "See developer TODOs",
# 						   description => "What is the total surface of all the segments the purkinje cell ?",
# 						   disabled => "See developer TODOs",
# 						   read => '= 2.61206e-07',
# 						   write => "printparameter /Purkinje/segments TOTALSURFACE",
# 						  },
						   {
						    comment => "the spines algorithm was not used, this values is without spines (even without spines, this value is very different from the value in table 2 of the Rapp paper, this is due to shrinkage correction, yet there is an unexplained anomaly in the difference for surface and volume.)",
						    description => "What is the total volume of the purkinje cell ?",
						    read => 'value = 5.37774e-14',
						    write => "printparameter /Purkinje TOTALVOLUME",
						   },
# 						  {
# 						   comment => "See developer TODOs",
# 						   description => "What is the total volume of all the segments the purkinje cell ?",
# 						   disabled => "See developer TODOs",
# 						   read => '= 5.39527e-14',
# 						   write => "printparameter /Purkinje/segments TOTALVOLUME",
# 						  },
						   {
						    description => "Does the main dendrite of the purkinje cell have a well-defined calcium dependent potassium conductance ?",
						    numerical_compare => 'small arithmetic differences are common for unscaled values',
						    read => 'value = 799.999',
						    write => "printparameter /Purkinje/b0s01[1]/KC G_MAX",
						   },
						   {
						    description => "Is conductance scaling done correctly ?",
						    read => '1.27212e-08',
						    write => "printparameterscaled /Purkinje/b0s01[1]/KC G_MAX",
						   },
						   {
						    description => "Does the main dendrite of the purkinje cell have a well-defined calcium dependent potassium conductance (2) ?",
						    numerical_compare => 'small arithmetic differences are common for unscaled values',
						    read => 'value = -0.085',
						    write => "printparameter /Purkinje/b0s01[1]/KC Erev",
						   },
# 						  {
# 						   description => "Can we find spines in the model purkinje cell ?",
# 						   read => '/Purkinje/b0s01[1]/Purkinje_spine_0
# - /Purkinje/b0s01[1]/Purkinje_spine_0/neck
# - /Purkinje/b0s01[1]/Purkinje_spine_0/head
# - /Purkinje/b0s01[1]/Purkinje_spine_0/head/par
# - /Purkinje/b0s01[1]/Purkinje_spine_0/head/par/synapse
# - /Purkinje/b0s01[1]/Purkinje_spine_0/head/par/exp2
# ',
# 						   write => "expand /Purkinje/b0s01[1]/Purkinje_spine_0/**",
# 						  },
# 						  {
# 						   description => "What are the forestspace IDs for the spine neck ?",
# 						   read => 'Traversal serial ID = 1138
# Principal serial ID = 1138 of 25525 Principal successors
# ',
# # Mechanism serial ID = 656 of 12914 Mechanism successors
# # Segment  serial  ID = 73 of 4548  Segment  successors
# 						   write => "serialMapping /Purkinje Purkinje/b0s01[1]/Purkinje_spine_0/neck",
# 						  },
						   {
						    comment => 'note the differences when using G2 tabchans, G3 ns-sli and plain G3',
						    description => "What are the forestspace IDs for the segment b0s01[1] ?",
						    read => 'Traversal serial ID = 5551
Principal serial ID = 5551 of 132457 Principal successors
',
						    # Mechanism serial ID = 649 of 12914 Mechanism successors
						    # Segment  serial  ID = 72 of 4548  Segment  successors
						    write => "serialMapping /Purkinje Purkinje/b0s01[1]",
						   },
						   {
						    description => "Can we assign a solver to the purkinje cell ?",
						    read => undef,
						    write => "solverset /Purkinje purk_solver",
						   },
# 						  {
# 						   description => "Can the solver for the spine neck be found, is it the one we just assigned to it ?",
# 						   read => 'Solver = purk_solver, solver serial ID = 1138
# Solver serial context for 1138 = 
# 	/Purkinje/b0s01[1]/Purkinje_spine_0/neck
# ',
# 						   write => "resolvesolver /Purkinje/b0s01[1]/Purkinje_spine_0/neck",
# 						  },
						  ),

						  {
						   description => "Can we reduce the model ?",
						   wait => 20,
						   write => "reduce",
						  },
						  (
						   (
						    {
						     description => "After reducing, what is the capacitance of the soma ?",
						     read => 'value = 0.0164
',
						     write => "printparameter /Purkinje/soma CM",
						    },
						    {
						     description => "After reducing, what is the capacitance of the first main segment ?",
						     read => 'value = 0.0164
',
						     write => "printparameter /Purkinje/main[0] CM",
						    },

						    {
						     description => "After reducing, what is the membrane resistance of the soma ?",
						     read => 'value = 1
',
						     write => "printparameter /Purkinje/soma RM",
						    },
						    {
						     description => "After reducing, what is the membrane resistance of the first main segment ?",
						     read => 'value = 3
',
						     write => "printparameter /Purkinje/main[0] RM",
						    },

						    {
						     description => "After reducing, what is the axial resistance of the soma ?",
						     read => 'value = 2.5
',
						     write => "printparameter /Purkinje/soma RA",
						    },
						    {
						     description => "After reducing, what is the axial resistance of the first main segment ?",
						     read => 'value = 2.5
',
						     write => "printparameter /Purkinje/main[0] RA",
						    },
						   ),

						   (
						    {
						     description => "After reducing, what is the length of the first main segment ?",
						     read => '= 1.44697e-05',
						     write => "printparameter /Purkinje/main[0] LENGTH",
						    },
						    {
						     description => "After reducing, what is the length of the second main segment ?",
						     read => '= 2.35003e-05',
						     write => "printparameter /Purkinje/main[1] LENGTH",
						    },
						    {
						     description => "After reducing, what is the length of the first spiny dendrite ?",
						     read => '= 6.16021e-06',
						     write => "printparameter /Purkinje/b0s01[0] LENGTH",
						    },
						    {
						     description => "After reducing, what is the length of the second spiny dendrite ?",
						     read => '= 2.22e-06',
						     write => "printparameter /Purkinje/b0s01[1] LENGTH",
						    },
						    {
						     description => "After reducing, what is the length of one of the spinyd dendrites (the longest one) ?",
						     read => '= 3.09897e-05',
						     write => "printparameter /Purkinje/b3s37[17] LENGTH",
						    },
# 						  {
# 						   description => "After reducing, what is the length of the first spine neck ?",
# 						   read => '= 6.6e-07',
# 						   write => "printparameter /Purkinje/b0s01[1]/Purkinje_spine_0/neck LENGTH",
# 						  },
# 						  {
# 						   description => "After reducing, what is the length of the first spine head ?",
# 						   read => '= 6.8036e-07',
# 						   write => "printparameter /Purkinje/b0s01[1]/Purkinje_spine_0/head LENGTH",
# 						  },
						    {
						     description => "After reducing, what is the somatopetal distance of the soma ?",
						     read => '= 0',
						     write => "printparameter /Purkinje/soma SOMATOPETAL_DISTANCE",
						    },
						    {
						     description => "After reducing, what is the somatopetal distance of the first main segment ?",
						     read => '= 1.44697e-05',
						     write => "printparameter /Purkinje/main[0] SOMATOPETAL_DISTANCE",
						    },
						    {
						     description => "After reducing, what is the somatopetal distance of the second main segment ?",
						     read => '= 3.797e-05',
						     write => "printparameter /Purkinje/main[1] SOMATOPETAL_DISTANCE",
						    },
						    {
						     description => "After reducing, what is the somatopetal distance of a spiny dendrite ?",
						     read => '= 4.41302e-05',
						     write => "printparameter /Purkinje/b0s01[0] SOMATOPETAL_DISTANCE",
						    },
						    {
						     description => "After reducing, what is the somatopetal distance of a spiny dendrite ?",
						     read => '= 4.63502e-05',
						     write => "printparameter /Purkinje/b0s01[1] SOMATOPETAL_DISTANCE",
						    },
# 						  {
# 						   description => "After reducing, what is the somatopetal distance of the spine neck for the previous dendritic segment ?",
# 						   read => '= 4.70102e-05',
# 						   write => "printparameter /Purkinje/b0s01[1]/Purkinje_spine_0/neck SOMATOPETAL_DISTANCE",
# 						  },
# 						  {
# 						   description => "After reducing, what is the somatopetal distance of the spine head for the previous dendritic segment ?",
# 						   read => '= 4.76906e-05',
# 						   write => "printparameter /Purkinje/b0s01[1]/Purkinje_spine_0/head SOMATOPETAL_DISTANCE",
# 						  },
						    {
						     comment => "the spines algorithm was not used, this values is without spines",
						     description => "After reducing, what is the total surface of the purkinje cell ?",
						     read => 'value = 0.0120441
',
						     write => "printparameter /Purkinje TOTALLENGTH",
						    },
# 						  {
# 						   comment => "the spines algorithm was not used, this values is without spines",
# 						   description => "After reducing, what is the total surface of all the segments the purkinje cell ?",
# 						   read => '= 0.0140198',
# 						   write => "printparameter /Purkinje/segments TOTALLENGTH",
# 						  },
						    {
						     comment => "even without spines, this value is very different from the value in table 2 of the Rapp paper, this is due to shrinkage correction, yet there is an unexplained anomaly in the difference for surface and volume.",
						     description => "After reducing, what is the total surface of the purkinje cell ?",
# 						   disabled => "the value by the model container is value = 6.89649e-08, the difference may be due to the soma, to be sorted out",
						     numerical_compare => 'small arithmetic differences between G3 (reports 2.61206e-07) and G2 because GENESIS 2 use of float values',
						     read => 'value = 2.61092e-07',
						     write => "printparameter /Purkinje TOTALSURFACE",
						    },
# 						  {
# 						   comment => "See developer TODOs",
# 						   description => "After reducing, what is the total surface of all the segments the purkinje cell ?",
# 						   disabled => "See developer TODOs",
# 						   read => '= 2.61206e-07',
# 						   write => "printparameter /Purkinje/segments TOTALSURFACE",
# 						  },
						    {
						     comment => "the spines algorithm was not used, this values is without spines (even without spines, this value is very different from the value in table 2 of the Rapp paper, this is due to shrinkage correction, yet there is an unexplained anomaly in the difference for surface and volume.)",
						     description => "After reducing, what is the total volume of the purkinje cell ?",
						     read => 'value = 5.37774e-14',
						     write => "printparameter /Purkinje TOTALVOLUME",
						    },
# 						  {
# 						   comment => "See developer TODOs",
# 						   description => "After reducing, what is the total volume of all the segments the purkinje cell ?",
# 						   disabled => "See developer TODOs",
# 						   read => '= 5.39527e-14',
# 						   write => "printparameter /Purkinje/segments TOTALVOLUME",
# 						  },
						    {
						     description => "After reducing, does the main dendrite of the purkinje cell have a well-defined calcium dependent potassium conductance ?",
						     numerical_compare => 'small arithmetic differences are common for unscaled values',
						     read => 'value = 799.999',
						     write => "printparameter /Purkinje/b0s01[1]/KC G_MAX",
						    },
						    {
						     description => "After reducing, is conductance scaling done correctly ?",
						     read => '1.27212e-08',
						     write => "printparameterscaled /Purkinje/b0s01[1]/KC G_MAX",
						    },
						    {
						     description => "After reducing, does the main dendrite of the purkinje cell have a well-defined calcium dependent potassium conductance (2) ?",
						     numerical_compare => 'small arithmetic differences are common for unscaled values',
						     read => 'value = -0.085',
						     write => "printparameter /Purkinje/b0s01[1]/KC Erev",
						    },
# 						  {
# 						   description => "After reducing, can we find spines in the model purkinje cell ?",
# 						   read => '/Purkinje/b0s01[1]/Purkinje_spine_0
# - /Purkinje/b0s01[1]/Purkinje_spine_0/neck
# - /Purkinje/b0s01[1]/Purkinje_spine_0/head
# - /Purkinje/b0s01[1]/Purkinje_spine_0/head/par
# - /Purkinje/b0s01[1]/Purkinje_spine_0/head/par/synapse
# - /Purkinje/b0s01[1]/Purkinje_spine_0/head/par/exp2
# ',
# 						   write => "expand /Purkinje/b0s01[1]/Purkinje_spine_0/**",
# 						  },
# 						  {
# 						   description => "After reducing, what are the forestspace IDs for the spine neck ?",
# 						   read => 'Traversal serial ID = 1138
# Principal serial ID = 1138 of 25525 Principal successors
# ',
# # Mechanism serial ID = 656 of 12914 Mechanism successors
# # Segment  serial  ID = 73 of 4548  Segment  successors
# 						   write => "serialMapping /Purkinje Purkinje/b0s01[1]/Purkinje_spine_0/neck",
# 						  },
						    {
						     comment => 'note the differences when using G2 tabchans, G3 ns-sli and plain G3',
						     description => "After reducing, what are the forestspace IDs for the segment b0s01[1] ?",
						     read => 'Traversal serial ID = 5551
Principal serial ID = 5551 of 132457 Principal successors
',
						     # Mechanism serial ID = 649 of 12914 Mechanism successors
						     # Segment  serial  ID = 72 of 4548  Segment  successors
						     write => "serialMapping /Purkinje Purkinje/b0s01[1]",
						    },
						    {
						     description => "After reducing, can we assign a solver to the purkinje cell ?",
						     read => undef,
						     write => "solverset /Purkinje purk_solver",
						    },
# 						  {
# 						   description => "After reducing, can the solver for the spine neck be found, is it the one we just assigned to it ?",
# 						   read => 'Solver = purk_solver, solver serial ID = 1138
# Solver serial context for 1138 = 
# 	/Purkinje/b0s01[1]/Purkinje_spine_0/neck
# ',
# 						   write => "resolvesolver /Purkinje/b0s01[1]/Purkinje_spine_0/neck",
# 						  },
						   ),
						  ),
						 ],
				comment => 'This test was derived from the model-container purkinje.t',
				description => "simplification tests for the purkinje cell model with parameterized channels",
			       },
			       {
				arguments => [
					      "$::config->{core_directory}/tests/scripts/PurkM9_model/ACTIVE-soma1.g",
					     ],
				command => 'src/nsgenesis',
				command_tests => [
						  (
						   {
						    description => "Can the morphology be read ?",
						    read => 'tests/scripts/PurkM9_model/Purk2M9_soma.p read: 1 compartments',
						    timeout => 10,
						   },
						   {
						    description => "Are the prototype library and the cell correctly constructed ?",
						    read => '
- /proto
- /output
- /library
- /library/Purk_NaF
- /library/Purk_NaF/HH_activation
- /library/Purk_NaF/HH_activation/A
- /library/Purk_NaF/HH_activation/B
- /library/Purk_NaF/HH_inactivation
- /library/Purk_NaF/HH_inactivation/A
- /library/Purk_NaF/HH_inactivation/B
- /library/Purk_NaP
- /library/Purk_NaP/HH_activation
- /library/Purk_NaP/HH_activation/A
- /library/Purk_NaP/HH_activation/B
- /library/Purk_CaP
- /library/Purk_CaP/HH_activation
- /library/Purk_CaP/HH_activation/A
- /library/Purk_CaP/HH_activation/B
- /library/Purk_CaP/HH_inactivation
- /library/Purk_CaP/HH_inactivation/A
- /library/Purk_CaP/HH_inactivation/B
- /library/Purk_CaT
- /library/Purk_CaT/HH_activation
- /library/Purk_CaT/HH_activation/A
- /library/Purk_CaT/HH_activation/B
- /library/Purk_CaT/HH_inactivation
- /library/Purk_CaT/HH_inactivation/A
- /library/Purk_CaT/HH_inactivation/B
- /library/Purk_KA
- /library/Purk_KA/HH_activation
- /library/Purk_KA/HH_activation/A
- /library/Purk_KA/HH_activation/B
- /library/Purk_KA/HH_inactivation
- /library/Purk_KA/HH_inactivation/A
- /library/Purk_KA/HH_inactivation/B
- /library/Purk_KC
- /library/Purk_KC/HH_activation
- /library/Purk_KC/HH_activation/A
- /library/Purk_KC/HH_activation/B
- /library/Purk_KC/HH_concentration
- /library/Purk_KC/HH_concentration/A
- /library/Purk_KC/HH_concentration/B
- /library/Purk_K2
- /library/Purk_K2/HH_activation
- /library/Purk_K2/HH_activation/A
- /library/Purk_K2/HH_activation/B
- /library/Purk_K2/HH_concentration
- /library/Purk_K2/HH_concentration/A
- /library/Purk_K2/HH_concentration/B
- /library/Purk_Kdr
- /library/Purk_Kdr/HH_activation
- /library/Purk_Kdr/HH_activation/A
- /library/Purk_Kdr/HH_activation/B
- /library/Purk_Kdr/HH_inactivation
- /library/Purk_Kdr/HH_inactivation/A
- /library/Purk_Kdr/HH_inactivation/B
- /library/Purk_KM
- /library/Purk_KM/HH_activation
- /library/Purk_KM/HH_activation/A
- /library/Purk_KM/HH_activation/B
- /library/Purk_h1
- /library/Purk_h1/HH_activation
- /library/Purk_h1/HH_activation/A
- /library/Purk_h1/HH_activation/B
- /library/Purk_h2
- /library/Purk_h2/HH_activation
- /library/Purk_h2/HH_activation/A
- /library/Purk_h2/HH_activation/B
- /library/Purk_soma
- /library/Purk_soma/NaF
- /library/Purk_soma/NaF/HH_activation
- /library/Purk_soma/NaF/HH_activation/A
- /library/Purk_soma/NaF/HH_activation/B
- /library/Purk_soma/NaF/HH_inactivation
- /library/Purk_soma/NaF/HH_inactivation/A
- /library/Purk_soma/NaF/HH_inactivation/B
- /library/Purk_soma/NaP
- /library/Purk_soma/NaP/HH_activation
- /library/Purk_soma/NaP/HH_activation/A
- /library/Purk_soma/NaP/HH_activation/B
- /library/Purk_soma/CaT
- /library/Purk_soma/CaT/HH_activation
- /library/Purk_soma/CaT/HH_activation/A
- /library/Purk_soma/CaT/HH_activation/B
- /library/Purk_soma/CaT/HH_inactivation
- /library/Purk_soma/CaT/HH_inactivation/A
- /library/Purk_soma/CaT/HH_inactivation/B
- /library/Purk_soma/KA
- /library/Purk_soma/KA/HH_activation
- /library/Purk_soma/KA/HH_activation/A
- /library/Purk_soma/KA/HH_activation/B
- /library/Purk_soma/KA/HH_inactivation
- /library/Purk_soma/KA/HH_inactivation/A
- /library/Purk_soma/KA/HH_inactivation/B
- /library/Purk_soma/Kdr
- /library/Purk_soma/Kdr/HH_activation
- /library/Purk_soma/Kdr/HH_activation/A
- /library/Purk_soma/Kdr/HH_activation/B
- /library/Purk_soma/Kdr/HH_inactivation
- /library/Purk_soma/Kdr/HH_inactivation/A
- /library/Purk_soma/Kdr/HH_inactivation/B
- /library/Purk_soma/KM
- /library/Purk_soma/KM/HH_activation
- /library/Purk_soma/KM/HH_activation/A
- /library/Purk_soma/KM/HH_activation/B
- /library/Purk_soma/h1
- /library/Purk_soma/h1/HH_activation
- /library/Purk_soma/h1/HH_activation/A
- /library/Purk_soma/h1/HH_activation/B
- /library/Purk_soma/h2
- /library/Purk_soma/h2/HH_activation
- /library/Purk_soma/h2/HH_activation/A
- /library/Purk_soma/h2/HH_activation/B
- /library/Purk_soma/Ca_pool
- /library/Purk_maind
- /library/Purk_maind/CaT
- /library/Purk_maind/CaT/HH_activation
- /library/Purk_maind/CaT/HH_activation/A
- /library/Purk_maind/CaT/HH_activation/B
- /library/Purk_maind/CaT/HH_inactivation
- /library/Purk_maind/CaT/HH_inactivation/A
- /library/Purk_maind/CaT/HH_inactivation/B
- /library/Purk_maind/KA
- /library/Purk_maind/KA/HH_activation
- /library/Purk_maind/KA/HH_activation/A
- /library/Purk_maind/KA/HH_activation/B
- /library/Purk_maind/KA/HH_inactivation
- /library/Purk_maind/KA/HH_inactivation/A
- /library/Purk_maind/KA/HH_inactivation/B
- /library/Purk_maind/Kdr
- /library/Purk_maind/Kdr/HH_activation
- /library/Purk_maind/Kdr/HH_activation/A
- /library/Purk_maind/Kdr/HH_activation/B
- /library/Purk_maind/Kdr/HH_inactivation
- /library/Purk_maind/Kdr/HH_inactivation/A
- /library/Purk_maind/Kdr/HH_inactivation/B
- /library/Purk_maind/KM
- /library/Purk_maind/KM/HH_activation
- /library/Purk_maind/KM/HH_activation/A
- /library/Purk_maind/KM/HH_activation/B
- /library/Purk_maind/CaP
- /library/Purk_maind/CaP/HH_activation
- /library/Purk_maind/CaP/HH_activation/A
- /library/Purk_maind/CaP/HH_activation/B
- /library/Purk_maind/CaP/HH_inactivation
- /library/Purk_maind/CaP/HH_inactivation/A
- /library/Purk_maind/CaP/HH_inactivation/B
- /library/Purk_maind/KC
- /library/Purk_maind/KC/HH_activation
- /library/Purk_maind/KC/HH_activation/A
- /library/Purk_maind/KC/HH_activation/B
- /library/Purk_maind/KC/HH_concentration
- /library/Purk_maind/KC/HH_concentration/A
- /library/Purk_maind/KC/HH_concentration/B
- /library/Purk_maind/K2
- /library/Purk_maind/K2/HH_activation
- /library/Purk_maind/K2/HH_activation/A
- /library/Purk_maind/K2/HH_activation/B
- /library/Purk_maind/K2/HH_concentration
- /library/Purk_maind/K2/HH_concentration/A
- /library/Purk_maind/K2/HH_concentration/B
- /library/Purk_maind/Ca_pool
- /library/Purk_maind/Ca_nernst
- /library/Purk_axon
- /library/Purk_axon/CaT
- /library/Purk_axon/CaT/HH_activation
- /library/Purk_axon/CaT/HH_activation/A
- /library/Purk_axon/CaT/HH_activation/B
- /library/Purk_axon/CaT/HH_inactivation
- /library/Purk_axon/CaT/HH_inactivation/A
- /library/Purk_axon/CaT/HH_inactivation/B
- /library/Purk_axon/KA
- /library/Purk_axon/KA/HH_activation
- /library/Purk_axon/KA/HH_activation/A
- /library/Purk_axon/KA/HH_activation/B
- /library/Purk_axon/KA/HH_inactivation
- /library/Purk_axon/KA/HH_inactivation/A
- /library/Purk_axon/KA/HH_inactivation/B
- /library/Purk_axon/Kdr
- /library/Purk_axon/Kdr/HH_activation
- /library/Purk_axon/Kdr/HH_activation/A
- /library/Purk_axon/Kdr/HH_activation/B
- /library/Purk_axon/Kdr/HH_inactivation
- /library/Purk_axon/Kdr/HH_inactivation/A
- /library/Purk_axon/Kdr/HH_inactivation/B
- /library/Purk_axon/KM
- /library/Purk_axon/KM/HH_activation
- /library/Purk_axon/KM/HH_activation/A
- /library/Purk_axon/KM/HH_activation/B
- /library/Purk_axon/CaP
- /library/Purk_axon/CaP/HH_activation
- /library/Purk_axon/CaP/HH_activation/A
- /library/Purk_axon/CaP/HH_activation/B
- /library/Purk_axon/CaP/HH_inactivation
- /library/Purk_axon/CaP/HH_inactivation/A
- /library/Purk_axon/CaP/HH_inactivation/B
- /library/Purk_axon/KC
- /library/Purk_axon/KC/HH_activation
- /library/Purk_axon/KC/HH_activation/A
- /library/Purk_axon/KC/HH_activation/B
- /library/Purk_axon/KC/HH_concentration
- /library/Purk_axon/KC/HH_concentration/A
- /library/Purk_axon/KC/HH_concentration/B
- /library/Purk_axon/K2
- /library/Purk_axon/K2/HH_activation
- /library/Purk_axon/K2/HH_activation/A
- /library/Purk_axon/K2/HH_activation/B
- /library/Purk_axon/K2/HH_concentration
- /library/Purk_axon/K2/HH_concentration/A
- /library/Purk_axon/K2/HH_concentration/B
- /library/Purk_axon/Ca_pool
- /library/Purk_axon/Ca_nernst
- /library/Purk_thickd
- /library/Purk_thickd/CaT
- /library/Purk_thickd/CaT/HH_activation
- /library/Purk_thickd/CaT/HH_activation/A
- /library/Purk_thickd/CaT/HH_activation/B
- /library/Purk_thickd/CaT/HH_inactivation
- /library/Purk_thickd/CaT/HH_inactivation/A
- /library/Purk_thickd/CaT/HH_inactivation/B
- /library/Purk_thickd/KA
- /library/Purk_thickd/KA/HH_activation
- /library/Purk_thickd/KA/HH_activation/A
- /library/Purk_thickd/KA/HH_activation/B
- /library/Purk_thickd/KA/HH_inactivation
- /library/Purk_thickd/KA/HH_inactivation/A
- /library/Purk_thickd/KA/HH_inactivation/B
- /library/Purk_thickd/Kdr
- /library/Purk_thickd/Kdr/HH_activation
- /library/Purk_thickd/Kdr/HH_activation/A
- /library/Purk_thickd/Kdr/HH_activation/B
- /library/Purk_thickd/Kdr/HH_inactivation
- /library/Purk_thickd/Kdr/HH_inactivation/A
- /library/Purk_thickd/Kdr/HH_inactivation/B
- /library/Purk_thickd/KM
- /library/Purk_thickd/KM/HH_activation
- /library/Purk_thickd/KM/HH_activation/A
- /library/Purk_thickd/KM/HH_activation/B
- /library/Purk_thickd/CaP
- /library/Purk_thickd/CaP/HH_activation
- /library/Purk_thickd/CaP/HH_activation/A
- /library/Purk_thickd/CaP/HH_activation/B
- /library/Purk_thickd/CaP/HH_inactivation
- /library/Purk_thickd/CaP/HH_inactivation/A
- /library/Purk_thickd/CaP/HH_inactivation/B
- /library/Purk_thickd/KC
- /library/Purk_thickd/KC/HH_activation
- /library/Purk_thickd/KC/HH_activation/A
- /library/Purk_thickd/KC/HH_activation/B
- /library/Purk_thickd/KC/HH_concentration
- /library/Purk_thickd/KC/HH_concentration/A
- /library/Purk_thickd/KC/HH_concentration/B
- /library/Purk_thickd/K2
- /library/Purk_thickd/K2/HH_activation
- /library/Purk_thickd/K2/HH_activation/A
- /library/Purk_thickd/K2/HH_activation/B
- /library/Purk_thickd/K2/HH_concentration
- /library/Purk_thickd/K2/HH_concentration/A
- /library/Purk_thickd/K2/HH_concentration/B
- /library/Purk_thickd/Ca_pool
- /library/Purk_thickd/Ca_nernst
- /library/Purk_thickd/CaT
- /library/Purk_thickd/CaT/HH_activation
- /library/Purk_thickd/CaT/HH_activation/A
- /library/Purk_thickd/CaT/HH_activation/B
- /library/Purk_thickd/CaT/HH_inactivation
- /library/Purk_thickd/CaT/HH_inactivation/A
- /library/Purk_thickd/CaT/HH_inactivation/B
- /library/Purk_thickd/CaP
- /library/Purk_thickd/CaP/HH_activation
- /library/Purk_thickd/CaP/HH_activation/A
- /library/Purk_thickd/CaP/HH_activation/B
- /library/Purk_thickd/CaP/HH_inactivation
- /library/Purk_thickd/CaP/HH_inactivation/A
- /library/Purk_thickd/CaP/HH_inactivation/B
- /library/Purk_thickd/KM
- /library/Purk_thickd/KM/HH_activation
- /library/Purk_thickd/KM/HH_activation/A
- /library/Purk_thickd/KM/HH_activation/B
- /library/Purk_thickd/KC
- /library/Purk_thickd/KC/HH_activation
- /library/Purk_thickd/KC/HH_activation/A
- /library/Purk_thickd/KC/HH_activation/B
- /library/Purk_thickd/KC/HH_concentration
- /library/Purk_thickd/KC/HH_concentration/A
- /library/Purk_thickd/KC/HH_concentration/B
- /library/Purk_thickd/K2
- /library/Purk_thickd/K2/HH_activation
- /library/Purk_thickd/K2/HH_activation/A
- /library/Purk_thickd/K2/HH_activation/B
- /library/Purk_thickd/K2/HH_concentration
- /library/Purk_thickd/K2/HH_concentration/A
- /library/Purk_thickd/K2/HH_concentration/B
- /library/Purk_thickd/Ca_pool
- /library/Purk_thickd/Ca_nernst
- /library/Purk_spinyd
- /library/Purk_spinyd/CaT
- /library/Purk_spinyd/CaT/HH_activation
- /library/Purk_spinyd/CaT/HH_activation/A
- /library/Purk_spinyd/CaT/HH_activation/B
- /library/Purk_spinyd/CaT/HH_inactivation
- /library/Purk_spinyd/CaT/HH_inactivation/A
- /library/Purk_spinyd/CaT/HH_inactivation/B
- /library/Purk_spinyd/KA
- /library/Purk_spinyd/KA/HH_activation
- /library/Purk_spinyd/KA/HH_activation/A
- /library/Purk_spinyd/KA/HH_activation/B
- /library/Purk_spinyd/KA/HH_inactivation
- /library/Purk_spinyd/KA/HH_inactivation/A
- /library/Purk_spinyd/KA/HH_inactivation/B
- /library/Purk_spinyd/Kdr
- /library/Purk_spinyd/Kdr/HH_activation
- /library/Purk_spinyd/Kdr/HH_activation/A
- /library/Purk_spinyd/Kdr/HH_activation/B
- /library/Purk_spinyd/Kdr/HH_inactivation
- /library/Purk_spinyd/Kdr/HH_inactivation/A
- /library/Purk_spinyd/Kdr/HH_inactivation/B
- /library/Purk_spinyd/KM
- /library/Purk_spinyd/KM/HH_activation
- /library/Purk_spinyd/KM/HH_activation/A
- /library/Purk_spinyd/KM/HH_activation/B
- /library/Purk_spinyd/CaP
- /library/Purk_spinyd/CaP/HH_activation
- /library/Purk_spinyd/CaP/HH_activation/A
- /library/Purk_spinyd/CaP/HH_activation/B
- /library/Purk_spinyd/CaP/HH_inactivation
- /library/Purk_spinyd/CaP/HH_inactivation/A
- /library/Purk_spinyd/CaP/HH_inactivation/B
- /library/Purk_spinyd/KC
- /library/Purk_spinyd/KC/HH_activation
- /library/Purk_spinyd/KC/HH_activation/A
- /library/Purk_spinyd/KC/HH_activation/B
- /library/Purk_spinyd/KC/HH_concentration
- /library/Purk_spinyd/KC/HH_concentration/A
- /library/Purk_spinyd/KC/HH_concentration/B
- /library/Purk_spinyd/K2
- /library/Purk_spinyd/K2/HH_activation
- /library/Purk_spinyd/K2/HH_activation/A
- /library/Purk_spinyd/K2/HH_activation/B
- /library/Purk_spinyd/K2/HH_concentration
- /library/Purk_spinyd/K2/HH_concentration/A
- /library/Purk_spinyd/K2/HH_concentration/B
- /library/Purk_spinyd/Ca_pool
- /library/Purk_spinyd/Ca_nernst
- /library/Purk_spinyd/CaT
- /library/Purk_spinyd/CaT/HH_activation
- /library/Purk_spinyd/CaT/HH_activation/A
- /library/Purk_spinyd/CaT/HH_activation/B
- /library/Purk_spinyd/CaT/HH_inactivation
- /library/Purk_spinyd/CaT/HH_inactivation/A
- /library/Purk_spinyd/CaT/HH_inactivation/B
- /library/Purk_spinyd/CaP
- /library/Purk_spinyd/CaP/HH_activation
- /library/Purk_spinyd/CaP/HH_activation/A
- /library/Purk_spinyd/CaP/HH_activation/B
- /library/Purk_spinyd/CaP/HH_inactivation
- /library/Purk_spinyd/CaP/HH_inactivation/A
- /library/Purk_spinyd/CaP/HH_inactivation/B
- /library/Purk_spinyd/KM
- /library/Purk_spinyd/KM/HH_activation
- /library/Purk_spinyd/KM/HH_activation/A
- /library/Purk_spinyd/KM/HH_activation/B
- /library/Purk_spinyd/KC
- /library/Purk_spinyd/KC/HH_activation
- /library/Purk_spinyd/KC/HH_activation/A
- /library/Purk_spinyd/KC/HH_activation/B
- /library/Purk_spinyd/KC/HH_concentration
- /library/Purk_spinyd/KC/HH_concentration/A
- /library/Purk_spinyd/KC/HH_concentration/B
- /library/Purk_spinyd/K2
- /library/Purk_spinyd/K2/HH_activation
- /library/Purk_spinyd/K2/HH_activation/A
- /library/Purk_spinyd/K2/HH_activation/B
- /library/Purk_spinyd/K2/HH_concentration
- /library/Purk_spinyd/K2/HH_concentration/A
- /library/Purk_spinyd/K2/HH_concentration/B
- /library/Purk_spinyd/Ca_pool
- /library/Purk_spinyd/Ca_nernst
- /Purkinje
- /Purkinje/soma
- /Purkinje/soma/NaF
- /Purkinje/soma/NaF/HH_activation
- /Purkinje/soma/NaF/HH_activation/A
- /Purkinje/soma/NaF/HH_activation/B
- /Purkinje/soma/NaF/HH_inactivation
- /Purkinje/soma/NaF/HH_inactivation/A
- /Purkinje/soma/NaF/HH_inactivation/B
- /Purkinje/soma/NaP
- /Purkinje/soma/NaP/HH_activation
- /Purkinje/soma/NaP/HH_activation/A
- /Purkinje/soma/NaP/HH_activation/B
- /Purkinje/soma/CaT
- /Purkinje/soma/CaT/HH_activation
- /Purkinje/soma/CaT/HH_activation/A
- /Purkinje/soma/CaT/HH_activation/B
- /Purkinje/soma/CaT/HH_inactivation
- /Purkinje/soma/CaT/HH_inactivation/A
- /Purkinje/soma/CaT/HH_inactivation/B
- /Purkinje/soma/KA
- /Purkinje/soma/KA/HH_activation
- /Purkinje/soma/KA/HH_activation/A
- /Purkinje/soma/KA/HH_activation/B
- /Purkinje/soma/KA/HH_inactivation
- /Purkinje/soma/KA/HH_inactivation/A
- /Purkinje/soma/KA/HH_inactivation/B
- /Purkinje/soma/Kdr
- /Purkinje/soma/Kdr/HH_activation
- /Purkinje/soma/Kdr/HH_activation/A
- /Purkinje/soma/Kdr/HH_activation/B
- /Purkinje/soma/Kdr/HH_inactivation
- /Purkinje/soma/Kdr/HH_inactivation/A
- /Purkinje/soma/Kdr/HH_inactivation/B
- /Purkinje/soma/KM
- /Purkinje/soma/KM/HH_activation
- /Purkinje/soma/KM/HH_activation/A
- /Purkinje/soma/KM/HH_activation/B
- /Purkinje/soma/h1
- /Purkinje/soma/h1/HH_activation
- /Purkinje/soma/h1/HH_activation/A
- /Purkinje/soma/h1/HH_activation/B
- /Purkinje/soma/h2
- /Purkinje/soma/h2/HH_activation
- /Purkinje/soma/h2/HH_activation/A
- /Purkinje/soma/h2/HH_activation/B
- /Purkinje/soma/Ca_pool
',
						    write => 'expand /**',
						   },
						   {
						    description => 'Quit the model-container querymachine.',
						    write => 'quit',
						   },
						   {
						    description => "Is the model correctly compiled by heccer ?",
						    read => 'Heccer (pcName) : (/Purkinje)
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
Heccer (dStep) : (2e-05)
Compartment (mc.iType) : (1)
Tables (iTabulatedGateCount) : (12)
Compartment operations
-----
00000 :: FINISH
00001 :: FINISH
Mechanism operations
-----
00000 :: COMPARTMENT							 -2.23189e-10 0 218562 1.00061
00001 :: INITIALIZECHANNEL 0.045 0.000209239
00002 :: LOADVOLTAGETABLE
00003 :: CONCEPTGATE 0 3 (nil)							 0.00784064
00004 :: CONCEPTGATE 1 1 (nil)							 0.263978
00005 :: UPDATECOMPARTMENTCURRENT
00006 :: INITIALIZECHANNEL 0.045 2.78986e-08
00007 :: LOADVOLTAGETABLE
00008 :: CONCEPTGATE 2 3 (nil)							 0.0452931
00009 :: UPDATECOMPARTMENTCURRENT
00010 :: INITIALIZECHANNEL 0.137526 1.39493e-08
00011 :: LOADVOLTAGETABLE
00012 :: CONCEPTGATE 3 1 (nil)							 0.0389187
00013 :: CONCEPTGATE 4 1 (nil)							 0.0826021
00014 :: UPDATECOMPARTMENTCURRENT
00015 :: REGISTERCHANNELCURRENT
00016 :: FLUXPOOL							 0
00017 :: INITIALIZECHANNEL -0.085 4.18479e-07
00018 :: LOADVOLTAGETABLE
00019 :: CONCEPTGATE 5 4 (nil)							 0.0832441
00020 :: CONCEPTGATE 6 1 (nil)							 0.749501
00021 :: UPDATECOMPARTMENTCURRENT
00022 :: INITIALIZECHANNEL -0.085 1.67391e-05
00023 :: LOADVOLTAGETABLE
00024 :: CONCEPTGATE 7 2 (nil)							 0.0045016
00025 :: CONCEPTGATE 8 1 (nil)							 0.999979
00026 :: UPDATECOMPARTMENTCURRENT
00027 :: INITIALIZECHANNEL -0.085 1.11594e-09
00028 :: LOADVOLTAGETABLE
00029 :: CONCEPTGATE 9 1 (nil)							 0.0354084
00030 :: UPDATECOMPARTMENTCURRENT
00031 :: INITIALIZECHANNEL -0.03 8.36957e-09
00032 :: LOADVOLTAGETABLE
00033 :: CONCEPTGATE 10 1 (nil)							 0.0961851
00034 :: UPDATECOMPARTMENTCURRENT
00035 :: INITIALIZECHANNEL -0.03 8.36957e-09
00036 :: LOADVOLTAGETABLE
00037 :: CONCEPTGATE 11 1 (nil)							 0.0240463
00038 :: UPDATECOMPARTMENTCURRENT
00039 :: EXPONENTIALDECAY 420702 4e-05 1.1
			 (0) (nil) (nil) (nil)							 4e-05
00040 :: FINISH
VM Diagonals (pdDiagonals[0]) : (1.00061)
VM Axial Resistances (pdResults[0]) : (0)
VM Axial Resistances (pdResults[1]) : (0)
VM Membrane Potentials (pdVms[0]) : (-0.068)
',
						   },
						   {
						    description => 'Quit the simulator.',
						    wait => 1,
						    write => 'quit',
						   },
						   {
						    description => "Is the generated output correct ?",
						    read => {
							     application_output_file => "$::config->{core_directory}/results/PurkM9_soma_only_0.03nA",
							     expected_output_file => "$::config->{core_directory}/tests/specifications/strings/PurkM9_soma_only_0.03nA",
							    },
						   },
						  ),
						 ],
				description => 'Running the purkinje cell soma by itself, active channels, current injections',
				preparation => {
						description => "Create the results directory",
						preparer =>
						sub
						{
						    `mkdir results`;
						},
					       },
				reparation => {
					       description => "Remove the generated output files in the results directory",
					       reparer =>
					       sub
					       {
						   `rm "$::config->{core_directory}/results/PurkM9_soma_only_0.03nA"`;
						   `rmdir results`;
					       },
					      },
			       },
			      ],
       description => "EDS purkinje cell model simplification",
       name => 'purkinje.t',
      };


return $test;

