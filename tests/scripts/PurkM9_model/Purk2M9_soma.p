// Morphology file for Purkinje cell
// (c) Erik De Schutter, Caltech 1991-1992
// Original data provided by Rapp, Yarom and Segev, Hebrew University Jerusalem
// Active membrane model without spines
// References: Rapp, M., Segev, I., and Yarom, Y. (1994) Physiology,
//   morphology and detailed passive models of cerebellar Purkinje cells.
//   J.  Physiol. (London), 471: 87-99.
//             De Schutter, E. and Bower, J. M. (1994) An active membrane
//   model of the cerebellar Purkinje cell: I. Simulation of current
//   clamps in slice. J. Neurophysiol., 71: 375-400.
//   http://www.bbf.uia.ac.be/TNB/TNB_pub8.html
//   http://www.bbf.uia.ac.be/models/PM9.shtml for general model info

*relative

*set_compt_param RM	{RMs}
*set_compt_param RA	{RA}
*set_compt_param CM	{CM}
*set_compt_param ELEAK {ELEAK}	
*set_compt_param EREST_ACT {EREST_ACT}
*compt /library/Purk_soma
soma		none		0.000	0.000	0.000	29.80

