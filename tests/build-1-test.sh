#!/usr/bin/env roundup
#
# This file contains test scripts to run for the build command.
# Execute it by invoking: 
#    
#     rerun stubbs:test -m rpm -c build
#

# Helpers
# ------------

rerun() {
    command $RERUN -M $RERUN_MODULES "$@"
}

# The Plan
# --------

describe "build"

it_can_build_the_jboss_example() {
   # make sure the distribution is available:
   if [[ -e $RERUN_MODULES/rpm/examples/build/jboss/SOURCES/jboss-as-7.1.1.Final.zip ]]
   then
      echo "\"rpm/examples/build/jboss/SOURCES/jboss-as-7.1.1.Final.zip\" has already been downloaded"
   else
      echo "Downloading \"rpm/examples/build/jboss/SOURCES/jboss-as-7.1.1.Final.zip\" from jboss.org ..."
      cd $RERUN_MODULES/rpm/examples/build/jboss/SOURCES
      wget -qO $RERUN_MODULES/rpm/examples/build/jboss/SOURCES/jboss-as-7.1.1.Final.zip http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip
   fi

   # build the package:
   rerun rpm:build -n jboss-as -v 7.1.1.Final -t $RERUN_MODULES/rpm/examples/build/jboss

   # check the package:
   rpm -qi -p $RERUN_MODULES/rpm/examples/build/jboss/RPMS/noarch/jboss-as-7.1.1.Final-1.noarch.rpm
   rpm -qlv -p $RERUN_MODULES/rpm/examples/build/jboss/RPMS/noarch/jboss-as-7.1.1.Final-1.noarch.rpm
   rpm -q --requires -p $RERUN_MODULES/rpm/examples/build/jboss/RPMS/noarch/jboss-as-7.1.1.Final-1.noarch.rpm
}
