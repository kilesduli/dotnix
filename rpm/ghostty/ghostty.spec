%global gitdate 20250424
%global commit  4e91d11a60bf3f52a15936cef65eae7135906b28
%global shortcommit %(c=%{commit}; echo ${c:0:7})
%global ghosttyversion 1.1.4

%bcond_with ReleaseFast

%if %{with ReleaseFast}
%global debug_package %{nil}
%endif

%global _zig_release_mode %{?with_ReleaseFast:fast}%{!?with_ReleaseFast:safe}
%global _zig_system_integration %{nil}


# We must need all options same in two phares
# tips: zig doesn't recongize ^, so we replace to -
%global ghostty_build_options %{shrink: \
    -Demit-docs=true \
    -Dversion-string="%{ghosttyversion}-%{gitdate}git%{shortcommit}" \
    -Dgtk-x11=true \
    -Dgtk-wayland=true \
    -fsys=gtk4-layer-shell
}

%global package_name ghostty
Name:           %{package_name}%{?with_ReleaseFast:-fast}
Version:        %{ghosttyversion}^%{gitdate}git%{shortcommit}
Release:        5%{?dist}
Summary:        Ghostty Terminal

License:        MIT
URL:            https://ghostty.org/
Source0:        https://github.com/ghostty-org/ghostty/archive/%{commit}/%{package_name}-%{shortcommit}.tar.gz
Patch:          0001-Remove-debug-warnning-in-RelaseSafe-build.patch

BuildRequires:  blueprint-compiler
BuildRequires:  gettext
BuildRequires:  gtk4-devel
BuildRequires:  gtk4-layer-shell-devel >= 1.11.1
BuildRequires:  libadwaita-devel
BuildRequires:  pandoc
BuildRequires:  pkg-config
BuildRequires:  zig
BuildRequires:  zig-rpm-macros

Conflicts:      %{package_name}%{!?with_ReleaseFast:-fast}


%description
Ghostty is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration.


%prep
%autosetup -n %{package_name}-%{commit} -p1


%build
%zig_build %{ghostty_build_options}


%install
%zig_install %{ghostty_build_options}
# ncurse-term provides it.
rm -rf %{buildroot}/%{_datadir}/terminfo/g/ghostty


%files
%license LICENSE
%doc %{_datadir}/ghostty/doc/*
%{_bindir}/ghostty
%{_datadir}/applications/com.mitchellh.ghostty.desktop
%{_datadir}/bash-completion/completions/ghostty.bash
%{_datadir}/bat/syntaxes/ghostty.sublime-syntax
%{_datadir}/fish/vendor_completions.d/ghostty.fish
%{_datadir}/ghostty/shell-integration/bash/*
%{_datadir}/ghostty/shell-integration/elvish/lib/ghostty-integration.elv
%{_datadir}/ghostty/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish
%{_datadir}/ghostty/shell-integration/zsh/.zshenv
%{_datadir}/ghostty/shell-integration/zsh/ghostty-integration
%{_datadir}/ghostty/themes/*
%{_datadir}/icons/hicolor/*/apps/com.mitchellh.ghostty.png
%{_datadir}/kio/servicemenus/com.mitchellh.ghostty.desktop
%{_datadir}/locale/*/LC_MESSAGES/com.mitchellh.ghostty.mo
%{_datadir}/man/man1/ghostty.1.gz
%{_datadir}/man/man5/ghostty.5.gz
%{_datadir}/metainfo/com.mitchellh.ghostty.metainfo.xml
%{_datadir}/nautilus-python/extensions/ghostty.py
%{_datadir}/nvim/site/*
%{_datadir}/terminfo/x/xterm-ghostty
%{_datadir}/vim/vimfiles/*
%{_datadir}/zsh/site-functions/_ghostty
