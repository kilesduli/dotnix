%global forgeurl      https://github.com/ahrm/sioyek
%global commit        a0650b5a71c15692c4797fec2908cc55c5aafd12
%global shortcommit   %(c=%{commit}; echo ${c:0:7})
%global gitdate       20260327
%global sioyekversion 2.0.0


Name:           sioyek
Version:        %{sioyekversion}^%{gitdate}git%{shortcommit}
Release:        %autorelease
Summary:        Sioyek is a PDF viewer with a focus on textbooks and research papers.

%forgemeta
License:        GPL-3.0-or-later 
URL:            %{forgeurl}
Source0:        %{forgesource}
Patch:          0001-wayland-tmp-fix.patch 

BuildRequires:  freetype-devel
BuildRequires:  gumbo-parser-devel
BuildRequires:  harfbuzz-devel
BuildRequires:  jbig2dec-devel
BuildRequires:  libjpeg-devel
BuildRequires:  mujs-devel
BuildRequires:  mupdf-devel
BuildRequires:  openjpeg-devel
BuildRequires:  zlib-ng-devel
BuildRequires:  cmake(Qt6Core)
BuildRequires:  cmake(Qt6Gui)
BuildRequires:  cmake(Qt6Network)
BuildRequires:  cmake(Qt6OpenGL)
BuildRequires:  cmake(Qt6OpenGLWidgets)
BuildRequires:  cmake(Qt6QuickWidgets)
BuildRequires:  cmake(Qt6Svg)
BuildRequires:  cmake(Qt6TextToSpeech)
BuildRequires:  cmake(Qt6WaylandClient)
BuildRequires:  cmake(Qt6Widgets)

%description
%{summary}


%prep
%forgeautosetup -p1
sed -i 's/-lmupdf-third//' pdf_viewer_build_config.pro


%build
%qmake_qt6_wrapper "PREFIX+=%{buildroot}/usr" pdf_viewer_build_config.pro
%make_build


%install
%make_install
install -Dpm0644 LICENSE %{buildroot}%{_datadir}/licenses/%{name}/LICENSE
install -Dpm0644 resources/sioyek.1 %{buildroot}%{_mandir}/man1/sioyek.1

rm -rf %{buildroot}/usr/etc
install -d %{buildroot}%{_sysconfdir}/sioyek
install -pm0644 pdf_viewer/keys.config  %{buildroot}%{_sysconfdir}/sioyek/keys.config
install -pm0644 pdf_viewer/prefs.config %{buildroot}%{_sysconfdir}/sioyek/prefs.config


%files
%license %{_datadir}/licenses/%{name}/LICENSE
%{_bindir}/sioyek
%{_datadir}/pixmaps/sioyek-icon-linux.png
%{_datadir}/applications/%{name}.desktop
%{_datadir}/%{name}/shaders/*
%{_datadir}/%{name}/tutorial.pdf
%{_mandir}/man1/sioyek.1*
%config(noreplace) %{_sysconfdir}/sioyek/keys.config
%config(noreplace) %{_sysconfdir}/sioyek/prefs.config



%changelog
* Sat May 02 2026 duli <duli4868@gmail.com>
- 
