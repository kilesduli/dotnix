# The spec file and related content for this software are forked from Fedora Dist-Git
# Source: https://src.fedoraproject.org/rpms/wf-shell

%global forgeurl https://github.com/WayfireWM/wf-shell
# 'libgnome-volume-control'
# This project is only intended to be used as a subproject
%global gvc_commit      5f9768a2eac29c1ed56f1fbb449a77a3523683b6
%global gvc_shortcommit %(c=%{gvc_commit}; echo ${c:0:7})

Name:           wf-shell
Version:        0.10.0
Epoch:          1
%forgemeta
Release:        %autorelease
Summary:        GTK3-based panel for wayfire

License:        MIT
URL:            %{forgeurl}
Source0:        %{forgesource}
Source1:        https://github.com/GNOME/libgnome-volume-control/tarball/%{gvc_commit}#/gvc-%{gvc_shortcommit}.tar.gz

BuildRequires:  gcc-c++
BuildRequires:  glm-devel
BuildRequires:  meson >= 0.51.0

BuildRequires:  pkgconfig(alsa)
BuildRequires:  pkgconfig(dbusmenu-gtk3-0.4)
BuildRequires:  pkgconfig(gtk-layer-shell-0) >= 0.6
BuildRequires:  pkgconfig(gtkmm-3.0) >= 3.24
BuildRequires:  pkgconfig(libpulse)
BuildRequires:  pkgconfig(wayfire)
BuildRequires:  pkgconfig(wayland-client)
BuildRequires:  pkgconfig(wayland-protocols)
BuildRequires:  pkgconfig(wf-config) >= 0.10.0

Recommends:     wayland-logout

Requires:       hicolor-icon-theme

Provides:       bundled(gvc) = 0.git%{gvc_shortcommit}

%description
wf-shell is a repository which contains the various components needed to built a
fully functional DE based around wayfire. Currently it has only a GTK-based
panel and background client.


%package        devel
Summary:        Development files for %{name}
Requires:       %{name}%{?_isa} = %{epoch}:%{version}-%{release}

%description    devel
Development files for %{name}.


%prep
%forgeautosetup -p1
%autosetup -D -T -a1
mv GNOME-libgnome-volume-control-%{gvc_shortcommit}/* \
    %{_builddir}/%{name}-%{version}/subprojects/gvc


%build
%meson \
    -Dwayland-logout=false
%meson_build


%install
%meson_install


%files
%license LICENSE
%doc README.md %{name}.ini.example
%{_bindir}/wf-background
%{_bindir}/wf-dock
%{_bindir}/wf-panel
%{_datadir}/icons/hicolor/*/apps/*.png
%{_datadir}/icons/hicolor/scalable/apps/*.svg
%{_datadir}/wayfire/

%files devel
%{_libdir}/pkgconfig/*.pc


%changelog
%autochangelog
