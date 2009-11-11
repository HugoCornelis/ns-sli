// genesis

/*
** $Id: olflib.g 1.2.1.3 Tue, 03 Jan 2006 15:51:45 -0600 hugo $
**
** $Log: olflib.g,v $
** Revision 1.13  2003/03/28 21:17:42  gen-dbeeman
** Fix by Dave Beeman for an error that caused the SUM message for the
** table2D object to fail.
**
** Revision 1.12  1999/10/17 22:31:42  mhucka
** Dave Beeman said that hh_tabchan should be considered a failed experiment,
** and be removed, so I've removed the definition of hh_tabchannel.
**
** Revision 1.11  1998/06/30 23:28:37  dhb
** EDS 22d merge
**
** Revision 1.10  1998/06/30 21:21:58  dhb
** Added the hh_tabchannel object
**
** Revision 1.9.1.1  1998/06/30 23:25:43  dhb
** EDS 22d merge
**
 * EDS22d revison: EDS BBF-UIA 98/04/30-98/05/04
 * Added instantaneous gates to tab(2)channels
 *
** Revision 1.9  1997/07/18 20:34:49  dhb
** Put dddyn object back (was removed in merging in Antwerp changes)
**
** Revision 1.8  1997/06/04 18:01:38  dhb
** Changed name of tabchannel and tab2Dchannel SCALE_GBAR message to
** ADD_BGAR and the solt name from scaling_factor to offset
**
** Revision 1.7  1997/06/03 20:15:13  dhb
** Changed name of 2d table object from table2d to table2D
**
** Revision 1.6  1997/05/29 08:33:49  dhb
** Update from Antwerp GENESIS version 21e
**
 * EDS21e revison: EDS BBF-UIA 96/08/02-97/04/16
 * Added SCALE_GBAR msg, updated tabcurrent
 *
 * EDS20j revison: EDS BBF-UIA 95/07/27-95/08/03
 * Added DOMAINCONC msg to tabchannel, tab2Dchannel and tabcurrent
 * Added surface field to tab_current, table2d and tab2channel
 * Cleaned up message fields, added SHOW action to tab2Dchannel. 
 *
 * EDS20i revison: EDS BBF-UIA 95/06/02
 * Added table2d, tab2Dchannel and tabcurrent
 * Added TABSAVE and TABREAD actions and predefined values
 *
 * Revision 1.5  1995/05/13  01:35:12  dhb
 * Changes to support xfileview like functionality using disk_in
 * and xview elements.
 *
 * Revision 1.4  1994/10/04  23:01:01  dhb
 * Added TABDELETE action to tabchannel.
 *
 * Revision 1.3  1994/08/08  22:30:37  dhb
 * Changes from Upi.
 *
 * Revision 1.3  1994/06/13  22:53:56  bhalla
 * Added TAB2FIELDS, DUMP, SHOW and other actions
 *
 * Revision 1.2  1993/02/25  18:50:10  dhb
 * 1.4 to 2.0 command name changes.
 *
 * Revision 1.1  1992/11/14  00:38:47  dhb
 * Initial revision
 *
*/

/*
************************************************************************
**                       OLF SHELL COMMANDS                           **
************************************************************************
*/

// Functions for filling tabchannels and gates with HH-curves
addfunc	setupalpha SetupAlpha
// addfunc setuptau SetupTau
// addfunc setupgate SetupGate
// addfunc setupghk SetupGHK
// addfunc setupNaCa SetupNaCa
addfunc tweakalpha TweakAlpha
addfunc tweaktau TweakTau
// addfunc scaletabchan ScaleTabchan
// addfunc duplicatetable DuplicateTable
// addfunc file2tab FileToTab
// addfunc tab2file TabToFile
// addfunc loadtab LoadTab

// addaction TABCREATE 200
// addaction TABFILL 201
// addaction TABDELETE 202
// addaction TABSAVE 203
// addaction TABREAD 204
// addaction TAB2FIELDS 207
// addaction TABOP 208

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
