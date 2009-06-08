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
						 ],
				description => "elementary tests for the purkinje cell model with genesis alike channels",
			       },
			      ],
       comment => 'This test was derived from the model-container purkinje.t',
       description => "EDS purkinje cell model simplification",
       name => 'purkinje.t',
      };


return $test;


