

#ifndef NEUROSPACES_SETUP_H
#define NEUROSPACES_SETUP_H


struct ProjectionQuery *
NeuroSpacesModelGetProjectionQuery(struct neurospaces_type *pneuro);

void NeuroSpacesModelSetupLock(struct neurospaces_type *pneuro);

void NeuroSpacesModelSetupUnlock(struct neurospaces_type *pneuro);

int neurospacessetup(struct neurospaces_type *pneuro,int argc,char *argv[]);


#endif


