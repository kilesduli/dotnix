Name:           chrome-flags-wrapper
Version:        3.0.0
Release:        1%{?dist}
Summary:        Just a chrome flags wrapper
BuildArch:      noarch

License:        MIT
URL:            https://github.com/kilesduli/dotnix
Source0:        chrome-flags-wrapper.sh

Requires:       bash
Requires:       grep
Requires:       alternatives

%description
%{summary}

%install
install -Dm755 %{S:0} %{buildroot}%{_libexecdir}/chrome-flags-wrapper.sh


%dnl When flags-wrapper upgrading and installing, %triggerin always executed.

%triggerin -- google-chrome-stable
if [ -e "/opt/google/chrome" ]; then
    /usr/sbin/alternatives --install /usr/bin/google-chrome-stable google-chrome-stable /opt/google/chrome/google-chrome 100 || :
    /usr/sbin/alternatives --install /usr/bin/google-chrome-stable google-chrome-stable %{_libexecdir}/chrome-flags-wrapper.sh 200 || :
fi

%triggerin -- google-chrome-unstable
chrome="google-chrome-unstable"
if [ -e "/opt/google/${chrome#google-}" ]; then
    /usr/sbin/alternatives --install /usr/bin/$chrome $chrome /opt/google/${chrome#google-}/$chrome 100 || :
    /usr/sbin/alternatives --install /usr/bin/$chrome $chrome %{_libexecdir}/chrome-flags-wrapper.sh 200 || :
fi

%triggerin -- google-chrome-beta
chrome="google-chrome-beta"
if [ -e "/opt/google/${chrome#google-}" ]; then
    /usr/sbin/alternatives --install /usr/bin/$chrome $chrome /opt/google/${chrome#google-}/$chrome 100 || :
    /usr/sbin/alternatives --install /usr/bin/$chrome $chrome %{_libexecdir}/chrome-flags-wrapper.sh 200 || :
fi

%triggerin -- google-chrome-canary
chrome="google-chrome-canary"
if [ -e "/opt/google/${chrome#google-}" ]; then
    /usr/sbin/alternatives --install /usr/bin/$chrome $chrome /opt/google/${chrome#google-}/$chrome 100 || :
    /usr/sbin/alternatives --install /usr/bin/$chrome $chrome %{_libexecdir}/chrome-flags-wrapper.sh 200 || :
fi

%dnl [ $1 -eq 0 ] || [ $2 -eq 0 ] means the script runs if either flags-wrapper or chrome is removed.

%triggerun -- google-chrome-stable
if [ $1 -eq 0 ] || [ $2 -eq 0 ]; then
    /usr/sbin/alternatives --remove-all google-chrome-stable || :
    ln -s /opt/google/chrome/google-chrome /usr/bin/google-chrome-stable || :
fi

%triggerun -- google-chrome-unstable
chrome="google-chrome-unstable"
if [ $1 -eq 0 ] || [ $2 -eq 0 ]; then
    /usr/sbin/alternatives --remove-all $chrome || :
    ln -s /opt/google/${chrome#google-}/$chrome /usr/bin/$chrome || :
fi

%triggerun -- google-chrome-beta
chrome="google-chrome-beta"
if [ $1 -eq 0 ] || [ $2 -eq 0 ]; then
    /usr/sbin/alternatives --remove-all $chrome || :
    ln -s /opt/google/${chrome#google-}/$chrome /usr/bin/$chrome || :
fi

%triggerun -- google-chrome-canary
chrome="google-chrome-canary"
if [ $1 -eq 0 ] || [ $2 -eq 0 ]; then
    /usr/sbin/alternatives --remove-all $chrome || :
    ln -s /opt/google/${chrome#google-}/$chrome /usr/bin/$chrome || :
fi

%files
%{_libexecdir}/chrome-flags-wrapper.sh
