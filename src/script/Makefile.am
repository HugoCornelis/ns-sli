sysdir = $(top_srcdir)/src/sys
scriptdir = $(top_srcdir)/src/script
shelldir = $(top_srcdir)/src/shell
utildir = $(top_srcdir)/src/util


INCLUDES = -I$(sysdir) -I$(scriptdir) -I$(shelldir) -I$(utildir) -I.

noinst_LIBRARIES = libparser.a libscript.a 

BUILT_SOURCES = \
	syntax.c \
	syntax.h \
	lexical.c


CLEANFILES = \
	syntax.c \
	syntax.h \
	lexical.c
 

AM_LFLAGS = -l
AM_YFLAGS = -dv


noinst_HEADERS = 
	parse.h \
	printoptusage.h \
	result.h \
	ss_func_ext.h \
	symtab.h \
	syntax.h

libparser_a_SOURCES = \
	lexical.l \
	syntax.y 


#libscript_a_SOURCES = \
#	eval.c \
#	parse.c \
#	strsave.c \
#	symtab.c \
#	yyless.c \
#	syntax.y 











