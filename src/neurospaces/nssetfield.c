//------------------------------------------------------------------
/*!
 *  \file nssetfield.c
 *  \author Mando Rodriguez
 *
 *
*/
//------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

#include "nsintegrator.h"
#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"

//------------------------------------------------------------------
/*!
 *  \fn int NeurospacesSetField(struct symtab_HSolveListElement *phsle,char *field,char *value)
 *  \return 0 on error, 1 on success.
 *  \param phsle A pointer to an Hsolve list element.
 *  \param ppist A Pidin stack for searching for child objects.
 *  \param field A field value to 
 *  \param value The value to place in the field given in the previous argument.
 *
 *  Function sets a field for an Hsolve list element and maps a value to it. This
 *  is done via direct operations on the model container data struct. The steps 
 *  for this are as follows:
 *
 *  1. Allocate Parameter.
 *  2. Set Parameter Value.
 *  3. Use the FIXED function.
 *  4. Link parameter list to phsle.
 *  5. Generate a parameter from the numerical value.
*/
//------------------------------------------------------------------
int NeurospacesSetField(struct symtab_HSolveListElement *phsle, 
			struct PidinStack *ppist,
			char *pcPathname, char *field, char *value){

 


  //!
  //! -The parameter fields "Ik" and "Gk" are solved variables in 
  //!  Heccer so they don't need a parameter to be set at all, thus they
  //!  are ignored completely.
  //!
  if(!phsle || 
     !strcmp(field,"Ik") || 
     !strcmp(field,"Gk") )
    return 0;
  




  //-
  //- Check the type on the phsle object passed. For certain types
  //- we must add parameters to the child objects rather than the object
  //- itself.
  //-
  //  if (phsle->iType == TYPE_CHANNEL_TABLEFILE){
  if (instanceof_channel(phsle)){



    //-
    //- Parameter Xpower is set in the HH gate object, which
    //- is set as a child to the phsle object in the model container.
    //- 
    //-    Channel -> 
    //-               HH_gate -parameter-> Xpower
    //-
    //- is the order we must traverse the stack to get to the object.. 
    //-
    if (strcmp(field, "Xpower") == 0){

      
      struct PidinStack *ppistGate = PidinStackDuplicate(ppist);

      //-
      //- Allocate a new string copy so that it can
      //- be modified to get to child objects
      //-

      struct symtab_HSolveListElement *phsleGate = 
	  PidinStackPushStringAndLookup(ppistGate,"HH_activation");
    
      PidinStackFree(ppistGate);

      if(!phsleGate)
	return 0;

      return setParameter(phsleGate,field,value,SETPARA_GENESIS2);


    }
    else if (strcmp(field, "Ypower") == 0){



/*       struct symtab_HSolveListElement *phsleGate =  */
/* 	PidinStackPushStringAndLookup(ppist,"HH_inactivation"); */


/*       if(!phsleGate) */
/* 	return 0; */

/*       return setParameter(phsleGate,field,value,SETPARA_GENESIS2); */


   
      return 1;
    }
    else if(strcmp(field,"Zpower") == 0){ return 1; }
  }

  return setParameter(phsle,field,value,SETPARA_GENESIS2);

}





