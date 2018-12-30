#!/usr/bin/env bash
export PROGRAM="$(cat solve.sh | sed -e '/^\s*\#/ d' | tr '\n' ';' | sed -e 's/;;\+/;/g' )" ; cat input | parallel gawk -e "$PROGRAM"
