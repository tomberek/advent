@include "../utils.awk"
BEGIN {
    print "hi"
}
function anagram(a,b, i, counta, countb){
    if(length(a) != length(b)) return 0
    for(i=1;i<=length(a);i++){
        counta[substr(a,i,1)]++
        countb[substr(b,i,1)]++
    }
    if(length(countb) != length(counta)) return 0
    asorti(counta,inda)
    asorti(countb,indb)
    for(i in inda){
        if(inda[i] != inda[i]) return 0
        if(counta[inda[i]] != countb[inda[i]]) return 0
    }
    print "     " a "-" b
    return 1
}
{
    delete data
    delete words
    split($0,a," ")
    for(i in a){
        for (word in words){
            ret = anagram(words[word],a[i])
            if( ret != 0 ){
                print "invalid " $0
                next
            }
        }
        words[i]=a[i]
    }
    print "valid"
    count++
}
END {
    print "count"
    print count
}

