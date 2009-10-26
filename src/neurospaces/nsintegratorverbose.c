
#include "nsintegrator.h"

int iNSIntegratorVerbose = 0;


int do_set_nsintegrator_verbose_level(argc,argv)
int	argc;
char	**argv;
{
    int iLevel = 0;

    /*  get previous trace level */

    int iResult = get_nsintegrator_verbose_level();

    /* parse options */

    initopt(argc, argv, "level");
    if (G_getopt(argc, argv))
    {
	printoptusage(argc, argv);
	return(iResult);
    }

    /* get trace level */

    iLevel = atoi(argv[1]);

    /* set trace level in parse tree evaluation routines */

    set_nsintegrator_verbose_level(iLevel);

    /* return previous level */

    return(iResult);
}


int set_nsintegrator_verbose_level(int iLevel)
{
  iNSIntegratorVerbose = iLevel;

  return(iLevel);
}

int get_nsintegrator_verbose_level(void)
{
  return(iNSIntegratorVerbose);
}

int nsintegrator_dump(struct nsintegrator_type *pelnsintegrator, int iSelection, int heccer_dump_selection)
{



    if (iSelection & 1)  
     {  
/*         struct Heccer **ppheccer = pelnsintegrator->pnsintegrator->ppheccer;   */

        int i;  
        for (i = 0 ; i < pelnsintegrator->pnsintegrator->iModelRegistrations ; i++)
	{
	  if(pelnsintegrator->pnsintegrator->psr[i].uSolver.pheccer)
	    HeccerDump(pelnsintegrator->pnsintegrator->psr[i].uSolver.pheccer, stdout, heccer_dump_selection);  

	}

      }  

    if (iSelection & 2)  
      {  
        //t print some info about the model container  
      }  

    if (iSelection & 4)  
      {  
        //t print some global information about simulator state  
      }  

  return 1;
}
