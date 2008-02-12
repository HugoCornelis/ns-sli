#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"

/*
 *
 *
 */
//t allocate parameter
//t set parameter value
//t use the FIXED function
//t link parameter list to phsle
int NeurospacesSetField(Element	*element, char *field, char *value){

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


   return 1;
}


