
#include <math.h>
#include <stdio.h>	/* needed by stdlib.h on some archs */
#include <stdlib.h>
#include <string.h>
#include "olf_ext.h"
#include "olf_defs.h"


#include "nsintegrator.h"


static void SetupGeneric(int argc,char **argv,int mode);
void tweak_tab_values(int argc,char **argv,int mode);


/* Set up a tabulated channel from alpha-beta rate constants */
void SetupAlpha(argc,argv)
	int argc;
	char	**argv;
{
	SetupGeneric(argc,argv,SETUP_ALPHA);
}

/* Set up a tabulated channel from tau-minf rate constants */
void SetupTau(argc,argv)
	int argc;
	char	**argv;
{
	SetupGeneric(argc,argv,SETUP_TAU);
}


void TweakAlpha(argc,argv)
	int argc;
	char	**argv;
{
	tweak_tab_values(argc,argv,SETUP_ALPHA);
}

void TweakTau(argc,argv)
	int argc;
	char	**argv;
{
	tweak_tab_values(argc,argv,SETUP_TAU);
}




static void SetupGeneric(int argc,char **argv,int mode)
{
	char *args[15];	
      
	int i;
	int	iResult;
	int status;

	args[10]="3000";
	args[11]="inf";
	args[12]="inf";

	initopt(argc, argv, "channel-element gate AA AB AC AD AF BA BB BC BD BF -size n -range min max");
	while ((status = G_getopt(argc, argv)) == 1)
	  {
	    if (strcmp(G_optopt, "-size") == 0)
		args[10] = optargv[1];
	    else if (strcmp(G_optopt, "-range") == 0)
	      {
		args[11] = optargv[1];
		args[12] = optargv[2];
	      }
	  }

	if (status < 0)
	  {
	    printoptusage(argc, argv);
	    return;
	  }




      for(i=3;i<optargc;i++) args[i-3]=optargv[i];
	
      if(mode == SETUP_ALPHA)
	iResult = NSSetupAlpha(argv[1],argv[2],args,optargc);
      else if(mode == SETUP_TAU)
	iResult = NSSetupTau(argv[1],argv[2],args,optargc);


      return;

}



/*!
 *
 */
void tweak_tab_values(argc,argv,mode)
	int argc;
	char	**argv;
	int		mode;
{
	
	
	initopt(argc, argv, "channel-element table");
	if (G_getopt(argc, argv) != 0)
	{
		printoptusage(argc, argv);
		return;
	}

	
	if (mode==SETUP_ALPHA) 
	{



	} 
	else if (mode==SETUP_TAU) 
	{

	  NSTweakTau(argv[1],argv[2]);

	}


}
