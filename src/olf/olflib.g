//genesis

/*
************************************************************************
**                       OLF SHELL COMMANDS                           **
************************************************************************
*/

// Functions for filling tabchannels and gates with HH-curves
addfunc	setupalpha SetupAlpha






addaction TABCREATE 200
addaction TABFILL 201
addaction TABDELETE 202
addaction TABSAVE 203
addaction TABREAD 204
addaction TAB2FIELDS 207
addaction TABOP 208



// Values for the fill modes for the tables
int	B_SPLINE_FILL = 0
int	C_SPLINE_FILL = 1
int	LINEAR_FILL = 2
// Values for calc_mode
int NO_INTERP = 0
int LIN_INTERP = 1
int FIXED = 2
// Values for index fields of tab2Dchannel
int VOLT_INDEX = 0
int C1_INDEX = 1
int C2_INDEX = 2
int DOMAIN_INDEX = 3
int VOLT_C1_INDEX = -1
int VOLT_C2_INDEX = -2
int VOLT_DOMAIN_INDEX = -3
int C1_C2_INDEX = -4
int DOMAIN_C2_INDEX = -5
// Values for instant field of tab(2D)channel
int INSTANTX = 1
int INSTANTY = 2
int INSTANTZ = 4

/*
*************************************************************************
**                              OBJECT TABLE                           **
*************************************************************************
*/
//==========================================================================
//	name		data            function	class	
//==========================================================================
object	tabchannel		tab_channel_type TabChannel	segment channel \
	-author ""
	-actions TABCREATE
	-description "A tabchannel function that interfaces with neurospaces"


