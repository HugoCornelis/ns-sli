# The _WORKING_DIRECTORY_ value will be replaced with the current working directory
%define _topdir	 	_WORKING_DIRECTORY_/RPM_BUILD
%define _bindir		/usr/local/bin
%define _mandir		/usr/local/share/man/man1

# $Format: "%define name	${package}"$
%define name	ns-sli
%define release		1


# $Format: "%define version 	${label}"$
%define version 	83c9247effe56b4735580b182b3bfdbda8cd1907.0
%define buildroot 	%{_topdir}/%{name}-%{version}-root

BuildRoot:		%{buildroot}
Summary: 		GENESIS backward compatability layer. 
License: 		GPL
Name: 			%{name}
Version: 		%{version}
Release: 		%{release}
Source: 		%{name}-%{version}.tar.gz
Prefix: 		/usr/local
Group: 			Science
Vendor: 		Hugo Cornelis <hugo.cornelis@gmail.com>
Packager: 		Mando Rodriguez <mandorodriguez@gmail.com>
URL:			http://www.neurospaces.org

%description
 GENESIS 3 is backward compatible with GENESIS Release 2.3 for all functionality of Tutorial 9--The Purkinje Tutorial. In doing this, backward compatibility supports the major functionalities of the GENESIS Script Language Interpreter.  Importantly, backward compatibility is provided to enable GENESIS 2 scripts to be used in association with the reconfigured GENESIS. It is not designed to extend a pre-existing GENESIS 2 script with new functionality provided by GENESIS 3. Although this may be possible is some cases, the results are not currently guaranteed. Contact GENESIS Support if you require further details.

# %package developer
# Requires: perl
# Summary: Neurospaces Developer Package
# Group: Science
# Provides: developer

%prep
echo %_target
echo %_target_alias
echo %_target_cpu
echo %_target_os
echo %_target_vendor
echo Building %{name}-%{version}-%{release}
%setup -q

%build
./configure 
make

%install
make install prefix=$RPM_BUILD_ROOT/usr/local

%clean
[ ${RPM_BUILD_ROOT} != "/" ] && rm -rf ${RPM_BUILD_ROOT}

# listing a directory name under files will include all files in the directory.
%files
%defattr(0755,root,root) 
/usr/local/
#/usr/share/


%doc %attr(0444,root,root) docs
#%doc %attr(0444,root,root) /usr/local/share/man/man1/wget.1
# need to put whatever docs to link to here.

%changelog
* Mon Apr  5 2010 Mando Rodriguez <mandorodriguez@gmail.com> - 
- Initial build.

