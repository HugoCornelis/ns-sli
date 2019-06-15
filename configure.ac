

# $Format: "AC_INIT(${package}, ${major}.${minor}.${micro}-${label}, ${email})"$
AC_INIT(ns-sli, 0.0.0-alpha, hugo.cornelis@gmail.com)

dnl Obtain operating system information.
AC_CANONICAL_TARGET

AC_CONFIG_SRCDIR(src)
AC_CONFIG_HEADER(src/config.h)



# $Format: "AM_INIT_AUTOMAKE(${package}, ${major}.${minor}.${micro}-${label})"$
AM_INIT_AUTOMAKE(ns-sli, 0.0.0-alpha)


AC_MSG_CHECKING(whether we build universal binaries.)
AC_ARG_WITH(universal,
[AS_HELP_STRING([--with-universal],
              [Build universal binaries on Mac OS X.])],
[ case "$val" in
  no)

    AC_MSG_RESULT(no)
    OSX_UNIVERSAL="no"

    ;;
  *)

    AC_MSG_RESULT(yes)
    OSX_UNIVERSAL="yes"

#    CFLAGS="$CFLAGS -arch x86_64 -arch i386 -arch ppc"
    CFLAGS="-g -O0 -arch x86_64 -arch i386 -arch ppc"
    AC_SUBST(CFLAGS)

    ;;
  esac ],
  AC_MSG_RESULT(no)
  OSX_UNIVERSAL="no"
)
AC_SUBST(OSX_UNIVERSAL)

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
 	  CFLAGS="$CFLAGS -fPIC"
	;;
	*)
	  AC_MSG_RESULT([Unknown CPU type])
	;;
esac



# Checks for programs.
AC_PROG_CC
AC_PROG_YACC
AC_PROG_LEX
AC_PROG_RANLIB
AC_PROG_CPP

case "$host_os" in
  darwin*)
    LDFLSLI=-ll
    AC_SUBST(LDFLSLI)
  ;;
  *)   
    LDFLSLI=-lfl
    AC_SUBST(LDFLSLI)
  ;;
esac


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


    #-- Here we determine the install path for perl modules --
    AC_MSG_CHECKING([Checking the perl module installation path])	
    pmdir_relative_path=`\
      $PERL -MConfig \
        -wle '($_ = $Config{installsitelib})
              =~ s!^\Q$Config{siteprefix}/!!; \
              print'`
 
    AC_ARG_WITH(
      [pmdir],
    AS_HELP_STRING(
      [--with-pmdir=DIR],
      [Install Perl modules in DIR]),
      [PMDIR=${withval}],
      [PMDIR="$pmdir_relative_path"])

    AC_SUBST([PMDIR])
    AC_MSG_RESULT([ $PMDIR ])
    # --- End perl module directory selection --------------

    # determine linker flags for perl embedding
    if test "$OSX_UNIVERSAL" == "yes"; then

      PERL_CCOPTS=`$PERL -MExtUtils::Embed -e ccopts`
      
      PERL_LDADD=`$PERL -MExtUtils::Embed -e ldopts`

      PERL_LDFLAGS=`$PERL -MExtUtils::Embed -e ldopts | perl -pe 's/\-arch\s\S+\s//g'`

    else

      PERL_CCOPTS=`$PERL -MExtUtils::Embed -e ccopts | perl -pe 's/\-arch\s\S+\s//g'`
    
      PERL_LDADD=`$PERL -MExtUtils::Embed -e ldopts | perl -pe 's/\-arch\s\S+\s//g'`

      PERL_LDFLAGS=`$PERL -MExtUtils::Embed -e ldopts | perl -pe 's/\-arch\s\S+\s//g'`

    fi


dnl Commenting out stuff that doesn't work
dnl     AC_CHECK_PROG(SWIG, swig, NULL, [/usr/bin/swig],[/usr/local/bin/swig /opt/local/bin/swig])
dnl     AC_SUBST(SWIG)

dnl     AC_MSG_CHECKING([Checking for swig])
dnl     case $SWIG in
dnl       NULL*)
dnl         echo ""
dnl         echo "Error, the standard version of swig for Mac OSX is not found."
dnl         echo "Non standard versions of swig are known to cause problems."
dnl         AC_ERROR([Swig for Mac OSX is not found.])
dnl         ;;
dnl       *)
dnl         AC_MSG_RESULT([ $SWIG ])
dnl         ;;
dnl     esac

    AC_CHECK_PROGS(SWIG, swig, [NULL], [/usr/bin /usr/local/bin])

    case $SWIG in
      NULL*)
        echo ""
        echo "Error, the standard version of swig for Mac OSX is not found."
        echo "Non standard versions of swig are known to cause problems."
        AC_ERROR([Swig for Mac OSX is not found.])
        ;;
    esac


    SYSLIBLINKS=' -lncurses -ll -lreadline -lm'
    AC_SUBST(SYSLIBLINKS)    

    PERLLIB_EXTENSION='dylib'
    AC_SUBST(PERLLIB_EXTENSION)

    SWIGCOMPILELINKSFORPERL='-I$(top_builddir) -ffloat-store 	-I$(top_builddir)/src 	-include src/config.h 	-g 	-O0 	-dynamic $(PERL_CCOPTS)'
    AC_SUBST(SWIGCOMPILELINKSFORPERL)

    SWIGCOMPILECOMMAND_PERL='gcc         $(SWIGCOMPILELINKSFORPERL)         -c swiggable_sli_wrap.c'
    AC_SUBST(SWIGCOMPILECOMMAND_PERL)

    if test "$OSX_UNIVERSAL" == "yes"; then 

      SWIGLDLINKSFORPERL='-a -dynamic -undefined suppress -flat_namespace -L$(top_builddir) -lexperiment -lheccer -L/usr/local/lib/model-container 	-lneurospacesread  -lsymbol_algorithms  $(shelldir)/../loadlib.o $(simdir)/libsim.a $(shelldir)/libshell.a	$(utildir)/libutil.a	$(scriptdir)/libscript.a	$(olfdir)/libolf.a	$(nsdir)/libneurospaces.a	-L$(libdir)/model-container -lneurospacesread	-L$(libdir)/model-container -lsymbol_algorithms  -lexperiment  -L$(libdir)/heccer -lheccer -lhneurospaces $(SYSLIBLINKS)'

    else

      SWIGLDLINKSFORPERL='-bundle -flat_namespace -undefined suppress  -L$(top_builddir) 	-lexperiment -lheccer -L../../../integrators  	-L/usr/local/lib/model-container 	-lneurospacesread  -lsymbol_algorithms  $(shelldir)/../loadlib.o $(shelldir)/shell_lib.o	$(simdir)/libsim.a	$(shelldir)/libshell.a	$(utildir)/libutil.a	$(scriptdir)/libscript.a	$(olfdir)/libolf.a	$(nsdir)/libneurospaces.a	-L$(libdir)/model-container -lneurospacesread	-L$(libdir)/model-container -lsymbol_algorithms  -lexperiment  -L$(libdir)/heccer -lheccer -lhneurospaces $(SYSLIBLINKS)'

    fi

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

       darwin10*)


          if test "$OSX_UNIVERSAL" == "yes"; then
  
            SWIGLINKCOMMAND_PERL='$(AR) $(SWIGLDLINKSFORPERL) -o SwiggableSLI.$(PERLLIB_EXTENSION) swiggable_sli_wrap.o'
          
          else

            SWIGLINKCOMMAND_PERL='ld $(SWIGLDLINKSFORPERL) -o SwiggableSLI.$(PERLLIB_EXTENSION) swiggable_sli_wrap.o   /usr/lib/bundle1.o'

          fi

          AC_SUBST(SWIGLINKCOMMAND_PERL)

	  SWIGLINKCOMMAND_PYTHON='ld 	$(SWIGLDLINKSFORPYTHON) -o _SwiggableSLI.$(PYTHONLIB_EXTENSION)  swiggable_sli_wrap.o  /usr/lib/bundle1.o'
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

    AR=ar
    ARFLAGS='cru'
    AC_SUBST(AR)
    AC_SUBST(ARFLAGS)
    AC_MSG_CHECKING([ranlib invocation ])
    AC_MSG_RESULT([$AR $ARFLAGS])

    SYSLIBLINKS='-lfl -lm -lncurses'
    AC_SUBST(SYSLIBLINKS)

    AC_CHECK_PROGS(PERL, perl5 perl)
    AC_SUBST(PERL)


    #-- Here we determine the install path for perl modules --
    AC_MSG_CHECKING([Checking the perl module installation path])	
    pmdir_relative_path=`\
      $PERL -MConfig \
        -wle '($_ = $Config{installsitelib})
              =~ s!^\Q$Config{siteprefix}/!!; \
              print'`
 
    AC_ARG_WITH(
      [pmdir],
    AS_HELP_STRING(
      [--with-pmdir=DIR],
      [Install Perl modules in DIR]),
      [PMDIR=${withval}],
      [PMDIR='${prefix}'/"$pmdir_relative_path"])

    AC_SUBST([PMDIR])
    AC_MSG_RESULT([ $PMDIR ])
    # --- End perl module directory selection --------------


    PERL_CCOPTS=`$PERL -MExtUtils::Embed -e ccopts`
    AC_SUBST(PERL_CCOPTS)

    dnl Need to have the compilation fail if swig and perl are not found at all.
    AC_CHECK_PROGS(SWIG, swig)
    AC_SUBST(SWIG)


    PERLLIB_EXTENSION='so'
    AC_SUBST(PERLLIB_EXTENSION)


    SWIGCOMPILELINKSFORPERL='-I$(top_builddir) -I$(top_builddir) -ffloat-store -I$(top_builddir)/src -include src/config.h -g -O0 -fPIC $(PERL_CCOPTS)'
    AC_SUBST(SWIGCOMPILELINKSFORPERL)

    SWIGCOMPILECOMMAND_PERL='gcc $(SWIGCOMPILELINKSFORPERL) -c swiggable_sli_wrap.c'
    AC_SUBST(SWIGCOMPILECOMMAND_PERL)


    SWIGLDLINKSFORPERL='-g -shared swiggable_sli_wrap.o -L$(top_builddir) -lexperiment -lheccer -L$(top_builddir)/integrators -L/usr/local/lib/model-container -lneurospacesread -lsymbol_algorithms -lncurses -fPIC	$(shelldir)/../loadlib.o $(shelldir)/shell_lib.o	$(simdir)/libsim.a	$(shelldir)/libshell.a	$(utildir)/libutil.a	$(scriptdir)/libscript.a	$(olfdir)/libolf.a	$(nsdir)/libneurospaces.a	-L${libdir}/model-container -lneurospacesread	-L${libdir}/model-container/ -lsymbol_algorithms	-lexperiment -L${libdir}/heccer -lheccer	-L${libdir}/heccer -lhneurospaces	-fPIC $(SYSLIBLINKS)'
    AC_SUBST(SWIGLDLINKSFORPERL)

    SWIGLINKCOMMAND_PERL='gcc $(SWIGLDLINKSFORPERL) -o SwiggableSLI.$(PERLLIB_EXTENSION)'
    AC_SUBST(SWIGLINKCOMMAND_PERL)


    PYTHONLIB_EXTENSION='so'
    AC_SUBST(PYTHONLIB_EXTENSION)

    SWIGCOMPILELINKSFORPYTHON='-g -DPRE_PROTO_TRAVERSAL -I$(PYTHON_HEADERS) -I$(top_builddir) -I$(top_builddir)/hierarchy/output/symbols -I$(top_builddir)/hierarchy/output/symbols/ -fPIC -Xlinker -export-dynamic'
    AC_SUBST(SWIGCOMPILELINKSFORPYTHON)

   SWIGCOMPILECOMMAND_PYTHON='gcc $(SWIGCOMPILELINKSFORPYTHON) -c swiggable_sli_wrap.c'
   AC_SUBST(SWIGCOMPILECOMMAND_PYTHON)

    SWIGLDLINKSFORPYTHON='-g -shared swiggable_sli_wrap.o -L$(top_builddir) -lexperiment -lheccer -L$(top_builddir)/integrators -L/usr/local/lib/model-container -lneurospacesread -L${libdir}/model-container/ -lsymbol_algorithms -lncurses -fPIC -Xlinker -export-dynamic'
    AC_SUBST(SWIGLDLINKSFORPYTHON)

    SWIGLINKCOMMAND_PYTHON='gcc $(SWIGLDLINKSFORPYTHON) -o _SwiggableSLI.$(PYTHONLIB_EXTENSION)'
    AC_SUBST(SWIGLINKCOMMAND_PYTHON)
    dnl }}} End of General Settings

  ;;
esac




# determine the test library to install

TEST_SPECIFICATION_FILES=`(find tests -iname "*.t" -o -iname "*.txt" -o -iname "*.g" -o -iname "*.p" -o -iname "*.g2" -o -iname "*.g3" -o -iname "*.ndf" -o -iname "*.out" -o -iname "*.html" -o -iname "*.rst" -o -iname "*.ssp" -o -iname "*-double" ) | perl -pe 's(^| )( \\$(top_srcdir)/)g' | perl -pe 's/\n/ /g' `
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



