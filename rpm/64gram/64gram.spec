# This file is encoded in UTF-8.  -*- coding: utf-8 -*-
# The spec file and related content for this software are forked from rpmfusion.
# Source: https://github.com/rpmfusion/telegram-desktop/blob/master/telegram-desktop.spec
%ifarch aarch64
    %global _lto_cflags %nil
%endif

%global _default_patch_fuzz 2

# Telegram Desktop's constants...
%global appname 64Gram

# Reducing debuginfo verbosity...
%global optflags %(echo %{optflags} | sed 's/-g /-g1 /')

%global tde2e_commit 6d509061574d684117f74133056aa43df89022fc
%global tde2e_shortcommit %(c=%{tde2e_commit}; echo ${c:0:7})

%global wallet_engine_tag v0.0.7
%global wallet_engine_version %(echo "%{wallet_engine_tag}" | sed 's/^v//')


Name:           64gram-desktop
Epoch:          1
Version:        1.2.13
Release:        1%{?dist}

# Application and 3rd-party modules licensing:
# * Telegram Desktop - GPL-3.0-or-later with OpenSSL exception -- main tarball;
# * cld3  - Apache-2.0 -- static dependency;
# * libprisma - MIT -- static dependency;
# * tgcalls - LGPL-3.0-only -- static dependency;
# * wayland-protocols - MIT -- static dependency;
# * rlottie - MIT -- static dependency;
# * * kuba--/zip - Unlicense
# * * miniz - MIT AND Unlicense
# * * freetype rasterizer - FTL
# * * vinterpolator.cpp (modified from mozilla/gecko-dev/dom/smil/SMILKeySpline.cpp) - MPL-1.1
# * * pixman arm neon routines - MIT
# * cmark-gfm - BSD-2-Clause AND MIT -- static dependency;
# * clatexmath - MIT -- static dependency;
# * toomanycooks - BSL-1.0 -- static dependency;
License:        GPL-3.0-or-later AND Apache-2.0 AND LGPL-3.0-only AND (MIT AND FTL AND BSD-3-Clause AND MPL-1.1 AND (MIT AND Unlicense)) AND BSD-2-Claude AND BSL-1.0
URL:            https://github.com/TDesktop-x64/tdesktop
Summary:        Unofficial Telegram Desktop providing Windows 64bit build and extra features
Source0:        %{name}-%{version}.tar.gz
Source1:        https://github.com/tdlib/td/archive/%{tde2e_commit}/td-%{tde2e_shortcommit}.tar.gz
Source2:        https://github.com/i582/wallet-engine/archive/%{wallet_engine_tag}.tar.gz#/wallet-engine-%{wallet_engine_version}.tar.gz
Source3:        wallet-vendor.tar.gz
Source4:        wallet-bindgen-vendor.tar.gz

Patch:          0001-feat-disable-sponsored-messages.patch
Patch:          0002-feat-disable-saving-restrictions.patch
Patch:          0003-feat-disable-invite-peeking-restrictions.patch

# use mochaa tg_owt instead of rpmfusion, so we need this patch to fix build
Patch:          https://codeberg.org/mochaa-rpms/64gram/raw/branch/rawhide/64Gram/1000-tgcalls-fix-libyuv-include.patch
Patch:          https://codeberg.org/mochaa-rpms/64gram/raw/branch/rawhide/64Gram/1000-tdesktop-unbundle-public-dbus-interfaces.patch
Patch:          https://codeberg.org/mochaa-rpms/64gram/raw/branch/rawhide/64Gram/1000-tde2e-use-tdlib.patch
Patch:          https://codeberg.org/mochaa-rpms/64gram/raw/branch/rawhide/64Gram/1000-lib_tl-fix-cstring-include.patch

# wallet_engine
Patch1001:      https://raw.githubusercontent.com/desktop-app/patches/refs/heads/master/wallet-engine.patch

Source600:      source-tarball.sh
Source601:      wallet-vendor.sh

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
BuildRequires:  pkgconfig(libfido2)
BuildRequires:  pkgconfig(libjpeg)
BuildRequires:  pkgconfig(liblz4)
BuildRequires:  pkgconfig(liblzma)
BuildRequires:  pkgconfig(libpulse)
BuildRequires:  pkgconfig(libswresample)
BuildRequires:  pkgconfig(libswscale)
BuildRequires:  pkgconfig(libxxhash)
BuildRequires:  pkgconfig(minizip)
%if 0%{?fedora} < 41
BuildRequires:  pkgconfig(openssl)
%endif
BuildRequires:  pkgconfig(opus)
BuildRequires:  pkgconfig(protobuf)
BuildRequires:  pkgconfig(protobuf-lite)
BuildRequires:  pkgconfig(rnnoise)
BuildRequires:  pkgconfig(tlottie)
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
BuildRequires:  libqrcodegencpp-devel
BuildRequires:  libstdc++-devel
BuildRequires:  minizip-compat-devel
BuildRequires:  ninja-build
BuildRequires:  python3
BuildRequires:  qt6-qtbase-private-devel
BuildRequires:  qt6-qtbase-static
BuildRequires:  pkgconfig(openh264)
BuildRequires:  xdg-desktop-portal
BuildRequires:  flatpak
BuildRequires:  cargo-rpm-macros


Requires:       hicolor-icon-theme
Requires:       qt6-qtimageformats%{?_isa}
Requires:       webkitgtk6.0%{?_isa}

Conflicts:      telegram-desktop%{?_isa}

# Short alias for the main package...
Provides:       telegram = %{?epoch:%{epoch}:}%{version}-%{release}
Provides:       telegram%{?_isa} = %{?epoch:%{epoch}:}%{version}-%{release}

%description
64gram-desktop

%prep
# Unpacking Telegram Desktop source archive...
%autosetup -N
%autopatch -p1 -M1000

tar -xaf %{S:1}
mv td-%{tde2e_commit} build-tde2e

tar -xaf %{S:2}
mv wallet-engine-%{wallet_engine_version} build-wallet_engine
%patch -d build-wallet_engine -p1 1001

mkdir -p build-wallet_engine/wallet-vendor
tar -xaf %{S:3} -C build-wallet_engine/wallet-vendor

mkdir -p build-wallet_engine/bindgen/cpp/wallet-bindgen-vendor
tar -xaf %{S:4} -C build-wallet_engine/bindgen/cpp/wallet-bindgen-vendor 

pushd build-wallet_engine
%cargo_prep -v wallet-vendor
popd

pushd build-wallet_engine/bindgen/cpp
%cargo_prep -v wallet-bindgen-vendor
popd

# Unbundling libraries... except minizip
# hime and nimf is another input method, we don't need it.
rm -rf Telegram/ThirdParty/{GSL,QR,dispatch,expected,fcitx-qt5,fcitx5-qt,hime,hunspell,kimageformats,kcoreaddons,lz4,nimf,range-v3,xxHash,xdg-desktop-portal,libfido2,libcbor}
rm Telegram/SourceFiles/platform/linux/org.freedesktop.portal.Flatpak.xml

%if 0%{?fedora} >= 41
sed -i "/#include <openssl\/engine.h>/d" Telegram/SourceFiles/core/utils.cpp
%endif

sed -i 's/set(output_name "64Gram")/set(output_name "Telegram")/g; s/STREQUAL "64Gram"/STREQUAL "Telegram"/g' Telegram/CMakeLists.txt
sed -i '/^TryExec=/ s/64Gram/\/usr\/bin\/Telegram/g; /^Exec=/ s/64Gram/\/usr\/bin\/Telegram/g' lib/xdg/io.github.tdesktop_x64.TDesktop.desktop
sed -i 's/^StartupWMClass=64Gram$/StartupWMClass=Telegram/' lib/xdg/io.github.tdesktop_x64.TDesktop.desktop
sed -i 's|<binary>telegram-desktop</binary>|<binary>Telegram</binary>|' lib/xdg/io.github.tdesktop_x64.TDesktop.metainfo.xml
sed -i 's/64Gram/Telegram/g' lib/xdg/io.github.tdesktop_x64.TDesktop.service
sed -i 's/telegram-desktop/Telegram/' lib/xdg/io.github.tdesktop_x64.TDesktop.metainfo.xml

%build
( TOPDIR=$(pwd)
  pushd build-wallet_engine
  %cargo_build
  popd

  pushd build-wallet_engine/bindgen/cpp
  %{__cargo} run %{__cargo_common_opts} --profile rpm \
      --manifest-path ./Cargo.toml -- \
      --library --out-dir $TOPDIR/build-wallet_engine/install/include/wallet_engine \
      $TOPDIR/build-wallet_engine/target/rpm/libwallet_engine.so
  popd
)


%__cmake -S build-tde2e -B build-tde2e/build \
    -DCMAKE_INSTALL_PREFIX="$PWD/build-tde2e/install" \
    -Wno-dev \
    -DTD_E2E_ONLY=ON

%__cmake --build build-tde2e/build
%__cmake --install build-tde2e/build


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
    -DTDESKTOP_DISABLE_AUTOUPDATE:BOOL=ON \
    -Dtde2e_DIR="$PWD/build-tde2e/install/lib/cmake/tde2e" \
    -DDESKTOP_APP_WALLET_ENGINE_LIBRARY="$PWD/build-wallet_engine/target/rpm/libwallet_engine.a" \
    -DDESKTOP_APP_WALLET_ENGINE_INCLUDE_DIR="$PWD/build-wallet_engine/install/include/wallet_engine"
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
