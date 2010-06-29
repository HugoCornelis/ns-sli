shelldir = $(top_builddir)/src/shell
simdir = $(top_builddir)/src/sim
scriptdir = $(top_builddir)/src/script
utildir = $(top_builddir)/src/util
nsdir = $(top_builddir)/src/neurospaces
hierarchy = ${prefix}/neurospaces/instrumentor

c2genesisdir = $(top_builddir)/src/c2genesis
c2genesis = $(c2genesisdir)/c2genesis
makestructs = $(c2genesisdir)/makestructs
makelib = $(c2genesisdir)/makelib


# \todo these variables are relative to builddir, should be relative to srcdir

INCLUDES = -I$(utildir) -I$(shelldir) -I$(simdir) -I$(scriptdir) -I$(nsdir) -I$(hierarchy)  -I/usr/local/neurospaces/instrumentor 

AM_CPPFLAGS = -DPRE_PROTO_TRAVERSAL

EXTRA_DIST = \
	olflib.g \
	olf_struct.h

noinst_LIBRARIES = libolf.a

BUILT_SOURCES = \
	olf_d@.c \
	olf_g@.c \
	olf_g@.h \
	olf_l@.c 

CLEANFILES = \
	olf_d@.c \
	olf_g@.c \
	olf_g@.h \
	olf_l@.c \
	tmp_olf_struct.h 


olf_d@.c: olflib.g
	$(CPP) olf_struct.h -I../script -I../util -I../sim -I../shell > tmp_olf_struct.h
	$(makestructs) tmp_olf_struct.h olf -I ./olf_ext.h -NI -o olf_d@.c

olf_g@.c: olflib.g
	$(c2genesis) olflib.g olf_ext.h olf

olf_g@.h:
	$(c2genesis) olflib.g olf_ext.h olf

olf_l@.c: olflib.g
	$(makelib) olf -o olf_l@.c


pkginclude_HEADERS = \
	olf_defs.h \
	olf_ext.h 


libolf_a_SOURCES = \
	olfsli.c \
	olf_d@.c \
	olf_g@.c \
	olf_l@.c 

libolf_a_DEPENDENCIES = \
	olf_d@.c \
	olf_g@.c \
	olf_g@.h \
	olf_l@.c 

dist-hook: $(libolf_a_DEPENDENCIES)

