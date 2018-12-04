#!/bin/sh
# Trick to allow this file to be self contained as a polyglot shell and awk script
true + /; exec -a "$0" gawk -f "$0" -- "$@"; / {}
#
function hamming(a,b){
    split(a,aa,"")
    split(b,bb,"")
    count=0
    for (i in aa){
        if (aa[i] != bb[i]){
            count+=1
        }
    }
    return count
}
BEGIN{
    cmd="cat data1"

    arr["12345678901234567890123456"]=26
    while ((cmd | getline) > 0) {
        arr[$_]=26
    }
    for (line in arr) {
        for (t in arr){
            res[t]=hamming(line,t)
        }
        min=27
        for (t in res){
            if (res[t] < min && res[t] > 0){
                min=res[t]
                out=t
            }
        }
        arr[line]=min
        delete res
    }
    min=2
    for (t in arr){
        if (arr[t] < min) {
            print arr[t], " ", t
        }

    }
    print "exit"
    close(cmd)
    exit
}
