#!/bin/sh
# Trick to allow this file to be self contained as a polyglot shell and awk script
true + /; exec -a "$0" gawk -f "$0" -- "$@"; / {}
#
BEGIN{
    cmd="cat data"
    while (1) {
        while ((cmd | getline) > 0) {
            sum+=$1
            arr[sum]++
            print $0
            if(arr[sum]>1) {
                print "first repeated sum= ", sum ; exit 
            }
        }
        close(cmd) 
    }
}
