//------------------------------------------------------------------
/*!
 *  \file nssymboltable.c
 *  \author Mando Rodriguez
 *
 *  This file contains functions for adding, searching, and printing
 *  out neurospaces_struct entries in the Neurospaces global
 *  integrator.
*/
//-------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

//t includes from our nsgenesis library
#include "neurospaces_ext.h"
#include "nsintegrator.h"







//-----------------------------------------------------------------
/*!
 *  \fn int NeurospacesAddSymbol(char *name,int type)
 *  \return -1 on error, 1 on success
 *  \param pcname A char array with the name to look up for mapping.
 *  \param type The type for the Neurospaces symbol.
 *  \sa neurospaces_symbol, pelnsintegrator.
 *
 *  Function maps a neurospaces_smybol in the global integrator
 *  to a like-named entry in the GENESIS symbol table.This allows 
 *  access to GENESIS objects via setting the pgel pointer to the
 *  cooresponding object. 
 */
//-----------------------------------------------------------------
int NeurospacesAddSymbol(char *pcname, int type){

  struct neurospaces_symbol *pSymbol;

  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct neurospaces_integrator *pnsintegrator
    = pelnsintegrator->pnsintegrator;

  if( pnsintegrator->iNumSyms > MAX_NSSYMBOLS ){
    
    //todo
    //todo make this realloc when the symtab gets full
    //todo
    fprintf(stderr,"Neurospaces symbol table is full\n");
    return -1;
  }

  pSymbol = 
    (struct neurospaces_symbol*)calloc(1,sizeof(struct neurospaces_symbol));

  if(!pSymbol){
    
    fprintf(stderr,"Error placing \'%s\' into the Symbol Table.\n",pcname);
    return -1;

  }
   
  pSymbol->iType = type;
  pSymbol->pcPathname = pcname;

  //t
  //t place the allocated symbol with pointer to the neurospaces members
  //t into the global symbol table and increment the number of symbols.
  //t
  pnsintegrator->ppSymbols[pnsintegrator->iNumSyms++] = 
    pSymbol;


  return 1;

}





//-----------------------------------------------------------------
/*!
 *  \fn struct neurospaces_symbol * NeurospacesGetSymbol(char *name);
 *  \return A pointer to a neurospaces_symbol data struct,NULL if not found.
 *  \param pcname A char array with the symbol name you want to look up.
 *  \sa neurospaces_symbol
 *
 *  Retrieves a neurospaces_symbol with the name that matches argument
 *  pcname. 
 */
//-----------------------------------------------------------------
struct neurospaces_symbol * NeurospacesGetSymbol(char *pcname){

  int i;

  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct neurospaces_integrator *pnsintegrator
    = pelnsintegrator->pnsintegrator;

  if(!pnsintegrator)
    return NULL;

  if( !pnsintegrator->ppSymbols)
    return NULL;

  struct neurospaces_symbol **symbols = pnsintegrator->ppSymbols;


  for(i=0;i<MAX_NSSYMBOLS;i++){

    if(!symbols[i])
      continue;

    if(!strcmp(pcname,symbols[i]->pcPathname))
      return symbols[i];

  }

  return NULL;

}





//----------------------------------------------------------------------------
/*!
 * \fn void NeurospacesPrintSymbols()
 * \sa ppSymbols, pelnsintegrator
 * 
 *  Prints out all symbols names in the symbol table in the Neurospaces 
 *  Integrator.
 */
//-----------------------------------------------------------------------------
void NeurospacesPrintSymbols(){

  int i;

  struct nsintegrator_type *pelnsintegrator
    = (struct nsintegrator_type *)GetElement("/neurospaces_integrator");

  struct neurospaces_integrator *pnsintegrator
    = pelnsintegrator->pnsintegrator;

  if(!pnsintegrator)
    return;

  struct neurospaces_symbol **symbols = pnsintegrator->ppSymbols;
  
  for(i=0;i<pnsintegrator->iNumSyms;i++){

    fprintf(stdout,"Symbolname:%s at index [%i]\n",symbols[i]->pcPathname,i);

  }

}






//-------------------------------------------------------------------------------
/*!
 * \fn void NeurospacesMapGenel(Element *pel)
 * \param pel A pointer to a GENESIS element.
 *
 * Maps a genesis Element to a cooresponding Neurospaces symbol if it exists.
 *
 */
//-------------------------------------------------------------------------------
void NeurospacesMapGenel(Element *pel){

  if(!pel)
    return;


  char *pc = Pathname(pel);
  // printf("Setting element: %s\n",pc);
  struct neurospaces_symbol *pNsSym = NeurospacesGetSymbol(pc);

  if(!pNsSym)
    return;

  //  printf("Mappped element: %s\n",pNsSym->pcPathname);
  pNsSym->pgenel = pel;

}
