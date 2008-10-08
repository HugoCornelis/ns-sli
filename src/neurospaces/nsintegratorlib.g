//genesis

/*********************************************************************

** neurospaces related functionality

********************************************************************/
addaction	 NSINTEGRATOR_DUMP	20101



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

HECCER_DUMP_ALL                                         (0xffffffff & ~HECCER_DUMP_SERVICE)
HECCER_DUMP_SERVICE					(1 << 7)
HECCER_DUMP_INDEXERS_SUMMARY				(1 << 8)
HECCER_DUMP_INDEXERS_STRUCTURE				(1 << 9)
HECCER_DUMP_INTERMEDIARY_COMPARTMENTS_PARAMETERS	(1 << 1)
HECCER_DUMP_INTERMEDIARY_COMPARTMENT_SUMMARY		(1 << 2)
HECCER_DUMP_INTERMEDIARY_MECHANISM_SUMMARY		(1 << 3)
HECCER_DUMP_INTERMEDIARY_STRUCTURE			(1 << 4)
HECCER_DUMP_INTERMEDIARY_SUMMARY			(1 << 5)
HECCER_DUMP_TABLE_GATE_SUMMARY				(1 << 12)
HECCER_DUMP_TABLE_GATE_TABLES				(1 << 13)
HECCER_DUMP_VM_COMPARTMENT_MATRIX			(1 << 16)
HECCER_DUMP_VM_COMPARTMENT_DATA				(1 << 17)
HECCER_DUMP_VM_COMPARTMENT_OPERATIONS			(1 << 18)
HECCER_DUMP_VM_MECHANISM_DATA				(1 << 19)
HECCER_DUMP_VM_MECHANISM_OPERATIONS			(1 << 20)
HECCER_DUMP_VM_CHANNEL_POOL_FLUXES			(1 << 21)
HECCER_DUMP_VM_SUMMARY					(1 << 22)
HECCER_DUMP_VM_AGGREGATORS				(1 << 25)


