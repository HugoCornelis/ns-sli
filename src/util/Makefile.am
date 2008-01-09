sysdir = $(top_srcdir)/src/sys
scriptdir = $(top_srcdir)/src/script
shelldir = $(top_srcdir)/src/shell

INCLUDES = -I$(sysdir) -I$(scriptdir) -I$(shelldir)

noinst_LIBRARIES = libutil.a

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


