# The spec file and related content for this software are forked from Fedora Dist-Git
# Source: https://src.fedoraproject.org/rpms/wayfire-config-manager

%global forgeurl https://github.com/WayfireWM/wcm

Name:           wayfire-config-manager
Version:        0.10.0
Epoch:          1
%forgemeta
Release:        %autorelease
Summary:        Wayfire Config Manager

License:        MIT
URL:            %{forgeurl}
Source0:        %{forgesource}

BuildRequires:  desktop-file-utils
BuildRequires:  gcc-c++
BuildRequires:  glm-devel
BuildRequires:  meson

BuildRequires:  pkgconfig(gtk+-3.0)
BuildRequires:  pkgconfig(gtkmm-3.0)
BuildRequires:  pkgconfig(libxml-2.0)
BuildRequires:  pkgconfig(wayfire)
BuildRequires:  pkgconfig(wayland-protocols)
BuildRequires:  pkgconfig(wf-config) >= 0.10.0
BuildRequires:  pkgconfig(wf-shell) >= 0.10.0

Requires:       hicolor-icon-theme
Requires:       wdisplays

Provides:       wcm = %{epoch}:%{version}-%{release}
Provides:       wcm%{?_isa} = %{epoch}:%{version}-%{release}


%description
%{summary}.


%prep
%forgeautosetup -p1


%build
%meson
%meson_build


%install
%meson_install


%check
desktop-file-validate %{buildroot}%{_datadir}/applications/*.desktop


%files
%license LICENSE
%{_bindir}/wcm
%{_datadir}/applications/*.desktop
%{_datadir}/icons/wcm.svg
%{_datadir}/wcm/
