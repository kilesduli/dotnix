# This file is encoded in UTF-8.  -*- coding: utf-8 -*-
# The packaging files for this software package are forked from Fedora dist-git.
# Source: https://src.fedoraproject.org/rpms/librime
Name:           librime
Epoch:          1
Version:        1.11.2
Release:        1%{?dist}
Summary:        Rime Input Method Engine Library

License:        GPL-3.0-only
URL:            https://rime.im/
Source0:        https://github.com/rime/librime/archive/%{version}.tar.gz#/%{name}-%{version}.tar.gz
Source1:        https://github.com/lotem/librime-octagram/archive/refs/heads/master.tar.gz#/librime-octagram.tar.gz
Source2:        https://github.com/hchunhui/librime-lua/archive/refs/heads/master.tar.gz#/librime-lua.tar.gz
Source3:        https://github.com/rime/librime-predict/archive/refs/heads/master.tar.gz#/librime-predict.tar.gz
Source4:        https://github.com/lotem/librime-proto/archive/refs/heads/master.tar.gz#/librime-proto.tar.gz

BuildRequires:  gcc-c++
BuildRequires:  cmake, opencc-devel
BuildRequires:  boost-devel >= 1.46
BuildRequires:  zlib-devel
BuildRequires:  glog-devel, gtest-devel
BuildRequires:  yaml-cpp-devel
BuildRequires:  gflags-devel
BuildRequires:  marisa-devel
BuildRequires:  leveldb-devel
BuildRequires:  lua-devel
BuildRequires:  capnproto, capnproto-devel

%description
Rime Input Method Engine Library

Support for shape-based and phonetic-based input methods,
including those for Chinese dialects.

A selected dictionary in Traditional Chinese,
powered by opencc for Simplified Chinese output.

%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{epoch}:%{version}-%{release}

%description    devel
The %{name}-devel package contains libraries and header files for
developing applications that use %{name}.


%package        tools
Summary:        Tools for %{name}
Requires:       %{name}%{?_isa} = %{epoch}:%{version}-%{release}

%description    tools
The %{name}-tools package contains tools for %{name}.


%prep
%autosetup -p1

source_files=(
    "%{SOURCE1}"
    "%{SOURCE2}"
    "%{SOURCE3}"
    "%{SOURCE4}"
)

# decompress and link additional sources to librime/plugins directory
for source_file in "${source_files[@]}"; do
    tar -xzvf "$source_file" -C %{_builddir}/%{name}-%{version}/plugins
done


%build
%cmake -DCMAKE_BUILD_TYPE=Release
%cmake_build


%install
%cmake_install


%ldconfig_scriptlets


%files
%doc README.md LICENSE
%{_libdir}/*.so.*


%files devel
%doc
%{_includedir}/*
%{_libdir}/*.so
%{_libdir}/pkgconfig/rime.pc
%dir %{_datadir}/cmake/rime
%{_datadir}/cmake/rime/RimeConfig.cmake


%files tools
%{_bindir}/rime_deployer
%{_bindir}/rime_dict_manager
%{_bindir}/rime_patch
%{_bindir}/rime_table_decompiler
