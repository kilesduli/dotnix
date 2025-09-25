Name:           chrome-flags-wrapper
Version:        1.0.0
Release:        1%{?dist}
Summary:        Just a chrome flags wrapper
BuildArch:      noarch

License:        MIT
URL:            https://github.com/kilesduli/dotnix
Source0:        chrome-flags-wrapper.sh

Requires:       bash
Requires:       grep

%description
%{summary}

%install
install -Dm755 %{S:0} %{buildroot}%{_libexecdir}/chrome-flags-wrapper.sh

%preun
chromes=(
    "google-chrome-stable"
    "google-chrome-unstable"
    "google-chrome-beta"
    "google-chrome-canary"
)

for chrome in "${chromes[@]}"; do
    /usr/sbin/alternatives --remove-all $chrome || :

    if [ -e "/opt/google/${chrome#google-}" ]; then
        ln -s /opt/google/${chrome#google-}/$chrome /usr/bin/$chrome || :
    fi
done

# There is no chrome-stable
if [ -e "/opt/google/chrome/google-chrome" ]; then
    ln -s /opt/google/chrome/google-chrome /usr/bin/google-chrome-stable || :
fi


%posttrans
chromes=(
    "google-chrome-stable"
    "google-chrome-unstable"
    "google-chrome-beta"
    "google-chrome-canary"
)
for chrome in "${chromes[@]}"; do
    if [ -e "/opt/google/${chrome#google-}" ]; then
        /usr/sbin/alternatives --install /usr/bin/$chrome $chrome /opt/google/${chrome#google-}/$chrome 100 || :
        /usr/sbin/alternatives --install /usr/bin/$chrome $chrome %{_libexecdir}/chrome-flags-wrapper.sh 200 || :
    fi

    if [ $chrome = "google-chrome-stable" ]; then
        /usr/sbin/alternatives --install /usr/bin/$chrome $chrome /opt/google/chrome/google-chrome 100 || :
        /usr/sbin/alternatives --install /usr/bin/$chrome $chrome %{_libexecdir}/chrome-flags-wrapper.sh 200 || :
    fi
done

%files
%{_libexecdir}/chrome-flags-wrapper.sh
