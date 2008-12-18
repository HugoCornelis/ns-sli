//------------------------------------------------------------------
/*!
 *  \file nssetelement.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for setting fields in 
 *  the Neurospaces Model Container compartments created via the
 *  GENESIS SLI.
*/
//------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"


#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"

//i
//i allocate parameter
//i set parameter value
//i use the FIXED function
//i link parameter list to phsle
//i

//-----------------------------------------------------------------------------
/*!
 *  \fn int NeurospacesSetElement(Element *element, char *field, char *value)
 *  \param element A pointer to a GENESIS element in the GENESIS namespace.
 *  \param field A pointer to a string indicating the element field.
 *  \param value A string with the value to place in the element field.
 *  \return 0 on error, 1 on success.
 *  \sa NeurospacesSetField
 *  \deprecated  see NeurospacesSetField.
 *  
 */
//-----------------------------------------------------------------------------
int NeurospacesSetElement(Element *element, char *field, char *value){

   double dValue = atof(value);
   char *pcParameter = strdup(field);
   struct PidinStack *ppist = (struct PidinStack *)element;

   struct symtab_HSolveListElement *phsle
		= PidinStackLookupTopSymbol(ppist);


   if (!phsle){
      printf("Warning: cannot find elements in the model container\n");
      return 0;
   }

   struct symtab_Function *pfun = FunctionCalloc();
		  
   struct symtab_Parameters *ppar
       =  ParameterNewFromNumber(pcParameter, dValue);
		  
   FunctionSetName(pfun,"FIXED");
   FunctionAssignParameters(pfun,ppar);

   printf("set field %s to %s\n",field,value);
   return 1;
}


