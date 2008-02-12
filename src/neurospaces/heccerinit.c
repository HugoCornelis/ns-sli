#include "heccer/heccer.h"

#include "neurospaces_defs.h"
#include "neurospaces_ext.h"
#include "neurospaces_struct.h"

#include <stdio.h>

/***************************************************
 *
 *
 ***************************************************/
int HeccerInitialize(){


   struct Heccer *pheccer = (struct Heccer *)calloc(1, sizeof(struct Heccer));


   if(!pheccer){
      
     fprintf(stderr,"Error Initializing Heccer instance.\n");
     return 0;

   }
   
   if( HeccerInitialize(pheccer) ){
      
     fprintf(stderr,"Error Initializing Heccer instance.\n");
     return 0;

   }
   
   
   return 1;
}
