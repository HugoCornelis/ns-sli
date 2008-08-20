//------------------------------------------------------------------
/*!
 *  \file nssetup.c
 *  \author Mando Rodriguez
 *
 *
*/
//------------------------------------------------------------------
#include <stdio.h>
#include "shell_func_ext.h"
#include "sim_ext.h"
#include <string.h>
#include "nsintegrator.h"

#include "neurospaces/function.h"
#include "neurospaces/neurospaces_ext.h"
#include "neurospaces/pidinstack.h"







/* Convert a sparsely filled table to tabchannel/tabgate format
** starting from alpha-beta or tau-minf values. Optionally
** do the TABFILL, but this is not yet implemented */
void tweak_tab_values(argc,argv,mode)
	int argc;
	char	**argv;
	int		mode;
{
/* 	Element	*elm; */
/* 	Interpol	*A,*B; */
/* 	float temp,temp2; */
/* 	int i; */
/* 	int	tab_gate_flag=0; */
/* 	Interpol *create_interpol(); */

/* 	A=B=NULL; */

/* 	initopt(argc, argv, "channel-element table"); */
/* 	if (G_getopt(argc, argv) != 0) */
/* 	  { */
/* 		printoptusage(argc, argv); */
/* 		return; */
/* 	  } */

/* 	elm = GetElement(optargv[1]); */
/* 	if (!elm) { */
/* 		printf("Element '%s' not found\n",optargv[1]); */
/* 		return; */
/* 	} */
/* 	if (strcmp(elm->object->name,"tabgate")==0) { */
/* 		A=((struct tab_gate_type *)elm)->alpha; */
/* 		B=((struct tab_gate_type *)elm)->beta; */
/* 		tab_gate_flag=1; */
/* 	} */
/* 	if (strcmp(elm->object->name,"tabchannel")==0) { */
/* 		if (strcmp(optargv[2],"X")==0) { */
/* 			A=((struct tab_channel_type *)elm)->X_A; */
/* 			B=((struct tab_channel_type *)elm)->X_B; */
/* 		} else if (strcmp(optargv[2],"Y")==0) { */
/* 			A=((struct tab_channel_type *)elm)->Y_A; */
/* 			B=((struct tab_channel_type *)elm)->Y_B; */
/* 		} else if (strcmp(optargv[2],"Z")==0) { */
/* 			A=((struct tab_channel_type *)elm)->Z_A; */
/* 			B=((struct tab_channel_type *)elm)->Z_B; */
/* 		} else { */
/* 			printf("Gate type %s not known in %s \n",optargv[2],optargv[0]); */
/* 			return; */
/* 		} */
/* 	} */
/* 	if (!A || !B) { */
/* 		printf("Error: Element %s should be a tabgate or tabchannel\n", */
/* 			optargv[1]); */
/* 		return; */
/* 	} */
/* 	if (mode==SETUP_ALPHA) { */


/* 		for(i=0;i<=A->xdivs;i++) */
/* 			B->table[i]+=A->table[i]; */


/* 	} else if (mode==SETUP_TAU) { */


/* 		for(i=0;i<=A->xdivs;i++) { */
/* 			temp=A->table[i]; */
/* 			temp2=B->table[i]; */

/* 			/* */
/* 			** per discussion with Mike Vanier */
/* 			*/ 
/* 			if (fabs(temp) < SING_TINY) { */
/* 			    if (temp < 0.0) */
/* 				temp = -SING_TINY; */
/* 			    else */
/* 				temp = SING_TINY; */
/* 			} */

/* 			A->table[i]=temp2/temp; */
/* 			B->table[i]=1.0/temp; */
/* 		} */
/* 	} */
}



void TweakAlpha(int argc,char **argv)
{
  return;
}

void TweakTau(int argc,char **argv)
{
  int x = 0;
  return;
}
