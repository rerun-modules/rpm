#!/usr/bin/env roundup
#
# This file contains the test plan for the upgrade command.
# Execute the plan by invoking: 
#    
#     rerun stubbs:test -m rpm -p upgrade
#

# The Plan
# --------

describe "upgrade"


it_fails_without_arguments() {
    if ! rerun rpm:upgrade
    then
      exit 0
    fi
}

