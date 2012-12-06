#!/usr/bin/env roundup
#
# This file contains the test plan for the `get-distribution-release-version` command.
#    
#/ usage:  rerun stubbs:test -m rpm -p get-distribution-release-version [--answers <>]
#

# Helpers
#
[[ -f ./functions.sh ]] && . ./functions.sh

# The Plan
# --------

describe "get-distribution-release-version"


# ------------------------------
# Replace this test. 
it_works_without_arguments() {
  rerun rpm:get-distribution-release-version
}
# ------------------------------

