//genesis 2.0

// This new version of the defaults.g file uses compiled code
// instead of Script Language functions to set up tabchannels.

/***********************************************************************
**                                                                    **
**	  DEFAULTS.G : defaults definition file, neuron builder kit.  **
**                                                                    **
**                    By E. De Schutter, Nov 1990                     **
**  Modified by Upi Bhalla and D. Beeman, June 1992 for GENESIS 1.4   **
************************************************************************/

/* DO NOT EDIT THIS FILE: it is the default.  Customize by making a 
**	copy of the 'userprefs.g' file and put that in your working 
**  directory (each directory can contain a different userpref file).  
** In userprefs.g you can change the value of the user_values and
**	other globals and create your own specific library.
** Do cd to your working  directory before starting Neurokit. */

/**********************************************************************/
/* DEFAULT USER_VALUES AND CELL_PARSER VALUES */
/* THESE GLOBAL VALUES SHOULD ALWAYS BE DEFINED! */

	float PI = 3.14159

	/* VARIABLES USED BY ACTIVE COMPONENTS */
	int EXPONENTIAL = 1
	int SIGMOID = 2
	int LINOID = 3

	/* VARIABLES ASSUMED DEFINED BY CELL_PARSER */
	float CM = 0.01		// Farads/m^2
	float RA = 0.5		// Ohms m
	float RM = 0.2		// Ohms m^2
	float EREST_ACT = -0.070		// Volts

/*   Set the user_variables: all these variables must be declared, 
**   even if they are not used! */

	str user_help = "./README"		/* help file name */

	/* xcell widget */
	float user_wx = 1.4e-3	//wx, wy, cx, cy, cz for the draw widget
	float user_wy = 1.4e-3
	float user_cx = 0.0
	float user_cy = 0.0
	float user_cz = 0.2e-3
	str user_field1 = "Vm"
	str user_path1 = "."
	float user_colmin1 = -0.10
	float user_colmax1 = 0.05
	float user_fatrange1 = -20.0
	int user_fatfix1 = 1
	int user_colfix1 = 0
	int user_numxouts = 1	/* show 1 or 2 xout and graph windows */
	str user_field2 = "Vm"
	str user_path2 = "."
	float user_colmin2 = -0.10
	float user_colmax2 = 0.05
	float user_fatrange2 = -20.0
	int user_fatfix2 = 1
	int user_colfix2 = 0

	/* xgraph widget */
	float user_xmax1 = 0.5
	float user_ymin1 = -0.1
	float user_ymax1 = 0.05
	float user_yoffset1 = 0.10
	float user_xmax2 = 0.5
	float user_ymin2 = -0.1
	float user_ymax2 = 0.05
	float user_yoffset2 = 0.10

	/* cell_run_control widget */
	/*  integration */
	int user_symcomps = 0	/* boolean, default is asymmetric comps */
	int user_intmethod = 0
	float user_runtime = 0.5

	/*  electrophysiology */
	float user_inject = 1.0	//nA
	float user_clamp = 0.0
	float user_rate = 100.0
	float user_weight = 1.0
	float user_activ = 1000.0
	float user_spike = 1.0
	str user_syntype1 = "glu"
	str user_syntype2 = "GABA"

	/*  simulation output : file_IO widget */
	str user_filepath = "."
	str user_restorefile = "restore_camit"
	str user_filefield = "Vm"
	str user_filefieldpath = "soma"
	str user_filename = "testVm"
	float user_dt = 1.0e-5
	float user_refresh = 10.0

	/* Cell specifications : file_form widget */
	str user_cell = "/camit"
	str user_pfile = "camit.p"
	str user_name = "Me"

	/* Set screen width preferences here.
	** Decstation 5000/200 : 1280
	** SUN workstations : 1150
	*/
	int user_screenwidth = 1024

	if ({exists /xproto})
		/* appropriate for black and white printing */
		xps -mingray 255 -maxgray 256 -inverse 0
		/* appropriate for printing out shades of grey */
		xps -mingray 20 -maxgray 120 -inverse 0
	end

	/* predefine some neurokit variables so they can be used in
	**	functions defined in userprefs.g */
	str cellname = "camit"
	str comptname = "soma"
	str channelname = "glu"
	str cellpath = "/new"
	str comptpath = "/new/soma"
	str channelpath = "/new/soma/glu"
	str analysis_level = "new"

/***********************************************************************/

/**********************************************************************
**
**		Creating the library
**
**********************************************************************/

if (!{exists /library})
	create neutral /library
	/* We don't want the library to try to calculate anything, 
	**	so we disable it */
	disable /library
end

/**********************************************************************
**
**		Creating the voltage clamp circuit for the library
**
**********************************************************************/

// include vclamp 
ce /library
// make_Vclamp
ce /


/**********************************************************************
**
**		Some utility functions for tabulated channels
**
**********************************************************************/

int TAB_XDIVS = 3000
float TAB_XMIN = -0.1
float TAB_XMAX = 0.05


// /* 
// ** These SLI functions  been replaced by compiled functions with
// ** clearer names.   The aliases defined below are just for
// ** backwards compatibility. They replace the script functions below.
// */

// addalias setup_table2 setupgate		// aka setupgate
// // The usage of this has changed, so "setupgate" should be used instead

// addalias tweak_tabchan tweakalpha	// aka tweakalpha
// addalias tau_tweak_tabchan tweaktau	// aka tweaktau
// addalias setup_tabchan setupalpha	// aka setupalpha
// addalias setup_tabchan_tau setuptau	// aka setuptau

// function setup_table3(gate, table, xdivs, xmin, xmax, A, B, C, D, F)
// 	setup_table2 {gate} {table} {A} {B} {C}  \
// 	    {D} {F} -size {xdivs} -range {xmin} {xmax} -noalloc
// end

// function setup_table(gate, table, xdivs, A, B, C, D, F)
// 	setup_table2 {gate} {table} {A}  \
// 	    {B} {C} {D} {F} -size {xdivs} -range {TAB_XMIN} {TAB_XMAX}
// end

// // settab2const sets a range of entries in a tabgate table to a constant
// function settab2const(gate, table, imin, imax, value)
//     str gate
//     str table
//     int i, imin, imax
//     float value
//     for (i = (imin); i <= (imax); i = i + 1)
//         setfield {gate} {table}->table[{i}] {value}
//     end
// end

/* The following "commented-out" functions were replaced by more
   efficient compiled functions in GENESIS ver. 1.4.  The older GENESIS
   Script Language implementations are included here in order to illustrate
   what they do.

function setup_table3(gate,table,xdivs,xmin,xmax,A,B,C,D,F)
	str	gate,table
	int	xdivs
	float	xmin,xmax,A,B,C,D,F

	int i
	float x,dx,y

	dx = xdivs
	dx = (xmax - xmin)/dx
	x = xmin

	for (i = 0 ; i <= {xdivs} ; i = i + 1)
		y = (A + B * x) / (C + {exp({(x + D) / F})})
		setfield {gate} {table}->table[{i}] {y}
		x = x + dx
	end
end

function setup_table2(gate,table,xdivs,xmin,xmax,A,B,C,D,F)
	str	gate,table
	int	xdivs
	float	xmin,xmax,A,B,C,D,F

	if (xdivs <= 9)
		echo must have at least 9, preferably over 100 elements in table
		return
	end
	call {gate} TABCREATE {table} {xdivs} {xmin} {xmax}
	setup_table3({gate},{table},{xdivs},{xmin},{xmax},{A},{B},{C},{D},{F})
end

function setup_table(gate,table,xdivs,A,B,C,D,F)
	str	gate,table
	int	xdivs
	float	A,B,C,D,F

	setup_table2({gate},{table},{xdivs},-0.1,0.1,{A},{B},{C},{D},{F})
end

// Alters the values in the B arrays of tabchan to 1/tau 
function tweak_tabchan(chan,gate)
	str chan,gate
	str tabA = {gate}+"_A"
	str tabB = {gate}+"_B"
	int xdivs,i
	float A,B

	xdivs = get({chan},{tabA}->xdivs)
	for (i = 0 ; i <= xdivs ; i = i + 1)
		A = get({chan},{tabA}->table[{i}])
		B = get({chan},{tabB}->table[{i}])
		setfield {chan} {tabB}->table[{i}] {A + B}
	end
end

// Alters the values in the A and B arrays of tabchan to A and 1/tau,
// from tau and minf 
function tau_tweak_tabchan(chan,gate)
	str chan,gate
	str tabA = {gate}+"_A"
	str tabB = {gate}+"_B"
	int xdivs,i
	float A,B
	float T,M

	xdivs = get({chan},{tabA}->xdivs)
	for (i = 0 ; i <= xdivs ; i = i + 1)
		T = get({chan},{tabA}->table[{i}])
		M = get({chan},{tabB}->table[{i}])
		A = M / T
		B = 1.0/T
		setfield {chan} {tabA}->table[{i}] {A}
		setfield {chan} {tabB}->table[{i}] {B}
	end
end

// Sets up a tabchan with hh params, with the non-interp option in
// a table of 3000 entries 
function setup_tabchan(chan,gate,AA,AB,AC,AD,AF,BA,BB,BC,BD,BF)
	str chan,gate
	str tabA = {gate}+"_A"
	str tabB = {gate}+"_B"
	float AA,AB,AC,AD,AF,BA,BB,BC,BD,BF
	call {chan} TABCREATE {gate} 49 -0.1 0.05
	setup_table3({chan},{tabA},49,-0.1,0.05,{AA},{AB},{AC},{AD},{AF})
	setup_table3({chan},{tabB},49,-0.1,0.05,{BA},{BB},{BC},{BD},{BF})
	tweak_tabchan({chan},{gate})
	setfield {chan} {tabA}->calc_mode 0	 {tabB}->calc_mode 0
	call {chan} TABFILL {gate} 3000 0
end

// Sets up a tabchan with hh params, with the non-interp option in
// a table of 3000 entries.
// This version uses parameters for tau and minf instead
// of alpha and beta 
function setup_tabchan_tau(chan,gate,TA,TB,TC,TD,TF,MA,MB,MC,MD,MF)
	str chan,gate
	str tabA = {gate}+"_A"
	str tabB = {gate}+"_B"
	float TA,TB,TC,TD,TF,MA,MB,MC,MD,MF
	call {chan} TABCREATE {gate} 49 -0.1 0.05
	setup_table3({chan},{tabA},49,-0.1,0.05,{TA},{TB},{TC},{TD},{TF})
	setup_table3({chan},{tabB},49,-0.1,0.05,{MA},{MB},{MC},{MD},{MF})
	tau_tweak_tabchan({chan},{gate})
	setfield {chan} {tabA}->calc_mode 0	 {tabB}->calc_mode 0
	call {chan} TABFILL {gate} 3000 0
end
*/
