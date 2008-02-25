#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

//t includes from our nsgenesis library
#include "neurospaces_ext.h"
#include "nsintegrator.h"



extern struct neurospaces_integrator *pNeurospacesIntegrator;




/*************************************************************************************
 *  Function adds a symbol to the global neurospaces symbol table for symbol lookups.
 *************************************************************************************/
int NeurospacesAddSymbol(char *pcpathname, int type){

  struct neurospaces_symbol *pSymbol;

  if( pNeurospacesIntegrator->iNumSyms > MAX_NSSYMBOLS ){
    
    //todo
    //todo make this realloc when the symtab gets full
    //todo
    fprintf(stderr,"Neurospaces symbol table is full\n");
    return -1;
  }

  pSymbol = 
    (struct neurospaces_symbol*)calloc(1,sizeof(struct neurospaces_symbol));

  if(!pSymbol){
    
    fprintf(stderr,"Error placing \'%s\' into the Symbol Table.\n",pcpathname);
    return -1;

  }
   
  pSymbol->iType = type;
  pSymbol->pcPathname = pcpathname;

  //t
  //t place the allocated symbol with pointer to the neurospaces members
  //t into the global symbol table and increment the number of symbols.
  //t
  pNeurospacesIntegrator->ppSymbols[pNeurospacesIntegrator->iNumSyms++] = pSymbol;


  return 1;

}



/**************************************************************************
*
* function retrieves a symbol from the global neurospaces symbol table.
* 
**************************************************************************/
struct neurospaces_symbol * NeurospacesGetSymbol(char *name){

  int i;
  struct neurospaces_symbol **symbols = pNeurospacesIntegrator->ppSymbols;

  for(i=0;i<MAX_NSSYMBOLS;i++){

    if(!strcmp(name,symbols[i]->pcPathname))
      return symbols[i];

  }

  return NULL;

}


/*****************************************************************
 * prints out all symbols names in the nsgenesis symtable
 ****************************************************************/
void NeurospacesPrintSymbols(){

  int i;
  struct neurospaces_symbol **symbols = pNeurospacesIntegrator->ppSymbols;

  for(i=0;i<pNeurospacesIntegrator->iNumSyms;i++){

    fprintf(stdout,"Symbolname:%s at index [%i]\n",symbols[i]->pcPathname,i);

  }

}
