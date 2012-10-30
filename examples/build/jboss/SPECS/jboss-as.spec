Summary: JBoss Application Server

# The package name, version and release are supplied by rpm:build using rpmbuild(8)'s "--define" option:
Name: %{name}
Version: %{version}
Release: %{release} 

# Assumes the appropriate community release has been downloaded to SOURCES from jboss.org:
Source0: %{name}-%{version}.zip
 
License: LGPL
Group: Applications/System

BuildArch: noarch

# Specify minimum Java version required:
Requires: java >= 1.6
 
# Disables debug packages and stripping of binaries:
%global _enable_debug_package 0
%global debug_package %{nil}
%global __os_install_post %{nil}
 
# stop the build failing just becauses there are a few sample binaries in the distribution:
%define _binaries_in_noarch_packages_terminate_build   0

%description
JBoss Application Server
 
%prep

%setup
# Overlay the source package contents with the customized files and directories:
cp -R $RPM_SOURCE_DIR/%{name}-%{version}/* $RPM_BUILD_DIR/%{name}-%{version}

%build
 
%install
# setup the target directory hierarchy:
rm -rf %{buildroot}
install -d -m 755 %{buildroot}/usr/share/jboss-as
mv * %{buildroot}/usr/share/jboss-as

# Install the default init script included with JBoss AS for standalone server configuration:
mkdir -p %{buildroot}/etc/init.d
cp %{buildroot}/usr/share/jboss-as/bin/init.d/jboss-as-standalone.sh %{buildroot}/etc/init.d/jboss-as

# Set the JBoss AS system level configuration file:
mkdir -p %{buildroot}/etc/jboss-as
cp %{buildroot}/usr/share/jboss-as/bin/init.d/jboss-as.conf %{buildroot}/etc/jboss-as

%clean

%files
# add the files to the RPM with appropriate permissions (allowing jboss-as.conf to be modified):
%defattr(-,jboss-as,jboss-as)
%attr(755,root,root) /etc/init.d/jboss-as
%dir /etc/jboss-as
%config %verify(not size md5 mtime) /etc/jboss-as/jboss-as.conf
/usr/share/jboss-as
 
%changelog

%pre
# make sure the jboss-as user and group exist:
if id jboss-as > /dev/null 2>&1
then
  :
else
  groupadd -f jboss-as
  useradd -rd /usr/share/jboss-as -gjboss-as jboss-as
  passwd -l jboss-as
fi

%post
# setup jboss-as as a system service:
chkconfig --add jboss-as
chkconfig --level 345 jboss-as on

%preun
service jboss-as stop
