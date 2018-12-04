#!/bin/sh
# Trick to allow this file to be self contained as a polyglot shell and awk script
true + /; exec -a "$0" gawk -f "$0" -- "$@"; / { }
#
function parse(a,value){
    $0=a
    sub(/\#/,"",$1)
    split($3,loc,",")
    res_x=loc[1]
    res_y=loc[2]
    sub(":","",res_y)
    split($4,loc,"x")
    s_x=loc[1]
    s_y=loc[2]
    value["claim"]=$1
    value["x"]=res_x
    value["y"]=res_y
    value["dx"]=s_x
    value["dy"]=s_y
}
function iterate(arr,value,f,g     ,i,j){
    for (i=0; i<value["dx"]; i++){
        if(g){ @g() }
        for(j=0; j<value["dy"]; j++){
            r_x=value["x"]+i
            r_y=value["y"]+j
            @f(arr,res_x,res_y,i,j,value)
        }
    }
}
function mark(arr,res_x,res_y,i,j,value){
    if(r_x in arr && r_y in arr[r_x]){
        arr[res_x+i][res_y+j]="X"
    } else {
        arr[res_x+i][res_y+j]=value["claim"]
    }
}
function search(arr,res_x,res_y,i,j,value){
    if(arr[r_x][r_y] == value["claim"]){
        printf "%s", "."
    } else {
        printf "%s", "X"
        res[value["claim"]]="X"
        res[arr[r_x][r_y]]="X"
    }
}
function print_0(){ print "" }

BEGIN{
}
/.*/{
    parse($0,value)
    storage[value["claim"]]=$0
    iterate(arr,value,"mark")
}

END{
    n = asorti(storage,sorted,"@ind_num_asc")
    for(i=1;i<=n;i++){
        parse(storage[sorted[i]],value)
        res[value["claim"]]=value["claim"]
        iterate(arr,value,"search","print_0")
        print " "
        print storage[sorted[i]]
    }
    print ""
    for(i in res){
        if(res[i] != "X"){ print "un-claimed plot: " i }
    }
    for(i in arr){
        for(j in arr[i]){
            if(arr[i][j] == "X" ){
                count+=1
            } else {
                badcount+=1
            }
        }
    }
    print "claimed spots: " count
    print "unclaimed spots: " badcount
    close(cmd)
    exit
}
