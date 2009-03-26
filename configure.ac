

# $Format: "AC_INIT(${package}, ${label}, ${email})"$
AC_INIT(ns-sli, python-2, hugo.cornelis@gmail.com)

dnl Obtain operating system information.
AC_CANONICAL_TARGET

AC_CONFIG_SRCDIR(src)
AC_CONFIG_HEADER(src/config.h)



# $Format: "AM_INIT_AUTOMAKE(${package}, ${label})"$
AM_INIT_AUTOMAKE(ns-sli, python-2)


AC_PROG_CC
AC_PROG_YACC
AC_PROG_LEX
AC_PROG_RANLIB
AC_PROG_CPP



AC_PATH_PROGS(PERL, perl perl5)

AC_PATH_PROGS(DOXYGEN,doxygen,["NULL"])

AC_CHECK_HEADERS([ heccer/heccer.h ],[],[
   echo "Error! Heccer header files not found in any standard location."
   exit -1
])

#AC_CHECK_HEADERS([ neurospaces/pidinstack.h ],[],[
#	echo "Error! Model Container header files not found in any standard location."
#	exit -1
#])


AC_MSG_CHECKING([Checking OS])
AC_MSG_RESULT([Host is running $host_os.])
case "$host_os" in

  darwin*)

    AC_MSG_CHECKING([Using libtool for MAC OS X.])
    AR=libtool
    ARFLAGS='-static -c -o'
    AC_SUBST(AR)
    AC_SUBST(ARFLAGS)
    AC_MSG_RESULT([$AR $ARFLAGS])


    SYSLIBLINKS=' -lncurses -lfl -lreadline -lm'
    AC_SUBST(SYSLIBLINKS)    

  ;;

  *) #default settings (Linux 2.6)

    AR=ar
    ARFLAGS='cru'
    AC_SUBST(AR)
    AC_SUBST(ARFLAGS)

    SYSLIBLINKS='-lfl -lreadline -lhistory -lm -lncurses'
    AC_SUBST(SYSLIBLINKS)
  ;;
esac


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




#DX_INIT_DOXYGEN(nsgenesis,dox.cfg,docs)
#DX_DOXYGEN_FEATURE(ON)
#DX_DOT_FEATURE(ON)
#DX_HTML_FEATURE(ON)
#DX_CHM_FEATURE(ON)
#DX_CHI_FEATURE(ON)
#DX_MAN_FEATURE(ON)
#DX_RTF_FEATURE(ON)
#DX_XML_FEATURE(ON)
#DX_PDF_FEATURE(ON)
#DX_PS_FEATURE(ON) 
