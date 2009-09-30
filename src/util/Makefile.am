sysdir = $(top_builddir)/src/sys
scriptdir = $(top_builddir)/src/script
shelldir = $(top_builddir)/src/shell

# \todo these variables are relative to builddir, should be relative to srcdir

INCLUDES = -I$(sysdir) -I$(scriptdir) -I$(shelldir)

noinst_LIBRARIES = libutil.a


noinst_HEADERS = \
	copyright.h \
	hash.h \
	header.h \
	printoptusage.h \
	profile.h \
	system_deps.h

libutil_a_SOURCES = \
	getopt.c \
	hash.c \
	jump.c \
	popen.c \
	proc.c \
	rstats.c \
	signal.c \
	system.c \
	system_deps.c \
	segv.c 


dist-hook: $(noinst_LIBRARIES)