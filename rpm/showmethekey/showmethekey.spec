%global forgeurl https://github.com/AlynxZhou/showmethekey
Name:           showmethekey
Version:        1.18.4
Release:        1%{?dist}
Summary:        Show keys you typed on screen.
%forgemeta
License:        Apache-2.0
URL:            https://showmethekey.alynx.one/
Source0:        %{forgesource}

BuildRequires:  meson
BuildRequires:  gcc
BuildRequires:  gettext

BuildRequires:  pkgconfig(gtk4)
BuildRequires:  pkgconfig(libadwaita-1)
BuildRequires:  pkgconfig(x11)
BuildRequires:  pkgconfig(glib-2.0)
BuildRequires:  pkgconfig(json-glib-1.0)
BuildRequires:  pkgconfig(gio-2.0)
BuildRequires:  pkgconfig(cairo)
BuildRequires:  pkgconfig(pango)
BuildRequires:  pkgconfig(xkbcommon)
BuildRequires:  pkgconfig(xkbregistry)
BuildRequires:  pkgconfig(libevdev)
BuildRequires:  pkgconfig(libudev)
BuildRequires:  pkgconfig(libinput)

Requires:       polkit

%description
Show keys you typed on screen, so your audiences can see what you do clearly while you are streaming or recording.

This is a screenkey alternative, and works not only on X11 but also Wayland.

Your desktop must support composition and you may need to set "always on top" and "show on all workspaces" manually so be sure your desktop supports them.


%prep
%autosetup -p1


%build
%meson
%meson_build


%install
%meson_install
%find_lang %{name}


%files -f %{name}.lang
%license LICENSE
%doc README.md
%{_bindir}/showmethekey-gtk
%{_bindir}/showmethekey-cli
%{_datadir}/applications/one.alynx.showmethekey.desktop
%{_datadir}/glib-2.0/schemas/one.alynx.showmethekey.gschema.xml
%{_datadir}/icons/hicolor/128x128/apps/one.alynx.showmethekey.png
%{_datadir}/icons/hicolor/64x64/apps/one.alynx.showmethekey.png
%{_datadir}/icons/hicolor/scalable/apps/one.alynx.showmethekey.svg
%{_datadir}/locale/zh_CN/LC_MESSAGES/showmethekey.mo
%{_datadir}/metainfo/one.alynx.showmethekey.metainfo.xml
%{_datadir}/polkit-1/actions/one.alynx.showmethekey.policy
%{_datadir}/polkit-1/rules.d/one.alynx.showmethekey.rules
