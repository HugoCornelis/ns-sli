sysdir = $(top_srcdir)/src/sys
scriptdir = $(top_srcdir)/src/script
shelldir = $(top_srcdir)/src/shell
utildir = $(top_srcdir)/src/util

INCLUDES = -I$(sysdir) -I$(scriptdir) -I$(shelldir) -I$(utildir) -I.

noinst_LIBRARIES = libscript.a 

BUILT_SOURCES = \
	syntax.c \
	syntax.h \
	lex.yy.c

CLEANFILES = \
	syntax.c \
	syntax.h \
	lexical.c \
	lex.yy.c
 

AM_LFLAGS = -l
AM_YFLAGS = -dv


noinst_HEADERS = 
	parse.h \
	printoptusage.h \
	result.h \
	ss_func_ext.h \
	symtab.h \
	syntax.h

#
# Target for generating the lexical analyzer code. 
# Automake cannot compile it due to a dependency in the lexical code 
# insertion, so the lex.yy.c file must be generated beforehand.
# 
#
lex.yy.c: lexical.l
	echo Using \"`which $(LEX)` $(AM_LFLAGS)\" for lexical parsing
	$(LEX) $(AM_LFLAGS) lexical.l


libscript_a_SOURCES = \
	eval.c \
	parse.c \
	strsave.c \
	symtab.c \
	yyless.c \
	syntax.y 











