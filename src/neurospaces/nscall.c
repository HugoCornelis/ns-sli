//------------------------------------------------------------------
/*!
 *  \file nscall.c
 *  \author Mando Rodriguez
 *
 *  This file contains functions for parsing out GENESIS calls made
 *  to objects that are in the model-container and have no presensce 
 *  in the element namespace.
 * 
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "shell_func_ext.h"
#include "sim_ext.h"

#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"

#include "nsintegrator.h"






//--------------------------------------------------------------------
/*
*
*/
//--------------------------------------------------------------------
int NSCall(int argc, char **argv){



  if(!strcmp(argv[2],"TABCREATE")){

    if (argc < 4) {
      printf("usage : %s field xdivs xmin xmax\n","tabcreate");
      return(0);
    }



    if( NSTabCreate(argc,argv) == 0 ){

      Error();
      printf("%s : Error performing Tabcreation in model-container on '%s'.\n",
	     argv[0],argv[2]);
      return 0;
    }

    OK();
    return 1;


  }//=end TABCREATE case



}






//-------------------------------------------------------------
/*
 *
 */
//--------------------------------------------------------------
int nsCallCheck(char *pcCall){
  
  char *NeurospacesCalls[] = {
    "TABCREATE",
    "TABFILL",
    NULL,
  };


  int i;
  for(i=0;NeurospacesCalls[i] != NULL; i++){

    if(!strcmp(pcCall,NeurospacesCalls[i]))
      return 1;

  }

  return 0;

}
