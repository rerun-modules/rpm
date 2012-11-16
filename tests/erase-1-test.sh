#!/usr/bin/env roundup
#
# This file contains the test plan for the erase command.
# Execute the plan by invoking: 
#    
#     rerun stubbs:test -m rpm -p erase
#

# The Plan
# --------

describe "erase"


it_fails_without_an_argument() {
    if ! rerun rpm:erase
    then
      exit 0
    fi
}
