@include "../utils.awk"
@include "./hash.awk"
BEGIN {
    size = 256
    FS=","
    OFS=""
}
{   
    data[NR]=$0
    for (i=1;i<=NF;i++){
        revs[NR][i]=$i
    }
}

function print_list(list, i){
    for(i=1;i<=length(list);i++){
        printf "%d", ord(substr(list,i,1))
    }
    print ""
}
END {
    list=""
    for(i=0;i<256;i++){
        list = list chr(i)
    }
    size=256
    l = length(revs[2])
    revs[2][l+1]=17
    revs[2][l+2]=31
    revs[2][l+3]=73
    revs[2][l+4]=47
    revs[2][l+5]=23
    revs[3][1]=17
    revs[3][2]=31
    revs[3][3]=73
    revs[3][4]=47
    revs[3][5]=23
    skip = 0
    cur = 0
    #print(list)
    skip=0
    cur=0
    v = hash(substr(list,1,5),revs[1])
    #print_list(v)
    skip=0
    cur=0
    v = hash(list,revs[2])
    #print_list(v)


    loadstr("",rev)
    v = hash64(list,rev)
    compact(v,thehash)
    printh(thehash)

    loadstr("AoC 2017",rev)
    v = hash64(list,rev)
    compact(v,thehash)
    printh(thehash)

    loadstr("1,2,3",rev)
    v = hash64(list,rev)
    compact(v,thehash)
    printh(thehash)

    loadstr("1,2,4",rev)
    v = hash64(list,rev)
    compact(v,thehash)
    printh(thehash)

    loadstr("225,171,131,2,35,5,0,13,1,246,54,97,255,98,254,110",rev)
    v = hash64(list,rev)
    compact(v,thehash)
    printh(thehash)
}
