

# $Format: "AC_INIT(${package}, ${major}.${minor}.${micro}-${label}, ${email})"$
AC_INIT(ns-sli, 0.0.0-alpha, hugo.cornelis@gmail.com)

dnl Obtain operating system information.
AC_CANONICAL_TARGET

AC_CONFIG_SRCDIR(src)
AC_CONFIG_HEADER(src/config.h)



# $Format: "AM_INIT_AUTOMAKE(${package}, ${major}.${minor}.${micro}-${label})"$
AM_INIT_AUTOMAKE(ns-sli, 0.0.0-alpha)


# Checks for programs.
AC_PROG_CC
AC_PROG_YACC
AC_PROG_LEX
AC_PROG_RANLIB
AC_PROG_CPP


AC_PATH_PROGS(DOXYGEN,doxygen,["NULL"])
AC_PATH_PROGS(DOT,dot,["NULL"])
AC_PATH_PROGS(SOURCE_HIGHLIGHT,source-highlight,["NULL"])


dnl Check for Python and it's headers
AM_PATH_PYTHON(,[],[
   echo "Python is not installed."
   exit -1
])

dnl
dnl This is a forced fix to make sure a mac installation gets the proper
dnl python executable. Unless the macpython installer was run, the autotools
dnl python macro won't look for python in the proper path. 
dnl 
case "$host_os" in
  darwin*)
    PYTHON='/Library/Frameworks/Python.framework/Versions/Current/bin/python'
    AC_SUBST(PYTHON)
  ;;
esac

case $PYTHON_PREFIX in
  *)   
    PYTHON_PREFIX=`echo $PYTHON | sed -e "s,[[^/]]*$,,;s,/$,,;s,^$,.,"`
    PYTHON_PREFIX=`echo $PYTHON_PREFIX | sed -e "s,[[^/]]*$,,;s,/$,,;s,^$,.,"`
    PYTHONHOME=$PYTHON_PREFIX
    AC_SUBST(PYTHON_PREFIX)
    AC_SUBST(PYTHONHOME)
				
    AC_MSG_CHECKING([Python header location])
    PYTHON_HEADERS='$(PYTHON_PREFIX)/include/python$(PYTHON_VERSION)'
    AC_SUBST(PYTHON_HEADERS)
    AC_MSG_RESULT([$PYTHON_PREFIX/include/python$PYTHON_VERSION])

    PYTHON_EXE='$(PYTHON_PREFIX)/bin/python'
    AC_SUBST(PYTHON_EXE)
  ;;
esac


# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([float.h limits.h locale.h stdlib.h string.h])

SAVE_CPPFLAGS=$CPPFLAGS
CPPFLAGS="-I/usr/local/neurospaces/instrumentor -DPRE_PROTO_TRAVERSAL"

AC_CHECK_HEADERS([neurospaces/neurospaces.h],[],
[echo "Error: neurospaces headers are not installed in standard location."])

CPPFLAGS=$SAVE_CPPFLAGS

AC_CHECK_HEADERS([ heccer/heccer.h ],[],[
   echo "Error! Heccer header files not found in any standard location."
])

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_C_CONST


AC_MSG_CHECKING([Checking OS])
AC_MSG_RESULT([Host is running $host_os.])
case "$host_os" in

  darwin*)

    #
    # These are settings specific to MAC OS X.
    #
    dnl {{{{
    AC_MSG_CHECKING([Using libtool for MAC OS X.])
    AR=libtool
    ARFLAGS='-static -c -o'
    AC_SUBST(AR)
    AC_SUBST(ARFLAGS)
    AC_MSG_RESULT([$AR $ARFLAGS])


    dnl On the MAC we will only look for perl in the standard location for the Apple
    dnl native perl. 
    AC_CHECK_PROG(PERL, perl, NULL, [/usr/bin/perl],[/usr/local/bin/perl /opt/local/bin/perl])
    AC_SUBST(PERL)

    AC_MSG_CHECKING([Checking the perl installation])
    case $PERL in
      NULL*)
        echo ""
        echo "Error, the standard version of perl for Mac OSX is not found."
        echo "Non standard versions of perl are known to cause problems."
        AC_ERROR([Perl for Mac OSX is not found.])
        ;;
      *)
        AC_MSG_RESULT([ $PERL ])
        ;;
    esac

    # determine linker flags for perl embedding

    PERL_CCOPTS=`$PERL -MExtUtils::Embed -e ccopts | $PERL -pe 's/\-arch\s\S+\s//g'`
    AC_SUBST(PERL_CCOPTS)


    AC_CHECK_PROG(SWIG, swig, NULL, [/usr/bin/swig],[/usr/local/bin/swig /opt/local/bin/swig])
    AC_SUBST(SWIG)

    AC_MSG_CHECKING([Checking for swig])
    case $SWIG in
      NULL*)
        echo ""
        echo "Error, the standard version of swig for Mac OSX is not found."
        echo "Non standard versions of swig are known to cause problems."
        AC_ERROR([Swig for Mac OSX is not found.])
        ;;
      *)
        AC_MSG_RESULT([ $SWIG ])
        ;;
    esac


    SYSLIBLINKS=' -lncurses -lfl -lreadline -lm'
    AC_SUBST(SYSLIBLINKS)    

    PERLLIB_EXTENSION='dylib'
    AC_SUBST(PERLLIB_EXTENSION)

    SWIGCOMPILELINKSFORPERL='-I$(srcdir)/../../.. 	-I$(top_builddir) 	-ffloat-store 	-I../../../src 	-include src/config.h 	-g 	-O0 	-dynamic $(PERL_CCOPTS)'
    AC_SUBST(SWIGCOMPILELINKSFORPERL)

    SWIGCOMPILECOMMAND_PERL='gcc         $(SWIGCOMPILELINKSFORPERL)         -c swiggable_sli_wrap.c'
    AC_SUBST(SWIGCOMPILECOMMAND_PERL)

 

    SWIGLDLINKSFORPERL='-bundle -flat_namespace -undefined suppress  -L../../.. 	-lheccer -L../../../integrators  	-L/usr/local/lib/model-container 	-lneurospacesread  -lsymbol_algorithms 	-lncurses -lreadline $(shelldir)/../loadlib.o $(shelldir)/shell_lib.o	$(simdir)/libsim.a	$(shelldir)/libshell.a	$(utildir)/libutil.a	$(scriptdir)/libscript.a	$(olfdir)/libolf.a	$(nsdir)/libneurospaces.a	-L${libdir}/model-container -lneurospacesread	-L${libdir}/neurospaces/instrumentor/hierarchy/output/symbols/ -lsymbol_algorithms	-L${libdir}/heccer -lheccer	-L${libdir}/heccer -lhneurospaces $(SYSLIBLINKS)'
    AC_SUBST(SWIGLDLINKSFORPERL)


    PYTHONLIB_EXTENSION='so'
    AC_SUBST(PYHONLIB_EXTENSION)

	# Mando: can you check why there are three dots in the include directive and explain here in a comment, it is a mystery to me.  This line comes from heccer's configure.ac
	# Hugo: May be a typo, I removed the line and it seemed to compile fine.

    SWIGCOMPILELINKSFORPYTHON='-I$(PYTHON_HEADERS)  -I.../../..	-I./../../.. 	-I.../../../hierarchy/output/symbols 	-I./../../../hierarchy/output/symbols/'
    AC_SUBST(SWIGCOMPILELINKSFORPYTHON)

    SWIGCOMPILECOMMAND_PYTHON='gcc         $(SWIGCOMPILELINKSFORPYTHON)         -c swiggable_sli_wrap.c'
    AC_SUBST(SWIGCOMPILECOMMAND_PYTHON)

    SWIGLDLINKSFORPYTHON='-L$(PYTHON_HEADERS)         -framework Python         -flat_namespace         -undefined suppress 	-bundle 	-bundle_loader $(PYTHON_EXE) -fPIC '
    AC_SUBST(SWIGLDLINKSFORPYTHON)




    dnl Here the SWIG linking is set. 
    case "$host_os" in
       *darwin10.2.0)
           dnl this is snow leopard
          SWIGLINKCOMMAND_PERL='ld 	$(SWIGLDLINKSFORPERL) 	-o SwiggableSLI.$(PERLLIB_EXTENSION) swiggable_sli_wrap.o   /usr/lib/bundle1.o'
          AC_SUBST(SWIGLINKCOMMAND_PERL)

	  SWIGLINKCOMMAND_PYTHON='ld 	$(SWIGLDLINKSFORPYTHON) 	-o _SwiggableSLI.$(PYTHONLIB_EXTENSION)  swiggable_sli_wrap.o  /usr/lib/bundle1.o'
          AC_SUBST(SWIGLINKCOMMAND_PYTHON)
       ;;
       *darwin10.3.0)
           dnl this is also snow leopard
          SWIGLINKCOMMAND_PERL='ld 	$(SWIGLDLINKSFORPERL) 	-o SwiggableSLI.$(PERLLIB_EXTENSION) swiggable_sli_wrap.o /usr/lib/bundle1.o'
          AC_SUBST(SWIGLINKCOMMAND_PERL)

	  SWIGLINKCOMMAND_PYTHON='ld 	$(SWIGLDLINKSFORPYTHON) 	-o _SwiggableSLI.$(PYTHONLIB_EXTENSION) swiggable_sli_wrap.o  /usr/lib/bundle1.o'
          AC_SUBST(SWIGLINKCOMMAND_PYTHON)
       ;;
       *darwin10.4.0)
           dnl this is also snow leopard
          SWIGLINKCOMMAND_PERL='ld 	$(SWIGLDLINKSFORPERL) 	-o SwiggableSLI.$(PERLLIB_EXTENSION) swiggable_sli_wrap.o /usr/lib/bundle1.o'
          AC_SUBST(SWIGLINKCOMMAND_PERL)

	  SWIGLINKCOMMAND_PYTHON='ld 	$(SWIGLDLINKSFORPYTHON) 	-o _SwiggableSLI.$(PYTHONLIB_EXTENSION) swiggable_sli_wrap.o  /usr/lib/bundle1.o'
          AC_SUBST(SWIGLINKCOMMAND_PYTHON)
       ;;
       *)
	  dnl All other mac versions. 
          dnl note: Leopard is i386-apple-darwin9.8.0
          SWIGLINKCOMMAND_PERL='ld 	$(SWIGLDLINKSFORPERL) 	-o SwiggableSLI.$(PERLLIB_EXTENSION) 	swiggable_sli_wrap.o /usr/lib/bundle1.o'
          AC_SUBST(SWIGLINKCOMMAND_PERL)

	  SWIGLINKCOMMAND_PYTHON='ld 	$(SWIGLDLINKSFORPYTHON) 	-o _SwiggableSLI.$(PYTHONLIB_EXTENSION) swiggable_sli_wrap.o /usr/lib/bundle1.o'
          AC_SUBST(SWIGLINKCOMMAND_PYTHON)
       ;;
    esac


    AC_MSG_RESULT([done.])
    dnl }}} end MAC OS X settings
    ;;




  *) #default settings (Linux 2.6)

    dnl {{{



    dnl -------------------------------------------
    dnl A check for 64 bit to set appropriate flags.
    dnl (can also put in other host_os specifics if needed)
    dnl -------------------------------------------
dnl     AC_MSG_CHECKING([checking for 64 bit])
dnl     case "$host_os" in:
dnl       *64*)
dnl          AC_MSG_RESULT([yes])
dnl          CFLAGS="-fPIC"
dnl          ;;
dnl 	 *)
dnl 	 AC_MSG_RESULT([no])
dnl          ;;
dnl     esac
    dnl -------------------------------------------



    AR=ar
    ARFLAGS='cru'
    AC_SUBST(AR)
    AC_SUBST(ARFLAGS)
    AC_MSG_CHECKING([ranlib invocation ])
    AC_MSG_RESULT([$AR $ARFLAGS])

    SYSLIBLINKS='-lfl -lreadline -lhistory -lm -lncurses'
    AC_SUBST(SYSLIBLINKS)

    AC_CHECK_PROGS(PERL, perl5 perl)
    AC_SUBST(PERL)

    PERL_CCOPTS=`$PERL -MExtUtils::Embed -e ccopts`
    AC_SUBST(PERL_CCOPTS)

    dnl Need to have the compilation fail if swig and perl are not found at all.
    AC_CHECK_PROGS(SWIG, swig)
    AC_SUBST(SWIG)


    PERLLIB_EXTENSION='so'
    AC_SUBST(PERLLIB_EXTENSION)


    SWIGCOMPILELINKSFORPERL='-I$(srcdir)/../../.. -I$(top_builddir) -ffloat-store -I../../../src -include src/config.h -g -O0 -fPIC $(PERL_CCOPTS)'
    AC_SUBST(SWIGCOMPILELINKSFORPERL)

    SWIGCOMPILECOMMAND_PERL='gcc $(SWIGCOMPILELINKSFORPERL) -c swiggable_sli_wrap.c'
    AC_SUBST(SWIGCOMPILECOMMAND_PERL)


    SWIGLDLINKSFORPERL='-g -shared swiggable_sli_wrap.o -L../../.. -lheccer -L../../../integrators -L/usr/local/lib/model-container -lneurospacesread -lsymbol_algorithms -lncurses -lreadline -lhistory -fPIC	$(shelldir)/../loadlib.o $(shelldir)/shell_lib.o	$(simdir)/libsim.a	$(shelldir)/libshell.a	$(utildir)/libutil.a	$(scriptdir)/libscript.a	$(olfdir)/libolf.a	$(nsdir)/libneurospaces.a	-L${libdir}/model-container -lneurospacesread	-L${libdir}/model-container/ -lsymbol_algorithms	-L${libdir}/heccer -lheccer	-L${libdir}/heccer -lhneurospaces	-fPIC $(SYSLIBLINKS)'
    AC_SUBST(SWIGLDLINKSFORPERL)

    SWIGLINKCOMMAND_PERL='gcc $(SWIGLDLINKSFORPERL) -o SwiggableSLI.$(PERLLIB_EXTENSION)'
    AC_SUBST(SWIGLINKCOMMAND_PERL)


    PYTHONLIB_EXTENSION='so'
    AC_SUBST(PYTHONLIB_EXTENSION)

    SWIGCOMPILELINKSFORPYTHON='-g -DPRE_PROTO_TRAVERSAL -I$(PYTHON_HEADERS) -I$(builddir)../../.. -I$(srcdir)/../../.. -I$(builddir)../../../hierarchy/output/symbols -I$(srcdir)/../../../hierarchy/output/symbols/ -fPIC -Xlinker -export-dynamic'
    AC_SUBST(SWIGCOMPILELINKSFORPYTHON)

   SWIGCOMPILECOMMAND_PYTHON='gcc $(SWIGCOMPILELINKSFORPYTHON) -c swiggable_sli_wrap.c'
   AC_SUBST(SWIGCOMPILECOMMAND_PYTHON)

    SWIGLDLINKSFORPYTHON='-g -shared swiggable_sli_wrap.o -L../../.. -lheccer -L../../../integrators -L/usr/local/lib/model-container -lneurospacesread -L${libdir}/model-container/ -lsymbol_algorithms -lncurses -lreadline -lhistory -fPIC -Xlinker -export-dynamic'
    AC_SUBST(SWIGLDLINKSFORPYTHON)

    SWIGLINKCOMMAND_PYTHON='gcc $(SWIGLDLINKSFORPYTHON) -o _SwiggableSLI.$(PYTHONLIB_EXTENSION)'
    AC_SUBST(SWIGLINKCOMMAND_PYTHON)
    dnl }}} End of General Settings

  ;;
esac


dnl -----------------------------------------------------
dnl Set flags for specific cpus
dnl -----------------------------------------------------
AC_MSG_CHECKING([checking CPU])
case "$host_cpu" in

	i[[3456]]86|pentium)
	  AC_MSG_RESULT([Intel based CPU])
	;;
	x86?64*)
	  dnl
	  dnl The test machine sorts an AMD 64 bit cpu
	  dnl this need fPIC set globally for all compiled objects
	  dnl for swig to work.
	  AC_MSG_RESULT([AMD 64 based CPU])
 	  CFLAGS="-fPIC"
	;;
	*)
	  AC_MSG_RESULT([Unknown CPU type])
	;;
esac



# determine the test library to install

TEST_SPECIFICATION_FILES=`(/bin/echo -n "tests/introduction.html " && find tests/specifications -name "*.t" && find tests/specifications/strings -name "*.txt" && find tests/scripts -name "*.g" && find tests/scripts -name "*.p" && find tests/specifications/strings -name "*.g2" && find tests/specifications/strings -name "*.g3" && find tests/specifications/strings -name "*.ssp" && find tests/specifications/strings -name "*-double" ) | perl -pe 's(^| )( \\$(top_srcdir)/)g' | perl -pe 's/\n/ /g' `
AC_SUBST(TEST_SPECIFICATION_FILES)


STARTUP_FILES=`(find src/startup) |  perl -pe 's/startup\n//g'  | perl -pe 's/src\///g' | perl -pe 's/\n/ /g'`
AC_SUBST(STARTUP_FILES)

#  perl -pe 's(^| )( \\$(top_srcdir)/)g'


AC_OUTPUT(Makefile \
		glue/Makefile \
                glue/swig/perl/Makefile \
		src/Makefile \
		src/util/Makefile \
		src/c2genesis/Makefile \
		src/script/Makefile \
		src/shell/Makefile \
		src/olf/Makefile \
		src/neurospaces/Makefile \
		src/sim/Makefile 
)



