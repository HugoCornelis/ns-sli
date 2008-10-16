struct nsintegrator_type {
  char *name; int index; struct object_type *object; short flags; short nextfields; char **extfields; float x; float y; float z; unsigned int nmsgin; Msg *msgin; Msg *msgintail; unsigned int nmsgout; Msg *msgout; Msg *msgouttail; GenesisObject *compositeobject; Element *componentof; Element *parent; Element *child; Element *next;
  struct neurospaces_integrator *pnsintegrator;
  int heccer_dump_selection;
  int heccer_reporting_granularity;
};
