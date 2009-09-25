sysdir = $(top_builddir)/src/sys
scriptdir = $(top_builddir)/src/script
shelldir = $(top_builddir)/src/shell
utildir = $(top_builddir)/src/util

# \todo these variables are relative to builddir, should be relative to srcdir

INCLUDES = -I$(sysdir) -I$(scriptdir) -I$(shelldir) -I$(utildir) -I.

noinst_LIBRARIES = libscript.a 



BUILT_SOURCES = \
	y.tab.c \
	y.tab.h \
	lex.yy.c

CLEANFILES = \
	syntax.c \
	syntax.h \
	lexical.c \
	lex.yy.c

AM_LFLAGS = -l
AM_YFLAGS = -dv


#noinst_HEADERS = 


#
# Target for generating the lexical analyzer code. 
# Automake cannot compile it due to a dependency in the lexical code 
# insertion, so the lex.yy.c file must be generated beforehand.
# 
#
lex.yy.c: lexical.l
	echo Using \"`which $(LEX)` $(AM_LFLAGS)\" for lexical parsing
	$(LEX) $(AM_LFLAGS) lexical.l

y.tab.c: lex.yy.c
	echo  Using\"`which $(YACC)` $(AM_YFLAGS)\" for syntax parsing
	$(YACC) -dv syntax.y


EXTRA_libscript_a_SOURCES = \
	lexical.l \
	syntax.y \
	parse.h \
	printoptusage.h \
	result.h \
	ss_func_ext.h \
	symtab.h \
	syntax.h

libscript_a_SOURCES = \
	eval.c \
	parse.c \
	strsave.c \
	symtab.c \
	y.tab.c \
	yyless.c 












