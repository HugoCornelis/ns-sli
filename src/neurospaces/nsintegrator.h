//------------------------------------------------------------------
/*!
 *  \file nsintegrator.h
 *  \author Mando Rodriguez
 *
 *  This file contains the necessary data structures and functions 
 *  for communication between the GENESIS SLI and components 
 *  in the Neurospaces projects Model Container and Heccer. 
*/

/*!
 *  \mainpage Neurospaces GENESIS backward compatability layer.
 *
 *  This is developer documentation for the GENESIS 3 backward compatability
 *  layer. 
 */
//-------------------------------------------------------------------

#include "heccer/heccer.h"
#include "heccer/output.h"
#include "heccer/pulsegen.h"
#include "heccer/neurospaces/heccer.h"
#include "neurospaces_ext.h"
#include "neurospaces/symboltable.h"

// Object includes.
#include "ascfile_struct.h"
#include "hsolve_struct.h"
#include "nsintegrator_struct.h"
#include "pulsegen_struct.h"

#ifndef NSINTEGRATOR_H
#define NSINTEGRATOR_H


//i
//i These are constant definitions for the neurospaces
//i to genesis integrator functions.
//i
#define NSINTEGRATOR_COMPARTMENT 10
#define NSINTEGRATOR_NEUTRAL 20
#define NSINTEGRATOR_TABCHANNEL 30
#define NSINTEGRATOR_POOL 40
#define NSINTEGRATOR_NERNST 50
#define NSINTEGRATOR_SYNCHAN 60
#define NSINTEGRATOR_ASCFILE 70
/* #define NSINTEGRATOR_ASCOUT 80 */
#define NSINTEGRATOR_SPIKEGEN 90
#define NSINTEGRATOR_PULSEGEN 100

//!
//! Used in nsetfield.c
//! These are flags for passing to setParameter() that
//! allow using different functions of the model container
//! to be called. 
//!

int
ChannelSetField
(struct symtab_HSolveListElement *phsleWorking,
 struct PidinStack *ppistWorking,
 char *pcPathname,
 char *pcField,
 char *pcValue);

int NSSetField(struct symtab_HSolveListElement *phsle, 
	       struct PidinStack *ppist,
	       char *pcPathname, char *pcField, char *pcValue);


//-- Defines for determining parameter types --
#define SETPARA_GENESIS2 2
#define SETPARA_NUM 3
#define SETPARA_STRING 4
#define SETPARA_FIELD 5
#define SETPARA_HERE 6
//---------------------------------------------


//-- Defines for determining solver types --
#define SOLVER_HECCER 1 
#define SOLVER_PULSEGEN 2
//------------------------------------------


#define MAX_HECCERS 100
#define MAX_ASCFILES 200


#define NUMBER_OF_MESSAGES 1000

#define HARDCODED_ROOT "hardcoded_neutral"



/*!
 * \struct SLI name to model-container mapper
 *
 * Associates a field name in the SLI with a parameter name in the model-container.
 *
 */

struct ParameterMapper
{
    /*!
     * name of the parameter in the G2 SLI
     */

    char *pcSLI;

    /*!
     * name of the parameter in the NS model-container
     */

    char *pcModelContainer;

    /*!
     * flags
     */

    int iFlags;
};


// \define this parameter is set at the SLI side using a scaled value and unscaling is not allowed.

#define SLI_PARAMETER_SCALED 1

// \define this parameter is scaled to compartment surface

#define SLI_PARAMETER_SCALED_TO_COMPARTMENT_SURFACE 2

// \define this parameter is scaled to compartment length

#define SLI_PARAMETER_SCALED_TO_COMPARTMENT_LENGTH 4

// \define this parameter is always has a numeric value

#define SLI_PARAMETER_NUMBER 8


/*!
 * \struct ioMsg
 *
 * A struct for storing parameters for a message to be processed after
 * performing a reset.
 */
struct ioMsg
{
    /*! for an activation message to post process after a
     *  reset: source element in the model container.
     */

    char *pcSourceSymbol;

    struct PidinStack *ppistSource;
    struct symtab_HSolveListElement *phsleSource;

    char *pcTargetSymbol;

    struct PidinStack *ppistTarget;
    struct symtab_HSolveListElement *phsleTarget;

    /*!
     *  A serial ID for an actication message to post process after a reset. 
     * synaptic activation messages
     */
    int iTarget;

    /*!
     * the target value in the solver
     */

    double *pdValue;

    /*!
     * field of activation message
     */
    char *pcSourceField;


    char *pcMsgName;

    /*!
     * has this message been integrated in the run-time
     */

    int iRunTime;

    /*!
     * the value of activation
     */
    double dValue;

    
    int iHeccerIndex;

};


/*!
 * \struct SolverInstance
 * \todo probably need to change this to a union.
 * a solver instance with the options used to instantiate it.
 */

struct SolverInstance
{
    int iOptions;

    struct Heccer *pheccer;
    
    struct simobj_PulseGen *ppg;
};


struct SolverRegistration
{
    /*!
     * Name of this registration: pointer into the element namespace.
     */

    char *pcName;

    /*!
     * Has been disabled using the 'disable' command?
     */

    int iDisabled;

    /*!
     * Type of the solver.
     */

    int iType;

    /*!
     * Solver instance associated with this name, may be NULL.
     */

    union
    {
	struct SolverInstance si;
    }
	uSolver;
};


//---------------------------------------------------------------
/*!
 *  \struct neurospaces_integrator
 *
 *  A single data structure encapulates all relevant
 *  data members for proper integration with the
 *  Neurospaces model container and Heccer.
 */
//----------------------------------------------------------------
struct neurospaces_integrator {



  /*!
   *  A pointer to the Neurospaces to GENESIS element  
   *  in the Genesis symbol table.
   */
  struct neurospaces_type *pelNeurospaces; 
                                          



  /*!
   *   A pointer to the Cached Root HSolveListElement 
   *   in the Neurospaces Model Container Parse Tree. 
   */
  struct symtab_HSolveListElement * phsleCachedRoot;  
                                                    


  /*!
   *   A pointer to the Root of the Pidin stack found at Idin "/"
   *
   */
  struct PidinStack * ppistCachedRoot; 






/*   /*! */
/*    *   Number of symbols in the NSGenesis symbol table. */
/*    * */
/*   int iNumSyms;  */





  /*!
   *  A pointer to a Heccer representation in the GENESIS SLI.
   */
  //struct neurospaces_type *pelHeccer; 
  struct Heccer *pheccerOptions;



    /*!
     *  Number of registrations of models to be simulated.
     */

    int iModelRegistrations;

    struct SolverRegistration *psr;

  /*!
   *    The number of Heccer instances in the ppheccer array
   */
/*   int iHeccers;  */
 

  /*!
   *   This is an array of Heccer structs.
   */
/*   struct Heccer **ppheccer;  */
   



  /*!
   * The number of heccer names registered. 
   */
/*   int iHeccerNames; */


  /*!
   * An array of character strings which are used in the creation of heccer
   * objects bearing the same name as a neutral rooted object to be used in the 
   * model container.
   */
/*   char **ppcHeccerNames; */





  /*!
   * An array of IO messages which are executed during a reset.
   */
  struct ioMsg **ppioMsg;


  int iIoMsgs;



};
//------ end neurospaces_integrator -------------------------------





//i -- Defined in filters.c --
int NSFilterCreate(char *pcType);


//i -- Defined in nsintegrator.c --
int NSGenesisInitialize();


//i -- Defined in heccercreate.c --
int AttemptHeccerName(char *pcName);
int SetSolverOptions(char *pcName, int iOptions);
int DisableHeccerName(char *pcName);
int TranslateHeccerNames(struct neurospaces_integrator *pnsintegrator);
int InitHeccerObject(struct SolverRegistration *psr);
struct Heccer *LookupHeccerObject(char *pcContext);


//i -- Defined in heccerreset.c --
void singleHeccerStatus(struct Heccer *pheccer);


//i -- Defined in nssymboltable.c --
int NeurospacesAddSymbol(char *pcname,int type);
struct neurospaces_symbol * NeurospacesGetSymbol(char *pcname);


//- -- Defined in nscomm.c --
char * mapParameterString(char *pcfield);
struct ParameterMapper * mapParameter(char *pcfield);
struct symtab_Parameters *newParameter(char *pcValue, int iType);
int setParameter(struct PidinStack *ppist,
		 struct symtab_HSolveListElement *phsle,
		 char *pcField, char *pcValue,int iFlag);
int setParameterNumber(struct PidinStack *ppist,
		       struct symtab_HSolveListElement *phsle,
		       char *pcField, double dNumber);
/* struct symtab_HSolveListElement * lookupGateKinetic(char *pcName, char *pcField, char *pcAorB); */
struct PidinStack * lookupGate(char *pcName, char *pcField);
/* struct symtab_HSolveListElement * NSLookupHSolveListElement(char *pcPath); */
struct PidinStack * getGateContext(char *pcName, char *pcField, char *pcAorB);
struct symtab_InputOutput * CreateInputOutput(char *pcContext, int iType);
struct neurospaces_integrator *getNsintegrator();
char *getRootedPathname(char *pc);
struct PidinStack *getRootedContext(char *pc);



//- -- Defined in nscreate.c --
int NSCreate( char* name,  char* pcParent, char* pcType);

//- -- Defined in nssetup.c --
int NSSetupAlpha( char *pcName, char *pcField, char **pcArgs, 
		  int iArgc);





//-- Defined in nsintegratorverbose.c --
int nsintegrator_dump(struct nsintegrator_type *pelnsintegrator, int iSelection, int heccer_dump_selection);
int get_nsintegrator_verbose_level(void);
int set_nsintegrator_verbose_level(int iLevel);
int do_set_nsintegrator_verbose_level(int argc, char **argv);


//-- Defined in nsasc.c --
int NSSetAscField(char *pcPathname, char *pcField, char *pcValue);

//-- Defined in nscopy.c --
int NSCopy(struct PidinStack *ppistSrc, char *pcDst, int iKeepPrototypeTraversal);

//-- Defined in nscopy.c --
int NSMove(struct PidinStack *ppistSrc, char *pcDst, char *pcName, int iIndex);

//-- Defined in hsolveactor.c --
char * do_findsolvefield();
int undo_findsolvefield(char **ppcElement, char **ppcField);


//- -- Defined in nscall.c --

//-- Defined in nsmsg.c --
int NSmsg(char *pcSrcpath, char *pcDstpath, char *pcTypename, char *pcField);

//- -- Defined in nsgetfield.c --
char* NSGetField(char *pcPathname,char *pcField);
char * GetHeccerVariable(char *pcName,char *pcParameter);

//- Defined in nslistcommands.c --
void NSListCommands();

//- Defined in nsshowfield.c --
int NSShowField(int argc,char **argv);
int PrintHeccerVariable(char *pcName,char *pcParameter,int iAll);

//- Defined in nspulsegen.c --
//

//- -- Defined in sim_main.c --
int sli_main(int argc, char **argv, char **envp, struct Neurospaces *pneuro);


#endif
