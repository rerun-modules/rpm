# Building a JBoss RPM using Rerun rpm:build

The Rerun rpm module's build command encodes the conventional approach for building a binary package ("-bb") using rpmbuild(8).

This example shows how to setup the source base to build a JBoss RPM using the commmand. The idea is to capture the instructions in the [JBoss AS 7.1 Getting Started Guide](https://docs.jboss.org/author/display/AS71/Getting+Started+Guide) for setting up a standalone server configuration using the service script included in the distribution ("jboss-as-7.1.1.Final/bin/init.d/jboss-as-standalone.sh").

