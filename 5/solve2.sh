#!/bin/sh
# Trick to allow this file to be self contained as a polyglot shell and awk script
true = 0 # Remove warnings
true + /; exec -a "$0" gawk --lint -f "$0" -- "$@"; / { }

# BEGIN rule(s)
@include "../color.awk"

function alen(a, i, k) {
    k = 0
    for(i in a) k++
    return k
}
# Recursive function, keeps reacting the types
function go(value, leng       ,str,i,prev,prevI,output){
    orig_length = leng #alen(value)
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
function rewind(    i)
{
    # shift remaining arguments up
    for (i = ARGC; i > ARGIND; i--)
        ARGV[i] = ARGV[i-1]

    # make sure gawk knows to keep going
    ARGC++

    # make current file next to get done
    ARGV[ARGIND+1] = FILENAME

    # do it
    nextfile
}
BEGIN {
    system("clear")
    system("cp input input-temp")
    FS=""
    RSS[0]="[[:upper:]][[:lower:]]|[[:lower:]][[:upper:]]"
    RSS[1]="[[:lower:]][[:upper:]]"
    RSS[2]="[[:upper:]][[:lower:]]"
    RS=RSS[state %3]
}
BEGINFILE{
    #print "beginfile"
    for (i = ARGC; i > ARGIND; i--)
        ARGV[i] = ARGV[i-1]
    ARGC++
    close("input-temp")
    ARGV[ARGIND+1] = "input-temp"

    list = "abcdefghijklmnopqrstuvwxyz"
    char = substr(list,list_i,1)
    list_i +=1
    dirty=0
    totalfile=""
}
{
    #print ""
    #print "local: " $0"-"RT
    left = substr(RT,1,1)
    right = substr(RT,2,1)
    if(RT != "" && tolower(left) == tolower(right)){
        #printf "%s", $0 > "output"
        totalfile=totalfile $0

        #print "dirty " left right " " $0
        dirty=1
    } else {
        #printf "%s%s", $0, RT > "output"
        totalfile=totalfile $0 RT
    }
}
ENDFILE {
    print totalfile > "output"
    close("output")
    close("input-temp")
    "cat output | wc -m" | getline len
    len-=1
    close("cat output | wc -m")
    if (dirty != 1){
        state+=1
        RS=RSS[state %3]
        finish+=1
    } else {
        state=0
        RS=RSS[0]
        finish = 0
    }
    if (finish >6){
        print "len: " len
        exit
    }
    dirty=0
    system("rm input-temp")
    system("cat output | rev | tr -d \"aA\" > input-temp")
    system("rm output")
    #print "end of file"
}
END{
    print "exit"
    exit
	n = asorti(result, result_s, "@val_num_asc")
    print chars[result_s[1]] " " result_s[1] " " result[result_s[1]]
}

