#include <stdio.h>
#include "neurospaces_ext.h"
#include "neurospaces_g@.h"

void STARTUP_neurospaces() {
  GenesisObject* object;
  GenesisObject  tobject;
  char*          slotnames[50];
  char*          argv[50];
  AddAction("NEUROSPACES_READ", 20001);
  AddAction("NEUROSPACES_QUERY", 20002);
  AddAction("NEUROSPACES_SETUP", 20003);

  /* Definition of object neurospaces */
  BZERO(&tobject,sizeof(GenesisObject));
  tobject.name = "neurospaces";
  tobject.type = "neurospaces_type";
  tobject.size = sizeof(struct neurospaces_type);
  { extern int NeuroSpacesActor(); tobject.function = NeuroSpacesActor; HashFunc("NeuroSpacesActor", NeuroSpacesActor, "int"); }
  ObjectAddClass(&tobject,ClassID("device"),CLASS_PERMANENT);
  AddDefaultFieldList(&tobject);
  tobject.defaults = (Element*) calloc(1, tobject.size);
  AddObject(&tobject);
  object = GetObject("neurospaces");
  object->defaults->object = object;
  object->defaults->name = CopyString("neurospaces");
  object->author = "Hugo Cornelis";
  { extern int NeuroSpacesActor(); AddActionToObject(object, "CREATE", NeuroSpacesActor, 0) ? 0 : (Error(), printf("adding action 'CREATE' to object 'neurospaces'\n")); HashFunc("NeuroSpacesActor", NeuroSpacesActor, "int"); }
  { extern int NeuroSpacesActor(); AddActionToObject(object, "RESET", NeuroSpacesActor, 0) ? 0 : (Error(), printf("adding action 'RESET' to object 'neurospaces'\n")); HashFunc("NeuroSpacesActor", NeuroSpacesActor, "int"); }
  { extern int NeuroSpacesActor(); AddActionToObject(object, "NEUROSPACES_READ", NeuroSpacesActor, 0) ? 0 : (Error(), printf("adding action 'NEUROSPACES_READ' to object 'neurospaces'\n")); HashFunc("NeuroSpacesActor", NeuroSpacesActor, "int"); }
  { extern int NeuroSpacesActor(); AddActionToObject(object, "NEUROSPACES_QUERY", NeuroSpacesActor, 0) ? 0 : (Error(), printf("adding action 'NEUROSPACES_QUERY' to object 'neurospaces'\n")); HashFunc("NeuroSpacesActor", NeuroSpacesActor, "int"); }
  { extern int NeuroSpacesActor(); AddActionToObject(object, "NEUROSPACES_SETUP", NeuroSpacesActor, 0) ? 0 : (Error(), printf("adding action 'NEUROSPACES_SETUP' to object 'neurospaces'\n")); HashFunc("NeuroSpacesActor", NeuroSpacesActor, "int"); }
  object->description = "Neurospaces interface\n";
  FieldListMakePermanent(object);
  MsgListMakePermanent(object);

/* Script variables */

} /* STARTUP_neurospaces */
