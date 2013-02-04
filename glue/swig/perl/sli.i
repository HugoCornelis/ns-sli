/* -*- C -*- */

/* swig -perl5 -makedefault -module Heccer heccer.i */
/* gcc -c heccer_wrap.c `perl -MExtUtils::Embed -e ccopts`  */
/* gcc -shared heccer_wrap.o -L. -lheccer -o heccer.so */

%module SwiggableSLI

%{
#include "src/config.h"
/* #include "src/shell/shell_func_ext.h" */


%}

%inline %{

/* #include <setjmp.h> */

/// integer array handling

//t use array generics, see carray.i

int *int_array(int size)
{
    return (int *) malloc(sizeof(int) * size);
}
void int_destroy(int *a)
{
    free(a);
}
void int_set(int *a, int i, int val)
{
    a[i] = val;
}
int int_get(int *a, int i)
{
    return a[i];
}

/// double array handling

//t use array generics, see carray.i

double *double_array(int size)
{
    return (double *) malloc(sizeof(double) * size);
}
void double_destroy(double *a)
{
    free(a);
}
void double_set(double *a, int i, double val)
{
    a[i] = val;
}
double double_get(double *a, int i)
{
    return a[i];
}

// \todo the implementation of the following functions is a work
// around for linker problems.  A variant of the same hack is also
// present in c2genesis.c, no idea why.

/* int memusage () { return 0; } */

/* void sim_set_float_format () {} */

// \todo when I use jmp_buf, I get an incompatible types during
// compilation, with an int it works, although that is obviously a
// hack to get the work around to work.

/* jmp_buf */ int main_context;

/* float G_RNG () { return 0.0; } */

struct Neurospaces;

extern int sli_main(int argc, char **argv, char **envp, struct Neurospaces *pneuro);

int IncludeG2Model(char *pcMorphologyDirectory, char *pcScript, void *pvNeurospaces, char *pcSimrc)
{
    //- the modeling service is neurospaces

    struct Neurospaces *pneuro = (struct Neurospaces *)pvNeurospaces;

    char *argv[20];

    int argc = 0;

    argv[argc++] = "ns-sli";

    argv[argc++] = "-batch";

    argv[argc++] = "-notty";

    argv[argc++] = "-altsimrc";

    if (!pcSimrc)
    {
	pcSimrc = "/local_home/local_home/hugo/neurospaces_project/ns-sli/source/snapshots/0/.simrc-ns-sli";
    }

    argv[argc++] = pcSimrc;

    if (pcMorphologyDirectory)
    {
	argv[argc++] = "-morphology-directory";

	argv[argc++] = pcMorphologyDirectory;
    }

    argv[argc++] = "-models-only";

    argv[argc++] = "-no-exit";

    argv[argc++] = "-no-interactive";

    if (pcScript)
    {
	argv[argc++] = pcScript;
    }

    // At first sight, it seems that envp is not used, so I pass a
    // NULL pointer for it.

    int iFail = sli_main(argc, argv, NULL, pneuro);

    return(iFail == 0);
}


int IncludeG2Script(char *pcScript)
{
    extern int      IncludeScript();

    char *argv[10];

    argv[0] = pcScript;

    int iIncluded = IncludeScript(1, argv);

    return(iIncluded);
}


int RunG2Model(char *pcMorphologyDirectory, char *pcScript, void *pvNeurospaces, char *pcSimrc)
{
    //- the modeling service is neurospaces

    struct Neurospaces *pneuro = (struct Neurospaces *)pvNeurospaces;

    char *argv[20];

    int argc = 0;

    argv[argc++] = "ns-sli";

    argv[argc++] = "-batch";

    argv[argc++] = "-notty";

    argv[argc++] = "-altsimrc";

    if (!pcSimrc)
    {
	pcSimrc = "/local_home/local_home/hugo/neurospaces_project/ns-sli/source/snapshots/0/.simrc-ns-sli";
    }

    argv[argc++] = pcSimrc;

    if (pcMorphologyDirectory)
    {
	argv[argc++] = "-morphology-directory";

	argv[argc++] = pcMorphologyDirectory;
    }

/*     argv[argc++] = "-models-only"; */

    argv[argc++] = "-no-exit";

    argv[argc++] = "-no-interactive";

    if (pcScript)
    {
	argv[argc++] = pcScript;
    }

    // At first sight, it seems that envp is not used, so I pass a
    // NULL pointer for it.

    int iFail = sli_main(argc, argv, NULL, pneuro);

    return(iFail == 0);
}


int RunInterpreter(int iSomething)
{
    Interpreter();
}


int ListObjects()
{
    do_list_objects();
}


int ListCommands()
{
    char *argv[2];

    argv[0] = "listcommands";

    ShowFuncNames(1,argv);
}


int PrintCommandList()
{
    NSListCommands();
}


/* int G2Initialize(char *pcOptionsOrSo) */
/* { */
/*     /// \note gosh, I had to do the same hack when integrating neurospaces */
/*     /// \note with genesis2/hsolve. */

/*     struct ParserContext *pacRoot = pneuro->pacRootContext; */

/*     struct ImportedFile *pifRoot */
/* 	= ParserContextGetImportedFile(pacRoot); */

/*     /// \note depending on how the linking is done, there can be multiple */
/*     /// \note instances of neurospaces around.  The following is a hack to */
/*     /// \note enforce the singleton (a bit) */

/* /*     fprintf(stdout, "HeccerConstruct(): root import is %p\n", ImportedFileGetRootImport()); * */

/*     ImportedFileSetRootImport(pifRoot); */
/* } */


%}

%include "src/config.h"
/* %include "src/shell/shell_func_ext.h" */

