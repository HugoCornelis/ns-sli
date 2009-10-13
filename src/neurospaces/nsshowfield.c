//------------------------------------------------------------------
/*!
 *  \file nssetfield.c
 *  \author Mando Rodriguez
 *
 *  File contains the code for setting element fields for model container
 *  objects that are referenced in the GENESIS namespace.
*/
//------------------------------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include "sim_ext.h"
#include "shell_func_ext.h"

#include <heccer/addressing.h>
#include "nsintegrator.h"
#include "neurospaces/function.h"
#include "neurospaces/pidinstack.h"



static int PrintParameterBasic(struct symtab_HSolveListElement *phsle,
			       struct PidinStack *ppist,
			       char *pcPar);


/*!
 *
 * \return 1 on success, -1 on error, 0 on not found in model container.
 */
int NSShowField(int argc,char **argv)
{

  int iInModelContainer = 0;
  int status = 0;
  int all = 0;
  int basic = 0;
  int describe = 0;
  initopt(argc, argv, "[path[:connections]] [field] ... -all -basic -describe");
  while ((status = G_getopt(argc, argv)) == 1)
  {
    if (strcmp(G_optopt, "-all") == 0)
      all = 1;
    else if (strcmp(G_optopt, "-basic") == 0)
      basic = 1;
    else if (strcmp(G_optopt, "-describe") == 0)
      describe = 1;
  }

  if (status < 0)
  {
    printoptusage(argc, argv);
    return;
  }

  
  char *pcPathname;

  pcPathname = optargv[1];


  struct PidinStack *ppist = PidinStackParse(pcPathname);

  struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist); 


  //
  // If no symbol if found then we exit and let GENESIS continue 
  // to process the request.
  //
  if(!phsle)
  {
    return 0;
  }
  else
  {
    iInModelContainer = 1;
  }


  {
    

    int i;
    printf("\n[ %s ]\n",pcPathname);

    for( i=2; i < argc; i++)
    {

      if(argv[i]==NULL || 
	 !strcmp(argv[i],"") )
	break;
      else if( argv[i][0] == '-')
	continue;


      PrintParameterBasic(phsle,ppist,argv[i]);
      
/*       if(all) */
/*       { */

/*       } */
/*       else */
/*       { */
	
/*       } */


    }



  }

  return 1;

}



/*
 *
 */
static int PrintParameterBasic(struct symtab_HSolveListElement *phsle,
			       struct PidinStack *ppist,
			       char *pcPar)
{


  char *pcMappedPar = mapParameterString(pcPar);
      
  //struct symtab_Parameters *ppar = SymbolFindParameter(phsle, ppist, pcMappedPar);

  double dValue = SymbolParameterResolveValue(phsle,ppist,pcMappedPar);

  if (dValue != FLT_MAX)
  {
    //fprintf(stdout, "%s", "---\n");
    
    //ParameterPrint(ppar,1,0,stdout);
    fprintf(stdout,"%s\t%e\n\n",pcPar,dValue);


  }
  else
  {
    fprintf(stdout,"Error: Object has no field called %s.\n",pcPar);
    return -1;
  }

}
