sysdir = $(top_srcdir)/src/sys
ssdir = $(top_srcdir)/src/ss
shelldir = $(top_srcdir)/src/shell
simdir = $(top_srcdir)/src/sim

INCLUDES = -I$(sysdir) -I$(ssdir) -I$(shelldir) -I$(simdir) -I/usr/local/neurospaces/instrumentor 

noinst_LIBRARIES = libneurospaces.a

libneurospaces_a_SOURCES = \
	neurospacesread.c \
	neurospacesmodel.c \
	neurospacesquery.c \
	neurospacessetup.c \
	neurospacessupport.c 
