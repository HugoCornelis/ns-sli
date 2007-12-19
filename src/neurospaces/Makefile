# $Id: Makefile 1.8 Thu, 16 Mar 2006 17:09:27 -0600 hugo $

CC = $(CC_IN)
#CFLAGS = $(CFLAGS_IN)
CFLAGS 		= 	$(COPT)
CPP = $(CPP_IN)
LD = $(LD_IN)
LDFLAGS = $(LDFLAGS_IN)

INSTALL = $(INSTALL_IN)
RANLIB = $(RANLIB_IN)

# genesis related overhead

LIBRARY_NAME 	= 	neurospaces
STARTUP		=	neurospaceslib.g
STRUCTURES 	= 	neurospaces_struct.h
EXT_HEADER	= 	neurospaces_ext.h
TARGET_OBJ	=	neurospaceslib.o

GENESIS_INCLUDE	= 	-I. -I../sim -I../sys -I../ss -I../shell -I/usr/local/neurospaces/instrumentor -DPRE_PROTO_TRAVERSAL 


# ========================================
# Generic file-format macro definitions 
# ========================================

NEUROSPACESDIRS = \
	neurospaces

NEUROSPACESINCLUDEDIR = \
	neurospaces

# NEUROSPACESLIBS = \
# 	$(NEUROSPACESDIRS)/libneurospacesread.a

# ========================================


OBJECTS = \
	neurospacesread.o \
	neurospacesmodel.o \
	neurospacesquery.o \
	neurospacessetup.o \
	neurospacessupport.o


default: $(TARGET_OBJ)


SYMBOLTAB = $(LIBRARY_NAME)_d@.o $(LIBRARY_NAME)_g@.o $(LIBRARY_NAME)_l@.o

$(TARGET_OBJ): $(NEUROSPACESLIBS) $(OBJECTS) $(SYMBOLTAB)
	$(LD) $(LDFLAGS) -r -o $@ $(OBJECTS) $(SYMBOLTAB)

$(LIBRARY_NAME)_g@.c $(LIBRARY_NAME)_g@.h: $(STARTUP)
	- ../sys/code_g $(STARTUP) $(EXT_HEADER) $(LIBRARY_NAME)

$(LIBRARY_NAME)_d@.c : $(STRUCTURES) ../sys/code_sym
	- $(CPP) $(STRUCTURES) /tmp/$(STRUCTURES) $(GENESIS_INCLUDE)
	- ../sys/code_sym /tmp/$(STRUCTURES) $(LIBRARY_NAME) \
	  -I $(EXT_HEADER) -NI -o $(LIBRARY_NAME)_d@.c
	- rm /tmp/$(STRUCTURES)

$(LIBRARY_NAME)_l@.c: $(LIBRARY_NAME)_g@.c $(LIBRARY_NAME)_d@.c ../sys/code_lib $(OBJECTS)
	- ../sys/code_lib $(LIBRARY_NAME) -o $(LIBRARY_NAME)_l@.c

# $(NEUROSPACESLIBS): neurospaceslibs

# neurospaceslibs: 
# 	@(for subdir in $(NEUROSPACESDIRS); do echo cd $$subdir; cd $$subdir; env - PATH=$$PATH CPICOPT="" CXX="" FC="" CC="$(CC)" CFLAGS="$(CFLAGS)" CPP="$(CPP)" AR=ar YACC="$(YACC_IN)" ./configure; env - PATH=$$PATH make all; done)
# 	-(touch neurospaceslibs)

clean:
	@-(for subdir in $(NEUROSPACESDIRS); do echo cd $$subdir; cd $$subdir; make clean; done)
	-(rm -rf *.a *.o *@.[ch] neurospaceslibs) 

#################################

# Suffix Rules

################################

.c.o:
	$(CC) $(CFLAGS) -I$(NEUROSPACESINCLUDEDIR) -I$(GENESIS_INCLUDE) $< -c
