#include "heccer/heccer.h"

#include "neurospaces_defs.h"
#include "neurospaces_ext.h"
#include "neurospaces_struct.h"

#include <stdio.h>

/***************************************
 *
 *
 **************************************/
struct Heccer * HeccerCalloc(){


   struct Heccer *pheccer = (struct Heccer *)calloc(1, sizeof(struct Heccer));


   if(!pheccer)
     return NULL;
   
   

   if( !HeccerInitialize(pheccer) )
     return NULL;
   
   
     
   
   return pheccer;
}
