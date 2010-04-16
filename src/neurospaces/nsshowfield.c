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
			       char *pcPar,int iAll);



/*!
 *
 * \return 1 on success, -1 on error, 0 on not found in model container.
 */
int NSShowField(int argc,char **argv)
{
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
    return(-1);
  }

  
  char *pcPathname;

  pcPathname = optargv[1];


  struct PidinStack *ppist = getRootedContext(pcPathname);

  struct symtab_HSolveListElement *phsle = PidinStackLookupTopSymbol(ppist); 

  if (!phsle)
  {
/*       fprintf(stdout, "element not found\n"); */

      return(0);
  }
   

  int i;
  printf("\n[ %s ]\n",pcPathname);

  for( i=2; i < argc; i++)
  {

    if(argv[i]==NULL || 
       !strcmp(argv[i],"") )
      break;
    else if( argv[i][0] == '-')
      continue;


    if(!strcmp(argv[i],"*"))
    {
      // displays all fields;
      SymbolPrintParameterTraversal(phsle, ppist);
      return 1;

    }
    else if(!strcmp(argv[i],"**"))
    {

      // just does the same as "*"
      SymbolPrintParameterTraversal(phsle, ppist);
      return 1;

    }
    else{

      int iResult = PrintHeccerVariable(pcPathname, argv[i], all);
      if( iResult > 0 )
      {
	return 1;
      }

      PrintParameterBasic(phsle, ppist, argv[i], all);

    }

  }





  return 1;

}




/*
 *
 */
static int PrintParameterBasic(struct symtab_HSolveListElement *phsle,
			       struct PidinStack *ppist,
			       char *pcPar,int iAll)
{


  char *pcMappedPar = mapParameterString(pcPar);
      

  if(iAll == 1)
  {

    struct symtab_Parameters *ppar = SymbolFindParameter(phsle, ppist, pcMappedPar);

    ParameterPrintInfoRecursive(ppar, ppist, 0, stdout);

    return 1;

  }

  double dValue = SymbolParameterResolveValue(phsle,ppist,pcMappedPar);

  if (dValue != DBL_MAX)
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








//------------------------------------------------------------
/*
 * \return returns the number of items printed.
 *
 * Prints a parameter if present in any heccer instance.  
 */
//------------------------------------------------------------
int PrintHeccerVariable(char *pcName,char *pcField,int iAll)
{


  int iItemsPrinted = 0;

  struct neurospaces_integrator *pnsintegrator = getNsintegrator();

  struct PidinStack *ppist = PidinStackParse(pcName);

  PidinStackUpdateCaches(ppist);

  int iSerial = PidinStackToSerial(ppist);

  int i;
  double *pdValue = NULL;

  for (i = 0 ; i < pnsintegrator->iModelRegistrations ; i++)
  {

    if (!pnsintegrator->psr[i].uSolver.si.pheccer)
    {

      if(!strcmp(pcField,"Vm"))
      {
	fprintf(stdout,"%s","Warning: No simulation has been run, Vm is not available.\n\n");
      }

      continue;
    }

    pdValue = HeccerAddressVariable(pnsintegrator->psr[i].uSolver.si.pheccer, iSerial, pcField);

    if(!pdValue)
      continue;


    if(iAll)
    {
      PrintIndent(0, stdout);
      fprintf(stdout,"%s","type: solved variable\n");
      PrintIndent(0,stdout);
      fprintf(stdout,"heccer instance: %d\n", i);
      PrintIndent(0, stdout);
      fprintf(stdout,"heccer serial id: %d\n",iSerial);
      PrintIndent(0, stdout);
      fprintf(stdout, "value: %g\n", (*pdValue));
      iItemsPrinted++;
    }
    else
    {
      fprintf(stdout,"%s\t%e\n\n",pcField,(*pdValue));
      iItemsPrinted++;
    }

  }

  return iItemsPrinted;
}



