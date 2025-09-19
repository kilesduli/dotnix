%global forgeurl https://github.com/WayfireWM/wayfire-plugins-extra

Name:           wayfire-plugins-extra
Version:        0.10.0
Release:        1%{?dist}
%forgemeta
Summary:        Additional plugins for Wayfire

License:        MIT
URL:            %{forgeurl}
Source0:        %{forgesource}

BuildRequires:  desktop-file-utils
BuildRequires:  gcc-c++
BuildRequires:  glm-devel
BuildRequires:  meson
BuildRequires:  vulkan-headers
BuildRequires:  boost-devel

BuildRequires:  pkgconfig(wayfire)
BuildRequires:  pkgconfig(wayland-protocols)
BuildRequires:  pkgconfig(cairo)
BuildRequires:  pkgconfig(glibmm-2.4)
BuildRequires:  pkgconfig(librsvg-2.0)

Requires:       iio-sensor-proxy


%description
Additional plugins for Wayfire


%prep
%forgeautosetup -p1


%build
%meson
%meson_build


%install
%meson_install

%files
%{_libdir}/wayfire/libannotate.so
%{_libdir}/wayfire/libautorotate-iio.so
%{_libdir}/wayfire/libbench.so
%{_libdir}/wayfire/libcrosshair.so
%{_libdir}/wayfire/libextra-animations.so
%{_libdir}/wayfire/libfocus-change.so
%{_libdir}/wayfire/libfocus-steal-prevent.so
%{_libdir}/wayfire/libfollow-focus.so
%{_libdir}/wayfire/libforce-fullscreen.so
%{_libdir}/wayfire/libghost.so
%{_libdir}/wayfire/libglib-main-loop.so
%{_libdir}/wayfire/libhide-cursor.so
%{_libdir}/wayfire/libjoin-views.so
%{_libdir}/wayfire/libkeycolor.so
%{_libdir}/wayfire/libmag.so
%{_libdir}/wayfire/libobs.so
%{_libdir}/wayfire/libpin-view.so
%{_libdir}/wayfire/libshowrepaint.so
%{_libdir}/wayfire/libshowtouch.so
%{_libdir}/wayfire/libview-shot.so
%{_libdir}/wayfire/libwater.so
%{_libdir}/wayfire/libwinzoom.so
%{_libdir}/wayfire/libworkspace-names.so
%{_datadir}/wayfire/metadata/*.xml
