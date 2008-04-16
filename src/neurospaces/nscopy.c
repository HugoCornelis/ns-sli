//------------------------------------------------------------------
/*!
 *  \file nscopy.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for copying objects in
 *  the Neurospaces Model Container via the GENESIS scripting 
 *  language.
*/
//-------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"


#include "neurospaces/segment.h"  
#include "neurospaces/symbols.h"  
#include "neurospaces/symboltable.h"  
#include "neurospaces/pidinstack.h"

//t includes from our nsgenesis library
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/nsintegrator.h"


//-------------------------------------------------------------------
/*
 *   Function copies an Element into a newly allocated element with 
 *   name pcDstname.
 */
//-------------------------------------------------------------------
int NSCopy(const Element* pelSrcelement, char *pcDstname){


  struct symtab_HSolveListElement *phsleDstelement = NULL;
  struct PidinStack* ppistDstelement = NULL;
  struct symtab_IdentifierIndex* pidinDstelement;

  char *pcDstElementname = strdup(pcDstname);
  pidinDstelement = IdinNewFromChars(pcDstElementname);


  
  if(!pidinDstelement){

    fprintf(stderr,"Could not create Element %s\n",pcDstname);
    return 0;

  }


  struct symtab_HSolveListElement *phsleSrcelement = 
      (struct symtab_HSolveListElement*)pelSrcelement;


  int iType = phsleSrcelement->iType;

   
  phsleDstelement = SegmentCreateAlias(phsleSrcelement,
				       pidinDstelement);

  /*   phsleDstelement = CellCreateAlias(phsleSrcelement, */
/* 				       pidinDstelement); */

  

  return 1;
}
