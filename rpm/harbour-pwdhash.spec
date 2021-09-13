Name:       harbour-pwdhash

%define version_major 1
%define version_minor 1
%define version_revis 0

Summary:    PwdHash
Version:    %{version_major}.%{version_minor}.%{version_revis}
Release:    1
Group:      Qt/Qt
License:    BSD
Source0:    %{name}-%{version}.tar.bz2
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 0.0.10
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(openssl)

%description
Manage a different password for each website you use,
without the need to store them in a password manager.

%prep
%autosetup -N -n %{name}-%{version}

%build
%qmake5 DEFINES+='VERSION_MAJOR=%{version_major}' \
  DEFINES+='VERSION_MINOR=%{version_minor}' \
  DEFINES+='VERSION_REVIS=%{version_revis}' \
  DEFINES+='VERSION=\"\\\"\"%{version_major}.%{version_minor}.%{version_revis}\"\\\"\"' \
  %{name}.pro
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install
desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/%{name}/translations
