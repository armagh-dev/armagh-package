%define version 2.2.0
%define base 2.2
%define debug_package %{nil}
%define _unpackaged_files_terminate_build 0

Name: ruby
Version: %{version}
Release: 1%{?dist}
License: Ruby License/GPL
URL: http://ruby-lang.org
Requires: libyaml
Source0: http://cache.ruby-lang.org/pub/ruby/%{base}/ruby-%{version}.tar.gz
Summary: OO scripting language interpreter
Group: Development / Languages

%description
Ruby is a dynamic, open source programming language with a focus on simplicity
and productivity. It has an elegant syntax that is natural to read and easy to
write.

%prep
%setup -q

%build
%configure \
  --enable-shared \
  --disable-rpath \
  --includedir=%{_includedir}/ruby \
  --libdir=%{_libdir} \
  --disable-install-doc

make %{?_smp_mflags}

%install
make install DESTDIR=$RPM_BUILD_ROOT

rm -rf $RPM_BUILD_ROOT/usr/src

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-, root, root, -)
%{_bindir}
%{_includedir}
%{_datadir}
%{_libdir}

%doc %{_mandir}/man1/erb.1.gz
%doc %{_mandir}/man1/irb.1.gz
%doc %{_mandir}/man1/rake.1.gz
%doc %{_mandir}/man1/ri.1.gz
%doc %{_mandir}/man1/ruby.1.gz

%changelog
* Tue Jan 6 2015 Kyle Nickel <kylenickel@noragh.com> 2.2.0
- Changed the spec to build off of the 2.2.0 release
* Thu Dec 11 2014 Kyle Nickel <kylenickel@noragh.com> 2.1.5
- Initial Build

