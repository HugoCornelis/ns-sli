//------------------------------------------------------------------
/*!
 *  \file nsasc.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for ascii output from a 
 *  heccer object accessible in the ns-sli.
*/
//-------------------------------------------------------------------
#include <stdio.h>


#include "nsintegrator.h"

struct asc_file * getAscFile(char *pcName);
static struct asc_file * AscCalloc(char *pcName);



/*!
 *  \fn static struct asc_out * AscCalloc()
 *
 */
static struct asc_file * AscCalloc(char *pcName)
{

  struct asc_file *asc = (struct asc_file*)calloc(1,sizeof(struct asc_file));

  if(!asc)
    return NULL;

  asc->pcName = strdup(pcName);

  return asc;

} 

/*!
 *  \fn void NSAscCreate()
 *  \return -1 on error, 0 on success.
 */
/* int NSAscCreate(char *pcName, char *pcParent) */
/* { */

/*   char *pc; */

/*   struct nsintegrator_type *pelnsintegrator */
/*     = (struct nsintegrator_type *)GetElement("/neurospaces_integrator"); */

  
/*   if(!pelnsintegrator) */
/*     return -1; */

/*   struct neurospaces_integrator *pnsintegrator */
/*     = pelnsintegrator->pnsintegrator; */

/*   if(!pnsintegrator) */
/*     return -1; */

  
/*   char pcPathName[1024]; */
/*   bzero(pcPathName,1024); */

/*   int iLen = strlen(pcParent); */

/*   sprintf(pcPathName,"%s",pcParent,iLen); */
/*   sprintf(&pcPathName[iLen],"%s",pcName,strlen(pcName)); */


/*   struct asc_file *pAscFile = AscCalloc(pcPathName); */


/*   pnsintegrator->ppAscFiles[pnsintegrator->iAscFiles++] = */
/*     pAscFile; */


/*   return NSINTEGRATOR_ASCFILE; */

/* } */


/*!
 *  \fn int NSSetAscField(char *pcPathname, char *pcField, char *pcValue)
 *  \param pcPathname
 *  \param pcField
 *  \param pcValue
 *  \return 1 if set correctly, 0 if not set, -1 on error. 
 */
int NSSetAscField(char *pcPathname, char *pcField, char *pcValue)
{


  struct asc_file *asc = getAscFile(pcPathname);

  if(!asc)
  {

    fprintf(stderr,"Error: Ascii Object %s not found.\n",pcPathname);
    return -1;

  }

  if(!strcmp(pcField,"append"))
  {

    asc->iAppend = atoi(pcValue);

    return 1;

  }
  else if(!strcmp(pcField,"filename"))
  {

    asc->pcFilename = strdup(pcValue);

    return 1;

  }
  else if(!strcmp(pcField,"flush"))
  {

    asc->iFlush = atoi(pcValue);

    return 1;

  }
  else if(!strcmp(pcField,"leave_open"))
  {

    asc->iLeaveOpen = atoi(pcValue);

    return 1;

  }
  else


    return 0;

}



/*!
 *  \fn int ascExists(char *pcName)
 *  \param pcName Name of asc_file to search for.
 *  \return 1 if present, 0 if not present.
 */
/* struct asc_file * getAscFile(char *pcName) */
/* { */

/*   struct nsintegrator_type *pelnsintegrator */
/*     = (struct nsintegrator_type *)GetElement("/neurospaces_integrator"); */

  
/*   if(!pelnsintegrator) */
/*     return NULL; */

/*   struct neurospaces_integrator *pnsintegrator */
/*     = pelnsintegrator->pnsintegrator; */

/*   if(!pnsintegrator) */
/*     return NULL; */

/*   struct asc_file **ppAscFiles = pnsintegrator->ppAscFiles; */
/*   int iAscFiles = pnsintegrator->iAscFiles; */
/*   int i; */

/*   for( i=0; i < iAscFiles; i++) */
/*   { */

/*     if(ppAscFiles[i]) */
/*     { */

/*       if(!strcmp(ppAscFiles[i]->pcName,pcName)) */
/* 	return ppAscFiles[i]; */

/*     } */

/*   } */

/*   return NULL; */

/* } */



//---------------------------------------------------------
/*!
 *  \fn int NSAscReset(char *pcName)
 *  \param pcName The name of the asc_file object to reset.
 *  \return -1 on error, 1 on success.
 */
//---------------------------------------------------------
int NSAscReset(char *pcName)
{


  struct asc_file *pasc = getAscFile(pcName);

  if(!pasc)
  {
    
    fprintf(stdout,"Error: asc_file object %s not found.\n",pcName);
    fprintf(stdout,"%s","Reset could not be performed.\n");

    return -1;

  }

  

  //-
  //- If the output generator is not already allocated then we 
  //- allocate it here.
  //-
  if(!pasc->pogAsc)
  {

    pasc->pogAsc = OutputGeneratorNew(pasc->pcFilename);

    if(!pasc->pogAsc)
    {

      fprintf(stdout,
	      "Error: Could not create file %s for asc_object %s.\n",
	      pasc->pcFilename,
	      pasc->pcName);

      return -1;

    }

  }


  if(OutputGeneratorInitiate(pasc->pogAsc) == -1)
  {

    fprintf(stdout,
	    "Error: Cound open file \"%s\" for write in asc_file %s\n",
	    pasc->pcFilename,
	    pasc->pcName);

    return -1;

  }

  return 1;
}
