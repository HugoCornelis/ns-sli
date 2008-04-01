//genesis

/*********************************************************************

** neurospaces related functionality

********************************************************************/
addaction	NSINTEGRATOR_CREATE	20101
addaction	NSINTEGRATOR_PROCESS	20102
addaction	NSINTEGRATOR_RESET	20103


/*************************************************************************
**                         NeuroSpaces objects                         **
*************************************************************************
*/
//==========================================================================
//	name		data		function		class	
//==========================================================================



object	 nsintegrator  nsintegrator_type  NeurospacesIntegratorActor	device	\
	-author 	"Captain Falcon" 	\
	-actions	NSINTEGRATOR_RESET NSINTEGRATOR_PROCESS NSINTEGRATOR_PROCESS 	\
	-description	"Neurospaces Integration"
