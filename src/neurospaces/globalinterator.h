//---------------------------------------------------------------
/*!
 *   \file nsintegrator_struct.h
 *   
 *   This file holds the neurospaces integrator data structure
 *   for compilation into the GENESIS SLI.
 */
//---------------------------------------------------------------


//---------------------------------------------------------------
/*!
 *  \struct neurospaces_integrator
 *
 *  A single data structure encapulates all relevant
 *  data members for proper integration with the
 *  Neurospaces model container and Heccer.
 */
//----------------------------------------------------------------
struct neurospaces_integrator{



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
  struct Heccer **ppHeccer; 
   


  /*!
   *    The number of Heccer instances in the ppHeccer array
   */
  int iHeccers; 

  
};
//------ end neurospaces_integrator -------------------------------
