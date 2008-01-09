sysdir = $(top_srcdir)/src/sys
ssdir = $(top_srcdir)/src/ss
shelldir = $(top_srcdir)/src/shell



INCLUDES = -I$(sysdir) -I$(ssdir) -I$(shelldir) -I.

noinst_LIBRARIES = libss.a

BUILT_SOURCES = \
	syntax.c 

CLEANFILES = \
	syntax.c \
	syntax.h \
	lexical.c

AM_LFLAGS = -l
AM_YFLAGS = -dv

lexical.o: syntax.h

libss_a_SOURCES = \
	eval.c \
	parse.c \
	strsave.c \
	symtab.c \
	yyless.c \
	syntax.y \
	lexical.l


