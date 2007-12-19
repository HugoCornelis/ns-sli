

#include "neurospaces/neurospaces.h"


/// **************************************************************************
///
/// SHORT: neurospaces_read_model()
///
/// ARGS.:
///
///	std. genesis script functions args.
///
///	argv[].: files to parse or options
///
/// RTN..: int : success of operation
///
/// DESCR: parse given files
///
///	just calls neurospacesparse()
///
/// **************************************************************************

int neurospaces_read_model(int argc,char *argv[])
{
    //- call parser routine

    struct Neurospaces *pneuro = NeurospacesNewFromCmdLine(argc,argv);
}


