%global __strip /bin/true
Name:           unityhub-repackage
Version:        3.11.1
Release:        1%{?dist}
Summary:        Re-packaged Unityhub

License:        Custom
URL:            https://github.com/Unity-Technologies/unity-hub#readme
Source0:        https://hub-dist.unity3d.com/artifactory/hub-rpm-prod-local/unity/stable/unityhub_x86_64/unityhub-x86_64-%{version}.rpm
Source1:        license.txt
Source2:        unitysha1fix.config

BuildRequires:  patchelf
# It is needed by unity2018 and newer.
Requires:       GConf2
Conflicts:      unityhub

%description
Re-packaged unity for personal use.

%package debuginfo
Summary: Debug information for package %{name}
Group: Development/Debug
AutoReq: 0
AutoProv: 1
%description debuginfo
This package provides debug information for package %{name}.
Debug information is useful when developing applications that use this
package or when debugging this package.


%prep
mkdir %{name}-%{version}
cd %{name}-%{version}
rpm2cpio %{S:0} | cpio -div --no-absolute-filenames


%build
cd %{name}-%{version}
sed "6i export OPENSSL_CONF=/opt/unityhub/unitysha1fix.config" opt/unityhub/unityhub > tmp && mv tmp opt/unityhub/unityhub
chmod +x opt/unityhub/unityhub
# RPM will complain, but unityhub still works fine even if it's not found.
patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so.1 opt/unityhub/UnityLicensingClient_V1/libcoreclrtraceptprovider.so


%install
cp -a %{name}-%{version}/* %{buildroot}
cd %{name}-%{version}
install -Dm644 %{S:1} %{buildroot}%{_licensedir}/unityhub/License.txt
install -Dm644 %{S:2} %{buildroot}/opt/unityhub/unitysha1fix.config
mv %{buildroot}/opt/unityhub/LICENSE.electron.txt %{buildroot}%{_licensedir}/unityhub
mv %{buildroot}/opt/unityhub/LICENSES.chromium.html %{buildroot}%{_licensedir}/unityhub

%preun
/usr/sbin/alternatives --remove unityhub %{_bindir}/unityhub || :

%posttrans
/usr/sbin/alternatives --install %{_bindir}/unityhub unityhub /opt/unityhub/unityhub 100 || :

%files
%license %{_licensedir}/unityhub/License.txt
%license %{_licensedir}/unityhub/LICENSE.electron.txt
%license %{_licensedir}/unityhub/LICENSES.chromium.html
/opt/unityhub/*
%{_datadir}/applications/unityhub.desktop
%{_datadir}/icons/hicolor/*/apps/unityhub.png

%files debuginfo
%{_prefix}/lib/.build-id/*
