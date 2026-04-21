# This file is encoded in UTF-8.  -*- coding: utf-8 -*-
# The spec file and related content for this software are forked from rpmfusion.
# Source: https://github.com/rpmfusion/telegram-desktop/blob/master/telegram-desktop.spec
%ifarch aarch64
    %global _lto_cflags %nil
%endif

# Telegram Desktop's constants...
%global appname 64Gram

# Reducing debuginfo verbosity...
%global optflags %(echo %{optflags} | sed 's/-g /-g1 /')

%global tde2e_commit 6d509061574d684117f74133056aa43df89022fc
%global tde2e_shortcommit %(c=%{tde2e_commit}; echo ${c:0:7})

Name:           64gram-desktop
Epoch:          1
Version:        1.1.99
Release:        1%{?dist}

# Application and 3rd-party modules licensing:
# * Telegram Desktop - GPL-3.0-or-later with OpenSSL exception -- main tarball;
# * tg_owt - BSD-3-Clause AND BSD-2-Clause AND Apache-2.0 AND MIT AND LicenseRef-Fedora-Public-Domain -- static dependency;
# * rlottie - LGPL-2.1-or-later AND AND FTL AND BSD-3-Clause -- static dependency;
# * cld3  - Apache-2.0 -- static dependency;
# * qt_functions.cpp - LGPL-3.0-only -- build-time dependency;
# * open-sans-fonts  - Apache-2.0 -- bundled font;
# * vazirmatn-fonts - OFL-1.1 -- bundled font.
License:        GPL-3.0-or-later AND BSD-3-Clause AND BSD-2-Clause AND Apache-2.0 AND MIT AND LicenseRef-Fedora-Public-Domain AND LGPL-2.1-or-later AND FTL AND MPL-1.1 AND LGPL-3.0-only AND OFL-1.1
URL:            https://github.com/TDesktop-x64/tdesktop
Summary:        Unofficial Telegram Desktop providing Windows 64bit build and extra features
Source0:        %{name}-%{version}.tar.gz
Source1:        https://github.com/tdlib/td/archive/%{tde2e_commit}/td-%{tde2e_shortcommit}.tar.gz
Patch:          0001-feat-disable-sponsored-messages.patch
Patch:          0002-feat-disable-saving-restrictions.patch
Patch:          0003-feat-disable-invite-peeking-restrictions.patch
Patch:          findprotobuf_fix.patch
# use mochaa tg_owt instead of rpmfusion, so we need this patch to fix build
Patch:          https://pagure.io/mochaa-rpms/64gram/raw/rawhide/f/64Gram/1000-tgcalls-fix-libyuv-include.patch#/tgcalls-fix-libyuv-include.patch
Patch:          https://pagure.io/mochaa-rpms/64gram/raw/rawhide/f/64Gram/1000-tgcalls-fix-cstdint-include.patch#/tgcalls-fix-cstdint-include.patch

# Telegram Desktop require more than 8 GB of RAM on linking stage.
# Disabling all low-memory architectures.
ExclusiveArch:  x86_64 aarch64

BuildRequires:  cmake(Microsoft.GSL)
BuildRequires:  cmake(OpenAL)
BuildRequires:  cmake(Qt6Concurrent)
BuildRequires:  cmake(Qt6Core)
BuildRequires:  cmake(Qt6Core5Compat)
BuildRequires:  cmake(Qt6DBus)
BuildRequires:  cmake(Qt6Gui)
BuildRequires:  cmake(Qt6Network)
BuildRequires:  cmake(Qt6OpenGL)
BuildRequires:  cmake(Qt6OpenGLWidgets)
BuildRequires:  cmake(Qt6Svg)
BuildRequires:  cmake(Qt6WaylandClient)
BuildRequires:  cmake(Qt6Widgets)
BuildRequires:  cmake(KF6CoreAddons)
BuildRequires:  cmake(KF6ImageFormats)
BuildRequires:  cmake(fmt)
BuildRequires:  cmake(range-v3)
BuildRequires:  cmake(tg_owt)
BuildRequires:  cmake(tl-expected)
BuildRequires:  cmake(ada)

BuildRequires:  pkgconfig(alsa)
BuildRequires:  pkgconfig(gio-2.0)
BuildRequires:  pkgconfig(glib-2.0)
BuildRequires:  pkgconfig(glibmm-2.68) >= 2.76.0
BuildRequires:  pkgconfig(gobject-2.0)
BuildRequires:  pkgconfig(gobject-introspection-1.0)
BuildRequires:  pkgconfig(hunspell)
BuildRequires:  pkgconfig(jemalloc)
BuildRequires:  pkgconfig(libavcodec)
BuildRequires:  pkgconfig(libavfilter)
BuildRequires:  pkgconfig(libavformat)
BuildRequires:  pkgconfig(libavutil)
BuildRequires:  pkgconfig(libcrypto)
BuildRequires:  pkgconfig(libjpeg)
BuildRequires:  pkgconfig(liblz4)
BuildRequires:  pkgconfig(liblzma)
BuildRequires:  pkgconfig(libpulse)
BuildRequires:  pkgconfig(libswresample)
BuildRequires:  pkgconfig(libswscale)
BuildRequires:  pkgconfig(libxxhash)
%if 0%{?fedora} < 41
BuildRequires:  pkgconfig(openssl)
%endif
BuildRequires:  pkgconfig(opus)
BuildRequires:  pkgconfig(protobuf)
BuildRequires:  pkgconfig(protobuf-lite)
BuildRequires:  pkgconfig(rnnoise)
BuildRequires:  pkgconfig(vpx)
BuildRequires:  pkgconfig(wayland-client)
BuildRequires:  pkgconfig(webkitgtk-6.0)
BuildRequires:  pkgconfig(xcb)
BuildRequires:  pkgconfig(xcb-keysyms)
BuildRequires:  pkgconfig(xcb-record)
BuildRequires:  pkgconfig(xcb-screensaver)

BuildRequires:  boost-devel
BuildRequires:  cmake
BuildRequires:  desktop-file-utils
# seems use ffmpeg-free to build will fine
BuildRequires:  ffmpeg-free-devel
BuildRequires:  gcc
BuildRequires:  gcc-c++
BuildRequires:  gperf
BuildRequires:  libappstream-glib
BuildRequires:  libatomic
BuildRequires:  libdispatch-devel
BuildRequires:  libqrcodegencpp-devel
BuildRequires:  libstdc++-devel
BuildRequires:  minizip-compat-devel
BuildRequires:  ninja-build
BuildRequires:  python3
BuildRequires:  qt6-qtbase-private-devel
BuildRequires:  qt6-qtbase-static
BuildRequires:  pkgconfig(openh264)


Requires:       hicolor-icon-theme
Requires:       qt6-qtimageformats%{?_isa}
Requires:       webkitgtk6.0%{?_isa}

Conflicts:      telegram-desktop%{?_isa}

# Short alias for the main package...
Provides:       telegram = %{?epoch:%{epoch}:}%{version}-%{release}
Provides:       telegram%{?_isa} = %{?epoch:%{epoch}:}%{version}-%{release}

# Virtual provides for bundled libraries...
Provides:       bundled(cld3) = 3.0.13~gitb48dc46
Provides:       bundled(kf5-kcoreaddons) = 5.106.0
Provides:       bundled(libtgvoip) = 2.4.4~git7c46f4c
Provides:       bundled(open-sans-fonts) = 1.10
Provides:       bundled(plasma-wayland-protocols) = 1.6.0
Provides:       bundled(rlottie) = 0~git8c69fc2
Provides:       bundled(vazirmatn-fonts) = 27.2.2
Provides:       bundled(cppgir) = 0~git69ef481c
Provides:       bundled(minizip) = 1.2.13

%description
Telegram is a messaging app with a focus on speed and security, it’s super
fast, simple and free. You can use Telegram on all your devices at the same
time — your messages sync seamlessly across any number of your phones,
tablets or computers.

With Telegram, you can send messages, photos, videos and files of any type
(doc, zip, mp3, etc), as well as create groups for up to 50,000 people or
channels for broadcasting to unlimited audiences. You can write to your
phone contacts and find people by their usernames. As a result, Telegram is
like SMS and email combined — and can take care of all your personal or
business messaging needs.

%prep
# Unpacking Telegram Desktop source archive...
%autosetup -p1

tar -xaf %{SOURCE1}
mv td-%{tde2e_commit} build-tde2e

# Unbundling libraries... except minizip
# hime and nimf is another input method, we don't need it.
rm -rf Telegram/ThirdParty/{GSL,QR,dispatch,expected,fcitx-qt5,fcitx5-qt,hime,hunspell,kimageformats,kcoreaddons,lz4,nimf,range-v3,xxHash}


# Fix minizip requrement
# sed -i 's|2.0.0|4.0.0|' cmake/external/minizip/CMakeLists.txt

%if 0%{?fedora} >= 41
sed -i "/#include <openssl\/engine.h>/d" Telegram/SourceFiles/core/utils.cpp
%endif

sed -i '/^TryExec=/ s/Telegram/\/usr\/bin\/Telegram/g; /^Exec=/ s/Telegram/\/usr\/bin\/Telegram/g' lib/xdg/io.github.tdesktop_x64.TDesktop.desktop
sed -i 's/telegram-desktop/Telegram/' lib/xdg/io.github.tdesktop_x64.TDesktop.metainfo.xml
sed -i '/<mediatype>x-scheme-handler\/tg<\/mediatype>/a \        <mediatype>x-scheme-handler/tonsite</mediatype>' lib/xdg/io.github.tdesktop_x64.TDesktop.metainfo.xml

%build
%__cmake -S build-tde2e -B build-tde2e/build \
    -DCMAKE_INSTALL_PREFIX="$PWD/build-tde2e/install" \
    -Wno-dev \
    -DTD_E2E_ONLY=ON

%__cmake --build build-tde2e/build
%__cmake --install build-tde2e/build


# Building Telegram Desktop using cmake...
%cmake -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_AR=%{_bindir}/gcc-ar \
    -DCMAKE_RANLIB=%{_bindir}/gcc-ranlib \
    -DCMAKE_NM=%{_bindir}/gcc-nm \
    -DTDESKTOP_API_ID=611335 \
    -DTDESKTOP_API_HASH=d524b414d21f4d37f08684c1df41ac9c \
    -DDESKTOP_APP_USE_PACKAGED:BOOL=ON \
    -DDESKTOP_APP_USE_PACKAGED_FONTS:BOOL=OFF \
    `# This will unbundle {kimageformats, fcitx5, hime, nimf}` \
    -DDESKTOP_APP_DISABLE_QT_PLUGINS:BOOL=ON \
    -DDESKTOP_APP_DISABLE_WAYLAND_INTEGRATION:BOOL=OFF \
    -DDESKTOP_APP_DISABLE_X11_INTEGRATION:BOOL=OFF \
    -DDESKTOP_APP_DISABLE_CRASH_REPORTS:BOOL=ON \
    -Dtde2e_DIR="$PWD/build-tde2e/install/lib/cmake/tde2e"
%cmake_build

%install
%cmake_install

%check
appstream-util validate-relax --nonet %{buildroot}%{_metainfodir}/*.metainfo.xml
desktop-file-validate %{buildroot}%{_datadir}/applications/*.desktop

%files
%doc README.md changelog.txt
%license LICENSE LEGAL
%{_bindir}/Telegram
%{_datadir}/applications/*.desktop
%{_datadir}/icons/hicolor/*/apps/*.png
%{_datadir}/icons/hicolor/*/apps/*.svg
%{_datadir}/dbus-1/services/*.service
%{_metainfodir}/*.metainfo.xml
