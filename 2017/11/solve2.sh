@include "../utils.awk"
BEGIN {
}

{
    FS="!."
    OFS="" 
    $0=$0
    print "0: " $0 "    ---- " $1
    $1=$1
    print "1: " $0

    $0=$0
    $1=$1
    FS="<[^>]*>"
    OFS=""
    $0=$0
    $1=$1
    print "2: " $0 "    -----" $1

    FS=" "
    $0=$0
    $1=$1
    print "3: " $0
    ret = recurse($0,1)
    print ret

    
}
function recurse(string,value, s, sum, arr, i, n, temp){
    #if(string=="{}") return value
    if(string=="") return 0

    sum = 0
    while(string != ""){
        print string "."
        s =substr(string,1,1)
        if(s == "{"){
            n = index(string,"}")
            print string " " n 
            rec_string = substr(string,2,n-2)
            string = substr(string,n+1,length(string)-n)
            print rec_string ". ." string "."
            exit
            sum += recurse(rec_string,value+1)
        } else if (s == ","){
            string = substr(string,2,length(string)-1)
        } else {
            print "exit"
            exit
        }
    }
    return sum
}

