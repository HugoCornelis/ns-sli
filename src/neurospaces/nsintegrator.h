/************************************************
 *
 * 
 *
 ************************************************/
#include "neurospaces_ext.h"
#include "heccer/heccer.h"


#ifndef NSINTEGRATOR_H
#define NSINTEGRATOR_H


#define NSINTEGRATOR_COMPARTMENT 0
#define NSINTEGRATOR_NEUTRAL 1




#define MAX_HECCERS 100
#define MAX_NSSYMBOLS 200


/****************************************************
 *  A struct for storing data for a neurospaces object
 *  created in the genesis SLI.
 ****************************************************/
struct neurospaces_symbol{


  char * pcPathname;  

  
  int iType;


  int iSerial;


  //struct symtab_HSolveListElement *phsle;



  /************************************
   * A pointer to a cooresponding 
   * genesis element.
   ***********************************/
  Element *pgenel;
  
};









/***************************************************
 *  A single data structure encapulates all relevant
 *  data members for proper integration with
 *  neurospaces.
 ***************************************************/
struct neurospaces_integrator{




  struct neurospaces_type *pelNeurospaces;


  /************************************
   * An array of neurospaces symbol
   * references for lookup in the 
   * genesis SLI.
   ************************************/
  struct neurospaces_symbol **ppSymbols;




  /************************************
   *
   * Number of symbols in the NSGenesis
   * Symbol table.
   *
   ************************************/
  int iNumSyms;





  /************************************
   * This is an array of heccer objects
   *
   ************************************/
  struct Heccer **ppHeccer;




  /*********************************
   * The number of Heccer instances
   *
   ********************************/
  int iHeccers;

  
};



int NSGenesisInitialize();
int HeccerCreate(char* idin);


/*************************************************************
 *
 * These are lookup functions for quickly finding elements created
 * in the genesis SLI that map to neurospaces objects.
 *
 **************************************************************/
int NeurospacesAddSymbol(char *name,int type);
struct neurospaces_symbol * NeurospacesGetSymbol(char *name);



#endif
