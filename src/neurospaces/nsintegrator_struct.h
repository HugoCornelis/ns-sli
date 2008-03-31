//---------------------------------------------------------------
/*!
 *   \file nsintegrator_struct.h
 *   
 *   This file contains the neurospaces integrator data structure
 *   which serves as a bridge between GENESIS and the Neurospaces
 *   model container. This creates a data type in GENESIS
 *   to make the integrator available from the SLI.
 */
//---------------------------------------------------------------



#ifndef NSINTEGRATOR_STRUCT_H
#define NSINTEGRATOR_STRUCT_H



#include "struct_defs.h"



//---------------------------------------------------------------
/*!
 *  \struct nintegrator_type
 *
 */
//----------------------------------------------------------------
struct nsintegrator_type {

 
  ELEMENT_TYPE

  struct neurospaces_integrator *pnsintegrator;


  
};
//------ end nsintegrator_type -------------------------------


#endif
