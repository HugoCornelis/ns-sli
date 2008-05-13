AC_INIT(src/sim/sim_main.c)

PACKAGE=ns-genesis-SLI
VERSION=0.1

AM_INIT_AUTOMAKE($PACKAGE,$VERSION)


AC_PROG_CC
AC_PROG_YACC
AC_PROG_LEX
AC_PROG_RANLIB
AC_PROG_CPP


AC_CONFIG_SRCDIR(src)

AC_CONFIG_HEADER(src/config.h)


AC_OUTPUT(Makefile \
	src/Makefile \
	src/util/Makefile \
	src/c2genesis/Makefile \
	src/script/Makefile \
	src/shell/Makefile \
	src/neurospaces/Makefile \
	src/par/Makefile \
	src/sim/Makefile \
	src/olf/Makefile
)

