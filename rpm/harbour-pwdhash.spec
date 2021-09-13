Name:       harbour-pwdhash

%define version_major 1
%define version_minor 1
%define version_revis 0

Summary:    pwdhash.com as an app
Version:    %{version_major}.%{version_minor}.%{version_revis}
Release:    1
Group:      Qt/Qt
License:    BSD
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-pwdhash.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 0.0.10
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)

%description
PwdHash converts a user's password into a domain-specific password.

%prep
%setup -q -n %{name}-%{version}

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

%files
%defattr(-,root,root,-)
/usr/share/harbour-pwdhash/translations
/usr/share/icons/hicolor/86x86/apps
/usr/share/applications
/usr/share/harbour-pwdhash
/usr/bin
