//genesis

/*********************************************************************

** neurospaces related functionality

********************************************************************/
addaction	 NSINTEGRATOR_DUMP	20101



/*************************************************************************

** global variables

*************************************************************************/

//int  HECCER_DUMP_SERVICE = 128
int HECCER_DUMP_SERVICE = {2 ** 7}
int  HECCER_DUMP_INDEXERS_SUMMARY = 256
int  HECCER_DUMP_INDEXERS_STRUCTURE = 512
int  HECCER_DUMP_INTERMEDIARY_COMPARTMENTS_PARAMETERS = 2
int  HECCER_DUMP_INTERMEDIARY_COMPARTMENT_SUMMARY = 4
int  HECCER_DUMP_INTERMEDIARY_MECHANISM_SUMMARY = 8
int  HECCER_DUMP_INTERMEDIARY_STRUCTURE = 16
int  HECCER_DUMP_INTERMEDIARY_SUMMARY = 32
int  HECCER_DUMP_TABLE_GATE_SUMMARY = 4096
int  HECCER_DUMP_TABLE_GATE_TABLES = 8192
int  HECCER_DUMP_VM_COMPARTMENT_MATRIX = 65536
int  HECCER_DUMP_VM_COMPARTMENT_DATA = 131072
int  HECCER_DUMP_VM_COMPARTMENT_OPERATIONS = 262144
int  HECCER_DUMP_VM_MECHANISM_DATA = 524288
int  HECCER_DUMP_VM_MECHANISM_OPERATIONS = 1048576
int  HECCER_DUMP_VM_CHANNEL_POOL_FLUXES = 2097152
int  HECCER_DUMP_VM_SUMMARY = 4194304
int  HECCER_DUMP_VM_AGGREGATORS = 33554432


int HECCER_DUMP_ALL =  {HECCER_DUMP_INDEXERS_SUMMARY + \			
			HECCER_DUMP_INDEXERS_STRUCTURE + \
			HECCER_DUMP_INTERMEDIARY_COMPARTMENTS_PARAMETERS + \
			HECCER_DUMP_INTERMEDIARY_COMPARTMENT_SUMMARY + \		
			HECCER_DUMP_INTERMEDIARY_MECHANISM_SUMMARY + \
			HECCER_DUMP_INTERMEDIARY_STRUCTURE + \	
			HECCER_DUMP_INTERMEDIARY_SUMMARY + \
			HECCER_DUMP_TABLE_GATE_SUMMARY + \
			HECCER_DUMP_TABLE_GATE_TABLES + \
			HECCER_DUMP_VM_COMPARTMENT_MATRIX + \
			HECCER_DUMP_VM_COMPARTMENT_DATA + \
			HECCER_DUMP_VM_COMPARTMENT_OPERATIONS + \
			HECCER_DUMP_VM_MECHANISM_DATA + \
			HECCER_DUMP_VM_MECHANISM_OPERATIONS + \
			HECCER_DUMP_VM_CHANNEL_POOL_FLUXES + \
			HECCER_DUMP_VM_SUMMARY + \
			HECCER_DUMP_VM_AGGREGATORS}	


/*************************************************************************
**                         NeuroSpaces objects                         **
*************************************************************************
*/
//==========================================================================
//	name		data		function		class	
//==========================================================================



object	 nsintegrator  nsintegrator_type  NeurospacesIntegratorActor	genesis3 \
	-author 	"Mando Rodriguez" 	\
	-actions	PROCESS RESET CHECK CREATE NSINTEGRATOR_DUMP 	\
	-description	"Neurospaces Integration"
					

addfunc		set_nsintegrator_verbose_level			do_set_nsintegrator_verbose_level		int


