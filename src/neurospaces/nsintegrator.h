//------------------------------------------------------------------
/*!
 *  \file nsintegrator.h
 *  \author Mando Rodriguez
 *
 *  This file contains the necessary data structures and functions 
 *  for communication between the GENESIS SLI and components 
 *  in the Neurospaces projects Model Container and Heccer. 
*/
//-------------------------------------------------------------------

#include "neurospaces_ext.h"
#include "heccer/heccer.h"
#include "nsintegrator_struct.h"

#ifndef NSINTEGRATOR_H
#define NSINTEGRATOR_H


//i
//i These are constant definitions for the neurospaces
//i to genesis integrator functions.
//i
#define NSINTEGRATOR_COMPARTMENT 10
#define NSINTEGRATOR_NEUTRAL 20
#define NSINTEGRATOR_TABCHANNEL 30




#define MAX_HECCERS 100
#define MAX_NSSYMBOLS 200





//---------------------------------------------------------------
/*!
 *  \struct neurospaces_integrator
 *
 *  A single data structure encapulates all relevant
 *  data members for proper integration with the
 *  Neurospaces model container and Heccer.
 */
//----------------------------------------------------------------
struct neurospaces_integrator {



  /*!
   *  A pointer to the Neurospaces to GENESIS element  
   *  in the Genesis symbol table.
   */
  struct neurospaces_type *pelNeurospaces; 
                                          



  /*!
   *   A pointer to the Cached Root HSolveListElement 
   *   in the Neurospaces Model Container Parse Tree. 
   */
  struct symtab_HSolveListElement * phsleCachedRoot;  
                                                    


  /*!
   *   A pointer to the Root of the Pidin stack found at Idin "/"
   *
   */
  struct PidinStack * ppistCachedRoot; 



  /*!
   *  An array of neurospaces symbol references for lookup in the
   *  GENESIS SLI. 
   */
  struct neurospaces_symbol **ppSymbols;  
                                         



  /*!
   *   Number of symbols in the NSGenesis symbol table.
   */
  int iNumSyms; 





  /*!
   *  A pointer to a Heccer representation in the GENESIS SLI.
   */
  struct neurospaces_type *pelHeccer; 
  



  /*!
   *   This is an array of Heccer structs.
   */
  struct Heccer **ppheccer; 
   


  /*!
   *    The number of Heccer instances in the ppheccer array
   */
  int iHeccers; 

  
};
//------ end neurospaces_integrator -------------------------------





//-----------------------------------------------------------
/*!
 *  \struct neurospaces_symbol
 *
 *  A struct for storing data for a neurospaces object
 *  created in the genesis SLI.
 *
 */
//------------------------------------------------------------
struct neurospaces_symbol {



  /*!
   *   The name of this symbol.
   */
  char * pcPathname; 





  /*!
   *   The defined type of this symbol.
   */
  int iType; 





  /*!
   *    The serial ID for retrieving the neurospaces instance. 
   */
  int iSerial; 


  //struct symtab_HSolveListElement *phsle;


  /*!
   *    A pointer to a mapped GENESIS element in the GENESIS SLI.
   */
  Element *pgenel; 
  
};
//------- end neurospaces_symbol ----------------------------





//i -- Defined in nsintegrator.c --
int NSGenesisInitialize();


//i -- Defined in heccercreate.c --
int HeccerCreate(char* idin);


//i -- Defined in heccerreset.c --
void singleHeccerStatus(struct Heccer *pheccer);




//i -- Defined in nssymboltable.c --
int NeurospacesAddSymbol(char *pcname,int type);
struct neurospaces_symbol * NeurospacesGetSymbol(char *pcname);


//  --Defined in nscomm.c --
struct symtab_HSolveListElement * PidinStackGetPhsle(struct PidinStack *ppist, 
							  char *pcName);
int PidinStackPushString(struct PidinStack *ppist,char *pcName);




#endif
