#!/usr/bin/env bash
#
#/ command: rpm:build: "Build an RPM using rpmbuild(8) with a conventional directory layout"
#
#/ usage: rerun rpm:build [ --arch|-a <noarch>]  --name|-n <>  --release|-r <> [ --topdir|-t </usr/src/rpm>]  --version|-v <> 
#
#/ variables: NAME RELEASE TOPDIR VERSION

# Read module function library.
source $RERUN_MODULES/rpm/lib/functions.sh || { echo "Failed loading function library" >&2 ; exit 1 ; }

# Parse the command options.
[ -r $RERUN_MODULES/rpm/commands/build/options.sh ] && {
  source $RERUN_MODULES/rpm/commands/build/options.sh || exit 2 ;
}

# Exit immediately upon non-zero exit. See [set](http://ss64.com/bash/set.html)
set -e

#
# Change to the specified build area:
#
cd ${TOPDIR}

#
# Expand the SPEC file template:
#
if [[ -r SPECS/${NAME}-${VERSION}.spec.template ]]
then
  /bin/rm -f 
  /bin/sed -e "s/\${NAME}/${NAME}/g" -e "s/\${VERSION}/${VERSION}/g" -e "s/\${RELEASE}/${RELEASE}/g" < SPECS/${NAME}-${VERSION}.spec.template > SPECS/${NAME}-${VERSION}.spec
else
  echo "\"${TOPDIR}/SPECS/${NAME}-${VERSION}.spec.template\" not found."
  exit 1
fi

#
# Build the binary RPM package:
#
/usr/bin/rpmbuild --define "_topdir $(pwd)" -bb SPECS/${NAME}-${VERSION}.spec

exit $?

# Done
