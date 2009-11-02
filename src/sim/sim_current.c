static char rcsid[] = "$Id: sim_current.c,v 1.2 2005/06/27 19:00:58 svitak Exp $";

/*
** $Log: sim_current.c,v $
** Revision 1.2  2005/06/27 19:00:58  svitak
** Added explicit types to untyped functions and fixed return values as
** appropriate. Initialized values explicitly when it was unclear if
** they were being used uninitialized (may not apply to all files being
** checked in in this batch).
**
** Revision 1.1.1.1  2005/06/14 04:38:28  svitak
** Import from snapshot of CalTech CVS tree of June 8, 2005
**
** Revision 1.3  2001/04/25 17:17:01  mhucka
** Misc. small changes to improve portability and address compiler warnings.
**
** Revision 1.2  1993/07/21 21:31:57  dhb
** fixed rcsid variable type
**
 * Revision 1.1  1992/10/27  19:48:13  dhb
 * Initial revision
 *
*/

#include <stdio.h>
#include <string.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

/* static Element *recent_element; */
static Connection *recent_connection;
/* static Element *working_element; */

static char recent_element_name[1000] = "";

static char working_element_name[1000] = "";

Element *WorkingElement()
{
    return(GetElement(working_element_name));
}

char *WorkingElementName()
{
    return(working_element_name);
}

void SetWorkingElement(char *parent_name, char *element_name)
{
    if (parent_name)
    {
	strcpy(working_element_name, parent_name);

	if (strlen(working_element_name))
	{
	    if (working_element_name[strlen(working_element_name) - 1] != '/')
	    {
		strcat(working_element_name, "/");
	    }
	}

	strcat(working_element_name, element_name);
    }
    else
    {
	strcpy(working_element_name, element_name);
    }

    if (working_element_name[0] != '/')
    {
	char pc[1000];

	strcpy(pc, working_element_name);

	sprintf(working_element_name, "/%s", pc);
    }

    //- now remove redundant path entries such as './'

    {
	struct PidinStack *ppistWorking
	    = PidinStackParse(working_element_name);

	PidinStackCompress(ppistWorking);

	PidinStackString(ppistWorking, working_element_name, sizeof(working_element_name));

	PidinStackFree(ppistWorking);
    }
}

void SetRecentElement(char *parent_name, char *recent_name)
{
    if (parent_name)
    {
	strcpy(recent_element_name, parent_name);

	if (strlen(recent_element_name))
	{
	    if (recent_element_name[strlen(recent_element_name) - 1] != '/')
	    {
		strcat(recent_element_name, "/");
	    }
	}

	strcat(recent_element_name, recent_name);
    }
    else
    {
	strcpy(recent_element_name, recent_name);
    }

    if (recent_element_name[0] != '/')
    {
	char pc[1000];

	sprintf(pc, "%s/%s", working_element_name, recent_element_name);

	strcpy(recent_element_name, pc);
    }

    //- now remove redundant path entries such as './'

    {
	struct PidinStack *ppistRecent
	    = PidinStackParse(recent_element_name);

	PidinStackCompress(ppistRecent);

	PidinStackString(ppistRecent, recent_element_name, sizeof(recent_element_name));

	PidinStackFree(ppistRecent);
    }
}

Element *RecentElement()
{
    return(GetElement(recent_element_name));
}

char *RecentElementName()
{
    return(recent_element_name);
}

void SetRecentConnection(connection)
Connection *connection;
{
    recent_connection = connection;
}

Connection *RecentConnection()
{
    return(recent_connection);
}
