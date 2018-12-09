@include "../utils.awk"
#@include "../bitmap.awk"
BEGIN {
    print "hi"
    FS=""
    OFS=""
}
# For every line
{
    items=NF
    for(i=1; i<=items; i++){
        $(items+i)=$i
    }
    print "next line: " $0

    sum = 0
    for(i=1; i<=items; i++){
        if ($i == $(i+items/2)) {
            print "match:" $i
            sum += $i
        }
    }
    print "sum: " sum
}
END {
    print "done"
}

