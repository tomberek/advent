#!/bin/sh
# Trick to allow this file to be self contained as a polyglot shell and awk script
true = 0 # Remove warnings
true + /; exec -a "$0" gawk --lint -f "$0" -- "$@"; / { }

# BEGIN rule(s)
@include "../color.awk"

# Recursive function, keeps reacting the types
function go(value, leng       ,str,i,prev,prevI,output){
    orig_length = leng
    prev=""
    prevI=0
    value_l=leng
    for(i in value){
        # Mark matches with a *. Cleanup later
        if (value[i] != prev && tolower(value[i]) == tolower(prev) ) {
            value[i]="*"
            value[prevI]="*"
            prev="*"
            delete value[i]
            delete value[prevI]
            value_l -=2
        } else {
			prev = value[i]
		}
        prevI=i
    }
	# no more reactants
    if (orig_length == value_l ) {
        return value_l
	}
	# recurse
	return go(value,value_l)
}
BEGIN {
 value = "dabAcCaCBAcCcaDA"
 print value
 split(value,value2)
 print go(value2)
}
{
    data=$0
    split(data,data_a,"")
    g=go(data_a,length(data))
    newstr=""
    for(i in data_a){
        newstr=newstr data_a[i]
    }
    data_f=newstr
    print length(data_f)

    list = "-abcdefghijklmnopqrstuvwxyz"
    split(list,chars,"")
    for (item in chars) {
        data=newstr
        gsub(chars[item] "|" toupper(chars[item])  ,"",data)
        split(data,data_a,"")
 
        g=go(data_a,length(data))
        result[item] = g
        print chars[item] "-" result[item] " - " g
    }
	n = asorti(result, result_s, "@val_num_asc")
    print chars[result_s[1]] " " result_s[1] " " result[result_s[1]]
}
