SUBDIRS = \
	src \
	glue

EXTRA_DIST = \
	tests \
	doxygen.cfg \
	tests.config 

TESTS = /usr/local/bin/neurospaces_harness


CLEANFILES = \
	$(top_builddir)/docs/doxygen.tag



RELEASE_MAJOR=`release-extract --major`
RELEASE_MINOR=`release-extract --minor`
RELEASE_MICRO=`release-extract --micro`

clean-local:
	$(RM) -rf $(top_builddir)/docs/html
	$(RM) -rf $(top_builddir)/docs/ns-sli
	$(RM) -f $(top_builddir)/*.dsc
	$(RM) -f $(top_builddir)/*.changes
	$(RM) -f $(top_builddir)/*.deb
	$(RM) -rf $(top_builddir)/RPM_BUILD
	$(RM) -f $(top_builddir)/build_debian.log
	$(RM) -f $(top_builddir)build_rpm.log
	$(RM) -f $(top_builddir)/*.tar.gz

show-release-labels:
	echo "Release information (major-minor-micro): $(RELEASE_MAJOR).$(RELEASE_MINOR)-$(RELEASE_MICRO)"

dist-keywords:
	release-expand ns-sli $(RELEASE_MAJOR) $(RELEASE_MINOR) $(RELEASE_MICRO) $(RELEASE_MAJOR).$(RELEASE_MINOR) hugo.cornelis@gmail.com --verbose

dist-hook: 
	echo "Building source dist"

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

# Create an rpm package
pkg-rpm: dist
	nspkg-rpm $(PACKAGE) $(VERSION)