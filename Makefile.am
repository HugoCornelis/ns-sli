SUBDIRS = \
	src \
	glue

EXTRA_DIST = \
	tests \
	doxygen.cfg \
	tests.config 

TESTS = $(top_builddir)/tests/neurospaces_harness


CLEANFILES = \
	$(top_builddir)/docs/doxygen.tag

clean-local:
	rm -rf $(top_builddir)/docs/html
	rm -rf $(top_builddir)/docs/ns-sli

html-upload-prepare:
	rm -fr html/htdocs/neurospaces_project/ns-sli
	mkdir -p html/htdocs/neurospaces_project/ns-sli
# $Format: "	( cd tests && ./tests_2_html --header '<img src=\"ns-main-logo-dark2-notext-32x32.jpg\" alt=\"Main Neurospaces logo\"> ${package}, ${label}, ${email} <hr>' --introduction introduction.html )" $
	( cd tests && ./tests_2_html --header '<img src="ns-main-logo-dark2-notext-32x32.jpg" alt="Main Neurospaces logo"> Genesis 2 Backwards Compatibility Bridge <hr>' --introduction introduction.html )
	tar cfh - tests/html | ( cd html/htdocs/neurospaces_project/ns-sli && tar vxf - )

html-upload: html-upload-prepare
	scp -pr html/htdocs/* hcornelis,neurospaces@web.sourceforge.net:/home/groups/n/ne/neurospaces/htdocs/


doxygen: doxygen.cfg
	$(DOXYGEN) doxygen.cfg

docs-level1:

docs-level2:

docs-level3: html-upload-prepare
	echo "Converted the regression tests to HTML"

docs-level4:

docs-level5:

docs-level6: doxygen
	echo "Doxygenized source code"

docs-level7:

docs: docs-level1 docs-level2 docs-level3 docs-level4 docs-level5 docs-level6 docs-level7

TMP_DIR = tmp

# Create a deb package
pkg-deb: dist
	nspkg-deb $(TMP_DIR) $(PACKAGE) $(VERSION)