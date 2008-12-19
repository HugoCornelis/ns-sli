SUBDIRS = src


EXTRA_DIST = \
	doxygen.cfg \
	docs	\
	tests.config \
	tests

TESTS = $(top_srcdir)/tests/neurospaces_harness


CLEANFILES = \
	$(top_srcdir)/docs/doxygen.tag

clean-local:
	rm -rf $(top_srcdir)/docs/html

html-upload-prepare:
	rm -fr html/htdocs/neurospaces_project/ns-sli
	mkdir --parents html/htdocs/neurospaces_project/ns-sli
# $Format: "	( cd tests && ./tests_2_html --header '<img src=\"ns-main-logo-dark2-notext-32x32.jpg\" alt=\"Main Neurospaces logo\"> ${package}, ${label}, ${email} <hr>' --introduction introduction.html )" $
	( cd tests && ./tests_2_html --header '<img src="ns-main-logo-dark2-notext-32x32.jpg" alt="Main Neurospaces logo"> Genesis 2 Backwards Compatibility Bridge <hr>' --introduction introduction.html )
	tar cfh - tests/html | ( cd html/htdocs/neurospaces_project/ns-sli && tar vxf - )

html-upload: html-upload-prepare
	scp -pr html/htdocs/* hcornelis,neurospaces@web.sourceforge.net:/home/groups/n/ne/neurospaces/htdocs/


doxygen: doxygen.cfg
	$(DOXYGEN) doxygen.cfg

docs: html-upload-prepare doxygen

