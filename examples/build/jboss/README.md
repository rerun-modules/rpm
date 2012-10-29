# Building a JBoss RPM using Rerun rpm:build

The Rerun rpm module's build command encodes the conventional approach for building a binary package ("-bb") using rpmbuild(8). This example shows how to setup the source base to build a JBoss RPM using the rpm:build command.

Note that the example has been tested using rpmbuild version 4.8.0 (under CentOS 6.2) and version 4.4.2.3 (under CentOS 5.4).

## Setting up the source base

The idea is to capture the instructions in the [JBoss AS 7.1 Getting Started Guide](https://docs.jboss.org/author/display/AS71/Getting+Started+Guide) for setting up a standalone server configuration running as non-root user (jboss-as) using the service script included in the distribution ("jboss-as-7.1.1.Final/bin/init.d/jboss-as-standalone.sh"):

* Choose a directory that will become the "topdir" for rpmbuild. The default is "/usr/src/rpm", but this example is in "[rpm/examples/build/jboss](https://github.com/rerun-modules/rpm/tree/master/examples/build/jboss)". The rpm:build command will work wherever the package source is rooted in the source base.
* Add an RPM specification file: "[rpm/examples/build/jboss/SPECS/jboss-as.spec](https://github.com/rerun-modules/rpm/tree/master/examples/build/jboss/SPECS/jboss-as.spec)" (note that rpm:build enforces the [specification file naming convention](http://fedoraproject.org/wiki/Packaging:NamingGuidelines#Spec_file_name) outlined at Fedora).
* Add  "[rpm/examples/build/jboss/SOURCES/jboss-as-7.1.1.Final/bin/init.d/jboss-as.conf](https://github.com/rerun-modules/rpm/tree/master/examples/build/jboss/SOURCES/jboss-as-7.1.1.Final/bin/init.d/jboss-as.conf)" to override the version in the distribution setting JBOSS_USER to jboss-as to enable non-root execution. (Note that this approach can be used in general to override files included in the distribution or add new files to be included in the RPM - e.g. JDBC driver jars, etc).

## Running the example

* Download the required version of JBoss to the SOURCES directory:
<pre>
[anthony@centos62-dukesbank-rerun SOURCES]$ wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip
--2012-10-26 09:32:50--  http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip
Resolving download.jboss.org... 128.241.220.89, 128.241.220.81
Connecting to download.jboss.org|128.241.220.89|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 133255203 (127M) [application/zip]
Saving to: `jboss-as-7.1.1.Final.zip'
.
.
.
2012-10-26 09:35:39 (768 KB/s) - `jboss-as-7.1.1.Final.zip' saved [133255203/133255203]
</pre>
* Build the RPM using rpm:build specifying the name, version, and top directory. (Note that the release is often set to the build or commit number too):
<pre>
[anthony@centos62-dukesbank-rerun jboss]$ rerun rpm:build -n jboss-as -v 7.1.1.Final -t $(pwd)
.
.
.
Wrote: /home/anthony/src/rerun-modules/modules/rpm/examples/build/jboss/RPMS/noarch/jboss-as-7.1.1.Final-1.noarch.rpm
.
.
.
</pre>
* Check the built package:
<pre>
[anthony@centos62-dukesbank-rerun jboss]$ rpm -qi -p RPMS/noarch/jboss-as-7.1.1.Final-1.noarch.rpm
Name        : jboss-as                     Relocations: (not relocatable)
Version     : 7.1.1.Final                       Vendor: (none)
Release     : 1                             Build Date: Fri Oct 26 10:37:02 2012
Install Date: (not installed)               Build Host: localhost
Group       : Applications/System           Source RPM: jboss-as-7.1.1.Final-1.src.rpm
Size        : 161244427                        License: LGPL
Signature   : (none)
Summary     : JBoss Application Server
Description :
JBoss Application Server
[anthony@centos62-dukesbank-rerun jboss]$ rpm -qlv -p RPMS/noarch/jboss-as-7.1.1.Final-1.noarch.rpm | more
-rwxr-xr-x    1 root    root                     3681 Oct 26 10:36 /etc/init.d/jboss-as
drwxr-xr-x    2 jboss-asjboss-as                    0 Oct 26 10:36 /etc/jboss-as
-rw-r--r--    1 jboss-asjboss-as                  367 Oct 26 10:36 /etc/jboss-as/jboss-as.conf
drwxr-xr-x    2 jboss-asjboss-as                    0 Oct 26 10:36 /usr/share/jboss-as
-rw-r--r--    1 jboss-asjboss-as                26530 Mar 10  2012 /usr/share/jboss-as/LICENSE.txt
-rw-r--r--    1 jboss-asjboss-as                 2421 Mar 10  2012 /usr/share/jboss-as/README.txt
.
.
.
</pre>

## Testing the example

* Install the RPM:
<pre>
[root@centos62-dukesbank-rerun ~]# rpm -i  /home/anthony/src/rerun-modules/modules/rpm/examples/build/jboss/RPMS/noarch/jboss-as-7.1.1.Final-1.noarch.rpm
Locking password for user jboss-as.
passwd: Success
</pre>
* Check the system service configuration:
<pre>
[root@centos62-dukesbank-rerun ~]# chkconfig --list jboss-as
jboss-as        0:off   1:off   2:off   3:on    4:on    5:on    6:off
</pre>
* Start JBoss AS and check that it's running:
<pre>
[root@centos62-dukesbank-rerun ~]# service jboss-as start
Starting jboss-as:                                         [  OK  ]
[root@centos62-dukesbank-rerun ~]# service jboss-as status
jboss-as is running (pid 44619)
</pre>
* Check the console log:
<pre>
[root@centos62-dukesbank-rerun ~]# cat /var/log/jboss-as/console.log
.
.
.
10:59:25,715 INFO  [org.apache.coyote.http11.Http11Protocol] (MSC service thread 1-1) Starting Coyote HTTP/1.1 on http--127.0.0.1-8080
10:59:25,735 INFO  [org.jboss.as.mail.extension] (MSC service thread 1-2) JBAS015400: Bound mail session [java:jboss/mail/Default]
10:59:26,654 INFO  [org.jboss.as.remoting] (MSC service thread 1-2) JBAS017100: Listening on /127.0.0.1:9999
10:59:26,741 INFO  [org.jboss.as.server.deployment.scanner] (MSC service thread 1-2) JBAS015012: Started FileSystemDeploymentService for directory /usr/share/jboss-as/standalone/deployments
10:59:26,799 INFO  [org.jboss.as.remoting] (MSC service thread 1-2) JBAS017100: Listening on /127.0.0.1:4447
10:59:27,028 INFO  [org.jboss.as.connector.subsystems.datasources] (MSC service thread 1-2) JBAS010400: Bound data source [java:jboss/datasources/ExampleDS]
10:59:27,071 INFO  [org.jboss.as] (Controller Boot Thread) JBAS015951: Admin console listening on http://127.0.0.1:9990
10:59:27,072 INFO  [org.jboss.as] (Controller Boot Thread) JBAS015874: JBoss AS 7.1.1.Final "Brontes" started in 8586ms - Started 133 of 208 services (74 services are passive or on-demand)
</pre>
* JBoss is available at http://localhost:8080 and at any other interface enabled on the system (firewalls allowing!):
<pre>
[root@centos62-dukesbank-rerun ~]# telnet localhost 8080
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
^]
telnet> Connection closed.
</pre>
* The example sets the admin user's password to "admin123".
