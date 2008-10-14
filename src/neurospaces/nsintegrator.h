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
#define NSINTEGRATOR_POOL 40


//!
//! Used in nsetfield.c
//! These are flags for passing to setParameter that
//! allow using different functions of the model container
//! to be called. 
//!
#define SETPARA_GENESIS2 2
#define SETPARA_NUM 3
#define SETPARA_STRING 4

#define MAX_HECCERS 100
#define MAX_NSSYMBOLS 200



#define MODELCONTAINER_ROOT "hardcoded_neutral"



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
  //struct neurospaces_type *pelHeccer; 
  struct Heccer *pheccerOptions;


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


//- -- Defined in nscomm.c --
int setParameter(struct symtab_HSolveListElement *phsle,
		 char *pcField, char *pcValue,int iFlag);


//- -- Defined in nssetup.c --
int NSSetupAlpha( char *pcName, char *pcField, char **pcArgs, 
		  int iArgc);





//-- Defined in nsintegratorverbose.c --
int nsintegrator_dump(struct nsintegrator_type *pelnsintegrator, int iSelection, int heccer_dump_selection);
int get_nsintegrator_verbose_level(void);
int set_nsintegrator_verbose_level(int iLevel);
int do_set_nsintegrator_verbose_level(argc,argv);


//- -- Defined in nscall.c --

#endif
