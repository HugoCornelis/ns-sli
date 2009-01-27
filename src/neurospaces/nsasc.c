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
int NSAscCreate(char *pcName, char *pcParent)
{

  char *pc;

  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  
  if(!pelnsintegrator)
    return -1;

  struct neurospaces_integrator *pnsintegrator
    = pelnsintegrator->pnsintegrator;

  if(!pnsintegrator)
    return -1;

  

  struct asc_file *pAscFile = AscCalloc(pcName);


  pnsintegrator->ppAscFiles[pnsintegrator->iAscFiles++] =
    pAscFile;


  return 1;

}

