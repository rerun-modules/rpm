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

it_runs_without_arguments() {
    rerun rpm:build
}
