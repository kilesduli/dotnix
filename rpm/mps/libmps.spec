%global gitdate 20241127
%global commit  9fd0577cf1231e61c9801c81499e5d16d0743806
%global shortcommit %(c=%{commit}; echo ${c:0:7})

# mps seems need make -j1
%global _smp_mflags %{nil}
# disable this won't failure.
%undefine _annotated_build
# performance?
%global debug_package %{nil}

Name:           libmps
Version:        1.118.0^%{gitdate}git%{shortcommit}
Release:        1%{?dist}
Summary:        Ravenbrook's Memory Pool System

License:        BSD-2-Clause
URL:            https://github.com/Ravenbrook/mps
Source0:        https://github.com/Ravenbrook/mps/archive/%{commit}/%{name}-%{shortcommit}.tar.gz

Patch:          0001-Fix-installdir-with-std-paths.patch

BuildRequires:  autoconf
BuildRequires:  gcc
BuildRequires:  sqlite-devel
Requires:       %{name}-devel%{?_isa} = %{version}-%{release}

%description
The Memory Pool System (MPS) is a very general, adaptable, flexible, reliable,
and efficient memory management system. It permits the flexible combination of
memory management techniques, supporting manual and automatic memory management,
in-line allocation, finalization, weakness, and multiple concurrent co-operating
incremental generational garbage collections.It also includes a library of
memory pool classes implementing specialized memory management policies.


%package        devel
Summary:        lopment files for %{name}

%description    devel
The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.


%package        tools
Summary:        Tools for %{name}

%description    tools
The %{name}-tools package contains tools for %{name}.


%prep
%autosetup -n mps-%{commit}
autoconf -vif

# avoid build failure
sed -i 's/-Werror / /g' code/gc.gmk
sed -i 's/-Werror / /g' code/gp.gmk
sed -i 's/-Werror / /g' code/ll.gmk

%build
%configure
%make_build


%install
%make_install


%files


%files devel
%{_includedir}/*.h
%{_libdir}/*.a


%files tools
%{_bindir}/mpseventcnv
%{_bindir}/mpseventpy
%{_bindir}/mpseventsql
%{_bindir}/mpseventtxt
