# Version of the .so library
# The spec file and related content for this software are forked from Fedora Dist-Git
# Source: https://src.fedoraproject.org/rpms/wlroots

%global abi_ver 0.19
# libliftoff does not bump soname on API changes
%global liftoff_ver 0.5.0

Name:           wlroots
Version:        0.19.2
Epoch:          1
Release:        2%{?dist}
Summary:        A modular Wayland compositor library

# Source files/overall project licensed as MIT, but
# - HPND-sell-variant
#   * protocol/drm.xml
#   * protocol/wlr-data-control-unstable-v1.xml
#   * protocol/wlr-foreign-toplevel-management-unstable-v1.xml
#   * protocol/wlr-gamma-control-unstable-v1.xml
#   * protocol/wlr-input-inhibitor-unstable-v1.xml
#   * protocol/wlr-layer-shell-unstable-v1.xml
#   * protocol/wlr-output-management-unstable-v1.xml
# - LGPL-2.1-or-later
#   * protocol/server-decoration.xml
# Those files are processed to C-compilable files by the
# `wayland-scanner` binary during build and don't alter
# the main license of the binaries linking with them by
# the underlying licenses.
License:        MIT
URL:            https://gitlab.freedesktop.org/wlroots/wlroots
Source0:        %{url}/-/releases/%{version}/downloads/wlroots-%{version}.tar.gz

# this file is a modification of examples/meson.build so as to:
# - make it self-contained
# - only has targets for examples known to compile well (cf. "examples) global)
Source3:        examples.meson.build

# Fedora patches
# Following patch is required for phoc.
Patch:          Revert-layer-shell-error-on-0-dimension-without-anch.patch

# Patchs from:  https://aur.archlinux.org/cgit/aur.git/tree/?h=wlroots-hidpi-xprop-git
Patch:          https://aur.archlinux.org/cgit/aur.git/plain/0001-Revert-compositor-send-WL_SURFACE_ERROR_INVALID_SIZE.patch?h=wlroots-hidpi-xprop-git#/0001-Revert-compositor-send-WL_SURFACE_ERROR_INVALID_SIZE.patch
Patch:          https://aur.archlinux.org/cgit/aur.git/plain/0001-xwayland-support-HiDPI-scale.patch?h=wlroots-hidpi-xprop-git#/0001-xwayland-support-HiDPI-scale.patch
Patch:          https://aur.archlinux.org/cgit/aur.git/plain/0002-Fix-configure_notify-event.patch?h=wlroots-hidpi-xprop-git#/0002-Fix-configure_notify-event.patch
Patch:          https://aur.archlinux.org/cgit/aur.git/plain/0003-Fix-size-hints-under-Xwayland-scaling.patch?h=wlroots-hidpi-xprop-git#/0003-Fix-size-hints-under-Xwayland-scaling.patch


BuildRequires:  gcc
BuildRequires:  glslang
BuildRequires:  gnupg2
BuildRequires:  meson >= 1.3

BuildRequires:  (pkgconfig(libdisplay-info) >= 0.1.1 with pkgconfig(libdisplay-info) < 0.3)
BuildRequires:  (pkgconfig(libliftoff) >= %{liftoff_ver} with pkgconfig(libliftoff) < 0.6)
BuildRequires:  pkgconfig(egl)
BuildRequires:  pkgconfig(gbm) >= 17.1.0
BuildRequires:  pkgconfig(glesv2)
BuildRequires:  pkgconfig(hwdata)
BuildRequires:  pkgconfig(lcms2)
BuildRequires:  pkgconfig(libdrm) >= 2.4.122
BuildRequires:  pkgconfig(libinput) >= 1.21.0
BuildRequires:  pkgconfig(libseat)
BuildRequires:  pkgconfig(libudev)
BuildRequires:  pkgconfig(pixman-1) >= 0.43.0
BuildRequires:  pkgconfig(vulkan) >= 1.2.182
BuildRequires:  pkgconfig(wayland-client)
BuildRequires:  pkgconfig(wayland-protocols) >= 1.41
BuildRequires:  pkgconfig(wayland-scanner)
BuildRequires:  pkgconfig(wayland-server) >= 1.23.1
BuildRequires:  pkgconfig(x11-xcb)
BuildRequires:  pkgconfig(xcb)
BuildRequires:  pkgconfig(xcb-composite)
BuildRequires:  pkgconfig(xcb-dri3)
BuildRequires:  pkgconfig(xcb-errors)
BuildRequires:  pkgconfig(xcb-ewmh)
BuildRequires:  pkgconfig(xcb-icccm)
BuildRequires:  pkgconfig(xcb-present)
BuildRequires:  pkgconfig(xcb-render)
BuildRequires:  pkgconfig(xcb-renderutil)
BuildRequires:  pkgconfig(xcb-res)
BuildRequires:  pkgconfig(xcb-shm)
BuildRequires:  pkgconfig(xcb-xfixes)
BuildRequires:  pkgconfig(xcb-xinput)
BuildRequires:  pkgconfig(xkbcommon)
BuildRequires:  pkgconfig(xwayland)
# libliftoff does not bump soname on API changes
Requires:       libliftoff%{?_isa} >= %{liftoff_ver}

%description
%{summary}.


%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} == %{epoch}:%{version}-%{release}
# not required per se, so not picked up automatically by RPM
Recommends:     pkgconfig(xcb-icccm)
# for examples
Suggests:       gcc
Suggests:       meson >= 0.58.0
Suggests:       pkgconfig(wayland-egl)

%description    devel
Development files for %{name}.


%prep
%global _default_patch_fuzz 2
%autosetup -N -n wlroots-%{version}
%autopatch -p1



%build
MESON_OPTIONS=(
    # Disable options requiring extra/unpackaged dependencies
    -Dexamples=false
)

%{meson} "${MESON_OPTIONS[@]}"
%{meson_build}


%install
%{meson_install}
install -pm0644 -D '%{SOURCE3}' '%{buildroot}/%{_pkgdocdir}/examples/meson.build'


%check
%{meson_test}


%files
%license LICENSE
%doc README.md
%{_libdir}/libwlroots-%{abi_ver}.so


%files  devel
%doc %{_pkgdocdir}/examples
%{_includedir}/wlroots-%{abi_ver}/wlr
%{_libdir}/pkgconfig/wlroots-%{abi_ver}.pc
