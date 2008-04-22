//------------------------------------------------------------------
/*!
 *  \file nsmsg.c
 *  \author Mando Rodriguez
 *
 *  This file contains the implementation for creating messages in
 *  objects in the Model Container. Currently does not support 
 *     GENESIS <--> model_container 
 *  message passing.
*/
//-------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"


#include "neurospaces/segment.h"  
#include "neurospaces/symbols.h"  
#include "neurospaces/symboltable.h"  
#include "neurospaces/pidinstack.h"

//t includes from our nsgenesis library
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/nsintegrator.h"



//-------------------------------------------------------------------
/*!
 *   \fn int NSmsg
 *   \return 0 on error, 1 on success.
 */
//-------------------------------------------------------------------
int NSmsg(const char *pcSrcpath, const char *pcDstpath, const char *pcTypename){


  struct symtab_HSolveListElement *phsleSrc = PidinStackParse("pcSrcpath");

  if(!phsleSrc){

    Error();
    printf("%s is not found in the Model Container.",phsleSrc);
    return 0;

  }


  struct symtab_HSolveListElement *phsleDst = PidinStackParse("pcDstpath");


  if(!phsleDst){

    Error();
    printf("%s is not found in the Model Container.",phsleDst);
    return 0;

  }









}
