static char rcsid[] = "$Id: tabchannel.c,v 1.6 2006/02/03 21:24:26 svitak Exp $";

/*
** $Log: tabchannel.c,v $
** Revision 1.6  2006/02/03 21:24:26  svitak
** Fix for Voltage-dependent Z gate when power is greater than zero. Part of
** Jagerlab's additions.
**
** Revision 1.5  2006/01/17 15:05:00  svitak
** Changes for voltage-dependent Z gate and new purkinje tutorial.
**
** Revision 1.4  2006/01/10 19:56:39  svitak
** Changes to allow voltage-dependent Z-gate.
**
** Revision 1.3  2005/07/20 20:02:01  svitak
** Added standard header files needed by some architectures.
**
** Revision 1.2  2005/07/01 10:03:07  svitak
** Misc fixes to address compiler warnings, esp. providing explicit types
** for all functions and cleaning up unused variables.
**
** Revision 1.1.1.1  2005/06/14 04:38:34  svitak
** Import from snapshot of CalTech CVS tree of June 8, 2005
**
** Revision 1.12  2000/06/19 06:14:31  mhucka
** The xmin/ymin and xmax/ymax parameters in the interpol and hsolve
** structures are doubles.  Functions that read these values from input files
** (e.g., for implementing tabcreate actions) need to treat them as doubles,
** not as float, because on some platforms (e.g., IRIX 6.5.3 using IRIX's C
** compiler), treating them as float results in roundoff errors.
**
** Revision 1.11  2000/06/12 05:07:04  mhucka
** Removed nested comments; added NOTREACHED comments where appropriate.
**
** Revision 1.10  1999/10/17 22:30:09  mhucka
** Added changes from Erik De Schuter dated circa March 1999.
** The definitions of TabChannel_SAVE, TabChannel_READ, TabChannel_ptrs have
** been moved to tabfiles.c.
**
 * EDS22h revison: EDS BBF-UIA 99/03/17-99/03/25
 * Moved TAB_SAVE and TAB_READ actions to tabfiles.cMovedfiles.c
 *
 * EDS22d revison: EDS BBF-UIA 98/04/30-98/05/04
 * Added instantaneous gates to tab(2)channels
 *
** Revision 1.8  1997/05/29 08:35:19  dhb
** Update from Antwerp GENESIS version 21e
**
 * EDS21e revison: EDS BBF-UIA 97/05/03
 * Added code to check if EREST_ACT exists
 *
 * EDS21c revison: EDS BBF-UIA 95/08/02-95/10/05
 * Added ADD_GBAR msg and updated tabcurrent in TabChannel_SAVE and TabChannel_READ
 *
 * EDS20j revison: EDS BBF-UIA 95/07/24-95/08/11
 * Added DOMAINCONC msg and surface field
 * Updated ShowInterpol function call
 * Minor corrections to TabChannel_READ and TabChannel_SAVE
 *
 * EDS20i revison: EDS BBF-UIA 95/06/02
 * Added TAB_SAVE and TAB_READ actions.
 * Added olf_defs.h
 *
 * Revision 1.7  1996/08/06  20:52:43  dhb
 * Use GetScriptDouble() rather than get_script_float().
 *
 * Revision 1.6  1995/03/23  01:37:06  dhb
 * Added number of values to SAVE2 file format
 *
 * Revision 1.5  1995/03/21  01:00:46  venkat
 * Upi changes: Typecasted second argument to TabInterp() to double
 *
 * Revision 1.4  1994/10/04  23:01:21  dhb
 * Added TABDELETE action.
 *
 * Revision 1.3  1994/08/08  22:31:03  dhb
 * Changes from Upi.
 *
 * Revision 1.4  1994/06/13  22:52:24  bhalla
 * Added the SHOW and DUMP actions
 *
 * Revision 1.3  1994/05/26  13:52:10  bhalla
 * Changed syntax for SetTable
 *
 * Revision 1.2  1994/03/22  18:13:18  dhb
 * Change by Upi Bhalla for setting tables.
 *
 * Revision 1.1  1992/11/14  00:37:22  dhb
 * Initial revision
 *
*/

#include <math.h>
#include "olf_ext.h"
#include "olf_defs.h"
#include "olf_g@.h"
#include "result.h"
#include "symtab.h"

static double       savedata[3];

/* E. De Schutter Caltech 1/91, modified Z 4/91 */
/* Tabulated hh-like channel.  The standard voltage dependent 
**	activation (X) and inactivation (Y) factors are present. For
**	concentration dependent processes a third factor (Z) has
**	added.  Z can do a lot of things, most important is that 
**	it gets another message (type1: c) than X and Y (type 0: v). 
**	Standard use for Z is inactivation, just use a Zpower>0.  
**	Alternative is to use it for codependent activation, use
**	Zpower<0, z will equal c times v-dependent table-value.
** For computation efficiency the forward rate factor alpha (A) and 
**	1/tau (B) are tabulated. 
*/
/* debugged, TABFILL added, CALC_MINF, CALC_ALPHA, CALC_BETA added
** by U.S. Bhalla Caltech 2/91 */
/*
** Generalized integration scheme implemented July 1991 by Upi Bhalla 
*/
/*
** Cengiz Gunay - January 2006
** Added a Z_conc flag indicating that the Z gate is concentration dependent.
** If Z_conc is 0 then it is voltage-dependent. Both the hines solver and
** the original code is modified to handle these cases. Hines chanmodes
** 1 and 4 tested and validated.
*/

void TabChannel_CALC_MINF(channel,action)
register struct tab_channel_type *channel;
Action      *action;
{
double	alpha,beta;
char	*gate;
Interpol	*ipa = NULL,*ipb = NULL;
double	m;

    if(action->argc == 2){
	gate = action->argv[0];
		if (strcmp(gate,"X") == 0) {
			ipa = channel->X_A;
			ipb = channel->X_B; 
		} else if (strcmp(gate,"Y") == 0) {
			ipa = channel->Y_A;
			ipb = channel->Y_B;
		} else if (strcmp(gate,"Z") == 0) {
			ipa = channel->Z_A;
			ipb = channel->Z_B;
		}
    	channel->activation = Atof(action->argv[1]);
    } else {
    Error();
    printf("usage : CALC_MINF gate voltage\n");
    }
    /*
    ** calculate the steady state value of the state variable
    */
	alpha = TabInterp(ipa,(double)(channel->activation));
	/* remember that in tabchannels beta is 1/tau */
	beta = TabInterp(ipb,(double)(channel->activation));
    m = alpha/beta;
    action->passback = ftoa(m);
}


void TabChannel_CALC_ALPHA(channel,action)
register struct tab_channel_type *channel;
Action		*action;
{
double	alpha;
char	*gate;
Interpol	*ip = NULL;

    if(action->argc == 2){
	gate = action->argv[0];
		if (strcmp(gate,"X") == 0) {
			ip = channel->X_A;
		} else if (strcmp(gate,"Y") == 0) {
			ip = channel->Y_A;
		} else if (strcmp(gate,"Z") == 0) {
			ip = channel->Z_A;
		}
    	channel->activation = Atof(action->argv[1]);
    } else {
    Error();
    printf("usage : CALC_ALPHA gate voltage\n");
    }
    /*
    ** calculate the steady state value of the state variable
    */
	alpha = TabInterp(ip,(double)(channel->activation));
    action->passback = ftoa(alpha);
}

void TabChannel_CALC_BETA(channel,action)
register struct tab_channel_type *channel;
Action		*action;
{
double	alpha,beta;
char	*gate;
Interpol	*ipa = NULL,*ipb = NULL;

    if(action->argc == 2){
	gate = action->argv[0];
		if (strcmp(gate,"X") == 0) {
			ipa = channel->X_A;
			ipb = channel->X_B; 
		} else if (strcmp(gate,"Y") == 0) {
			ipa = channel->Y_A;
			ipb = channel->Y_B;
		} else if (strcmp(gate,"Z") == 0) {
			ipa = channel->Z_A;
			ipb = channel->Z_B;
		}
    	channel->activation = Atof(action->argv[1]);
    } else {
    Error();
    printf("usage : CALC_MINF gate voltage\n");
    }
    /*
    ** calculate the steady state value of the state variable
    */
	alpha = TabInterp(ipa,(double)(channel->activation));
	/* remember that in tabchannels beta is 1/tau */
	beta = TabInterp(ipb,(double)(channel->activation));
    beta -= alpha;
    action->passback = ftoa(beta);
}
